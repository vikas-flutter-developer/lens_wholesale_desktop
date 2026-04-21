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
import '../../data/models/collection_target_model.dart';
import '../../data/services/target_service.dart';

// ─── Helpers ──────────────────────────────────────────────────────────────────
String _inr(double v) {
  final fmt = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);
  return fmt.format(v);
}

Color _statusColor(double perf) {
  if (perf >= 100) return const Color(0xFF10B981); // emerald
  if (perf >= 70) return const Color(0xFFF59E0B); // amber
  return const Color(0xFFF43F5E); // rose
}

// ─── Main Page ───────────────────────────────────────────────────────────────
class CollectionTargetReportPage extends StatefulWidget {
  const CollectionTargetReportPage({super.key});

  @override
  State<CollectionTargetReportPage> createState() => _CollectionTargetReportPageState();
}

class _CollectionTargetReportPageState extends State<CollectionTargetReportPage> {
  String _activeTab = 'Customer'; // 'Customer' | 'Vendor'

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TargetProvider>().fetchCollectionTargetReport(_activeTab);
    });
  }

  void _switchTab(String tab) {
    setState(() => _activeTab = tab);
    context.read<TargetProvider>().fetchCollectionTargetReport(tab);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Consumer<TargetProvider>(
        builder: (context, provider, _) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildPeriodFilter(provider),
                      const SizedBox(height: 16),
                      _buildTabRow(),
                      const SizedBox(height: 24),
                      if (provider.isLoading)
                        const SizedBox(
                          height: 300,
                          child: Center(child: CircularProgressIndicator(color: Color(0xFF4F46E5))),
                        )
                      else
                        _CollectionSection(
                          key: ValueKey(_activeTab),
                          targetType: _activeTab,
                          provider: provider,
                        ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
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
              gradient: const LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: const Color(0xFF4F46E5).withAlpha(60), blurRadius: 12, offset: const Offset(0, 4))],
            ),
            child: const Icon(LucideIcons.wallet, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Customer / Vendor Collection Report',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1E293B), letterSpacing: -0.5),
              ),
              Text(
                'COLLECTION TARGET TRACKING & PERFORMANCE',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade500, letterSpacing: 1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodFilter(TargetProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
            child: const Icon(LucideIcons.clock, size: 16, color: Color(0xFF4F46E5)),
          ),
          const SizedBox(width: 12),
          // Period type toggle
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: ['Monthly', 'Quarterly', 'Yearly'].map((tp) {
                final isActive = provider.selectedPeriodType == tp;
                return GestureDetector(
                  onTap: () {
                    provider.setFilters(periodType: tp);
                    provider.fetchCollectionTargetReport(_activeTab);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isActive ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: isActive ? [const BoxShadow(color: Color(0x0A000000), blurRadius: 4, offset: Offset(0, 1))] : [],
                    ),
                    child: Text(
                      tp.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: isActive ? const Color(0xFF4F46E5) : Colors.grey.shade500,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(width: 16),
          // Year dropdown
          _buildDropdown(
            value: provider.selectedYear,
            items: List.generate(5, (i) => DateTime.now().year - 2 + i),
            onChanged: (val) {
              provider.setFilters(year: val as int);
              provider.fetchCollectionTargetReport(_activeTab);
            },
          ),
          const SizedBox(width: 10),
          // Month / Quarter dropdown
          if (provider.selectedPeriodType == 'Monthly')
            _buildDropdown(
              value: provider.selectedMonth,
              items: List.generate(12, (i) => i + 1),
              itemLabelBuilder: (v) => ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][(v as int) - 1],
              onChanged: (val) {
                provider.setFilters(month: val as int);
                provider.fetchCollectionTargetReport(_activeTab);
              },
            ),
          if (provider.selectedPeriodType == 'Quarterly')
            _buildDropdown(
              value: provider.selectedQuarter,
              items: [1, 2, 3, 4],
              itemLabelBuilder: (v) => 'Q${v as int}',
              onChanged: (val) {
                provider.setFilters(quarter: val as int);
                provider.fetchCollectionTargetReport(_activeTab);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildTabRow() {
    return Row(
      children: [
        _tabButton(
          key: 'Customer',
          icon: LucideIcons.users,
          label: 'Customer Collection',
          accentColor: const Color(0xFF4F46E5),
        ),
        const SizedBox(width: 10),
        _tabButton(
          key: 'Vendor',
          icon: LucideIcons.shoppingBag,
          label: 'Vendor Collection',
          accentColor: const Color(0xFF7C3AED),
        ),
      ],
    );
  }

  Widget _tabButton({required String key, required IconData icon, required String label, required Color accentColor}) {
    final isActive = _activeTab == key;
    return GestureDetector(
      onTap: () => _switchTab(key),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? accentColor : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isActive ? accentColor : const Color(0xFFE2E8F0)),
          boxShadow: isActive ? [BoxShadow(color: accentColor.withAlpha(50), blurRadius: 10, offset: const Offset(0, 4))] : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isActive ? Colors.white : Colors.grey.shade500),
            const SizedBox(width: 8),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: isActive ? Colors.white : Colors.grey.shade500,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
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
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
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
}

// ─── Collection Section ───────────────────────────────────────────────────────
class _CollectionSection extends StatefulWidget {
  final String targetType;
  final TargetProvider provider;

  const _CollectionSection({super.key, required this.targetType, required this.provider});

  @override
  State<_CollectionSection> createState() => _CollectionSectionState();
}

class _CollectionSectionState extends State<_CollectionSection> {
  final _searchCtrl = TextEditingController();
  String _search = '';

  bool get _isCustomer => widget.targetType == 'Customer';
  Color get _accent => _isCustomer ? const Color(0xFF4F46E5) : const Color(0xFF7C3AED);

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<CollectionParty> get _filtered {
    final data = widget.provider.collectionReport?.data ?? [];
    if (_search.isEmpty) return data;
    return data.where((p) => p.partyName.toLowerCase().contains(_search.toLowerCase())).toList();
  }

  Future<void> _exportExcel() async {
    final data = _filtered;
    if (data.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No data to export')));
      return;
    }
    try {
      final excel = xl.Excel.createExcel();
      final sheet = excel['${widget.targetType} Collection'];

      final prov = widget.provider;
      sheet.appendRow([xl.TextCellValue('${widget.targetType} / Vendor Collection Report')]);
      sheet.appendRow([xl.TextCellValue('Period: ${prov.selectedPeriodType} - ${prov.selectedYear}')]);
      sheet.appendRow([xl.TextCellValue('')]);
      sheet.appendRow([
        xl.TextCellValue('SR.NO.'),
        xl.TextCellValue('PARTY NAME'),
        xl.TextCellValue('TARGET (₹)'),
        xl.TextCellValue('RECEIVED (₹)'),
        xl.TextCellValue('BALANCE (₹)'),
        xl.TextCellValue('EXCESS (₹)'),
        xl.TextCellValue('PERFORMANCE %'),
        xl.TextCellValue('STATUS'),
      ]);
      for (int i = 0; i < data.length; i++) {
        final p = data[i];
        sheet.appendRow([
          xl.IntCellValue(i + 1),
          xl.TextCellValue(p.partyName),
          xl.DoubleCellValue(p.targetAmount),
          xl.DoubleCellValue(p.received),
          xl.DoubleCellValue(p.balance),
          xl.DoubleCellValue(p.excess),
          xl.DoubleCellValue(p.performance),
          xl.TextCellValue(p.status),
        ]);
      }

      final fileName = '${widget.targetType}_Collection_${prov.selectedPeriodType}_${prov.selectedYear}.xlsx';
      final path = await FilePicker.saveFile(
        dialogTitle: 'Save Excel File',
        fileName: fileName,
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );
      if (path != null) {
        final bytes = excel.encode();
        if (bytes != null) {
          await File(path).writeAsBytes(bytes);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Excel exported successfully!')));
          }
        }
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _printReport() async {
    final report = widget.provider.collectionReport;
    if (report == null) return;
    final prov = widget.provider;
    final font = await PdfGoogleFonts.interRegular();
    final bold = await PdfGoogleFonts.interBold();
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(28),
        build: (ctx) => [
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
            pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Text('${widget.targetType} / Vendor Collection Report', style: pw.TextStyle(font: bold, fontSize: 16)),
              pw.Text('Period: ${prov.selectedPeriodType} - ${prov.selectedYear}',
                  style: pw.TextStyle(font: font, fontSize: 9, color: PdfColors.grey700)),
            ]),
            pw.Text(DateFormat('dd-MMM-yyyy HH:mm').format(DateTime.now()),
                style: pw.TextStyle(font: font, fontSize: 8, color: PdfColors.grey500)),
          ]),
          pw.SizedBox(height: 16),
          pw.Row(children: [
            _pdfCard('TOTAL TARGET', _inr(report.summary?.totalTarget ?? 0), bold, font),
            pw.SizedBox(width: 16),
            _pdfCard('TOTAL RECEIVED', _inr(report.summary?.totalReceived ?? 0), bold, font),
            pw.SizedBox(width: 16),
            _pdfCard('ACHIEVEMENT %', '${report.summary?.achievement.toStringAsFixed(2) ?? 0}%', bold, font),
            pw.SizedBox(width: 16),
            _pdfCard('BALANCE', _inr(report.summary?.totalBalance ?? 0), bold, font),
          ]),
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            headers: ['#', 'PARTY NAME', 'TARGET', 'RECEIVED', 'BALANCE', 'EXCESS', 'PERF %', 'STATUS'],
            data: report.data.asMap().entries.map((e) {
              final p = e.value;
              return [
                '${e.key + 1}',
                p.partyName.toUpperCase(),
                _inr(p.targetAmount),
                _inr(p.received),
                p.balance > 0 ? _inr(p.balance) : '—',
                p.excess > 0 ? _inr(p.excess) : '—',
                '${p.performance.toStringAsFixed(2)}%',
                p.status,
              ];
            }).toList(),
            headerStyle: pw.TextStyle(font: bold, fontSize: 8, color: PdfColors.white),
            cellStyle: pw.TextStyle(font: font, fontSize: 7),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.indigo800),
            cellAlignment: pw.Alignment.centerRight,
            columnWidths: {0: const pw.FixedColumnWidth(24), 1: const pw.FlexColumnWidth(3)},
          ),
        ],
      ),
    );
    await Printing.layoutPdf(onLayout: (_) => pdf.save());
  }

  pw.Widget _pdfCard(String label, String val, pw.Font bold, pw.Font reg) {
    return pw.Expanded(
      child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Text(label, style: pw.TextStyle(font: reg, fontSize: 7, color: PdfColors.grey600)),
        pw.Text(val, style: pw.TextStyle(font: bold, fontSize: 12)),
      ]),
    );
  }

  void _showEditDialog(CollectionParty party) {
    final ctrl = TextEditingController(text: party.targetAmount > 0 ? party.targetAmount.toStringAsFixed(0) : '');
    final prov = widget.provider;
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: _accent, borderRadius: BorderRadius.circular(10)),
                        child: const Icon(LucideIcons.wallet, color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 12),
                      const Text('Set Collection Target', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
                      const Spacer(),
                      IconButton(
                        icon: Icon(LucideIcons.x, size: 18, color: Colors.grey.shade400),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                ),
                // Body
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _accent.withAlpha(12),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: _accent.withAlpha(40)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.targetType.toUpperCase(), style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: _accent, letterSpacing: 1)),
                            const SizedBox(height: 4),
                            Text(party.partyName.toUpperCase(), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: _accent.withAlpha(220))),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6), border: Border.all(color: _accent.withAlpha(40))),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(LucideIcons.calendar, size: 12, color: _accent),
                                  const SizedBox(width: 6),
                                  Text('${prov.selectedPeriodType} • ${prov.selectedYear}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: _accent)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text('TARGET AMOUNT (₹)', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.grey.shade600, letterSpacing: 1)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: ctrl,
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _accent.withAlpha(60))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _accent.withAlpha(60))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _accent, width: 2)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            Icon(LucideIcons.alertCircle, size: 16, color: Colors.orange.shade600),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'This target applies only for the selected ${prov.selectedPeriodType.toLowerCase()} period.',
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.deepOrange, height: 1.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Footer
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text('CANCEL', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.grey.shade600)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final amount = double.tryParse(ctrl.text) ?? 0;
                            if (amount < 0) return;
                            final ok = await prov.saveTarget(
                              partyId: party.partyName,
                              partyName: party.partyName,
                              amount: amount,
                              isCollection: true,
                              targetType: widget.targetType,
                            );
                            if (ok && ctx.mounted) Navigator.pop(ctx);
                          },
                          icon: const Icon(LucideIcons.checkCircle2, size: 16),
                          label: const Text('SAVE TARGET', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: _accent,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showHistoryDialog(CollectionParty party) async {
    // Fetch history
    List<CollectionHistoryItem> history = [];
    bool loading = true;
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setModalState) {
          if (loading) {
            targetService.getCollectionTargetHistory(party.partyName, widget.targetType).then((data) {
              if (ctx.mounted) setModalState(() { history = data; loading = false; });
            }).catchError((_) {
              if (ctx.mounted) setModalState(() => loading = false);
            });
          }
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: Colors.white,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640, maxHeight: 560),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(10)),
                          child: const Icon(LucideIcons.history, size: 18, color: Color(0xFF4F46E5)),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Collection History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
                            Text(party.partyName.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade500, letterSpacing: 0.5)),
                          ],
                        ),
                        const Spacer(),
                        IconButton(icon: Icon(LucideIcons.x, size: 18, color: Colors.grey.shade400), onPressed: () => Navigator.pop(ctx)),
                      ],
                    ),
                  ),
                  // Body
                  Expanded(
                    child: loading
                        ? const Center(child: CircularProgressIndicator())
                        : history.isEmpty
                            ? const Center(child: Text('No previous targets recorded', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)))
                            : SingleChildScrollView(
                                child: Column(
                                  children: [
                                    // Table header
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                      color: const Color(0xFFF8FAFC),
                                      child: Row(
                                        children: [
                                          const Expanded(flex: 3, child: Text('PERIOD', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 0.8))),
                                          const Expanded(flex: 2, child: Text('TARGET', textAlign: TextAlign.right, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 0.8))),
                                          const Expanded(flex: 2, child: Text('RECEIVED', textAlign: TextAlign.right, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 0.8))),
                                          const Expanded(flex: 3, child: Text('PERFORMANCE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 0.8))),
                                        ],
                                      ),
                                    ),
                                    ...history.asMap().entries.map((e) {
                                      final h = e.value;
                                      final cc = _statusColor(h.performance);
                                      final periodLabel = h.month != null
                                          ? '${h.year} • Month ${h.month}'
                                          : h.quarter != null
                                              ? '${h.year} • Q${h.quarter}'
                                              : '${h.year} • Full Year';
                                      final periodTypeLabel = h.periodType;
                                      return Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                        decoration: BoxDecoration(
                                          border: Border(bottom: BorderSide(color: Colors.grey.shade50)),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 32, height: 32,
                                                    decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE2E8F0))),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      h.month != null ? 'M' : h.quarter != null ? 'Q' : 'Y',
                                                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF4F46E5)),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(periodLabel, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
                                                      Text(periodTypeLabel, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey.shade400, letterSpacing: 0.5)),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(_inr(h.targetAmount), textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(_inr(h.received), textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF10B981))),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                        decoration: BoxDecoration(color: cc.withAlpha(20), borderRadius: BorderRadius.circular(4)),
                                                        child: Text(h.status, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: cc)),
                                                      ),
                                                      const Spacer(),
                                                      Text('${h.performance}%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: cc)),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 4),
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(4),
                                                    child: LinearProgressIndicator(
                                                      value: (h.performance / 100).clamp(0.0, 1.0),
                                                      backgroundColor: Colors.grey.shade100,
                                                      valueColor: AlwaysStoppedAnimation<Color>(cc),
                                                      minHeight: 5,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                  ),
                  // Footer
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      border: Border(top: BorderSide(color: Colors.grey.shade100)),
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                    ),
                    child: Center(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                        child: const Text('CLOSE RECORD', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final report = widget.provider.collectionReport;
    final summary = report?.summary;
    final data = _filtered;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Summary cards
        _buildSummaryCards(summary),
        const SizedBox(height: 24),

        // Chart + Insight row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: _buildTop5Chart(report?.data ?? [])),
            const SizedBox(width: 20),
            Expanded(flex: 1, child: _buildInsightBox(summary)),
          ],
        ),
        const SizedBox(height: 24),

        // Search + export row
        _buildSearchExportRow(),
        const SizedBox(height: 20),

        // Main table
        _buildTable(data),
      ],
    );
  }

  Widget _buildSummaryCards(CollectionSummary? summary) {
    final totalTarget = summary?.totalTarget ?? 0;
    final totalReceived = summary?.totalReceived ?? 0;
    final achievement = summary?.achievement ?? 0;
    final totalExcess = summary?.totalExcess ?? 0;
    final totalBalance = summary?.totalBalance ?? 0;

    final cards = [
      _SummaryCardData(
        label: 'TOTAL TARGET',
        value: _inr(totalTarget),
        icon: _isCustomer ? LucideIcons.users : LucideIcons.shoppingBag,
        accent: _accent,
        progressFraction: totalTarget > 0 ? 1.0 : 0,
      ),
      _SummaryCardData(
        label: 'TOTAL RECEIVED',
        value: _inr(totalReceived),
        icon: LucideIcons.trendingUp,
        accent: const Color(0xFF10B981),
        progressFraction: totalTarget > 0 ? (totalReceived / totalTarget).clamp(0, 1) : 0,
      ),
      _SummaryCardData(
        label: 'ACHIEVEMENT %',
        value: '${achievement.toStringAsFixed(2)}%',
        icon: LucideIcons.barChart2,
        accent: achievement >= 90 ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
        progressFraction: (achievement / 100).clamp(0, 1),
      ),
      _SummaryCardData(
        label: 'BALANCE / EXCESS',
        value: totalExcess > 0 ? '+${_inr(totalExcess)}' : '-${_inr(totalBalance)}',
        icon: totalExcess > 0 ? LucideIcons.arrowUpRight : LucideIcons.arrowDownRight,
        accent: totalExcess > 0 ? const Color(0xFF10B981) : const Color(0xFFF43F5E),
        progressFraction: 1.0,
      ),
    ];

    return Row(
      children: cards.map((c) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: cards.indexOf(c) < cards.length - 1 ? 16 : 0),
            child: _summaryCard(c),
          ),
        );
      }).toList(),
    );
  }

  Widget _summaryCard(_SummaryCardData c) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Stack(
        children: [
          Positioned(right: 16, top: 24, child: Icon(c.icon, size: 44, color: c.accent.withAlpha(18))),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.grey.shade500, letterSpacing: 1)),
                const SizedBox(height: 8),
                Text(c.value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
              ],
            ),
          ),
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: Container(
              height: 4,
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: const BorderRadius.vertical(bottom: Radius.circular(18))),
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: c.progressFraction.clamp(0, 1),
                child: Container(
                  decoration: BoxDecoration(color: c.accent, borderRadius: const BorderRadius.vertical(bottom: Radius.circular(18))),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTop5Chart(List<CollectionParty> data) {
    final top5 = [...data]..sort((a, b) => b.received.compareTo(a.received));
    final top = top5.take(5).toList();
    final maxVal = top.isEmpty ? 1.0 : math.max(top.map((d) => math.max(d.targetAmount, d.received)).reduce(math.max), 1.0);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.barChart3, size: 16, color: _accent),
              const SizedBox(width: 8),
              Text('TARGET VS RECEIVED (TOP 5)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey.shade700, letterSpacing: 0.8)),
            ],
          ),
          const SizedBox(height: 20),
          if (top.isEmpty)
            const SizedBox(height: 100, child: Center(child: Text('Waiting for performance data…', style: TextStyle(color: Color(0xFFCBD5E1), fontWeight: FontWeight.w900))))
          else
            ...top.map((d) {
              final targetFraction = (d.targetAmount / maxVal).clamp(0.0, 1.0);
              final receivedFraction = (d.received / maxVal).clamp(0.0, 1.0);
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(d.partyName.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: _accent.withAlpha(200))),
                        Text('${d.received.toStringAsFixed(0)} / ${d.targetAmount.toStringAsFixed(0)}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade400)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Stack(
                      children: [
                        Container(
                          height: 12,
                          width: double.infinity,
                          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(6)),
                        ),
                        FractionallySizedBox(
                          widthFactor: targetFraction,
                          child: Container(
                            height: 12,
                            decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(6)),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: receivedFraction,
                          child: Container(
                            height: 12,
                            decoration: BoxDecoration(color: _accent, borderRadius: BorderRadius.circular(6)),
                            alignment: Alignment.centerRight,
                            child: Container(
                              width: 4, height: 8,
                              decoration: BoxDecoration(color: Colors.white.withAlpha(100), borderRadius: BorderRadius.circular(2)),
                              margin: const EdgeInsets.only(right: 2),
                            ),
                          ),
                        ),
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

  Widget _buildInsightBox(CollectionSummary? summary) {
    final ach = summary?.achievement ?? 0;
    String insight;
    if (ach >= 90) {
      insight = 'Excellent! ${widget.targetType} collection is on track. Keep up the momentum.';
    } else if (ach >= 50) {
      insight = 'Balanced performance. Focus on parties below 70% to improve overall collection.';
    } else {
      insight = 'Opportunity for growth. Review targets and increase collection touchpoints.';
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: _accent.withAlpha(15),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(14),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: _accent.withAlpha(20), borderRadius: BorderRadius.circular(14)),
              child: Icon(LucideIcons.wallet, size: 28, color: _accent),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${widget.targetType.toUpperCase()} INSIGHTS',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF1E293B), letterSpacing: 1),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            insight.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade500, height: 1.6, letterSpacing: 0.5),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('VIEW STRATEGY', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: _accent, letterSpacing: 0.8)),
              const SizedBox(width: 4),
              Icon(LucideIcons.arrowRight, size: 14, color: _accent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchExportRow() {
    return Row(
      children: [
        // Search
        SizedBox(
          width: 280,
          child: TextField(
            controller: _searchCtrl,
            onChanged: (v) => setState(() => _search = v),
            decoration: InputDecoration(
              hintText: 'Search ${widget.targetType.toLowerCase()}…',
              hintStyle: const TextStyle(fontSize: 12, color: Color(0xFFCBD5E1), fontWeight: FontWeight.bold),
              prefixIcon: const Icon(LucideIcons.search, size: 16, color: Color(0xFFCBD5E1)),
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: _accent, width: 1.5)),
            ),
          ),
        ),
        const Spacer(),
        // Download
        _iconActionButton(icon: LucideIcons.download, onTap: _exportExcel, tooltip: 'Export Excel'),
        const SizedBox(width: 8),
        // Print
        _iconActionButton(icon: LucideIcons.printer, onTap: _printReport, tooltip: 'Print'),
      ],
    );
  }

  Widget _iconActionButton({required IconData icon, required VoidCallback onTap, required String tooltip}) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Icon(icon, size: 18, color: Colors.grey.shade600),
        ),
      ),
    );
  }

  Widget _buildTable(List<CollectionParty> data) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Row(
              children: [
                _th('SR', flex: 1),
                _th('PARTY DETAILS', flex: 4),
                _th('TARGET', flex: 2, align: TextAlign.right),
                _th('RECEIVED', flex: 2, align: TextAlign.right),
                _th('BALANCE', flex: 2, align: TextAlign.right),
                _th('EXCESS', flex: 2, align: TextAlign.right),
                _th('PERFORMANCE %', flex: 4),
                _th('ACTIONS', flex: 2, align: TextAlign.center),
              ],
            ),
          ),

          // Rows
          if (data.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 60),
              child: Center(
                child: Text(
                  'No ${widget.targetType.toLowerCase()} parties found',
                  style: const TextStyle(fontSize: 13, color: Color(0xFFCBD5E1), fontWeight: FontWeight.w900, letterSpacing: 0.5),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.length,
              separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
              itemBuilder: (_, idx) => _buildRow(data[idx], idx),
            ),
        ],
      ),
    );
  }

  Widget _th(String text, {int flex = 1, TextAlign align = TextAlign.left}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: align,
        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 0.8),
      ),
    );
  }

  Widget _buildRow(CollectionParty p, int idx) {
    final isNoTarget = p.targetAmount == 0;
    final statusColor = _statusColor(p.performance);
    final isOver = p.received >= p.targetAmount && p.targetAmount > 0;

    Color statusBg;
    if (isNoTarget) {
      statusBg = Colors.grey.shade100;
    } else {
      statusBg = statusColor.withAlpha(20);
    }

    return Container(
      color: isOver ? const Color(0x0810B981) : Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      child: Row(
        children: [
          // SR
          Expanded(
            flex: 1,
            child: Text('${idx + 1}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFFCBD5E1))),
          ),
          // Party Details
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.partyName.toUpperCase(),
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: _accent),
                ),
                const SizedBox(height: 3),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(4)),
                  child: Text(
                    p.status.toUpperCase(),
                    style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: isNoTarget ? Colors.grey.shade400 : statusColor, letterSpacing: 0.5),
                  ),
                ),
              ],
            ),
          ),
          // Target
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(_inr(p.targetAmount), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
                Text('Target', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey.shade400)),
              ],
            ),
          ),
          // Received
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _inr(p.received),
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: p.received > 0 ? const Color(0xFF10B981) : Colors.grey.shade400),
                ),
                Text('Collected', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey.shade400)),
              ],
            ),
          ),
          // Balance
          Expanded(
            flex: 2,
            child: Text(
              p.balance > 0 ? _inr(p.balance) : '—',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w900,
                color: p.balance > 0 ? const Color(0xFFF43F5E) : const Color(0xFFCBD5E1),
              ),
            ),
          ),
          // Excess
          Expanded(
            flex: 2,
            child: Text(
              p.excess > 0 ? '+${_inr(p.excess)}' : '—',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w900,
                color: p.excess > 0 ? const Color(0xFF10B981) : const Color(0xFFCBD5E1),
              ),
            ),
          ),
          // Performance bar + %
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(4)),
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: (p.performance / 100).clamp(0, 1),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [statusColor.withAlpha(180), statusColor],
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 48,
                  child: Text(
                    isNoTarget ? '0%' : '${p.performance.toStringAsFixed(2)}%',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: statusColor),
                  ),
                ),
              ],
            ),
          ),
          // Actions
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(LucideIcons.pencil, size: 16, color: _accent.withAlpha(180)),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: 'Edit Target',
                  onPressed: () => _showEditDialog(p),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: Icon(LucideIcons.history, size: 16, color: Colors.grey.shade500),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: 'View History',
                  onPressed: () => _showHistoryDialog(p),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCardData {
  final String label;
  final String value;
  final IconData icon;
  final Color accent;
  final double progressFraction;

  const _SummaryCardData({
    required this.label,
    required this.value,
    required this.icon,
    required this.accent,
    required this.progressFraction,
  });
}
