import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/inventory_provider.dart';
import '../../../masters/data/providers/inventory_providers.dart';
import '../../../masters/data/providers/account_provider.dart';
import '../../../masters/data/models/lens_group_model.dart';
import '../../../masters/data/models/account_model.dart';
import '../../data/models/damage_entry_model.dart';

class AddDamageEntryPage extends StatefulWidget {
  final String? editId;
  const AddDamageEntryPage({super.key, this.editId});

  @override
  State<AddDamageEntryPage> createState() => _AddDamageEntryPageState();
}

class _AddDamageEntryPageState extends State<AddDamageEntryPage> {
  // Header State
  String _billSeries = 'DMG';
  String _billNo = '';
  DateTime _date = DateTime.now();
  String _type = 'Damage';
  String _godown = 'HO';
  String _remark = '';

  // Items State
  List<DamageItemModel> _items = [const DamageItemModel()];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.editId != null) {
      _loadExistingEntry();
    } else {
      _fetchNextBillNo();
    }
    // Ensure data is loaded for autocompletes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LensGroupProvider>().fetchAllLensPower();
      context.read<AccountProvider>().fetchAllAccounts();
    });
  }

  Future<void> _fetchNextBillNo() async {
    final no = await context.read<InventoryProvider>().getNextDamageBillNo(_billSeries);
    setState(() => _billNo = no);
  }

  Future<void> _loadExistingEntry() async {
    setState(() => _isLoading = true);
    final res = await context.read<InventoryProvider>().getDamageEntry(widget.editId!);
    if (res['success'] == true && res['data'] != null) {
      final entry = DamageEntryModel.fromJson(res['data']);
      setState(() {
        _billSeries = entry.billSeries;
        _billNo = entry.billNo;
        _date = entry.date != null ? DateTime.parse(entry.date!) : DateTime.now();
        _type = entry.type;
        _godown = entry.godown;
        _remark = entry.remark;
        _items = entry.items.isEmpty ? [const DamageItemModel()] : entry.items;
      });
    }
    setState(() => _isLoading = false);
  }

  void _addItem() {
    setState(() {
      _items = [..._items, const DamageItemModel()];
    });
  }

  void _removeItem(int index) {
    if (_items.length <= 1) return;
    setState(() {
      _items = List.from(_items)..removeAt(index);
    });
  }

  void _updateItem(int index, DamageItemModel newItem) {
    setState(() {
      _items[index] = newItem;
    });
  }

  double get grandTotalQty => _items.fold(0, (sum, item) => sum + item.qty).toDouble();
  double get grandTotalAmt => _items.fold(0.0, (sum, item) => sum + item.totalAmt);

  Future<void> _handleSave() async {
    if (_billNo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bill No is required')));
      return;
    }

    final validItems = _items.where((it) => it.itemName.isNotEmpty).toList();
    if (validItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add at least one item')));
      return;
    }

    setState(() => _isLoading = true);
    final payload = {
      'billSeries': _billSeries,
      'billNo': _billNo,
      'date': _date.toIso8601String(),
      'type': _type,
      'godown': _godown,
      'remark': _remark,
      'items': validItems.map((e) => e.toJson()).toList(),
      'totalQty': grandTotalQty.toInt(),
      'totalAmt': grandTotalAmt,
    };

    final res = widget.editId != null
        ? await context.read<InventoryProvider>().updateDamageEntry(widget.editId!, payload)
        : await context.read<InventoryProvider>().saveDamageEntry(payload);

    setState(() => _isLoading = false);

    if (res['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.editId != null ? 'Entry updated successfully' : 'Entry saved successfully')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['error'] ?? 'Save failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading && widget.editId != null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.editId != null ? 'Edit Damage Entry' : 'Add Damage Entry',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              widget.editId != null ? 'Modify existing record' : 'Create a new damage / shrinkage record',
              style: TextStyle(fontSize: 12, color: Colors.blueGrey.shade300, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          if (_isLoading)
            const Center(child: Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Bill Header Card
            _buildHeaderCard(),
            const SizedBox(height: 24),

            // Items Table Card
            _buildItemsTable(),
            const SizedBox(height: 24),

            // Bottom Actions (Save Entry)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: _handleSave,
                  icon: const Icon(LucideIcons.save, size: 18),
                  label: Text(widget.editId != null ? 'Update Entry' : 'Save Entry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 100), // Space for bottom totals
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.blueGrey.shade100)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: _headerInput('Bill Series', _billSeries, (v) {
                _billSeries = v;
                _fetchNextBillNo();
              }),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _headerInput('Bill No', _billNo, (v) => setState(() => _billNo = v), readOnly: true),
            ),
            const SizedBox(width: 16),
            Expanded(child: _datePicker('Date', _date, (d) => setState(() => _date = d))),
            const SizedBox(width: 16),
            Expanded(child: _headerDropdown('Type', _type, ['Damage', 'Shrinkage'], (v) => setState(() => _type = v!))),
            const SizedBox(width: 16),
            Expanded(child: _headerDropdown('Godown', _godown, ['HO', 'Branch', 'Main Store', 'Branch Store'], (v) => setState(() => _godown = v!))),
            const SizedBox(width: 16),
            Expanded(child: _headerInput('Remark', _remark, (v) => _remark = v)),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsTable() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.blueGrey.shade100)),
      child: Column(
        children: [
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFEFF6FF), Color(0xFFF8FAFC)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              border: const Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Row(
              children: [
                const SizedBox(width: 40, child: Text('SN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                const SizedBox(width: 80, child: Text('CODE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                const Expanded(flex: 3, child: Text('ITEM NAME', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                const SizedBox(width: 12),
                const Expanded(flex: 3, child: Text('PARTY NAME', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                const SizedBox(width: 12),
                const SizedBox(width: 80, child: Text('ORDER NO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                const SizedBox(width: 60, child: Text('EYE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                const SizedBox(width: 50, child: Text('SPH', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                const SizedBox(width: 50, child: Text('CYL', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                const SizedBox(width: 50, child: Text('AXIS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                const SizedBox(width: 50, child: Text('ADD', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                const SizedBox(width: 50, child: Text('QTY', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                const SizedBox(width: 80, child: Text('PRICE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                const SizedBox(width: 100, child: Text('TOTAL AMT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                const SizedBox(width: 40),
                ElevatedButton.icon(
                  onPressed: _addItem,
                  icon: const Icon(LucideIcons.plus, size: 14),
                  label: const Text('Add Row'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF16A34A),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),

          // Table Rows
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _items.length,
            separatorBuilder: (c, i) => const Divider(height: 1),
            itemBuilder: (c, i) => _buildRow(i),
          ),

          // Add Row Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: _addItem,
                  icon: const Icon(LucideIcons.plus, size: 16, color: Color(0xFF2563EB)),
                  label: const Text('Add Row', style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold, fontSize: 13)),
                  style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8)),
                ),
                // Summary Totals
                Row(
                  children: [
                    _summaryLabel('Grand Total', ''),
                    const SizedBox(width: 8),
                    Text(
                      grandTotalQty.toInt().toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E40AF)),
                    ),
                    const SizedBox(width: 32),
                    Text(
                      '₹${grandTotalAmt.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E40AF)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(int index) {
    final item = _items[index];
    final sn = index + 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 40, child: Text('$sn', style: const TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold, fontSize: 11))),
          
          // Code
          SizedBox(
            width: 80,
            child: _gridInput(
              controller: TextEditingController(text: item.code), 
              onChanged: (v) => _updateItem(index, item.copyWith(code: v)),
              hint: '',
            ),
          ),
          const SizedBox(width: 8),

          // Item Name
          Expanded(
            flex: 3,
            child: Autocomplete<LensGroupModel>(
              initialValue: TextEditingValue(text: item.itemName),
              optionsBuilder: (textEditingValue) {
                final lenses = context.read<LensGroupProvider>().lensGroups;
                return lenses.where((l) => (l.productName).toLowerCase().contains(textEditingValue.text.toLowerCase()));
              },
              displayStringForOption: (l) => l.productName,
              onSelected: (l) {
                final price = double.tryParse(l.salePrice?['default']?.toString() ?? '0') ?? 0.0;
                _updateItem(index, item.copyWith(
                  itemName: l.productName,
                  price: price,
                  totalAmt: item.qty * price,
                  combinationId: l.id ?? '',
                ));
              },
              fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                return _gridInput(controller: controller, focusNode: focusNode, hint: '🔍  Search item...', hasIcon: true);
              },
            ),
          ),
          const SizedBox(width: 8),

          // Party Name
          Expanded(
            flex: 3,
            child: Autocomplete<AccountModel>(
              initialValue: TextEditingValue(text: item.partyName),
              optionsBuilder: (textEditingValue) {
                final accounts = context.read<AccountProvider>().accounts;
                return accounts.where((a) => (a.name ?? '').toLowerCase().contains(textEditingValue.text.toLowerCase()));
              },
              displayStringForOption: (a) => a.name ?? '',
              onSelected: (a) {
                _updateItem(index, item.copyWith(partyName: a.name ?? ''));
              },
              fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                return _gridInput(controller: controller, focusNode: focusNode, hint: '🔍  Search party...', hasIcon: true);
              },
            ),
          ),
          const SizedBox(width: 8),

          // Order No
          SizedBox(
            width: 80,
            child: _gridInput(
              controller: TextEditingController(text: item.orderNo),
              onChanged: (v) => _updateItem(index, item.copyWith(orderNo: v)),
              hint: '',
            ),
          ),
          const SizedBox(width: 8),

          // EYE
          SizedBox(
            width: 60,
            child: _gridDropdown(item.eye, ['', 'R', 'L', 'RL'], (v) => _updateItem(index, item.copyWith(eye: v!))),
          ),
          const SizedBox(width: 8),

          // SPH
          SizedBox(width: 50, child: _gridInputNumber(item.sph.toString(), (v) => _updateItem(index, item.copyWith(sph: double.tryParse(v) ?? 0.0)))),
          const SizedBox(width: 4),

          // CYL
          SizedBox(width: 50, child: _gridInputNumber(item.cyl.toString(), (v) => _updateItem(index, item.copyWith(cyl: double.tryParse(v) ?? 0.0)))),
          const SizedBox(width: 4),

          // Axis
          SizedBox(width: 50, child: _gridInputNumber(item.axis.toString(), (v) => _updateItem(index, item.copyWith(axis: double.tryParse(v) ?? 0.0)))),
          const SizedBox(width: 4),

          // Add
          SizedBox(width: 50, child: _gridInputNumber(item.add.toString(), (v) => _updateItem(index, item.copyWith(add: double.tryParse(v) ?? 0.0)))),
          const SizedBox(width: 8),

          // Qty
          SizedBox(
            width: 50,
            child: _gridInputNumber(item.qty.toString(), (v) {
              final q = int.tryParse(v) ?? 0;
              _updateItem(index, item.copyWith(qty: q, totalAmt: q * item.price));
            }, isInt: true),
          ),
          const SizedBox(width: 8),

          // Price
          SizedBox(
            width: 80,
            child: _gridInputNumber(item.price.toString(), (v) {
              final p = double.tryParse(v) ?? 0.0;
              _updateItem(index, item.copyWith(price: p, totalAmt: item.qty * p));
            }),
          ),
          const SizedBox(width: 8),

          // Total Amt (read-only style)
          Container(
             width: 100,
             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
             decoration: BoxDecoration(
               color: const Color(0xFFF8FAFC),
               borderRadius: BorderRadius.circular(6),
               border: Border.all(color: const Color(0xFFE2E8F0)),
             ),
             alignment: Alignment.centerRight,
             child: Text('₹${item.totalAmt.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF475569), fontSize: 11)),
          ),
          const SizedBox(width: 8),

          // remove button
          IconButton(
            onPressed: () => _removeItem(index),
            icon: const Icon(LucideIcons.trash2, size: 14, color: Color(0xFFF87171)),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            hoverColor: const Color(0xFFFEF2F2),
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _headerInput(String label, String value, Function(String) onChanged, {bool readOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: value,
          readOnly: readOnly,
          onChanged: onChanged,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: readOnly,
            fillColor: readOnly ? Colors.blueGrey.shade50 : Colors.white,
          ),
          style: const TextStyle(fontSize: 13),
        ),
      ],
    );
  }

  Widget _headerDropdown(String label, String value, List<String> options, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          style: const TextStyle(fontSize: 13, color: Colors.black),
        ),
      ],
    );
  }

  Widget _datePicker(String label, DateTime date, Function(DateTime) onSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
        const SizedBox(height: 6),
        InkWell(
          onTap: () async {
            final d = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (d != null) onSelected(d);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                const Icon(LucideIcons.calendar, size: 16, color: Colors.blueGrey),
                const SizedBox(width: 8),
                Text(DateFormat('dd-MM-yyyy').format(date), style: const TextStyle(fontSize: 13)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _gridInput({TextEditingController? controller, FocusNode? focusNode, String? hint, Function(String)? onChanged, bool hasIcon = false}) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: hasIcon ? const Icon(LucideIcons.search, size: 14, color: Color(0xFF94A3B8)) : null,
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xFF2563EB))),
        fillColor: Colors.white,
        filled: true,
      ),
      style: const TextStyle(fontSize: 11),
    );
  }

  Widget _gridInputNumber(String value, Function(String) onChanged, {bool isInt = false}) {
    return TextFormField(
      initialValue: value == '0' || value == '0.0' ? '' : value,
      onChanged: onChanged,
      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
      textAlign: TextAlign.center,
      decoration: InputDecoration(isDense: true, contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8), border: OutlineInputBorder(borderRadius: BorderRadius.circular(6))),
      style: const TextStyle(fontSize: 13),
    );
  }

  Widget _gridDropdown(String value, List<String> options, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: options.contains(value) ? value : options.first,
      iconSize: 18,
      items: options.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 11)))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        isDense: true, 
        contentPadding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8), 
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );
  }

  Widget _summaryLabel(String label, String value, {bool isBold = false, Color? color}) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blueGrey)),
        const SizedBox(width: 8),
        Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.w600, fontSize: 13, color: color ?? Colors.blueGrey.shade800)),
      ],
    );
  }
}
