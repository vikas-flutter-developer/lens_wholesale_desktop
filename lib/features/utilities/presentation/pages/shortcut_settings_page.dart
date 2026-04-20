import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:lens_wholesale_desktop/features/utilities/data/providers/utility_provider.dart';
import 'package:lens_wholesale_desktop/features/utilities/data/models/utility_models.dart';

class ShortcutSettingsPage extends StatefulWidget {
  const ShortcutSettingsPage({super.key});

  @override
  State<ShortcutSettingsPage> createState() => _ShortcutSettingsPageState();
}

class _ShortcutSettingsPageState extends State<ShortcutSettingsPage> {
  String _searchQuery = "";
  String _selectedModule = "All";
  final List<String> _modules = ["All", "Masters", "Transaction", "Sale", "Purchase", "Utilities", "Reports"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Consumer<UtilityProvider>(
        builder: (context, provider, _) {
          final filteredShortcuts = provider.keyBindings.where((s) {
            final matchesSearch = s.pageName.toLowerCase().contains(_searchQuery.toLowerCase()) || 
                                 s.shortcutKey.toLowerCase().contains(_searchQuery.toLowerCase());
            final matchesModule = _selectedModule == "All" || s.module == _selectedModule;
            return matchesSearch && matchesModule;
          }).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: AnimationLimiter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 375),
                  childAnimationBuilder: (w) => SlideAnimation(verticalOffset: 50.0, child: FadeInAnimation(child: w)),
                  children: [
                    _buildHeader(provider),
                    const SizedBox(height: 32),
                    _buildFilters(),
                    const SizedBox(height: 24),
                    _buildShortcutsTable(context, provider, filteredShortcuts),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(UtilityProvider provider) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(16)),
                child: const Icon(LucideIcons.keyboard, color: Color(0xFF2563EB), size: 28),
              ),
              const SizedBox(width: 20),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Shortcut Keys",
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF111827), letterSpacing: -1),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "Manage and customize global keyboard shortcuts",
                      style: TextStyle(fontSize: 14, color: Color(0xFF6B7280), fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        _buildHeaderAction(
          label: "Add New Shortcut",
          icon: LucideIcons.plus,
          color: const Color(0xFF2563EB),
          onTap: () => _showAddEditShortcutDialog(context, provider),
        ),
        const SizedBox(width: 12),
        _buildHeaderAction(
          label: "Reset to Default",
          icon: LucideIcons.rotateCcw,
          color: Colors.white,
          textColor: const Color(0xFF475569),
          borderColor: const Color(0xFFE2E8F0),
          onTap: () => _confirmReset(provider),
        ),
        const SizedBox(width: 12),
        _buildIconButton(LucideIcons.fileSpreadsheet, const Color(0xFF10B981), "Export to Excel", () => _exportToCSV(provider.keyBindings)),
        const SizedBox(width: 8),
        _buildIconButton(LucideIcons.printer, const Color(0xFF3B82F6), "Print", () => _printShortcuts(provider.keyBindings)),
      ],
    );
  }

  Widget _buildHeaderAction({required String label, required IconData icon, required Color color, Color? textColor, Color? borderColor, required VoidCallback onTap}) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor ?? Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: borderColor != null ? BorderSide(color: borderColor) : BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, Color color, String tooltip, VoidCallback onTap) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }

  Future<void> _exportToCSV(List<KeyBinding> shortcuts) async {
    try {
      final List<List<dynamic>> rows = [
        ["SR. NO.", "PAGE NAME", "MODULE", "SHORTCUT KEY", "DESCRIPTION", "STATUS"]
      ];
      for (int i = 0; i < shortcuts.length; i++) {
        final s = shortcuts[i];
        rows.add([i + 1, s.pageName, s.module, s.shortcutKey, s.description ?? "", s.status]);
      }
      String csv = const ListToCsvConverter().convert(rows);
      
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/KeyboardShortcuts_Export.csv');
      await file.writeAsString(csv);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Exported to Documents folder as CSV"), backgroundColor: const Color(0xFF10B981)),
        );
      }
    } catch (e) {
      debugPrint("Export failed: $e");
    }
  }

  Future<void> _printShortcuts(List<KeyBinding> shortcuts) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("System Keyboard Shortcuts", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(
                headers: ["SN", "PAGE", "MODULE", "KEY", "STATUS"],
                data: shortcuts.map((s) => [
                  shortcuts.indexOf(s) + 1,
                  s.pageName,
                  s.module ?? "",
                  s.shortcutKey,
                  s.status
                ]).toList(),
              ),
            ],
          );
        },
      ),
    );
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }


  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: "Search by page name or shortcut key...",
                prefixIcon: const Icon(LucideIcons.search, size: 20),
                filled: true,
                fillColor: const Color(0xFFF9FAFB),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
          const SizedBox(width: 24),
          const Text("Filter by Module:", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF64748B), fontSize: 13)),
          const SizedBox(width: 16),
          Wrap(
            spacing: 8,
            children: _modules.map((m) => ChoiceChip(
              label: Text(m),
              selected: _selectedModule == m,
              onSelected: (val) => setState(() => _selectedModule = m),
              selectedColor: const Color(0xFF2563EB),
              labelStyle: TextStyle(
                color: _selectedModule == m ? Colors.white : const Color(0xFF64748B),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              backgroundColor: const Color(0xFFF1F5F9),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              side: BorderSide.none,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              showCheckmark: false,
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildShortcutsTable(BuildContext context, UtilityProvider provider, List<KeyBinding> shortcuts) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          _buildTableHeader(),
          if (shortcuts.isEmpty)
            _buildEmptyState()
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: shortcuts.length,
              separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
              itemBuilder: (context, index) {
                final s = shortcuts[index];
                return _buildShortcutRow(context, provider, s, index + 1);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: Color(0xFFF9FAFB),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: const Row(
        children: [
          SizedBox(width: 60, child: Text("SR. NO.", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 1))),
          Expanded(flex: 3, child: Text("PAGE NAME", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 1))),
          Expanded(flex: 2, child: Text("MODULE", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 1))),
          Expanded(flex: 2, child: Text("SHORTCUT KEY", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 1))),
          Expanded(flex: 3, child: Text("DESCRIPTION", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 1))),
          SizedBox(width: 80, child: Center(child: Text("STATUS", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 1)))),
          SizedBox(width: 100, child: Center(child: Text("ACTION", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 1)))),
        ],
      ),
    );
  }

  Widget _buildShortcutRow(BuildContext context, UtilityProvider provider, KeyBinding s, int displayIndex) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          SizedBox(width: 60, child: Text(displayIndex.toString().padLeft(2, '0'), style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold))),
          Expanded(flex: 3, child: Text(s.pageName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B)))),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(6)),
              child: Text(s.module?.toUpperCase() ?? "GENERAL", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF2563EB), letterSpacing: 0.5)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2))],
                  ),
                  child: Text(s.shortcutKey, style: const TextStyle(fontFamily: 'monospace', fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ],
            ),
          ),
          Expanded(flex: 3, child: Text(s.description ?? "-", style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)))),
          SizedBox(
            width: 80,
            child: Center(
              child: IconButton(
                icon: Icon(
                  s.status == 'Enabled' ? LucideIcons.toggleRight : LucideIcons.toggleLeft,
                  size: 32,
                  color: s.status == 'Enabled' ? const Color(0xFF10B981) : const Color(0xFFCBD5E1),
                ),
                onPressed: () => provider.toggleKeyBindingStatus(s.id!, s),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(LucideIcons.pencil, size: 18, color: Color(0xFF3B82F6)),
                  onPressed: () => _showAddEditShortcutDialog(context, provider, s),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: "Edit",
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(LucideIcons.trash2, size: 18, color: Color(0xFFEF4444)),
                  onPressed: () => _confirmDelete(context, provider, s.id!),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: "Delete",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: const [
          Icon(LucideIcons.searchX, size: 48, color: Color(0xFFCBD5E1)),
          SizedBox(height: 16),
          Text("No shortcuts found", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
          Text("Try adjusting your search or filters", style: TextStyle(color: Color(0xFF94A3B8))),
        ],
      ),
    );
  }

  void _showAddEditShortcutDialog(BuildContext context, UtilityProvider provider, [KeyBinding? existing]) {
    String pageName = existing?.pageName ?? '';
    String shortcutKey = existing?.shortcutKey ?? '';
    String module = existing?.module ?? 'Masters';
    String description = existing?.description ?? '';
    String url = existing?.url ?? '';
    String routeSearch = pageName;
    bool showResults = false;

    final nameController = TextEditingController(text: pageName);
    final LayerLink layerLink = LayerLink();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final filtered = routeSearch.isEmpty 
            ? UtilityProvider.systemPages.take(5).toList()
            : UtilityProvider.systemPages.where((r) => 
                r['label']!.toLowerCase().contains(routeSearch.toLowerCase()) || 
                r['value']!.toLowerCase().contains(routeSearch.toLowerCase())
              ).take(5).toList();

          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Container(
              width: 500,
              padding: const EdgeInsets.all(24),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(existing == null ? "Add New Shortcut" : "Edit Shortcut", 
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                          IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(LucideIcons.x, color: Color(0xFF64748B))),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      CompositedTransformTarget(
                        link: layerLink,
                        child: TextField(
                          onChanged: (v) => setDialogState(() {
                            routeSearch = v;
                            pageName = v;
                            showResults = true;
                          }),
                          onTap: () => setDialogState(() => showResults = true),
                          controller: nameController,
                          decoration: InputDecoration(
                            hintText: "Search for a page...",
                            prefixIcon: const Icon(LucideIcons.search, size: 18),
                            filled: true,
                            fillColor: const Color(0xFFF9FAFB),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Module", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                                const SizedBox(height: 8),
                                  Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(12)),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _modules.contains(module) ? module : "Masters",
                                      isExpanded: true,
                                      hint: const Text("Select"),
                                      items: _modules.where((m) => m != "All").map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                                      onChanged: (v) => setDialogState(() => module = v!),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  const Text("Shortcut Key", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                                  const SizedBox(height: 8),
                                  TextField(
                                    onChanged: (v) => setDialogState(() => shortcutKey = v),
                                    controller: TextEditingController(text: shortcutKey),
                                    decoration: InputDecoration(
                                      hintText: "e.g. F2 or Alt+S",
                                      filled: true,
                                      fillColor: const Color(0xFFF9FAFB),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      const Text("Description", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                      const SizedBox(height: 8),
                      TextField(
                        onChanged: (v) => setDialogState(() => description = v),
                        controller: TextEditingController(text: description),
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText: "What does this shortcut do?",
                          filled: true,
                          fillColor: const Color(0xFFF9FAFB),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        ),
                      ),
                      const SizedBox(height: 32),

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                side: const BorderSide(color: Color(0xFFE2E8F0)),
                              ),
                              child: const Text("Cancel", style: TextStyle(color: Color(0xFF64748B))),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: () {
                                if (pageName.isEmpty || shortcutKey.isEmpty) return;
                                final newBinding = KeyBinding(
                                  id: existing?.id,
                                  pageName: pageName,
                                  shortcutKey: shortcutKey,
                                  module: module,
                                  description: description,
                                  url: url,
                                  status: existing?.status ?? 'Enabled',
                                );
                                if (existing == null) {
                                  provider.addKeyBinding(newBinding);
                                } else {
                                  provider.updateKeyBinding(existing.id!, newBinding);
                                }
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 0,
                              ),
                              child: Text(existing == null ? "Create Shortcut" : "Update Shortcut", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Floating Search Results - Matches React "absolute top-full"
                  if (showResults)
                    Positioned(
                      width: 436, // Matches inner width (500 - 64 padding)
                      child: CompositedTransformFollower(
                        link: layerLink,
                        showWhenUnlinked: false,
                        offset: const Offset(0, 52), // Below input field
                        child: Material(
                          elevation: 32,
                          shadowColor: Colors.black.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFF1F5F9))),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: filtered.map((r) => InkWell(
                                onTap: () => setDialogState(() {
                                  pageName = r['label']!;
                                  url = r['value']!;
                                  routeSearch = r['label']!;
                                  nameController.text = r['label']!;
                                  showResults = false;
                                }),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9)))),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(r['label']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B))),
                                      Text(r['value']!, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                                    ],
                                  ),
                                ),
                              )).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, UtilityProvider provider, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Shortcut?"),
        content: const Text("Are you sure you want to remove this keyboard shortcut? This action cannot be undone."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              provider.deleteKeyBinding(id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  void _confirmReset(UtilityProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Reset to Default?"),
        content: const Text("This will erase all your custom shortcuts and restore the system defaults. Proceed?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              provider.resetShortcutToDefaults();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB)),
            child: const Text("Reset Now"),
          ),
        ],
      ),
    );
  }
}
