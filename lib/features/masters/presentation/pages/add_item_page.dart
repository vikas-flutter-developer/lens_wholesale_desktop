import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:excel/excel.dart' as excel;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../data/models/item_master_model.dart';
import '../../data/models/item_group_model.dart';
import '../../data/models/tax_category_model.dart';
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
  final _vendorItemNameController = TextEditingController();
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
  bool _stockable = false;

  String? _editingId;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _setupAutoFills();
    _searchController.addListener(() => setState(() {}));
  }

  void _initializeData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ItemMasterProvider>().fetchItems();
      context.read<ItemGroupProvider>().fetchGroups();
      context.read<TaxCategoryProvider>().fetchAllTaxCategories();
      _fetchNextAlias();
    });
  }

  void _setupAutoFills() {
    _itemNameController.addListener(() {
      if (_editingId == null) {
        _billItemNameController.text = _itemNameController.text;
        _printNameController.text = _itemNameController.text;
      }
    });

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
    _itemNameController.dispose(); _vendorItemNameController.dispose(); _billItemNameController.dispose();
    _aliasController.dispose(); _printNameController.dispose(); _unitController.dispose();
    _allUnitController.dispose(); _descriptionController.dispose(); _openingStockController.dispose();
    _openingStockValueController.dispose(); _purchasePriceController.dispose(); _saleProfitController.dispose();
    _salePriceController.dispose(); _mrpPriceController.dispose(); _saleDiscountController.dispose();
    _purchaseDiscountController.dispose(); _minSalePriceController.dispose(); _hsnCodeController.dispose();
    _barcodeController.dispose(); _godownController.dispose(); _loyaltyPointsController.dispose();
    _refAmnController.dispose(); _refAmntIndiaController.dispose(); _sellStockLevelController.dispose();
    _batchWiseDetailsController.dispose(); _searchController.dispose();
    super.dispose();
  }

  void _handleEdit(ItemMasterModel item) {
    setState(() {
      _editingId = item.id;
      _itemNameController.text = item.itemName;
      _vendorItemNameController.text = item.vendorItemName; // Corrected from placeholder
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
      _loyaltyPointsController.text = item.loyaltyPoints?.toString() ?? '';
      _refAmnController.text = item.refAmn?.toString() ?? '';
      _refAmntIndiaController.text = item.refAmntIndia?.toString() ?? '';
      _forLensProduct = item.forLensProduct;
      _sellStockLevelController.text = item.sellStockLevel;
      _batchWiseDetailsController.text = item.batchWiseDetails;
      _selectedTaxCategory = item.taxCategory;
    });
    Scrollable.ensureVisible(_formKey.currentContext!, duration: const Duration(milliseconds: 300));
  }

  void _handleReset() {
    setState(() {
      _editingId = null;
      _itemNameController.clear(); _billItemNameController.clear(); _printNameController.clear();
      _vendorItemNameController.clear();
      _selectedGroupName = null; _unitController.clear(); _allUnitController.clear();
      _descriptionController.clear(); _taxSetting = 'N'; _openingStockController.clear();
      _openingStockValueController.clear(); _purchasePriceController.clear(); _saleProfitController.clear();
      _salePriceController.clear(); _mrpPriceController.clear(); _saleDiscountController.clear();
      _purchaseDiscountController.clear(); _minSalePriceController.clear(); _hsnCodeController.clear();
      _barcodeController.clear(); _stockable = false; _godownController.clear();
      _loyaltyPointsController.clear(); _refAmnController.clear(); _refAmntIndiaController.clear();
      _forLensProduct = false; _sellStockLevelController.clear(); _batchWiseDetailsController.clear();
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
        vendorItemName: _vendorItemNameController.text.trim(),
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
        loyaltyPoints: double.tryParse(_loyaltyPointsController.text),
        refAmn: double.tryParse(_refAmnController.text),
        refAmntIndia: double.tryParse(_refAmntIndiaController.text),
        forLensProduct: _forLensProduct,
        sellStockLevel: _sellStockLevelController.text.trim(),
        batchWiseDetails: _batchWiseDetailsController.text.trim(),
        taxCategory: _selectedTaxCategory ?? '',
      );
      final provider = context.read<ItemMasterProvider>();
      if (_editingId != null) {
        await provider.updateItem(_editingId!, item);
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item updated successfully')));
      } else {
        await provider.addItem(item);
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item created successfully')));
        if (widget.onSaveSuccess != null) widget.onSaveSuccess!(item);
      }
      _handleReset();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _handleDownloadExcel(List<ItemMasterModel> items) async {
    if (items.isEmpty) return;
    try {
      var ex = excel.Excel.createExcel();
      excel.Sheet sheetObject = ex['Items'];
      ex.delete('Sheet1');

      List<String> headers = ['Sr No.', 'Created On', 'Group', 'Item Name', 'Unit', 'P. Price', 'S. Price', 'P. Disc%'];
      sheetObject.appendRow(headers.map((h) => excel.TextCellValue(h)).toList());

      for (var i = 0; i < items.length; i++) {
        final item = items[i];
        sheetObject.appendRow([
          excel.IntCellValue(i + 1),
          excel.TextCellValue(item.createdAt?.substring(0, 10) ?? '-'),
          excel.TextCellValue(item.groupName),
          excel.TextCellValue(item.itemName),
          excel.TextCellValue(item.unit),
          excel.DoubleCellValue(item.purchasePrice ?? 0),
          excel.DoubleCellValue(item.salePrice ?? 0),
          excel.DoubleCellValue(item.purchaseDiscount ?? 0),
        ]);
      }

      Directory? downloadsDir = await getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();
      String path = "${downloadsDir.path}/ItemMaster_${DateTime.now().millisecondsSinceEpoch}.xlsx";
      File(path)
        ..createSync(recursive: true)
        ..writeAsBytesSync(ex.encode()!);
      
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Excel saved to Downloads'), backgroundColor: Colors.green));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to export: $e'), backgroundColor: Colors.red));
    }
  }

  Future<void> _handlePrint(List<ItemMasterModel> items) async {
    if (items.isEmpty) return;
    final doc = pw.Document();
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Header(level: 0, child: pw.Text("Item Master Report", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold))),
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            headers: ['Sr.', 'Group', 'Item Name', 'Unit', 'P. Price', 'S. Price', 'Disc%'],
            data: items.asMap().entries.map((e) => [
              e.key + 1, e.value.groupName, e.value.itemName, e.value.unit, e.value.purchasePrice ?? 0, e.value.salePrice ?? 0, e.value.purchaseDiscount ?? 0
            ]).toList(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            cellPadding: const pw.EdgeInsets.all(5),
          ),
          pw.Footer(leading: pw.Text("Generated on ${DateTime.now().toString().substring(0, 16)}")),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => doc.save());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ItemMasterProvider>();
    final groups = context.watch<ItemGroupProvider>().groups;
    final taxCats = context.watch<TaxCategoryProvider>().taxCategories;
    final filteredItems = provider.items.where((i) {
      final q = _searchController.text.toLowerCase();
      return i.itemName.toLowerCase().contains(q) || i.alias.toLowerCase().contains(q) || i.groupName.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFF8FAFC), Color(0xFFEFF6FF)]),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!widget.hideHeader) ...[
                const Text("Item Master Creation", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
                const SizedBox(height: 8),
                const Text("Create and manage your inventory items with detailed specifications", style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                const SizedBox(height: 32),
              ],

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: _buildFormColumn(groups, taxCats)),
                  const SizedBox(width: 32),
                  Expanded(child: _buildActionColumn()),
                ],
              ),
              const SizedBox(height: 48),
              _buildRegistrySection(filteredItems, provider.isLoading),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormColumn(List<ItemGroupModel> groups, List<TaxCategoryModel> taxCats) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 15, offset: const Offset(0, 4))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF4F46E5)])),
            child: Row(
              children: [
                const Icon(LucideIcons.layout, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Text(_editingId != null ? "EDITING: ${_itemNameController.text.toUpperCase()}" : "NEW ITEM REGISTRATION", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 0.5)),
                if (_editingId != null) ...[
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)),
                    child: const Text("SAVE CHANGES TO UPDATE", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(children: [
                    Expanded(child: _buildTextField("ITEM NAME *", _itemNameController, required: true, hint: "e.g. Blue Cut Lens")),
                    const SizedBox(width: 24),
                    Expanded(child: _buildTextField("VENDOR ITEM NAME", _vendorItemNameController, hint: "Name shown to vendor (WhatsApp)")),
                  ]),
                  const SizedBox(height: 24),
                  Row(children: [
                    Expanded(child: _buildTextField("BILL ITEM NAME", _billItemNameController, hint: "Name shown in print/bill")),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _buildDropdownWithAction(
                        "GROUP NAME *",
                        _selectedGroupName,
                        groups.where((g) => g.groupName.isNotEmpty).map((g) => g.groupName).toList(),
                        (v) => setState(() => _selectedGroupName = v),
                        onAction: () => _showAddGroupQuickDialog(),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 24),
                  Row(children: [
                    Expanded(child: _buildTextField("ALIAS / CODE", _aliasController, hint: "Internal code")),
                    const SizedBox(width: 24),
                    Expanded(child: _buildDropdown("UNIT", _unitController.text.isEmpty ? null : _unitController.text, ['Pcs', 'Box', 'Pair', 'Nos'], (v) => setState(() => _unitController.text = v!))),
                  ]),
                  const SizedBox(height: 24),
                  Row(children: [
                    Expanded(child: _buildTextField("HSN CODE", _hsnCodeController, hint: "e.g. 9004")),
                    const SizedBox(width: 24),
                    Expanded(child: _buildDropdown("TAX CATEGORY", _selectedTaxCategory, taxCats.where((t) => t.name.isNotEmpty).map((t) => t.name).toList(), (v) => setState(() => _selectedTaxCategory = v))),
                  ]),
                  const SizedBox(height: 24),
                  Row(children: [
                    Expanded(child: _buildTextField("PURCHASE PRICE", _purchasePriceController, hint: "0.00", icon: LucideIcons.indianRupee)),
                    const SizedBox(width: 24),
                    Expanded(child: _buildTextField("SELLING PRICE", _salePriceController, hint: "0.00", icon: LucideIcons.indianRupee)),
                  ]),
                  const SizedBox(height: 24),
                  Row(children: [
                    Expanded(child: _buildTextField("PURCHASE DISCOUNT (%)", _purchaseDiscountController, hint: "0.00")),
                    const SizedBox(width: 24),
                    Expanded(child: _buildTextField("MRP", _mrpPriceController, hint: "0.00", icon: LucideIcons.indianRupee)),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddGroupQuickDialog() {
    // For now, consistent with react behavior:
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Navigate to Item Group tab to add dynamic groups')));
  }

  Widget _buildDropdownWithAction(String label, String? value, List<String> items, ValueChanged<String?> onChanged, {required VoidCallback onAction}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF64748B), letterSpacing: 1.0)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: value,
                items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)))).toList(),
                onChanged: onChanged,
                decoration: _inputDecoration(),
                icon: const Icon(LucideIcons.chevronDown, size: 14),
                hint: const Text("Select Category", style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFDBEAFE)),
              ),
              child: IconButton(
                onPressed: onAction,
                icon: const Icon(LucideIcons.plus, color: Color(0xFF2563EB), size: 18),
                constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionColumn() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 15, offset: const Offset(0, 4))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(children: [Icon(LucideIcons.plus, color: Color(0xFF2563EB), size: 14), SizedBox(width: 8), Text("ACTIONS", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 0.5, color: Color(0xFF1E293B)))]),
              const SizedBox(height: 24),
              _buildBigButton(
                label: _editingId != null ? "UPDATE ITEM" : "SAVE ITEM",
                icon: _isSubmitting ? LucideIcons.loader2 : LucideIcons.save,
                color: const Color(0xFF2563EB),
                onPressed: _isSubmitting ? null : _handleSubmit,
              ),
              const SizedBox(height: 12),
              _buildBigButton(label: _editingId != null ? "CANCEL EDIT" : "RESET FORM", icon: LucideIcons.rotateCcw, color: const Color(0xFFF1F5F9), textColor: const Color(0xFF475569), onPressed: _handleReset),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: const Color(0xFFFFFBEB), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFFEF3C7))),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("PRO TIP", style: TextStyle(color: Color(0xFF92400E), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
              SizedBox(height: 8),
              Text("Make sure to select the correct Group Name for reporting and stock categorization.", style: TextStyle(color: Color(0xFFB45309), fontSize: 11, fontWeight: FontWeight.w600, height: 1.5)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRegistrySection(List<ItemMasterModel> items, bool isLoading) {
    return LayoutBuilder(builder: (context, constraints) {
      final totalWidth = constraints.maxWidth;
      double w(double p) => totalWidth * p;

      final widths = {
        'sr': w(0.08),
        'date': w(0.12),
        'group': w(0.15),
        'item': w(0.25),
        'unit': w(0.10),
        'price': w(0.10),
        'disc': w(0.10),
        'action': w(0.10),
      };

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 25, offset: const Offset(0, 8))],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: const BoxDecoration(color: Color(0xFFF8FAFC), border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9)))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(children: [Icon(LucideIcons.list, color: Color(0xFF2563EB), size: 20), SizedBox(width: 10), Text("INVENTORY REGISTRY", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF1E293B), letterSpacing: 0.5))]),
                      const SizedBox(height: 4),
                      Text("Total ${items.length} items found".toUpperCase(), style: const TextStyle(color: Color(0xFF64748B), fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    children: [
                      _buildToolButton(LucideIcons.fileSpreadsheet, const Color(0xFF10B981), () => _handleDownloadExcel(items)),
                      const SizedBox(width: 12),
                      _buildToolButton(LucideIcons.printer, const Color(0xFF2563EB), () => _handlePrint(items)),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 280,
                        child: TextField(
                          controller: _searchController,
                          decoration: _inputDecoration(hint: "Search items, groups...", prefixIcon: LucideIcons.search),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isLoading && items.isEmpty)
              const Padding(padding: EdgeInsets.all(64), child: CircularProgressIndicator())
            else
              DataTable(
                headingRowHeight: 48,
                dataRowMinHeight: 70,
                dataRowMaxHeight: 85,
                horizontalMargin: 0,
                columnSpacing: 0,
                headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                dividerThickness: 1,
                columns: [
                  _buildTableColumn("SR NO.", width: widths['sr']!, centered: true),
                  _buildTableColumn("CREATED ON", width: widths['date']!),
                  _buildTableColumn("GROUP", width: widths['group']!),
                  _buildTableColumn("ITEM NAME", width: widths['item']!),
                  _buildTableColumn("UNIT", width: widths['unit']!),
                  _buildTableColumn("S. PRICE", width: widths['price']!, centered: true),
                  _buildTableColumn("P. DISC%", width: widths['disc']!, centered: true),
                  _buildTableColumn("ACTION", width: widths['action']!, centered: true),
                ],
                rows: items.asMap().entries.map((e) {
                  final i = e.key;
                  final item = e.value;
                  String formattedDate = "-";
                  try {
                    if (item.createdAt != null) {
                      final dt = DateTime.parse(item.createdAt!);
                      formattedDate = DateFormat('d/M/yyyy').format(dt);
                    }
                  } catch (_) {}

                  return DataRow(
                    cells: [
                      _buildTableCell(child: Text("${i + 1}", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), fontSize: 12)), width: widths['sr']!, centered: true),
                      _buildTableCell(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
                          child: Text(formattedDate, style: const TextStyle(fontSize: 11, color: Color(0xFF475569), fontWeight: FontWeight.w700)),
                        ),
                        width: widths['date']!,
                      ),
                      _buildTableCell(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE0E7FF))),
                          child: Text(item.groupName, style: const TextStyle(color: Color(0xFF4F46E5), fontSize: 10, fontWeight: FontWeight.w900)),
                        ),
                        width: widths['group']!,
                      ),
                      _buildTableCell(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text(item.itemName, style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF1E293B), fontSize: 13)),
                          if (item.alias.isNotEmpty) Text(item.alias, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold)),
                        ]),
                        width: widths['item']!,
                      ),
                      _buildTableCell(child: Text(item.unit.isEmpty ? "---" : item.unit.toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF64748B))), width: widths['unit']!),
                      _buildTableCell(child: Text("₹${item.salePrice ?? 0}", style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF2563EB), fontSize: 13)), width: widths['price']!, centered: true),
                      _buildTableCell(child: Text("${item.purchaseDiscount ?? 0}%", style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFFD97706), fontSize: 13)), width: widths['disc']!, centered: true),
                      _buildTableCell(
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          _buildTableActionIcon(LucideIcons.pencil, const Color(0xFF2563EB), () => _handleEdit(item)),
                          const SizedBox(width: 8),
                          _buildTableActionIcon(LucideIcons.trash2, const Color(0xFFDC2626), () => _showDeleteDialog(item)),
                        ]),
                        width: widths['action']!,
                        centered: true,
                      ),
                    ],
                  );
                }).toList(),
              ),
          ],
        ),
      );
    });
  }

  DataColumn _buildTableColumn(String label, {required double width, bool centered = false}) {
    return DataColumn(
      label: Container(
        width: width,
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: centered ? Alignment.center : Alignment.centerLeft,
        decoration: const BoxDecoration(border: Border(right: BorderSide(color: Color(0xFFF1F5F9)))),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), fontSize: 10, letterSpacing: 1.0)),
      ),
    );
  }

  DataCell _buildTableCell({required Widget child, required double width, bool centered = false}) {
    return DataCell(
      Container(
        width: width,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: centered ? Alignment.center : Alignment.centerLeft,
        decoration: const BoxDecoration(border: Border(right: BorderSide(color: Color(0xFFF1F5F9)))),
        child: child,
      ),
    );
  }

  Widget _buildFormRow(List<Widget> children) {
    return Padding(padding: const EdgeInsets.only(bottom: 24), child: Row(children: children));
  }

  Widget _buildTextField(String label, TextEditingController ctrl, {String? hint, bool required = false, bool readOnly = false, IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF64748B), letterSpacing: 1.0)),
        const SizedBox(height: 8),
        TextFormField(
          controller: ctrl,
          readOnly: readOnly,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
          decoration: _inputDecoration(hint: hint, prefixIcon: icon),
          validator: (val) => required && (val == null || val.trim().isEmpty) ? "Required" : null,
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String? value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF64748B), letterSpacing: 1.0)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)))).toList(),
          onChanged: onChanged,
          decoration: _inputDecoration(),
          icon: const Icon(LucideIcons.chevronDown, size: 14),
          hint: const Text("Select Unit", style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({String? hint, IconData? prefixIcon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 16, color: const Color(0xFF94A3B8)) : null,
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5)),
      hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
    );
  }

  Widget _buildBigButton({required String label, required IconData icon, required Color color, Color? textColor, required VoidCallback? onPressed}) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: color == const Color(0xFF2563EB) ? [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))] : null,
        ),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: icon == LucideIcons.loader2 
            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) 
            : Icon(icon, size: 18, color: textColor ?? Colors.white),
          label: Text(label, style: TextStyle(color: textColor ?? Colors.white, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 0.5)),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: color == const Color(0xFFF1F5F9) ? const BorderSide(color: Color(0xFFE2E8F0)) : BorderSide.none),
          ),
        ),
      ),
    );
  }

  Widget _buildToolButton(IconData icon, Color color, VoidCallback onPressed) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 48, width: 48,
          decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withValues(alpha: 0.2))),
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }

  Widget _buildTableActionIcon(IconData icon, Color color, VoidCallback onPressed) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 16, color: color),
        ),
      ),
    );
  }

  void _showDeleteDialog(ItemMasterModel item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Item', style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
        content: Text('Are you sure you want to delete "${item.itemName}"? This item will be permanently removed from inventory.', style: const TextStyle(fontSize: 14, color: Color(0xFF475569))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold))),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await context.read<ItemMasterProvider>().deleteItem(item.id!);
                if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item deleted successfully')));
              } catch (e) {
                if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            child: const Text('Delete', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
