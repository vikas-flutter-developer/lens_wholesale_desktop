import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:io';
import '../../data/providers/transaction_report_provider.dart';
import '../../data/models/transaction_report_models.dart';
import 'package:excel/excel.dart' as xl;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';

class SaleSummaryFormatPage extends StatefulWidget {
  const SaleSummaryFormatPage({super.key});

  @override
  State<SaleSummaryFormatPage> createState() => _SaleSummaryFormatPageState();
}

class _SaleSummaryFormatPageState extends State<SaleSummaryFormatPage> {
  final TextEditingController _seriesController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  DateTime _fromDate = DateTime(2025, 12, 28);
  DateTime _toDate = DateTime.now();

  final Map<String, bool> _activeCols = {
    'SNo': true,
    'Date': true,
    'Bill No': true,
    'Party Name': true,
    'Mobile No': true,
    'GSTIN': true,
    'State': true,
    'Bill Type': true,
    'Mtrl Cntr': true,
    'Total Qty': true,
    'Total Amt': true,
    'Taxable Amt': true,
    'Tax@%': true,
    'Cgst %': true,
    'Cgst Amt': true,
    'Sgst %': true,
    'Sgst Amt': true,
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleSearch();
    });
  }

  void _handleSearch() {
    final params = {
      'billSeries': _seriesController.text,
      'dateFrom': DateFormat('yyyy-MM-dd').format(_fromDate),
      'dateTo': DateFormat('yyyy-MM-dd').format(_toDate),
      'searchText': _searchController.text,
    };
    context.read<TransactionReportProvider>().fetchSaleSummaryFormatReport(params);
  }

  void _resetFilters() {
    setState(() {
      _seriesController.clear();
      _searchController.clear();
      _fromDate = DateTime(2025, 12, 28);
      _toDate = DateTime.now();
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
              title: const Text('Toggle Visibility', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              content: SizedBox(
                width: 300,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _activeCols.keys.map((col) {
                      return CheckboxListTile(
                        title: Text(col, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        value: _activeCols[col],
                        onChanged: (val) {
                          setState(() => _activeCols[col] = val ?? false);
                          setDialogState(() {});
                        },
                        dense: true,
                        activeColor: const Color(0xFF2563EB),
                        controlAffinity: ListTileControlAffinity.leading,
                      );
                    }).toList(),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close', style: TextStyle(fontWeight: FontWeight.bold)),
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
    if (provider.saleFormats.isEmpty) return;

    try {
      var excel = xl.Excel.createExcel();
      xl.Sheet sheetObject = excel['SaleSummaryFormat'];
      
      List<xl.CellValue> headers = _activeCols.entries
          .where((e) => e.value)
          .map((e) => xl.TextCellValue(e.key))
          .toList();
      sheetObject.appendRow(headers);

      for (var item in provider.saleFormats) {
        List<xl.CellValue> row = [];
        if (_activeCols['SNo']!) row.add(xl.IntCellValue(provider.saleFormats.indexOf(item) + 1));
        if (_activeCols['Date']!) row.add(xl.TextCellValue(item.date ?? ''));
        if (_activeCols['Bill No']!) row.add(xl.TextCellValue(item.billNo ?? ''));
        if (_activeCols['Party Name']!) row.add(xl.TextCellValue(item.partyName ?? ''));
        if (_activeCols['Mobile No']!) row.add(xl.TextCellValue(item.mobileNo ?? ''));
        if (_activeCols['GSTIN']!) row.add(xl.TextCellValue(item.gstin ?? ''));
        if (_activeCols['State']!) row.add(xl.TextCellValue(item.state ?? ''));
        if (_activeCols['Bill Type']!) row.add(xl.TextCellValue(item.billType ?? ''));
        if (_activeCols['Mtrl Cntr']!) row.add(xl.TextCellValue(item.mtrlCntr ?? ''));
        if (_activeCols['Total Qty']!) row.add(xl.DoubleCellValue(item.totalQty));
        if (_activeCols['Total Amt']!) row.add(xl.DoubleCellValue(item.totalAmt));
        if (_activeCols['Taxable Amt']!) row.add(xl.DoubleCellValue(item.taxableAmt));
        if (_activeCols['Tax@%']!) row.add(xl.DoubleCellValue(item.taxPercent));
        if (_activeCols['Cgst %']!) row.add(xl.DoubleCellValue(item.cgstPercent));
        if (_activeCols['Cgst Amt']!) row.add(xl.DoubleCellValue(item.cgstAmt));
        if (_activeCols['Sgst %']!) row.add(xl.DoubleCellValue(item.sgstPercent));
        if (_activeCols['Sgst Amt']!) row.add(xl.DoubleCellValue(item.sgstAmt));
        sheetObject.appendRow(row);
      }

      String? outputFile = await FilePicker.saveFile(
        dialogTitle: 'Save Excel File',
        fileName: 'SaleSummaryFormat.xlsx',
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
    if (provider.saleFormats.isEmpty) return;

    final pdf = pw.Document();
    final headers = _activeCols.entries.where((e) => e.value).map((e) => e.key).toList();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Sale Summary Format Report', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Date range: ${DateFormat('dd/MM/yyyy').format(_fromDate)} to ${DateFormat('dd/MM/yyyy').format(_toDate)}', style: const pw.TextStyle(fontSize: 10)),
                ],
              ),
            ),
            pw.SizedBox(height: 10),
            pw.TableHelper.fromTextArray(
              headers: headers,
              data: provider.saleFormats.asMap().entries.map((entry) {
                final i = entry.key;
                final item = entry.value;
                List<String> row = [];
                if (_activeCols['SNo']!) row.add('${i + 1}');
                if (_activeCols['Date']!) row.add(item.date ?? '');
                if (_activeCols['Bill No']!) row.add(item.billNo ?? '');
                if (_activeCols['Party Name']!) row.add(item.partyName ?? '');
                if (_activeCols['Mobile No']!) row.add(item.mobileNo ?? '');
                if (_activeCols['GSTIN']!) row.add(item.gstin ?? '');
                if (_activeCols['State']!) row.add(item.state ?? '');
                if (_activeCols['Bill Type']!) row.add(item.billType ?? '');
                if (_activeCols['Mtrl Cntr']!) row.add(item.mtrlCntr ?? '');
                if (_activeCols['Total Qty']!) row.add(item.totalQty.toStringAsFixed(2));
                if (_activeCols['Total Amt']!) row.add(NumberFormat('#,##,##0').format(item.totalAmt));
                if (_activeCols['Taxable Amt']!) row.add(NumberFormat('#,##,##0').format(item.taxableAmt));
                if (_activeCols['Tax@%']!) row.add(item.taxPercent.toStringAsFixed(2));
                if (_activeCols['Cgst %']!) row.add(item.cgstPercent.toStringAsFixed(2));
                if (_activeCols['Cgst Amt']!) row.add(NumberFormat('#,##,##0').format(item.cgstAmt));
                if (_activeCols['Sgst %']!) row.add(item.sgstPercent.toStringAsFixed(2));
                if (_activeCols['Sgst Amt']!) row.add(NumberFormat('#,##,##0').format(item.sgstAmt));
                return row;
              }).toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
              cellStyle: const pw.TextStyle(fontSize: 7),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
              cellAlignment: pw.Alignment.centerLeft,
              columnWidths: {
                0: const pw.FixedColumnWidth(25), // SNo
                3: const pw.FixedColumnWidth(100), // Party Name
              },
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'SaleSummaryFormat_${DateFormat('dd-MM-yyyy').format(_fromDate)}.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFilterHeader(),
        Expanded(
          child: Consumer<TransactionReportProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) return const Center(child: CircularProgressIndicator());
              if (provider.saleFormats.isEmpty) {
                return const Center(child: Text('No records found in this time range', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)));
              }
              return _buildDataTable(provider.saleFormats);
            },
          ),
        ),
        _buildFooterButtons(),
      ],
    );
  }

  Widget _buildFilterHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        border: Border(bottom: BorderSide(color: Colors.blue.shade100)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: 200,
              child: _filterColumn('BILL SERIES', TextField(
                controller: _seriesController,
                decoration: _inputDecoration('Enter Bill Series'),
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              )),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 140,
              child: _filterColumn('DATE FROM', _datePicker(_fromDate, (d) => setState(() => _fromDate = d))),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 140,
              child: _filterColumn('TO', _datePicker(_toDate, (d) => setState(() => _toDate = d))),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 250,
              child: _filterColumn('', TextField(
                controller: _searchController,
                decoration: _inputDecoration('Search records...'),
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              )),
            ),
            const SizedBox(width: 16),
            _actionOutlineButton(
              onPressed: _showColumnSelectionDialog,
              icon: LucideIcons.layout,
              label: 'Columns (${_activeCols.values.where((v) => v).length})',
            ),
            const SizedBox(width: 8),
            _primaryButton(onPressed: _handleSearch, label: 'SEARCH', color: const Color(0xFF2563EB)),
            const SizedBox(width: 8),
            _primaryButton(onPressed: _resetFilters, label: 'RESET', color: const Color(0xFF06B6D4)),
            const SizedBox(width: 8),
            _iconActionButton(LucideIcons.fileSpreadsheet, _exportToExcel, Colors.green),
            const SizedBox(width: 8),
            _iconActionButton(LucideIcons.printer, _printReport, Colors.blueGrey),
          ],
        ),
      ),
    );
  }

  Widget _buildDataTable(List<SaleSummaryFormat> data) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: const Color(0xFFE2E8F0)),
      child: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(const Color(0xFFE7F0F7)),
              headingRowHeight: 45,
              dataRowMinHeight: 40,
              dataRowMaxHeight: 52,
              columnSpacing: 24,
              border: TableBorder.all(color: const Color(0xFFDAE1E7), width: 0.5),
              columns: _activeCols.entries.where((e) => e.value).map((e) {
                return DataColumn(
                  label: Text(
                    e.key.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF1E3A8A), fontSize: 11),
                  ),
                  numeric: ['Total Qty', 'Total Amt', 'Taxable Amt', 'Tax@%', 'Cgst %', 'Cgst Amt', 'Sgst %', 'Sgst Amt'].contains(e.key),
                );
              }).toList(),
              rows: data.map((item) {
                final index = data.indexOf(item);
                return DataRow(
                  color: index % 2 != 0 ? WidgetStateProperty.all(const Color(0xFFF8FAFC)) : null,
                  cells: _activeCols.entries.where((e) => e.value).map((e) {
                    return DataCell(_buildCellContent(e.key, item, index));
                  }).toList(),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCellContent(String col, SaleSummaryFormat item, int index) {
    String text = '';
    TextStyle style = const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF475569));

    switch (col) {
      case 'SNo':
        text = '${index + 1}';
        style = style.copyWith(color: Colors.grey.shade600);
        break;
      case 'Date':
        try {
          DateTime dt = DateTime.parse(item.date!);
          text = DateFormat('dd/MM/yyyy').format(dt);
        } catch (_) {
          text = item.date ?? '-';
        }
        break;
      case 'Bill No':
        text = item.billNo ?? '-';
        style = style.copyWith(fontWeight: FontWeight.w900, color: const Color(0xFF1E293B));
        break;
      case 'Party Name':
        text = item.partyName ?? '-';
        style = style.copyWith(fontWeight: FontWeight.w900, color: Colors.black87, fontSize: 13);
        break;
      case 'Mobile No':
        text = item.mobileNo ?? '-';
        break;
      case 'GSTIN':
        text = item.gstin ?? '-';
        style = style.copyWith(fontFamily: 'monospace', color: Colors.blue.shade700, fontWeight: FontWeight.bold, fontSize: 11);
        break;
      case 'State':
        text = item.state ?? '-';
        break;
      case 'Bill Type':
        text = item.billType ?? '-';
        style = style.copyWith(fontStyle: FontStyle.italic, color: Colors.grey.shade500, fontWeight: FontWeight.bold, fontSize: 11);
        break;
      case 'Mtrl Cntr':
        text = item.mtrlCntr ?? '-';
        break;
      case 'Total Qty':
        text = item.totalQty.toStringAsFixed(2);
        style = style.copyWith(fontWeight: FontWeight.w900, color: Colors.black);
        break;
      case 'Total Amt':
        text = NumberFormat('#,##,##0').format(item.totalAmt);
        style = style.copyWith(fontWeight: FontWeight.w900, color: const Color(0xFF1E3A8A));
        break;
      case 'Taxable Amt':
        text = NumberFormat('#,##,##0').format(item.taxableAmt);
        break;
      case 'Tax@%':
        text = item.taxPercent.toStringAsFixed(2);
        style = style.copyWith(fontWeight: FontWeight.bold, color: Colors.grey.shade400);
        break;
      case 'Cgst %':
        text = item.cgstPercent.toStringAsFixed(2);
        break;
      case 'Cgst Amt':
        text = NumberFormat('#,##,##0').format(item.cgstAmt);
        style = style.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF334155));
        break;
      case 'Sgst %':
        text = item.sgstPercent.toStringAsFixed(2);
        break;
      case 'Sgst Amt':
        text = NumberFormat('#,##,##0').format(item.sgstAmt);
        style = style.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF334155));
        break;
    }

    return Text(text, style: style);
  }

  Widget _buildFooterButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _footerButton(
              onPressed: () {},
              icon: LucideIcons.checkSquare,
              label: 'VERIFY LIST',
              color: const Color(0xFF16A34A),
            ),
            const SizedBox(width: 12),
            _footerButton(
              onPressed: () {},
              icon: LucideIcons.edit3,
              label: 'UPDATE VOUCHER',
              color: const Color(0xFF4CAF50),
            ),
          ],
        ),
      ),
    );
  }

  Widget _footerButton({required VoidCallback onPressed, required IconData icon, required String label, required Color color}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1.2)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2,
        shadowColor: color.withValues(alpha: 0.3),
      ),
    );
  }

  Widget _filterColumn(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF0F766E), letterSpacing: 0.5)),
          const SizedBox(height: 6),
        ],
        child,
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      isDense: true,
      hintStyle: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.normal),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5)),
    );
  }

  Widget _datePicker(DateTime date, Function(DateTime) onPicked) {
    return InkWell(
      onTap: () async {
        final d = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          builder: (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(primary: Color(0xFF2563EB)),
            ),
            child: child!,
          ),
        );
        if (d != null) onPicked(d);
      },
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFCBD5E1)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(DateFormat('dd-MM-yyyy').format(date), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            const Spacer(),
            const Icon(LucideIcons.calendar, size: 16, color: Color(0xFF64748B)),
          ],
        ),
      ),
    );
  }

  Widget _primaryButton({required VoidCallback onPressed, required String label, required Color color}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 4,
        shadowColor: color.withValues(alpha: 0.4),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
    );
  }

  Widget _actionOutlineButton({required VoidCallback onPressed, required IconData icon, required String label}) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16, color: const Color(0xFF2563EB)),
      label: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900)),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF1E293B),
        backgroundColor: Colors.white,
        side: const BorderSide(color: Color(0xFFCBD5E1)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _iconActionButton(IconData icon, VoidCallback onPressed, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 20),
        onPressed: onPressed,
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(),
      ),
    );
  }
}
