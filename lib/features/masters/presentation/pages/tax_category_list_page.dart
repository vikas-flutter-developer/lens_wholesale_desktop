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
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Category deleted successfully")));
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
        padding: const EdgeInsets.all(24.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Title
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: const Text(
                  "Tax Category",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                ),
              ),
              const Divider(height: 1, color: Color(0xFFE2E8F0)),

              // Top Controls
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      child: TextField(
                        controller: _searchCtrl,
                        onChanged: (val) => setState(() => _searchTerm = val),
                        style: const TextStyle(fontSize: 13),
                        decoration: InputDecoration(
                          hintText: "Search by Name",
                          hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF2563EB))),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => setState(() { _searchCtrl.clear(); _searchTerm = ""; }),
                      icon: const Icon(LucideIcons.rotateCcw, size: 16),
                      label: const Text("Reset", style: TextStyle(fontSize: 13)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF1F5F9),
                        foregroundColor: const Color(0xFF475569),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddTaxCategoryPage()),
                      ),
                      icon: const Icon(LucideIcons.plus, size: 16),
                      label: const Text("Add Category", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                    ),
                    _buildGrayIconBtn(LucideIcons.fileSpreadsheet),
                    _buildGrayIconBtn(LucideIcons.printer),
                  ],
                ),
              ),

              // Table
              provider.isLoading && provider.taxCategories.isEmpty
                  ? const Padding(padding: EdgeInsets.all(48.0), child: Center(child: CircularProgressIndicator()))
                  : filteredCategories.isEmpty
                      ? const Padding(padding: EdgeInsets.all(48.0), child: Center(child: Text("No categories found", style: TextStyle(color: Color(0xFF64748B), fontStyle: FontStyle.italic))))
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 48),
                            child: DataTable(
                              columnSpacing: 24,
                              horizontalMargin: 20,
                              showBottomBorder: true,
                              headingRowHeight: 45,
                              dataRowHeight: 45,
                              headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                              columns: const [
                                DataColumn(label: Text("#", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF475569)))),
                                DataColumn(label: Text("Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF475569)))),
                                DataColumn(label: Text("Type", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF475569)))),
                                DataColumn(label: Text("CGST", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF475569)))),
                                DataColumn(label: Text("SGST", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF475569)))),
                                DataColumn(label: Text("IGST", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF475569)))),
                                DataColumn(label: Text("CESS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF475569)))),
                                DataColumn(label: Text("Tax on MRP", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF475569)))),
                                DataColumn(label: Text("Default", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF475569)))),
                                DataColumn(label: Text("Remarks", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF475569)))),
                                DataColumn(label: Text("Actions", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF475569)))),
                              ],
                              rows: List.generate(filteredCategories.length, (index) {
                                final cat = filteredCategories[index];
                                return DataRow(
                                  onSelectChanged: (_) {}, // To enable hover color
                                  cells: [
                                  DataCell(Text("${index + 1}", style: const TextStyle(fontSize: 13))),
                                  DataCell(Text(cat.name, style: const TextStyle(fontSize: 13))),
                                  DataCell(Text(cat.type, style: const TextStyle(fontSize: 13))),
                                  DataCell(Text("${cat.localTax1}", style: const TextStyle(fontSize: 13))),
                                  DataCell(Text("${cat.localTax2}", style: const TextStyle(fontSize: 13))),
                                  DataCell(Text("${cat.centralTax}", style: const TextStyle(fontSize: 13))),
                                  DataCell(Text("${cat.cessTax}", style: const TextStyle(fontSize: 13))),
                                  DataCell(Text(cat.taxOnMRP.toLowerCase() == "yes" ? "Yes" : "No", style: const TextStyle(fontSize: 13))),
                                  DataCell(Text(cat.isDefault ? "Yes" : "No", style: const TextStyle(fontSize: 13))),
                                  DataCell(Text(cat.remarks ?? "", style: const TextStyle(fontSize: 13))),
                                  DataCell(
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(LucideIcons.pencil, size: 16, color: Color(0xFF2563EB)),
                                          onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => AddTaxCategoryPage(taxCategory: cat)),
                                          ),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                        ),
                                        const SizedBox(width: 8),
                                        IconButton(
                                          icon: const Icon(LucideIcons.trash, size: 16, color: Color(0xFFEF4444)),
                                          onPressed: () => _handleDelete(cat.id),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]);
                              }),
                            ),
                          ),
                        ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGrayIconBtn(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: const Color(0xFF475569), size: 18),
    );
  }
}
