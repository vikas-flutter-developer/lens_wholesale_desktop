import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../data/models/lens_sale_order_model.dart';
import '../../data/providers/lens_sale_order_provider.dart';
import '../../../masters/data/providers/account_provider.dart';
import '../../../masters/data/providers/tax_category_provider.dart';
import '../../../masters/data/providers/inventory_providers.dart';
import '../../../masters/data/providers/account_wise_price_provider.dart';
import '../../../masters/data/models/tax_category_model.dart';
import '../../../masters/data/models/account_model.dart';
import '../widgets/bulk_lens_matrix_modal.dart';
import '../widgets/lens_order_grid_widget.dart';

class AddLensSaleOrderPage extends StatefulWidget {
  final String? orderId; // For editing

  const AddLensSaleOrderPage({super.key, this.orderId});

  @override
  State<AddLensSaleOrderPage> createState() => _AddLensSaleOrderPageState();
}

class _AddLensSaleOrderPageState extends State<AddLensSaleOrderPage> {
  // --- Form State ---
  SaleOrderBillData _billData = const SaleOrderBillData(godown: 'HO');
  SaleOrderPartyData _partyData = const SaleOrderPartyData();
  List<SaleOrderItem> _items = List.generate(5, (index) => const SaleOrderItem());
  List<SaleOrderTax> _taxes = [];
  String _remark = '';
  String _status = 'Pending';
  double _paidAmount = 0.0;

