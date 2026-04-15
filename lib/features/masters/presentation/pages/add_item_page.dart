import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../data/models/item_master_model.dart';
import '../../data/providers/inventory_providers.dart';
import '../../data/providers/tax_category_provider.dart';

class AddItemPage extends StatefulWidget {
  final bool hideHeader;
  final Function(ItemMasterModel)? onSaveSuccess;

  const AddItemPage({
    super.key,
    this.hideHeader = false,
    this.onSaveSuccess,
  });

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _itemNameController = TextEditingController();
  final _billItemNameController = TextEditingController();
  final _aliasController = TextEditingController();
  final _printNameController = TextEditingController();
  final _unitController = TextEditingController();
  final _allUnitController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _openingStockController = TextEditingController();
  final _openingStockValueController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _saleProfitController = TextEditingController();
  final _salePriceController = TextEditingController();
  final _mrpPriceController = TextEditingController();
  final _saleDiscountController = TextEditingController();
  final _purchaseDiscountController = TextEditingController();
  final _minSalePriceController = TextEditingController();
  final _hsnCodeController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _godownController = TextEditingController();
  final _loyaltyPointsController = TextEditingController();
  final _refAmnController = TextEditingController();
  final _refAmntIndiaController = TextEditingController();
  final _sellStockLevelController = TextEditingController();
  final _batchWiseDetailsController = TextEditingController();
  final _searchController = TextEditingController();

  String? _selectedGroupName;
  String? _selectedTaxCategory;
  String _taxSetting = 'N';
  bool _forLensProduct = false;
  String _stockable = 'N';

