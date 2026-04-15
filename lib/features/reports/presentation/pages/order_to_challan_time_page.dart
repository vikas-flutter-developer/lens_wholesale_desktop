import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import '../../data/providers/operational_report_provider.dart';
import '../../data/models/operational_report_model.dart';

class OrderToChallanTimePage extends StatefulWidget {
  const OrderToChallanTimePage({super.key});

  @override
  State<OrderToChallanTimePage> createState() => _OrderToChallanTimePageState();
}

class _OrderToChallanTimePageState extends State<OrderToChallanTimePage> {
  final _dateFromController = TextEditingController(text: DateFormat('yyyy-MM-01').format(DateTime.now()));
  final _dateToController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  String _status = 'All';
  String _partySearch = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
  }

  void _fetchData() {
    context.read<OperationalReportProvider>().fetchOrderToChallanReport({
      'dateFrom': _dateFromController.text,
      'dateTo': _dateToController.text,
      'status': _status,
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
              _buildFilters(provider),
              _buildSummaryCards(provider),
              Expanded(
                child: provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildSlaChart(provider),
                            _buildDetailedTable(provider),
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

  Widget _buildHeader(OperationalReportProvider provider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF4F46E5),
        gradient: LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF4338CA)]),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
            child: const Icon(LucideIcons.clock, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Order to Challan Time Report',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
              ),
              Text(
                'Monitor processing efficiency and operational bottlenecks',
                style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
              ),
            ],
          ),
          const Spacer(),
          _buildThresholdControl(provider),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () {
              final bytes = provider.exportOrderToChallanCsv();
              Printing.sharePdf(bytes: bytes, filename: 'order_to_challan_report.csv');
            },
            icon: const Icon(LucideIcons.download, size: 16),
            label: const Text('Export'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.indigo,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThresholdControl(OperationalReportProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.settings2, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          const Text('Threshold (Mins):', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(width: 12),
          SizedBox(
            width: 40,
            child: TextField(
              controller: TextEditingController(text: provider.threshold.toString()),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(isDense: true, border: InputBorder.none),
              keyboardType: TextInputType.number,
              onSubmitted: (val) => provider.setThreshold(int.tryParse(val) ?? 30),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(OperationalReportProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: Colors.white,
      child: Row(
        children: [
          _filterItem('From', _dateFromController, isDate: true),
          const SizedBox(width: 16),
          _filterItem('To', _dateToController, isDate: true),
          const SizedBox(width: 16),
          _statusDropdown(),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: _fetchData,
            icon: const Icon(LucideIcons.refreshCw, size: 16),
            label: const Text('Refresh'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
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

  Widget _statusDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('STATUS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey)),
        const SizedBox(height: 4),
        Container(
          width: 150,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(8)),
          child: DropdownButton<String>(
            value: _status,
            isExpanded: true,
            underline: Container(),
            items: ['All', 'Completed', 'Pending'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (val) {
              setState(() => _status = val!);
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

  Widget _buildSummaryCards(OperationalReportProvider provider) {
    if (provider.orderToChallanReport == null) return const SizedBox.shrink();
    final summary = provider.orderToChallanReport!.summary;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          _summaryCard('Total Orders', summary.totalOrders.toString(), LucideIcons.receipt, Colors.blue),
          const SizedBox(width: 16),
          _summaryCard('Completed', summary.completedOrders.toString(), LucideIcons.checkCircle2, Colors.teal),
          const SizedBox(width: 16),
          _summaryCard('Pending', summary.pendingOrders.toString(), LucideIcons.alertCircle, Colors.amber),
          const SizedBox(width: 16),
          _summaryCard('Avg. Processing', _formatTime(summary.avgTime), LucideIcons.clock, summary.avgTime > provider.threshold ? Colors.red : Colors.indigo),
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
                Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey, letterSpacing: 1.2)),
                Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: color)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlaChart(OperationalReportProvider provider) {
    if (provider.orderToChallanReport == null || provider.orderToChallanReport!.details.isEmpty) return const SizedBox.shrink();
    
    final details = provider.orderToChallanReport!.details;
    final onTimeCount = details.where((d) => d.status != 'Pending' && d.timeDifference <= provider.threshold).length;
    final delayedCount = details.where((d) => d.timeDifference > provider.threshold).length;
    final pendingCount = details.where((d) => d.status == 'Pending' && d.timeDifference <= provider.threshold).length;
    final total = details.length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.grey.shade100)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(LucideIcons.activity, size: 20, color: Colors.indigo),
                    SizedBox(width: 8),
                    Text('SLA COMPLIANCE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 24),
                _slaMetric('On Time', onTimeCount, total, Colors.teal),
                const SizedBox(height: 12),
                _slaMetric('Delayed', delayedCount, total, Colors.red),
                const SizedBox(height: 12),
                _slaMetric('Pending (Under SLA)', pendingCount, total, Colors.amber),
              ],
            ),
          ),
          const SizedBox(width: 48),
          SizedBox(
            height: 180,
            width: 180,
            child: Stack(
              children: [
                Center(
                  child: CustomPaint(
                    size: const Size(180, 180),
                    painter: _PieChartPainter(
                      slices: [
                        _Slice(color: Colors.teal, percent: onTimeCount / total),
                        _Slice(color: Colors.red, percent: delayedCount / total),
                        _Slice(color: Colors.amber, percent: pendingCount / total),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${((onTimeCount / total) * 100).toStringAsFixed(0)}%', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.teal)),
                      const Text('ON TIME', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _slaMetric(String label, int count, int total, Color color) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
        const Spacer(),
        Text('$count orders', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
        const SizedBox(width: 12),
        Text('${((count / total) * 100).toStringAsFixed(1)}%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: color)),
      ],
    );
  }

  Widget _buildDetailedTable(OperationalReportProvider provider) {
    final details = provider.orderToChallanReport?.details ?? [];
    if (details.isEmpty) return const Center(child: Text('No data found for the selected period.'));

    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.grey.shade100)),
      child: Column(
        children: [
          _tableHeader(),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: details.length,
            separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade50),
            itemBuilder: (context, index) => _tableRow(details[index], provider.threshold),
          ),
        ],
      ),
    );
  }

  Widget _tableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
      child: Row(
        children: const [
          Expanded(child: Text('ORDER DETAIL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey))),
          Expanded(child: Text('CHALLAN DETAIL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey))),
          Expanded(child: Text('PARTY NAME', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey))),
          SizedBox(width: 120, child: Text('DIFFERENCE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey), textAlign: TextAlign.center)),
          SizedBox(width: 120, child: Text('STATUS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey), textAlign: TextAlign.center)),
        ],
      ),
    );
  }

  Widget _tableRow(OrderToChallanDetail d, int threshold) {
    final bool isDelayed = d.timeDifference > threshold;
    final bool isPending = d.status == 'Pending';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: isDelayed ? Colors.red.withOpacity(0.02) : null,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(d.orderNo, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                Text(_formatDateTime(d.orderCreatedAt), style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
          ),
          Expanded(
            child: d.challanNo != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(d.challanNo!, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                      Text(_formatDateTime(d.challanCreatedAt!), style: const TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  )
                : const Text('NOT CREATED', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.redAccent)),
          ),
          Expanded(
            child: Row(
              children: [
                const CircleAvatar(radius: 12, backgroundColor: Color(0xFFF1F5F9), child: Icon(LucideIcons.user, size: 12, color: Colors.grey)),
                const SizedBox(width: 8),
                Text(d.partyName, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
              ],
            ),
          ),
          SizedBox(
            width: 120,
            child: Column(
              children: [
                Text(_formatTime(d.timeDifference), style: TextStyle(fontWeight: FontWeight.w900, color: isDelayed ? Colors.red : Colors.black87)),
                if (isPending) const Text('RUNNING', style: TextStyle(fontSize: 8, color: Colors.amber, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          SizedBox(
            width: 120,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDelayed ? Colors.red : (isPending ? Colors.amber : Colors.teal),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isDelayed ? 'DELAYED' : (isPending ? 'PENDING' : 'ON TIME'),
                  style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(double mins) {
    if (mins < 60) return '${mins.toInt()}m';
    final h = (mins / 60).floor();
    final m = (mins % 60).toInt();
    return m > 0 ? '${h}h ${m}m' : '${h}h';
  }

  String _formatDateTime(String dt) {
    try {
      final date = DateTime.parse(dt);
      return DateFormat('dd/MM/yy, hh:mm a').format(date);
    } catch (_) {
      return dt;
    }
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
    final paint = Paint()..style = PaintingStyle.stroke..strokeWidth = 14;
    
    double startAngle = -1.5708; // -90 deg
    for (var slice in slices) {
      if (slice.percent <= 0) continue;
      final sweepAngle = slice.percent * 6.28319; // 360 deg
      paint.color = slice.color;
      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

