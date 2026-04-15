import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../data/models/lens_sale_challan_model.dart';
import '../../data/models/lens_sale_order_model.dart';
import '../../data/providers/lens_sale_challan_provider.dart';
import '../../data/providers/lens_sale_order_provider.dart';
import '../../../masters/data/providers/account_provider.dart';
import '../../../masters/data/providers/tax_category_provider.dart';
import '../../../masters/data/models/tax_category_model.dart';
import '../../../masters/data/models/account_model.dart';
import '../widgets/lens_order_grid_widget.dart';
import '../widgets/load_sale_orders_modal.dart';

class AddLensSaleChallanPage extends StatefulWidget {
  final String? challanId; // For editing

  const AddLensSaleChallanPage({super.key, this.challanId});

  @override
  State<AddLensSaleChallanPage> createState() => _AddLensSaleChallanPageState();
}

class _AddLensSaleChallanPageState extends State<AddLensSaleChallanPage> {
  // --- Form State ---
  SaleOrderBillData _billData = const SaleOrderBillData(godown: 'HO');
  SaleOrderPartyData _partyData = const SaleOrderPartyData();
  List<SaleOrderItem> _items = List.generate(5, (index) => const SaleOrderItem());
  List<SaleOrderTax> _taxes = [];
  String _remark = '';
  String _status = 'Pending';
  double _paidAmount = 0.0;
  String? _sourceSaleId;

  // Track valid barcodes locally via loaded orders
  Map<String, Map<String, dynamic>> _validBarcodes = {};

