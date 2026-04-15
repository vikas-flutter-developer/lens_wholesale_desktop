import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:lens_wholesale_desktop/features/sales/data/models/sale_return_model.dart';
import 'package:lens_wholesale_desktop/features/sales/data/models/rx_sale_order_model.dart';
import 'package:lens_wholesale_desktop/features/sales/data/models/lens_sale_order_model.dart';
import 'package:lens_wholesale_desktop/features/sales/data/providers/sale_return_provider.dart';
import 'package:lens_wholesale_desktop/features/masters/data/providers/account_provider.dart';
import 'package:lens_wholesale_desktop/features/masters/data/providers/tax_category_provider.dart';
import 'package:lens_wholesale_desktop/features/masters/data/models/tax_category_model.dart';
import 'package:lens_wholesale_desktop/features/masters/data/models/account_model.dart';
import 'package:lens_wholesale_desktop/features/sales/presentation/widgets/sale_return_grid_widget.dart';
import 'package:lens_wholesale_desktop/features/sales/presentation/widgets/sale_item_selection_modal.dart';

class AddRxSaleReturnPage extends StatefulWidget {
  final String? returnId;

  const AddRxSaleReturnPage({super.key, this.returnId});

  @override
  State<AddRxSaleReturnPage> createState() => _AddRxSaleReturnPageState();
}

class _AddRxSaleReturnPageState extends State<AddRxSaleReturnPage> {
  SaleOrderBillData _billData = const SaleOrderBillData(godown: 'Main Store', billSeries: 'RXSR');
  SaleOrderPartyData _partyData = const SaleOrderPartyData();
  List<RxOrderItem> _items = [];
  List<SaleOrderTax> _taxes = [];
  String _remark = '';
  String _status = 'Pending';
  double _paidAmount = 0.0;

  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalAmount);
  double get taxesAmount => _taxes.fold(0.0, (sum, tax) => sum + tax.amount);
  double get netAmount => subtotal + taxesAmount;

  final TextEditingController _partyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _billData = _billData.copyWith(date: DateFormat('yyyy-MM-dd').format(DateTime.now()));
    if (widget.returnId != null) {
      _loadReturn();
    }
  }

  Future<void> _loadReturn() async {
    final provider = context.read<SaleReturnProvider>();
    final sr = await provider.fetchReturnById(widget.returnId!, isRx: true);
    if (sr != null && mounted) {
      setState(() {
        _billData = sr.billData;
        _partyData = sr.partyData;
        _items = List.from(sr.items);
        _taxes = List.from(sr.taxes);
        _paidAmount = sr.paidAmount;
        _remark = sr.remark ?? '';
        _status = sr.status;
        _partyController.text = sr.partyData.partyAccount;
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
        accountCategory: acc.accountCategory ?? '',
      );
      _partyController.text = acc.name ?? '';
      _items = [];
    });

    final provider = context.read<SaleReturnProvider>();
    provider.getNextBillNumberForParty(acc.name ?? '').then((val) {
      if (mounted) setState(() => _billData = _billData.copyWith(billNo: val));
    });
  }

  void _showItemSelection() async {
    if (_partyData.partyAccount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a party first')));
      return;
    }

    final List<RxOrderItem>? selected = await showDialog<List<RxOrderItem>>(
      context: context,
      builder: (context) => SaleItemSelectionModal(partyAccount: _partyData.partyAccount),
    );

    if (selected != null && mounted) {
      setState(() {
        _items = [..._items, ...selected];
        _calculateTotals();
      });
    }
  }

  void _saveReturn() async {
    final provider = context.read<SaleReturnProvider>();
    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please add at least one item')));
      return;
    }

    final sr = SaleReturnModel(
      id: widget.returnId,
      billData: _billData,
      partyData: _partyData,
      items: _items,
      taxes: _taxes,
      paidAmount: _paidAmount,
      subtotal: subtotal,
      taxesAmount: taxesAmount,
      netAmount: netAmount,
      remark: _remark,
      status: _status,
      type: 'RX SALE RETURN',
    );

    final res = widget.returnId != null
        ? await provider.editReturn(widget.returnId!, sr.toJson(), isRx: true)
        : await provider.createReturn(sr.toJson(), isRx: true);

    if (res['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('RX Sale Return saved successfully')));
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
                  SaleReturnGridWidget(
                    isRx: true,
                    items: _items,
                    customPrices: const {},
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
              const Icon(LucideIcons.repeat, color: Color(0xFF8B5CF6), size: 20),
              const SizedBox(width: 8),
              const Text('Add RX Prescription Return', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFFF5F3FF), borderRadius: BorderRadius.circular(99)),
                child: const Text('RX Return', style: TextStyle(color: Color(0xFF7C3AED), fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: _showItemSelection,
            icon: const Icon(LucideIcons.search, size: 16),
            label: const Text('Select from Sales'),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E293B), foregroundColor: Colors.white),
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
    return Card(elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFE2E8F0))), child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [_buildTotalRow('Subtotal', subtotal.toStringAsFixed(2)), const Divider(), ..._taxes.map((t) => _buildTotalRow(t.taxName, t.amount.toStringAsFixed(2))), const Divider(), _buildTotalRow('Return Amount', netAmount.toStringAsFixed(2), isBold: true, color: const Color(0xFF7C3AED)), _buildTotalRow('Paid/Adjusted', ''), _buildTotalRow('Due to Customer', (netAmount - _paidAmount).toStringAsFixed(2), color: Colors.green)])));
  }

  Widget _buildTotalRow(String label, String value, {bool isBold = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        if (label == 'Paid/Adjusted')
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
            onPressed: _saveReturn,
            icon: const Icon(LucideIcons.save),
            label: const Text('Save RX Return'),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7C3AED), foregroundColor: Colors.white),
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
