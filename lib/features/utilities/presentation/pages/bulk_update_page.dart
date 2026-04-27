import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:excel/excel.dart' as exc;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import '../../../masters/data/providers/inventory_providers.dart';
import '../../../masters/data/models/item_master_model.dart';
import '../../data/providers/utility_provider.dart';

class ProductListForUpdatePage extends StatefulWidget {
  const ProductListForUpdatePage({super.key});

  @override
  State<ProductListForUpdatePage> createState() => _ProductListForUpdatePageState();
}

class _ProductListForUpdatePageState extends State<ProductListForUpdatePage> {
  final ScrollController _horizontalScrollController = ScrollController();
  final TextEditingController _nameFilterController = TextEditingController();
  // Using a separate controller for Autocomplete to allow programmatic clearing
  final TextEditingController _autocompleteController = TextEditingController();
  
  String _selectedGroup = 'ALL GROUPS';
  final Map<String, Map<String, dynamic>> _editData = {}; // itemId -> {field: value}
  final Set<String> _selectedIds = {};
  bool _isOperationLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _nameFilterController.dispose();
    _autocompleteController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    await context.read<ItemGroupProvider>().fetchGroups();
    await context.read<ItemMasterProvider>().fetchItems();
  }

  List<ItemMasterModel> _getFilteredItems(List<ItemMasterModel> allItems) {
    return allItems.where((item) {
      final matchesGroup = _selectedGroup == 'ALL GROUPS' || item.groupName == _selectedGroup;
      final matchesName = _nameFilterController.text.isEmpty || 
          item.itemName.toLowerCase().contains(_nameFilterController.text.toLowerCase());
      return matchesGroup && matchesName;
    }).toList();
  }

  void _handleInputChange(String itemId, String field, dynamic value) {
    setState(() {
      if (!_editData.containsKey(itemId)) {
        _editData[itemId] = {};
      }
      _editData[itemId]![field] = value;
      _selectedIds.add(itemId);
    });
  }

  String _formatPrice(dynamic value) {
    if (value == null) return '0';
    final val = double.tryParse(value.toString()) ?? 0.0;
    return val % 1 == 0 ? val.toInt().toString() : val.toString();
  }

  String _getEffectiveValue(ItemMasterModel item, String field) {
    if (_editData.containsKey(item.id) && _editData[item.id]!.containsKey(field)) {
      return _editData[item.id]![field].toString();
    }
    switch (field) {
      case 'itemName': return item.itemName;
      case 'purchasePrice': return _formatPrice(item.purchasePrice);
      case 'salePrice': return _formatPrice(item.salePrice);
      case 'mrpPrice': return _formatPrice(item.mrpPrice);
      case 'gst': return _formatPrice(item.gst);
      default: return '';
    }
  }

  Future<void> _handleCopyGstToAll(List<ItemMasterModel> visibleItems) async {
    if (visibleItems.isEmpty) return;
    
    // Get GST from the first visible item
    final firstItem = visibleItems[0];
    final sourceGstStr = _getEffectiveValue(firstItem, 'gst');
    final gstValue = double.tryParse(sourceGstStr) ?? 0.0;

    final List<Map<String, dynamic>> itemsToUpdate = [];
    
    setState(() {
      for (var item in visibleItems) {
        // 1. Update local edit state (merge like React)
        if (!_editData.containsKey(item.id)) {
          _editData[item.id!] = {};
        }
        _editData[item.id!]!['gst'] = gstValue;

        // 2. Build partial update list for backend
        if ((item.gst ?? 0.0) != gstValue) {
          itemsToUpdate.add({
            'id': item.id,
            'gst': gstValue,
          });
        }
      }
    });

    if (itemsToUpdate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("All visible items already have GST $gstValue%"),
        backgroundColor: Colors.blue,
      ));
      return;
    }

    setState(() => _isOperationLoading = true);
    try {
      final provider = context.read<ItemMasterProvider>();
      await provider.bulkUpdateItems(itemsToUpdate);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("GST $gstValue% applied to ${itemsToUpdate.length} items"),
          backgroundColor: Colors.green,
        ));
      }
      // Re-fetch to sync master list, but keep local edit state for other unsaved changes
      await _fetchData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Failed to copy GST: $e"),
          backgroundColor: Colors.red,
        ));
      }
    } finally {
      setState(() => _isOperationLoading = false);
    }
  }

  Future<void> _handleUpdateBulk() async {
    if (_selectedIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No items selected for update")));
      return;
    }

    setState(() => _isOperationLoading = true);
    try {
      final provider = context.read<ItemMasterProvider>();
      final List<ItemMasterModel> itemsToUpdate = [];

      for (var id in _selectedIds) {
        final originalItem = provider.items.firstWhere((i) => i.id == id);
        final updates = _editData[id] ?? {};
        
        itemsToUpdate.add(originalItem.copyWith(
          itemName: updates['itemName'] ?? originalItem.itemName,
          purchasePrice: double.tryParse(updates['purchasePrice']?.toString() ?? '') ?? originalItem.purchasePrice,
          salePrice: double.tryParse(updates['salePrice']?.toString() ?? '') ?? originalItem.salePrice,
          mrpPrice: double.tryParse(updates['mrpPrice']?.toString() ?? '') ?? originalItem.mrpPrice,
          gst: double.tryParse(updates['gst']?.toString() ?? '') ?? originalItem.gst,
        ));
      }

      await provider.bulkUpdateItems(itemsToUpdate);
      setState(() {
        _editData.clear();
        _selectedIds.clear();
      });
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Items updated successfully"), backgroundColor: Colors.green));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
    } finally {
      setState(() => _isOperationLoading = false);
    }
  }

  Future<void> _handleDeleteBulk() async {
    if (_selectedIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No items selected for deletion")));
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: Text("Are you sure you want to delete ${_selectedIds.length} items?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white), child: const Text("Delete")),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isOperationLoading = true);
    try {
      final provider = context.read<ItemMasterProvider>();
      for (var id in _selectedIds) {
        await provider.deleteItem(id);
      }
      setState(() {
        _editData.clear();
        _selectedIds.clear();
      });
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Items deleted successfully"), backgroundColor: Colors.green));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
    } finally {
      setState(() => _isOperationLoading = false);
    }
  }

  Future<void> _handleSyncAll() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Sync All Lenses"),
        content: const Text("This will synchronize all lens prices from the Lens Rate Master to the item list. Continue?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text("Sync Now")),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isOperationLoading = true);
    final success = await context.read<ItemMasterProvider>().syncAllLenses();
    setState(() => _isOperationLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(success ? "Lenses synchronized successfully" : "Failed to synchronize lenses"),
        backgroundColor: success ? Colors.green : Colors.red,
      ));
    }
  }

  Future<void> _exportToExcel(List<ItemMasterModel> items) async {
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No items to export")));
      return;
    }

    setState(() => _isOperationLoading = true);
    try {
      final excel = exc.Excel.createExcel();
      final sheet = excel['Product List'];
      excel.delete('Sheet1');

      // Add Headers
      sheet.appendRow([
        exc.TextCellValue('SN'),
        exc.TextCellValue('Item Name'),
        exc.TextCellValue('Group Name'),
        exc.TextCellValue('Purchase Price'),
        exc.TextCellValue('Sale Price'),
        exc.TextCellValue('MRP Price'),
      ]);

      // Add Data
      for (int i = 0; i < items.length; i++) {
        final item = items[i];
        sheet.appendRow([
          exc.IntCellValue(i + 1),
          exc.TextCellValue(item.itemName),
          exc.TextCellValue(item.groupName),
          exc.DoubleCellValue(item.purchasePrice ?? 0),
          exc.DoubleCellValue(item.salePrice ?? 0),
          exc.DoubleCellValue(item.mrpPrice ?? 0),
        ]);
      }

      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'ProductList_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.xlsx';
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(excel.save()!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Excel exported to: ${file.path}'),
          backgroundColor: Colors.green,
          action: SnackBarAction(label: 'Open', onPressed: () => url_launcher.launchUrl(Uri.file(file.path))),
        ));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Export failed: $e'), backgroundColor: Colors.red));
    } finally {
      setState(() => _isOperationLoading = false);
    }
  }

  Future<void> _printList(List<ItemMasterModel> items) async {
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No items to print")));
      return;
    }

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async {
        final pdf = pw.Document();
        pdf.addPage(
          pw.MultiPage(
            pageFormat: format,
            build: (context) => [
              pw.Header(level: 0, child: pw.Text('Product List for Update', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18))),
              pw.SizedBox(height: 10),
              pw.TableHelper.fromTextArray(
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headers: ['SN', 'Item Name', 'Group', 'Pur Price', 'Sale Price', 'MRP'],
                data: items.asMap().entries.map((e) => [
                  (e.key + 1).toString(),
                  e.value.itemName,
                  e.value.groupName,
                  _formatPrice(e.value.purchasePrice),
                  _formatPrice(e.value.salePrice),
                  _formatPrice(e.value.mrpPrice),
                ]).toList(),
              ),
            ],
          ),
        );
        return pdf.save();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: Column(
        children: [
          _buildHeaderBar(),
          Expanded(
            child: Consumer2<ItemMasterProvider, ItemGroupProvider>(
              builder: (context, itemProv, groupProv, _) {
                final filteredItems = _getFilteredItems(itemProv.items);
                return Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      _buildFilterSection(groupProv.groups, filteredItems),
                      const SizedBox(height: 12),
                      Expanded(child: _buildTableSection(filteredItems, itemProv.isLoading)),
                      const SizedBox(height: 12),
                      _buildBottomActions(),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFF1E40AF),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Update/Delete Item In Bulk', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          Text('SADGURU OPTICALS (C0004)', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildFilterSection(List<dynamic> groups, List<ItemMasterModel> filteredItems) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 0.5),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('PRODUCT GROUP', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF059669))),
                const SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  value: _selectedGroup,
                  isDense: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 0.5)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 0.5)),
                  ),
                  items: ['ALL GROUPS', ...groups.map((g) => g.groupName.toString())]
                      .map<DropdownMenuItem<String>>((e) => DropdownMenuItem<String>(
                          value: e,
                          child: Text(e, style: const TextStyle(fontSize: 12))))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedGroup = v!),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('PRODUCT NAME', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF059669))),
                const SizedBox(height: 4),
                Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    final names = context.read<ItemMasterProvider>().items.map((i) => i.itemName).toSet().toList()..sort();
                    if (textEditingValue.text.isEmpty) return names;
                    return names.where((String option) => option.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                  },
                  onSelected: (String selection) {
                    _nameFilterController.text = selection;
                    setState(() {});
                  },
                  fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                    // Sync internal autocomplete controller with our local tracking controller
                    if (_autocompleteController != controller) {
                      // Note: We don't replace the controller, we just ensure value parity if needed
                    }
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      style: const TextStyle(fontSize: 12),
                      onChanged: (v) {
                        _nameFilterController.text = v;
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 0.5)),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 0.5)),
                        hintText: 'Search product...',
                        hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
                        suffixIcon: const Icon(Icons.arrow_drop_down, size: 20, color: Colors.grey),
                      ),
                    );
                  },
                  optionsViewBuilder: (context, onSelected, options) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 4.0,
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          width: 300,
                          constraints: const BoxConstraints(maxHeight: 300),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0xFFE2E8F0), width: 0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: options.length,
                            itemBuilder: (BuildContext context, int index) {
                              final String option = options.elementAt(index);
                              return InkWell(
                                onTap: () => onSelected(option),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.1), width: 0.5)),
                                  ),
                                  child: Text(option, style: const TextStyle(fontSize: 12, color: Color(0xFF334155))),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _actionButton(LucideIcons.search, 'Search', const Color(0xFF1D4ED8), _fetchData),
          const SizedBox(width: 6),
          _actionButton(LucideIcons.save, 'Sync All Lenses', const Color(0xFF059669), _handleSyncAll),
          const SizedBox(width: 6),
          _iconButton(LucideIcons.rotateCcw, Colors.grey.shade400, () {
            setState(() {
              _selectedGroup = 'ALL GROUPS';
              _nameFilterController.clear();
              // Reset the Autocomplete would require a GlobalKey or re-rendering
              // For now, we clear the filter which is the most important
              _editData.clear();
              _selectedIds.clear();
            });
            // Re-fetch to clear filters
            _fetchData();
          }),
          const SizedBox(width: 6),
          _iconButton(LucideIcons.fileSpreadsheet, const Color(0xFF059669), () => _exportToExcel(filteredItems)),
          const SizedBox(width: 6),
          _iconButton(LucideIcons.printer, Colors.grey.shade600, () => _printList(filteredItems)),
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, String label, Color color, VoidCallback onTap) {
    return SizedBox(
      height: 38,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 14),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
    );
  }

  Widget _iconButton(IconData icon, Color color, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE2E8F0), width: 0.5), borderRadius: BorderRadius.circular(4), color: Colors.white),
      child: IconButton(
        icon: Icon(icon, size: 16, color: color),
        onPressed: onTap,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
      ),
    );
  }

  Widget _buildTableSection(List<ItemMasterModel> items, bool isLoading) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 0.5),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    controller: _horizontalScrollController,
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: constraints.maxWidth),
                      child: SingleChildScrollView(
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(const Color(0xFFF1F5F9)),
                          dataRowMinHeight: 44,
                          dataRowMaxHeight: 44,
                          headingRowHeight: 44,
                          columnSpacing: 24,
                          horizontalMargin: 12,
                          columns: [
                            const DataColumn(label: Text('SN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B)))),
                            const DataColumn(label: Text('ITEM NAME', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B)))),
                            const DataColumn(label: Text('ITEM GROUP', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B)))),
                             DataColumn(
                               label: Row(
                                 children: [
                                   const Text('GST (%)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                                   const SizedBox(width: 4),
                                   InkWell(
                                     onTap: () => _handleCopyGstToAll(items),
                                     child: Tooltip(
                                       message: "Copy first row GST to all visible rows",
                                       child: const Icon(LucideIcons.copy, size: 12, color: Colors.blue),
                                     ),
                                   ),
                                 ],
                               ),
                             ),
                             const DataColumn(label: Text('PUR PRICE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B)))),
                             const DataColumn(label: Text('SALE PRICE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B)))),
                             const DataColumn(label: Text('MRP PRICE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B)))),
                            DataColumn(
                              label: SizedBox(
                                width: 24,
                                child: Checkbox(
                                  visualDensity: VisualDensity.compact,
                                  value: items.isNotEmpty && _selectedIds.length == items.length,
                                  onChanged: (v) {
                                    setState(() {
                                      if (v == true) {
                                        _selectedIds.addAll(items.map((e) => e.id!));
                                      } else {
                                        _selectedIds.clear();
                                      }
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                          rows: items.asMap().entries.map((entry) {
                            final idx = entry.key;
                            final item = entry.value;
                            final isSelected = _selectedIds.contains(item.id);
                            return DataRow(
                              color: WidgetStateProperty.resolveWith((states) => isSelected ? const Color(0xFFEFF6FF) : null),
                              cells: [
                                DataCell(Text('${idx + 1}.', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500))),
                                DataCell(
                                  Container(
                                    width: 280,
                                    margin: const EdgeInsets.symmetric(vertical: 6),
                                    child: TextField(
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                                      controller: TextEditingController(text: _getEffectiveValue(item, 'itemName'))..selection = TextSelection.collapsed(offset: _getEffectiveValue(item, 'itemName').toString().length),
                                      onChanged: (v) => _handleInputChange(item.id!, 'itemName', v),
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 1)),
                                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 0.5)),
                                        isDense: true,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(Text(item.groupName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569)))),
                                _priceCell(item, 'gst'),
                                _priceCell(item, 'purchasePrice'),
                                _priceCell(item, 'salePrice'),
                                _priceCell(item, 'mrpPrice'),
                                DataCell(
                                  SizedBox(
                                    width: 24,
                                    child: Checkbox(
                                      visualDensity: VisualDensity.compact,
                                      value: isSelected,
                                      onChanged: (v) {
                                        setState(() {
                                          if (v == true) {
                                            _selectedIds.add(item.id!);
                                          } else {
                                            _selectedIds.remove(item.id!);
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (isLoading || _isOperationLoading)
              const LinearProgressIndicator(minHeight: 2, backgroundColor: Color(0xFFEFF6FF), valueColor: AlwaysStoppedAnimation(Color(0xFF1E40AF))),
          ],
        ),
      ),
    );
  }

  DataCell _priceCell(ItemMasterModel item, String field) {
    return DataCell(
      Container(
        width: 80,
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: TextField(
          textAlign: TextAlign.right,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          keyboardType: TextInputType.number,
          controller: TextEditingController(text: _getEffectiveValue(item, field))..selection = TextSelection.collapsed(offset: _getEffectiveValue(item, field).toString().length),
          onChanged: (v) => _handleInputChange(item.id!, field, v),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 1)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 0.5)),
            isDense: true,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
            child: ElevatedButton.icon(
              onPressed: _handleUpdateBulk,
              icon: const Icon(LucideIcons.save, size: 16),
              label: const Text('Update Item'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF59E0B),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                elevation: 2,
              ),
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            height: 40,
            child: ElevatedButton.icon(
              onPressed: _handleDeleteBulk,
              icon: const Icon(LucideIcons.trash2, size: 16),
              label: const Text('Delete'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                elevation: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
