import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:excel/excel.dart' as excel;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
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

  Future<void> _handleExportExcel() async {
    final provider = context.read<AccountGroupProvider>();
    final filteredGroups = provider.accountGroups.where((group) {
      return group.accountGroupName.toLowerCase().contains(_searchTerm);
    }).toList();

    if (filteredGroups.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No records to export")));
      return;
    }

    var ex = excel.Excel.createExcel();
    var sheet = ex['Account Groups'];
    ex.setDefaultSheet('Account Groups');

    sheet.appendRow([
      excel.TextCellValue("Sr. No."),
      excel.TextCellValue("Account Group Name"),
      excel.TextCellValue("Primary"),
      excel.TextCellValue("Ledger Group"),
    ]);

    for (var i = 0; i < filteredGroups.length; i++) {
      final group = filteredGroups[i];
      sheet.appendRow([
        excel.IntCellValue(i + 1),
        excel.TextCellValue(group.accountGroupName),
        excel.TextCellValue(group.primaryGroup),
        excel.TextCellValue(group.ledgerGroup),
      ]);
    }

    final directory = await getDownloadsDirectory();
    if (directory != null) {
      final file = File("${directory.path}/AccountGroupMaster.xlsx");
      await file.writeAsBytes(ex.encode()!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Excel exported to Downloads folder")));
      }
    }
  }

  Future<void> _handlePrint() async {
    final provider = context.read<AccountGroupProvider>();
    final filteredGroups = provider.accountGroups.where((group) {
      return group.accountGroupName.toLowerCase().contains(_searchTerm);
    }).toList();

    if (filteredGroups.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No records to print")));
      return;
    }

    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Account Group Master", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 24, color: PdfColors.blue900)),
                      pw.Text("Generated on ${DateTime.now().toLocal()}"),
                    ],
                  ),
                  pw.Text("Total Groups: ${filteredGroups.length}"),
                ],
              ),
            ),
            pw.TableHelper.fromTextArray(
              context: context,
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
              data: [
                ['Sr. No.', 'Account Group Name', 'Primary', 'Ledger Group'],
                ...filteredGroups.asMap().entries.map((e) => [
                      "${e.key + 1}",
                      e.value.accountGroupName,
                      e.value.primaryGroup,
                      e.value.ledgerGroup,
                    ]),
              ],
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AccountGroupProvider>();
    final filteredGroups = provider.accountGroups.where((group) {
      return group.accountGroupName.toLowerCase().contains(_searchTerm);
    }).toList();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF8FAFC), Color(0xFFEFF6FF)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(48.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                "Account Group Master",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              ),
              const SizedBox(height: 8),
              const Text(
                "Manage your account groups and ledger classifications",
                style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 32),

              // Controls Section
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Row(
                  children: [
                    // Search Bar
                    Expanded(
                      flex: 3,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: _searchCtrl,
                          onChanged: _onSearchChanged,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(LucideIcons.search, color: Color(0xFF94A3B8)),
                            hintText: "Search by account name...",
                            hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFFE2E8F0)), borderRadius: BorderRadius.circular(12)),
                            focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2), borderRadius: BorderRadius.circular(12)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Search Button
                    ElevatedButton.icon(
                      onPressed: () {}, // Filter is real-time
                      icon: const Icon(LucideIcons.search, size: 18),
                      label: const Text("Search"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Reset Button
                    ElevatedButton.icon(
                      onPressed: () {
                        _searchCtrl.clear();
                        _onSearchChanged("");
                      },
                      icon: const Icon(LucideIcons.rotateCcw, size: 18),
                      label: const Text("Reset"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF1F5F9),
                        foregroundColor: const Color(0xFF475569),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                    ),
                    const Spacer(),
                    // Add New Button
                    ElevatedButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddAccountGroupPage()),
                      ),
                      icon: const Icon(LucideIcons.plus, size: 18),
                      label: const Text("Add New"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF16A34A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Excel Button
                    IconButton.filled(
                      onPressed: _handleExportExcel,
                      icon: const Icon(LucideIcons.fileSpreadsheet, size: 20, color: Color(0xFF059669)),
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFFECFDF5),
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      tooltip: "Download Excel",
                    ),
                    const SizedBox(width: 8),
                    // Print Button
                    IconButton.filled(
                      onPressed: _handlePrint,
                      icon: const Icon(LucideIcons.printer, size: 20, color: Color(0xFF2563EB)),
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFFEFF6FF),
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      tooltip: "Print",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Table Section
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                child: provider.isLoading && provider.accountGroups.isEmpty
                    ? const Padding(padding: EdgeInsets.all(100.0), child: Center(child: CircularProgressIndicator()))
                    : filteredGroups.isEmpty
                        ? const Padding(padding: EdgeInsets.all(100.0), child: Center(child: Text("No accounts found", style: TextStyle(color: Color(0xFF64748B), fontSize: 18))))
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Table Header
                              Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(colors: [Color(0xFFEFF6FF), Color(0xFFF8FAFC)]),
                                  border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                                child: Row(
                                  children: const [
                                    SizedBox(width: 80, child: Text("Sr. No.", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF475569)))),
                                    Expanded(flex: 3, child: Text("Account Group Name", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF475569)))),
                                    SizedBox(width: 100, child: Text("Primary", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF475569)))),
                                    Expanded(flex: 2, child: Text("Ledger Group", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF475569)))),
                                    SizedBox(width: 80, child: Text("Edit", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF475569)))),
                                    SizedBox(width: 80, child: Text("Delete", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF475569)))),
                                  ],
                                ),
                              ),
                              // Table Rows
                              ...List.generate(filteredGroups.length, (index) {
                                final group = filteredGroups[index];
                                final isAlternate = index % 2 != 0;
                                return Container(
                                  color: isAlternate ? const Color(0xFFF8FAFC) : Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 80, child: Text("${index + 1}", textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w500))),
                                      Expanded(flex: 3, child: Text(group.accountGroupName, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E293B)))),
                                      SizedBox(
                                        width: 100,
                                        child: Center(
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: group.primaryGroup == "Y" ? const Color(0xFFDCFCE7) : const Color(0xFFF1F5F9),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Text(
                                              group.primaryGroup,
                                              style: TextStyle(color: group.primaryGroup == "Y" ? const Color(0xFF166534) : const Color(0xFF475569), fontWeight: FontWeight.bold, fontSize: 12),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(flex: 2, child: Text(group.ledgerGroup, style: const TextStyle(color: Color(0xFF475569)))),
                                      SizedBox(
                                        width: 80,
                                        child: IconButton(
                                          icon: const Icon(LucideIcons.pencil, size: 18, color: Color(0xFF2563EB)),
                                          onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => AddAccountGroupPage(accountGroup: group)),
                                          ),
                                          style: IconButton.styleFrom(
                                            hoverColor: const Color(0xFFEFF6FF),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 80,
                                        child: IconButton(
                                          icon: const Icon(LucideIcons.trash, size: 18, color: Color(0xFFEF4444)),
                                          onPressed: () => _handleDelete(group.id),
                                          style: IconButton.styleFrom(
                                            hoverColor: const Color(0xFFFEF2F2),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
              ),

              // Footer Info
              const SizedBox(height: 24),
              Center(
                child: Text(
                  "Showing ${filteredGroups.length} of ${provider.accountGroups.length} account groups",
                  style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
