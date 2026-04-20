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


class TransactionDetailPage extends StatefulWidget {
  const TransactionDetailPage({super.key});

  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now();
  String _groupName = '';
  String _itemName = '';
  String _transType = 'All';
  final TextEditingController _searchController = TextEditingController();

  final Map<String, bool> _activeCols = {
    'SNo': true, 'Date': true, 'Vch No': true, 'Party Name': true, 'Mob.No': true,
    'Group': true, 'Product': true, 'MODEL NO.': true, 'SIZE': true, 'COLOR': true,
    'Item Detail': true, 'Qty': true, 'Price': true, 'Ttl Prc': true, 'Dis Amt': true,
    'Ttl Price': true, 'GstWise Amt': true, 'Due Amt': true, 'View': true,
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
      'searchText': _searchController.text,
    };
    context.read<TransactionReportProvider>().fetchDetails(params);
  }

  void _resetFilters() {
    setState(() {
      _fromDate = DateTime.now();
      _toDate = DateTime.now();
      _groupName = '';
      _itemName = '';
      _transType = 'All';
      _searchController.clear();
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
    if (provider.details.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No data to export')));
      return;
    }

    try {
      var excel = xl.Excel.createExcel();
      xl.Sheet sheetObject = excel['TransactionDetails'];
      
      // Header
      List<xl.CellValue> headers = _activeCols.entries
          .where((e) => e.value && e.key != 'View')
          .map((e) => xl.TextCellValue(e.key))
          .toList();
      sheetObject.appendRow(headers);

      // Data
      for (int i = 0; i < provider.details.length; i++) {
        final item = provider.details[i];
        List<xl.CellValue> row = [];
        if (_activeCols['SNo']!) row.add(xl.IntCellValue(i + 1));
        if (_activeCols['Date']!) row.add(xl.TextCellValue(item.date ?? ''));
        if (_activeCols['Vch No']!) row.add(xl.TextCellValue(item.vchNo ?? ''));
        if (_activeCols['Party Name']!) row.add(xl.TextCellValue(item.partyName ?? ''));
        if (_activeCols['Mob.No']!) row.add(xl.TextCellValue(item.mobileNo ?? ''));
        if (_activeCols['Group']!) row.add(xl.TextCellValue(item.groupName ?? ''));
        if (_activeCols['Product']!) row.add(xl.TextCellValue(item.productName ?? ''));
        if (_activeCols['MODEL NO.']!) row.add(xl.TextCellValue(item.modelNo ?? ''));
        if (_activeCols['SIZE']!) row.add(xl.TextCellValue(item.size ?? ''));
        if (_activeCols['COLOR']!) row.add(xl.TextCellValue(item.color ?? ''));
        if (_activeCols['Item Detail']!) row.add(xl.TextCellValue(item.itemDetail ?? ''));
        if (_activeCols['Qty']!) row.add(xl.DoubleCellValue(item.qty));
        if (_activeCols['Price']!) row.add(xl.DoubleCellValue(item.price));
        if (_activeCols['Ttl Prc']!) row.add(xl.DoubleCellValue(item.totalBasic));
        if (_activeCols['Dis Amt']!) row.add(xl.DoubleCellValue(item.discountAmt));
        if (_activeCols['Ttl Price']!) row.add(xl.DoubleCellValue(item.netAmt));
        if (_activeCols['GstWise Amt']!) row.add(xl.DoubleCellValue(item.taxAmt));
        if (_activeCols['Due Amt']!) row.add(xl.DoubleCellValue(item.dueAmt));
        sheetObject.appendRow(row);
      }

      String? outputFile = await FilePicker.saveFile(
        dialogTitle: 'Save Excel File',
        fileName: 'TransactionDetails.xlsx',
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );


      if (outputFile != null) {
        final bytes = excel.encode();
        if (bytes != null) {
          File(outputFile).writeAsBytesSync(bytes);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Excel exported successfully!')));
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error exporting excel: $e')));
      }
    }
  }

  Future<void> _printReport() async {
    final provider = context.read<TransactionReportProvider>();
    if (provider.details.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No data to print')));
      return;
    }

    final pdf = pw.Document();
    
    // Only includes visible columns (excluding View)
    final headers = _activeCols.entries.where((e) => e.value && e.key != 'View').map((e) => e.key).toList();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (pw.Context context) {
          return [
            pw.Header(level: 0, child: pw.Text('Transaction Detail Report', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold))),
            pw.SizedBox(height: 10),
            pw.TableHelper.fromTextArray(
              headers: headers,
              data: provider.details.asMap().entries.map((entry) {
                final i = entry.key;
                final item = entry.value;
                List<String> row = [];
                if (_activeCols['SNo']!) row.add('${i + 1}');
                if (_activeCols['Date']!) row.add(item.date ?? '');
                if (_activeCols['Vch No']!) row.add(item.vchNo ?? '');
                if (_activeCols['Party Name']!) row.add(item.partyName ?? '');
                if (_activeCols['Mob.No']!) row.add(item.mobileNo ?? '');
                if (_activeCols['Group']!) row.add(item.groupName ?? '');
                if (_activeCols['Product']!) row.add(item.productName ?? '');
                if (_activeCols['MODEL NO.']!) row.add(item.modelNo ?? '');
                if (_activeCols['SIZE']!) row.add(item.size ?? '');
                if (_activeCols['COLOR']!) row.add(item.color ?? '');
                if (_activeCols['Item Detail']!) row.add(item.itemDetail ?? '');
                if (_activeCols['Qty']!) row.add(item.qty.toStringAsFixed(1));
                if (_activeCols['Price']!) row.add(item.price.toStringAsFixed(0));
                if (_activeCols['Ttl Prc']!) row.add(item.totalBasic.toStringAsFixed(0));
                if (_activeCols['Dis Amt']!) row.add(item.discountAmt.toStringAsFixed(0));
                if (_activeCols['Ttl Price']!) row.add(item.netAmt.toStringAsFixed(0));
                if (_activeCols['GstWise Amt']!) row.add(item.taxAmt.toStringAsFixed(0));
                if (_activeCols['Due Amt']!) row.add(item.dueAmt.toStringAsFixed(0));
                return row;
              }).toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
              cellStyle: const pw.TextStyle(fontSize: 7),
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
              if (provider.details.isEmpty) return const Center(child: Text('No transaction details found', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)));
              return _buildNativeDataTable(provider.details);
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
              Expanded(flex: 2, child: _filterField('Bill Series', _textField(TextEditingController(text: 'All'), 'Series'))),
              const SizedBox(width: 8),
              Expanded(flex: 2, child: _filterField('Date From', _datePicker(_fromDate, (d) => setState(() => _fromDate = d)))),
              const SizedBox(width: 8),
              Expanded(flex: 2, child: _filterField('To', _datePicker(_toDate, (d) => setState(() => _toDate = d)))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _textField(_searchController, 'Search Any Text')),
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

  Widget _buildNativeDataTable(List<TransactionDetail> data) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double initialWidth = 1650.0;
        final double tableWidth = constraints.maxWidth < initialWidth ? initialWidth : constraints.maxWidth;
        final double columnSpacing = (tableWidth - 1450) / 19;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: DataTable(
              columnSpacing: columnSpacing.clamp(8.0, 40.0),
              horizontalMargin: 10,
              headingRowHeight: 38,
              dataRowMinHeight: 32,
              dataRowMaxHeight: 48,
              headingRowColor: WidgetStateProperty.all(const Color(0xFFCFE2F3).withValues(alpha: 0.5)),
              border: TableBorder.all(color: const Color(0xFFE2E8F0), width: 0.5),

              columns: [
                if (_activeCols['SNo']!) const DataColumn(label: Text('SNo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
                if (_activeCols['Date']!) const DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
                if (_activeCols['Vch No']!) const DataColumn(label: Text('Vch No', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
                if (_activeCols['Party Name']!) const DataColumn(label: Text('Party Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
                if (_activeCols['Mob.No']!) const DataColumn(label: Text('Mob.No', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
                if (_activeCols['Group']!) const DataColumn(label: Text('Group', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
                if (_activeCols['Product']!) const DataColumn(label: Text('Product', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
                if (_activeCols['MODEL NO.']!) const DataColumn(label: Text('MODEL NO.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
                if (_activeCols['SIZE']!) const DataColumn(label: Text('SIZE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
                if (_activeCols['COLOR']!) const DataColumn(label: Text('COLOR', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
                if (_activeCols['Item Detail']!) const DataColumn(label: Text('Item Detail', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
                if (_activeCols['Qty']!) const DataColumn(label: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)), numeric: true),
                if (_activeCols['Price']!) const DataColumn(label: Text('Price', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)), numeric: true),
                if (_activeCols['Ttl Prc']!) const DataColumn(label: Text('Ttl Prc', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)), numeric: true),
                if (_activeCols['Dis Amt']!) const DataColumn(label: Text('Dis Amt', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)), numeric: true),
                if (_activeCols['Ttl Price']!) const DataColumn(label: Text('Ttl Price', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)), numeric: true),
                if (_activeCols['GstWise Amt']!) const DataColumn(label: Text('GstWise Amt', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)), numeric: true),
                if (_activeCols['Due Amt']!) const DataColumn(label: Text('Due Amt', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.red)), numeric: true),
                if (_activeCols['View']!) const DataColumn(label: Text('View', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
              ],
              rows: [
                ...data.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  String dateStr = item.date ?? '-';
                  if (dateStr != '-') {
                    try { dateStr = DateFormat('dd-MM-yy').format(DateTime.parse(dateStr)); } catch (_) {}
                  }

                  return DataRow(
                    cells: [
                      if (_activeCols['SNo']!) DataCell(Text('${index + 1}', style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)))),
                      if (_activeCols['Date']!) DataCell(Text(dateStr, style: const TextStyle(fontSize: 10, color: Color(0xFF334155)))),
                      if (_activeCols['Vch No']!) DataCell(Text(item.vchNo ?? '-', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 10, color: Color(0xFF111827)))),
                      if (_activeCols['Party Name']!) DataCell(Text(item.partyName ?? '-', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: Color(0xFF1F2937)))),
                      if (_activeCols['Mob.No']!) DataCell(Text(item.mobileNo ?? '-', style: const TextStyle(fontSize: 10, color: Color(0xFF4B5563)))),
                      if (_activeCols['Group']!) DataCell(Text(item.groupName ?? '-', style: const TextStyle(fontSize: 9, fontStyle: FontStyle.italic, color: Color(0xFF4B5563)))),
                      if (_activeCols['Product']!) DataCell(Text(item.productName ?? '-', style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF1E40AF), fontSize: 11, letterSpacing: -0.5))),
                      if (_activeCols['MODEL NO.']!) DataCell(Text(item.modelNo ?? '-', style: const TextStyle(fontSize: 10, color: Color(0xFF4B5563)))),
                      if (_activeCols['SIZE']!) DataCell(Text(item.size ?? '-', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
                      if (_activeCols['COLOR']!) DataCell(Text(item.color ?? '-', style: const TextStyle(fontSize: 10, color: Color(0xFF4B5563)))),
                      if (_activeCols['Item Detail']!) DataCell(Text(item.itemDetail ?? '-', style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 10, color: Color(0xFF6B7280)))),
                      if (_activeCols['Qty']!) DataCell(Text(item.qty.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF111827), fontSize: 11))),
                      if (_activeCols['Price']!) DataCell(Text(item.price.toStringAsFixed(0), style: const TextStyle(fontSize: 10, color: Color(0xFF374151)))),
                      if (_activeCols['Ttl Prc']!) DataCell(Text(item.totalBasic.toStringAsFixed(0), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF374151)))),
                      if (_activeCols['Dis Amt']!) DataCell(Text('-${item.discountAmt.toStringAsFixed(0)}', style: const TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold, fontSize: 11))),
                      if (_activeCols['Ttl Price']!) DataCell(Text(item.netAmt.toStringAsFixed(0), style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF111827), fontSize: 11))),
                      if (_activeCols['GstWise Amt']!) DataCell(Text(item.taxAmt.toStringAsFixed(0), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)))),
                      if (_activeCols['Due Amt']!) DataCell(Text(item.dueAmt.toStringAsFixed(0), style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFFB91C1C), fontSize: 11))),
                      if (_activeCols['View']!) DataCell(Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: const Color(0xFFFBBF24), borderRadius: BorderRadius.circular(4)), child: const Icon(LucideIcons.fileText, size: 14, color: Colors.white))),
                    ],
                  );
                }),
                DataRow(
                  color: WidgetStateProperty.all(const Color(0xFFF1F5F9)),

                  cells: [
                    if (_activeCols['SNo']!) const DataCell(SizedBox()),
                    if (_activeCols['Date']!) const DataCell(SizedBox()),
                    if (_activeCols['Vch No']!) const DataCell(SizedBox()),
                    if (_activeCols['Party Name']!) const DataCell(Text('TOTALS:', style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF1E3A8A), fontSize: 10))),
                    if (_activeCols['Mob.No']!) const DataCell(SizedBox()),
                    if (_activeCols['Group']!) const DataCell(SizedBox()),
                    if (_activeCols['Product']!) const DataCell(SizedBox()),
                    if (_activeCols['MODEL NO.']!) const DataCell(SizedBox()),
                    if (_activeCols['SIZE']!) const DataCell(SizedBox()),
                    if (_activeCols['COLOR']!) const DataCell(SizedBox()),
                    if (_activeCols['Item Detail']!) const DataCell(SizedBox()),
                    if (_activeCols['Qty']!) DataCell(Text(data.fold(0.0, (s, i) => s + i.qty).toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
                    if (_activeCols['Price']!) const DataCell(SizedBox()),
                    if (_activeCols['Ttl Prc']!) DataCell(Text(data.fold(0.0, (s, i) => s + i.totalBasic).toStringAsFixed(0), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
                    if (_activeCols['Dis Amt']!) DataCell(Text(data.fold(0.0, (s, i) => s + i.discountAmt).toStringAsFixed(0), style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 10))),
                    if (_activeCols['Ttl Price']!) DataCell(Text(data.fold(0.0, (s, i) => s + i.netAmt).toStringAsFixed(0), style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A), fontSize: 10))),
                    if (_activeCols['GstWise Amt']!) DataCell(Text(data.fold(0.0, (s, i) => s + i.taxAmt).toStringAsFixed(0), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
                    if (_activeCols['Due Amt']!) DataCell(Text(data.fold(0.0, (s, i) => s + i.dueAmt).toStringAsFixed(0), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 10))),
                    if (_activeCols['View']!) const DataCell(SizedBox()),
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
