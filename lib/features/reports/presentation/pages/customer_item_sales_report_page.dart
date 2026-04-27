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
import '../../../masters/data/providers/account_provider.dart';
import '../../../masters/data/models/account_model.dart';
import '../../../masters/data/providers/inventory_providers.dart';
import '../../../masters/data/models/item_master_model.dart';

class CustomerItemSalesReportPage extends StatefulWidget {
  const CustomerItemSalesReportPage({super.key});

  @override
  State<CustomerItemSalesReportPage> createState() => _CustomerItemSalesReportPageState();
}

class _CustomerItemSalesReportPageState extends State<CustomerItemSalesReportPage> {
  DateTime _fromDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime _toDate = DateTime.now();
  String _customerName = '';
  String _itemSearch = '';
  final TextEditingController _customerSearchController = TextEditingController();
  final TextEditingController _itemSearchController = TextEditingController();
  final FocusNode _customerFocusNode = FocusNode();
  final FocusNode _itemFocusNode = FocusNode();

  final ScrollController _verticalScroll = ScrollController();
  final ScrollController _horizontalScroll = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountProvider>().fetchAllAccounts();
      context.read<ItemMasterProvider>().fetchItems();
    });
  }

  @override
  void dispose() {
    _customerSearchController.dispose();
    _itemSearchController.dispose();
    _customerFocusNode.dispose();
    _itemFocusNode.dispose();
    _verticalScroll.dispose();
    _horizontalScroll.dispose();
    super.dispose();
  }

  void _handleGenerate() {
    if (_customerName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a customer first')),
      );
      return;
    }

    final Map<String, dynamic> filters = {
      'customerName': _customerName,
      'dateFrom': DateFormat('yyyy-MM-dd').format(_fromDate),
      'dateTo': DateFormat('yyyy-MM-dd').format(_toDate),
      'itemSearch': _itemSearch.isEmpty ? null : _itemSearch,
    };
    context.read<InventoryReportProvider>().fetchCustomerItemSalesReport(filters);
  }

  void _handleReset() {
    _customerSearchController.clear();
    _itemSearchController.clear();
    setState(() {
      _customerName = '';
      _itemSearch = '';
      _fromDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
      _toDate = DateTime.now();
    });
    context.read<InventoryReportProvider>().resetAll();
  }

  Future<void> _exportExcel(CustomerItemSalesResponse report) async {
    final excel = xl.Excel.createExcel();
    final sheet = excel['Customer Item Sales'];
    excel.setDefaultSheet('Customer Item Sales');

    final header = ['SR No.', 'Item Name', 'Total Qty', 'Revenue', 'Orders', 'Last Sold'];
    sheet.appendRow(header.map((e) => xl.TextCellValue(e)).toList());

    for (var i = 0; i < report.data.length; i++) {
      final r = report.data[i];
      sheet.appendRow([
        xl.IntCellValue(i + 1),
        xl.TextCellValue(r.itemName),
        xl.DoubleCellValue(r.totalQty),
        xl.DoubleCellValue(r.totalRevenue),
        xl.IntCellValue(r.orderCount),
        xl.TextCellValue(r.lastSoldDate ?? '-'),
      ]);
    }

    // Grand Total
    sheet.appendRow([
      xl.TextCellValue(''),
      xl.TextCellValue('GRAND TOTAL'),
      xl.DoubleCellValue(report.summary.totalQty),
      xl.DoubleCellValue(report.summary.totalRevenue),
      xl.IntCellValue(report.summary.totalOrders ?? 0),
      xl.TextCellValue(''),
    ]);

    String? path = await FilePicker.saveFile(
      dialogTitle: 'Save Excel File',
      fileName: 'Customer_Item_Sales_${_customerName}_${DateFormat('ddMMyyyy').format(DateTime.now())}.xlsx',
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (path != null) {
      if (!path.endsWith('.xlsx')) path += '.xlsx';
      final fileBytes = excel.save();
      if (fileBytes != null) {
        File(path).writeAsBytesSync(fileBytes);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Exported to $path')),
          );
        }
      }
    }
  }

  Future<void> _printPdf(CustomerItemSalesResponse report) async {
    final doc = pw.Document();
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Customer Item Sales Report', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 4),
                  pw.Text('Customer: $_customerName | Period: ${DateFormat('dd/MM/yyyy').format(_fromDate)} to ${DateFormat('dd/MM/yyyy').format(_toDate)}',
                      style: const pw.TextStyle(fontSize: 10)),
                ],
              ),
            ),
            pw.SizedBox(height: 10),
            pw.TableHelper.fromTextArray(
              headers: ['SR', 'Item Name', 'Total Qty', 'Revenue', 'Orders', 'Last Sold'],
              data: [
                ...report.data.asMap().entries.map((ent) {
                  final r = ent.value;
                  return [
                    (ent.key + 1).toString(),
                    r.itemName,
                    r.totalQty.toStringAsFixed(0),
                    '₹${r.totalRevenue.toStringAsFixed(2)}',
                    r.orderCount.toString(),
                    r.lastSoldDate ?? '-',
                  ];
                }),
                [
                  '',
                  'GRAND TOTAL',
                  report.summary.totalQty.toStringAsFixed(0),
                  '₹${report.summary.totalRevenue.toStringAsFixed(2)}',
                  (report.summary.totalOrders ?? 0).toString(),
                  '',
                ]
              ],
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
              cellStyle: const pw.TextStyle(fontSize: 8),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
              cellAlignment: pw.Alignment.centerLeft,
              columnWidths: {
                0: const pw.FixedColumnWidth(30),
                1: const pw.FlexColumnWidth(),
                2: const pw.FixedColumnWidth(60),
                3: const pw.FixedColumnWidth(80),
                4: const pw.FixedColumnWidth(50),
                5: const pw.FixedColumnWidth(80),
              },
            ),
          ];
        },
      ),
    );
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
      name: 'Customer_Item_Sales_Report.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Consumer<InventoryReportProvider>(
        builder: (context, provider, child) {
          final report = provider.customerItemSalesResponse;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(report),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    _buildFilterPanel(provider.isLoading),
                    const SizedBox(height: 24),
                    if (report != null && !provider.isLoading) ...[
                      _buildSummaryCards(report.summary),
                      const SizedBox(height: 24),
                      _buildInsightsRow(report),
                      const SizedBox(height: 24),
                      _buildTableSection(report),
                    ] else if (!provider.isLoading && report == null)
                      _buildEmptyState(),
                    if (provider.isLoading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 64),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(CustomerItemSalesResponse? report) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)]),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: const Color(0xFF4F46E5).withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))],
            ),
            child: const Icon(LucideIcons.package, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Customer Item Sales Report',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
              ),
              const SizedBox(height: 2),
              Text(
                'ITEMS PURCHASED BY CUSTOMER · QUANTITY & REVENUE ANALYSIS',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade400, letterSpacing: 1),
              ),
            ],
          ),
          const Spacer(),
          _headerButton(
            icon: LucideIcons.download, 
            tooltip: 'Export Excel', 
            onTap: report != null ? () => _exportExcel(report) : null,
            iconColor: report != null ? const Color(0xFF1E293B) : null,
          ),
          const SizedBox(width: 8),
          _headerButton(
            icon: LucideIcons.printer, 
            tooltip: 'Print', 
            onTap: report != null ? () => _printPdf(report) : null,
            iconColor: report != null ? const Color(0xFF1E293B) : null,
          ),
          const SizedBox(width: 8),
          _headerButton(
            icon: LucideIcons.refreshCw, 
            tooltip: 'Reset', 
            onTap: _handleReset, 
            color: const Color(0xFFFEF2F2), 
            iconColor: const Color(0xFFEF4444),
          ),
        ],
      ),
    );
  }

  Widget _headerButton({required IconData icon, required String tooltip, VoidCallback? onTap, Color? color, Color? iconColor}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color ?? Colors.white,
          border: Border.all(color: color == null ? Colors.grey.shade200 : Colors.transparent),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 16, color: onTap == null ? Colors.grey.shade300 : (iconColor ?? Colors.grey.shade600)),
      ),
    );
  }

  Widget _buildFilterPanel(bool isLoading) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          // Customer Search
          SizedBox(
            width: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _filterLabel(LucideIcons.users, 'Customer *'),
                const SizedBox(height: 8),
                Consumer<AccountProvider>(
                  builder: (context, provider, _) => Autocomplete<AccountModel>(
                    textEditingController: _customerSearchController,
                    focusNode: _customerFocusNode,
                    optionsBuilder: (textEditingValue) {
                      return provider.accounts
                          .where((a) => (a.accountType == 'Sale' || a.accountType == 'Both') &&
                                        a.name.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                    },
                    displayStringForOption: (option) => option.name,
                    onSelected: (v) => setState(() => _customerName = v.name),
                    fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                      if (controller.text != _customerName && _customerName.isNotEmpty) {
                        // Keep controller in sync with state if needed, but here we use the param
                      }
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: _inputDecoration('Search & select customer…',
                            suffix: _customerName.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(LucideIcons.x, size: 14),
                                    onPressed: () {
                                      controller.clear();
                                      setState(() => _customerName = '');
                                    },
                                  )
                                : null),
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // From Date
          SizedBox(
            width: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _filterLabel(LucideIcons.calendar, 'From'),
                const SizedBox(height: 8),
                _datePickerWidget(_fromDate, (d) => setState(() => _fromDate = d)),
              ],
            ),
          ),
          // To Date
          SizedBox(
            width: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _filterLabel(LucideIcons.calendar, 'To'),
                const SizedBox(height: 8),
                _datePickerWidget(_toDate, (d) => setState(() => _toDate = d)),
              ],
            ),
          ),
          // Item Search
          SizedBox(
            width: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _filterLabel(LucideIcons.search, 'Item Search'),
                const SizedBox(height: 8),
                Consumer<ItemMasterProvider>(
                  builder: (context, provider, _) => Autocomplete<ItemMasterModel>(
                    textEditingController: _itemSearchController,
                    focusNode: _itemFocusNode,
                    optionsBuilder: (textEditingValue) {
                      return provider.items
                          .where((i) => i.itemName.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                    },
                    displayStringForOption: (option) => option.itemName,
                    onSelected: (v) => setState(() => _itemSearch = v.itemName),
                    fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                      if (controller.text != _itemSearch && _itemSearch.isNotEmpty && controller.text.isEmpty) {
                         controller.text = _itemSearch;
                      }
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        onChanged: (v) => setState(() => _itemSearch = v),
                        decoration: _inputDecoration('Filter items…', 
                            suffix: _itemSearch.isNotEmpty 
                                ? IconButton(
                                    icon: const Icon(LucideIcons.x, size: 14),
                                    onPressed: () {
                                      controller.clear();
                                      setState(() => _itemSearch = '');
                                    },
                                  )
                                : const Icon(LucideIcons.search, size: 14, color: Colors.grey)),
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Generate Button
          ElevatedButton.icon(
            onPressed: isLoading ? null : _handleGenerate,
            icon: isLoading
                ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(LucideIcons.trendingUp, size: 14),
            label: Text(isLoading ? 'LOADING…' : 'GENERATE'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 1),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterLabel(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 12, color: Colors.grey.shade400),
        const SizedBox(width: 6),
        Text(label.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey.shade400, letterSpacing: 1)),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint, {Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade300, fontWeight: FontWeight.normal),
      fillColor: const Color(0xFFF8FAFC),
      filled: true,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade100, width: 2)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade100, width: 2)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2)),
      suffixIcon: suffix,
    );
  }

  Widget _datePickerWidget(DateTime date, Function(DateTime) onPicked) {
    return InkWell(
      onTap: () async {
        final d = await showDatePicker(context: context, initialDate: date, firstDate: DateTime(2000), lastDate: DateTime(2100));
        if (d != null) onPicked(d);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade100, width: 2)),
        child: Text(DateFormat('dd-MM-yyyy').format(date), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSummaryCards(CustomerItemSalesSummary summary) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double cardWidth = (constraints.maxWidth - 32) / 3;
        return Row(
          children: [
            _summaryCard('Total Items', summary.totalItems.toString(), LucideIcons.package, const Color(0xFF6366F1), 'Unique items', cardWidth),
            const SizedBox(width: 16),
            _summaryCard('Total Qty Sold', summary.totalQty.toStringAsFixed(0), LucideIcons.barChart3, const Color(0xFF06B6D4), 'Pieces dispatched', cardWidth),
            const SizedBox(width: 16),
            _summaryCard('Total Revenue', '₹${NumberFormat('#,##,##0.00').format(summary.totalRevenue)}', LucideIcons.trendingUp, const Color(0xFF10B981), 'Gross sales value', cardWidth),
          ],
        );
      },
    );
  }

  Widget _summaryCard(String label, String value, IconData icon, Color color, String sub, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            top: -10,
            child: Opacity(
              opacity: 0.05,
              child: Icon(icon, size: 64, color: color),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label.toUpperCase(), style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.grey.shade400, letterSpacing: 1)),
              const SizedBox(height: 12),
              Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1E293B), letterSpacing: -0.5)),
              const SizedBox(height: 4),
              Text(sub.toUpperCase(), style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey.shade300, letterSpacing: 1)),
              const SizedBox(height: 12),
              Container(
                height: 4, 
                width: double.infinity, 
                decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(2)),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 1.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInsightsRow(CustomerItemSalesResponse report) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top 5 Chart
        Expanded(
          flex: 7,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(LucideIcons.barChart3, size: 16, color: Color(0xFF6366F1)),
                    const SizedBox(width: 12),
                    Text('TOP 5 ITEMS BY QUANTITY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey.shade700, letterSpacing: 1)),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(height: 1, color: Color(0xFFF1F5F9)),
                ),
                _buildMiniBarChart(report.data),
              ],
            ),
          ),
        ),
        const SizedBox(width: 24),
        // Insights Card
        Expanded(
          flex: 5,
          child: Container(
            padding: const EdgeInsets.all(24),
            height: 280,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 4,
                  width: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF22D3EE)]),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(12)),
                      child: const Icon(LucideIcons.star, size: 18, color: Color(0xFF4F46E5)),
                    ),
                    const SizedBox(width: 12),
                    const Text('CUSTOMER INSIGHTS', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF1E293B), letterSpacing: 1)),
                  ],
                ),
                const SizedBox(height: 16),
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade400, height: 1.6, letterSpacing: 0.5),
                    children: [
                      TextSpan(text: '${_customerName.toUpperCase()} HAS PURCHASED '),
                      TextSpan(text: '${report.summary.totalItems} UNIQUE ITEMS', style: const TextStyle(color: Color(0xFF4F46E5))),
                      const TextSpan(text: ' WITH A TOTAL OF '),
                      TextSpan(text: '${report.summary.totalQty.toStringAsFixed(0)} UNITS', style: const TextStyle(color: Color(0xFF10B981))),
                      const TextSpan(text: ' AND REVENUE OF '),
                      TextSpan(text: '₹${NumberFormat('#,##,##0.00').format(report.summary.totalRevenue)}', style: const TextStyle(color: Color(0xFF10B981))),
                      const TextSpan(text: '.'),
                    ],
                  ),
                ),
                if (report.data.isNotEmpty) ...[
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: const Color(0xFFF5F3FF), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFEDE9FE))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('TOP ITEM', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFFA78BFA), letterSpacing: 1)),
                        const SizedBox(height: 4),
                        Text(report.data[0].itemName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF5B21B6))),
                        const SizedBox(height: 4),
                        Text(
                          '${report.data[0].totalQty.toStringAsFixed(0)} PCS · ₹${NumberFormat('#,##,##0.00').format(report.data[0].totalRevenue)} · ${report.data[0].orderCount} ORDERS',
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF8B5CF6)),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMiniBarChart(List<CustomerItemSalesItem> data) {
    final top5 = data.take(5).toList();
    if (top5.isEmpty) {
      return const Center(child: Text('NO DATA TO DISPLAY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFFCBD5E1), letterSpacing: 2)));
    }
    final maxQty = top5[0].totalQty;

    return Column(
      children: top5.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(item.itemName.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey.shade500, letterSpacing: 0.5), overflow: TextOverflow.ellipsis)),
                  Text('${item.totalQty.toStringAsFixed(0)} PCS', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF4F46E5))),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                height: 12,
                width: double.infinity,
                decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(6), border: Border.all(color: const Color(0xFFF1F5F9))),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: maxQty > 0 ? (item.totalQty / maxQty) : 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF818CF8), Color(0xFF4F46E5)]),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTableSection(CustomerItemSalesResponse report) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20)],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Table(
            columnWidths: const {
              0: FixedColumnWidth(60),
              1: FlexColumnWidth(),
              2: FixedColumnWidth(120),
              3: FixedColumnWidth(150),
              4: FixedColumnWidth(100),
              5: FixedColumnWidth(150),
            },
            children: [
              TableRow(
                decoration: const BoxDecoration(color: Color(0xFFF8FAFC)),
                children: [
                  _headerCell('SR'),
                  _headerCell('ITEM NAME'),
                  _headerCell('TOTAL QTY', align: TextAlign.right),
                  _headerCell('REVENUE', align: TextAlign.right),
                  _headerCell('ORDERS', align: TextAlign.center),
                  _headerCell('LAST SOLD'),
                ],
              ),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: report.data.length,
            itemBuilder: (context, index) {
              final item = report.data[index];
              return Container(
                decoration: BoxDecoration(
                  color: index == 0 ? const Color(0xFFEEF2FF).withOpacity(0.3) : null,
                  border: Border(bottom: BorderSide(color: Colors.grey.shade50)),
                ),
                child: Table(
                  columnWidths: const {
                    0: FixedColumnWidth(60),
                    1: FlexColumnWidth(),
                    2: FixedColumnWidth(120),
                    3: FixedColumnWidth(150),
                    4: FixedColumnWidth(100),
                    5: FixedColumnWidth(150),
                  },
                  children: [
                    TableRow(
                      children: [
                        _cell((index + 1).toString(), color: Colors.grey.shade300, weight: FontWeight.w900),
                        _itemCell(item.itemName, index == 0),
                        _qtyCell(item.totalQty, report.data[0].totalQty),
                        _cell('₹${NumberFormat('#,##,##0.00').format(item.totalRevenue)}', color: const Color(0xFF10B981), weight: FontWeight.w900),
                        _orderCell(item.orderCount),
                        _cell(item.lastSoldDate ?? '—', color: Colors.grey.shade400, weight: FontWeight.bold),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          // Grand Total
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE2E8F0), width: 2)),
            ),
            child: Table(
              columnWidths: const {
                0: FixedColumnWidth(60),
                1: FlexColumnWidth(),
                2: FixedColumnWidth(120),
                3: FixedColumnWidth(150),
                4: FixedColumnWidth(100),
                5: FixedColumnWidth(150),
              },
              children: [
                TableRow(
                  children: [
                    const SizedBox(),
                    _cell('GRAND TOTAL', align: TextAlign.right, weight: FontWeight.w900, size: 12),
                    _cell(report.summary.totalQty.toStringAsFixed(0), align: TextAlign.right, color: const Color(0xFF4F46E5), weight: FontWeight.w900, size: 14),
                    _cell('₹${NumberFormat('#,##,##0.00').format(report.summary.totalRevenue)}', align: TextAlign.right, color: const Color(0xFF10B981), weight: FontWeight.w900, size: 12),
                    _cell((report.summary.totalOrders ?? 0).toString(), align: TextAlign.center, weight: FontWeight.w900, size: 14),
                    const SizedBox(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerCell(String text, {TextAlign align = TextAlign.left}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Text(text, textAlign: align, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 1)),
    );
  }

  Widget _cell(String text, {TextAlign align = TextAlign.left, Color? color, FontWeight? weight, double size = 11}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Text(text, textAlign: align, style: TextStyle(fontSize: size, fontWeight: weight ?? FontWeight.bold, color: color ?? const Color(0xFF1E293B))),
    );
  }

  Widget _itemCell(String name, bool isTop) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: [
          if (isTop) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: const Color(0xFFFFF7ED), borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xFFFFEDD5))),
              child: const Row(
                children: [
                  Icon(LucideIcons.star, size: 10, color: Color(0xFFD97706)),
                  SizedBox(width: 4),
                  Text('TOP', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Color(0xFFD97706))),
                ],
              ),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(child: Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)), overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  Widget _qtyCell(double qty, double maxQty) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(qty.toStringAsFixed(0), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF4F46E5))),
          const SizedBox(height: 4),
          Container(
            height: 3,
            width: 60,
            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(1.5)),
            child: FractionallySizedBox(
              alignment: Alignment.centerRight,
              widthFactor: maxQty > 0 ? (qty / maxQty) : 0,
              child: Container(decoration: BoxDecoration(color: const Color(0xFF818CF8), borderRadius: BorderRadius.circular(1.5))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderCell(int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Center(
        child: Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFF1F5F9))),
          child: Text(count.toString(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF64748B))),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(24)),
            child: const Icon(LucideIcons.package, size: 48, color: Color(0xFF818CF8)),
          ),
          const SizedBox(height: 24),
          const Text('SELECT A CUSTOMER', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF334155), letterSpacing: -0.5)),
          const SizedBox(height: 8),
          Text('CHOOSE A CUSTOMER AND DATE RANGE, THEN CLICK GENERATE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade400, letterSpacing: 1)),
        ],
      ),
    );
  }
}
