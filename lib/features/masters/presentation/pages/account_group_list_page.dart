import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../data/providers/account_group_provider.dart';
import 'add_account_group_page.dart';

class AccountGroupListPage extends StatefulWidget {
  const AccountGroupListPage({super.key});

  @override
  State<AccountGroupListPage> createState() => _AccountGroupListPageState();
}

class _AccountGroupListPageState extends State<AccountGroupListPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchTerm = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountGroupProvider>().fetchAllAccountGroups();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchTerm = value.toLowerCase();
    });
  }

  void _handleDelete(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this account group?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final success = await context.read<AccountGroupProvider>().deleteAccountGroup(id);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account Group deleted successfully!")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AccountGroupProvider>();
    final filteredGroups = provider.accountGroups.where((group) {
      return group.accountGroupName.toLowerCase().contains(_searchTerm);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Account Group Master",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Color(0xFF0F172A), letterSpacing: -0.5),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Manage your account groups and ledger classifications",
                      style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddAccountGroupPage()),
                  ),
                  icon: const Icon(LucideIcons.plus, size: 18, color: Colors.white),
                  label: const Text("Add New", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Search Bar & Actions
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchCtrl,
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(LucideIcons.search, size: 20),
                        hintText: "Search by account name...",
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      _searchCtrl.clear();
                      _onSearchChanged("");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF1F5F9),
                      foregroundColor: const Color(0xFF475569),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: Row(
                      children: const [Icon(LucideIcons.rotateCcw, size: 18), SizedBox(width: 8), Text("Reset")],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Data Table View
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              width: double.infinity,
              child: provider.isLoading && provider.accountGroups.isEmpty
                  ? const Padding(padding: EdgeInsets.all(48.0), child: Center(child: CircularProgressIndicator()))
                  : filteredGroups.isEmpty
                      ? const Padding(padding: EdgeInsets.all(48.0), child: Center(child: Text("No records found", style: TextStyle(color: Color(0xFF64748B), fontSize: 16))))
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
                              DataColumn(label: Text("Sr. No.")),
                              DataColumn(label: Text("Account Group Name")),
                              DataColumn(label: Text("Primary")),
                              DataColumn(label: Text("Ledger Group")),
                              DataColumn(label: Center(child: Text("Actions"))),
                            ],
                            rows: List.generate(filteredGroups.length, (index) {
                              final group = filteredGroups[index];
                              return DataRow(cells: [
                                DataCell(Text("${index + 1}")),
                                DataCell(Text(group.accountGroupName, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E293B)))),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: group.primaryGroup == "Y" ? Colors.green.shade50 : Colors.blueGrey.shade50,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      group.primaryGroup,
                                      style: TextStyle(color: group.primaryGroup == "Y" ? Colors.green.shade800 : Colors.blueGrey.shade600, fontWeight: FontWeight.bold, fontSize: 12),
                                    ),
                                  ),
                                ),
                                DataCell(Text(group.ledgerGroup)),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(LucideIcons.pencil, size: 18, color: Color(0xFF3B82F6)),
                                        onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => AddAccountGroupPage(accountGroup: group)),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(LucideIcons.trash, size: 18, color: Color(0xFFEF4444)),
                                        onPressed: () => _handleDelete(group.id),
                                      ),
                                    ],
                                  ),
                                ),
                              ]);
                            }),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
