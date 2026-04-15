import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../data/providers/audit_provider.dart';
import '../../../masters/data/providers/account_provider.dart';

class VerifyBankStatementPage extends StatefulWidget {
  const VerifyBankStatementPage({super.key});

  @override
  State<VerifyBankStatementPage> createState() => _VerifyBankStatementPageState();
}

class _VerifyBankStatementPageState extends State<VerifyBankStatementPage> {
  String? _selectedBank;
  DateTime _fromDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _toDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch all accounts — filter to Bank type client-side
      context.read<AccountProvider>().fetchAllAccounts();
    });
  }

  void _handleSearch() {
    if (_selectedBank == null) return;
    context.read<AuditProvider>().fetchBankAudit({
      'bankAccount': _selectedBank,
      'fromDate': DateFormat('yyyy-MM-dd').format(_fromDate),
      'toDate': DateFormat('yyyy-MM-dd').format(_toDate),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('Bank Statement Reconciliation', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(LucideIcons.upload, size: 16),
              label: const Text('Import Statement (.csv)'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildBankSelector(),
          Expanded(
            child: Row(
              children: [
                Expanded(flex: 3, child: _buildStatementView()),
                const VerticalDivider(width: 1, thickness: 1),
                Expanded(flex: 2, child: _buildSystemVouchersView()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          Consumer<AccountProvider>(
            builder: (context, provider, _) {
              // Show only bank-type accounts
              final bankAccounts = provider.accounts.where((a) {
                final g = a.groups.map((group) => group.toLowerCase()).join(' ');
                return g.contains('bank') || g.contains('hdfc') || g.contains('icici');
              }).toList();

              return Container(
                width: 250,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedBank,
                    hint: const Text('Select Bank Account'),
                    isExpanded: true,
                    items: (bankAccounts.isEmpty ? provider.accounts : bankAccounts)
                        .map((e) => DropdownMenuItem(
                              value: e.name,
                              child: Text(e.name, style: const TextStyle(fontSize: 13)),
                            ))
                        .toList(),
                    onChanged: (v) {
                      setState(() => _selectedBank = v);
                      _handleSearch();
                    },
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 16),
          _dateRangePicker(),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: _handleSearch,
            icon: const Icon(LucideIcons.refreshCcw, size: 16),
            label: const Text('Fetch Entries'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[800],
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateRangePicker() {
    return Row(
      children: [
        Text(DateFormat('dd MMM').format(_fromDate)),
        const Text(' - '),
        Text(DateFormat('dd MMM yyyy').format(_toDate)),
        IconButton(
          icon: const Icon(LucideIcons.calendar, size: 18),
          onPressed: () async {
            final range = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (range != null) {
              setState(() {
                _fromDate = range.start;
                _toDate = range.end;
              });
              _handleSearch();
            }
          },
        ),
      ],
    );
  }

  Widget _buildStatementView() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Bank Statement Entries',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          const SizedBox(height: 12),
          Expanded(
            child: Consumer<AuditProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) return const Center(child: CircularProgressIndicator());
                if (provider.bankAuditItems.isEmpty) {
                  return const Center(child: Text('No bank entries found for selection.'));
                }
                return ListView.separated(
                  itemCount: provider.bankAuditItems.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final it = provider.bankAuditItems[index];
                    return _statementItem(provider, it);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _statementItem(AuditProvider provider, item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: item.isReconciled ? Colors.green.shade200 : Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: item.type == 'Cr' ? Colors.green[50] : Colors.red[50],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              item.type as String,
              style: TextStyle(
                color: item.type == 'Cr' ? Colors.green[800] : Colors.red[800],
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.description as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text(item.date as String, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
          Text('₹${(item.amount as double).toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 16),
          if (item.isReconciled as bool)
            const Icon(LucideIcons.checkCircle, color: Colors.green, size: 20)
          else
            ElevatedButton(
              onPressed: () {
                if (item.id != null) {
                  provider.updateBankReconciliation(item.id as String, true);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[50],
                foregroundColor: Colors.blue[800],
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: const Text('Match', style: TextStyle(fontSize: 11)),
            ),
        ],
      ),
    );
  }

  Widget _buildSystemVouchersView() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('System Bank Vouchers',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              itemCount: 5,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return const ListTile(
                  title: Text('VCH/23-24/0412', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  subtitle: Text('Bank Payment • 12 Oct 2023', style: TextStyle(fontSize: 11)),
                  trailing: Text('₹5,000.00', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  contentPadding: EdgeInsets.zero,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