  String? _editingId;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ItemMasterProvider>().fetchItems();
      context.read<ItemGroupProvider>().fetchGroups();
      context.read<TaxCategoryProvider>().fetchAllTaxCategories();
      _fetchNextAlias();
    });
    _searchController.addListener(() => setState(() {}));
    
    // Auto-fill logic from React: itemName fills billItemName and printName
    _itemNameController.addListener(() {
      if (_editingId == null) {
        _billItemNameController.text = _itemNameController.text;
        _printNameController.text = _itemNameController.text;
      }
    });

    // Price calculation logic
    _purchasePriceController.addListener(_calculateSalePrice);
    _saleProfitController.addListener(_calculateSalePrice);
  }

  void _calculateSalePrice() {
    final pPrice = double.tryParse(_purchasePriceController.text) ?? 0;
    final profit = double.tryParse(_saleProfitController.text) ?? 0;
    if (pPrice > 0 && profit > 0 && _editingId == null) {
      final sPrice = pPrice + (pPrice * profit / 100);
      _salePriceController.text = sPrice.toStringAsFixed(2);
    }
  }

  Future<void> _fetchNextAlias() async {
    final alias = await context.read<ItemMasterProvider>().fetchNextAlias();
    if (alias != null && mounted && _editingId == null) {
      setState(() => _aliasController.text = alias);
    }
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _billItemNameController.dispose();
    _aliasController.dispose();
    _printNameController.dispose();
    _unitController.dispose();
    _allUnitController.dispose();
    _descriptionController.dispose();
    _openingStockController.dispose();
    _openingStockValueController.dispose();
    _purchasePriceController.dispose();
    _saleProfitController.dispose();
    _salePriceController.dispose();
    _mrpPriceController.dispose();
    _saleDiscountController.dispose();
    _purchaseDiscountController.dispose();
    _minSalePriceController.dispose();
    _hsnCodeController.dispose();
    _barcodeController.dispose();
    _godownController.dispose();
    _loyaltyPointsController.dispose();
    _refAmnController.dispose();
    _refAmntIndiaController.dispose();
    _sellStockLevelController.dispose();
    _batchWiseDetailsController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _handleEdit(ItemMasterModel item) {
    setState(() {
      _editingId = item.id;
      _itemNameController.text = item.itemName;
      _billItemNameController.text = item.billItemName;
      _aliasController.text = item.alias;
      _printNameController.text = item.printName;
      _selectedGroupName = item.groupName;
      _unitController.text = item.unit;
      _allUnitController.text = item.allUnit;
      _descriptionController.text = item.description;
      _taxSetting = item.taxSetting;
      _openingStockController.text = item.openingStock?.toString() ?? '';
      _openingStockValueController.text = item.openingStockValue?.toString() ?? '';
      _purchasePriceController.text = item.purchasePrice?.toString() ?? '';
      _saleProfitController.text = item.saleProfit?.toString() ?? '';
      _salePriceController.text = item.salePrice?.toString() ?? '';
      _mrpPriceController.text = item.mrpPrice?.toString() ?? '';
      _saleDiscountController.text = item.saleDiscount?.toString() ?? '';
      _purchaseDiscountController.text = item.purchaseDiscount?.toString() ?? '';
      _minSalePriceController.text = item.minSalePrice?.toString() ?? '';
      _hsnCodeController.text = item.hsnCode;
      _barcodeController.text = item.barcode;
      _stockable = item.stockable;
      _godownController.text = item.godown;
      _loyaltyPointsController.text = item.loyaltyPoints;
      _refAmnController.text = item.refAmn;
      _refAmntIndiaController.text = item.refAmntIndia;
      _forLensProduct = item.forLensProduct;
      _sellStockLevelController.text = item.sellStockLevel;
      _batchWiseDetailsController.text = item.batchWiseDetails;
      _selectedTaxCategory = item.taxCategory;
    });
  }

  void _handleReset() {
    setState(() {
      _editingId = null;
      _itemNameController.clear();
      _billItemNameController.clear();
      _printNameController.clear();
      _selectedGroupName = null;
      _unitController.clear();
      _allUnitController.clear();
      _descriptionController.clear();
      _taxSetting = 'N';
      _openingStockController.clear();
      _openingStockValueController.clear();
      _purchasePriceController.clear();
      _saleProfitController.clear();
      _salePriceController.clear();
      _mrpPriceController.clear();
      _saleDiscountController.clear();
      _purchaseDiscountController.clear();
      _minSalePriceController.clear();
      _hsnCodeController.clear();
      _barcodeController.clear();
      _stockable = 'N';
      _godownController.clear();
      _loyaltyPointsController.clear();
      _refAmnController.clear();
      _refAmntIndiaController.clear();
      _forLensProduct = false;
      _sellStockLevelController.clear();
      _batchWiseDetailsController.clear();
      _selectedTaxCategory = null;
    });
    _fetchNextAlias();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    try {
      final item = ItemMasterModel(
        itemName: _itemNameController.text.trim(),
        billItemName: _billItemNameController.text.trim(),
        alias: _aliasController.text.trim(),
        printName: _printNameController.text.trim(),
        groupName: _selectedGroupName ?? '',
        unit: _unitController.text.trim(),
        allUnit: _allUnitController.text.trim(),
        description: _descriptionController.text.trim(),
        taxSetting: _taxSetting,
        openingStock: double.tryParse(_openingStockController.text),
        openingStockValue: double.tryParse(_openingStockValueController.text),
        purchasePrice: double.tryParse(_purchasePriceController.text),
        saleProfit: double.tryParse(_saleProfitController.text),
        salePrice: double.tryParse(_salePriceController.text),
        mrpPrice: double.tryParse(_mrpPriceController.text),
        saleDiscount: double.tryParse(_saleDiscountController.text),
        purchaseDiscount: double.tryParse(_purchaseDiscountController.text),
        minSalePrice: double.tryParse(_minSalePriceController.text),
        hsnCode: _hsnCodeController.text.trim(),
        barcode: _barcodeController.text.trim(),
        stockable: _stockable,
        godown: _godownController.text.trim(),
        loyaltyPoints: _loyaltyPointsController.text.trim(),
        refAmn: _refAmnController.text.trim(),
        refAmntIndia: _refAmntIndiaController.text.trim(),
        forLensProduct: _forLensProduct,
        sellStockLevel: _sellStockLevelController.text.trim(),
        batchWiseDetails: _batchWiseDetailsController.text.trim(),
        taxCategory: _selectedTaxCategory ?? '',
      );

      final provider = context.read<ItemMasterProvider>();
      if (_editingId != null) {
        await provider.updateItem(_editingId!, item);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item updated successfully')));
      } else {
        await provider.addItem(item);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item created successfully')));
        if (widget.onSaveSuccess != null) widget.onSaveSuccess!(item);
      }
      _handleReset();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ItemMasterProvider>();
    final groups = context.watch<ItemGroupProvider>().groups;
    final taxCats = context.watch<TaxCategoryProvider>().taxCategories;

    final filteredItems = provider.items.where((i) {
      final query = _searchController.text.toLowerCase();
      return i.itemName.toLowerCase().contains(query) || i.alias.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!widget.hideHeader) ...[
              const Text('Item Master', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              const SizedBox(height: 8),
              const Text('Create and manage inventory items', style: TextStyle(color: Color(0xFF64748B))),
              const SizedBox(height: 32),
            ],

            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildSection('Product Basic Info', [
                    Row(
                      children: [
                        Expanded(flex: 2, child: _buildTextField(controller: _itemNameController, label: 'Item Name*', icon: LucideIcons.package, validator: (v) => v?.isEmpty ?? true ? 'Required' : null)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildTextField(controller: _aliasController, label: 'Alias', icon: LucideIcons.hash)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildTextField(controller: _billItemNameController, label: 'Bill Item Name')),
                        const SizedBox(width: 16),
                        Expanded(child: _buildTextField(controller: _printNameController, label: 'Print Name')),
                        const SizedBox(width: 16),
                        Expanded(child: _buildDropdown(label: 'Group Name', value: _selectedGroupName, items: groups.map((g) => g.groupName).toList(), onChanged: (v) => setState(() => _selectedGroupName = v))),
                      ],
                    ),
                  ]),

                  _buildSection('Inventory & Units', [
                    Row(
                      children: [
                        Expanded(child: _buildTextField(controller: _unitController, label: 'Unit (e.g. PCS)')),
                        const SizedBox(width: 16),
                        Expanded(child: _buildTextField(controller: _allUnitController, label: 'Alt Unit')),
                        const SizedBox(width: 16),
                        Expanded(child: _buildDropdown(label: 'Stockable', value: _stockable, items: ['Y', 'N'], onChanged: (v) => setState(() => _stockable = v!))),
                        const SizedBox(width: 16),
                        Expanded(child: _buildCheckbox('For Lens Product', _forLensProduct, (v) => setState(() => _forLensProduct = v!))),
                      ],
                    ),
                  ]),

                  _buildSection('Pricing & Tax Details', [
                    Row(
                      children: [
                        Expanded(child: _buildTextField(controller: _purchasePriceController, label: 'Purchase Price', prefix: '₹')),
                        const SizedBox(width: 16),
                        Expanded(child: _buildTextField(controller: _saleProfitController, label: 'Sale Profit (%)')),
                        const SizedBox(width: 16),
                        Expanded(child: _buildTextField(controller: _salePriceController, label: 'Sale Price', prefix: '₹')),
                        const SizedBox(width: 16),
                        Expanded(child: _buildTextField(controller: _mrpPriceController, label: 'MRP Price', prefix: '₹')),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildTextField(controller: _saleDiscountController, label: 'Sale Discount (%)')),
                        const SizedBox(width: 16),
                        Expanded(child: _buildTextField(controller: _purchaseDiscountController, label: 'Purchase Disc (%)')),
                        const SizedBox(width: 16),
                        Expanded(child: _buildTextField(controller: _hsnCodeController, label: 'HSN Code', icon: LucideIcons.scanLine)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildDropdown(label: 'Tax Category', value: _selectedTaxCategory, items: taxCats.map((t) => t.name).toList(), onChanged: (v) => setState(() => _selectedTaxCategory = v))),
                      ],
                    ),
                  ]),

                  _buildSection('Advanced Settings', [
                    Row(
                      children: [
                        Expanded(child: _buildTextField(controller: _barcodeController, label: 'Barcode')),
                        const SizedBox(width: 16),
                        Expanded(child: _buildTextField(controller: _openingStockController, label: 'Opening Stock')),
                        const SizedBox(width: 16),
                        Expanded(child: _buildTextField(controller: _openingStockValueController, label: 'Opening Stock Value')),
                        const SizedBox(width: 16),
                        Expanded(child: _buildTextField(controller: _godownController, label: 'Godown')),
                      ],
                    ),
                  ]),

                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 400,
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search items by name or alias...',
                            prefixIcon: const Icon(LucideIcons.search, size: 18),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          OutlinedButton.icon(onPressed: _handleReset, icon: const Icon(LucideIcons.rotateCcw, size: 18), label: const Text('Reset')),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: _isSubmitting ? null : _handleSubmit,
                            icon: _isSubmitting ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(LucideIcons.save, size: 18),
                            label: Text(_editingId != null ? 'Update Item' : 'Save Item'),
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Item List Table
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(color: Color(0xFFF8FAFC), borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Product Catalog', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                        Text('Total Items: ${filteredItems.length}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  DataTable(
                    headingRowColor: MaterialStateProperty.all(const Color(0xFFF8FAFC)),
                    columns: const [
                      DataColumn(label: Text('ALIAS')),
                      DataColumn(label: Text('ITEM NAME')),
                      DataColumn(label: Text('GROUP')),
                      DataColumn(label: Text('SALE PRICE')),
                      DataColumn(label: Text('STOCK')),
                      DataColumn(label: Text('ACTIONS')),
                    ],
                    rows: filteredItems.map((item) => DataRow(cells: [
                      DataCell(Text(item.alias)),
                      DataCell(Text(item.itemName, style: const TextStyle(fontWeight: FontWeight.bold))),
                      DataCell(Text(item.groupName)),
                      DataCell(Text('₹${item.salePrice?.toStringAsFixed(2) ?? "0.00"}')),
                      DataCell(Text(item.openingStock?.toString() ?? '0')),
                      DataCell(Row(
                        children: [
                          IconButton(icon: const Icon(LucideIcons.pencil, size: 16, color: Colors.blue), onPressed: () => _handleEdit(item)),
                          IconButton(icon: const Icon(LucideIcons.trash2, size: 16, color: Colors.red), onPressed: () => _showDeleteDialog(item)),
                        ],
                      )),
                    ])).toList(),
                  ),
                  if (filteredItems.isEmpty)
                    const Padding(padding: EdgeInsets.all(32), child: Text('No items found.', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF94A3B8), fontStyle: FontStyle.italic))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label, IconData? icon, String? prefix, String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixText: prefix,
        prefixIcon: icon != null ? Icon(icon, size: 18) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }

  Widget _buildDropdown({required String label, required String? value, required List<String> items, required ValueChanged<String?> onChanged}) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, style: const TextStyle(fontSize: 14)))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
    );
  }

  Widget _buildCheckbox(String label, bool value, ValueChanged<bool?> onChanged) {
    return Row(
      children: [
        Checkbox(value: value, onChanged: onChanged),
        Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF475569))),
      ],
    );
  }

  void _showDeleteDialog(ItemMasterModel item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete "${item.itemName}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await context.read<ItemMasterProvider>().deleteItem(item.id!);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item deleted')));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
