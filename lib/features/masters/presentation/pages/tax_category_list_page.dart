import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../data/providers/tax_category_provider.dart';
import 'add_tax_category_page.dart';

class TaxCategoryListPage extends StatefulWidget {
  const TaxCategoryListPage({super.key});

  @override
  State<TaxCategoryListPage> createState() => _TaxCategoryListPageState();
}

class _TaxCategoryListPageState extends State<TaxCategoryListPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchTerm = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaxCategoryProvider>().fetchAllTaxCategories();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _handleDelete(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this tax category?"),
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
      final success = await context.read<TaxCategoryProvider>().deleteTaxCategory(id);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Tax category deleted successfully!")));
      } else if (mounted) {
        final error = context.read<TaxCategoryProvider>().error;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error ?? "Failed to delete")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaxCategoryProvider>();
    final filteredCategories = provider.taxCategories.where((cat) {
      return (cat.name).toLowerCase().contains(_searchTerm.toLowerCase());
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
                      "Tax Category Master",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Color(0xFF0F172A), letterSpacing: -0.5),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Manage CGST, SGST, and IGST tax layers",
                      style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddTaxCategoryPage()),
                  ),
                  icon: const Icon(LucideIcons.plus, size: 18, color: Colors.white),
                  label: const Text("Add New", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Controls
            Container(
              padding: const EdgeInsets.all(20),
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
                      onChanged: (val) => setState(() => _searchTerm = val),
                      decoration: InputDecoration(
                        hintText: "Search by Name...",
                        prefixIcon: const Icon(LucideIcons.search, size: 18),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () => setState(() { _searchCtrl.clear(); _searchTerm = ""; }),
                    icon: const Icon(LucideIcons.rotateCcw, size: 18),
                    label: const Text("Reset"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF1F5F9),
                      foregroundColor: const Color(0xFF475569),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Table
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              width: double.infinity,
              child: provider.isLoading && provider.taxCategories.isEmpty
                  ? const Padding(padding: EdgeInsets.all(48.0), child: Center(child: CircularProgressIndicator()))
                  : filteredCategories.isEmpty
                      ? const Padding(padding: EdgeInsets.all(48.0), child: Center(child: Text("No tax categories found", style: TextStyle(color: Color(0xFF64748B), fontSize: 16))))
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 64),
                            child: DataTable(
                              columnSpacing: 24,
                              horizontalMargin: 24,
                              showBottomBorder: true,
                              headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                              columns: const [
                                DataColumn(label: Text("#")),
                                DataColumn(label: Text("Name")),
                                DataColumn(label: Text("Type")),
                                DataColumn(label: Text("CGST %")),
                                DataColumn(label: Text("SGST %")),
                                DataColumn(label: Text("IGST %")),
                                DataColumn(label: Text("Default")),
                                DataColumn(label: Text("Remarks")),
                                DataColumn(label: Text("Actions")),
                              ],
                              rows: List.generate(filteredCategories.length, (index) {
                                final cat = filteredCategories[index];
                                return DataRow(cells: [
                                  DataCell(Text("${index + 1}")),
                                  DataCell(Text(cat.name, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E293B)))),
                                  DataCell(Text(cat.type.toUpperCase())),
                                  DataCell(Text("${cat.localTax1}%")),
                                  DataCell(Text("${cat.localTax2}%")),
                                  DataCell(Text("${cat.centralTax}%")),
                                  DataCell(
                                    cat.isDefault 
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(6)),
                                          child: const Text("Yes", style: TextStyle(color: Color(0xFF166534), fontSize: 12, fontWeight: FontWeight.bold)),
                                        )
                                      : const Text("No")
                                  ),
                                  DataCell(Text(cat.remarks ?? "-")),
                                  DataCell(
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(LucideIcons.pencil, size: 18, color: Color(0xFF3B82F6)),
                                          onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => AddTaxCategoryPage(taxCategory: cat)),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(LucideIcons.trash, size: 18, color: Color(0xFFEF4444)),
                                          onPressed: () => _handleDelete(cat.id),
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
}
