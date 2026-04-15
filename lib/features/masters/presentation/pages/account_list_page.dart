import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../data/providers/account_provider.dart';
import '../../data/providers/account_group_provider.dart';
import 'add_account_page.dart';

class AccountListPage extends StatefulWidget {
  const AccountListPage({super.key});

  @override
  State<AccountListPage> createState() => _AccountListPageState();
}

class _AccountListPageState extends State<AccountListPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchTerm = "";
  String _selectedGroup = "";
  String _selectedType = ""; // 'Sale', 'Purchase', 'Both'
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountProvider>().fetchAllAccounts();
      context.read<AccountGroupProvider>().fetchAllAccountGroups();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _handleReset() {
    setState(() {
      _searchCtrl.clear();
      _searchTerm = "";
      _selectedGroup = "";
      _selectedType = "";
      _fromDate = null;
      _toDate = null;
    });
  }

  void _handleDelete(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this account?"),
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
      final success = await context.read<AccountProvider>().deleteAccount(id);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Account deleted successfully!")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AccountProvider>();
    final groupProvider = context.watch<AccountGroupProvider>();

    final filteredAccounts = provider.accounts.where((account) {
      final matchesSearch = _searchTerm.isEmpty ||
          account.name.toLowerCase().contains(_searchTerm) ||
          (account.mobileNumber?.contains(_searchTerm) ?? false) ||
          (account.gstin?.toLowerCase().contains(_searchTerm) ?? false);

      final matchesGroup = _selectedGroup.isEmpty ||
          account.groups.any((g) => g.toLowerCase().contains(_selectedGroup.toLowerCase()));

      final matchesType = _selectedType.isEmpty ||
          account.accountType == "Both" ||
          account.accountType == _selectedType;

      bool matchesDate = true;
      if (_fromDate != null || _toDate != null) {
        if (account.createdAt == null) {
          matchesDate = false;
        } else {
          final created = account.createdAt!;
          if (_fromDate != null && created.isBefore(_fromDate!)) matchesDate = false;
          if (_toDate != null && created.isAfter(_toDate!.add(const Duration(days: 1)))) matchesDate = false;
        }
      }

      return matchesSearch && matchesGroup && matchesType && matchesDate;
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
                      "Account Master",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Color(0xFF0F172A), letterSpacing: -0.5),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Manage customer and vendor account information",
                      style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddAccountPage()),
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

            // Filters Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    crossAxisAlignment: WrapCrossAlignment.end,
                    children: [
                      // Group Dropdown
                      SizedBox(
                        width: 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Group Name", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              value: _selectedGroup.isEmpty ? null : _selectedGroup,
                              hint: const Text("All Groups"),
                              items: groupProvider.accountGroups.map((g) {
                                return DropdownMenuItem(value: g.accountGroupName, child: Text(g.accountGroupName));
                              }).toList(),
                              onChanged: (val) => setState(() => _selectedGroup = val ?? ""),
                              decoration: _filterInputDecoration(),
                            ),
                          ],
                        ),
                      ),

                      // Search Text
                      SizedBox(
                        width: 250,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Search Name, Number", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _searchCtrl,
                              onChanged: (val) => setState(() => _searchTerm = val.toLowerCase()),
                              decoration: _filterInputDecoration(hint: "Search..."),
                            ),
                          ],
                        ),
                      ),

                      // Date Range
                      SizedBox(
                        width: 150,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Register From", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () async {
                                final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
                                if (date != null) setState(() => _fromDate = date);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE2E8F0)), borderRadius: BorderRadius.circular(8), color: const Color(0xFFF8FAFC)),
                                child: Row(children: [Text(_fromDate == null ? "Select Date" : DateFormat('dd/MM/yyyy').format(_fromDate!)), const Spacer(), const Icon(LucideIcons.calendar, size: 16)]),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Account Type
                      SizedBox(
                        width: 150,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Account Type", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              value: _selectedType.isEmpty ? null : _selectedType,
                              hint: const Text("All Types"),
                              items: const [
                                DropdownMenuItem(value: "Sale", child: Text("Sale")),
                                DropdownMenuItem(value: "Purchase", child: Text("Purchase")),
                                DropdownMenuItem(value: "Both", child: Text("Both")),
                              ],
                              onChanged: (val) => setState(() => _selectedType = val ?? ""),
                              decoration: _filterInputDecoration(),
                            ),
                          ],
                        ),
                      ),

                      // Action Buttons
                      ElevatedButton.icon(
                        onPressed: _handleReset,
                        icon: const Icon(LucideIcons.rotateCcw, size: 18),
                        label: const Text("Reset"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF1F5F9),
                          foregroundColor: const Color(0xFF475569),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Table View
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              width: double.infinity,
              child: provider.isLoading && provider.accounts.isEmpty
                  ? const Padding(padding: EdgeInsets.all(48.0), child: Center(child: CircularProgressIndicator()))
                  : filteredAccounts.isEmpty
                      ? const Padding(padding: EdgeInsets.all(48.0), child: Center(child: Text("No accounts found", style: TextStyle(color: Color(0xFF64748B), fontSize: 16))))
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Theme(
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
                                DataColumn(label: Text("Date")),
                                DataColumn(label: Text("Account Name")),
                                DataColumn(label: Text("Mobile No.")),
                                DataColumn(label: Text("GST No.")),
                                DataColumn(label: Text("Parent Group")),
                                DataColumn(label: Text("Station")),
                                DataColumn(label: Text("State")),
                                DataColumn(label: Text("Actions")),
                              ],
                              rows: List.generate(filteredAccounts.length, (index) {
                                final account = filteredAccounts[index];
                                return DataRow(cells: [
                                  DataCell(Text("${index + 1}")),
                                  DataCell(Text(account.createdAt != null ? DateFormat('dd/MM/yyyy').format(account.createdAt!) : "-")),
                                  DataCell(Text(account.name, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E293B)))),
                                  DataCell(Text(account.mobileNumber ?? "-")),
                                  DataCell(Text(account.gstin ?? "-")),
                                  DataCell(Text(account.groups.join(", "))),
                                  DataCell(Text(account.stations.join(", "))),
                                  DataCell(Text(account.state ?? "-")),
                                  DataCell(
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(LucideIcons.pencil, size: 18, color: Color(0xFF3B82F6)),
                                          onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => AddAccountPage(account: account)),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(LucideIcons.trash, size: 18, color: Color(0xFFEF4444)),
                                          onPressed: () => _handleDelete(account.id),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]);
                              }),
                            ),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _filterInputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF3B82F6))),
    );
  }
}
