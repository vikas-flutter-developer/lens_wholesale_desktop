import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import '../../data/providers/operational_report_provider.dart';
import '../../data/models/operational_report_model.dart';
import 'dart:math' as math;
import '../../../masters/data/providers/account_provider.dart';
import '../../../masters/data/models/account_model.dart';
import 'dart:io';
import 'package:excel/excel.dart' as xl;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';

class SaleReturnRatioReportPage extends StatefulWidget {
  const SaleReturnRatioReportPage({super.key});

  @override
  State<SaleReturnRatioReportPage> createState() => _SaleReturnRatioReportPageState();
}

class _SaleReturnRatioReportPageState extends State<SaleReturnRatioReportPage> {
  final _dateFromController = TextEditingController(text: DateFormat('yyyy-MM-01').format(DateTime.now()));
  final _dateToController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  String _searchQuery = '';
  String _activePreset = 'Month';
  String _sortKey = 'ratio';
  bool _sortAscending = false;
  final _partyCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
      context.read<AccountProvider>().fetchAllAccounts();
    });
  }

  void _fetchData() {
    context.read<OperationalReportProvider>().fetchSaleReturnRatioReport({
      'dateFrom': _dateFromController.text,
      'dateTo': _dateToController.text,
      'customerName': _partyCtrl.text,
    });
  }

  void _setPreset(String preset) {
    setState(() => _activePreset = preset);
    final now = DateTime.now();
    DateTime fromDate;
    DateTime toDate = now;
    if (preset == 'Month') {
      fromDate = DateTime(now.year, now.month, 1);
    } else if (preset == 'Quarter') {
      final quarter = (now.month / 3).ceil();
      fromDate = DateTime(now.year, 3 * quarter - 2, 1);
      toDate = DateTime(now.year, 3 * quarter + 1, 0); // End of quarter
      if (toDate.isAfter(now)) toDate = now;
    } else {
      fromDate = DateTime(now.year, 1, 1);
    }
    _dateFromController.text = DateFormat('yyyy-MM-dd').format(fromDate);
    _dateToController.text = DateFormat('yyyy-MM-dd').format(toDate);
    _fetchData();
  }

  void _handleSort(String key) {
    setState(() {
      if (_sortKey == key && !_sortAscending) {
        _sortAscending = true;
      } else {
        _sortKey = key;
        _sortAscending = false;
      }
    });
  }

  Future<void> _printReport(OperationalReportProvider provider) async {
    final report = provider.saleReturnRatioReport;
    if (report == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No data to print')));
      return;
    }

    final pdf = pw.Document();
    final font = await PdfGoogleFonts.interRegular();
    final fontBold = await PdfGoogleFonts.interBold();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Sale Return Ratio Report', style: pw.TextStyle(font: fontBold, fontSize: 18)),
                      pw.Text('Period: ${_dateFromController.text} to ${_dateToController.text}', style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey700)),
                    ],
                  ),
                  pw.Text(DateFormat('dd-MMM-yyyy HH:mm').format(DateTime.now()), style: pw.TextStyle(font: font, fontSize: 8, color: PdfColors.grey500)),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            // Summary Row
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                _pdfSummaryItem('TOTAL SALE', 'Rs. ${_formatCurrency(report.summary.totalSale)}', fontBold, font),
                _pdfSummaryItem('TOTAL RETURN', 'Rs. ${_formatCurrency(report.summary.totalReturn)}', fontBold, font),
                _pdfSummaryItem('NET SALE', 'Rs. ${_formatCurrency(report.summary.netSale)}', fontBold, font),
                _pdfSummaryItem('RATIO', '${report.summary.ratio.toStringAsFixed(2)}%', fontBold, font),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Text('PARTY-WISE BREAKDOWN', style: pw.TextStyle(font: fontBold, fontSize: 12, color: PdfColors.blueGrey800)),
            pw.SizedBox(height: 8),
            pw.TableHelper.fromTextArray(
              headers: ['#', 'PARTY NAME', 'TOTAL SALE', 'RETURN', 'NET SALE', 'RATIO %'],
              data: report.partyWise.asMap().entries.map((entry) {
                final i = entry.key;
                final p = entry.value;
                return [
                  '${i + 1}',
                  p.partyName.toUpperCase(),
                  _formatCurrency(p.totalSale),
                  _formatCurrency(p.totalReturn),
                  _formatCurrency(p.netSale),
                  '${p.ratio.toStringAsFixed(2)}%'
                ];
              }).toList(),
              headerStyle: pw.TextStyle(font: fontBold, fontSize: 9, color: PdfColors.white),
              cellStyle: pw.TextStyle(font: font, fontSize: 8),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey900),
              cellAlignment: pw.Alignment.centerRight,
              columnWidths: {
                0: const pw.FixedColumnWidth(30),
                1: const pw.FlexColumnWidth(3),
              },
            ),
            pw.SizedBox(height: 10),
            // PDF Footer Summary Row
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: const pw.BoxDecoration(color: PdfColors.grey100),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('TOTAL SUMMARY', style: pw.TextStyle(font: fontBold, fontSize: 9)),
                  pw.Text(_formatCurrency(report.summary.totalSale), style: pw.TextStyle(font: fontBold, fontSize: 9)),
                  pw.Text(_formatCurrency(report.summary.totalReturn), style: pw.TextStyle(font: fontBold, fontSize: 9, color: PdfColors.red)),
                  pw.Text(_formatCurrency(report.summary.netSale), style: pw.TextStyle(font: fontBold, fontSize: 9, color: PdfColors.green)),
                  pw.Text('${report.summary.ratio.toStringAsFixed(2)}%', style: pw.TextStyle(font: fontBold, fontSize: 9)),
                ],
              ),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  pw.Widget _pdfSummaryItem(String label, String value, pw.Font bold, pw.Font reg) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(label, style: pw.TextStyle(font: reg, fontSize: 8, color: PdfColors.grey600)),
        pw.Text(value, style: pw.TextStyle(font: bold, fontSize: 14)),
      ],
    );
  }

  Future<void> _exportToExcel(OperationalReportProvider provider) async {
    final report = provider.saleReturnRatioReport;
    if (report == null || report.partyWise.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No data to export')));
      return;
    }

    try {
      var excel = xl.Excel.createExcel();
      xl.Sheet sheetObject = excel['SaleReturnRatioReport'];

      // Title & Date Header
      sheetObject.appendRow([xl.TextCellValue('Sale Return Ratio Report')]);
      sheetObject.appendRow([xl.TextCellValue('Period: ${_dateFromController.text} to ${_dateToController.text}')]);
      sheetObject.appendRow([]); // Empty row

      // Summary Header Row
      sheetObject.appendRow([
        xl.TextCellValue('TOTAL SALE'),
        xl.DoubleCellValue(report.summary.totalSale),
        xl.TextCellValue('TOTAL RETURN'),
        xl.DoubleCellValue(report.summary.totalReturn),
        xl.TextCellValue('NET SALE'),
        xl.DoubleCellValue(report.summary.netSale),
        xl.TextCellValue('RATIO %'),
        xl.DoubleCellValue(report.summary.ratio),
      ]);
      sheetObject.appendRow([]); // Empty row

      // Table Headers
      sheetObject.appendRow([
        xl.TextCellValue('SR. NO.'),
        xl.TextCellValue('PARTY NAME'),
        xl.TextCellValue('TOTAL SALE'),
        xl.TextCellValue('TOTAL RETURN'),
        xl.TextCellValue('NET SALE'),
        xl.TextCellValue('RETURN %'),
      ]);

      // Data Rows
      for (int i = 0; i < report.partyWise.length; i++) {
        final p = report.partyWise[i];
        sheetObject.appendRow([
          xl.IntCellValue(i + 1),
          xl.TextCellValue(p.partyName),
          xl.DoubleCellValue(p.totalSale),
          xl.DoubleCellValue(p.totalReturn),
          xl.DoubleCellValue(p.netSale),
          xl.DoubleCellValue(p.ratio),
        ]);
      }

      // Final Footer Summary
      sheetObject.appendRow([]);
      sheetObject.appendRow([
        xl.TextCellValue('GRAND TOTAL'),
        xl.TextCellValue(''),
        xl.DoubleCellValue(report.summary.totalSale),
        xl.DoubleCellValue(report.summary.totalReturn),
        xl.DoubleCellValue(report.summary.netSale),
        xl.DoubleCellValue(report.summary.ratio),
      ]);

      String? outputFile = await FilePicker.saveFile(
        dialogTitle: 'Save Excel File',
        fileName: 'Sale_Return_Ratio_Report_${_dateFromController.text}_to_${_dateToController.text}.xlsx',
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );

      if (outputFile != null) {
        final bytes = excel.encode();
        if (bytes != null) {
          final file = File(outputFile);
          await file.writeAsBytes(bytes);
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

  String _formatCurrency(double val) {
    final format = NumberFormat.currency(locale: 'en_IN', symbol: '', decimalDigits: 2);
    return format.format(val);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // slate-50
      body: Consumer<OperationalReportProvider>(
        builder: (context, provider, _) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(provider),
                const SizedBox(height: 24),
                Expanded(
                  child: provider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _buildBody(provider),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(OperationalReportProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade600,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(color: Colors.blue.shade200, blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: const Icon(LucideIcons.activity, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sale Return Ratio Report',
                  style: TextStyle(color: Color(0xFF1E293B), fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -0.5),
                ),
                Text(
                  'Monitor business performance and party-wise return trends',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () => _exportToExcel(provider),
              icon: const Icon(LucideIcons.download, size: 16),
              label: const Text('Export'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.grey.shade700,
                elevation: 0,
                side: BorderSide(color: Colors.grey.shade200),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () => _printReport(provider),
              icon: const Icon(LucideIcons.printer, size: 16),
              label: const Text('Print'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F172A), // slate-900
                foregroundColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBody(OperationalReportProvider provider) {
    final report = provider.saleReturnRatioReport;
    if (report == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSummaryCards(report.summary),
          const SizedBox(height: 24),
          _buildFilterAndVisuals(report),
          const SizedBox(height: 24),
          _buildDataTable(report.partyWise, report.summary),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(SaleReturnRatioSummary summary) {
    return Row(
      children: [
        _summaryCard(
          title: 'Total Sale',
          value: '₹ ${_formatCurrency(summary.totalSale)}',
          tag: 'Gross amount',
          icon: LucideIcons.dollarSign,
          color: Colors.blue,
        ),
        const SizedBox(width: 16),
        _summaryCard(
          title: 'Total Return',
          value: '₹ ${_formatCurrency(summary.totalReturn)}',
          tag: 'Returned amount',
          icon: LucideIcons.rotateCcw,
          color: Colors.red,
        ),
        const SizedBox(width: 16),
        _summaryCard(
          title: 'Net Sale',
          value: '₹ ${_formatCurrency(summary.netSale)}',
          tag: 'Actual business',
          icon: LucideIcons.trendingUp,
          color: Colors.teal, // emerald
        ),
        const SizedBox(width: 16),
        _summaryCard(
          title: 'Return Ratio',
          value: '${summary.ratio.toStringAsFixed(2)}%',
          tag: summary.ratio > 10 ? 'High' : 'Healthy',
          icon: LucideIcons.percent,
          color: summary.ratio > 10 ? Colors.red : Colors.teal,
          isRatioCard: true,
          ratio: summary.ratio,
        ),
      ],
    );
  }

  Widget _summaryCard({
    required String title,
    required String value,
    required String tag,
    required IconData icon,
    required MaterialColor color,
    bool isRatioCard = false,
    double ratio = 0.0,
  }) {
    final isHigh = isRatioCard && ratio > 10;
    
    Color bgColor = Colors.white;
    Color borderColor = Colors.grey.shade100;
    
    if (isRatioCard) {
      if (isHigh) {
        bgColor = Colors.red.shade50;
        borderColor = Colors.red.shade100;
      } else {
        bgColor = Colors.teal.shade50;
        borderColor = Colors.teal.shade100;
      }
    }

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
          boxShadow: isRatioCard ? [] : [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -8,
              top: -8,
              child: Icon(icon, size: 48, color: color.withAlpha(25)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: isRatioCard ? (isHigh ? Colors.red.shade400 : Colors.teal.shade400) : Colors.grey.shade400,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: isRatioCard ? (isHigh ? Colors.red.shade700 : Colors.teal.shade700) : const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isRatioCard ? (isHigh ? Colors.red.shade100 : Colors.teal.shade100) : color.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isRatioCard) ...[
                        Icon(isHigh ? LucideIcons.trendingUp : LucideIcons.trendingDown, size: 12, color: isHigh ? Colors.red.shade700 : Colors.teal.shade700),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        tag,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isRatioCard ? (isHigh ? Colors.red.shade700 : Colors.teal.shade700) : color.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterAndVisuals(SaleReturnRatioReport report) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 8,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Filters Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(LucideIcons.filter, size: 16, color: Colors.blue.shade600),
                        const SizedBox(width: 8),
                        Text('FILTERS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey.shade800, letterSpacing: 1)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade100)),
                      child: Row(
                        children: ['Month', 'Quarter', 'Year'].map((preset) {
                          final isActive = _activePreset == preset;
                          return InkWell(
                            onTap: () => _setPreset(preset),
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: isActive ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: isActive ? [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 4, offset: const Offset(0, 1))] : [],
                              ),
                              child: Text(
                                preset.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  color: isActive ? Colors.blue.shade600 : Colors.grey.shade600,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Divider(height: 1),
                ),
                // Inputs
                Row(
                  children: [
                    _filterInput('DATE FROM', _dateFromController, true),
                    const SizedBox(width: 24),
                    _filterInput('DATE TO', _dateToController, true),
                    const SizedBox(width: 24),
                    Expanded(child: _searchInput()),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Divider(height: 1),
                ),
                // Insights
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildHighestReturnAlert(report.partyWise)),
                    const SizedBox(width: 32),
                    Expanded(child: _buildTop5Parties(report.partyWise)),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 4,
          child: Column(
            children: [
              _buildCompositionChart(report.summary),
              const SizedBox(height: 24),
              _buildTrendChart(report.trend),
            ],
          ),
        ),
      ],
    );
  }

  Widget _filterInput(String label, TextEditingController controller, bool isDate) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(isDate ? LucideIcons.calendar : LucideIcons.search, size: 12, color: Colors.grey.shade400),
              const SizedBox(width: 4),
              Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey.shade400, letterSpacing: 0.5)),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            readOnly: isDate,
            onTap: isDate ? () => _selectDate(controller) : null,
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.blue.shade500, width: 2)),
              suffixIcon: isDate ? const Icon(LucideIcons.calendar, size: 16) : null,
            ),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _searchInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(LucideIcons.search, size: 12, color: Colors.grey.shade400),
            const SizedBox(width: 4),
            Text('QUICK SEARCH', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey.shade400, letterSpacing: 0.5)),
          ],
        ),
        const SizedBox(height: 8),
        Consumer<AccountProvider>(
          builder: (context, accProv, _) => Autocomplete<AccountModel>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return const Iterable<AccountModel>.empty();
              }
              return accProv.accounts.where((AccountModel option) {
                return option.name.toLowerCase().contains(textEditingValue.text.toLowerCase());
              });
            },
            displayStringForOption: (AccountModel option) => option.name,
            onSelected: (AccountModel selection) {
              _partyCtrl.text = selection.name;
              _fetchData();
            },
            fieldViewBuilder: (context, textController, focusNode, onFieldSubmitted) {
              // Sync with our controller
              if (textController.text != _partyCtrl.text) {
                textController.text = _partyCtrl.text;
              }
              return TextField(
                controller: textController,
                focusNode: focusNode,
                onChanged: (val) {
                  _partyCtrl.text = val;
                  setState(() => _searchQuery = val.toLowerCase());
                  if (val.isEmpty) _fetchData();
                },
                decoration: InputDecoration(
                  hintText: 'Search party name...',
                  isDense: true,
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  prefixIcon: const Icon(LucideIcons.search, size: 16, color: Colors.grey),
                  suffixIcon: _partyCtrl.text.isNotEmpty 
                    ? IconButton(
                        icon: const Icon(LucideIcons.x, size: 16),
                        onPressed: () {
                          textController.clear();
                          _partyCtrl.clear();
                          setState(() => _searchQuery = '');
                          _fetchData();
                        },
                      )
                    : null,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.blue.shade500, width: 2)),
                ),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              );
            },
            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 300, // Matching field width roughly
                    constraints: const BoxConstraints(maxHeight: 300),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (BuildContext context, int index) {
                        final AccountModel option = options.elementAt(index);
                        return InkWell(
                          onTap: () => onSelected(option),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(option.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
      _fetchData();
    }
  }

  Widget _buildHighestReturnAlert(List<PartyWiseReturnRatio> partyWise) {
    final highRatios = partyWise.where((p) => p.ratio > 15).toList();
    highRatios.sort((a, b) => b.ratio.compareTo(a.ratio));
    final topRatios = highRatios.take(3);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(LucideIcons.trendingDown, size: 16, color: Colors.red.shade500),
            const SizedBox(width: 8),
            Text('HIGHEST RETURN ALERT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey.shade800, letterSpacing: 1)),
          ],
        ),
        const SizedBox(height: 16),
        if (topRatios.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: const Text('All parties within safe limits', style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic)),
          ),
        ...topRatios.toList().asMap().entries.map((entry) {
          int index = entry.key;
          PartyWiseReturnRatio p = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              border: Border.all(color: Colors.red.shade100),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(color: Colors.red.shade100, borderRadius: BorderRadius.circular(8)),
                      alignment: Alignment.center,
                      child: Text('${index + 1}', style: TextStyle(color: Colors.red.shade600, fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                    const SizedBox(width: 12),
                    Text(p.partyName, style: TextStyle(color: Colors.red.shade900, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${p.ratio.toStringAsFixed(2)}%', style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w900, fontSize: 14)),
                    Text('RETURN RATE', style: TextStyle(color: Colors.red.shade400, fontWeight: FontWeight.bold, fontSize: 8)),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildTop5Parties(List<PartyWiseReturnRatio> partyWise) {
    var sorted = List<PartyWiseReturnRatio>.from(partyWise)..sort((a, b) => b.ratio.compareTo(a.ratio));
    final top5 = sorted.take(5);
    final double maxRatio = top5.isNotEmpty ? math.max(top5.first.ratio, 10.0) : 10.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(LucideIcons.barChart3, size: 16, color: Colors.teal.shade500),
            const SizedBox(width: 8),
            Text('RETURN TOP 5 PARTIES', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey.shade800, letterSpacing: 1)),
          ],
        ),
        const SizedBox(height: 16),
        ...top5.map((p) {
          final isHigh = p.ratio > 15;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(p.partyName.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade500)),
                    Text('${p.ratio.toStringAsFixed(2)}%', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade500)),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  width: double.infinity,
                  height: 8,
                  decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(4)),
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: (p.ratio / maxRatio).clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isHigh ? Colors.red.shade500 : Colors.teal.shade500,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCompositionChart(SaleReturnRatioSummary summary) {
    final netSale = summary.netSale;
    final totalReturn = summary.totalReturn;
    final total = netSale + totalReturn;
    final double returnPercent = total > 0 ? totalReturn / total : 0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(LucideIcons.pieChart, size: 16, color: Colors.indigo.shade500),
              const SizedBox(width: 8),
              Text('RETURN COMPOSITION', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey.shade800, letterSpacing: 1)),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 120, // matching react size roughly (w-32 is 128px)
            width: 120,
            child: Stack(
              children: [
                Center(
                  child: CustomPaint(
                    size: const Size(120, 120),
                    painter: _DoughnutPainter(
                      color1: Colors.teal.shade500, // Emerald
                      color2: Colors.red.shade500,  // Red
                      percent2: returnPercent,
                      strokeWidth: 12,
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('RATIO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade400)),
                      Text('${summary.ratio.toStringAsFixed(2)}%', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade100)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.teal, shape: BoxShape.circle)),
                          const SizedBox(width: 6),
                          Text('NET SALE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade400)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('₹ ${_formatCurrency(summary.netSale)}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.grey.shade700)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade100)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
                          const SizedBox(width: 6),
                          Text('RETURN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade400)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('₹ ${_formatCurrency(summary.totalReturn)}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.grey.shade700)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrendChart(List<RatioTrend> trend) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.trendingUp, size: 16, color: Colors.blue.shade500),
              const SizedBox(width: 8),
              Text('RETURN RATIO TREND', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey.shade800, letterSpacing: 1)),
            ],
          ),
          const SizedBox(height: 24),
          if (trend.isEmpty)
            const SizedBox(height: 120, child: Center(child: Text('No trend data', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic))))
          else
            SizedBox(
              height: 120,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: trend.take(12).map((t) {
                  final maxRatio = trend.map((e) => e.ratio).reduce(math.max);
                  final safeMax = math.max(maxRatio, 5.0);
                  final heightFactor = (t.ratio / safeMax).clamp(0.0, 1.0);
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Tooltip(
                            message: '${t.period}: ${t.ratio}%',
                            child: Container(
                              height: 80 * heightFactor + 4, // base height plus variable
                              width: 24, // Fix max width to avoid massive stretching
                              decoration: BoxDecoration(
                                color: Colors.blue.shade500, // bg-blue-500
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Transform.rotate(
                            angle: -math.pi / 4,
                            alignment: Alignment.topLeft,
                            child: Text(
                              t.period.length > 7 ? t.period.substring(0, 7) : t.period,
                              style: TextStyle(fontSize: 8, color: Colors.grey.shade400, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.visible,
                              softWrap: false,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  int _compareValues(dynamic a, dynamic b) {
    if (a is num && b is num) {
      return a.compareTo(b);
    }
    return a.toString().compareTo(b.toString());
  }

  Widget _buildDataTable(List<PartyWiseReturnRatio> partyWise, SaleReturnRatioSummary summary) {
    List<PartyWiseReturnRatio> filtered = partyWise.where((p) => p.partyName.toLowerCase().contains(_searchQuery)).toList();

    filtered.sort((a, b) {
      dynamic valA, valB;
      switch (_sortKey) {
        case 'partyName': valA = a.partyName; valB = b.partyName; break;
        case 'totalSale': valA = a.totalSale; valB = b.totalSale; break;
        case 'totalReturn': valA = a.totalReturn; valB = b.totalReturn; break;
        case 'netSale': valA = a.netSale; valB = b.netSale; break;
        case 'ratio': valA = a.ratio; valB = b.ratio; break;
        default: valA = a.ratio; valB = b.ratio;
      }
      return _sortAscending ? _compareValues(valA, valB) : _compareValues(valB, valA);
    });

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.indigo.shade50, borderRadius: BorderRadius.circular(8)),
                      child: Icon(LucideIcons.user, size: 16, color: Colors.indigo.shade600),
                    ),
                    const SizedBox(width: 12),
                    const Text('Party-wise Breakdown', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
                  ],
                ),
                Text.rich(
                  TextSpan(
                    text: 'SORTED BY ',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade400, letterSpacing: 1),
                    children: [
                      TextSpan(
                        text: '${_sortKey.toUpperCase()} (${_sortAscending ? 'ASC' : 'DESC'})',
                        style: TextStyle(color: Colors.blue.shade600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1, color: Colors.grey.shade100),
          // Custom Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            color: Colors.grey.shade50,
            child: Row(
              children: [
                Expanded(flex: 1, child: Text('#', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey.shade500, letterSpacing: 1))),
                Expanded(flex: 4, child: _buildCustomSortHeader('PARTY NAME', 'partyName')),
                Expanded(flex: 3, child: _buildCustomSortHeader('TOTAL SALE', 'totalSale', alignRight: true)),
                Expanded(flex: 3, child: _buildCustomSortHeader('RETURN', 'totalReturn', alignRight: true)),
                Expanded(flex: 3, child: _buildCustomSortHeader('NET SALE', 'netSale', alignRight: true)),
                Expanded(flex: 3, child: _buildCustomSortHeader('RETURN %', 'ratio', alignRight: true)),
              ],
            ),
          ),
          Container(height: 1, color: Colors.grey.shade200),
          // Table Rows
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filtered.length,
            separatorBuilder: (context, index) => Container(height: 1, color: Colors.grey.shade100),
            itemBuilder: (context, index) {
              final p = filtered[index];
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Expanded(flex: 1, child: Text('${index + 1}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade400))),
                    Expanded(
                      flex: 4, 
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.partyName.toUpperCase(), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.blue.shade600)),
                          const SizedBox(height: 2),
                          Text('REGULAR CUSTOMER', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey.shade400, letterSpacing: 0.5)),
                        ],
                      ),
                    ),
                    Expanded(flex: 3, child: Text('₹${_formatCurrency(p.totalSale)}', textAlign: TextAlign.right, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.grey.shade800))),
                    Expanded(flex: 3, child: Text('₹${_formatCurrency(p.totalReturn)}', textAlign: TextAlign.right, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.red.shade500))),
                    Expanded(flex: 3, child: Text('₹${_formatCurrency(p.netSale)}', textAlign: TextAlign.right, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.teal.shade600))),
                    Expanded(
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 36,
                            height: 4,
                            decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(4)),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: (p.ratio / 100).clamp(0.0, 1.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: p.ratio > 15 ? Colors.red.shade500 : Colors.teal.shade500,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 46,
                            child: Text('${p.ratio.toStringAsFixed(2)}%', textAlign: TextAlign.right, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: p.ratio > 15 ? Colors.red.shade600 : Colors.teal.shade600)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          if (filtered.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40),
              alignment: Alignment.center,
              child: const Text('No sales or returns found for the selected period', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
            ),
          // Table Footer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            color: const Color(0xFF1E293B), // slate-900 absolute dark
            child: Row(
              children: [
                Expanded(flex: 5, child: const Text('TOTAL SUMMARY OVER SELECTED PERIOD', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, color: Colors.white, letterSpacing: 0.5))),
                Expanded(flex: 3, child: Text('₹${_formatCurrency(summary.totalSale)}', textAlign: TextAlign.right, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.white))),
                Expanded(flex: 3, child: Text('₹${_formatCurrency(summary.totalReturn)}', textAlign: TextAlign.right, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.red.shade400))),
                Expanded(flex: 3, child: Text('₹${_formatCurrency(summary.netSale)}', textAlign: TextAlign.right, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.teal.shade400))),
                Expanded(flex: 3, child: Text('${summary.ratio.toStringAsFixed(2)}%', textAlign: TextAlign.right, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.amber.shade400))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomSortHeader(String label, String key, {bool alignRight = false}) {
    final isSelected = _sortKey == key;
    return InkWell(
      onTap: () => _handleSort(key),
      child: Row(
        mainAxisAlignment: alignRight ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: isSelected ? Colors.blue.shade600 : Colors.grey.shade500,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            isSelected
                ? (_sortAscending ? LucideIcons.chevronUp : LucideIcons.chevronDown)
                : LucideIcons.chevronDown,
            size: 12,
            color: isSelected ? Colors.blue.shade600 : Colors.grey.shade400,
          ),
        ],
      ),
    );
  }
}

class _DoughnutPainter extends CustomPainter {
  final Color color1;
  final Color color2;
  final double percent2;
  final double strokeWidth;

  _DoughnutPainter({
    required this.color1,
    required this.color2,
    required this.percent2,
    this.strokeWidth = 12,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(strokeWidth / 2, strokeWidth / 2, size.width - strokeWidth, size.height - strokeWidth);
    
    // Draw base ring (Net Sale)
    final basePaint = Paint()
      ..color = color1
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;
    
    canvas.drawArc(rect, 0, math.pi * 2, false, basePaint);

    // Draw return overlay ring
    if (percent2 > 0) {
      final overlayPaint = Paint()
        ..color = color2
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;
      
      final sweepAngle = (percent2 * math.pi * 2).clamp(0.0, math.pi * 2);
      canvas.drawArc(rect, -math.pi / 2, sweepAngle, false, overlayPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
