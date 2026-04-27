import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:lens_wholesale_desktop/features/purchases/data/models/purchase_model.dart';
import 'package:lens_wholesale_desktop/features/purchases/data/providers/purchase_provider.dart';
import 'package:lens_wholesale_desktop/features/masters/data/providers/account_provider.dart';
import 'package:lens_wholesale_desktop/features/masters/data/providers/tax_category_provider.dart';
import 'package:lens_wholesale_desktop/features/masters/data/models/account_model.dart';
import 'package:lens_wholesale_desktop/features/purchases/presentation/widgets/purchase_grid_widget.dart';

class AddPurchaseOrderPage extends StatefulWidget {
  final String? orderId;
  final List<PurchaseItem>? initialItems;

  const AddPurchaseOrderPage({super.key, this.orderId, this.initialItems});

  @override
  State<AddPurchaseOrderPage> createState() => _AddPurchaseOrderPageState();
}

class _AddPurchaseOrderPageState extends State<AddPurchaseOrderPage> {
  PurchaseBillData _billData = const PurchaseBillData(godown: 'HO');
  PurchasePartyData _partyData = const PurchasePartyData();
  List<PurchaseItem> _items = List.generate(1, (index) => const PurchaseItem());
  List<PurchaseTax> _taxes = [];
  String _remark = '';
  String _status = 'Pending';
  double _paidAmount = 0.0;

  double get subtotal => _items.fold<double>(0.0, (sum, item) => sum + item.totalAmount);
  double get taxesAmount => _taxes.fold<double>(0.0, (sum, tax) => sum + tax.amount);
  double get netAmount => subtotal + taxesAmount;

