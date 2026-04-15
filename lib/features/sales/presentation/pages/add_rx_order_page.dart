import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../data/models/rx_sale_order_model.dart';
import '../../data/models/lens_sale_order_model.dart';
import '../../data/providers/rx_sale_order_provider.dart';
import '../../../masters/data/providers/account_provider.dart';
import '../../../masters/data/providers/tax_category_provider.dart';
import '../../../masters/data/models/tax_category_model.dart';
import '../../../masters/data/models/account_model.dart';
import '../../../masters/data/providers/account_wise_price_provider.dart';
import '../widgets/rx_order_grid_widget.dart';

class AddRxOrderPage extends StatefulWidget {
  final String? orderId;

  const AddRxOrderPage({super.key, this.orderId});

  @override
  State<AddRxOrderPage> createState() => _AddRxOrderPageState();
}

class _AddRxOrderPageState extends State<AddRxOrderPage> {
  SaleOrderBillData _billData = const SaleOrderBillData(godown: 'Main Store', billSeries: 'RXS');
  SaleOrderPartyData _partyData = const SaleOrderPartyData();
  List<RxOrderItem> _items = List.generate(5, (index) => const RxOrderItem());
  List<SaleOrderTax> _taxes = [];
  String _remark = '';
  String _status = 'Pending';
  double _paidAmount = 0.0;
  Map<String, dynamic> _customPrices = {};

  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalAmount);
  double get taxesAmount => _taxes.fold(0.0, (sum, tax) => sum + tax.amount);
  double get netAmount => subtotal + taxesAmount;
  double get dueAmount => netAmount - _paidAmount;

  final TextEditingController _partyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _billData = _billData.copyWith(date: DateFormat('yyyy-MM-dd').format(DateTime.now()));
    if (widget.orderId != null) {
      _loadOrder();
    }
  }

  Future<void> _loadOrder() async {
    final provider = context.read<RxSaleOrderProvider>();
    final order = await provider.fetchOrderById(widget.orderId!);
    if (order != null && mounted) {
      setState(() {
        _billData = order.billData;
        _partyData = order.partyData;
        _items = List.from(order.items);
        if (_items.length < 5) {
          _items.addAll(List.generate(5 - _items.length, (index) => const RxOrderItem()));
        }
        _taxes = List.from(order.taxes);
        _paidAmount = order.paidAmount;
        _remark = order.remark ?? '';
        _status = order.status;
        _partyController.text = order.partyData.partyAccount;
      });
    }
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

  void _onTaxCategorySelected(dynamic taxCat) {
    setState(() {
      _billData = _billData.copyWith(billType: taxCat.name);
      _taxes = [];
      if (taxCat.localTax1 > 0) _taxes.add(SaleOrderTax(taxName: 'CGST', percentage: taxCat.localTax1.toDouble()));
      if (taxCat.localTax2 > 0) _taxes.add(SaleOrderTax(taxName: 'SGST', percentage: taxCat.localTax2.toDouble()));
      if (taxCat.centralTax > 0) _taxes.add(SaleOrderTax(taxName: 'IGST', percentage: taxCat.centralTax.toDouble()));
      if (taxCat.cessTax > 0) _taxes.add(SaleOrderTax(taxName: 'CESS', percentage: taxCat.cessTax.toDouble()));
    });
    _calculateTotals();
  }

  void _selectParty(dynamic acc) async {
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
    });

    final provider = context.read<RxSaleOrderProvider>();
    provider.getNextBillNumberForParty(acc.name ?? '').then((val) {
      if (mounted) setState(() => _billData = _billData.copyWith(billNo: val));
    });

    final priceProv = context.read<AccountWisePriceProvider>();
    priceProv.getAccountWisePrices(acc.id ?? '', type: "Sale").then((prices) {
      if (mounted) {
        final Map<String, dynamic> priceMap = {};
        for (var p in prices) {
          final key = p['lensId']?.toString() ?? p['lensGroupId']?.toString() ?? '';
          if (key.isNotEmpty) priceMap[key] = p;
        }
        setState(() => _customPrices = priceMap);
      }
    });
  }

  void _saveOrder() async {
    final provider = context.read<RxSaleOrderProvider>();
    final List<RxOrderItem> filledItems = _items.where((it) => it.itemName.isNotEmpty && it.qty > 0).toList();

    if (filledItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please add at least one item')));
      return;
    }
    if (_partyData.partyAccount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a party')));
      return;
    }

    final hasInvalidRows = filledItems.any((it) => it.combinationId.isEmpty);
    if (hasInvalidRows) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Validation Error: One or more rows have invalid power combinations. Please fix before saving.')));
       return;
    }

    final order = RxSaleOrderModel(
      id: widget.orderId,
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

    final res = widget.orderId != null
        ? await provider.editOrder(widget.orderId!, order.toJson())
        : await provider.createOrder(order.toJson());

    if (res['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('RX Order saved successfully')));
      if (mounted) Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${res['message']}')));
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
                  RxOrderGridWidget(
                    items: _items,
                    selectedAccount: _partyData.id != null 
                        ? context.read<AccountProvider>().accounts.cast<AccountModel?>().firstWhere(
                            (a) => a?.id == _partyData.id, 
                            orElse: () => null,
                          )
                        : null,
                    customPrices: _customPrices,
                    onItemsChanged: (newItems) {
                      setState(() {
                         _items = newItems;
                         _calculateTotals();
                      });
                    },
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
              const Icon(LucideIcons.fileText, color: Color(0xFF6366F1), size: 20),
              const SizedBox(width: 8),
              const Text('Add RX Prescription Order', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(99)),
                child: const Text('RX Order', style: TextStyle(color: Color(0xFF4F46E5), fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.list, size: 16),
            label: const Text('View All orders'),
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
        child: Row(
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
                      return TextField(controller: controller, focusNode: focusNode, decoration: InputDecoration(isDense: true, contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), border: OutlineInputBorder(borderRadius: BorderRadius.circular(6))), style: const TextStyle(fontSize: 12));
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _buildFormField('Godown', _billData.godown, (val) => setState(() => _billData = _billData.copyWith(godown: val))),
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
                      Autocomplete<AccountModel>(
                        optionsBuilder: (textEditingValue) async {
                          if (textEditingValue.text.isEmpty) return const Iterable.empty();
                          final accounts = context.read<AccountProvider>().accounts;
                          if (accounts.isEmpty) await context.read<AccountProvider>().fetchAllAccounts();
                          return context.read<AccountProvider>().accounts.where((acc) => (acc.name ?? '').toLowerCase().contains(textEditingValue.text.toLowerCase()));
                        },
                        displayStringForOption: (acc) => acc.name ?? '',
                        onSelected: _selectParty,
                        fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                          if (_partyController.text.isNotEmpty && !focusNode.hasFocus) controller.text = _partyController.text;
                          return TextField(controller: controller, focusNode: focusNode, decoration: InputDecoration(hintText: 'Type party...', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))), onEditingComplete: onFieldSubmitted);
                        },
                      ),
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
            onPressed: _saveOrder,
            icon: const Icon(Icons.save),
            label: const Text('Save RX Order'),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1), foregroundColor: Colors.white),
          ),
        ],
      ),
    );
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
