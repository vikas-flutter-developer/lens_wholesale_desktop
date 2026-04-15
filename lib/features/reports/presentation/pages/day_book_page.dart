import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:csv/csv.dart';
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:go_router/go_router.dart';

import '../../data/providers/financial_provider.dart';
import '../../data/models/financial_models.dart';
import '../../../masters/data/providers/account_provider.dart';
import '../../../masters/data/models/account_model.dart';
import 'dart:async';

class DayBookPage extends StatefulWidget {
  const DayBookPage({super.key});

  @override
  State<DayBookPage> createState() => _DayBookPageState();
}

class _DayBookPageState extends State<DayBookPage> {
  final _searchController = TextEditingController();
  final _firmController = TextEditingController(text: 'All Firms');
  final LayerLink _layerLink = LayerLink();
  final ScrollController _horizontalScrollController = ScrollController();
  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now();
  bool _showColumnFilter = false;
  String _quickSearch = '';

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountProvider>().fetchAllAccounts();
      _handleSearch();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _handleSearch() async {
    final provider = context.read<FinancialProvider>();
    await provider.fetchDayBook({
      'firmName': _firmController.text == 'All Firms' ? '' : _firmController.text,
      'dateFrom': DateFormat('yyyy-MM-dd').format(_fromDate),
      'dateTo': DateFormat('yyyy-MM-dd').format(_toDate),
    });
  }

  void _resetFilters() {
    _firmController.text = 'All Firms';
    _searchController.clear();
    setState(() {
      _quickSearch = '';
      _fromDate = DateTime.now();
      _toDate = DateTime.now();
    });
    context.read<FinancialProvider>().resetAll();
  }

