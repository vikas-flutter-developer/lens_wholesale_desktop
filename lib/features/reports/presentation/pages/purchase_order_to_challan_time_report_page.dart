import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart' as xl;
import 'package:file_picker/file_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/operational_report_model.dart';
import '../../data/providers/operational_report_provider.dart';

class PurchaseOrderToChallanTimeReportPage extends StatefulWidget {
  const PurchaseOrderToChallanTimeReportPage({Key? key}) : super(key: key);

  @override
  State<PurchaseOrderToChallanTimeReportPage> createState() => _PurchaseOrderToChallanTimeReportPageState();
}

class _PurchaseOrderToChallanTimeReportPageState extends State<PurchaseOrderToChallanTimeReportPage> {
  // Use 30 days ago as default to ensure data visibility, or matching React's effective date
  String _dateFrom =
      DateTime.now().subtract(const Duration(days: 30)).toString().split(' ')[0];
  String _dateTo = DateTime.now().toString().split(' ')[0];
  String _status = 'All';
  String _partyName = '';
  String _partySearch = '';
  String _searchTerm = '';

  bool _showPartyList = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  Timer? _minuteTimer;
  late TextEditingController _thresholdController;

  @override
  void initState() {
    super.initState();
    _thresholdController = TextEditingController();
    // Default to 1st of month like React, but handle the 1-day offset if needed
    _dateFrom = DateTime(DateTime.now().year, DateTime.now().month, 1).toString().split(' ')[0];
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<OperationalReportProvider>();
      _thresholdController.text = provider.purchaseThreshold.toString();
      _fetch();
    });
    _minuteTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _minuteTimer?.cancel();
    _thresholdController.dispose();
    _hideOverlay();
    super.dispose();
  }

  void _fetch() {
    final provider = context.read<OperationalReportProvider>();
    provider.fetchPurchaseOrderToChallanReport({
      'dateFrom': _dateFrom,
      'dateTo': _dateTo,
      'partyName': _partyName,
      'status': _status,
    });
  }

  String _formatTimeLong(double? totalMins) {
    if (totalMins == null) return "0 m";
    final mins = totalMins.round();
    if (mins < 60) return "$mins m";
    final h = mins ~/ 60;
    final m = mins % 60;
    return m > 0 ? "${h}hr $m mins" : "$h hrs";
  }

  String _formatTimeShort(double? totalMins) {
    if (totalMins == null) return "0m";
    final mins = totalMins.round();
    if (mins < 60) return "${mins}m";
    final h = mins ~/ 60;
    final m = mins % 60;
    return m > 0 ? "$h hr $m min" : "$h hrs";
  }

  List<Map<String, dynamic>> _getProcessedAndFilteredDetails(
    List<OrderToChallanDetail> details,
    int threshold,
  ) {
    final now = DateTime.now();
    List<Map<String, dynamic>> processed = details.map((d) {
      String st = d.status;
      double? displayDiff = d.timeDifference;

      if (st == 'Pending') {
        final orderTime = DateTime.parse(d.orderCreatedAt);
        final diffMin = now.difference(orderTime).inMinutes.toDouble();
        if (diffMin > threshold) {
          st = 'Delayed';
        }
        displayDiff = diffMin;
      } else if (displayDiff != null && displayDiff > threshold) {
        st = 'Delayed';
      } else {
        st = 'On Time';
      }

      return {
        'detail': d,
        'calcStatus': st,
        'displayDiff': displayDiff,
      };
    }).toList();

    if (_partyName.isNotEmpty) {
      processed = processed
          .where((e) =>
              (e['detail'] as OrderToChallanDetail).partyName.toLowerCase() ==
              _partyName.toLowerCase())
          .toList();
    }

    if (_status != 'All') {
      if (_status == 'Completed') {
        processed = processed.where((e) => (e['detail'] as OrderToChallanDetail).status != 'Pending').toList();
      } else {
        processed = processed.where((e) => (e['detail'] as OrderToChallanDetail).status == 'Pending').toList();
      }
    }

    if (_searchTerm.isNotEmpty) {
      final term = _searchTerm.toLowerCase();
      processed = processed.where((e) {
        final d = e['detail'] as OrderToChallanDetail;
        return d.partyName.toLowerCase().contains(term) ||
            d.orderNo.toLowerCase().contains(term) ||
            (d.challanNo ?? '').toLowerCase().contains(term);
      }).toList();
    }

    return processed;
  }

  Future<void> _exportExcel(List<Map<String, dynamic>> data) async {
    final excel = xl.Excel.createExcel();
    final sheet = excel['Purchase Order Timing'];
    excel.setDefaultSheet('Purchase Order Timing');

    final header = [
      'Sr. No.',
      'Order Date',
      'Order No',
      'Challan Date',
      'Challan No',
      'Party Name',
      'Diff',
      'Status',
    ];
    sheet.appendRow(header.map((e) => xl.TextCellValue(e)).toList());

    for (var i = 0; i < data.length; i++) {
      final item = data[i];
      final d = item['detail'] as OrderToChallanDetail;
      sheet.appendRow([
        xl.IntCellValue(i + 1),
        xl.TextCellValue(d.orderDate),
        xl.TextCellValue(d.orderNo),
        xl.TextCellValue(d.challanDate ?? 'N/A'),
        xl.TextCellValue(d.challanNo ?? 'N/A'),
        xl.TextCellValue(d.partyName),
        xl.TextCellValue(_formatTimeShort(item['displayDiff'])),
        xl.TextCellValue(item['calcStatus']),
      ]);
    }

    String? path = await FilePicker.saveFile(
      dialogTitle: 'Save Excel File',
      fileName: 'Purchase_Order_Timings_$_dateFrom.xlsx',
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

  Future<void> _printPdf(List<Map<String, dynamic>> data) async {
    final doc = pw.Document();
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (pw.Context context) {
          return [
            pw.Text(
              'Purchase Order to Challan Time Report',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            pw.TableHelper.fromTextArray(
              headers: [
                'Sr. No.',
                'Order Date',
                'Order No',
                'Challan Date',
                'Challan No',
                'Party Name',
                'Diff',
                'Status',
              ],
              data: data.asMap().entries.map((ent) {
                final d = ent.value['detail'] as OrderToChallanDetail;
                return [
                  (ent.key + 1).toString(),
                  d.orderDate,
                  d.orderNo,
                  d.challanDate ?? 'N/A',
                  d.challanNo ?? 'N/A',
                  d.partyName,
                  _formatTimeShort(ent.value['displayDiff']),
                  ent.value['calcStatus'],
                ];
              }).toList(),
            ),
          ];
        },
      ),
    );
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
      name: 'Purchase_Order_Timings_Report.pdf',
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required Color color,
    required Color bgColor,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade400,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: valueColor ?? const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPartyOverlay(List<String> uniqueParties) {
    if (_overlayEntry != null) return;
    _overlayEntry = OverlayEntry(
      builder: (context) {
        final q = _partySearch.toLowerCase();
        final filtered = uniqueParties.where((p) => p.toLowerCase().contains(q)).take(50).toList();
        return Stack(
          children: [
            GestureDetector(
              onTap: _hideOverlay,
              behavior: HitTestBehavior.opaque,
              child: Container(color: Colors.transparent),
            ),
            Positioned(
              width: 300,
              child: CompositedTransformFollower(
                link: _layerLink,
                offset: const Offset(0, 48),
                showWhenUnlinked: false,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 250),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Select Party (${filtered.length})',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade500),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _partyName = '';
                              _partySearch = '';
                            });
                            _hideOverlay();
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Text(
                              'Clear Filter / All Parties',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: filtered.length,
                            itemBuilder: (context, i) {
                              final p = filtered[i];
                              return InkWell(
                                  onTap: () {
                                    setState(() {
                                      _partyName = p;
                                      _partySearch = p;
                                    });
                                    _hideOverlay();
                                    _fetch();
                                  },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  color: _partyName == p ? Colors.deepPurple.shade50 : null,
                                  child: Text(
                                    p,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: _partyName == p ? Colors.deepPurple.shade700 : Colors.grey.shade800,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OperationalReportProvider>();
    final threshold = provider.purchaseThreshold;
    final report = provider.purchaseOrderToChallanReport;
    final details = report?.details ?? [];

    final processedDetails = _getProcessedAndFilteredDetails(details, threshold);

    final uniqueParties = details.map((d) => d.partyName).toSet().toList()..sort();

    final avgTime = report?.summary.avgTime ?? 0;

    // SLA Calculation for Chart
    final total = processedDetails.length;
    final onTime = processedDetails.where((e) => e['calcStatus'] == 'On Time').length;
    final delayed = processedDetails.where((e) => e['calcStatus'] == 'Delayed').length;
    final pending = processedDetails.where((e) => e['calcStatus'] == 'Pending').length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade600,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(LucideIcons.timer, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Purchase Order to Challan Time Report',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
                        ),
                        Text(
                          'Monitor purchase processing efficiency and operational bottlenecks',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    // Sale / Purchase Toggle
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () => context.go('/reports/otherreports/ordertochallantimereport'),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              child: Row(
                                children: [
                                  Icon(LucideIcons.trendingUp, size: 14, color: Colors.grey.shade500),
                                  const SizedBox(width: 8),
                                  Text('SALE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.grey.shade500, letterSpacing: 1)),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.shade600,
                              borderRadius: const BorderRadius.only(topRight: Radius.circular(11), bottomRight: Radius.circular(11)),
                            ),
                            child: const Row(
                              children: [
                                Icon(LucideIcons.shoppingCart, size: 14, color: Colors.white),
                                SizedBox(width: 8),
                                Text('PURCHASE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Threshold Input
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(LucideIcons.settings, size: 14, color: Colors.grey.shade400),
                          const SizedBox(width: 8),
                          Text('THRESHOLD (MINS):', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey.shade500)),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 40,
                            child: TextField(
                              controller: _thresholdController,
                              keyboardType: TextInputType.number,
                              onChanged: (val) {
                                final parsed = int.tryParse(val) ?? 0;
                                context.read<OperationalReportProvider>().setPurchaseThreshold(parsed);
                              },
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                              decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.zero, border: InputBorder.none),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton.icon(
                      onPressed: () => _printPdf(processedDetails),
                      icon: const Icon(LucideIcons.printer, size: 16),
                      label: const Text('Print', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.grey.shade700, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () => _exportExcel(processedDetails),
                      icon: const Icon(LucideIcons.download, size: 16),
                      label: const Text('Export', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.grey.shade700, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                // Summary Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        icon: LucideIcons.receipt,
                        color: Colors.deepPurple.shade600,
                        bgColor: Colors.deepPurple.shade50,
                        label: 'Total Orders',
                        value: report?.summary.totalOrders.toString() ?? '0',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildSummaryCard(
                        icon: LucideIcons.checkCircle2,
                        color: Colors.green.shade600,
                        bgColor: Colors.green.shade50,
                        label: 'Completed',
                        value: report?.summary.completedOrders.toString() ?? '0',
                        valueColor: Colors.green.shade600,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildSummaryCard(
                        icon: LucideIcons.alertCircle,
                        color: Colors.amber.shade600,
                        bgColor: Colors.amber.shade50,
                        label: 'Pending',
                        value: report?.summary.pendingOrders.toString() ?? '0',
                        valueColor: Colors.amber.shade600,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: avgTime > threshold ? Colors.red.shade50 : Colors.deepPurple.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: avgTime > threshold ? Colors.red.shade100 : Colors.deepPurple.shade100),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: avgTime > threshold ? Colors.red.shade100 : Colors.deepPurple.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(LucideIcons.clock, color: avgTime > threshold ? Colors.red.shade600 : Colors.deepPurple.shade600, size: 28),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'AVG. PROCESSING',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: avgTime > threshold ? Colors.red.shade400 : Colors.deepPurple.shade400,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _formatTimeLong(avgTime),
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                      color: avgTime > threshold ? Colors.red.shade700 : Colors.deepPurple.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Filters & SLA
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 8,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.grey.shade100),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(LucideIcons.filter, size: 20, color: Colors.deepPurple.shade600),
                                const SizedBox(width: 12),
                                const Text(
                                  'GLOBAL FILTERS',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF1E293B), letterSpacing: 1),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('FROM', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade400, letterSpacing: 1)),
                                      const SizedBox(height: 8),
                                      InkWell(
                                        onTap: () async {
                                          final d = await showDatePicker(context: context, initialDate: DateTime.parse(_dateFrom), firstDate: DateTime(2000), lastDate: DateTime(2100));
                                          if (d != null) {
                                            setState(() => _dateFrom = d.toString().split(' ')[0]);
                                            _fetch();
                                          }
                                        },
                                        child: Container(
                                          height: 44,
                                          padding: const EdgeInsets.symmetric(horizontal: 16),
                                          decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
                                          alignment: Alignment.centerLeft,
                                          child: Text(_dateFrom, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('TO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade400, letterSpacing: 1)),
                                      const SizedBox(height: 8),
                                      InkWell(
                                        onTap: () async {
                                          final d = await showDatePicker(context: context, initialDate: DateTime.parse(_dateTo), firstDate: DateTime(2000), lastDate: DateTime(2100));
                                          if (d != null) {
                                            setState(() => _dateTo = d.toString().split(' ')[0]);
                                            _fetch();
                                          }
                                        },
                                        child: Container(
                                          height: 44,
                                          padding: const EdgeInsets.symmetric(horizontal: 16),
                                          decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
                                          alignment: Alignment.centerLeft,
                                          child: Text(_dateTo, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('STATUS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade400, letterSpacing: 1)),
                                      const SizedBox(height: 8),
                                      Container(
                                        height: 44,
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            value: _status,
                                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                                            items: const [
                                              DropdownMenuItem(value: 'All', child: Text('All Transactions')),
                                              DropdownMenuItem(value: 'Completed', child: Text('Completed Only')),
                                              DropdownMenuItem(value: 'Pending', child: Text('Pending Only')),
                                            ],
                                            onChanged: (v) {
                                              if (v != null) {
                                                setState(() => _status = v);
                                                _fetch();
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('PARTY NAME', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade400, letterSpacing: 1)),
                                      const SizedBox(height: 8),
                                      CompositedTransformTarget(
                                        link: _layerLink,
                                        child: Container(
                                          height: 44,
                                          decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
                                          child: TextField(
                                            controller: TextEditingController(text: _partySearch)..selection = TextSelection.collapsed(offset: _partySearch.length),
                                            onChanged: (v) {
                                              _partySearch = v;
                                              _showPartyOverlay(uniqueParties);
                                              _overlayEntry?.markNeedsBuild();
                                            },
                                            onTap: () => _showPartyOverlay(uniqueParties),
                                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                              prefixIcon: const Icon(LucideIcons.search, size: 16),
                                              hintText: 'Search party...',
                                              hintStyle: const TextStyle(fontWeight: FontWeight.normal),
                                              suffixIcon: _partySearch.isNotEmpty
                                                  ? IconButton(
                                                      icon: const Icon(LucideIcons.x, size: 16),
                                                      onPressed: () {
                                                        setState(() {
                                                          _partySearch = '';
                                                          _partyName = '';
                                                        });
                                                        _hideOverlay();
                                                      },
                                                    )
                                                  : null,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            // Quick Search & Refresh
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 44,
                                    decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
                                    child: TextField(
                                      onChanged: (v) => setState(() => _searchTerm = v),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                        prefixIcon: Icon(LucideIcons.search, size: 16),
                                        hintText: 'Quick search order or party...',
                                        hintStyle: TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                ElevatedButton.icon(
                                  onPressed: provider.isLoading ? null : _fetch,
                                  icon: provider.isLoading
                                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                      : const Icon(LucideIcons.refreshCcw, size: 16),
                                  label: const Text('Refresh Data', style: TextStyle(fontWeight: FontWeight.bold)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple.shade600,
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size(0, 44),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 4,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.grey.shade100),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(LucideIcons.activity, size: 20, color: Colors.deepPurple.shade600),
                                const SizedBox(width: 12),
                                const Text(
                                  'SLA COMPLIANCE',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF1E293B), letterSpacing: 1),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Divider(color: Color(0xFFF1F5F9), height: 1),
                            ),
                            SizedBox(
                              height: 160,
                              child: CustomPieChart(total: total, onTime: onTime, delayed: delayed, pending: pending),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _legendItem(Colors.green.shade500, 'ON TIME'),
                                const SizedBox(width: 16),
                                _legendItem(Colors.red.shade500, 'DELAYED'),
                                const SizedBox(width: 16),
                                _legendItem(Colors.amber.shade400, 'PENDING'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Table
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.grey.shade100),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(12)),
                              child: const Icon(LucideIcons.activity, color: Colors.white, size: 18),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Operation Audit Breakdown', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
                                Text('Real-time purchase order processing performance'.toUpperCase(), style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey.shade400, letterSpacing: 1)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.blueGrey.shade50,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        child: Row(
                          children: [
                            Expanded(flex: 3, child: _th('ORDER DETAIL')),
                            Expanded(flex: 3, child: _th('CHALLAN DETAIL')),
                            Expanded(flex: 4, child: _th('PARTY NAME')),
                            Expanded(flex: 2, child: Center(child: _th('DIFFERENCE'))),
                            Expanded(flex: 2, child: Center(child: _th('STATUS'))),
                          ],
                        ),
                      ),
                      if (provider.isLoading)
                        const Padding(
                          padding: EdgeInsets.all(100),
                          child: Center(child: CircularProgressIndicator(color: Colors.deepPurple)),
                        )
                      else if (processedDetails.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(100),
                          child: Column(
                            children: [
                              Icon(LucideIcons.searchX, size: 48, color: Colors.grey.shade300),
                              const SizedBox(height: 16),
                              Text('No records found for the selected filters', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey.shade400, letterSpacing: 1)),
                            ],
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: processedDetails.length,
                          separatorBuilder: (c, i) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
                          itemBuilder: (context, index) {
                            final item = processedDetails[index];
                            final d = item['detail'] as OrderToChallanDetail;
                            final st = item['calcStatus'];
                            final diff = item['displayDiff'];

                            final isDelayed = st == 'Delayed';
                            final bgColor = isDelayed ? Colors.red.shade50.withOpacity(0.3) : Colors.transparent;

                            return Container(
                              color: bgColor,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(d.orderNo, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
                                        const SizedBox(height: 2),
                                        Text(
                                          DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(d.orderCreatedAt)),
                                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade400),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: d.challanCreatedAt != null
                                        ? Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(d.challanNo ?? '', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
                                              const SizedBox(height: 2),
                                              Text(
                                                DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(d.challanCreatedAt!)),
                                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade400),
                                              ),
                                            ],
                                          )
                                        : Text('NOT CREATED', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.red.shade300, letterSpacing: 1)),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                                          child: Icon(LucideIcons.user, size: 12, color: Colors.grey.shade500),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(d.partyName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          _formatTimeShort(diff),
                                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: isDelayed ? Colors.red.shade600 : const Color(0xFF1E293B)),
                                        ),
                                        if (d.status == 'Pending')
                                          Padding(
                                            padding: const EdgeInsets.only(top: 2),
                                            child: Text('STILL RUNNING', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.amber.shade500)),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Center(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: st == 'On Time'
                                              ? Colors.green.shade500
                                              : st == 'Delayed'
                                                  ? Colors.red.shade600
                                                  : Colors.amber.shade400,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          st.toUpperCase(),
                                          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _th(String label) {
    return Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey.shade500, letterSpacing: 1));
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.grey.shade500, letterSpacing: 1)),
      ],
    );
  }
}

class CustomPieChart extends StatelessWidget {
  final int total;
  final int onTime;
  final int delayed;
  final int pending;

  const CustomPieChart({Key? key, required this.total, required this.onTime, required this.delayed, required this.pending}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (total == 0) {
      return const Center(child: Text('No Data', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)));
    }
    
    final onTimeP = (onTime / total) * 100;
    final delayedP = (delayed / total) * 100;
    final pendingP = (pending / total) * 100;

    return Stack(
      children: [
        Center(
          child: CustomPaint(
            size: const Size(160, 160),
            painter: PiePainter(
              onTimeP: onTimeP,
              delayedP: delayedP,
              pendingP: pendingP,
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('PROCESS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade400, letterSpacing: 1)),
              Text('${onTimeP.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
            ],
          ),
        ),
      ],
    );
  }
}

class PiePainter extends CustomPainter {
  final double onTimeP;
  final double delayedP;
  final double pendingP;

  PiePainter({required this.onTimeP, required this.delayedP, required this.pendingP});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 20) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    const strokeW = 12.0;

    // Background track
    final bgPaint = Paint()
      ..color = Colors.grey.shade100
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW;
    canvas.drawCircle(center, radius, bgPaint);

    void drawArc(double startPct, double sweepPct, Color color) {
      if (sweepPct <= 0) return;
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeW
        ..strokeCap = StrokeCap.round;
      
      final startAngle = -math.pi / 2 + (startPct / 100) * 2 * math.pi;
      final sweepAngle = (sweepPct / 100) * 2 * math.pi;

      // Slightly reduce sweep angle to avoid overlap with round caps if multiple sections
      final adjustedSweep = sweepAngle > 0.05 ? sweepAngle - 0.02 : sweepAngle;

      canvas.drawArc(rect, startAngle, adjustedSweep, false, paint);
    }

    // Stack them end to end
    drawArc(0, onTimeP, Colors.green.shade500);
    drawArc(onTimeP, delayedP, Colors.red.shade500);
    drawArc(onTimeP + delayedP, pendingP, Colors.amber.shade400);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
