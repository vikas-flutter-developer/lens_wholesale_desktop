import 'dart:math' as math;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart' as xl;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';
import 'package:printing/printing.dart';
import '../../data/providers/operational_report_provider.dart';
import '../../data/models/operational_report_model.dart';

// ─── Page ────────────────────────────────────────────────────────────────────
class CancelledOrderRatioPage extends StatefulWidget {
  const CancelledOrderRatioPage({super.key});

  @override
  State<CancelledOrderRatioPage> createState() => _CancelledOrderRatioPageState();
}

class _CancelledOrderRatioPageState extends State<CancelledOrderRatioPage> {
  late String _dateFrom;
  late String _dateTo;
  String _transactionType = 'Both';
  String _searchTerm = '';
  String _partySearch = '';
  String _sortKey = 'ratio';
  String _sortDir = 'desc';

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _dateFrom = DateFormat('yyyy-MM-01').format(now);
    _dateTo = DateFormat('yyyy-MM-dd').format(now);
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetch());
  }

  void _fetch() {
    context.read<OperationalReportProvider>().fetchCancelledOrderRatioReport({
      'dateFrom': _dateFrom,
      'dateTo': _dateTo,
      'transactionType': _transactionType,
    });
  }

  void _setPeriod(String type) {
    final now = DateTime.now();
    String from, to = DateFormat('yyyy-MM-dd').format(now);
    if (type == 'current_month') {
      from = DateFormat('yyyy-MM-01').format(now);
    } else if (type == 'last_quarter') {
      final q = (now.month - 1) ~/ 3;
      final qFrom = DateTime(now.year, q * 3 + 1, 1);
      final qTo = DateTime(now.year, (q + 1) * 3 + 1, 0);
      from = DateFormat('yyyy-MM-dd').format(qFrom);
      to = DateFormat('yyyy-MM-dd').format(qTo);
    } else {
      from = '${now.year}-01-01';
    }
    setState(() { _dateFrom = from; _dateTo = to; });
    _fetch();
  }

  Future<void> _pickDate(bool isFrom) async {
    final initial = DateTime.tryParse(isFrom ? _dateFrom : _dateTo) ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && mounted) {
      setState(() {
        if (isFrom) _dateFrom = DateFormat('yyyy-MM-dd').format(picked);
        else _dateTo = DateFormat('yyyy-MM-dd').format(picked);
      });
      _fetch();
    }
  }

  Future<void> _exportExcel(CancelledOrderRatioReport report) async {
    try {
      final filtered = report.details.where((d) => d.status.toLowerCase() == 'cancelled').toList();
      final excel = xl.Excel.createExcel();
      final sheet = excel['Cancelled Orders'];
      sheet.appendRow([
        xl.TextCellValue('Sr. No.'), xl.TextCellValue('Date'), xl.TextCellValue('Type'),
        xl.TextCellValue('Document'), xl.TextCellValue('Party Name'), xl.TextCellValue('Amount'), xl.TextCellValue('Status'), xl.TextCellValue('Cancelled'),
      ]);
      for (int i = 0; i < filtered.length; i++) {
        final d = filtered[i];
        sheet.appendRow([
          xl.IntCellValue(i + 1), xl.TextCellValue(d.date), xl.TextCellValue(d.transactionType),
          xl.TextCellValue(d.label), xl.TextCellValue(d.partyName), xl.DoubleCellValue(d.netAmount), xl.TextCellValue(d.status),
          xl.TextCellValue(d.cancelledOrders == 1 ? "Yes" : "No"),
        ]);
      }
      final path = await FilePicker.saveFile(
        dialogTitle: 'Save Excel',
        fileName: 'Cancelled_Order_Ratio_${_dateFrom}_to_$_dateTo.xlsx',
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );
      if (path != null) {
        final bytes = excel.encode();
        if (bytes != null) {
          await File(path).writeAsBytes(bytes);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Excel exported successfully!')),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _print(CancelledOrderRatioReport report) async {
    final font = await PdfGoogleFonts.interRegular();
    final bold = await PdfGoogleFonts.interBold();
    final pdf = pw.Document();
    final filtered = report.details.where((d) => d.status.toLowerCase() == 'cancelled').toList();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(28),
        build: (ctx) => [
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
            pw.Text('Cancelled Order Ratio Report', style: pw.TextStyle(font: bold, fontSize: 18)),
            pw.Text('Period: $_dateFrom to $_dateTo', style: pw.TextStyle(font: font, fontSize: 9, color: PdfColors.grey600)),
          ]),
          pw.SizedBox(height: 20),
          pw.Row(children: [
            _pdfCard('TOTAL ORDERS', report.summary.totalOrders?.toString() ?? '0', bold, font),
            pw.SizedBox(width: 16),
            _pdfCard('CANCELLED', report.summary.cancelledOrders?.toString() ?? '0', bold, font),
            pw.SizedBox(width: 16),
            _pdfCard('ACTIVE', report.summary.activeOrders?.toString() ?? '0', bold, font),
            pw.SizedBox(width: 16),
            _pdfCard('RATIO', '${report.summary.ratio?.toStringAsFixed(1) ?? 0}%', bold, font),
          ]),
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            headers: ['#', 'DATE', 'TYPE', 'DOCUMENT', 'PARTY NAME', 'AMOUNT', 'STATUS'],
            data: filtered.asMap().entries.map((e) => [
              '${e.key + 1}', e.value.date, e.value.transactionType, e.value.label,
              e.value.partyName, '₹${e.value.netAmount.toStringAsFixed(0)}', e.value.status,
            ]).toList(),
            headerStyle: pw.TextStyle(font: bold, fontSize: 7, color: PdfColors.white),
            cellStyle: pw.TextStyle(font: font, fontSize: 7),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.red800),
            cellAlignment: pw.Alignment.centerLeft,
            columnWidths: {0: const pw.FixedColumnWidth(20)},
          ),
        ],
      ),
    );
    await Printing.layoutPdf(onLayout: (_) => pdf.save());
  }

  pw.Widget _pdfCard(String label, String val, pw.Font bold, pw.Font reg) => pw.Expanded(
    child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.Text(label, style: pw.TextStyle(font: reg, fontSize: 7, color: PdfColors.grey600)),
      pw.Text(val, style: pw.TextStyle(font: bold, fontSize: 14)),
    ]),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Consumer<OperationalReportProvider>(
        builder: (context, provider, _) {
          final report = provider.cancelledOrderRatioReport;

          // Derived lists
          final filteredDetails = report == null ? <CancelledOrderRatioDetail>[] :
            report.details.where((d) {
              final isCancelled = d.status.toLowerCase() == 'cancelled';
              if (!isCancelled) return false;
              if (_searchTerm.isEmpty) return true;
              final t = _searchTerm.toLowerCase();
              return d.partyName.toLowerCase().contains(t) || d.label.toLowerCase().contains(t);
            }).toList();

          List<PartyWiseRatio> sortedParties = report == null ? [] : [...report.partyWise];
          if (_partySearch.isNotEmpty) {
            sortedParties = sortedParties.where((p) => p.partyName.toLowerCase().contains(_partySearch.toLowerCase())).toList();
          }
          sortedParties.sort((a, b) {
            dynamic av = _sortKey == 'partyName' ? a.partyName : _sortKey == 'totalOrders' ? a.totalOrders : _sortKey == 'cancelledOrders' ? a.cancelledOrders : a.ratio;
            dynamic bv = _sortKey == 'partyName' ? b.partyName : _sortKey == 'totalOrders' ? b.totalOrders : _sortKey == 'cancelledOrders' ? b.cancelledOrders : b.ratio;
            final cmp = (av is String) ? av.compareTo(bv as String) : (av as num).compareTo(bv as num);
            return _sortDir == 'asc' ? cmp : -cmp;
          });

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader(report, provider)),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Summary cards
                    if (report != null) _buildSummaryCards(report.summary),
                    if (report != null) const SizedBox(height: 24),

                    // Main 2-col layout
                    if (provider.isLoading)
                      const SizedBox(height: 300, child: Center(child: CircularProgressIndicator(color: Color(0xFFDC2626))))
                    else if (report != null) ...[
                      _buildFiltersAndCharts(report),
                      const SizedBox(height: 24),
                      _buildTransactionalBreakdown(filteredDetails, provider.isLoading),
                      const SizedBox(height: 24),
                      _buildPartyWiseTable(sortedParties),
                    ],
                    const SizedBox(height: 40),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ─── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeader(CancelledOrderRatioReport? report, OperationalReportProvider provider) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFDC2626),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: const Color(0xFFDC2626).withAlpha(60), blurRadius: 12, offset: const Offset(0, 4))],
            ),
            child: const Icon(LucideIcons.activity, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Cancelled Order Ratio Report',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1E293B), letterSpacing: -0.5)),
              Text('Analyze cancellation trends and ratios across transactions',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
            ],
          ),
          const Spacer(),
          // Export
          _headerButton(
            label: 'Export',
            icon: LucideIcons.download,
            onTap: report != null ? () => _exportExcel(report) : null,
            dark: false,
          ),
          const SizedBox(width: 10),
          // Print
          _headerButton(
            label: 'Print',
            icon: LucideIcons.printer,
            onTap: report != null ? () => _print(report) : null,
            dark: true,
          ),
        ],
      ),
    );
  }

  Widget _headerButton({required String label, required IconData icon, VoidCallback? onTap, required bool dark}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: dark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: dark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 4, offset: const Offset(0, 1))],
        ),
        child: Row(
          children: [
            Icon(icon, size: 15, color: dark ? Colors.white : const Color(0xFF475569)),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: dark ? Colors.white : const Color(0xFF475569))),
          ],
        ),
      ),
    );
  }

  // ─── Summary Cards ─────────────────────────────────────────────────────────
  Widget _buildSummaryCards(CancelledOrderRatioSummary s) {
    final ratio = s.ratio ?? 0;
    final isHigh = ratio > 20;
    return Row(
      children: [
        _summaryCard(label: 'TOTAL ORDERS', value: (s.totalOrders ?? 0).toString(), watermark: LucideIcons.activity,
            accent: const Color(0xFF4F46E5), badge: 'Gross orders count', badgeColor: const Color(0xFF4F46E5)),
        const SizedBox(width: 16),
        _summaryCard(label: 'CANCELLED ORDERS', value: (s.cancelledOrders ?? 0).toString(), watermark: LucideIcons.alertCircle,
            accent: const Color(0xFFDC2626), badge: 'Total cancellations', badgeColor: const Color(0xFFDC2626)),
        const SizedBox(width: 16),
        _summaryCard(label: 'ACTIVE ORDERS', value: (s.activeOrders ?? 0).toString(), watermark: LucideIcons.trendingUp,
            accent: const Color(0xFF059669), badge: 'Processable orders', badgeColor: const Color(0xFF059669)),
        const SizedBox(width: 16),
        _ratioBadgeCard(ratio: ratio, isHigh: isHigh),
      ],
    );
  }

  Widget _summaryCard({required String label, required String value, required IconData watermark, required Color accent, required String badge, required Color badgeColor}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(6), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Stack(
          children: [
            Positioned(right: 0, top: -4, child: Icon(watermark, size: 56, color: accent.withAlpha(20))),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 1)),
                const SizedBox(height: 8),
                Text(value, style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: accent)),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: badgeColor.withAlpha(16), borderRadius: BorderRadius.circular(20)),
                  child: Text(badge, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: badgeColor)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _ratioBadgeCard({required double ratio, required bool isHigh}) {
    final color = isHigh ? const Color(0xFFDC2626) : const Color(0xFF2563EB);
    final bg = isHigh ? const Color(0xFFFEF2F2) : const Color(0xFFEFF6FF);
    final borderColor = isHigh ? const Color(0xFFFECACA) : const Color(0xFFBFDBFE);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20), border: Border.all(color: borderColor)),
        child: Stack(
          children: [
            Positioned(right: 0, top: -4, child: Icon(LucideIcons.percent, size: 56, color: color.withAlpha(40))),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CANCELLATION RATIO', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: color.withAlpha(180), letterSpacing: 1)),
                const SizedBox(height: 8),
                Text('${ratio.toStringAsFixed(1)}%', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: color)),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: color.withAlpha(25), borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(isHigh ? LucideIcons.trendingUp : LucideIcons.trendingDown, size: 12, color: color),
                      const SizedBox(width: 4),
                      Text(isHigh ? 'Attention Needed' : 'Optimized Flow', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: color)),
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

  // ─── Filter + Charts Row ───────────────────────────────────────────────────
  Widget _buildFiltersAndCharts(CancelledOrderRatioReport report) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left col (flex:8) — filters + 2 mini charts
        Expanded(
          flex: 8,
          child: Column(
            children: [
              _buildFilterCard(),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: _buildHighCancellationParties(report.partyWise)),
                  const SizedBox(width: 20),
                  Expanded(child: _buildSalePurchaseIndex(report.summary)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        // Right col (flex:4) — composition + trend
        Expanded(
          flex: 4,
          child: Column(
            children: [
              _buildCompositionCard(report.summary),
              const SizedBox(height: 20),
              _buildTrendCard(report.trend),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Filter Card ───────────────────────────────────────────────────────────
  Widget _buildFilterCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        children: [
          // Title row
          Row(
            children: [
              Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(8)),
                child: const Icon(LucideIcons.filter, size: 18, color: Color(0xFF2563EB))),
              const SizedBox(width: 12),
              const Text('FILTER CONFIGURATION', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF1E293B), letterSpacing: 1.5)),
              const Spacer(),
              // Quick period buttons
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFF1F5F9))),
                child: Row(
                  children: [
                    for (final p in [('current_month', 'MONTH'), ('last_quarter', 'QUARTER'), ('current_year', 'YEAR')])
                      GestureDetector(
                        onTap: () => _setPeriod(p.$1),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                          child: Text(p.$2, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.grey.shade500, letterSpacing: 0.8)),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Fields row
          Row(
            children: [
              Expanded(child: _filterField(label: 'FROM', icon: LucideIcons.calendar, value: _dateFrom.replaceAll('-', '-'), onTap: () => _pickDate(true))),
              const SizedBox(width: 16),
              Expanded(child: _filterField(label: 'TO', icon: LucideIcons.calendar, value: _dateTo.replaceAll('-', '-'), onTap: () => _pickDate(false))),
              const SizedBox(width: 16),
              // Type dropdown
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [const Icon(LucideIcons.activity, size: 12, color: Color(0xFF94A3B8)), const SizedBox(width: 6),
                      const Text('TYPE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 1))]),
                    const SizedBox(height: 8),
                    Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE2E8F0))),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _transactionType,
                          isExpanded: true,
                          icon: Icon(LucideIcons.chevronDown, size: 14, color: Colors.grey.shade500),
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
                          items: const [
                            DropdownMenuItem(value: 'Both', child: Text('Both (Sale/Purchase)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900))),
                            DropdownMenuItem(value: 'Sale', child: Text('Sales Only', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900))),
                            DropdownMenuItem(value: 'Purchase', child: Text('Purchase Only', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900))),
                          ],
                          onChanged: (v) { setState(() => _transactionType = v!); _fetch(); },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Search
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [const Icon(LucideIcons.search, size: 12, color: Color(0xFF94A3B8)), const SizedBox(width: 6),
                      const Text('QUICK SEARCH', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 1))]),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 44,
                      child: TextField(
                        onChanged: (v) => setState(() => _searchTerm = v),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
                        decoration: InputDecoration(
                          filled: true, fillColor: const Color(0xFFF8FAFC),
                          hintText: 'Party / Document...', hintStyle: const TextStyle(fontSize: 12, color: Color(0xFFCBD5E1), fontWeight: FontWeight.bold),
                          prefixIcon: const Icon(LucideIcons.search, size: 14, color: Color(0xFFCBD5E1)),
                          isDense: true, contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1.5)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _filterField({required String label, required IconData icon, required String value, required VoidCallback onTap}) {
    // format value from yyyy-MM-dd to dd-MM-yyyy for display
    String display = value;
    try {
      final d = DateTime.parse(value);
      display = DateFormat('dd-MM-yyyy').format(d);
    } catch (_) {}

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [Icon(icon, size: 12, color: const Color(0xFF94A3B8)), const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 1))]),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE2E8F0))),
            child: Row(
              children: [
                Text(display, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
                const Spacer(),
                const Icon(LucideIcons.calendar, size: 14, color: Color(0xFF94A3B8)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─── High Cancellation Parties ─────────────────────────────────────────────
  Widget _buildHighCancellationParties(List<PartyWiseRatio> partyWise) {
    final high = partyWise.where((p) => p.ratio > 25).toList()..sort((a, b) => b.ratio.compareTo(a.ratio));
    final top4 = high.take(4).toList();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFF1F5F9))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(LucideIcons.trendingDown, size: 18, color: Color(0xFFDC2626))),
              const SizedBox(width: 10),
              const Text('HIGH CANCELLATION PARTIES', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFF1E293B), letterSpacing: 1)),
            ],
          ),
          const SizedBox(height: 20),
          if (top4.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: Text('Optimal performance across all parties',
                    style: TextStyle(fontSize: 11, color: Color(0xFFCBD5E1), fontStyle: FontStyle.italic, fontWeight: FontWeight.w900)),
              ),
            )
          else
            ...top4.asMap().entries.map((e) {
              final p = e.value;
              return Container(
                margin: EdgeInsets.only(bottom: e.key < top4.length - 1 ? 10 : 0),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: const Color(0xFFFFF5F5), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFFECACA).withAlpha(100))),
                child: Row(
                  children: [
                    Container(
                      width: 36, height: 36, alignment: Alignment.center,
                      decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(10)),
                      child: Text('${e.key + 1}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFFDC2626))),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.partyName.toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF7F1D1D))),
                          Text('${p.totalOrders} total orders', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFFF87171))),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('${p.ratio.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFFB91C1C))),
                        const Text('RATIO', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFFF87171))),
                      ],
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  // ─── Sale vs Purchase Index ────────────────────────────────────────────────
  Widget _buildSalePurchaseIndex(CancelledOrderRatioSummary summary) {
    final saleRatio = ((summary.sale?['ratio'] as num?) ?? 0).toDouble();
    final purchaseRatio = ((summary.purchase?['ratio'] as num?) ?? 0).toDouble();
    final maxRatio = math.max(math.max(saleRatio, purchaseRatio), 10.0);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFF1F5F9))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(LucideIcons.barChart3, size: 18, color: Color(0xFF4F46E5))),
              const SizedBox(width: 10),
              const Text('SALE VS PURCHASE INDEX', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFF1E293B), letterSpacing: 1)),
            ],
          ),
          const SizedBox(height: 28),
          _indexBar('SALE CANCELLATION', saleRatio, maxRatio, const Color(0xFF3B82F6)),
          const SizedBox(height: 20),
          _indexBar('PURCHASE CANCELLATION', purchaseRatio, maxRatio, const Color(0xFFF59E0B)),
        ],
      ),
    );
  }

  Widget _indexBar(String label, double ratio, double maxRatio, Color color) {
    final fraction = maxRatio > 0 ? (ratio / maxRatio).clamp(0.0, 1.0) : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFF64748B), letterSpacing: 0.5)),
          Text('${ratio.toStringAsFixed(1)}%', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: color)),
        ]),
        const SizedBox(height: 8),
        Container(
          height: 10,
          decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(5)),
          child: FractionallySizedBox(
            widthFactor: fraction,
            alignment: Alignment.centerLeft,
            child: Container(decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(5))),
          ),
        ),
      ],
    );
  }

  // ─── Composition Donut ─────────────────────────────────────────────────────
  Widget _buildCompositionCard(CancelledOrderRatioSummary s) {
    final total = s.totalOrders ?? 0;
    final cancelled = s.cancelledOrders ?? 0;
    final active = s.activeOrders ?? 0;
    final ratio = s.ratio ?? 0.0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFF1F5F9))),
      child: Column(
        children: [
          Row(children: [
            const Icon(LucideIcons.pieChart, size: 18, color: Color(0xFF4F46E5)),
            const SizedBox(width: 10),
            const Text('OVERALL COMPOSITION', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFF1E293B), letterSpacing: 1)),
          ]),
          const SizedBox(height: 28),
          SizedBox(
            height: 130,
            width: 130,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(130, 130),
                  painter: _DonutPainter(
                    activePercent: total > 0 ? active / total : 1.0,
                    cancelledPercent: total > 0 ? cancelled / total : 0.0,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('RATIO', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 0.5)),
                    Text('${ratio.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFF1F5F9))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF059669), shape: BoxShape.circle)), const SizedBox(width: 6), const Text('ACTIVE', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8)))]),
                      const SizedBox(height: 4),
                      Text(active.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFF1F5F9))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFFDC2626), shape: BoxShape.circle)), const SizedBox(width: 6), const Text('CANCELLED', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8)))]),
                      const SizedBox(height: 4),
                      Text(cancelled.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
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

  // ─── Cancellation Trend ────────────────────────────────────────────────────
  Widget _buildTrendCard(List<RatioTrend> trend) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFF1F5F9))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(LucideIcons.trendingUp, size: 18, color: Color(0xFF3B82F6)),
            const SizedBox(width: 10),
            const Text('CANCELLATION TREND', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFF1E293B), letterSpacing: 1)),
          ]),
          const SizedBox(height: 20),
          if (trend.isEmpty)
            const SizedBox(height: 120, child: Center(child: Text('No trend data', style: TextStyle(color: Color(0xFFCBD5E1), fontStyle: FontStyle.italic, fontWeight: FontWeight.w900))))
          else
            SizedBox(
              height: 140,
              child: _TrendChart(trend: trend.length > 12 ? trend.sublist(trend.length - 12) : trend),
            ),
        ],
      ),
    );
  }

  // ─── Transactional Breakdown Table ─────────────────────────────────────────
  Widget _buildTransactionalBreakdown(List<CancelledOrderRatioDetail> details, bool loading) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFF1F5F9))),
      child: Column(
        children: [
          // Table header bar
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
            child: Row(
              children: [
                Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(14)),
                    child: const Icon(LucideIcons.receipt, size: 18, color: Colors.white)),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Transactional Breakdown', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
                    Text('AUDIT LOG OF ALL PROCESSED ENTRIES', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 0.8)),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE2E8F0))),
                  child: Row(
                    children: [
                      const Text('LIVE RESULT COUNT: ', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 0.5)),
                      Text('${details.length}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF2563EB))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF8FAFC)),
          // Column headers
          Container(
            color: const Color(0xFFF8FAFC),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            child: const Row(
              children: [
                Expanded(flex: 2, child: Text('DATE', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 0.8))),
                Expanded(flex: 1, child: Text('TYPE', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 0.8))),
                Expanded(flex: 2, child: Text('DOC TYPE', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 0.8))),
                Expanded(flex: 3, child: Text('PARTY NAME', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 0.8))),
                Expanded(flex: 2, child: Text('AMOUNT', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 0.8))),
                SizedBox(width: 100, child: Center(child: Text('STATUS', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 0.8)))),
              ],
            ),
          ),
          // Rows
          if (loading)
            const Padding(padding: EdgeInsets.symmetric(vertical: 60), child: Center(child: CircularProgressIndicator(color: Color(0xFFDC2626))))
          else if (details.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 60),
              child: Column(
                children: [
                  Icon(LucideIcons.alertCircle, size: 40, color: Colors.grey.withAlpha(60)),
                  const SizedBox(height: 10),
                  const Text('Inventory log is currently empty for filters',
                      style: TextStyle(fontSize: 11, color: Color(0xFFCBD5E1), fontWeight: FontWeight.w900, fontStyle: FontStyle.italic)),
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: details.length,
              separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF8FAFC)),
              itemBuilder: (_, i) => _detailRow(details[i]),
            ),
        ],
      ),
    );
  }

  Widget _detailRow(CancelledOrderRatioDetail d) {
    final isSale = d.transactionType == 'Sale';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: Colors.grey.shade50))),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(d.date, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF334155))),
                const Text('TIMESTAMP LOG', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8))),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: isSale ? const Color(0xFFEFF6FF) : const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(d.transactionType, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: isSale ? const Color(0xFF2563EB) : const Color(0xFFD97706))),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(d.label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  width: 30, height: 30,
                  decoration: const BoxDecoration(color: Color(0xFFF1F5F9), shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: const Icon(LucideIcons.user, size: 14, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(d.partyName.toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)))),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text('₹${NumberFormat('#,##,##0').format(d.netAmount.toInt())}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
          ),
          SizedBox(
            width: 100,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: d.status.toLowerCase() == 'cancelled' ? const Color(0xFFDC2626) : const Color(0xFF059669),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(d.status.toUpperCase(), style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 0.5)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Party-wise Performance Table ──────────────────────────────────────────
  Widget _buildPartyWiseTable(List<PartyWiseRatio> parties) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFF1F5F9))),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
            child: Row(
              children: [
                Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFF4F46E5), borderRadius: BorderRadius.circular(14)),
                    child: const Icon(LucideIcons.user, size: 18, color: Colors.white)),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Party-wise Performance', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
                    Text('CONSOLIDATED RATIO PER ACCOUNT', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 0.8)),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    // Party search
                    SizedBox(
                      width: 220,
                      height: 38,
                      child: TextField(
                        onChanged: (v) => setState(() => _partySearch = v),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
                        decoration: InputDecoration(
                          filled: true, fillColor: const Color(0xFFF8FAFC),
                          hintText: 'Search party...', hintStyle: const TextStyle(fontSize: 11, color: Color(0xFFCBD5E1), fontWeight: FontWeight.bold),
                          prefixIcon: const Icon(LucideIcons.search, size: 14, color: Color(0xFFCBD5E1)),
                          isDense: true, contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 1.5)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text('SORT: ', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.grey.shade400)),
                    Text('$_sortKey ($_sortDir)', style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Color(0xFF4F46E5))),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF8FAFC)),
          // Header
          Container(
            color: const Color(0xFFF8FAFC),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            child: Row(
              children: [
                Expanded(flex: 4, child: _sortHeader('PARTY NAME', 'partyName')),
                Expanded(flex: 2, child: Center(child: _sortHeader('TOTAL ORDERS', 'totalOrders'))),
                Expanded(flex: 2, child: Center(child: _sortHeader('CANCELLED', 'cancelledOrders'))),
                Expanded(flex: 3, child: Center(child: _sortHeader('CANCELLATION %', 'ratio'))),
              ],
            ),
          ),
          // Rows
          if (parties.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(child: Text('No party data found', style: TextStyle(color: Color(0xFFCBD5E1), fontWeight: FontWeight.w900, fontStyle: FontStyle.italic))),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: parties.length,
              separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF8FAFC)),
              itemBuilder: (_, i) => _partyRow(parties[i]),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _sortHeader(String label, String key) {
    final active = _sortKey == key;
    return GestureDetector(
      onTap: () => setState(() {
        if (_sortKey == key) _sortDir = _sortDir == 'desc' ? 'asc' : 'desc';
        else { _sortKey = key; _sortDir = 'desc'; }
      }),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: active ? const Color(0xFF4F46E5) : const Color(0xFF94A3B8), letterSpacing: 0.8)),
          const SizedBox(width: 4),
          if (active) Icon(_sortDir == 'desc' ? LucideIcons.chevronDown : LucideIcons.chevronUp, size: 12, color: const Color(0xFF4F46E5)),
        ],
      ),
    );
  }

  Widget _partyRow(PartyWiseRatio p) {
    final isHigh = p.ratio > 20;
    final barColor = isHigh ? const Color(0xFFEF4444) : const Color(0xFF3B82F6);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(p.partyName.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF334155))),
          ),
          Expanded(
            flex: 2,
            child: Center(child: Text(p.totalOrders.toString(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B)))),
          ),
          Expanded(
            flex: 2,
            child: Center(child: Text(p.cancelledOrders.toString(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFEF4444)))),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100, height: 8,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (p.ratio / 100).clamp(0, 1),
                      backgroundColor: const Color(0xFFF1F5F9),
                      valueColor: AlwaysStoppedAnimation<Color>(barColor),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 44,
                  child: Text('${p.ratio.toStringAsFixed(1)}%',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: barColor)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Donut Painter ────────────────────────────────────────────────────────────