  List<DayBookTransaction> _getFilteredTransactions(List<DayBookTransaction> transactions) {
    if (_quickSearch.isEmpty) return transactions;
    final term = _quickSearch.toLowerCase();
    return transactions.where((t) {
      final matchBase = t.account.toLowerCase().contains(term) ||
          t.transType.toLowerCase().contains(term) ||
          (t.vchNo?.toLowerCase().contains(term) ?? false);

      final matchItems = t.items?.any((it) =>
      (it.itemName?.toLowerCase().contains(term) ?? false) ||
          (it.orderNo?.toLowerCase().contains(term) ?? false) ||
          (it.eye?.toLowerCase().contains(term) ?? false) ||
          (it.sph?.toLowerCase().contains(term) ?? false) ||
          (it.cyl?.toLowerCase().contains(term) ?? false) ||
          (it.axis?.toLowerCase().contains(term) ?? false) ||
          (it.add?.toLowerCase().contains(term) ?? false) ||
          (it.remark?.toLowerCase().contains(term) ?? false)
      ) ?? false;

      return matchBase || matchItems;
    }).toList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              _buildHeader(),
              _buildFilters(),
              _buildSummaryBar(),
              Expanded(child: _buildTable()),
            ],
          ),
          if (_showColumnFilter)
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              bottom: 0,
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _showColumnFilter = false),
                    behavior: HitTestBehavior.opaque,
                    child: Container(color: Colors.transparent),
                  ),
                  CompositedTransformFollower(
                    link: _layerLink,
                    offset: const Offset(0, 42),
                    targetAnchor: Alignment.bottomRight,
                    followerAnchor: Alignment.topRight,
                    child: _buildColumnFilterPopup(context.watch<FinancialProvider>()),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFF4A86E8),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(LucideIcons.bookOpen, color: Colors.blue.shade100, size: 20),
              const SizedBox(width: 8),
              const Text(
                'DAY BOOK SUMMARY',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(flex: 3, child: _buildFilterInput('FIRM NAME', _buildFirmAutocomplete())),
          const SizedBox(width: 12),
          _buildFilterInput('FROM DATE', _buildDateInput(_fromDate, (d) => setState(() => _fromDate = d))),
          const SizedBox(width: 12),
          _buildFilterInput('TO DATE', _buildDateInput(_toDate, (d) => setState(() => _toDate = d))),
          const SizedBox(width: 12),
          Expanded(flex: 4, child: _buildFilterInput('', _buildSearchField())),
          const SizedBox(width: 12),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildFilterInput(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: Color(0xFF64748B),
                letterSpacing: 1.5,
              ),
            ),
          ),
        child,
      ],
    );
  }

  Widget _buildDateInput(DateTime date, Function(DateTime) onSelect) {
    return InkWell(
      onTap: () async {
        final d = await showDatePicker(context: context, initialDate: date, firstDate: DateTime(2000), lastDate: DateTime(2100));
        if (d != null) onSelect(d);
      },
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFCBD5E1)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              DateFormat('dd-MM-yyyy').format(date),
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
            ),
            const SizedBox(width: 8),
            const Icon(LucideIcons.calendar, size: 14, color: Color(0xFF64748B)),
          ],
        ),
      ),
    );
  }

  Widget _buildFirmAutocomplete() {
    final accounts = context.watch<AccountProvider>().accounts;
    return LayoutBuilder(
      builder: (context, constraints) => Autocomplete<AccountModel>(
        optionsBuilder: (TextEditingValue value) {
          if (value.text.isEmpty || value.text == 'All Firms') {
            return [AccountModel(id: '', name: 'All Firms', printName: '', accountId: '', groups: [], stations: [])];
          }
          return accounts.where((a) => (a.name).toLowerCase().contains(value.text.toLowerCase()));
        },
        displayStringForOption: (option) => option.name ?? '',
        onSelected: (option) {
          _firmController.text = option.name ?? '';
          _handleSearch();
        },
        fieldViewBuilder: (context, controller, focus, onFieldSubmitted) {
          if (controller.text.isEmpty && _firmController.text.isNotEmpty) {
            controller.text = _firmController.text;
          }
          return SizedBox(
            height: 44,
            child: TextField(
              controller: controller,
              focusNode: focus,
              decoration: InputDecoration(
                hintText: 'All Firms',
                isDense: false,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF4A86E8), width: 2)),
                fillColor: Colors.white,
                filled: true,
                suffixIcon: controller.text.isNotEmpty ? IconButton(icon: const Icon(Icons.clear, size: 14), onPressed: () {
                  controller.clear();
                  _firmController.text = 'All Firms';
                  _handleSearch();
                }) : null,
              ),
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
            ),
          );
        },
        optionsViewBuilder: (context, onSelected, options) => Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: constraints.maxWidth,
              constraints: const BoxConstraints(maxHeight: 250),
              decoration: BoxDecoration(border: Border.all(color: const Color(0xFFF1F5F9)), borderRadius: BorderRadius.circular(12)),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);
                  return ListTile(
                    title: Text(option.name ?? '', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    onTap: () => onSelected(option),
                    hoverColor: Colors.blue.shade50,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return SizedBox(
      height: 44,
      child: TextField(
        onChanged: (v) {
          if (_debounce?.isActive ?? false) _debounce!.cancel();
          _debounce = Timer(const Duration(milliseconds: 300), () {
            setState(() => _quickSearch = v);
          });
        },
        decoration: InputDecoration(
          hintText: 'Quick search...',
          isDense: false,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF4A86E8), width: 2)),
          fillColor: Colors.white,
          filled: true,
        ),
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
      ),
    );
  }

  Widget _buildActionButtons() {
    final provider = context.watch<FinancialProvider>();
    return Row(
      children: [
        CompositedTransformTarget(
          link: _layerLink,
          child: _btn(
              LucideIcons.layout,
              Colors.white,
              const Color(0xFF475569),
                  () => setState(() => _showColumnFilter = !_showColumnFilter),
              label: 'Columns',
              iconColor: const Color(0xFF2563EB)
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () async {
            await _handleSearch();
            if (mounted) setState(() {});
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2563EB),
            foregroundColor: Colors.white,
            minimumSize: const Size(120, 44),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 4,
            shadowColor: const Color(0xFF2563EB).withValues(alpha: 0.4),
          ),
          child: provider.isLoading
              ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Text('SEARCH', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 0.5)),
        ),
        const SizedBox(width: 8),
        _iconBtn(LucideIcons.rotateCcw, _resetFilters, color: const Color(0xFF64748B), bg: const Color(0xFFF1F5F9)),
        const SizedBox(width: 8),
        _iconBtn(LucideIcons.fileSpreadsheet, () {
          if (provider.dayBook != null) _exportCSV(_getFilteredTransactions(provider.dayBook!.transactions));
        }, color: Colors.white, bg: const Color(0xFF22C55E)),
        const SizedBox(width: 8),
        _iconBtn(LucideIcons.printer, () {
          if (provider.dayBook != null) _handlePrint(_getFilteredTransactions(provider.dayBook!.transactions));
        }, color: Colors.white, bg: const Color(0xFF64748B)),
      ],
    );
  }

  Widget _buildColumnFilterPopup(FinancialProvider provider) {
    Map<String, String> labels = {
      'sNo': 'SNo', 'date': 'Date', 'transType': 'Trans Type', 'vchNo': 'Vch No',
      'account': 'Account', 'itemName': 'Item Name', 'orderNo': 'Ord No',
      'eye': 'Eye', 'sph': 'SPH', 'cyl': 'CYL', 'axis': 'Axis', 'add': 'ADD',
      'remark': 'Remark', 'debit': 'Debit', 'credit': 'Credit', 'view': 'View'
    };

    return Material(
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 24,
      shadowColor: Colors.black.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 256,
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 8),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: const Text('TOGGLE VISIBILITY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 1.5)),
            ),
            Flexible(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: RawScrollbar(
                  thumbColor: const Color(0xFFCBD5E1),
                  radius: const Radius.circular(4),
                  thickness: 5,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: provider.dayBookVisibleColumns.keys.map((k) {
                          final isVisible = provider.dayBookVisibleColumns[k] ?? true;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: _ColumnToggleItem(
                              label: labels[k] ?? k,
                              isVisible: isVisible,
                              onToggle: () => provider.toggleDayBookColumn(k),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _btn(IconData icon, Color bg, Color text, VoidCallback onTap, {String? label, Color? iconColor}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFCBD5E1)),
          boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: iconColor ?? text),
            if (label != null) ...[const SizedBox(width: 8), Text(label, style: TextStyle(color: text, fontWeight: FontWeight.w900, fontSize: 13))],
          ],
        ),
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap, {required Color color, required Color bg}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 44, width: 44,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: bg == const Color(0xFFF1F5F9) ? const Color(0xFFE2E8F0) : Colors.transparent),
            boxShadow: bg != const Color(0xFFF1F5F9) ? [BoxShadow(color: bg.withValues(alpha: 0.2), blurRadius: 4, offset: const Offset(0, 2))] : null,
          ),
          child: Icon(icon, size: 20, color: color),
        ),
      ),
    );
  }

  Widget _buildSummaryBar() {
    final provider = context.watch<FinancialProvider>();
    final summary = provider.dayBook;
    if (summary == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _infoText('FIRM: ', _firmController.text.isEmpty ? 'ALL FIRMS' : _firmController.text.toUpperCase()),
              _divider(),
              _infoText('PERIOD: ', '${DateFormat('d/M/yyyy').format(_fromDate)} TO ${DateFormat('d/M/yyyy').format(_toDate)}'),
              _divider(),
              _infoText('TXNS: ', '${summary.transactions.length}'),
            ],
          ),
          Row(
            children: [
              _sumItem('TOTAL DEBIT: ', summary.totalDebit, const Color(0xFF16A34A)),
              const SizedBox(width: 24),
              _sumItem('TOTAL CREDIT: ', summary.totalCredit, const Color(0xFFDC2626)),
              const SizedBox(width: 24),
              _sumItem('BALANCE: ', summary.balance.abs(), summary.balance >= 0 ? const Color(0xFF16A34A) : const Color(0xFFDC2626), suffix: summary.balance >= 0 ? 'DR' : 'CR'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(width: 1, height: 12, color: const Color(0xFFCBD5E1), margin: const EdgeInsets.symmetric(horizontal: 16));

  Widget _infoText(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), letterSpacing: 0.3),
        children: [
          TextSpan(text: label),
          TextSpan(text: value, style: const TextStyle(color: Color(0xFF334155), fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _sumItem(String label, double val, Color color, {String? suffix}) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.bold),
        children: [
          TextSpan(text: label),
          TextSpan(
            text: '₹${val.toStringAsFixed(2)}${suffix != null ? " $suffix" : ""}',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildTable() {
    final provider = context.watch<FinancialProvider>();
    if (provider.isLoading) return const Center(child: CircularProgressIndicator());
    if (provider.dayBook == null) return _buildEmptyState();

    final transactions = _getFilteredTransactions(provider.dayBook!.transactions);
    final v = provider.dayBookVisibleColumns;

    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(
              builder: (context, constraints) {

                // Dynamically adjust spacing based on screen size
                final double dynamicSpacing = constraints.maxWidth < 1300 ? 8.0 : 16.0;

                return Scrollbar(
                  controller: _horizontalScrollController,
                  thumbVisibility: true,
                  trackVisibility: true,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      controller: _horizontalScrollController,
                      scrollDirection: Axis.horizontal,

                      // ConstrainedBox forces the table to stretch to the max width of the screen
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: constraints.maxWidth,
                        ),
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(const Color(0xFFE7F0F7)),
                          dataRowMinHeight: 40,
                          dataRowMaxHeight: 100,
                          columnSpacing: dynamicSpacing,
                          horizontalMargin: 12,
                          headingTextStyle: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF1E3A8A), fontSize: 13, letterSpacing: -0.2),
                          border: TableBorder.all(color: Colors.blue.shade100.withValues(alpha: 0.5), width: 0.5),
                          columns: [
                            if (v['sNo']!) const DataColumn(label: Text('SNo')),
                            if (v['date']!) const DataColumn(label: Text('Date')),
                            if (v['transType']!) const DataColumn(label: Text('Trans Type')),
                            if (v['vchNo']!) const DataColumn(label: Text('Vch No')),
                            // Expanded helps the Account column consume the extra width
                            if (v['account']!) const DataColumn(label: Expanded(child: Text('Account'))),
                            if (v['itemName']!) const DataColumn(label: Text('Item Name')),
                            if (v['orderNo']!) const DataColumn(label: Text('Ord No')),
                            if (v['eye']!) const DataColumn(label: Text('Eye')),
                            if (v['sph']!) const DataColumn(label: Text('SPH')),
                            if (v['cyl']!) const DataColumn(label: Text('CYL')),
                            if (v['axis']!) const DataColumn(label: Text('Axis')),
                            if (v['add']!) const DataColumn(label: Text('ADD')),
                            if (v['remark']!) const DataColumn(label: Text('Remark')),
                            if (v['debit']!) const DataColumn(label: Text('Debit'), numeric: true),
                            if (v['credit']!) const DataColumn(label: Text('Credit'), numeric: true),
                            const DataColumn(label: Text('View')),
                          ],
                          rows: transactions.asMap().entries.map((entry) {
                            final i = entry.key;
                            final t = entry.value;
                            return DataRow(
                              cells: [
                                if (v['sNo']!) DataCell(Text((i + 1).toString(), style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.bold))),
                                if (v['date']!) DataCell(Text(DateFormat('d/M/yyyy').format(DateTime.parse(t.date)), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500))),
                                if (v['transType']!) DataCell(_badge(t.transType)),
                                if (v['vchNo']!) DataCell(Text(t.vchNo ?? '', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, fontFamily: 'monospace'))),
                                if (v['account']!) DataCell(Text(t.account.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: Color(0xFF0F172A)))),
                                if (v['itemName']!) DataCell(_nestedItems(t.items, (it) => it.itemName)),
                                if (v['orderNo']!) DataCell(_nestedItems(t.items, (it) => it.orderNo)),
                                if (v['eye']!) DataCell(_nestedItems(t.items, (it) => it.eye, isBold: true)),
                                if (v['sph']!) DataCell(_nestedItems(t.items, (it) => it.sph, isMono: true)),
                                if (v['cyl']!) DataCell(_nestedItems(t.items, (it) => it.cyl, isMono: true)),
                                if (v['axis']!) DataCell(_nestedItems(t.items, (it) => it.axis, isMono: true)),
                                if (v['add']!) DataCell(_nestedItems(t.items, (it) => it.add, isMono: true)),
                                if (v['remark']!) DataCell(_nestedItems(t.items, (it) => it.remark, isItalic: true)),
                                if (v['debit']!) DataCell(Text(t.debit > 0 ? t.debit.toStringAsFixed(2) : '-', style: const TextStyle(color: Color(0xFF15803D), fontWeight: FontWeight.w900, fontSize: 13))),
                                if (v['credit']!) DataCell(Text(t.credit > 0 ? t.credit.toStringAsFixed(2) : '-', style: const TextStyle(color: Color(0xFFB91C1C), fontWeight: FontWeight.w900, fontSize: 13))),
                                DataCell(
                                  Center(
                                    child: IconButton(
                                      icon: const Icon(LucideIcons.eye, size: 16, color: Color(0xFF3B82F6)),
                                      onPressed: () => _viewTransaction(t),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      hoverColor: const Color(0xFFEFF6FF),
                                      splashRadius: 18,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                );
              }
          ),
        ),
        _buildStickyTotals(provider),
      ],
    );
  }

  Widget _buildStickyTotals(FinancialProvider provider) {
    final v = provider.dayBookVisibleColumns;
    final transactions = _getFilteredTransactions(provider.dayBook!.transactions);
    double totalDebit = transactions.fold(0, (sum, t) => sum + t.debit);
    double totalCredit = transactions.fold(0, (sum, t) => sum + t.credit);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        border: Border(top: BorderSide(color: Colors.blue.shade100)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text('TOTALS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 1.5)),
          const Spacer(),
          if (v['debit']!) ...[
            _sumItem('DEBIT: ', totalDebit, const Color(0xFF15803D)),
            const SizedBox(width: 32),
          ],
          if (v['credit']!) ...[
            _sumItem('CREDIT: ', totalCredit, const Color(0xFFB91C1C)),
            const SizedBox(width: 52), // Align with View column
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(LucideIcons.bookOpen, size: 80, color: Color(0xFFE2E8F0)),
          const SizedBox(height: 16),
          const Text('Search to generate Day Book', style: TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _badge(String type) {
    Color bg = const Color(0xFFEFF6FF);
    Color textCol = const Color(0xFF2563EB);

    final t = type.toUpperCase();
    if (t.contains('SALE')) {
      bg = const Color(0xFFF0FDF4);
      textCol = const Color(0xFF16A34A);
    } else if (t.contains('PURCHASE')) {
      bg = const Color(0xFFEFF6FF);
      textCol = const Color(0xFF2563EB);
    } else if (t.contains('RETURN')) {
      bg = const Color(0xFFFEF2F2);
      textCol = const Color(0xFFDC2626);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(4)),
      child: Text(t, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: textCol, letterSpacing: -0.2)),
    );
  }

  Widget _nestedItems(List<DayBookItem>? items, String? Function(DayBookItem) selector, {bool isBold = false, bool isMono = false, bool isItalic = false}) {
    if (items == null || items.isEmpty) return const Text('-', style: TextStyle(color: Colors.grey));
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((it) {
        final text = selector(it) ?? '-';
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: const Color(0xFF334155),
              fontFamily: isMono ? 'monospace' : null,
              fontStyle: isItalic ? FontStyle.italic : null,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
    );
  }

  void _viewTransaction(DayBookTransaction t) {
    final type = t.transType.toUpperCase();
    final id = t.docId;

    if (id == null) return;

    String route = '';
    if (type.contains('PURCHASE ORDER')) {
      route = '/lenstransaction/purchase/AddLensPurchaseOrder';
    } else if (type.contains('PURCHASE CHALLAN')) {
      route = '/lenstransaction/purchase/AddLensPurchaseChallan';
    } else if (type.contains('PURCHASE INVOICE')) {
      route = '/lenstransaction/purchase/AddLensPurchase';
    } else if (type.contains('SALE ORDER')) {
      route = '/lenstransaction/sale/AddLensSaleOrder';
    } else if (type.contains('SALE CHALLAN')) {
      route = '/lenstransaction/sale/AddLensSaleChallan';
    } else if (type.contains('SALE INVOICE')) {
      route = '/lenstransaction/sale/AddLensSale';
    } else if (type.contains('PAYMENT') || type.contains('RECEIPT') || type.contains('VOUCHER')) {
      route = '/transaction/add-voucher';
    } else if (type.contains('EXCHANGE')) {
      route = '/lenstransaction/add-product-exchange';
    }

    if (route.isNotEmpty) {
      context.push('$route/$id');
    }
  }

  void _exportCSV(List<DayBookTransaction> data) {
    final provider = context.read<FinancialProvider>();
    final visible = provider.dayBookVisibleColumns;

    List<List<dynamic>> rows = [];

    // Header
    List<dynamic> header = [];
    if (visible['sNo'] ?? true) header.add('SNo');
    if (visible['date'] ?? true) header.add('Date');
    if (visible['transType'] ?? true) header.add('Trans Type');
    if (visible['vchNo'] ?? true) header.add('Vch No');
    if (visible['account'] ?? true) header.add('Account');
    if (visible['itemName'] ?? true) header.add('Items');
    if (visible['debit'] ?? true) header.add('Debit');
    if (visible['credit'] ?? true) header.add('Credit');
    rows.add(header);

    for (var i = 0; i < data.length; i++) {
      final t = data[i];
      List<dynamic> row = [];
      if (visible['sNo'] ?? true) row.add(i + 1);
      if (visible['date'] ?? true) row.add(t.date);
      if (visible['transType'] ?? true) row.add(t.transType);
      if (visible['vchNo'] ?? true) row.add(t.vchNo);
      if (visible['account'] ?? true) row.add(t.account);
      if (visible['itemName'] ?? true) row.add(t.items?.map((it) => it.itemName).join(' | ') ?? '');
      if (visible['debit'] ?? true) row.add(t.debit);
      if (visible['credit'] ?? true) row.add(t.credit);
      rows.add(row);
    }

    String csvData = const ListToCsvConverter().convert(rows);
    final bytes = Uint8List.fromList(csvData.codeUnits);
    Printing.sharePdf(bytes: bytes, filename: 'DayBook_${DateFormat('yyyyMMdd').format(_fromDate)}.csv');
  }

  Future<void> _handlePrint(List<DayBookTransaction> data) async {
    final pdf = pw.Document();
    final provider = context.read<FinancialProvider>();
    final visible = provider.dayBookVisibleColumns;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (context) => [
          pw.Header(level: 0, child: pw.Text('Day Book Summary', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold))),
          pw.Paragraph(text: 'Firm: ${_firmController.text.isEmpty ? "All Firms" : _firmController.text} | Period: ${DateFormat('d/M/yyyy').format(_fromDate)} to ${DateFormat('d/M/yyyy').format(_toDate)}'),
          pw.TableHelper.fromTextArray(
            headers: [
              if (visible['sNo'] ?? true) 'SNo',
              if (visible['date'] ?? true) 'Date',
              if (visible['transType'] ?? true) 'Type',
              if (visible['vchNo'] ?? true) 'VchNo',
              if (visible['account'] ?? true) 'Account',
              if (visible['debit'] ?? true) 'Debit',
              if (visible['credit'] ?? true) 'Credit',
            ],
            data: data.asMap().entries.map((e) {
              final t = e.value;
              return [
                if (visible['sNo'] ?? true) e.key + 1,
                if (visible['date'] ?? true) t.date,
                if (visible['transType'] ?? true) t.transType,
                if (visible['vchNo'] ?? true) t.vchNo ?? '',
                if (visible['account'] ?? true) t.account,
                if (visible['debit'] ?? true) t.debit.toStringAsFixed(2),
                if (visible['credit'] ?? true) t.credit.toStringAsFixed(2),
              ];
            }).toList(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            cellAlignment: pw.Alignment.centerLeft,
          ),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }
}

class _ColumnToggleItem extends StatefulWidget {
  final String label;
  final bool isVisible;
  final VoidCallback onToggle;

  const _ColumnToggleItem({
    required this.label,
    required this.isVisible,
    required this.onToggle,
  });

  @override
  State<_ColumnToggleItem> createState() => _ColumnToggleItemState();
}

class _ColumnToggleItemState extends State<_ColumnToggleItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onToggle,
          borderRadius: BorderRadius.circular(8),
          hoverColor: const Color(0xFFEFF6FF), // blue-50
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: _isHovered ? const Color(0xFFEFF6FF) : Colors.transparent,
            ),
            child: Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: widget.isVisible ? const Color(0xFF2563EB) : Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: widget.isVisible ? const Color(0xFF2563EB) : const Color(0xFFCBD5E1),
                      width: 1.5,
                    ),
                  ),
                  child: widget.isVisible
                      ? const Center(child: Icon(Icons.check, size: 13, color: Colors.white))
                      : null,
                ),
                const SizedBox(width: 12),
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _isHovered ? const Color(0xFF1D4ED8) : const Color(0xFF334155),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}