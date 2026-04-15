import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';

import '../../data/providers/inventory_report_provider.dart';
import '../../data/models/inventory_report_models.dart';
import '../../../masters/data/providers/inventory_providers.dart';
import '../../../masters/data/providers/account_provider.dart';

class StockReorderReportPage extends StatefulWidget {
  const StockReorderReportPage({super.key});

  @override
  State<StockReorderReportPage> createState() => _StockReorderReportPageState();
}

class _StockReorderReportPageState extends State<StockReorderReportPage> {
  final ScrollController _horizontalScroll = ScrollController();
  
  String _groupName = '';
  String _itemName = '';
  String _barcode = '';
  String _vendorName = '';
  String _searchType = 'All'; // All, Min, Max
  double? _setValue;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountProvider>().fetchAllAccounts();
      context.read<ItemGroupProvider>().fetchGroups();
      context.read<ItemMasterProvider>().fetchItems();
      _handleSearch(); // Auto-load on entry like React
    });
  }

  void _handleSearch() {
    final Map<String, dynamic> filters = {
      'groupName': _groupName,
      'itemName': _itemName,
      'barcode': _barcode,
      'vendorName': _vendorName,
      'searchType': _searchType,
      'setValue': _setValue,
    };
    context.read<InventoryReportProvider>().fetchReorderReport(filters);
  }

  void _handleReorder(StockReorderItem item) {
    // Navigate to Purchase Invoice with pre-filled item
    // Note: We use 'extra' to pass the item data
    context.push('/purchases/add-purchase-invoice', extra: item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Item Stock Reorder', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF3B82F6),
        foregroundColor: Colors.white,
        elevation: 4,
        actions: [
          IconButton(icon: const Icon(LucideIcons.printer), onPressed: () {}, tooltip: 'Print'),
          IconButton(icon: const Icon(LucideIcons.fileSpreadsheet), onPressed: () {}, tooltip: 'Export Excel'),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<InventoryReportProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              _buildFilterSection(),
              if (provider.isLoading)
                const Expanded(child: Center(child: CircularProgressIndicator()))
              else if (provider.reorderItems == null)
                const Expanded(child: Center(child: Text('Click Search to load reorder report')))
              else
                Expanded(child: _buildReportContent(provider.reorderItems!)),
              _buildFooter(provider.reorderItems?.length ?? 0),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          _filterItem('Item Group', _groupAutocomplete()),
          _filterItem('Item Name', _itemAutocomplete()),
          _filterItem('Barcode', _textField('Search Barcode', (v) => _barcode = v)),
          _filterItem('Search Type', _dropdown(_searchType, ['All', 'Min', 'Max'], (v) => setState(() => _searchType = v!))),
          _filterItem('Set Value', _numberField('0', (v) => _setValue = double.tryParse(v))),
          _filterItem('Vendor', _vendorAutocomplete()),

          ElevatedButton.icon(
            onPressed: _handleSearch,
            icon: const Icon(LucideIcons.search, size: 16),
            label: const Text('Search'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
          ),
          IconButton(
            onPressed: () => setState(() {
              _groupName = ''; _itemName = ''; _barcode = ''; _vendorName = ''; _searchType = 'All'; _setValue = null;
              _handleSearch();
            }),
            icon: const Icon(LucideIcons.rotateCcw),
            padding: const EdgeInsets.all(12),
          ),
        ],
      ),
    );
  }

  Widget _buildReportContent(List<StockReorderItem> items) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.packageSearch, size: 64, color: Colors.grey.shade200),
            const SizedBox(height: 16),
            const Text('No items found below alert level', style: TextStyle(color: Colors.blueGrey, fontStyle: FontStyle.italic)),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Scrollbar(
          controller: _horizontalScroll,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _horizontalScroll,
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 20,
              headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
              columns: const [
                DataColumn(label: Text('SNO')),
                DataColumn(label: Text('PRODUCT NAME')),
                DataColumn(label: Text('GROUP')),
                DataColumn(label: Text('UNIT')),
                DataColumn(label: Text('CRITICAL LVL')),
                DataColumn(label: Text('STOCK')),
                DataColumn(label: Text('MAX')),
                DataColumn(label: Text('MIN')),
                DataColumn(label: Text('REQ MAX')),
                DataColumn(label: Text('POWER')),
                DataColumn(label: Text('ACTION')),
              ],
              rows: List.generate(items.length, (index) {
                final item = items[index];
                final reqMax = (item.maxStock ?? 0) - item.stock;
                final lens = item.lensInfo;
                final power = lens != null ? "${lens.eye ?? ''} S:${lens.sph ?? ''} C:${lens.cyl ?? ''}" : '-';

                return DataRow(
                  cells: [
                    DataCell(Text((index + 1).toString())),
                    DataCell(Text(item.productName, style: const TextStyle(fontWeight: FontWeight.bold))),
                    DataCell(Text(item.groupName)),
                    DataCell(Text(item.unit)),
                    DataCell(Text(item.alertQty.toStringAsFixed(0), style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
                    DataCell(Text(item.stock.toStringAsFixed(0), style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold))),
                    DataCell(Text(item.maxStock?.toStringAsFixed(0) ?? '0')),
                    DataCell(Text(item.minStock?.toStringAsFixed(0) ?? '0')),
                    DataCell(Text(reqMax > 0 ? reqMax.toStringAsFixed(0) : '0')),
                    DataCell(Text(power, style: const TextStyle(fontSize: 10, color: Colors.grey))),
                    DataCell(
                      ElevatedButton.icon(
                        onPressed: () => _handleReorder(item),
                        icon: const Icon(LucideIcons.shoppingCart, size: 12),
                        label: const Text('Order', style: TextStyle(fontSize: 11)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade50,
                          foregroundColor: Colors.blue.shade700,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          side: BorderSide(color: Colors.blue.shade200),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      color: Colors.orange.shade50,
      child: Row(
        children: [
          const Icon(LucideIcons.alertTriangle, color: Colors.orange, size: 16),
          const SizedBox(width: 8),
          const Text('Showing items below critical stock levels', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.orange)),
          const Spacer(),
          Text('TOTAL ITEMS: $count', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.blueGrey)),
        ],
      ),
    );
  }

  // --- Helpers ---

  Widget _filterItem(String label, Widget child) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label.toUpperCase(), style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
      const SizedBox(height: 4),
      child,
    ]);
  }

  Widget _dropdown(String value, List<String> items, Function(String?) onChanged) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(border: Border.all(color: const Color(0xFFCBD5E1)), borderRadius: BorderRadius.circular(4)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 12)))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _groupAutocomplete() {
    return SizedBox(
      width: 150,
      child: Consumer<ItemGroupProvider>(
        builder: (context, provider, _) => Autocomplete<String>(
          optionsBuilder: (textEditingValue) => provider.groups.map((e) => e.groupName).where((e) => e.toLowerCase().contains(textEditingValue.text.toLowerCase())),
          onSelected: (v) => _groupName = v,
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) => TextField(controller: controller, focusNode: focusNode, decoration: _inputDeco('Group'), style: const TextStyle(fontSize: 12)),
        ),
      ),
    );
  }

  Widget _itemAutocomplete() {
    return SizedBox(
      width: 180,
      child: Consumer<ItemMasterProvider>(
        builder: (context, provider, _) => Autocomplete<String>(
          optionsBuilder: (textEditingValue) => provider.items.map((e) => e.itemName).where((e) => e.toLowerCase().contains(textEditingValue.text.toLowerCase())),
          onSelected: (v) => _itemName = v,
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) => TextField(controller: controller, focusNode: focusNode, decoration: _inputDeco('Item'), style: const TextStyle(fontSize: 12)),
        ),
      ),
    );
  }

  Widget _vendorAutocomplete() {
    return SizedBox(
      width: 180,
      child: Consumer<AccountProvider>(
        builder: (context, provider, _) => Autocomplete<String>(
          optionsBuilder: (textEditingValue) => provider.accounts.map((e) => e.name).where((e) => e.toLowerCase().contains(textEditingValue.text.toLowerCase())),
          onSelected: (v) => _vendorName = v,
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) => TextField(controller: controller, focusNode: focusNode, decoration: _inputDeco('Vendor'), style: const TextStyle(fontSize: 12)),
        ),
      ),
    );
  }

  Widget _textField(String hint, Function(String) onChanged) => SizedBox(width: 120, child: TextField(decoration: _inputDeco(hint), style: const TextStyle(fontSize: 12), onChanged: onChanged));
  Widget _numberField(String hint, Function(String) onChanged) => SizedBox(width: 60, child: TextField(keyboardType: TextInputType.number, decoration: _inputDeco(hint), style: const TextStyle(fontSize: 12), onChanged: onChanged));

  InputDecoration _inputDeco(String hint) {
    return InputDecoration(
      hintText: hint, isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      border: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFFCBD5E1)), borderRadius: BorderRadius.circular(4)),
      enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFFCBD5E1)), borderRadius: BorderRadius.circular(4)),
    );
  }
}
