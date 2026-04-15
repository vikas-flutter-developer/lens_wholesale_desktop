import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:csv/csv.dart';
import 'package:printing/printing.dart';
import 'dart:typed_data';

import '../../data/providers/financial_provider.dart';
import '../../data/models/financial_models.dart';
import '../../../masters/data/providers/account_provider.dart';
import '../../../masters/data/models/account_model.dart';

class CollectionReportPage extends StatefulWidget {
  const CollectionReportPage({super.key});

  @override
  State<CollectionReportPage> createState() => _CollectionReportPageState();
}

class _CollectionReportPageState extends State<CollectionReportPage> {
  String _reportBy = 'Date Wise';
  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now();
  DateTime _fromMonth = DateTime.now();
  DateTime _toMonth = DateTime.now();
  String _firmName = '';
  List<String> _selectedTransTypes = [
    'Sale', 'Sale Order', 'Sale Challan',
    'Purchase', 'Purchase Order', 'Purchase Challan',
    'Damage and Shrinkage'
  ];

  final List<String> _availableTransTypes = [
    'Sale', 'Sale Order', 'Sale Challan',
    'Purchase', 'Purchase Order', 'Purchase Challan',
    'Damage and Shrinkage'
  ];

  // Added ScrollController for horizontal scrolling
  final ScrollController _horizontalScrollController = ScrollController();

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
    // Properly dispose the scroll controller
    _horizontalScrollController.dispose();
    super.dispose();
  }

  Future<void> _handleSearch() async {
    final provider = context.read<FinancialProvider>();
    Map<String, dynamic> filters = {
      'firmName': _firmName,
      'reportBy': _reportBy,
      'transTypes': _selectedTransTypes,
    };

    if (_reportBy == 'Month Wise') {
      filters['monthFrom'] = "${DateFormat('yyyy-MM').format(_fromMonth)}-01";
      filters['monthTo'] = "${DateFormat('yyyy-MM').format(_toMonth)}-01";
    } else {
      filters['dateFrom'] = DateFormat('yyyy-MM-dd').format(_fromDate);
      filters['dateTo'] = DateFormat('yyyy-MM-dd').format(_toDate);
    }

    await provider.fetchCollectionReport(filters);
  }

  void _exportCSV(CollectionReport data) {
    List<List<dynamic>> rows = [];
    rows.add(['AMOUNT COLLECTION REPORT']);
    rows.add(['Period:', _reportBy == 'Month Wise'
        ? '${DateFormat('MMM yyyy').format(_fromMonth)} to ${DateFormat('MMM yyyy').format(_toMonth)}'
        : '${DateFormat('dd/MM/yyyy').format(_fromDate)} to ${DateFormat('dd/MM/yyyy').format(_toDate)}'
    ]);
    rows.add([]);
    rows.add(['Date/Month', 'Total Business', 'Cash Dr', 'Cash Cr', 'Bank Dr', 'Bank Cr', 'Oth Dr', 'Oth Cr', 'Balance']);

    for (var r in data.reportData) {
      rows.add([
        r.date, r.totalBusiness, r.cashDr, r.cashCr, r.bankDr, r.bankCr, r.othDr, r.othCr, r.balance
      ]);
    }

    rows.add(['GRAND TOTALS', data.totalBusiness, data.totalCashDr, data.totalCashCr, data.totalBankDr, data.totalBankCr, '', '', '']);

    String csvData = const ListToCsvConverter().convert(rows);
    Printing.sharePdf(bytes: Uint8List.fromList(csvData.codeUnits), filename: 'collection_report.csv');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildHeader(),
          _buildFilters(),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF4338CA)]),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10)),
            child: const Icon(LucideIcons.briefcase, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('AMOUNT COLLECTION REPORT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 0.5)),
              Text('Financial Inflow & Outflow Analysis', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
            ],
          ),
          const Spacer(),
          _headerAction(LucideIcons.fileSpreadsheet, const Color(0xFF10B981), () {
            final provider = context.read<FinancialProvider>();
            if (provider.collectionReport != null) {
              _exportCSV(provider.collectionReport!);
            }
          }),
          const SizedBox(width: 8),
          _headerAction(LucideIcons.printer, Colors.white, () {}),
          const SizedBox(width: 8),
          _headerAction(LucideIcons.rotateCcw, Colors.white, () {
            setState(() {
              _reportBy = 'Date Wise';
              _fromDate = DateTime.now();
              _toDate = DateTime.now();
              _firmName = '';
              _selectedTransTypes = List.from(_availableTransTypes);
            });
            _handleSearch();
          }),
        ],
      ),
    );
  }

  Widget _headerAction(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(flex: 2, child: _filterCol('FIRM NAME', _buildFirmAutocomplete())),
              const SizedBox(width: 16),
              _filterCol('REPORT BY', _buildReportByDropdown()),
              const SizedBox(width: 16),
              if (_reportBy == 'Month Wise') ...[
                _filterCol('MONTH FROM', _monthBtn(_fromMonth, (d) => setState(() => _fromMonth = d))),
                const SizedBox(width: 16),
                _filterCol('MONTH TO', _monthBtn(_toMonth, (d) => setState(() => _toMonth = d))),
              ] else ...[
                _filterCol('DATE FROM', _dateBtn(_fromDate, (d) => setState(() => _fromDate = d))),
                const SizedBox(width: 16),
                _filterCol('DATE TO', _dateBtn(_toDate, (d) => setState(() => _toDate = d))),
              ],
              const SizedBox(width: 16),
              _filterCol('TRANS TYPE', _buildTransTypeBtn()),
              const SizedBox(width: 16),
              _buildSearchButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _filterCol(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF64748B), letterSpacing: 1.5)),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildFirmAutocomplete() {
    final providers = context.watch<AccountProvider>();
    return Autocomplete<AccountModel>(
      optionsBuilder: (TextEditingValue val) {
        if (val.text.isEmpty) return providers.accounts.take(20);
        return providers.accounts.where((a) => a.name.toLowerCase().contains(val.text.toLowerCase())).take(20);
      },
      displayStringForOption: (a) => a.name,
      onSelected: (a) => setState(() => _firmName = a.name),
      fieldViewBuilder: (ctx, ctrl, focus, onFieldSubmitted) {
        return TextField(
          controller: ctrl,
          focusNode: focus,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            hintText: 'All Firms',
            filled: true, fillColor: const Color(0xFFF1F5F9),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          ),
          onChanged: (val) {
            if (val.isEmpty) {
              setState(() => _firmName = '');
            }
          },
        );
      },
    );
  }

  Widget _buildReportByDropdown() {
    return Container(
      width: 130, padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _reportBy,
          items: ['All', 'Date Wise', 'Month Wise'].map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)))).toList(),
          onChanged: (v) => setState(() => _reportBy = v!),
        ),
      ),
    );
  }

  Widget _dateBtn(DateTime d, Function(DateTime) onSelect) {
    return InkWell(
      onTap: () async {
        final res = await showDatePicker(context: context, initialDate: d, firstDate: DateTime(2000), lastDate: DateTime(2100));
        if (res != null) onSelect(res);
      },
      child: Container(
        width: 140, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
        child: Row(children: [Text(DateFormat('dd-MM-yyyy').format(d), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)), const Spacer(), const Icon(LucideIcons.calendar, size: 16, color: Colors.indigo)]),
      ),
    );
  }

  Widget _monthBtn(DateTime d, Function(DateTime) onSelect) {
    return InkWell(
      onTap: () async {
        final res = await showDatePicker(
          context: context,
          initialDate: d,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          initialDatePickerMode: DatePickerMode.year,
        );
        if (res != null) onSelect(DateTime(res.year, res.month));
      },
      child: Container(
        width: 140, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
        child: Row(children: [Text(DateFormat('MMM yyyy').format(d), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)), const Spacer(), const Icon(LucideIcons.calendar, size: 16, color: Colors.indigo)]),
      ),
    );
  }

  Widget _buildTransTypeBtn() {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (ctx) => StatefulBuilder(
            builder: (ctx, setS) => AlertDialog(
              title: const Text('Select Transaction Types', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: _availableTransTypes.map((t) => CheckboxListTile(
                  title: Text(t, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  value: _selectedTransTypes.contains(t),
                  onChanged: (v) {
                    setS(() {
                      if (v!) _selectedTransTypes.add(t);
                      else _selectedTransTypes.remove(t);
                    });
                    setState(() {});
                  },
                )).toList(),
              ),
              actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('DONE', style: TextStyle(fontWeight: FontWeight.bold)))],
            ),
          ),
        );
      },
      child: Container(
        width: 150, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
        child: Row(children: [
          Expanded(child: Text('${_selectedTransTypes.length} Selected', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis)),
          const Icon(LucideIcons.chevronDown, size: 16, color: Colors.blueGrey),
        ]),
      ),
    );
  }

  Widget _buildSearchButton() {
    final provider = context.watch<FinancialProvider>();
    return SizedBox(
      height: 48,
      child: ElevatedButton.icon(
        onPressed: provider.isLoading ? null : _handleSearch,
        icon: provider.isLoading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(LucideIcons.search, size: 16),
        label: const Text('SEARCH', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.5)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4F46E5),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          elevation: 4,
        ),
      ),
    );
  }

  Widget _buildContent() {
    final provider = context.watch<FinancialProvider>();
    if (provider.isLoading) return const Center(child: CircularProgressIndicator());
    final data = provider.collectionReport;
    if (data == null || data.reportData.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.search, size: 64, color: Colors.blueGrey.shade100),
            const SizedBox(height: 16),
            const Text('No collection data found', style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 18)),
            const Text('Adjust filters and search again', style: TextStyle(color: Colors.grey, fontSize: 13)),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Expanded(
              // Method 1 Native Fix applied here: LayoutBuilder -> Scrollbar -> Vertical Scroll -> Horizontal Scroll -> ConstrainedBox -> DataTable
              child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Dynamic column spacing based on screen width
                    final double dynamicSpacing = constraints.maxWidth < 1000 ? 16.0 : 32.0;

                    return Scrollbar(
                      controller: _horizontalScrollController,
                      thumbVisibility: true,
                      trackVisibility: true,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          controller: _horizontalScrollController,
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              // Forces the table to stretch to at least the full container width
                              minWidth: constraints.maxWidth,
                            ),
                            child: DataTable(
                              headingRowHeight: 52,
                              dataRowMaxHeight: 64,
                              headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                              columnSpacing: dynamicSpacing, // Use dynamic spacing
                              columns: [
                                _col('DATE / MONTH'),
                                _col('TOTAL BUSINESS'),
                                _col('CASH DR', color: const Color(0xFF059669)),
                                _col('CASH CR', color: const Color(0xFFE11D48)),
                                _col('BANK DR', color: const Color(0xFF4F46E5)),
                                _col('BANK CR', color: const Color(0xFFD97706)),
                                _col('OTH DR'),
                                _col('OTH CR'),
                                _col('BAL.'),
                              ],
                              rows: data.reportData.map((r) => DataRow(cells: [
                                DataCell(Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(r.date, style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
                                    if (_reportBy == 'All' && r.firmName != null)
                                      Text(r.firmName!, style: const TextStyle(fontSize: 9, color: Colors.indigo, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                                  ],
                                )),
                                DataCell(Text('₹${_f(r.totalBusiness)}', style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF0F172A)))),
                                DataCell(Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(color: const Color(0xFF059669).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                                  child: Text(r.cashDr > 0 ? '₹${_f(r.cashDr)}' : '-', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF059669))),
                                )),
                                DataCell(Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(color: const Color(0xFFE11D48).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                                  child: Text(r.cashCr > 0 ? '₹${_f(r.cashCr)}' : '-', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE11D48))),
                                )),
                                DataCell(Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(color: const Color(0xFF4F46E5).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                                  child: Text(r.bankDr > 0 ? '₹${_f(r.bankDr)}' : '-', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4F46E5))),
                                )),
                                DataCell(Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(color: const Color(0xFFD97706).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                                  child: Text(r.bankCr > 0 ? '₹${_f(r.bankCr)}' : '-', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFD97706))),
                                )),
                                DataCell(Text('₹${_f(r.othDr)}', style: const TextStyle(color: Colors.blueGrey, fontSize: 12))),
                                DataCell(Text('₹${_f(r.othCr)}', style: const TextStyle(color: Colors.blueGrey, fontSize: 12))),
                                DataCell(Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: r.balance.contains('Dr') ? const Color(0xFF059669).withValues(alpha: 0.2) : const Color(0xFFE11D48).withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(r.balance, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: r.balance.contains('Dr') ? const Color(0xFF064E3B) : const Color(0xFF9F1239))),
                                )),
                              ])).toList(),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
              ),
            ),
            _buildFooter(data),
          ],
        ),
      ),
    );
  }

  // Updated DataColumn helper utilizing 'Expanded' to dynamically size the columns
  // along with ConstrainedBox minWidth from LayoutBuilder above.
  DataColumn _col(String label, {Color? color}) {
    return DataColumn(
      label: Expanded(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: color ?? const Color(0xFF64748B),
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(CollectionReport data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      color: const Color(0xFF0F172A),
      child: Row(
        children: [
          const Text('GRAND TOTALS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 2)),
          const Spacer(),
          _footerItem('Business', data.totalBusiness, Colors.white),
          const SizedBox(width: 40),
          _footerItem('Cash Dr', data.totalCashDr, const Color(0xFF10B981)),
          const SizedBox(width: 40),
          _footerItem('Cash Cr', data.totalCashCr, const Color(0xFFF43F5E)),
          const SizedBox(width: 40),
          _footerItem('Bank Dr', data.totalBankDr, const Color(0xFF6366F1)),
          const SizedBox(width: 40),
          _footerItem('Bank Cr', data.totalBankCr, const Color(0xFFF59E0B)),
        ],
      ),
    );
  }

  Widget _footerItem(String label, double val, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label.toUpperCase(), style: TextStyle(color: color.withValues(alpha: 0.5), fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 1)),
        Text('₹${_f(val)}', style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 15)),
      ],
    );
  }

  String _f(double v) => NumberFormat('#,##,##0.00').format(v);
}