class _DonutPainter extends CustomPainter {
  final double activePercent;
  final double cancelledPercent;

  _DonutPainter({required this.activePercent, required this.cancelledPercent});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2, cy = size.height / 2;
    final radius = (size.width / 2) - 10;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.butt;

    const startAngle = -math.pi / 2;

    // Active (green/emerald)
    paint.color = const Color(0xFF059669);
    canvas.drawArc(Rect.fromCircle(center: Offset(cx, cy), radius: radius),
        startAngle, activePercent * 2 * math.pi, false, paint);

    // Cancelled (red)
    paint.color = const Color(0xFFDC2626);
    canvas.drawArc(Rect.fromCircle(center: Offset(cx, cy), radius: radius),
        startAngle + activePercent * 2 * math.pi, cancelledPercent * 2 * math.pi, false, paint);

    // Background track if empty
    if (activePercent == 0 && cancelledPercent == 0) {
      paint.color = const Color(0xFFF1F5F9);
      canvas.drawCircle(Offset(cx, cy), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ─── Trend Chart ─────────────────────────────────────────────────────────────
class _TrendChart extends StatelessWidget {
  final List<RatioTrend> trend;
  const _TrendChart({required this.trend});

  @override
  Widget build(BuildContext context) {
    final maxRatio = trend.map((t) => t.ratio).fold(0.0, math.max).clamp(5.0, double.infinity);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: trend.map((t) {
        final isHigh = t.ratio > 10;
        final barH = ((t.ratio / maxRatio) * 100).clamp(4.0, 100.0);

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('${t.ratio.toInt()}%', style: const TextStyle(fontSize: 7, fontWeight: FontWeight.w900, color: Color(0xFF64748B))),
                const SizedBox(height: 4),
                Container(
                  height: barH,
                  decoration: BoxDecoration(
                    color: isHigh ? const Color(0xFFF87171) : const Color(0xFF94A3B8),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
                  ),
                ),
                const SizedBox(height: 6),
                RotatedBox(
                  quarterTurns: 1,
                  child: Text(t.period.length > 7 ? t.period.substring(2) : t.period,
                      style: const TextStyle(fontSize: 6, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
