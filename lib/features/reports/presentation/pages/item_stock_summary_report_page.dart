import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:excel/excel.dart' as xl;
import 'package:file_picker/file_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../data/providers/inventory_report_provider.dart';
import '../../data/models/inventory_report_models.dart';
import '../../../masters/data/providers/inventory_providers.dart';
import '../../../masters/data/models/item_master_model.dart';

class ItemStockSummaryReportPage extends StatefulWidget {
  const ItemStockSummaryReportPage({super.key});

  @override
  State<ItemStockSummaryReportPage> createState() => _ItemStockSummaryReportPageState();
}

class _ItemStockSummaryReportPageState extends State<ItemStockSummaryReportPage> {
  String _groupName = '';
  String _productName = '';
  String _stockStatus = 'All';
  String _activeView = 'table'; // 'table' or 'chart'
  String _profitView = 'total'; // 'total' or 'live'
  int _resetId = 0;
  final Set<int> _expandedRows = {};

  final TextEditingController _itemSearchController = TextEditingController();
  final FocusNode _itemFocusNode = FocusNode();

  final ScrollController _verticalScroll = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ItemGroupProvider>().fetchGroups();
      context.read<ItemMasterProvider>().fetchItems();
      _handleSearch();
    });
  }

  @override
  void dispose() {
    _itemSearchController.dispose();
    _itemFocusNode.dispose();
    _verticalScroll.dispose();
    super.dispose();
  }

  void _handleSearch() {
    final filters = {
      'groupName': _groupName.isEmpty ? null : _groupName,
      'productName': _productName.isEmpty ? null : _productName,
      'stockStatus': _stockStatus == 'All' ? null : _stockStatus,
    };
    context.read<InventoryReportProvider>().fetchItemStockSummaryReport(filters);
  }

  void _handleReset() {
    setState(() {
      _groupName = '';
      _productName = '';
      _stockStatus = 'All';
      _resetId++;
      _itemSearchController.clear();
    });
    _handleSearch();
  }

  String _fmt(double? n) => NumberFormat('#,##,##0.00').format(n ?? 0);
  String _fmtInt(double? n) => NumberFormat('#,##,##0').format(n ?? 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Consumer<InventoryReportProvider>(
        builder: (context, provider, child) {
          final report = provider.itemStockSummary;
          final isLoading = provider.isLoading;

          return Column(
            children: [
              _buildGradientHeader(),
              Expanded(
                child: ListView(
                  controller: _verticalScroll,
                  padding: const EdgeInsets.all(24),
                  children: [
                    _buildSummaryCards(report?.data ?? []),
                    const SizedBox(height: 24),
                    _buildFiltersCard(),
                    const SizedBox(height: 24),
                    if (isLoading)
                      const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator()))
                    else if (report != null) ...[
                      _activeView == 'table' ? _buildTableSection(report.data) : _buildChartsSection(report.data),
                      const SizedBox(height: 24),
                      _buildAlertsSection(report.data),
                    ] else
                      const Center(child: Text("No data loaded. Click search.")),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGradientHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFB56965).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(LucideIcons.boxes, color: Color(0xFF2563EB), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Item Stock Summary Report",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
                ),
                Text(
                  "Aggregated item-level stock, value & profitability",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                ),
              ],
            ),
          ),
          _buildViewToggle(),
          const SizedBox(width: 16),
          _buildHeaderAction(LucideIcons.fileSpreadsheet, "Excel", const Color(0xFFF1F5F9), _exportExcel, textColor: const Color(0xFF475569)),
          const SizedBox(width: 12),
          _buildHeaderAction(LucideIcons.printer, "Print", const Color(0xFF2563EB), _printPdf),
        ],
      ),
    );
  }

  Widget _buildViewToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Row(
        children: [
          _toggleBtn("table", "Table", LucideIcons.table),
          _toggleBtn("chart", "Top Items", LucideIcons.barChart3),
        ],
      ),
    );
  }

  Widget _toggleBtn(String view, String label, IconData icon) {
    final active = _activeView == view;
    return GestureDetector(
      onTap: () => setState(() => _activeView = view),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF2563EB) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: active ? Colors.white : const Color(0xFF64748B)),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: active ? Colors.white : const Color(0xFF64748B))),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderAction(IconData icon, String label, Color color, Function action, {Color? textColor}) {
    return ElevatedButton.icon(
      onPressed: () {
        final data = context.read<InventoryReportProvider>().itemStockSummary?.data;
        if (data != null) action(data);
      },
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor ?? Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSummaryCards(List<ItemStockSummaryItem> data) {
    final totals = {
      'items': data.length.toDouble(),
      'qty': data.fold(0.0, (s, r) => s + r.totalStockQty),
      'purValue': data.fold(0.0, (s, r) => s + r.totalPurchaseValue),
      'saleValue': data.fold(0.0, (s, r) => s + r.totalSellingValue),
      'profit': data.fold(0.0, (s, r) => s + r.expectedProfit),
    };

    return Row(
      children: [
        _card("TOTAL ITEMS", _fmtInt(totals['items']), "Configured products", LucideIcons.package, const Color(0xFF64748B)),
        const SizedBox(width: 16),
        _card("TOTAL STOCK QTY", _fmtInt(totals['qty']), "Sum of all combinations", LucideIcons.layers, const Color(0xFF2563EB)),
        const SizedBox(width: 16),
        _card("PURCHASE VALUE", "₹${_fmt(totals['purValue'])}", "Cost of current stock", LucideIcons.indianRupee, const Color(0xFF475569)),
        const SizedBox(width: 16),
        _card("SELLING VALUE", "₹${_fmt(totals['saleValue'])}", "Revenue potential", LucideIcons.trendingUp, const Color(0xFF2563EB)),
        const SizedBox(width: 16),
        _card("EXPECTED PROFIT", "₹${_fmt(totals['profit'])}", "Estimated gross profit", LucideIcons.trendingDown, const Color(0xFF10B981)),
      ],
    );
  }

  Widget _card(String label, String value, String sub, IconData icon, Color color) {
    return Expanded(
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border(left: BorderSide(color: color, width: 4)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 1)),
                Icon(icon, size: 16, color: color.withOpacity(0.5)),
              ],
            ),
            const Spacer(),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E293B), letterSpacing: -0.5)),
            const SizedBox(height: 4),
            Text(sub, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Consumer<ItemGroupProvider>(
              builder: (context, provider, _) => _dropdownField("GROUP NAME", _groupName, ["", ...provider.groups.map((e) => e.groupName)], (v) => setState(() => _groupName = v!)),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Consumer<ItemMasterProvider>(
              builder: (context, provider, _) => _autocompleteField("ITEM NAME", _productName, provider.items.map((e) => e.itemName).toList(), (v) => setState(() => _productName = v)),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: _dropdownField("STOCK STATUS", _stockStatus, ["All", "High", "Medium", "Low", "Zero", "Negative"], (v) => setState(() => _stockStatus = v!)),
          ),
          const SizedBox(width: 20),
          _actionBtn(LucideIcons.search, "Search", const Color(0xFF2563EB), _handleSearch),
          const SizedBox(width: 12),
          _iconBtn(LucideIcons.rotateCcw, _handleReset),
        ],
      ),
    );
  }

  Widget _dropdownField(String label, String value, List<String> options, Function(String?) onChange) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF64748B), letterSpacing: 1)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              items: options.map((e) => DropdownMenuItem(value: e, child: Text(e.isEmpty ? "All Groups" : e))).toList(),
              onChanged: onChange,
            ),
          ),
        ),
      ],
    );
  }

  Widget _autocompleteField(String label, String value, List<String> options, Function(String) onSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF64748B), letterSpacing: 1)),
        const SizedBox(height: 8),
        Autocomplete<String>(
          key: ValueKey("item_$_resetId"),
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) return const Iterable<String>.empty();
            return options.where((s) => s.toLowerCase().contains(textEditingValue.text.toLowerCase()));
          },
          onSelected: onSelected,
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: "Search items...",
                isDense: true,
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _actionBtn(IconData icon, String label, Color color, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 0,
        textStyle: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE2E8F0))),
        child: Icon(icon, size: 20, color: const Color(0xFF475569)),
      ),
    );
  }

  Widget _buildTableSection(List<ItemStockSummaryItem> data) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFE2E8F0))),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _buildTableContent(data),
          _buildGrandTotalFooter(data),
        ],
      ),
    );
  }

  Widget _buildTableContent(List<ItemStockSummaryItem> data) {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          color: const Color(0xFF2563EB),
          child: Row(
            children: [
              _th("SR", width: 40),
              _th("ITEM NAME", flex: 1),
              _th("GROUP", width: 150),
              _th("STOCK QTY", width: 100, align: TextAlign.right),
              _th("COMBOS", width: 80, align: TextAlign.right),
              _th("AVG P.PR", width: 100, align: TextAlign.right),
              _th("AVG S.PR", width: 100, align: TextAlign.right),
              _th("PUR. VAL", width: 120, align: TextAlign.right),
              _th("SALE VAL", width: 120, align: TextAlign.right),
              _th("PROFIT", width: 120, align: TextAlign.right),
              _th("TURN", width: 80, align: TextAlign.center),
              _th("STATUS", width: 100, align: TextAlign.center),
            ],
          ),
        ),
        // Rows
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: data.length,
          separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
          itemBuilder: (context, index) {
            final r = data[index];
            final expanded = _expandedRows.contains(index);
            final isNeg = r.totalStockQty < 0;
            final isLow = r.totalStockQty > 0 && r.totalStockQty <= 10;
            
            Color rowColor = Colors.white;
            if (isNeg) rowColor = const Color(0xFFFFF1F2);
            else if (isLow) rowColor = const Color(0xFFFFFBEB);

            return Column(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      if (expanded) _expandedRows.remove(index);
                      else _expandedRows.add(index);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    color: rowColor,
                    child: Row(
                      children: [
                        _td("${index + 1}", width: 40, color: Colors.grey),
                        _td(r.productName, flex: 1, bold: true),
                        _td(r.groupName, width: 150, size: 12, color: const Color(0xFF64748B)),
                        _td(_fmtInt(r.totalStockQty), width: 100, align: TextAlign.right, bold: true, size: 15, 
                            color: isNeg ? Colors.red : (isLow ? Colors.amber.shade700 : const Color(0xFF1E293B))),
                        _td("${r.combinationCount}", width: 80, align: TextAlign.right),
                        _td("₹${_fmt(r.avgPurchasePrice)}", width: 100, align: TextAlign.right),
                        _td("₹${_fmt(r.avgSellingPrice)}", width: 100, align: TextAlign.right),
                        _td("₹${_fmt(r.totalPurchaseValue)}", width: 120, align: TextAlign.right, bold: true),
                        _td("₹${_fmt(r.totalSellingValue)}", width: 120, align: TextAlign.right, bold: true, color: const Color(0xFF2563EB)),
                        _td("₹${_fmt(r.expectedProfit)}", width: 120, align: TextAlign.right, bold: true, 
                            color: r.expectedProfit >= 0 ? Colors.green.shade700 : Colors.red),
                        _tdW(80, _turnaroundBadge(r.turnover)),
                        _tdW(100, _statusBadge(r.totalStockQty)),
                      ],
                    ),
                  ),
                ),
                if (expanded) _buildRowDetail(r),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _th(String label, {double? width, int? flex, TextAlign align = TextAlign.left}) {
    final child = Text(label, textAlign: align, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1));
    return flex != null ? Expanded(flex: flex, child: child) : SizedBox(width: width, child: child);
  }

  Widget _td(String label, {double? width, int? flex, TextAlign align = TextAlign.left, bool bold = false, double size = 13, Color? color}) {
    final child = Text(label, textAlign: align, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal, fontSize: size, color: color ?? const Color(0xFF334155)));
    return flex != null ? Expanded(flex: flex, child: child) : SizedBox(width: width, child: child);
  }

  Widget _tdW(double width, Widget child) {
    return SizedBox(width: width, child: Center(child: child));
  }

  Widget _buildRowDetail(ItemStockSummaryItem r) {
    final margin = r.totalSellingValue > 0 ? (r.expectedProfit / r.totalSellingValue) * 100 : 0.0;

    return Container(
      padding: const EdgeInsets.all(24),
      color: const Color(0xFFF8FAFC),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          _detailMiniCard("TOTAL COMBOS", "${r.combinationCount}", LucideIcons.package, const Color(0xFF6366F1)),
          _detailMiniCard("AVG PUR. PRICE", "₹${_fmt(r.avgPurchasePrice)}", LucideIcons.indianRupee, const Color(0xFF64748B)),
          _detailMiniCard("AVG SALE PRICE", "₹${_fmt(r.avgSellingPrice)}", LucideIcons.indianRupee, const Color(0xFF2563EB)),
          _detailMiniCard("PROFIT MARGIN", "${margin.toStringAsFixed(1)}%", LucideIcons.trendingUp, const Color(0xFF10B981)),
          _detailMiniCard("TURNAROUND", "${r.turnover}x", LucideIcons.rotateCcw, const Color(0xFFF59E0B)),
        ],
      ),
    );
  }

  Widget _detailMiniCard(String label, String value, IconData icon, Color color) {
    return Container(
      width: 180,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color.withOpacity(0.7), letterSpacing: 0.5)),
                Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _legend(String label, Color color) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
      ],
    );
  }

  Widget _turnaroundBadge(double value) {
    Color color = Colors.red;
    if (value >= 5) color = Colors.green;
    else if (value >= 2) color = Colors.amber;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withOpacity(0.3))),
      child: Text("${value}x", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: color)),
    );
  }

  Widget _statusBadge(double qty) {
    String label = "High"; Color color = Colors.green;
    if (qty < 0) { label = "Negative"; color = Colors.red; }
    else if (qty == 0) { label = "Zero"; color = Colors.grey; }
    else if (qty <= 10) { label = "Low"; color = Colors.amber; }
    else if (qty <= 50) { label = "Medium"; color = Colors.blue; }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
    );
  }

  Widget _buildGrandTotalFooter(List<ItemStockSummaryItem> data) {
    final qty = data.fold<double>(0, (p, c) => p + c.totalStockQty);
    final pur = data.fold<double>(0, (p, c) => p + c.totalPurchaseValue);
    final sale = data.fold<double>(0, (p, c) => p + c.totalSellingValue);
    final profit = data.fold<double>(0, (p, c) => p + c.expectedProfit);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF2563EB),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [BoxShadow(color: const Color(0xFF2563EB).withOpacity(0.2), blurRadius: 10, offset: const Offset(0, -4))],
      ),
      child: Row(
        children: [
          const Text("GRAND TOTAL", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1)),
          const Spacer(),
          _footerVal("QTY", _fmtInt(qty)),
          const SizedBox(width: 40),
          _footerVal("PURCHASE", "₹${_fmt(pur)}"),
          const SizedBox(width: 40),
          _footerVal("SALE", "₹${_fmt(sale)}"),
          const SizedBox(width: 40),
          _footerVal("PROFIT", "₹${_fmt(profit)}", color: const Color(0xFF10B981)),
        ],
      ),
    );
  }

  Widget _footerVal(String label, String value, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white38)),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: color ?? Colors.white)),
      ],
    );
  }

  Widget _buildChartsSection(List<ItemStockSummaryItem> data) {
    final topStock = [...data]..sort((a, b) => b.totalStockQty.compareTo(a.totalStockQty));
    final top5Stock = topStock.take(5).toList();
    final maxStock = top5Stock.isEmpty ? 1.0 : top5Stock.first.totalStockQty;

    final topProfit = [...data]..sort((a, b) => b.expectedProfit.compareTo(a.expectedProfit));
    final top5Profit = topProfit.take(5).toList();
    final maxProfit = top5Profit.isEmpty ? 1.0 : top5Profit.first.expectedProfit;
    final sumProfit = top5Profit.fold(0.0, (s, r) => s + r.expectedProfit);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _chartCard("Top 5 Items By Stock Quantity", LucideIcons.barChart3, const Color(0xFF2563EB), top5Stock, maxStock, (r) => r.totalStockQty, (v) => _fmtInt(v))),
        const SizedBox(width: 24),
        Expanded(
          child: _chartCard(
            "Top 5 Most Profitable Items", 
            LucideIcons.trendingUp, 
            const Color(0xFF10B981), 
            top5Profit, 
            maxProfit, 
            (r) => r.expectedProfit, 
            (v) => "₹${_fmt(v)}",
            showToggle: true,
            footer: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(height: 32, color: Color(0xFFF1F5F9)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("TOTAL OVERALL PROFIT", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 0.5)),
                        Text("(SUM OF TOP 5 ITEMS)", style: TextStyle(fontSize: 8, color: Colors.grey.shade400, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Text("₹${_fmt(sumProfit)}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF10B981))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _chartCard(String title, IconData icon, Color color, List<ItemStockSummaryItem> items, double max, double Function(ItemStockSummaryItem) valGetter, String Function(double) formatter, {bool showToggle = false, Widget? footer}) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 12),
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
              const Spacer(),
              if (showToggle) _buildProfitToggle(),
            ],
          ),
          const SizedBox(height: 32),
          ...items.map((it) {
            final val = valGetter(it);
            return Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(it.productName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF334155)))),
                      Text(formatter(val), style: TextStyle(fontWeight: FontWeight.w900, color: color)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 12,
                    width: double.infinity,
                    decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: max > 0 ? (val / max).clamp(0, 1) : 0,
                      child: Container(
                        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          if (footer != null) footer,
        ],
      ),
    );
  }

  Widget _buildProfitToggle() {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          _miniToggle("total", "Total Profit"),
          _miniToggle("live", "Live Profit"),
        ],
      ),
    );
  }

  Widget _miniToggle(String type, String label) {
    final active = _profitView == type;
    return GestureDetector(
      onTap: () => setState(() => _profitView = type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          boxShadow: active ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)] : null,
        ),
        child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: active ? const Color(0xFF2563EB) : const Color(0xFF94A3B8))),
      ),
    );
  }

  Widget _buildAlertsSection(List<ItemStockSummaryItem> data) {
    final deadStock = data.where((r) => r.totalStockQty > 0 && r.turnover == 0).toList();
    final lowStock = data.where((r) => r.totalStockQty > 0 && r.totalStockQty <= 10).toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _alertCard("Dead Stock Items", LucideIcons.skull, const Color(0xFF64748B), deadStock, "Items with stock but no movement")),
        const SizedBox(width: 24),
        Expanded(child: _alertCard("Low Stock Alerts", LucideIcons.alertTriangle, const Color(0xFFF59E0B), lowStock, "Items below threshold (10 units)")),
      ],
    );
  }

  Widget _alertCard(String title, IconData icon, Color color, List<ItemStockSummaryItem> items, String sub) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32), border: Border.all(color: color.withOpacity(0.1))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, size: 20, color: color)),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
                  Text(sub, style: TextStyle(fontSize: 11, color: Colors.grey.shade400, fontWeight: FontWeight.bold)),
                ],
              ),
              const Spacer(),
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)), child: Text("${items.length}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
            ],
          ),
          const SizedBox(height: 24),
          if (items.isEmpty)
            const Center(child: Padding(padding: EdgeInsets.all(20), child: Text("NO ITEMS IN THIS CATEGORY", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFFCBD5E1), letterSpacing: 1))))
          else
            SizedBox(
              height: 250,
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: items.length,
                separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
                itemBuilder: (context, i) {
                  final it = items[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(it.productName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF334155))),
                              Text("${it.groupName} • ${it.combinationCount} combos", style: TextStyle(fontSize: 10, color: Colors.grey.shade400, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Column(
                           crossAxisAlignment: CrossAxisAlignment.end,
                           children: [
                             Text("${it.totalStockQty.toInt()} PCS", style: TextStyle(fontWeight: FontWeight.w900, color: color, fontSize: 13)),
                             Text("₹${_fmt(it.totalPurchaseValue)}", style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                           ],
                         ),
                         const SizedBox(width: 12),
                         Container(
                           padding: const EdgeInsets.all(4),
                           decoration: BoxDecoration(color: Colors.red.withOpacity(0.05), shape: BoxShape.circle),
                           child: const Icon(LucideIcons.x, size: 12, color: Colors.red),
                         ),
                       ],
                     ),
                   );
                },
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _exportExcel(List<ItemStockSummaryItem> data) async {
    final excel = xl.Excel.createExcel();
    final sheet = excel['Summary'];
    sheet.appendRow(["SR", "Item Name", "Group", "Stock Qty", "Pur. Price", "Sale Price", "Pur. Value", "Sale Value", "Profit", "Turnaround"].map((e) => xl.TextCellValue(e)).toList());
    for (var i = 0; i < data.length; i++) {
      final r = data[i];
      sheet.appendRow([
        xl.IntCellValue(i + 1),
        xl.TextCellValue(r.productName),
        xl.TextCellValue(r.groupName),
        xl.DoubleCellValue(r.totalStockQty),
        xl.DoubleCellValue(r.avgPurchasePrice),
        xl.DoubleCellValue(r.avgSellingPrice),
        xl.DoubleCellValue(r.totalPurchaseValue),
        xl.DoubleCellValue(r.totalSellingValue),
        xl.DoubleCellValue(r.expectedProfit),
        xl.TextCellValue("${r.turnover}x")
      ]);
    }
    final fileBytes = excel.save();
    if (fileBytes != null) {
      String fileName = "Item_Stock_Summary_${DateFormat('ddMMyy').format(DateTime.now())}.xlsx";
      String? path = await FilePicker.saveFile(fileName: fileName, type: FileType.custom, allowedExtensions: ['xlsx']);
      if (path != null) {
        File(path).writeAsBytesSync(fileBytes);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Exported to $path"), backgroundColor: Colors.green));
      }
    }
  }

  Future<void> _printPdf(List<ItemStockSummaryItem> data) async {
    final doc = pw.Document();
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context context) => [
          pw.Header(level: 0, child: pw.Text("Item Stock Summary Report", style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold))),
          pw.SizedBox(height: 10),
          pw.TableHelper.fromTextArray(
            headers: ["SR", "Item Name", "Group", "Qty", "P.Price", "S.Price", "Pur.Val", "Sale.Val", "Profit"],
            data: data.asMap().entries.map((e) => [
              "${e.key + 1}",
              e.value.productName,
              e.value.groupName,
              _fmtInt(e.value.totalStockQty),
              _fmt(e.value.avgPurchasePrice),
              _fmt(e.value.avgSellingPrice),
              _fmt(e.value.totalPurchaseValue),
              _fmt(e.value.totalSellingValue),
              _fmt(e.value.expectedProfit),
            ]).toList(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
            cellStyle: const pw.TextStyle(fontSize: 8),
          ),
        ],
      ),
    );
    await Printing.layoutPdf(onLayout: (format) async => doc.save());
  }
}
