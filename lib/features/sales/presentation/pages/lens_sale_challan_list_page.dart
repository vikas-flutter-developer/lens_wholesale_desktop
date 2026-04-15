import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../data/models/lens_sale_challan_model.dart';
import '../../data/providers/lens_sale_challan_provider.dart';

class LensSaleChallanListPage extends StatefulWidget {
  const LensSaleChallanListPage({super.key});

  @override
  State<LensSaleChallanListPage> createState() => _LensSaleChallanListPageState();
}

class _LensSaleChallanListPageState extends State<LensSaleChallanListPage> {
  String _searchQuery = '';
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LensSaleChallanProvider>().fetchAllChallans();
    });
  }

  List<LensSaleChallanModel> get _filteredChallans {
    final provider = context.watch<LensSaleChallanProvider>();
    return provider.challans.where((challan) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        if (!(challan.billData.billNo.toLowerCase().contains(q) ||
              challan.partyData.partyAccount.toLowerCase().contains(q))) {
          return false;
        }
      }
      if (_fromDate != null && challan.billData.date != null) {
        final d = DateTime.tryParse(challan.billData.date!);
        if (d != null && d.isBefore(_fromDate!)) return false;
      }
      if (_toDate != null && challan.billData.date != null) {
        final d = DateTime.tryParse(challan.billData.date!);
        if (d != null && d.isAfter(_toDate!.add(const Duration(days: 1)))) return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildFilters(),
            const SizedBox(height: 24),
            _buildChallanTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Lens Sale Challans', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            SizedBox(height: 4),
            Text('Manage delivery notes and item dispatches', style: TextStyle(fontSize: 14, color: Color(0xFF64748B))),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => context.push('/sales/add-lens-sale-challan'),
          icon: const Icon(LucideIcons.plus, size: 18),
          label: const Text('Add Sale Challan'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2563EB),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFE2E8F0))),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search by Challan No or Party Name...',
                  prefixIcon: const Icon(LucideIcons.search, size: 18, color: Color(0xFF94A3B8)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  isDense: true,
                ),
                onChanged: (val) => setState(() => _searchQuery = val),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
               child: InkWell(
                 onTap: () async {
                   final date = await showDatePicker(context: context, initialDate: _fromDate ?? DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
                   if (date != null) setState(() => _fromDate = date);
                 },
                 child: Container(
                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                   decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE2E8F0)), borderRadius: BorderRadius.circular(8)),
                   child: Row(children: [const Icon(LucideIcons.calendar, size: 16, color: Color(0xFF64748B)), const SizedBox(width: 8), Text(_fromDate != null ? DateFormat('dd MMM yyyy').format(_fromDate!) : 'From Date', style: const TextStyle(fontSize: 13, color: Color(0xFF475569)))]),
                 ),
               ),
            ),
            const SizedBox(width: 16),
             Expanded(
               child: InkWell(
                 onTap: () async {
                   final date = await showDatePicker(context: context, initialDate: _toDate ?? DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
                   if (date != null) setState(() => _toDate = date);
                 },
                 child: Container(
                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                   decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE2E8F0)), borderRadius: BorderRadius.circular(8)),
                   child: Row(children: [const Icon(LucideIcons.calendar, size: 16, color: Color(0xFF64748B)), const SizedBox(width: 8), Text(_toDate != null ? DateFormat('dd MMM yyyy').format(_toDate!) : 'To Date', style: const TextStyle(fontSize: 13, color: Color(0xFF475569)))]),
                 ),
               ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChallanTable() {
    return Expanded(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFE2E8F0))),
        child: _filteredChallans.isEmpty 
          ? const Center(child: Text('No challans found.', style: TextStyle(color: Colors.grey)))
          : Scrollbar(
              child: ListView(
                children: [
                  DataTable(
                    headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                    columns: const [
                      DataColumn(label: Text('DATE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF64748B)))),
                      DataColumn(label: Text('CHALLAN NO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF64748B)))),
                      DataColumn(label: Text('PARTY NAME', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF64748B)))),
                      DataColumn(label: Text('QTY', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF64748B)))),
                      DataColumn(label: Text('NET AMT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF64748B)))),
                      DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF64748B)))),
                      DataColumn(label: Text('ACTIONS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF64748B)))),
                    ],
                    rows: _filteredChallans.map((challan) {
                      return DataRow(
                        cells: [
                          DataCell(Text(challan.billData.date ?? '-', style: const TextStyle(fontSize: 13))),
                          DataCell(Text('${challan.billData.billSeries}-${challan.billData.billNo}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
                          DataCell(Text(challan.partyData.partyAccount, style: const TextStyle(fontSize: 13))),
                          DataCell(Text(challan.orderQty.toString(), style: const TextStyle(fontSize: 13))),
                          DataCell(Text('₹ ${challan.netAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 13, color: Color(0xFF16A34A), fontWeight: FontWeight.bold))),
                          DataCell(_buildStatusBadge(challan.status)),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(icon: const Icon(LucideIcons.printer, size: 18, color: Color(0xFF64748B)), onPressed: () {}),
                                IconButton(
                                  icon: const Icon(LucideIcons.edit, size: 18, color: Color(0xFF2563EB)),
                                  onPressed: () => context.push('/sales/add-lens-sale-challan?id=${challan.id}'),
                                ),
                                IconButton(
                                  icon: const Icon(LucideIcons.trash2, size: 18, color: Colors.red),
                                  onPressed: () {
                                    context.read<LensSaleChallanProvider>().deleteChallan(challan.id!);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg = const Color(0xFFF1F5F9);
    Color fg = const Color(0xFF64748B);
    switch (status.toLowerCase()) {
      case 'done':
      case 'invoiced':
        bg = const Color(0xFFDCFCE7);
        fg = const Color(0xFF16A34A);
        break;
      case 'pending':
        bg = const Color(0xFFFEF9C3);
        fg = const Color(0xFFCA8A04);
        break;
      case 'cancelled':
        bg = const Color(0xFFFEE2E2);
        fg = const Color(0xFFEF4444);
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16)),
      child: Text(status.toUpperCase(), style: TextStyle(color: fg, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}
