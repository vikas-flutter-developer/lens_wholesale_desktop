import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../data/providers/sale_return_provider.dart';

class SaleReturnListPage extends StatefulWidget {
  const SaleReturnListPage({super.key});

  @override
  State<SaleReturnListPage> createState() => _SaleReturnListPageState();
}

class _SaleReturnListPageState extends State<SaleReturnListPage> {
  String _searchQuery = '';
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<SaleReturnProvider>().fetchAllReturns());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Column(
        children: [
          _buildHeader(),
          _buildFilters(),
          Expanded(child: _buildList()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/sales/add-sale-return'),
        label: const Text('New Return'),
        icon: const Icon(LucideIcons.plus),
        backgroundColor: const Color(0xFFEF4444),
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      color: Colors.white,
      child: const Row(
        children: [
          Icon(LucideIcons.rotateCcw, color: Color(0xFFEF4444), size: 24),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sale Returns', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text('Manage and track customer returns and inventory credits', style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Search by party or bill no...',
                prefixIcon: const Icon(LucideIcons.search, size: 18),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                isDense: true,
              ),
            ),
          ),
          const SizedBox(width: 16),
          _buildDateButton('Start Date', _startDate, (d) => setState(() => _startDate = d)),
          const SizedBox(width: 8),
          _buildDateButton('End Date', _endDate, (d) => setState(() => _endDate = d)),
          const SizedBox(width: 16),
          IconButton(
            onPressed: () {
              setState(() {
                _startDate = null;
                _endDate = null;
                _searchQuery = '';
              });
              context.read<SaleReturnProvider>().fetchAllReturns();
            },
            icon: const Icon(LucideIcons.refreshCw, size: 18),
            tooltip: 'Reset Filters',
          )
        ],
      ),
    );
  }

  Widget _buildDateButton(String label, DateTime? value, Function(DateTime?) onSelected) {
    return ActionChip(
      onPressed: () async {
        final d = await showDatePicker(context: context, initialDate: value ?? DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
        onSelected(d);
      },
      label: Text(value == null ? label : DateFormat('dd/MM/yy').format(value)),
      avatar: const Icon(LucideIcons.calendar, size: 14),
    );
  }

  Widget _buildList() {
    return Consumer<SaleReturnProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) return const Center(child: CircularProgressIndicator());
        
        final filtered = provider.returns.where((r) {
          final matchesSearch = r.partyData.partyAccount.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                                r.billData.billNo.toLowerCase().contains(_searchQuery.toLowerCase());
          final date = r.billData.date != null ? DateTime.tryParse(r.billData.date!) : null;
          final matchesStart = _startDate == null || (date != null && !date.isBefore(_startDate!));
          final matchesEnd = _endDate == null || (date != null && !date.isAfter(_endDate!));
          return matchesSearch && matchesStart && matchesEnd;
        }).toList();

        if (filtered.isEmpty) return const Center(child: Text('No returns found'));

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final sr = filtered[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFE2E8F0))),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                leading: CircleAvatar(
                  backgroundColor: sr.type == 'RX SALE RETURN' ? const Color(0xFFF5F3FF) : const Color(0xFFFEF2F2),
                  child: Icon(sr.type == 'RX SALE RETURN' ? LucideIcons.repeat : LucideIcons.rotateCcw, 
                            color: sr.type == 'RX SALE RETURN' ? const Color(0xFF7C3AED) : const Color(0xFFEF4444), size: 20),
                ),
                title: Row(
                  children: [
                    Text(sr.partyData.partyAccount, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(4)),
                      child: Text('${sr.billData.billSeries}-${sr.billData.billNo}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                    ),
                  ],
                ),
                subtitle: Text('Items: ${sr.items.length} | Date: ${sr.billData.date} | Status: ${sr.status}', style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('₹${sr.netAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                        const Text('RETURN AMT', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8))),
                      ],
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(LucideIcons.trash2, size: 16, color: Color(0xFFEF4444)),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: const Text('Are you sure you want to delete this sale return?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                              TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          final res = await context.read<SaleReturnProvider>().deleteReturn(sr.id!, isRx: sr.type == 'RX SALE RETURN');
                          if (res['success'] == true) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sale Return deleted successfully')));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${res['message']}')));
                          }
                        }
                      },
                    ),
                  ],
                ),
                onTap: () {
                   final route = sr.type == 'RX SALE RETURN' ? '/sales/add-rx-sale-return' : '/sales/add-sale-return';
                   context.push('$route?id=${sr.id}');
                },
              ),
            );
          },
        );
      },
    );
  }
}
