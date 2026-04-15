import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../data/providers/audit_provider.dart';

class VerifyBillingPage extends StatefulWidget {
  const VerifyBillingPage({super.key});

  @override
  State<VerifyBillingPage> createState() => _VerifyBillingPageState();
}

class _VerifyBillingPageState extends State<VerifyBillingPage> {
  DateTime _fromDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _toDate = DateTime.now();
  final ScrollController _horizontalScroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _handleSearch();
  }

  void _handleSearch() {
    context.read<AuditProvider>().fetchBillingAudit({
      'fromDate': DateFormat('yyyy-MM-dd').format(_fromDate),
      'toDate': DateFormat('yyyy-MM-dd').format(_toDate),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Verify Billing Discrepancies', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(LucideIcons.checkSquare, size: 18),
              label: const Text('Mark Selected as Verified'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilters(),
          _buildAuditSummary(),
          Expanded(child: _buildTable()),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          _datePicker('From Date', _fromDate, (d) => setState(() => _fromDate = d)),
          const SizedBox(width: 16),
          _datePicker('To Date', _toDate, (d) => setState(() => _toDate = d)),
          const SizedBox(width: 24),
          ElevatedButton.icon(
            onPressed: _handleSearch,
            icon: const Icon(LucideIcons.search, size: 16),
            label: const Text('Filter Audit'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E293B),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _datePicker(String label, DateTime date, Function(DateTime) onChanged) {
    return InkWell(
      onTap: () async {
        final d = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (d != null) onChanged(d);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(LucideIcons.calendar, size: 16, color: Colors.blueGrey),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 10, color: Colors.blueGrey)),
                Text(DateFormat('dd MMM yyyy').format(date),
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuditSummary() {
    return Consumer<AuditProvider>(
      builder: (context, provider, _) {
        if (provider.billingAuditItems.isEmpty) return const SizedBox.shrink();
        final totalIssues = provider.billingAuditItems.where((it) => it.issues.isNotEmpty).length;
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: totalIssues > 0 ? Colors.red[50] : Colors.green[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: (totalIssues > 0 ? Colors.red[200] : Colors.green[200])!),
          ),
          child: Row(
            children: [
              Icon(
                totalIssues > 0 ? LucideIcons.alertTriangle : LucideIcons.checkCircle,
                color: totalIssues > 0 ? Colors.red[800] : Colors.green[800],
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    totalIssues > 0
                        ? 'Found $totalIssues billing discrepancies'
                        : 'No billing discrepancies found in this period',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: totalIssues > 0 ? Colors.red[900] : Colors.green[900],
                    ),
                  ),
                  const Text(
                    'System audits check for tax miscalculations, voucher series gaps, and total mismatches.',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTable() {
    return Consumer<AuditProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) return const Center(child: CircularProgressIndicator());
        if (provider.billingAuditItems.isEmpty) return const Center(child: Text('No billing data for audit.'));

        return Scrollbar(
          controller: _horizontalScroll,
          child: SingleChildScrollView(
            controller: _horizontalScroll,
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(Colors.grey[100]),
                columns: const [
                  DataColumn(label: Text('Invoice No')),
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Party')),
                  DataColumn(label: Text('System Amount')),
                  DataColumn(label: Text('Recalculated Amount')),
                  DataColumn(label: Text('Variance')),
                  DataColumn(label: Text('Issues Found')),
                  DataColumn(label: Text('Status')),
                ],
                rows: provider.billingAuditItems.map((it) {
                  final hasIssue = it.issues.isNotEmpty;
                  return DataRow(
                    cells: [
                      DataCell(Text(it.invoiceNo, style: const TextStyle(fontWeight: FontWeight.bold))),
                      DataCell(Text(it.date)),
                      DataCell(Text(it.partyName)),
                      DataCell(Text('₹${it.systemAmount.toStringAsFixed(2)}')),
                      DataCell(Text('₹${it.recalculatedAmount.toStringAsFixed(2)}')),
                      DataCell(
                        Text(
                          '₹${it.variance.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: it.variance != 0 ? Colors.red[800] : Colors.green[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataCell(
                        it.issues.isEmpty
                            ? const Text('-', style: TextStyle(color: Colors.grey))
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: it.issues
                                    .map((e) => Text('• $e', style: const TextStyle(fontSize: 11, color: Colors.red)))
                                    .toList(),
                              ),
                      ),
                      DataCell(
                        Icon(
                          it.isVerified ? LucideIcons.checkCircle : LucideIcons.circle,
                          color: it.isVerified ? Colors.green : Colors.grey,
                          size: 20,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
