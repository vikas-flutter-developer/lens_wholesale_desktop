import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import '../../data/providers/operational_report_provider.dart';
import '../../data/models/operational_report_model.dart';

class CancelledOrderRatioPage extends StatefulWidget {
  const CancelledOrderRatioPage({super.key});

  @override
  State<CancelledOrderRatioPage> createState() => _CancelledOrderRatioPageState();
}

class _CancelledOrderRatioPageState extends State<CancelledOrderRatioPage> {
  final _dateFromController = TextEditingController(text: DateFormat('yyyy-MM-01').format(DateTime.now()));
  final _dateToController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  String _transactionType = 'Both';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
  }

  void _fetchData() {
    context.read<OperationalReportProvider>().fetchCancelledOrderRatioReport({
      'dateFrom': _dateFromController.text,
      'dateTo': _dateToController.text,
      'transactionType': _transactionType,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Consumer<OperationalReportProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              _buildHeader(provider),
              _buildFilters(),
              _buildSummaryGrid(provider),
              Expanded(
                child: provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildAnalytics(provider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(OperationalReportProvider provider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFFDC2626),
        gradient: LinearGradient(colors: [Color(0xFFDC2626), Color(0xFFB91C1C)]),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
            child: const Icon(LucideIcons.activity, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Cancelled Order Ratio Report',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
              ),
              Text(
                'Analyze cancellation trends and ratios across transactions',
                style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: () {
              final bytes = provider.exportCancelledRatioCsv();
              Printing.sharePdf(bytes: bytes, filename: 'cancelled_order_ratio_report.csv');
            },
            icon: const Icon(LucideIcons.download, size: 16),
            label: const Text('Export'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: Colors.white,
      child: Row(
        children: [
          _filterItem('From', _dateFromController, isDate: true),
          const SizedBox(width: 16),
          _filterItem('To', _dateToController, isDate: true),
          const SizedBox(width: 16),
          _typeDropdown(),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: _fetchData,
            icon: const Icon(LucideIcons.refreshCw, size: 16),
            label: const Text('Refresh'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterItem(String label, TextEditingController controller, {bool isDate = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey)),
        const SizedBox(height: 4),
        SizedBox(
          width: 150,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              isDense: true,
              suffixIcon: isDate ? const Icon(LucideIcons.calendar, size: 16) : null,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onTap: isDate ? () => _selectDate(controller) : null,
            readOnly: isDate,
          ),
        ),
      ],
    );
  }

  Widget _typeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('TRANSACTION TYPE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey)),
        const SizedBox(height: 4),
        Container(
          width: 180,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(8)),
          child: DropdownButton<String>(
            value: _transactionType,
            isExpanded: true,
            underline: Container(),
            items: ['Both', 'Sale', 'Purchase'].map((e) => DropdownMenuItem(value: e, child: Text(e == 'Both' ? 'Both (Sale/Purchase)' : e))).toList(),
            onChanged: (val) {
              setState(() => _transactionType = val!);
              _fetchData();
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

  Widget _buildSummaryGrid(OperationalReportProvider provider) {
    if (provider.cancelledOrderRatioReport == null) return const SizedBox.shrink();
    final summary = provider.cancelledOrderRatioReport!.summary;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          _summaryCard('Total Orders', (summary.totalOrders ?? 0).toString(), LucideIcons.shoppingCart, Colors.indigo),
          const SizedBox(width: 16),
          _summaryCard('Cancelled', (summary.cancelledOrders ?? 0).toString(), LucideIcons.alertCircle, Colors.red),
          const SizedBox(width: 16),
          _summaryCard('Active Orders', (summary.activeOrders ?? 0).toString(), LucideIcons.trendingUp, Colors.teal),
          const SizedBox(width: 16),
          _summaryCard('Cancellation Ratio', '${(summary.ratio ?? 0).toStringAsFixed(1)}%', LucideIcons.percent, summary.ratio != null && summary.ratio! > 20 ? Colors.red : Colors.blue),
        ],
      ),
    );
  }

  Widget _summaryCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.grey.shade100)),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey)),
                Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: color)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalytics(OperationalReportProvider provider) {
    final report = provider.cancelledOrderRatioReport;
    if (report == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    _buildTrendSection(report.trend),
                    const SizedBox(height: 24),
                    _buildBreakdownTable(report.details),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: [
                    _buildCompositionCard(report.summary),
                    const SizedBox(height: 24),
                    _buildPartyWisePerformance(report.partyWise),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompositionCard(CancelledOrderRatioSummary summary) {
    final active = (summary.totalOrders ?? 0) - (summary.cancelledOrders ?? 0);
    final cancelled = summary.cancelledOrders ?? 0;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.grey.shade100)),
      child: Column(
        children: [
          Row(
            children: const [
              Icon(LucideIcons.pieChart, size: 20, color: Colors.indigo),
              SizedBox(width: 8),
              Text('OVERALL COMPOSITION', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 150,
            width: 150,
            child: Stack(
              children: [
                Center(
                  child: CustomPaint(
                    size: const Size(150, 150),
                    painter: _PieChartPainter(
                      slices: [
                        _Slice(color: Colors.teal, percent: active / (summary.totalOrders ?? 1)),
                        _Slice(color: Colors.red, percent: cancelled / (summary.totalOrders ?? 1)),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('RATIO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                      Text('${(summary.ratio ?? 0).toStringAsFixed(1)}%', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _legendItem('Active', Colors.teal, active),
              _legendItem('Cancelled', Colors.red, cancelled),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendItem(String label, Color color, int val) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
          ],
        ),
        Text(val.toString(), style: const TextStyle(fontWeight: FontWeight.w900)),
      ],
    );
  }

  Widget _buildTrendSection(List<RatioTrend> trend) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.grey.shade100)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(LucideIcons.trendingUp, size: 20, color: Colors.blue),
              SizedBox(width: 8),
              Text('CANCELLATION TREND', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: trend.map((t) => _trendBar(t)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _trendBar(RatioTrend t) {
    final maxRatio = 50.0; // Assume 50% max for scaling
    final height = (t.ratio / maxRatio).clamp(0.01, 1.0) * 160;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text('${t.ratio.toInt()}%', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Container(
          width: 30,
          height: height,
          decoration: BoxDecoration(
            color: t.ratio > 10 ? Colors.red.withOpacity(0.6) : Colors.blue.withOpacity(0.6),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(t.period, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  Widget _buildBreakdownTable(List<CancelledOrderRatioDetail> details) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.grey.shade100)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: const [
                Icon(LucideIcons.receipt, size: 20, color: Colors.black87),
                SizedBox(width: 8),
                Text('TRANSACTIONAL BREAKDOWN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey)),
              ],
            ),
          ),
          Table(
            border: TableBorder(horizontalInside: BorderSide(color: Colors.grey.shade50)),
            children: [
              TableRow(
                decoration: BoxDecoration(color: Colors.grey.shade50),
                children: const [
                  Padding(padding: EdgeInsets.all(16), child: Text('DATE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey))),
                  Padding(padding: EdgeInsets.all(16), child: Text('DOC TYPE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey))),
                  Padding(padding: EdgeInsets.all(16), child: Text('PARTY NAME', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey))),
                  Padding(padding: EdgeInsets.all(16), child: Text('AMOUNT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey))),
                  Padding(padding: EdgeInsets.all(16), child: Center(child: Text('STATUS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey)))),
                ],
              ),
              ...details.where((d) => d.status.toLowerCase() == 'cancelled').map((d) => TableRow(
                children: [
                  Padding(padding: const EdgeInsets.all(16), child: Text(d.date, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                  Padding(padding: const EdgeInsets.all(16), child: Text(d.label, style: const TextStyle(fontSize: 12))),
                  Padding(padding: const EdgeInsets.all(16), child: Text(d.partyName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                  Padding(padding: const EdgeInsets.all(16), child: Text('₹${d.netAmount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900))),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(8)),
                        child: const Text('CANCELLED', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w900)),
                      ),
                    ),
                  ),
                ],
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPartyWisePerformance(List<PartyWiseRatio> partyWise) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.grey.shade100)),
      child: Column(
        children: [
          Row(
            children: const [
              Icon(LucideIcons.user, size: 20, color: Colors.indigo),
              SizedBox(width: 8),
              Text('PARTY-WISE PERFORMANCE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 24),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: partyWise.length.clamp(0, 10),
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final p = partyWise[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(p.partyName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
                      Text('${p.ratio.toStringAsFixed(1)}%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: p.ratio > 20 ? Colors.red : Colors.blue)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: p.ratio / 100,
                      minHeight: 6,
                      backgroundColor: Colors.grey.shade100,
                      valueColor: AlwaysStoppedAnimation<Color>(p.ratio > 20 ? Colors.red : Colors.blue),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Slice {
  final Color color;
  final double percent;
  _Slice({required this.color, required this.percent});
}

class _PieChartPainter extends CustomPainter {
  final List<_Slice> slices;
  _PieChartPainter({required this.slices});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()..style = PaintingStyle.stroke..strokeWidth = 12;
    
    double startAngle = -1.5708; // -90 deg
    for (var slice in slices) {
      final sweepAngle = slice.percent * 6.28319; // 360 deg
      paint.color = slice.color;
      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
