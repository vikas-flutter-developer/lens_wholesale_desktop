import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../data/providers/payment_history_provider.dart';
import '../../data/models/payment_history_model.dart';

class SAPaymentHistoryPage extends StatefulWidget {
  const SAPaymentHistoryPage({super.key});

  @override
  State<SAPaymentHistoryPage> createState() => _SAPaymentHistoryPageState();
}

class _SAPaymentHistoryPageState extends State<SAPaymentHistoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentHistoryProvider>().fetchPayments();
    });
  }

  String _formatDate(DateTime dt) {
    return "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}";
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'paid': return Colors.green.shade600;
      case 'pending': return Colors.amber.shade700;
      case 'failed': return Colors.red.shade600;
      default: return Colors.grey;
    }
  }

  Color _statusBg(String status) {
    switch (status) {
      case 'paid': return Colors.green.shade50;
      case 'pending': return Colors.amber.shade50;
      case 'failed': return Colors.red.shade50;
      default: return Colors.grey.shade100;
    }
  }

  Color _statusBorder(String status) {
    switch (status) {
      case 'paid': return Colors.green.shade200;
      case 'pending': return Colors.amber.shade200;
      case 'failed': return Colors.red.shade200;
      default: return Colors.grey.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PaymentHistoryProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Payment History",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Color(0xFF0F172A), letterSpacing: -0.5),
          ),
          const SizedBox(height: 8),
          const Text(
            "Track all subscription transactions and billing records across all companies.",
            style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 32),

          // Summary Stat Row
          if (!provider.isLoading) ...[
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                _buildStatChip(
                  label: "Total Revenue",
                  value: "₹${provider.totalRevenue.toStringAsFixed(2)}",
                  icon: LucideIcons.trendingUp,
                  color: const Color(0xFF10B981),
                ),
                _buildStatChip(
                  label: "Paid",
                  value: "${provider.paidCount}",
                  icon: LucideIcons.checkCircle,
                  color: const Color(0xFF10B981),
                ),
                _buildStatChip(
                  label: "Pending",
                  value: "${provider.pendingCount}",
                  icon: LucideIcons.clock,
                  color: const Color(0xFFF59E0B),
                ),
                _buildStatChip(
                  label: "Failed",
                  value: "${provider.failedCount}",
                  icon: LucideIcons.xCircle,
                  color: const Color(0xFFEF4444),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],

          // Error
          if (provider.error != null)
            Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                border: Border.all(color: Colors.red.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(LucideIcons.alertCircle, color: Colors.red.shade700),
                  const SizedBox(width: 12),
                  Expanded(child: Text(provider.error!, style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w500))),
                ],
              ),
            ),

          // Data Table
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF1F5F9)),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: provider.isLoading
                ? const Padding(
                    padding: EdgeInsets.all(48.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : provider.payments.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(48.0),
                        child: Center(
                          child: Text("No payment records found.", style: TextStyle(color: Color(0xFF64748B), fontSize: 16)),
                        ),
                      )
                    : Theme(
                        data: Theme.of(context).copyWith(
                          dataTableTheme: DataTableThemeData(
                            headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                            headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                          ),
                        ),
                        child: DataTable(
                          columnSpacing: 24,
                          horizontalMargin: 24,
                          showBottomBorder: true,
                          columns: const [
                            DataColumn(label: Text("Company")),
                            DataColumn(label: Text("Plan")),
                            DataColumn(label: Text("Amount")),
                            DataColumn(label: Text("Billing Cycle")),
                            DataColumn(label: Text("Method")),
                            DataColumn(label: Text("Paid On")),
                            DataColumn(label: Text("Valid Until")),
                            DataColumn(label: Text("Status")),
                          ],
                          rows: provider.payments.map((p) => _buildRow(p)).toList(),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  DataRow _buildRow(PaymentHistoryModel p) {
    return DataRow(
      cells: [
        DataCell(Text(p.companyName, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E293B)))),
        DataCell(Text(p.planName)),
        DataCell(Text("₹${p.amount.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.w600))),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(4)),
            child: Text(p.billingCycle.toUpperCase(), style: TextStyle(color: Colors.blue.shade700, fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ),
        DataCell(Text(p.paymentMethod)),
        DataCell(Text(_formatDate(p.paidAt))),
        DataCell(Text(_formatDate(p.validUntil))),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: _statusBg(p.status),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _statusBorder(p.status)),
            ),
            child: Text(
              p.status.toUpperCase(),
              style: TextStyle(color: _statusColor(p.status), fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatChip({required String label, required String value, required IconData icon, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.w500)),
              Text(value, style: const TextStyle(color: Color(0xFF1E293B), fontSize: 20, fontWeight: FontWeight.w800)),
            ],
          ),
        ],
      ),
    );
  }
}