  // --- Calculations ---
  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalAmount);
  double get taxesAmount => _taxes.fold(0.0, (sum, tax) => sum + tax.amount);
  double get netAmount => subtotal + taxesAmount;
  double get dueAmount => netAmount - _paidAmount;

  // --- Controllers & Focus ---
  final TextEditingController _partyController = TextEditingController();
  final FocusNode _partyFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _billData = _billData.copyWith(date: DateFormat('yyyy-MM-dd').format(DateTime.now()));
    if (widget.orderId != null) {
      _loadOrder();
    }
  }

  Future<void> _loadOrder() async {
    // Implement loading existing order logic
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
    setState(() {
      // Logic adjusted to flat discount to match React reference
      final total = (newItem.qty * newItem.salePrice) - newItem.discount;
      _items[index] = newItem.copyWith(totalAmount: total);
    });
    _calculateTotals();
  }

  void _onTaxCategorySelected(dynamic taxCat) {
    setState(() {
      _billData = _billData.copyWith(billType: taxCat.name);
      _taxes = [];
      
      // CGST
      if (taxCat.localTax1 > 0) {
        _taxes.add(SaleOrderTax(taxName: 'CGST', percentage: taxCat.localTax1.toDouble()));
      }
      // SGST
      if (taxCat.localTax2 > 0) {
        _taxes.add(SaleOrderTax(taxName: 'SGST', percentage: taxCat.localTax2.toDouble()));
      }
      // IGST
      if (taxCat.centralTax > 0) {
        _taxes.add(SaleOrderTax(taxName: 'IGST', percentage: taxCat.centralTax.toDouble()));
      }
    });
    _calculateTotals();
  }

  void _addItemsFromBulk(List<SaleOrderItem> newMappedItems) {
    setState(() {
      // Filter out empty rows from current items
      final existingItems = _items.where((it) => it.itemName.isNotEmpty || it.qty > 0).toList();
      _items = [...existingItems, ...newMappedItems];
      
      // Ensure at least 5 rows
      if (_items.length < 5) {
        _items.addAll(List.generate(5 - _items.length, (index) => const SaleOrderItem()));
      }
    });
    _calculateTotals();
  }

  void _selectParty(dynamic acc) {
    setState(() {
      _partyData = SaleOrderPartyData(
        id: acc.id,
        partyAccount: acc.name,
        address: acc.address ?? '',
        contactNumber: acc.mobileNumber ?? '',
        stateCode: acc.state ?? '',
        creditLimit: acc.creditLimit?.toDouble() ?? 0.0,
        creditDays: acc.creditDays ?? 0,
        accountCategory: acc.accountCategory ?? '',
      );
      _partyController.text = acc.name;
    });

    // Fetch next bill number for this party
    final provider = context.read<LensSaleOrderProvider>();
    provider.getNextBillNumberForParty(acc.name).then((val) {
      setState(() {
        _billData = _billData.copyWith(billNo: val);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Column(
        children: [
          // TopBar / Breadcrumbs
          _buildTopBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Bill Details Section
                  _buildBillSection(),
                  const SizedBox(height: 16),
                  // Party Section
                  _buildPartySection(),
                  const SizedBox(height: 16),
                  // Items Table Section
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
                         _items = newItems;
                         _calculateTotals();
                      });
                    },
                    onAddItems: _addItemsFromBulk,
                  ),
                  const SizedBox(height: 16),
                  // Bottom Section (Remarks, Taxes, Totals)
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
          // Action Buttons
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
              const Icon(Icons.shopping_cart_outlined, color: Color(0xFF2563EB), size: 20),
              const SizedBox(width: 8),
              const Text('Lens Sale Order', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(99)),
                child: const Text('Add New', style: TextStyle(color: Color(0xFF1E4ED8), fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.list, size: 16),
            label: const Text('View All Orders'),
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
            const Text('Bill Selection', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF64748B))),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildFormField('Series', _billData.billSeries, (val) => setState(() => _billData = _billData.copyWith(billSeries: val))),
                const SizedBox(width: 12),
                _buildFormField('Bill No', _billData.billNo, (val) => setState(() => _billData = _billData.copyWith(billNo: val)), isReadOnly: true),
                const SizedBox(width: 12),
                _buildFormField('Date', _billData.date ?? '', (val) => setState(() => _billData = _billData.copyWith(date: val))),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('BILL TYPE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8))),
                      const SizedBox(height: 4),
                      Autocomplete<TaxCategoryModel>(
                        optionsBuilder: (textEditingValue) {
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
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                            ),
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                _buildFormField('Godown', _billData.godown, (val) => setState(() => _billData = _billData.copyWith(godown: val))),
                const SizedBox(width: 12),
                _buildFormField('Booked By', _billData.bookedBy, (val) => setState(() => _billData = _billData.copyWith(bookedBy: val))),
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
            const Text('Party Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF64748B))),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Search Party', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
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
                Expanded(child: _buildReadOnlyInfo('Balance', '${_partyData.currentBalance.amount} ${_partyData.currentBalance.type}')),
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
        if (textEditingValue.text.isEmpty) return const Iterable.empty();
        final accounts = context.read<AccountProvider>().accounts;
        if (accounts.isEmpty) await context.read<AccountProvider>().fetchAllAccounts();
        return context.read<AccountProvider>().accounts.where((acc) => (acc.name ?? '').toLowerCase().contains(textEditingValue.text.toLowerCase()));
      },
      displayStringForOption: (acc) => acc.name ?? '',
      onSelected: _selectParty,
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: 'Type party name...',
            prefixIcon: const Icon(Icons.search, size: 16),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
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
              decoration: InputDecoration(
                hintText: 'Enter internal notes or customer requests...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
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
            _buildTotalRow('Grand Total', netAmount.toStringAsFixed(2), isBold: true, color: const Color(0xFF1E293B), fontSize: 16),
            const SizedBox(height: 12),
            _buildTotalRow('Paid Amount', ''), // TextField here
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
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              decoration: InputDecoration(contentPadding: const EdgeInsets.symmetric(horizontal: 8), border: OutlineInputBorder(borderRadius: BorderRadius.circular(6))),
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
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.rotate_left),
            label: const Text('Reset Form'),
            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16)),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: _saveOrder,
            icon: const Icon(Icons.save),
            label: const Text('Save Sale Order'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E293B),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  void _saveOrder() async {
    final provider = context.read<LensSaleOrderProvider>();
    final List<SaleOrderItem> filledItems = _items.where((it) => it.itemName.isNotEmpty && it.qty > 0).toList();

    if (filledItems.isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please add at least one item')));
       return;
    }

    if (_partyData.partyAccount.isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a party')));
       return;
    }

    final order = LensSaleOrderModel(
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
    );

    final res = await provider.createOrder(order.toJson());
    if (res['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order saved successfully')));
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
