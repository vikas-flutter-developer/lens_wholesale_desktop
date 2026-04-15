import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import 'package:lens_wholesale_desktop/features/purchases/data/models/purchase_model.dart';
import 'package:lens_wholesale_desktop/features/purchases/data/providers/purchase_provider.dart';
import 'package:lens_wholesale_desktop/features/masters/data/providers/account_provider.dart';
import 'package:lens_wholesale_desktop/features/masters/data/providers/tax_category_provider.dart';
import 'package:lens_wholesale_desktop/features/masters/data/models/account_model.dart';
import '../widgets/purchase_grid_widget.dart';

class AddRxPurchasePage extends StatefulWidget {
  final PurchaseModel? initialData;
  const AddRxPurchasePage({super.key, this.initialData});

  @override
  State<AddRxPurchasePage> createState() => _AddRxPurchasePageState();
}

class _AddRxPurchasePageState extends State<AddRxPurchasePage> {
  late PurchaseModel _model;
  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    _isEdit = widget.initialData != null;
    _model = widget.initialData ?? PurchaseModel(
      billData: PurchaseBillData(
        billSeries: 'RXP',
        date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        godown: 'HO',
      ),
      orderType: 'RX',
      items: [PurchaseItem()],
    );

    if (!_isEdit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<AccountProvider>().fetchAllAccounts();
        context.read<TaxCategoryProvider>().fetchAllTaxCategories();
      });
    }
  }

  void _updateModel(PurchaseModel newModel) {
    setState(() => _model = newModel);
  }

  Future<void> _handleSave() async {
    if (_model.partyData.partyAccount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a vendor")));
      return;
    }
    if (_model.items.every((it) => it.itemName.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please add at least one item")));
      return;
    }

    final res = await context.read<PurchaseProvider>().createRxOrder(_model.toJson());
    if (res['success'] == true) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Rx Purchase Order Saved Successfully")));
        context.pop();
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
        title: Text(_isEdit ? "Edit Rx Purchase Order" : "New Rx Purchase Order", 
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton.icon(
              onPressed: _handleSave,
              icon: const Icon(LucideIcons.save, size: 18),
              label: const Text("Save Rx PO"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTopSection(),
            const SizedBox(height: 24),
            PurchaseGridWidget(
              items: _model.items,
              selectedAccount: null, // Vendor accounts handled differently here
              onItemsChanged: (items) {
                final net = items.fold<double>(0.0, (sum, it) => sum + it.totalAmount);
                _updateModel(_model.copyWith(items: items, netAmount: net, dueAmount: net - _model.paidAmount));
              },
              onAddItems: (newItems) {
                final combined = [..._model.items, ...newItems]..removeWhere((it) => it.itemName.isEmpty);
                final net = combined.fold<double>(0.0, (sum, it) => sum + it.totalAmount);
                _updateModel(_model.copyWith(items: combined, netAmount: net, dueAmount: net - _model.paidAmount));
              },
            ),
            const SizedBox(height: 24),
            _buildSummarySection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: _buildBillInfoCard()),
        const SizedBox(width: 24),
        Expanded(flex: 2, child: _buildVendorCard()),
      ],
    );
  }

  Widget _buildBillInfoCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Color(0xFFE2E8F0))),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(children: [Icon(LucideIcons.receipt, size: 18, color: Colors.blue), SizedBox(width: 8), Text("Purchase Details", style: TextStyle(fontWeight: FontWeight.bold))]),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _buildInputLabel("Bill Series", TextField(
                  controller: TextEditingController(text: _model.billData.billSeries),
                  onChanged: (v) => _updateModel(_model.copyWith(billData: _model.billData.copyWith(billSeries: v))),
                  decoration: _inputDeco("Series"),
                ))),
                const SizedBox(width: 16),
                Expanded(child: _buildInputLabel("Bill No", TextField(
                  controller: TextEditingController(text: _model.billData.billNo),
                  readOnly: true,
                  decoration: _inputDeco("Auto"),
                ))),
                const SizedBox(width: 16),
                Expanded(child: _buildInputLabel("Date", TextField(
                  controller: TextEditingController(text: _model.billData.date),
                  onTap: () async {
                    final d = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
                    if (d != null) _updateModel(_model.copyWith(billData: _model.billData.copyWith(date: DateFormat('yyyy-MM-dd').format(d))));
                  },
                  readOnly: true,
                  decoration: _inputDeco("YYYY-MM-DD", suffix: const Icon(LucideIcons.calendar, size: 16)),
                ))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVendorCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Color(0xFFE2E8F0))),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Row(children: [Icon(LucideIcons.user, size: 18, color: Colors.blue), SizedBox(width: 8), Text("Vendor Details", style: TextStyle(fontWeight: FontWeight.bold))]),
            const SizedBox(height: 20),
            Consumer<AccountProvider>(
              builder: (context, accProv, child) {
                final vendors = accProv.accounts; // Should filter for vendors if needed
                return Autocomplete<AccountModel>(
                  displayStringForOption: (acc) => acc.name,
                  optionsBuilder: (text) => vendors.where((a) => a.name.toLowerCase().contains(text.text.toLowerCase())),
                  onSelected: (acc) async {
                    final nextNo = await context.read<PurchaseProvider>().getNextRxPONumber(acc.name);
                    _updateModel(_model.copyWith(
                      partyData: PurchasePartyData(
                        partyAccount: acc.name,
                        address: acc.address ?? '',
                        contactNumber: acc.mobileNumber ?? '',
                        stateCode: acc.state ?? '',
                      ),
                      billData: _model.billData.copyWith(billNo: nextNo),
                    ));
                  },
                  fieldViewBuilder: (ctx, ctrl, focus, onFieldSubmitted) {
                    if (ctrl.text.isEmpty && _model.partyData.partyAccount.isNotEmpty) ctrl.text = _model.partyData.partyAccount;
                    return TextField(
                      controller: ctrl,
                      focusNode: focus,
                      decoration: _inputDeco("Search Vendor...", icon: LucideIcons.search),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Color(0xFFE2E8F0))),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildSummaryItem("Net Amount", "₹${_model.netAmount.toStringAsFixed(2)}", isBold: true),
                const SizedBox(width: 48),
                _buildSummaryItem("Paid Amount", "", 
                  child: SizedBox(
                    width: 120,
                    child: TextField(
                      textAlign: TextAlign.right,
                      onChanged: (v) {
                        final val = double.tryParse(v) ?? 0;
                        _updateModel(_model.copyWith(paidAmount: val, dueAmount: _model.netAmount - val));
                      },
                      decoration: _inputDeco("0.00"),
                    ),
                  )
                ),
                const SizedBox(width: 48),
                _buildSummaryItem("Due Balance", "₹${_model.dueAmount.toStringAsFixed(2)}", color: Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, {bool isBold = false, Color? color, Widget? child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.blueGrey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        child ?? Text(value, style: TextStyle(fontSize: 18, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: color)),
      ],
    );
  }

  Widget _buildInputLabel(String label, Widget child) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
      const SizedBox(height: 8),
      child,
    ]);
  }

  InputDecoration _inputDeco(String hint, {IconData? icon, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon, size: 16) : null,
      suffixIcon: suffix,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2)),
    );
  }
}
