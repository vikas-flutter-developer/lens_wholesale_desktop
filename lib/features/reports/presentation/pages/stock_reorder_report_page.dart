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
  String _searchType = 'All'; // Default is 'All' (labeled 'None' in UI) to match React
  double? _setValue;

  final Map<String, bool> _visibleCols = {
    'sno': true,
    'productName': true,
    'groupName': true,
    'unit': true,
    'criticalLevel': true,
    'stock': true,
    'maxQty': true,
    'minQty': true,
    'reqMaxQty': true,
    'reqMinQty': true,
    'minReorder': true,
    'sph': true,
    'cyl': true,
    'eye': true,
    'action': true,
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountProvider>().fetchAllAccounts();
      context.read<ItemGroupProvider>().fetchGroups();
      context.read<ItemMasterProvider>().fetchItems();
      _handleSearch();
    });
  }

  void _handleSearch() {
    final Map<String, dynamic> filters = {
      'groupName': _groupName.trim(),
      'itemName': _itemName.trim(),
      'barcode': _barcode.trim(),
      'vendorName': _vendorName.trim(),
      'searchType': _searchType,
      'setValue': _setValue?.toString() ?? '',
    };

    context.read<InventoryReportProvider>().fetchReorderReport(filters);
  }

  void _handleReset() {
    setState(() {
      _groupName = '';
      _itemName = '';
      _barcode = '';
      _vendorName = '';
      _searchType = 'All';
      _setValue = null;
    });
    _handleSearch();
  }

  void _showColumnVisibilityDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(
                'Column Visibility',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SizedBox(
                width: 300,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setDialogState(() {
                                  _visibleCols.updateAll((key, value) => true);
                                });
                                setState(() {});
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Show All'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setDialogState(() {
                                  _visibleCols.updateAll((key, value) => false);
                                });
                                setState(() {});
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Hide All'),
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      ..._visibleCols.keys.map((col) {
                        return CheckboxListTile(
                          title: Text(
                            _getColumnLabel(col),
                            style: const TextStyle(fontSize: 13),
                          ),
                          value: _visibleCols[col],
                          onChanged: (val) {
                            setDialogState(
                              () => _visibleCols[col] = val ?? false,
                            );
                            setState(() {});
                          },
                          dense: true,
                          controlAffinity: ListTileControlAffinity.leading,
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _getColumnLabel(String col) {
    switch (col) {
      case 'sno':
        return 'S.No';
      case 'productName':
        return 'Product Name';
      case 'groupName':
        return 'Group Name';
      case 'unit':
        return 'Unit';
      case 'criticalLevel':
        return 'Critical Lvl';
      case 'stock':
        return 'Stock';
      case 'maxQty':
        return 'Max Qty';
      case 'minQty':
        return 'Min Qty';
      case 'reqMaxQty':
        return 'Req Max Qty';
      case 'reqMinQty':
        return 'Req Min Qty';
      case 'minReorder':
        return 'Min. Reorder';
      case 'sph':
        return 'SPH';
      case 'cyl':
        return 'CYL';
      case 'eye':
        return 'EYE';
      case 'action':
        return 'Action';
      default:
        return col;
    }
  }

  void _handleReorder(StockReorderItem item) {
    // Navigate to Purchase Invoice with pre-filled item
    context.push('/purchases/add-purchase-invoice', extra: item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Column(
        children: [
          _buildHeader(),
          _buildFilters(),
          Expanded(
            child: Consumer<InventoryReportProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                final items = provider.reorderItems ?? [];
                return Column(
                  children: [
                    _buildTableControls(),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: items.isEmpty
                            ? _buildEmptyState(provider)
                            : _buildTable(items),
                      ),
                    ),
                    _buildFooter(items),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF3B82F6),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.packageSearch, color: Colors.white, size: 22),
          const SizedBox(width: 12),
          const Text(
            'Item Stock Reorder',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(LucideIcons.printer, color: Colors.white),
            onPressed: () {},
            tooltip: 'Print',
          ),
          IconButton(
            icon: const Icon(LucideIcons.fileText, color: Colors.white),
            onPressed: () {},
            tooltip: 'Excel',
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          _filterItem('Item Group', _groupAutocomplete()),
          _filterItem('Item Name', _itemAutocomplete()),
          _filterItem(
            'Barcode',
            _textField('Search Barcode', (v) => _barcode = v),
          ),
          _filterItem(
            'Search Type',
            _dropdown(
              _searchType,
              ['All', 'Min', 'Max'],
              (v) => setState(() => _searchType = v!),
              labels: {'All': 'None', 'Min': 'Min Qty', 'Max': 'Max Qty'},
            ),
          ),
          _filterItem(
            'Set Value',
            _numberField('0', (v) => _setValue = double.tryParse(v)),
          ),
          _filterItem('Vendor Name', _vendorAutocomplete()),

          ElevatedButton.icon(
            onPressed: _handleSearch,
            icon: const Icon(LucideIcons.search, size: 16),
            label: const Text(
              'Search',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF16A34A),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          IconButton(
            onPressed: _handleReset,
            icon: const Icon(LucideIcons.rotateCcw),
            padding: const EdgeInsets.all(12),
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFFE2E8F0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableControls() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          OutlinedButton.icon(
            onPressed: _showColumnVisibilityDialog,
            icon: const Icon(LucideIcons.filter, size: 16),
            label: const Text(
              'Column Visibility',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF334155),
              side: const BorderSide(color: Color(0xFFE2E8F0)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              backgroundColor: const Color(0xFFF8FAFC),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(InventoryReportProvider provider) {
    if (provider.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(LucideIcons.alertCircle, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Data Processing Error',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  provider.error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _handleSearch,
                icon: const Icon(LucideIcons.rotateCcw, size: 16),
                label: const Text('Retry Search'),
              ),
            ],
          ),
        ),
      );
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.packageSearch,
            size: 64,
            color: Colors.grey.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          const Text(
            'No items found matching the current filters',
            style: TextStyle(
              color: Color(0xFF64748B),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Note: Only items where Stock ≤ Critical Level are shown here.',
            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
          ),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: () {
              _handleReset();
            },
            child: const Text('Reset All Filters'),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(List<StockReorderItem> items) {
    return Scrollbar(
      controller: _horizontalScroll,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _horizontalScroll,
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 24,
          headingRowHeight: 42,
          dataRowMinHeight: 32,
          dataRowMaxHeight: 48,
          headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
          border: const TableBorder(
            verticalInside: BorderSide(color: Color(0xFFE2E8F0), width: 1),
            horizontalInside: BorderSide(color: Color(0xFFF1F5F9), width: 1),
            bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
          ),
          columns: [
            if (_visibleCols['sno']!)
              const DataColumn(label: Text('SNO', style: _headerStyle)),
            if (_visibleCols['productName']!)
              const DataColumn(
                label: Text('PRODUCT NAME', style: _headerStyle),
              ),
            if (_visibleCols['groupName']!)
              const DataColumn(label: Text('GROUP NAME', style: _headerStyle)),
            if (_visibleCols['unit']!)
              const DataColumn(label: Text('UNIT', style: _headerStyle)),
            if (_visibleCols['criticalLevel']!)
              DataColumn(
                label: Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'CRITICAL LVL',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 10,
                      color: Color(0xFFDC2626),
                    ),
                  ),
                ),
              ),
            if (_visibleCols['stock']!)
              const DataColumn(label: Text('STOCK', style: _headerStyle)),
            if (_visibleCols['maxQty']!)
              const DataColumn(label: Text('MAX QTY', style: _headerStyle)),
            if (_visibleCols['minQty']!)
              const DataColumn(label: Text('MIN QTY', style: _headerStyle)),
            if (_visibleCols['reqMaxQty']!)
              const DataColumn(label: Text('REQ MAX QTY', style: _headerStyle)),
            if (_visibleCols['reqMinQty']!)
              const DataColumn(label: Text('REQ MIN QTY', style: _headerStyle)),
            if (_visibleCols['minReorder']!)
              const DataColumn(
                label: Text('MIN. REORDER', style: _headerStyle),
              ),
            if (_visibleCols['sph']!)
              const DataColumn(label: Text('SPH', style: _headerStyle)),
            if (_visibleCols['cyl']!)
              const DataColumn(label: Text('CYL', style: _headerStyle)),
            if (_visibleCols['eye']!)
              const DataColumn(label: Text('EYE', style: _headerStyle)),
            if (_visibleCols['action']!)
              const DataColumn(label: Text('REORDER', style: _headerStyle)),
          ],
          rows: List.generate(items.length, (index) {
            final item = items[index];
            final reqMax = (item.maxStock ?? 0) - item.stock;
            final reqMin = (item.minStock ?? 0) - item.stock;
            final lens = item.lensInfo;

            return DataRow(
              cells: [
                if (_visibleCols['sno']!)
                  DataCell(
                    Text(
                      (index + 1).toString(),
                      style: _cellStyle.copyWith(
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                if (_visibleCols['productName']!)
                  DataCell(
                    Text(
                      item.productName ?? 'N/A',
                      style: _cellStyle.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                if (_visibleCols['groupName']!)
                  DataCell(
                    Text(
                      (item.groupName ?? 'N/A').toUpperCase(),
                      style: _cellStyle,
                    ),
                  ),
                if (_visibleCols['unit']!)
                  DataCell(
                    Center(
                      child: Text(
                        item.unit ?? 'PCS',
                        style: _cellStyle.copyWith(
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),
                if (_visibleCols['criticalLevel']!)
                  DataCell(
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(color: Colors.red, width: 1),
                        ),
                      ),
                      child: Text(
                        item.alertQty.toStringAsFixed(0),
                        style: const TextStyle(
                          color: Color(0xFFDC2626),
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                if (_visibleCols['stock']!)
                  DataCell(
                    Center(
                      child: Text(
                        item.stock.toStringAsFixed(0),
                        style: const TextStyle(
                          color: Color(0xFF2563EB),
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                if (_visibleCols['maxQty']!)
                  DataCell(
                    Center(
                      child: Text(
                        (item.maxStock ?? 0).toStringAsFixed(0),
                        style: _cellStyle,
                      ),
                    ),
                  ),
                if (_visibleCols['minQty']!)
                  DataCell(
                    Center(
                      child: Text(
                        (item.minStock ?? 0).toStringAsFixed(0),
                        style: _cellStyle,
                      ),
                    ),
                  ),
                if (_visibleCols['reqMaxQty']!)
                  DataCell(
                    Center(
                      child: Text(
                        reqMax > 0 ? reqMax.toStringAsFixed(0) : '0',
                        style: _cellStyle,
                      ),
                    ),
                  ),
                if (_visibleCols['reqMinQty']!)
                  DataCell(
                    Center(
                      child: Text(
                        reqMin > 0 ? reqMin.toStringAsFixed(0) : '0',
                        style: _cellStyle,
                      ),
                    ),
                  ),
                if (_visibleCols['minReorder']!)
                  DataCell(
                    Center(
                      child: Text(
                        (item.minReorderQty ?? 0).toStringAsFixed(0),
                        style: _cellStyle,
                      ),
                    ),
                  ),
                if (_visibleCols['sph']!)
                  DataCell(
                    Center(
                      child: Text(
                        lens?.sph?.toString() ?? '-',
                        style: _cellStyle,
                      ),
                    ),
                  ),
                if (_visibleCols['cyl']!)
                  DataCell(
                    Center(
                      child: Text(
                        lens?.cyl?.toString() ?? '-',
                        style: _cellStyle,
                      ),
                    ),
                  ),
                if (_visibleCols['eye']!)
                  DataCell(
                    Center(
                      child: Text(
                        lens?.eye?.toString() ?? '-',
                        style: _cellStyle,
                      ),
                    ),
                  ),
                if (_visibleCols['action']!)
                  DataCell(
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () => _handleReorder(item),
                        icon: const Icon(LucideIcons.shoppingCart, size: 12),
                        label: const Text(
                          'Order',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEFF6FF),
                          foregroundColor: const Color(0xFF1D4ED8),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          side: const BorderSide(color: Color(0xFFBFDBFE)),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildFooter(List<StockReorderItem> items) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFFFFF7ED),
        border: Border(top: BorderSide(color: Color(0xFFFED7AA))),
      ),
      child: Row(
        children: [
          const Icon(
            LucideIcons.alertTriangle,
            color: Color(0xFFEA580C),
            size: 16,
          ),
          const SizedBox(width: 8),
          const Text(
            'Showing items that have reached critical stock levels (Stock ≤ Alert Quantity).',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF9A3412),
            ),
          ),
          const Spacer(),
          Text(
            'TOTAL ITEMS FOUND: ',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade500,
              letterSpacing: 1,
            ),
          ),
          Text(
            '${items.length}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: Color(0xFF7C2D12),
            ),
          ),
        ],
      ),
    );
  }

  // --- Style Constants ---
  static const _headerStyle = TextStyle(
    fontWeight: FontWeight.w900,
    fontSize: 10,
    color: Color(0xFF475569),
  );
  static const _cellStyle = TextStyle(fontSize: 11, color: Color(0xFF334155));

  // --- Helpers (matching TransactionDetailPage patterns) ---

  Widget _filterItem(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w900,
            color: Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }

  Widget _dropdown(
    String value,
    List<String> items,
    Function(String?) onChanged, {
    Map<String, String>? labels,
  }) {
    return Container(
      width: 130,
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
          items: items.map((e) {
            String label = e;
            if (labels != null && labels.containsKey(e)) {
              label = labels[e]!;
            }
            return DropdownMenuItem(value: e, child: Text(label));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _groupAutocomplete() {
    return SizedBox(
      width: 160,
      child: Consumer<ItemGroupProvider>(
        builder: (context, provider, _) => Container(
          height: 38,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Autocomplete<String>(
            optionsBuilder: (textEditingValue) => provider.groups
                .map((e) => e.groupName)
                .where(
                  (e) => e.toLowerCase().contains(
                    textEditingValue.text.toLowerCase(),
                  ),
                ),
            onSelected: (v) => setState(() => _groupName = v),
            fieldViewBuilder:
                (context, controller, focusNode, onFieldSubmitted) {
                  if (controller.text != _groupName && _groupName.isEmpty)
                    controller.text = '';
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      hintText: 'Select Group',
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(fontSize: 12),
                    onChanged: (v) => _groupName = v,
                  );
                },
          ),
        ),
      ),
    );
  }

  Widget _itemAutocomplete() {
    return SizedBox(
      width: 200,
      child: Consumer<ItemMasterProvider>(
        builder: (context, provider, _) => Container(
          height: 38,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Autocomplete<String>(
            optionsBuilder: (textEditingValue) => provider.items
                .map((e) => e.itemName)
                .where(
                  (e) => e.toLowerCase().contains(
                    textEditingValue.text.toLowerCase(),
                  ),
                ),
            onSelected: (v) => setState(() => _itemName = v),
            fieldViewBuilder:
                (context, controller, focusNode, onFieldSubmitted) {
                  if (controller.text != _itemName && _itemName.isEmpty)
                    controller.text = '';
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      hintText: 'Select Item',
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(fontSize: 12),
                    onChanged: (v) => _itemName = v,
                  );
                },
          ),
        ),
      ),
    );
  }

  Widget _vendorAutocomplete() {
    return SizedBox(
      width: 180,
      child: Consumer<AccountProvider>(
        builder: (context, provider, _) => Container(
          height: 38,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Autocomplete<String>(
            optionsBuilder: (textEditingValue) => provider.accounts
                .map((e) => e.name)
                .where(
                  (e) => e.toLowerCase().contains(
                    textEditingValue.text.toLowerCase(),
                  ),
                ),
            onSelected: (v) => setState(() => _vendorName = v),
            fieldViewBuilder:
                (context, controller, focusNode, onFieldSubmitted) {
                  if (controller.text != _vendorName && _vendorName.isEmpty)
                    controller.text = '';
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      hintText: 'Vendor Name',
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(fontSize: 12),
                    onChanged: (v) => _vendorName = v,
                  );
                },
          ),
        ),
      ),
    );
  }

  Widget _textField(String hint, Function(String) onChanged) {
    return Container(
      width: 140,
      height: 38,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          border: InputBorder.none,
        ),
        style: const TextStyle(fontSize: 12),
        onChanged: onChanged,
      ),
    );
  }

  Widget _numberField(String hint, Function(String) onChanged) {
    return Container(
      width: 80,
      height: 38,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: hint,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          border: InputBorder.none,
        ),
        style: const TextStyle(fontSize: 12),
        onChanged: onChanged,
      ),
    );
  }
}
