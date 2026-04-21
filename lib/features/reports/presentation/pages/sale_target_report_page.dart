import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'dart:io';
import 'package:excel/excel.dart' as xl;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';
import 'package:printing/printing.dart';
import '../../data/providers/target_provider.dart';
import '../../data/models/target_model.dart';

class SaleTargetReportPage extends StatefulWidget {
  const SaleTargetReportPage({super.key});

  @override
  State<SaleTargetReportPage> createState() => _SaleTargetReportPageState();
}

class _SaleTargetReportPageState extends State<SaleTargetReportPage> {
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TargetProvider>().fetchSaleTargetReport();
    });
  }

  void _fetchData() {
    context.read<TargetProvider>().fetchSaleTargetReport();
  }

  String _formatCurrency(double val) {
    final format = NumberFormat.currency(locale: 'en_IN', symbol: '', decimalDigits: 2);
    return format.format(val);
  }

  Future<void> _printReport(TargetReport report) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.interRegular();
    final fontBold = await PdfGoogleFonts.interBold();
    
    final periodType = context.read<TargetProvider>().selectedPeriodType;
    final year = context.read<TargetProvider>().selectedYear;
    String periodInfo = '$periodType - $year';

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
                      pw.Text('Sale Target Report', style: pw.TextStyle(font: fontBold, fontSize: 18)),
                      pw.Text('Period: $periodInfo', style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey700)),
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
                _pdfSummaryItem('TOTAL TARGET', 'Rs. ${_formatCurrency(report.summary?.totalTarget ?? 0)}', fontBold, font),
                _pdfSummaryItem('TOTAL ACHIEVED', 'Rs. ${_formatCurrency(report.summary?.totalAchieved ?? 0)}', fontBold, font),
                _pdfSummaryItem('ACHIEVEMENT %', '${(report.summary?.ratio ?? 0).toStringAsFixed(2)}%', fontBold, font),
                _pdfSummaryItem('SHORTFALL', 'Rs. ${_formatCurrency(math.max(0, (report.summary?.totalTarget ?? 0) - (report.summary?.totalAchieved ?? 0)))}', fontBold, font),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Text('PARTY-WISE BREAKDOWN', style: pw.TextStyle(font: fontBold, fontSize: 12, color: PdfColors.blueGrey800)),
            pw.SizedBox(height: 8),
            pw.TableHelper.fromTextArray(
              headers: ['#', 'PARTY NAME', 'TARGET', 'ACHIEVED', 'DIFF / GAP', 'ACHIEVEMENT %'],
              data: report.data.asMap().entries.map((entry) {
                final i = entry.key;
                final p = entry.value;
                return [
                  '${i + 1}',
                  p.partyName.toUpperCase(),
                  _formatCurrency(p.targetAmount),
                  _formatCurrency(p.achieved),
                  _formatCurrency(p.difference),
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

  Future<void> _exportToExcel(TargetReport report) async {
    if (report.data.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No data to export')));
      return;
    }

    try {
      var excel = xl.Excel.createExcel();
      xl.Sheet sheetObject = excel['SaleTargetReport'];

      final periodType = context.read<TargetProvider>().selectedPeriodType;
      final year = context.read<TargetProvider>().selectedYear;
      String periodInfo = '$periodType - $year';

      // Title & Date Header
      sheetObject.appendRow([xl.TextCellValue('Sale Target Report')]);
      sheetObject.appendRow([xl.TextCellValue('Period: $periodInfo')]);
      sheetObject.appendRow([]); // Empty row

      // Summary Header Row
      final totalTarget = report.summary?.totalTarget ?? 0.0;
      final totalAchieved = report.summary?.totalAchieved ?? 0.0;
      final ratio = report.summary?.ratio ?? 0.0;
      final shortfall = math.max(0.0, totalTarget - totalAchieved);

      sheetObject.appendRow([
        xl.TextCellValue('TOTAL TARGET'),
        xl.DoubleCellValue(totalTarget),
        xl.TextCellValue('TOTAL ACHIEVED'),
        xl.DoubleCellValue(totalAchieved),
        xl.TextCellValue('ACHIEVEMENT %'),
        xl.DoubleCellValue(ratio),
        xl.TextCellValue('SHORTFALL'),
        xl.DoubleCellValue(shortfall),
      ]);
      sheetObject.appendRow([]); // Empty row

      // Table Headers
      sheetObject.appendRow([
        xl.TextCellValue('SR. NO.'),
        xl.TextCellValue('PARTY NAME'),
        xl.TextCellValue('TARGET'),
        xl.TextCellValue('ACHIEVED'),
        xl.TextCellValue('DIFF / GAP'),
        xl.TextCellValue('ACHIEVEMENT %'),
        xl.TextCellValue('STATUS'),
      ]);

      // Data Rows
      for (int i = 0; i < report.data.length; i++) {
        final p = report.data[i];
        sheetObject.appendRow([
          xl.IntCellValue(i + 1),
          xl.TextCellValue(p.partyName),
          xl.DoubleCellValue(p.targetAmount),
          xl.DoubleCellValue(p.achieved),
          xl.DoubleCellValue(p.difference),
          xl.DoubleCellValue(p.ratio),
          xl.TextCellValue(p.status),
        ]);
      }

      String? outputFile = await FilePicker.saveFile(
        dialogTitle: 'Save Excel File',
        fileName: 'Sale_Target_Report_${periodType}_$year.xlsx',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Matching other reports
      body: Consumer<TargetProvider>(
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

  Widget _buildHeader(TargetProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.indigo.shade600, // Matching the screenshot icon color
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(color: Colors.indigo.shade200, blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: const Icon(LucideIcons.target, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sale Target Report',
                  style: TextStyle(color: Color(0xFF1E293B), fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -0.5),
                ),
                Text(
                  'PERFORMANCE TRACKING & PLANNING',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: IconButton(
                icon: Icon(LucideIcons.download, size: 18, color: Colors.grey.shade600),
                onPressed: () {
                  if (provider.saleReport != null) {
                    _exportToExcel(provider.saleReport!);
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: IconButton(
                icon: Icon(LucideIcons.printer, size: 18, color: Colors.grey.shade600),
                onPressed: () {
                  if (provider.saleReport != null) {
                    _printReport(provider.saleReport!);
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBody(TargetProvider provider) {
    final report = provider.saleReport;
    if (report == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSummaryCards(report.summary),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _buildTop5Chart(report.data)),
              const SizedBox(width: 24),
              Expanded(flex: 1, child: _buildInsightsBox()),
            ],
          ),
          const SizedBox(height: 24),
          _buildFilterAndTable(provider, report),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(TargetSummary? summary) {
    final double totalTarget = summary?.totalTarget ?? 0;
    final double totalAchieved = summary?.totalAchieved ?? 0;
    final double achievementPercent = summary?.ratio ?? 0;
    final double totalShortfall = math.max(0, totalTarget - totalAchieved);

    return Row(
      children: [
        _summaryCard(
          title: 'TOTAL TARGET',
          value: '₹${_formatCurrency(totalTarget)}',
          icon: LucideIcons.target,
          accentColor: Colors.indigo.shade500,
          progress: totalTarget > 0 ? 1.0 : 0.0,
        ),
        const SizedBox(width: 16),
        _summaryCard(
          title: 'TOTAL ACHIEVED',
          value: '₹${_formatCurrency(totalAchieved)}',
          icon: LucideIcons.trendingUp,
          accentColor: Colors.teal.shade500, // Emerald green
          progress: totalTarget > 0 ? (totalAchieved / totalTarget).clamp(0.0, 1.0) : 0.0,
        ),
        const SizedBox(width: 16),
        _summaryCard(
          title: 'ACHIEVEMENT %',
          value: '${achievementPercent.toStringAsFixed(2)}%',
          icon: LucideIcons.barChart2,
          accentColor: Colors.amber.shade500,
          progress: (achievementPercent / 100).clamp(0.0, 1.0),
        ),
        const SizedBox(width: 16),
        _summaryCard(
          title: 'TOTAL SHORTFALL',
          value: '₹${_formatCurrency(totalShortfall)}',
          icon: LucideIcons.trendingDown,
          accentColor: Colors.pink.shade500,
          progress: totalTarget > 0 ? (totalShortfall / totalTarget).clamp(0.0, 1.0) : 0.0,
        ),
      ],
    );
  }

  Widget _summaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color accentColor,
    double? progress,
  }) {
    return Expanded(
      child: Container(
        height: 120, // Match screenshot proportion
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: Colors.grey.shade500,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 20,
              top: 30,
              child: Icon(icon, size: 40, color: accentColor.withAlpha(20)),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 0,
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: progress != null ? Colors.grey.shade100 : accentColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                ),
                alignment: Alignment.centerLeft,
                child: progress != null 
                    ? FractionallySizedBox(
                        widthFactor: progress.clamp(0.0, 1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: accentColor,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                          ),
                        ),
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTop5Chart(List<AgentPerformance> data) {
    var sorted = List<AgentPerformance>.from(data)..sort((a, b) => b.achieved.compareTo(a.achieved));
    final top5 = sorted.take(5).toList();

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
              Icon(LucideIcons.barChart3, size: 16, color: Colors.indigo.shade400),
              const SizedBox(width: 8),
              Text('TARGET VS ACHIEVED (TOP 5)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey.shade800, letterSpacing: 1)),
            ],
          ),
          const SizedBox(height: 24),
          if (top5.isEmpty)
            const SizedBox(height: 150, child: Center(child: Text('No performance data available', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic))))
          else
            ...top5.map((p) {
              final double maxTarget = math.max(p.targetAmount, 1.0); // Avoid div by zero
              final double progressPercent = (p.achieved / maxTarget).clamp(0.0, 1.0);

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(p.partyName.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.indigo.shade900)),
                        Text('${_formatCurrency(p.achieved)} / ${_formatCurrency(p.targetAmount)}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade500)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      height: 8,
                      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(6)),
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: progressPercent,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.indigo.shade500, // Adjust color if achieved >= target
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildInsightsBox() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(LucideIcons.target, size: 24, color: Colors.indigo.shade600),
          ),
          const SizedBox(height: 16),
          const Text('TARGETS INSIGHTS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1)),
          const SizedBox(height: 12),
          Text(
            'OPPORTUNITY FOR GROWTH. CONSIDER REVISING TARGETS OR INCREASING TOUCHPOINTS FOR MAJOR PARTIES.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.indigo.shade400, height: 1.5),
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('VIEW STRATEGY', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.indigo.shade600, letterSpacing: 1)),
                const SizedBox(width: 4),
                Icon(LucideIcons.arrowRight, size: 14, color: Colors.indigo.shade600),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFilterAndTable(TargetProvider provider, TargetReport report) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          // Filter Bar
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.indigo.shade50, shape: BoxShape.circle),
                  child: Icon(LucideIcons.clock, size: 16, color: Colors.indigo.shade600),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade100),
                  ),
                  child: Row(
                    children: ['Monthly', 'Quarterly', 'Yearly'].map((preset) {
                      final isActive = provider.selectedPeriodType == preset;
                      return InkWell(
                        onTap: () {
                          provider.setFilters(periodType: preset);
                          _fetchData();
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                              color: isActive ? Colors.indigo.shade600 : Colors.grey.shade600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 24),
                // Year Dropdown
                _buildDropdown(
                  value: provider.selectedYear,
                  items: List.generate(5, (index) => 2024 + index),
                  onChanged: (val) {
                    provider.setFilters(year: val);
                    _fetchData();
                  },
                ),
                const SizedBox(width: 12),
                // Month/Quarter Dropdown
                if (provider.selectedPeriodType == 'Monthly')
                  _buildDropdown(
                    value: provider.selectedMonth,
                    items: List.generate(12, (index) => index + 1),
                    itemLabelBuilder: (val) => ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][val - 1],
                    onChanged: (val) {
                      provider.setFilters(month: val);
                      _fetchData();
                    },
                  ),
                if (provider.selectedPeriodType == 'Quarterly')
                  _buildDropdown(
                    value: provider.selectedQuarter,
                    items: [1, 2, 3, 4],
                    itemLabelBuilder: (val) => 'Q$val',
                    onChanged: (val) {
                      provider.setFilters(quarter: val);
                      _fetchData();
                    },
                  ),
                const Spacer(),
                // Search Input
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
                    decoration: InputDecoration(
                      hintText: 'Search party performance...',
                      hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                      isDense: true,
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      prefixIcon: const Icon(LucideIcons.search, size: 16, color: Colors.grey),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.indigo.shade500, width: 2)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1, color: Colors.grey.shade100),
          // Table Headers
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            color: Colors.grey.shade50, // Match React app header background
            child: Row(
              children: [
                Expanded(flex: 1, child: Text('SR. NO.', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey.shade500, letterSpacing: 1))),
                Expanded(flex: 4, child: Text('PARTY DETAILS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey.shade500, letterSpacing: 1))),
                Expanded(flex: 2, child: Text('TARGET', textAlign: TextAlign.right, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey.shade500, letterSpacing: 1))),
                Expanded(flex: 2, child: Text('ACHIEVED', textAlign: TextAlign.right, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey.shade500, letterSpacing: 1))),
                Expanded(flex: 3, child: Text('DIFF / GAP', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey.shade500, letterSpacing: 1))),
                Expanded(flex: 3, child: Text('PERFORMANCE PROGRESS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey.shade500, letterSpacing: 1))),
                Expanded(flex: 1, child: Text('ACTIONS', textAlign: TextAlign.right, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey.shade500, letterSpacing: 1))),
              ],
            ),
          ),
          Container(height: 1, color: Colors.grey.shade200),
          // Table Rows
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: report.data.where((p) => p.partyName.toLowerCase().contains(_searchQuery)).length,
            separatorBuilder: (context, index) => Container(height: 1, color: Colors.grey.shade100),
            itemBuilder: (context, index) {
              final items = report.data.where((p) => p.partyName.toLowerCase().contains(_searchQuery)).toList();
              final p = items[index];

              // Calculate diff correctly based on screenshot
              // React screenshot shows DIFF/GAP like "-₹46,770 TO TARGET" for Below Target
              // "+₹1364.25 TO TARGET" for NO TARGET? Or exceeded?
              final diff = p.achieved - p.targetAmount;
              final diffColor = diff >= 0 ? Colors.teal.shade500 : Colors.red.shade500;
              final diffPrefix = diff > 0 ? '+' : '';

              // Progress Bar Logic
              final double maxRange = math.max(p.targetAmount, p.achieved);
              final double safeMax = math.max(maxRange, 1.0);
              final progressPercent = (p.achieved / safeMax).clamp(0.0, 1.0);
              final isAchieved = p.achieved >= p.targetAmount && p.targetAmount > 0;
              final Color progressColor = p.targetAmount == 0 ? Colors.teal.shade500 : (isAchieved ? Colors.teal.shade500 : Colors.red.shade500);

              // Status Chip Logic
              String statusText = p.targetAmount == 0 ? 'NO TARGET' : (isAchieved ? 'ACHIEVED' : 'BELOW TARGET');
              Color statusColor = p.targetAmount == 0 ? Colors.indigo.shade500 : (isAchieved ? Colors.teal.shade500 : Colors.red.shade500);

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 1, child: Text('${index + 1}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.grey.shade400))),
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.partyName.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: statusColor.withAlpha(20), borderRadius: BorderRadius.circular(4)),
                            child: Text(statusText, style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: statusColor, letterSpacing: 0.5)),
                          ),
                        ],
                      ),
                    ),
                    Expanded(flex: 2, child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('₹${_formatCurrency(p.targetAmount)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
                        Text('Target', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey.shade400)),
                      ],
                    )),
                    Expanded(flex: 2, child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('₹${_formatCurrency(p.achieved)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
                        Text('Sales', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey.shade400)),
                      ],
                    )),
                    Expanded(
                      flex: 3, 
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('$diffPrefix₹${_formatCurrency(diff)}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: diffColor)),
                          Text('TO TARGET', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.grey.shade400, letterSpacing: 0.5)),
                        ],
                      )
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 6,
                              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(3)),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: progressPercent,
                                child: Container(decoration: BoxDecoration(color: progressColor, borderRadius: BorderRadius.circular(3))),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 50,
                            child: Text(
                              p.targetAmount == 0 ? '0%' : '${(p.achieved / p.targetAmount * 100).toStringAsFixed(2)}%',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: progressColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(LucideIcons.pencil, size: 16, color: Colors.indigo.shade400),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              // Edit Target Action
                              _showTargetEntryDialog(p.partyName);
                            },
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            icon: Icon(LucideIcons.history, size: 16, color: Colors.grey.shade500),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              // History Action
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          if (report.data.where((p) => p.partyName.toLowerCase().contains(_searchQuery)).isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: const Center(child: Text('No targets found for the selected period.', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic))),
            ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required dynamic value,
    required List<dynamic> items,
    required Function(dynamic) onChanged,
    String Function(dynamic)? itemLabelBuilder,
  }) {
    return Container(
      height: 36, // Ensure height matches filter presets
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<dynamic>(
          value: value,
          icon: Icon(LucideIcons.chevronDown, size: 14, color: Colors.grey.shade600),
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
          items: items.map((e) => DropdownMenuItem(
            value: e,
            child: Text(itemLabelBuilder?.call(e) ?? e.toString(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
          )).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // Same Target Entry Dialog conceptually, styled slightly
  void _showTargetEntryDialog(String partyName) {
    showDialog(
      context: context,
      builder: (context) {
        final amountCtrl = TextEditingController();
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Colors.white,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.indigo.shade600,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(LucideIcons.target, color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 12),
                          const Text('Set Sales Target', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
                        ],
                      ),
                      IconButton(
                        icon: Icon(LucideIcons.x, color: Colors.grey.shade400, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade50.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.indigo.shade100.withOpacity(0.5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('TARGET INDIVIDUAL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.indigo.shade600, letterSpacing: 1)),
                        const SizedBox(height: 8),
                        Text(partyName.toUpperCase(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.indigo.shade900)),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.indigo.shade100)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(LucideIcons.calendar, size: 12, color: Colors.indigo.shade400),
                              const SizedBox(width: 6),
                              Consumer<TargetProvider>(
                                builder: (context, provider, _) {
                                  String periodText = '${provider.selectedPeriodType} • ${provider.selectedYear}';
                                  if (provider.selectedPeriodType == 'Monthly') {
                                    final monthStr = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][provider.selectedMonth - 1];
                                    periodText = '$monthStr • ${provider.selectedYear}';
                                  } else if (provider.selectedPeriodType == 'Quarterly') {
                                    periodText = 'Q${provider.selectedQuarter} • ${provider.selectedYear}';
                                  }
                                  return Text(periodText, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.indigo.shade600));
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('TARGET AMOUNT (₹)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey.shade600, letterSpacing: 1)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: amountCtrl,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.indigo.shade200)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.indigo.shade200)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.indigo.shade500, width: 2)),
                      suffixIcon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(LucideIcons.chevronUp, size: 16, color: Colors.grey.shade400),
                          Icon(LucideIcons.chevronDown, size: 16, color: Colors.grey.shade400),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(LucideIcons.alertCircle, size: 16, color: Colors.orange.shade600),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'THIS TARGET WILL APPLY ONLY TO THE SELECTED PERIOD. HISTORICAL TARGETS WILL REMAIN UNAFFECTED.',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.deepOrange, height: 1.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('CANCEL', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.grey.shade600, letterSpacing: 1)),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          final amount = double.tryParse(amountCtrl.text) ?? 0;
                          if (amount > 0) {
                            context.read<TargetProvider>().saveTarget(
                              partyId: partyName, 
                              partyName: partyName,
                              amount: amount,
                              isCollection: false,
                            ).then((_) {
                              if (context.mounted) Navigator.pop(context);
                            });
                          }
                        },
                        icon: const Icon(LucideIcons.checkCircle2, size: 16),
                        label: const Text('SAVE TARGET', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1)),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          backgroundColor: Colors.indigo.shade600,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