  // --- Calculations ---
  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalAmount);
  double get taxesAmount => _taxes.fold(0.0, (sum, tax) => sum + tax.amount);
  double get netAmount => subtotal + taxesAmount;
  double get dueAmount => netAmount - _paidAmount;

  final TextEditingController _partyController = TextEditingController();

  bool get isReadOnly => (_status.toLowerCase() == 'done' || _status.toLowerCase() == 'received');

  @override
  void initState() {
    super.initState();
    _billData = _billData.copyWith(date: DateFormat('yyyy-MM-dd').format(DateTime.now()));
    if (widget.challanId != null) {
      _loadChallan();
    }
  }

  Future<void> _loadChallan() async {
    // Implement loading existing challan logic
  }

  void _calculateTotals() {
    setState(() {
      for (int i = 0; i < _taxes.length; i++) {
        final tax = _taxes[i];
        final amount = (subtotal * tax.percentage) / 100.0;
        _taxes[i] = tax.copyWith(amount: amount);
      }
    });
  }

  void _updateItem(int index, SaleOrderItem newItem) {
    if (isReadOnly) return;
    
    // Barcode auto-increment logic
    if (newItem.barcode.isNotEmpty && _validBarcodes.containsKey(newItem.barcode)) {
        final match = _validBarcodes[newItem.barcode]!;
        
        // Scan for existing occurrence to increment qty instead of duplicating row
        int existingIndex = _items.indexWhere((it) => it.barcode == newItem.barcode && it != newItem);
        if (existingIndex != -1) {
            // Increment logic
            int nextQty = _items[existingIndex].qty + 1;
            if (nextQty > (match['qty'] as int)) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Quantity Limit Exceeded. Only ${match['qty']} allowed.')));
                // Clear the current box
                setState(() {
                   _items[index] = newItem.copyWith(barcode: '');
                });
                return;
            }
            
            setState(() {
                final existing = _items[existingIndex];
                final total = (nextQty * existing.salePrice) - (nextQty * existing.salePrice * (existing.discount / 100));
                _items[existingIndex] = existing.copyWith(qty: nextQty, totalAmount: total);
                _items[index] = newItem.copyWith(barcode: '');
            });
            _calculateTotals();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Incremented quantity for ${match['itemName']}')));
            return;
        } else {
            // New entry matching a valid barcode
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Matched: ${match['itemName']}')));
            _sourceSaleId = match['sourceOrderId'] as String?;
            final qty = 1;
            final price = double.parse(match['salePrice'].toString());
            final disc = double.parse(match['discount'].toString());
            final total = (qty * price) - (qty * price * (disc / 100));

            setState(() {
              _items[index] = newItem.copyWith(
                itemName: match['itemName'],
                orderNo: match['orderNo'] ?? '',
                eye: match['eye'] ?? '',
                sph: double.tryParse(match['sph'].toString()) ?? 0.0,
                cyl: double.tryParse(match['cyl'].toString()) ?? 0.0,
                axis: double.tryParse(match['axis'].toString()) ?? 0.0,
                add: double.tryParse(match['add'].toString()) ?? 0.0,
                qty: qty,
                salePrice: price,
                discount: disc,
                totalAmount: total,
                combinationId: match['combinationId'] ?? '',
                id: match['_id'], // Set _id mapping for fulfillment
              );
            });
            _calculateTotals();
            return;
        }
    } else if (newItem.barcode.isNotEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid Barcode for selected party.')));
       setState(() {
         _items[index] = newItem.copyWith(barcode: '');
       });
       return;
    }

    setState(() {
      final total = (newItem.qty * newItem.salePrice) - newItem.discount;
      _items[index] = newItem.copyWith(totalAmount: total);
    });
    _calculateTotals();
  }

  void _onTaxCategorySelected(dynamic taxCat) {
    if (isReadOnly) return;
    setState(() {
      _billData = _billData.copyWith(billType: taxCat.name);
      _taxes = [];
      
      if (taxCat.localTax1 > 0) _taxes.add(SaleOrderTax(taxName: 'CGST', percentage: taxCat.localTax1.toDouble()));
      if (taxCat.localTax2 > 0) _taxes.add(SaleOrderTax(taxName: 'SGST', percentage: taxCat.localTax2.toDouble()));
      if (taxCat.centralTax > 0) _taxes.add(SaleOrderTax(taxName: 'IGST', percentage: taxCat.centralTax.toDouble()));
    });
    _calculateTotals();
  }

  void _addItemsFromBulk(List<SaleOrderItem> newMappedItems) {
    if (isReadOnly) return;
    setState(() {
      final existingItems = _items.where((it) => it.itemName.isNotEmpty || it.qty > 0).toList();
      _items = [...existingItems, ...newMappedItems];
      if (_items.length < 5) _items.addAll(List.generate(5 - _items.length, (index) => const SaleOrderItem()));
    });
    _calculateTotals();
  }

  Future<void> _selectParty(dynamic acc) async {
    setState(() {
      _partyData = SaleOrderPartyData(
        id: acc.id,
        partyAccount: acc.name ?? '',
        address: acc.address ?? '',
        contactNumber: acc.mobileNumber ?? '',
        stateCode: acc.state ?? '',
        creditLimit: acc.creditLimit?.toDouble() ?? 0.0,
        creditDays: acc.creditDays ?? 0,
        accountCategory: acc.accountCategory ?? '',
      );
      _partyController.text = acc.name ?? '';
      _validBarcodes = {}; // Clear barcodes
    });

    // Fetch next bill number
    final provider = context.read<LensSaleChallanProvider>();
    provider.getNextBillNumberForParty(acc.name ?? '').then((val) {
      if (mounted) setState(() => _billData = _billData.copyWith(billNo: val));
    });

    // Extract barcodes from pending orders
    final ordProvider = context.read<LensSaleOrderProvider>();
    await ordProvider.fetchAllOrders();
    final pendingOrders = ordProvider.orders.where((o) =>
        o.partyData.partyAccount == acc.name && o.balQty > 0 && o.status.toLowerCase() != 'done' && o.status.toLowerCase() != 'received');
    
    final Map<String, Map<String, dynamic>> barcodesMap = {};
    for (var o in pendingOrders) {
      for (var item in o.items) {
        if (item.barcode.isNotEmpty) {
           final baseJson = item.toJson();
           baseJson['sourceOrderId'] = o.id;
           barcodesMap[item.barcode] = baseJson;
        }
      }
    }
    setState(() {
       _validBarcodes = barcodesMap;
    });
  }

  void _showLoadOrdersModal() async {
    if (_partyData.partyAccount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a party first')));
      return;
    }

    final ordProvider = context.read<LensSaleOrderProvider>();
    await ordProvider.fetchAllOrders();
    final partyPendingOrders = ordProvider.orders.where((o) =>
        o.partyData.partyAccount == _partyData.partyAccount && o.balQty > 0 && o.status.toLowerCase() != 'done' && o.status.toLowerCase() != 'received').toList();

    if (!mounted) return;

    final selectedItems = await showDialog<List<Map<String, dynamic>>>(
      context: context,
      builder: (context) => LoadSaleOrdersModal(orders: partyPendingOrders, partyName: _partyData.partyAccount),
    );

    if (selectedItems != null && selectedItems.isNotEmpty) {
       setState(() {
          final existing = _items.where((it) => it.itemName.isNotEmpty).toList();
          final List<SaleOrderItem> newItems = [];
          
          bool isFirst = false;
          for (var itemMap in selectedItems) {
             if (!isFirst) {
                _sourceSaleId = itemMap['sourceOrderId'];
                isFirst = true;
             }
             newItems.add(SaleOrderItem.fromJson(itemMap));
          }
          
          _items = [...existing, ...newItems];
          if (_items.isEmpty) _items.addAll(List.generate(5, (_) => const SaleOrderItem()));
       });
       _calculateTotals();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Column(
        children: [
          _buildTopBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildBillSection(),
                  const SizedBox(height: 16),
                  _buildPartySection(),
                  const SizedBox(height: 16),
                  
                  // Load Orders ActionBar
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton.icon(
                      onPressed: isReadOnly ? null : _showLoadOrdersModal,
                      icon: const Icon(LucideIcons.plus, size: 16),
                      label: const Text('Load Orders'),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF059669), foregroundColor: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),

                  LensOrderGridWidget(
                    items: _items,
                    selectedAccount: _partyData.id != null 
                        ? context.read<AccountProvider>().accounts.cast<AccountModel?>().firstWhere(
                            (a) => a?.id == _partyData.id, 
                            orElse: () => null,
                          )
                        : null,
                    onItemsChanged: (newItems) {
                      setState(() {
                         // Iterate to simulate _updateItem behavior manually for internal list
                         _items = newItems;
                         _calculateTotals();
                      });
                    },
                    onAddItems: _addItemsFromBulk,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: _buildRemarksSection()),
                      const SizedBox(width: 16),
                      Expanded(flex: 3, child: _buildTotalsSection()),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.receipt, color: Color(0xFF2563EB), size: 20),
              const SizedBox(width: 8),
              const Text('Lens Sale Challan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(99)),
                child: const Text('Add New', style: TextStyle(color: Color(0xFF1E4ED8), fontSize: 11, fontWeight: FontWeight.bold)),
              ),
              if (isReadOnly)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(color: const Color(0xFFD1FAE5), border: Border.all(color: const Color(0xFF10B981)), borderRadius: BorderRadius.circular(99)),
                  child: const Text('COMPLETED', style: TextStyle(color: Color(0xFF047857), fontSize: 11, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.list, size: 16),
            label: const Text('View All Challans'),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF1F5F9), foregroundColor: const Color(0xFF475569)),
          ),
        ],
      ),
    );
  }

  Widget _buildBillSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFE2E8F0))),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Challan Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF64748B), letterSpacing: 1)),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildFormField('Series', _billData.billSeries, (val) => setState(() => _billData = _billData.copyWith(billSeries: val)), isReadOnly: isReadOnly),
                const SizedBox(width: 12),
                _buildFormField('Bill No', _billData.billNo, (val) => setState(() => _billData = _billData.copyWith(billNo: val)), isReadOnly: true),
                const SizedBox(width: 12),
                _buildFormField('Date', _billData.date ?? '', (val) => setState(() => _billData = _billData.copyWith(date: val)), isReadOnly: isReadOnly),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('BILL TYPE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8))),
                      const SizedBox(height: 4),
                      Autocomplete<TaxCategoryModel>(
                        optionsBuilder: (textEditingValue) {
                          if (isReadOnly) return const Iterable.empty();
                          final cats = context.read<TaxCategoryProvider>().taxCategories;
                          return cats.where((c) => (c.name ?? '').toLowerCase().contains(textEditingValue.text.toLowerCase()));
                        },
                        displayStringForOption: (c) => c.name ?? '',
                        onSelected: _onTaxCategorySelected,
                        fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                          controller.text = _billData.billType;
                          return TextField(
                            controller: controller,
                            focusNode: focusNode,
                            readOnly: isReadOnly,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                              filled: isReadOnly,
                              fillColor: isReadOnly ? const Color(0xFFF1F5F9) : Colors.white,
                            ),
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                _buildFormField('Godown', _billData.godown, (val) => setState(() => _billData = _billData.copyWith(godown: val)), isReadOnly: isReadOnly),
                const SizedBox(width: 12),
                _buildFormField('Booked By', _billData.bookedBy, (val) => setState(() => _billData = _billData.copyWith(bookedBy: val)), isReadOnly: isReadOnly),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPartySection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFE2E8F0))),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Party Information', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF64748B), letterSpacing: 1)),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('ACCOUNT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                      const SizedBox(height: 4),
                      _buildPartyAutocomplete(),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(child: _buildReadOnlyInfo('Address', _partyData.address)),
                const SizedBox(width: 16),
                Expanded(child: _buildReadOnlyInfo('Contact', _partyData.contactNumber)),
                const SizedBox(width: 16),
                Expanded(child: _buildReadOnlyInfo('State Code', _partyData.stateCode)),
                const SizedBox(width: 16),
                Expanded(child: _buildReadOnlyInfo('Balance', '₹ ${_partyData.currentBalance.amount} ${_partyData.currentBalance.type}')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPartyAutocomplete() {
    return Autocomplete<AccountModel>(
      optionsBuilder: (textEditingValue) async {
        if (textEditingValue.text.isEmpty || isReadOnly) return const Iterable.empty();
        final accounts = context.read<AccountProvider>().accounts;
        if (accounts.isEmpty) await context.read<AccountProvider>().fetchAllAccounts();
        return context.read<AccountProvider>().accounts.where((acc) => (acc.name ?? '').toLowerCase().contains(textEditingValue.text.toLowerCase()));
      },
      displayStringForOption: (acc) => acc.name ?? '',
      onSelected: _selectParty,
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        if (_partyController.text.isNotEmpty && !focusNode.hasFocus) controller.text = _partyController.text;
        return TextField(
          controller: controller,
          focusNode: focusNode,
          readOnly: isReadOnly,
          decoration: InputDecoration(
            hintText: 'Type party name...',
            prefixIcon: const Icon(Icons.search, size: 16),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            filled: isReadOnly,
            fillColor: isReadOnly ? const Color(0xFFF1F5F9) : Colors.white,
          ),
          onEditingComplete: onFieldSubmitted,
        );
      },
    );
  }

  Widget _buildRemarksSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFE2E8F0))),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Remark', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF64748B))),
            const SizedBox(height: 8),
            TextField(
              maxLines: 4,
              readOnly: isReadOnly,
              decoration: InputDecoration(
                hintText: 'Enter internal notes...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: isReadOnly ? const Color(0xFFF1F5F9) : const Color(0xFFF8FAFC),
              ),
              onChanged: (v) => _remark = v,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalsSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFE2E8F0))),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTotalRow('Subtotal', subtotal.toStringAsFixed(2)),
            const Divider(height: 24),
            ..._taxes.map((t) => _buildTotalRow(t.taxName, t.amount.toStringAsFixed(2))),
            const Divider(height: 24),
            _buildTotalRow('Net Amount', netAmount.toStringAsFixed(2), isBold: true, color: const Color(0xFF1E4ED8), fontSize: 16),
            const SizedBox(height: 12),
            _buildTotalRow('Paid Amount', ''),
            _buildTotalRow('Due Amount', dueAmount.toStringAsFixed(2), color: Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalRow(String label, String value, {bool isBold = false, Color? color, double fontSize = 13}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: fontSize, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: const Color(0xFF64748B))),
        if (label == 'Paid Amount')
          SizedBox(
            width: 120,
            height: 32,
            child: TextField(
              textAlign: TextAlign.right,
              keyboardType: TextInputType.number,
              readOnly: isReadOnly,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8), 
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                filled: isReadOnly,
                fillColor: isReadOnly ? const Color(0xFFF1F5F9) : Colors.white,
              ),
              onChanged: (v) => setState(() => _paidAmount = double.tryParse(v) ?? 0.0),
            ),
          )
        else
          Text(value, style: TextStyle(fontSize: fontSize, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: color ?? const Color(0xFF1E293B))),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton.icon(
            onPressed: isReadOnly ? null : () => Navigator.pop(context),
            icon: const Icon(Icons.rotate_left),
            label: const Text('Reset Form'),
            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16)),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: isReadOnly ? null : _saveChallan,
            icon: Icon(isReadOnly ? LucideIcons.lock : Icons.save),
            label: Text(isReadOnly ? 'LOCKED' : 'Finalize Challan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: isReadOnly ? const Color(0xFF64748B) : const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  void _saveChallan() async {
    final provider = context.read<LensSaleChallanProvider>();
    final List<SaleOrderItem> filledItems = _items.where((it) => it.itemName.isNotEmpty && it.qty > 0).toList();

    if (filledItems.isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please add at least one item')));
       return;
    }
    if (_partyData.partyAccount.isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a party')));
       return;
    }

    final challan = LensSaleChallanModel(
      billData: _billData,
      partyData: _partyData,
      items: filledItems,
      taxes: _taxes,
      paidAmount: _paidAmount,
      subtotal: subtotal,
      taxesAmount: taxesAmount,
      netAmount: netAmount,
      dueAmount: dueAmount,
      remark: _remark,
      status: _status,
      sourceSaleId: _sourceSaleId,
    );

    final res = await provider.createChallan(challan.toJson());
    if (res['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Challan saved successfully')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${res['message']}')));
    }
  }

  Widget _buildFormField(String label, String value, Function(String) onChanged, {bool isReadOnly = false}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8))),
          const SizedBox(height: 4),
          SizedBox(
            height: 36,
            child: TextField(
              readOnly: isReadOnly,
              controller: TextEditingController(text: value)..selection = TextSelection.fromPosition(TextPosition(offset: value.length)),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                filled: isReadOnly,
                fillColor: isReadOnly ? const Color(0xFFF1F5F9) : Colors.white,
              ),
              style: const TextStyle(fontSize: 12),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8))),
        const SizedBox(height: 4),
        Text(value.isEmpty ? '-' : value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
      ],
    );
  }
}
