import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:io';
import '../../data/providers/transaction_report_provider.dart';
import '../../../masters/data/providers/inventory_providers.dart';
import '../../data/models/transaction_report_models.dart';
import 'package:excel/excel.dart' as xl;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';


class TransactionSummaryPage extends StatefulWidget {
  const TransactionSummaryPage({super.key});

  @override
  State<TransactionSummaryPage> createState() => _TransactionSummaryPageState();
}

class _TransactionSummaryPageState extends State<TransactionSummaryPage> {
  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now();
  String _groupName = '';
  String _itemName = '';
  String _transType = 'All';
  final TextEditingController _seriesCtrl = TextEditingController();
  final TextEditingController _searchCtrl = TextEditingController();

  final Map<String, bool> _activeCols = {
    'SNo': true, 'Date': true, 'Particulars': true, 'Vch No': true, 
    'Trans Type': true, 'Mobile No': true, 'Gross': true, 
    'Paid': true, 'Due': true,
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ItemGroupProvider>().fetchGroups();
      context.read<ItemMasterProvider>().fetchItems();
      _handleSearch();
    });
  }

  void _handleSearch() {
    final params = {
      'dateFrom': DateFormat('yyyy-MM-dd').format(_fromDate),
      'dateTo': DateFormat('yyyy-MM-dd').format(_toDate),
      'transType': _transType == 'All' ? '' : _transType,
      'groupName': _groupName,
      'itemName': _itemName,
      'searchText': _searchCtrl.text,
    };
    context.read<TransactionReportProvider>().fetchSummaries(params);
  }

  void _resetFilters() {
    setState(() {
      _fromDate = DateTime.now();
      _toDate = DateTime.now();
      _groupName = '';
      _itemName = '';
      _transType = 'All';
      _seriesCtrl.clear();
      _searchCtrl.clear();
    });
    _handleSearch();
  }

  void _showColumnSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Select Columns', style: TextStyle(fontWeight: FontWeight.bold)),
              content: SizedBox(
                width: 300,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _activeCols.keys.map((col) {
                      return CheckboxListTile(
                        title: Text(col),
                        value: _activeCols[col],
                        onChanged: (val) {
                          setState(() => _activeCols[col] = val ?? false);
                          setDialogState(() {});
                        },
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                      );
                    }).toList(),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _exportToExcel() async {
    final provider = context.read<TransactionReportProvider>();
    if (provider.summaries.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No data to export')));
      return;
    }

    try {
      var excel = xl.Excel.createExcel();
      xl.Sheet sheetObject = excel['TransactionSummary'];
      
      List<xl.CellValue> headers = _activeCols.entries
          .where((e) => e.value)
          .map((e) => xl.TextCellValue(e.key))
          .toList();
      sheetObject.appendRow(headers);

      for (int i = 0; i < provider.summaries.length; i++) {
        final item = provider.summaries[i];
        List<xl.CellValue> row = [];
        if (_activeCols['SNo']!) row.add(xl.IntCellValue(i + 1));
        if (_activeCols['Date']!) row.add(xl.TextCellValue(item.date ?? ''));
        if (_activeCols['Particulars']!) row.add(xl.TextCellValue(item.partyName ?? ''));
        if (_activeCols['Vch No']!) row.add(xl.TextCellValue(item.vchNo ?? ''));
        if (_activeCols['Trans Type']!) row.add(xl.TextCellValue(item.transactionType ?? ''));
        if (_activeCols['Mobile No']!) row.add(xl.TextCellValue(item.mobileNo ?? ''));
        if (_activeCols['Gross']!) row.add(xl.DoubleCellValue(item.totalBasic));
        if (_activeCols['Paid']!) row.add(xl.DoubleCellValue(item.taxAmt));
        if (_activeCols['Due']!) row.add(xl.DoubleCellValue(item.netAmt));
        sheetObject.appendRow(row);
      }

      String? outputFile = await FilePicker.saveFile(
        dialogTitle: 'Save Excel File',
        fileName: 'TransactionSummary.xlsx',
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );


      if (outputFile != null) {
        final bytes = excel.encode();
        if (bytes != null) {
          File(outputFile).writeAsBytesSync(bytes);
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Excel exported successfully!')));
        }
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _printReport() async {
    final provider = context.read<TransactionReportProvider>();
    if (provider.summaries.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No data to print')));
      return;
    }

    final pdf = pw.Document();
    final headers = _activeCols.entries.where((e) => e.value).map((e) => e.key).toList();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (pw.Context context) {
          return [
            pw.Header(level: 0, child: pw.Text('Transaction Summary Report', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold))),
            pw.SizedBox(height: 10),
            pw.TableHelper.fromTextArray(
              headers: headers,
              data: provider.summaries.asMap().entries.map((entry) {
                final i = entry.key;
                final item = entry.value;
                List<String> row = [];
                if (_activeCols['SNo']!) row.add('${i + 1}');
                if (_activeCols['Date']!) row.add(item.date ?? '');
                if (_activeCols['Particulars']!) row.add(item.partyName ?? '');
                if (_activeCols['Vch No']!) row.add(item.vchNo ?? '');
                if (_activeCols['Trans Type']!) row.add(item.transactionType ?? '');
                if (_activeCols['Mobile No']!) row.add(item.mobileNo ?? '');
                if (_activeCols['Gross']!) row.add(item.totalBasic.toStringAsFixed(2));
                if (_activeCols['Paid']!) row.add(item.taxAmt.toStringAsFixed(2));
                if (_activeCols['Due']!) row.add(item.netAmt.toStringAsFixed(2));
                return row;
              }).toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
              cellStyle: const pw.TextStyle(fontSize: 9),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFilterCard(),
        const Divider(height: 1, color: Color(0xFFE2E8F0)),
        Expanded(
          child: Consumer<TransactionReportProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) return const Center(child: CircularProgressIndicator());
              if (provider.summaries.isEmpty) return const Center(child: Text('No records found', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)));
              return _buildNativeDataTable(provider.summaries);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(flex: 3, child: _filterField('GROUP NAME', _groupDropdown())),
              const SizedBox(width: 8),
              Expanded(flex: 3, child: _filterField('ITEM NAME', _itemDropdown())),
              const SizedBox(width: 8),
              Expanded(flex: 2, child: _filterField('Trans Type', _typeDropdown())),
              const SizedBox(width: 8),
              Expanded(flex: 2, child: _filterField('Bill Series', _textField(_seriesCtrl, 'Series'))),
              const SizedBox(width: 8),
              Expanded(flex: 2, child: _filterField('Date From', _datePicker(_fromDate, (d) => setState(() => _fromDate = d)))),
              const SizedBox(width: 8),
              Expanded(flex: 2, child: _filterField('To', _datePicker(_toDate, (d) => setState(() => _toDate = d)))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _textField(_searchCtrl, 'Search Any Text')),
              const SizedBox(width: 12),
              _actionOutlineButton(onPressed: _showColumnSelectionDialog, icon: LucideIcons.layout, label: 'Columns (${_activeCols.values.where((v) => v).length})'),
              const SizedBox(width: 8),
              _iconButton(LucideIcons.check, _handleSearch, Colors.green, size: 36),
              const SizedBox(width: 8),
              _actionButton(onPressed: _handleSearch, label: 'Search', color: const Color(0xFF2563EB), textColor: Colors.white),
              const SizedBox(width: 8),
              _iconButton(LucideIcons.rotateCcw, _resetFilters, const Color(0xFF06B6D4), size: 36),
              const SizedBox(width: 8),
              _iconButton(LucideIcons.fileSpreadsheet, _exportToExcel, const Color(0xFF3B82F6), size: 36),
              const SizedBox(width: 8),
              _iconButton(LucideIcons.printer, _printReport, const Color(0xFF64748B), size: 36),

            ],
          ),
        ],
      ),
    );
  }

  // Method 1: The Native Fix
  Widget _buildNativeDataTable(List<TransactionSummary> data) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Dynamic column spacing to fit screen
        final double columnSpacing = constraints.maxWidth < 1000 ? 20.0 : (constraints.maxWidth - 900) / 9;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: DataTable(
              columnSpacing: columnSpacing.clamp(10.0, 60.0),
              headingRowHeight: 40,
              dataRowMinHeight: 48,
              dataRowMaxHeight: 48,
              headingRowColor: WidgetStateProperty.all(const Color(0xFFF1F5F9)),

              border: TableBorder.all(color: const Color(0xFFE2E8F0), width: 0.5),
              columns: [
                if (_activeCols['SNo']!) const DataColumn(label: Text('SNo', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)))),
                if (_activeCols['Date']!) const DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)))),
                if (_activeCols['Particulars']!) const DataColumn(label: Text('Particulars', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)))),
                if (_activeCols['Vch No']!) const DataColumn(label: Text('Vch No', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)))),
                if (_activeCols['Trans Type']!) const DataColumn(label: Text('Trans Type', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)))),
                if (_activeCols['Mobile No']!) const DataColumn(label: Text('Mobile No', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)))),
                if (_activeCols['Gross']!) const DataColumn(label: Text('Gross', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))), numeric: true),
                if (_activeCols['Paid']!) const DataColumn(label: Text('Paid', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))), numeric: true),
                if (_activeCols['Due']!) const DataColumn(label: Text('Due', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)), numeric: true),
              ],
              rows: [
                ...data.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return DataRow(
                    cells: [
                      if (_activeCols['SNo']!) DataCell(Text('${index + 1}')),
                      if (_activeCols['Date']!) DataCell(Text(item.date ?? '-')),
                      if (_activeCols['Particulars']!) DataCell(Text(item.partyName ?? '-', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2563EB)))),
                      if (_activeCols['Vch No']!) DataCell(Text(item.vchNo ?? '-', style: const TextStyle(fontWeight: FontWeight.bold))),
                      if (_activeCols['Trans Type']!) DataCell(Text(item.transactionType ?? '-')),
                      if (_activeCols['Mobile No']!) DataCell(Text(item.mobileNo ?? '-')),
                      if (_activeCols['Gross']!) DataCell(Text(item.totalBasic.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold))),
                      if (_activeCols['Paid']!) DataCell(Text(item.taxAmt.toStringAsFixed(2))),
                      if (_activeCols['Due']!) DataCell(Text(item.netAmt.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red))),
                    ],
                  );
                }),
                // Footer Row as an extra DataRow
                DataRow(
                  color: WidgetStateProperty.all(const Color(0xFFF1F5F9)),

                  cells: [
                    if (_activeCols['SNo']!) const DataCell(SizedBox()),
                    if (_activeCols['Date']!) const DataCell(SizedBox()),
                    if (_activeCols['Particulars']!) const DataCell(Text('TOTALS:', style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF1E3A8A)))),
                    if (_activeCols['Vch No']!) const DataCell(SizedBox()),
                    if (_activeCols['Trans Type']!) const DataCell(SizedBox()),
                    if (_activeCols['Mobile No']!) const DataCell(SizedBox()),
                    if (_activeCols['Gross']!) DataCell(Text(data.fold(0.0, (s, i) => s + i.totalBasic).toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.w900))),
                    if (_activeCols['Paid']!) DataCell(Text(data.fold(0.0, (s, i) => s + i.taxAmt).toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.w900))),
                    if (_activeCols['Due']!) DataCell(Text(data.fold(0.0, (s, i) => s + i.netAmt).toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.red))),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _filterField(String label, Widget child) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label.toUpperCase(), style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8))), const SizedBox(height: 6), child]);
  }

  Widget _groupDropdown() {
    return Consumer<ItemGroupProvider>(builder: (context, provider, _) => Container(height: 38, padding: const EdgeInsets.symmetric(horizontal: 12), decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE2E8F0)), borderRadius: BorderRadius.circular(8)), child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: _groupName.isEmpty ? null : _groupName, isExpanded: true, isDense: true, items: [const DropdownMenuItem(value: '', child: Text('SELECT GROUP', style: TextStyle(fontSize: 11))), ...provider.groups.map((g) => DropdownMenuItem(value: g.groupName, child: Text(g.groupName, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold))))], onChanged: (v) => setState(() { _groupName = v ?? ''; _itemName = ''; })))));
  }

  Widget _itemDropdown() {
    return Consumer<ItemMasterProvider>(builder: (context, provider, _) => Container(height: 38, padding: const EdgeInsets.symmetric(horizontal: 12), decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE2E8F0)), borderRadius: BorderRadius.circular(8)), child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: _itemName.isEmpty ? null : _itemName, isExpanded: true, isDense: true, items: [const DropdownMenuItem(value: '', child: Text('SELECT ITEM', style: TextStyle(fontSize: 11))), ...provider.items.where((it) => _groupName.isEmpty || it.groupName == _groupName).map((it) => DropdownMenuItem(value: it.itemName, child: Text(it.itemName, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold))))], onChanged: (v) => setState(() => _itemName = v ?? '')))));
  }

  Widget _typeDropdown() {
    return Container(height: 38, padding: const EdgeInsets.symmetric(horizontal: 12), decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE2E8F0)), borderRadius: BorderRadius.circular(8)), child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: _transType, isExpanded: true, isDense: true, items: ['All', 'Sale', 'Purchase', 'Sale Return', 'Purchase Return'].map((opt) => DropdownMenuItem(value: opt, child: Text(opt.toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))))).toList(), onChanged: (v) => setState(() => _transType = v ?? 'All'))));
  }

  Widget _textField(TextEditingController ctrl, String hint) {
    return Container(height: 38, decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE2E8F0)), borderRadius: BorderRadius.circular(8)), child: TextField(controller: ctrl, decoration: InputDecoration(hintText: hint, isDense: true, contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), border: InputBorder.none), style: const TextStyle(fontSize: 12)));
  }

  Widget _datePicker(DateTime date, Function(DateTime) onPicked) {
    return InkWell(onTap: () async { final d = await showDatePicker(context: context, initialDate: date, firstDate: DateTime(2000), lastDate: DateTime(2100)); if (d != null) onPicked(d); }, child: Container(height: 38, padding: const EdgeInsets.symmetric(horizontal: 8), decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE2E8F0)), borderRadius: BorderRadius.circular(8)), child: Row(children: [Text(DateFormat('dd-MM-yyyy').format(date), style: const TextStyle(fontSize: 11)), const Spacer(), const Icon(LucideIcons.calendar, size: 12, color: Color(0xFF64748B))])));
  }

  Widget _actionButton({required VoidCallback onPressed, String? label, Color? color, Color? textColor}) {
    return ElevatedButton(onPressed: onPressed, style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: textColor, elevation: 0, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: Text(label ?? '', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13)));
  }

  Widget _actionOutlineButton({required VoidCallback onPressed, required IconData icon, required String label}) {
    return OutlinedButton.icon(onPressed: onPressed, icon: Icon(icon, size: 14), label: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)), style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFF475569), side: const BorderSide(color: Color(0xFFE2E8F0)), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))));
  }

  Widget _iconButton(IconData icon, VoidCallback onPressed, Color color, {double size = 42}) {
    return Container(width: size, height: size, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)), child: IconButton(icon: Icon(icon, color: Colors.white, size: 18), onPressed: onPressed, padding: EdgeInsets.zero));
  }
}
