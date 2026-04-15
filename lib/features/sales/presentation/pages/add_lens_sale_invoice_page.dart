import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../data/models/lens_sale_invoice_model.dart';
import '../../data/models/lens_sale_order_model.dart';
import '../../data/providers/lens_sale_invoice_provider.dart';
import '../../data/providers/lens_sale_challan_provider.dart';
import '../../../masters/data/providers/account_provider.dart';
import '../../../masters/data/providers/tax_category_provider.dart';
import '../../../masters/data/models/tax_category_model.dart';
import '../../../masters/data/models/account_model.dart';
import '../widgets/lens_order_grid_widget.dart';
import '../widgets/load_sale_challans_modal.dart';

class AddLensSaleInvoicePage extends StatefulWidget {
  final String? invoiceId;

  const AddLensSaleInvoicePage({super.key, this.invoiceId});

  @override
  State<AddLensSaleInvoicePage> createState() => _AddLensSaleInvoicePageState();
}

class _AddLensSaleInvoicePageState extends State<AddLensSaleInvoicePage> {
  SaleOrderBillData _billData = const SaleOrderBillData(godown: 'HO');
  SaleOrderPartyData _partyData = const SaleOrderPartyData();
  List<SaleOrderItem> _items = List.generate(5, (index) => const SaleOrderItem());
  List<SaleOrderTax> _taxes = [];
  String _remark = '';
  String _status = 'Pending';
  double _paidAmount = 0.0;
  String? _sourceSaleId;

