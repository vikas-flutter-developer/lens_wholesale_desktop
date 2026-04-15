import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:printing/printing.dart';
import '../../data/services/target_service.dart';
import '../../data/providers/target_provider.dart';
import '../../data/models/target_model.dart';

class SaleTargetReportPage extends StatefulWidget {
  const SaleTargetReportPage({super.key});

  @override
  State<SaleTargetReportPage> createState() => _SaleTargetReportPageState();
}

class _SaleTargetReportPageState extends State<SaleTargetReportPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  void _fetchData() {
    final provider = Provider.of<TargetProvider>(context, listen: false);
    if (_tabController.index == 0) {
      provider.fetchSaleTargetReport();
    } else {
      provider.fetchCollectionTargetReport('Customer');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Column(
        children: [
          _buildHeader(),
          _buildFilters(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _TargetView(isCollection: false),
                _TargetView(isCollection: true),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showTargetEntryDialog(),
        icon: const Icon(LucideIcons.plus),
        label: const Text('Set Target'),
        backgroundColor: const Color(0xFF1D4ED8),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFF1D4ED8), Color(0xFF4338CA)]),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(LucideIcons.target, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              const Text(
                'Targets Management',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  tabs: const [
                    Tab(text: 'Sales Targets'),
                    Tab(text: 'Collection Targets'),
                  ],
                  onTap: (index) => _fetchData(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Consumer<TargetProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          color: Colors.white,
          child: Row(
            children: [
              _filterDropdown(
                label: 'Period',
                value: provider.selectedPeriodType,
                items: ['Monthly', 'Quarterly', 'Yearly'],
                onChanged: (val) {
                  provider.setFilters(periodType: val);
                  _fetchData();
                },
              ),
              const SizedBox(width: 16),
              if (provider.selectedPeriodType == 'Monthly')
                _filterDropdown(
                  label: 'Month',
                  value: provider.selectedMonth,
                  items: List.generate(12, (index) => index + 1),
                  onChanged: (val) {
                    provider.setFilters(month: val);
                    _fetchData();
                  },
                ),
              if (provider.selectedPeriodType == 'Quarterly')
                _filterDropdown(
                  label: 'Quarter',
                  value: provider.selectedQuarter,
                  items: [1, 2, 3, 4],
                  onChanged: (val) {
                    provider.setFilters(quarter: val);
                    _fetchData();
                  },
                ),
              const SizedBox(width: 16),
              _filterDropdown(
                label: 'Year',
                value: provider.selectedYear,
                items: List.generate(5, (index) => 2024 + index),
                onChanged: (val) {
                  provider.setFilters(year: val);
                  _fetchData();
                },
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  final bytes = provider.exportToCsv(_tabController.index == 1);
                  Printing.sharePdf(
                    bytes: bytes,
                    filename: '${_tabController.index == 0 ? "sales" : "collection"}_targets.csv',
                  );
                },
                icon: const Icon(LucideIcons.fileSpreadsheet, size: 16),
                label: const Text('Export'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: _fetchData,
                icon: const Icon(LucideIcons.refreshCw, size: 16),
                label: const Text('Refresh'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D4ED8),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _filterDropdown({required String label, required dynamic value, required List<dynamic> items, required Function(dynamic) onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
          child: DropdownButton<dynamic>(
            value: value,
            underline: Container(),
            items: items.map((e) {
              String text = e.toString();
              if (label == 'Month') {
                text = [
                  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
                ][e - 1];
              }
              return DropdownMenuItem(value: e, child: Text(text));
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  void _showTargetEntryDialog() {
    showDialog(
      context: context,
      builder: (context) => _TargetEntryDialog(
        isCollection: _tabController.index == 1,
      ),
    );
  }
}

class _TargetView extends StatelessWidget {
  final bool isCollection;
  const _TargetView({required this.isCollection});

  @override
  Widget build(BuildContext context) {
    return Consumer<TargetProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) return const Center(child: CircularProgressIndicator());
        final report = isCollection ? provider.collectionReport : provider.saleReport;
        if (report == null || report.data.isEmpty) {
          return const Center(child: Text('No agents found for this period.'));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(24),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 1.5,
          ),
          itemCount: report.data.length,
          itemBuilder: (context, index) {
            final agent = report.data[index];
            return _AgentCard(agent: agent);
          },
        );
      },
    );
  }
}

class _AgentCard extends StatelessWidget {
  final AgentPerformance agent;
  const _AgentCard({required this.agent});

  @override
  Widget build(BuildContext context) {
    final ratio = agent.ratio / 100;
    Color statusColor;
    switch (agent.status) {
      case 'Achieved':
        statusColor = Colors.green;
        break;
      case 'Pending':
        statusColor = Colors.orange;
        break;
      case 'Below Target':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: statusColor.withOpacity(0.1),
                  child: Icon(LucideIcons.user, color: statusColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(agent.partyName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text(agent.status, style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Text('${agent.ratio.toStringAsFixed(1)}%', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: statusColor)),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(LucideIcons.history, size: 18),
                  onPressed: () => _showHistoryDialog(context, agent.partyName, isCollection: true), // Simplified
                  tooltip: 'View History',
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _metric('Target', agent.targetAmount),
                _metric('Achieved', agent.achieved),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: ratio.clamp(0.0, 1.0),
                minHeight: 8,
                backgroundColor: Colors.grey.shade100,
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              agent.difference > 0 ? '${agent.difference.toStringAsFixed(0)} pending' : 'Target exceeded!',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metric(String label, double val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
        Text('₹${val.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }
}

class _TargetEntryDialog extends StatefulWidget {
  final bool isCollection;
  const _TargetEntryDialog({required this.isCollection});

  @override
  State<_TargetEntryDialog> createState() => _TargetEntryDialogState();
}

class _TargetEntryDialogState extends State<_TargetEntryDialog> {
  final _amountController = TextEditingController();
  final _partyController = TextEditingController();
  String _selectedPartyId = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Set ${widget.isCollection ? 'Collection' : 'Sale'} Target'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _partyController,
            decoration: const InputDecoration(labelText: 'Party / Agent Name'),
            onChanged: (val) => _selectedPartyId = val, // For demo, assuming ID = Name
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _amountController,
            decoration: const InputDecoration(labelText: 'Target Amount (₹)'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () async {
            final provider = Provider.of<TargetProvider>(context, listen: false);
            final success = await provider.saveTarget(
              partyId: _selectedPartyId,
              partyName: _partyController.text,
              amount: double.tryParse(_amountController.text) ?? 0,
              isCollection: widget.isCollection,
              targetType: widget.isCollection ? 'Customer' : null,
            );
            if (success && mounted) Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1D4ED8), foregroundColor: Colors.white),
          child: const Text('Save Target'),
        ),
      ],
    );
  }
}

void _showHistoryDialog(BuildContext context, String partyName, {required bool isCollection}) {
  showDialog(
    context: context,
    builder: (context) => _AgentHistoryDialog(partyName: partyName, isCollection: isCollection),
  );
}

class _AgentHistoryDialog extends StatelessWidget {
  final String partyName;
  final bool isCollection;
  const _AgentHistoryDialog({required this.partyName, required this.isCollection});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<TargetProvider>();
    return AlertDialog(
      title: Text('Performance History: $partyName'),
      content: SizedBox(
        width: 600,
        height: 400,
        child: FutureBuilder<List<AgentPerformance>>(
          future: isCollection 
            ? targetService.getCollectionTargetHistory(partyName, 'Customer')
            : targetService.getPartyTargetHistory(partyName),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
            if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text('No historical data found.'));

            return ListView.separated(
              itemCount: snapshot.data!.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final h = snapshot.data![index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: h.status == 'Achieved' ? Colors.green.shade50 : Colors.red.shade50,
                    child: Text(h.year.toString().substring(2), style: TextStyle(fontSize: 12, color: h.status == 'Achieved' ? Colors.green : Colors.red)),
                  ),
                  title: Text('${h.periodType} - ${h.month ?? h.quarter ?? h.year}'),
                  subtitle: Text('Target: ₹${h.targetAmount} | Achieved: ₹${h.achieved}'),
                  trailing: Text('${h.ratio}%', style: const TextStyle(fontWeight: FontWeight.bold)),
                );
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
      ],
    );
  }
}