  final TextEditingController _partyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _billData = _billData.copyWith(date: DateFormat('yyyy-MM-dd').format(DateTime.now()));
    if (widget.initialItems != null) {
      _items = widget.initialItems!;
    }
    if (widget.orderId != null) _loadOrder();
  }

  Future<void> _loadOrder() async {
    final order = await context.read<PurchaseProvider>().fetchPOById(widget.orderId!);
    if (order != null) {
      setState(() {
        _billData = order.billData;
        _partyData = order.partyData;
        _items = order.items;
        _taxes = order.taxes;
        _remark = order.remark ?? '';
        _status = order.status;
        _paidAmount = order.paidAmount;
        _partyController.text = _partyData.partyAccount;
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

  void _onAccountSelected(AccountModel acc) async {
    final nextNo = await context.read<PurchaseProvider>().getNextPONumber(acc.name);
    setState(() {
      _partyData = PurchasePartyData(
        partyAccount: acc.name,
        contactNumber: acc.mobileNumber ?? "",
        address: acc.address ?? "",
        stateCode: acc.state ?? "",
        creditLimit: acc.creditLimit ?? 0.0,
      );
      _billData = _billData.copyWith(billNo: nextNo);
      _partyController.text = acc.name;
    });
  }

  void _onTaxCategorySelected(dynamic taxCat) {
    setState(() {
      _billData = _billData.copyWith(billType: taxCat.name);
      _taxes = [
        if (taxCat.localTax1 > 0) PurchaseTax(taxName: 'CGST', percentage: taxCat.localTax1.toDouble()),
        if (taxCat.localTax2 > 0) PurchaseTax(taxName: 'SGST', percentage: taxCat.localTax2.toDouble()),
        if (taxCat.centralTax > 0) PurchaseTax(taxName: 'IGST', percentage: taxCat.centralTax.toDouble()),
      ];
    });
    _calculateTotals();
  }

  Future<void> _saveOrder() async {
    if (_partyData.partyAccount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a vendor")));
      return;
    }
    
    final validItems = _items.where((it) => it.itemName.isNotEmpty && it.qty > 0).toList();
    if (validItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please add at least one item")));
      return;
    }

    final order = PurchaseModel(
      id: widget.orderId,
      billData: _billData,
      partyData: _partyData,
      items: validItems,
      taxes: _taxes,
      subtotal: subtotal,
      taxesAmount: taxesAmount,
      netAmount: netAmount,
      paidAmount: _paidAmount,
      dueAmount: netAmount - _paidAmount,
      remark: _remark,
      status: _status,
      orderType: 'LENS',
    );

    final res = await context.read<PurchaseProvider>().createPurchaseOrder(order.toJson());
    if (res['success'] == true) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Purchase Order Saved Successfully")));
        Navigator.pop(context);
      }
    } else {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${res['message']}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(widget.orderId == null ? "Add Purchase Order" : "Edit Purchase Order", style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton.icon(
              onPressed: _saveOrder,
              icon: const Icon(LucideIcons.save, size: 18),
              label: const Text("Save Order"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[600], foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildHeaderSection(),
            const SizedBox(height: 24),
            PurchaseGridWidget(
              items: _items,
              onItemsChanged: (newList) => setState(() { _items = newList; _calculateTotals(); }),
              onAddItems: (newItems) => setState(() { _items.addAll(newItems); _calculateTotals(); }),
            ),
            const SizedBox(height: 24),
            _buildFooterSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: _buildCard(title: "Vendor Details", child: _buildPartyForm())),
        const SizedBox(width: 24),
        Expanded(flex: 2, child: _buildCard(title: "Order Details", child: _buildBillForm())),
      ],
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
        const SizedBox(height: 20),
        child,
      ]),
    );
  }

  Widget _buildPartyForm() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _partyController,
                readOnly: true,
                onTap: _showAccountSelector,
                decoration: InputDecoration(labelText: "Vendor Account", prefixIcon: const Icon(LucideIcons.user, size: 18), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildInfoField("Contact", _partyData.contactNumber)),
            const SizedBox(width: 16),
            Expanded(child: _buildInfoField("State", _partyData.stateCode)),
          ],
        ),
      ],
    );
  }

  Widget _buildBillForm() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildReadField("Series", _billData.billSeries)),
            const SizedBox(width: 12),
            Expanded(child: _buildReadField("Order No", _billData.billNo)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildReadField("Date", _billData.date ?? "")),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                readOnly: true,
                onTap: _showTaxSelector,
                decoration: InputDecoration(labelText: "Bill Type", hintText: _billData.billType, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooterSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: _buildCard(title: "Remarks", child: TextField(maxLines: 4, onChanged: (v) => _remark = v, decoration: const InputDecoration(hintText: "Internal order notes...", border: InputBorder.none)))),
        const SizedBox(width: 24),
        Expanded(flex: 2, child: _buildSummaryCard()),
      ],
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.blue[900], borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          _summaryRow("Subtotal", subtotal),
          ..._taxes.map((t) => _summaryRow(t.taxName, t.amount)),
          const Divider(color: Colors.white24, height: 32),
          _summaryRow("Net Amount", netAmount, isTotal: true),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, double value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: isTotal ? Colors.white : Colors.white70, fontSize: isTotal ? 16 : 13, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text("₹${value.toStringAsFixed(2)}", style: TextStyle(color: Colors.white, fontSize: isTotal ? 20 : 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildInfoField(String label, String value) => TextFormField(initialValue: value, key: Key(value), readOnly: true, decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), filled: true, fillColor: Colors.grey[50]));
  Widget _buildReadField(String label, String value) => TextFormField(initialValue: value, readOnly: true, decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))));

  void _showAccountSelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Select Vendor"),
        content: SizedBox(
          width: 400,
          child: Consumer<AccountProvider>(
            builder: (context, provider, _) => ListView.builder(
              shrinkWrap: true,
              itemCount: provider.accounts.length,
              itemBuilder: (context, index) {
                final acc = provider.accounts[index];
                return ListTile(title: Text(acc.name), subtitle: Text(acc.mobileNumber ?? ""), onTap: () { _onAccountSelected(acc); Navigator.pop(context); });
              },
            ),
          ),
        ),
      ),
    );
  }

  void _showTaxSelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Select Bill Type"),
        content: SizedBox(
          width: 400,
          child: Consumer<TaxCategoryProvider>(
            builder: (context, provider, _) => ListView.builder(
              shrinkWrap: true,
              itemCount: provider.taxCategories.length,
              itemBuilder: (context, index) {
                final tc = provider.taxCategories[index];
                return ListTile(title: Text(tc.name), onTap: () { _onTaxCategorySelected(tc); Navigator.pop(context); });
              },
            ),
          ),
        ),
      ),
    );
  }
}