  Map<String, Map<String, dynamic>> _validBarcodes = {};

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
    if (widget.invoiceId != null) {
      _loadInvoice();
    }
  }

  Future<void> _loadInvoice() async {
    // Implement loading logic when edit needed
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
    
    if (newItem.barcode.isNotEmpty && _validBarcodes.containsKey(newItem.barcode)) {
        final match = _validBarcodes[newItem.barcode]!;
        
        int existingIndex = _items.indexWhere((it) => it.barcode == newItem.barcode && it != newItem);
        if (existingIndex != -1) {
            int nextQty = _items[existingIndex].qty + 1;
            if (nextQty > (match['qty'] as int)) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Quantity Limit Exceeded. Only ${match['qty']} allowed.')));
                setState(() { _items[index] = newItem.copyWith(barcode: ''); });
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
                id: match['_id'],
              );
            });
            _calculateTotals();
            return;
        }
    } else if (newItem.barcode.isNotEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid Barcode for selected party.')));
       setState(() { _items[index] = newItem.copyWith(barcode: ''); });
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
      _validBarcodes = {};
    });

    final provider = context.read<LensSaleInvoiceProvider>();
    provider.getNextBillNumberForParty(acc.name ?? '').then((val) {
      if (mounted) setState(() => _billData = _billData.copyWith(billNo: val));
    });

    final chalProvider = context.read<LensSaleChallanProvider>();
    await chalProvider.fetchAllChallans();
    final pendingChallans = chalProvider.challans.where((c) =>
        c.partyData.partyAccount == acc.name && c.balQty > 0 && c.status.toLowerCase() != 'done' && c.status.toLowerCase() != 'received');
    
    final Map<String, Map<String, dynamic>> barcodesMap = {};
    for (var c in pendingChallans) {
      for (var item in c.items) {
        if (item.barcode.isNotEmpty) {
           final baseJson = item.toJson();
           baseJson['sourceOrderId'] = c.id;
           barcodesMap[item.barcode] = baseJson;
        }
      }
    }
    setState(() { _validBarcodes = barcodesMap; });
  }

  void _showLoadChallansModal() async {
    if (_partyData.partyAccount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a party first')));
      return;
    }

    final chalProvider = context.read<LensSaleChallanProvider>();
    await chalProvider.fetchAllChallans();
    final partyPendingChallans = chalProvider.challans.where((c) =>
        c.partyData.partyAccount == _partyData.partyAccount && c.balQty > 0 && c.status.toLowerCase() != 'done' && c.status.toLowerCase() != 'received').toList();

    if (!mounted) return;

    final selectedItems = await showDialog<List<Map<String, dynamic>>>(
      context: context,
      builder: (context) => LoadSaleChallansModal(challans: partyPendingChallans, partyName: _partyData.partyAccount),
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
                  
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton.icon(
                      onPressed: isReadOnly ? null : _showLoadChallansModal,
                      icon: const Icon(LucideIcons.plus, size: 16),
                      label: const Text('Load Challans'),
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
              const Icon(LucideIcons.fileText, color: Color(0xFF2563EB), size: 20),
              const SizedBox(width: 8),
              const Text('Add Lens Sale Invoice', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(99)),
                child: const Text('Finalize', style: TextStyle(color: Color(0xFF1E4ED8), fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.list, size: 16),
            label: const Text('View All Invoices'),
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
            const Text('Invoice Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF64748B), letterSpacing: 1)),
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
          children: [
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
        return TextField(controller: controller, focusNode: focusNode, readOnly: isReadOnly, decoration: InputDecoration(hintText: 'Type party...', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))), onEditingComplete: onFieldSubmitted);
      },
    );
  }

  Widget _buildRemarksSection() {
    return Card(elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFE2E8F0))), child: Padding(padding: const EdgeInsets.all(16), child: TextField(maxLines: 4, decoration: const InputDecoration(hintText: 'Notes...', border: OutlineInputBorder()), onChanged: (v) => _remark = v)));
  }

  Widget _buildTotalsSection() {
    return Card(elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFE2E8F0))), child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [_buildTotalRow('Subtotal', subtotal.toStringAsFixed(2)), const Divider(), ..._taxes.map((t) => _buildTotalRow(t.taxName, t.amount.toStringAsFixed(2))), const Divider(), _buildTotalRow('Net Amount', netAmount.toStringAsFixed(2), isBold: true, color: const Color(0xFF1E4ED8)), _buildTotalRow('Paid Amount', ''), _buildTotalRow('Due Amount', dueAmount.toStringAsFixed(2), color: Colors.red)])));
  }

  Widget _buildTotalRow(String label, String value, {bool isBold = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        if (label == 'Paid Amount')
          SizedBox(width: 120, height: 32, child: TextField(textAlign: TextAlign.right, keyboardType: TextInputType.number, decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 8)), onChanged: (v) => setState(() => _paidAmount = double.tryParse(v) ?? 0.0)))
        else
          Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: color)),
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
           ElevatedButton.icon(
            onPressed: isReadOnly ? null : _saveInvoice,
            icon: const Icon(Icons.save),
            label: const Text('Publish Invoice'),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), foregroundColor: Colors.white),
          ),
        ],
      ),
    );
  }

  void _saveInvoice() async {
    final provider = context.read<LensSaleInvoiceProvider>();
    final List<SaleOrderItem> filledItems = _items.where((it) => it.itemName.isNotEmpty && it.qty > 0).toList();

    if (filledItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please add at least one item')));
      return;
    }
    if (_partyData.partyAccount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a party')));
      return;
    }

    final qtySum = filledItems.fold<int>(0, (sum, it) => sum + it.qty);

    final invoice = LensSaleInvoiceModel(
      billData: _billData,
      partyData: _partyData,
      items: filledItems,
      taxes: _taxes,
      invoiceQty: qtySum,
      paidAmount: _paidAmount,
      subtotal: subtotal,
      taxesAmount: taxesAmount,
      netAmount: netAmount,
      dueAmount: dueAmount,
      remark: _remark,
      status: _status,
      sourceSaleId: _sourceSaleId,
    );

    final res = await provider.createInvoice(invoice.toJson());
    if (res['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invoice saved successfully')));
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
          SizedBox(height: 36, child: TextField(readOnly: isReadOnly, controller: TextEditingController(text: value)..selection = TextSelection.fromPosition(TextPosition(offset: value.length)), decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(6))), onChanged: onChanged)),
        ],
      ),
    );
  }

  Widget _buildReadOnlyInfo(String label, String value) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label.toUpperCase(), style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8))), const SizedBox(height: 4), Text(value.isEmpty ? '-' : value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155)))]);
  }
}
