import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/product_exchange_provider.dart';
import '../../../masters/data/providers/inventory_providers.dart';
import '../../../masters/data/providers/account_provider.dart';
import '../../../masters/data/models/lens_group_model.dart';
import '../../../masters/data/models/item_master_model.dart';
import '../../../masters/data/models/account_model.dart';
import '../../data/models/product_exchange_model.dart';
import '../../../../core/auth/auth_provider.dart';
import 'package:go_router/go_router.dart';

class AddProductExchangePage extends StatefulWidget {
  final String? editId;
  const AddProductExchangePage({super.key, this.editId});

  @override
  State<AddProductExchangePage> createState() => _AddProductExchangePageState();
}

class _AddProductExchangePageState extends State<AddProductExchangePage> {
  // Header state
  String _billSeries = 'Exchange';
  String _billNo = '';
  DateTime _date = DateTime.now();
  String _type = 'Lens';
  String _godown = 'MT-1';
  String _bookedBy = '';

  // Party state
  String _partyName = '';
  String _address = '';
  String _contactNo = '';

  // Items state
  List<ExchangeItemModel> _exchangeOutItems = [const ExchangeItemModel()];
  List<ExchangeItemModel> _exchangeInItems = [const ExchangeItemModel()];

  String _remarks = '';
  bool _isLoading = false;

  // Controllers for reactive fields
  late TextEditingController _billNoController;
  late TextEditingController _addressController;
  late TextEditingController _contactNoController;
  late TextEditingController _remarksController;
  late TextEditingController _bookedByController;

  @override
  void initState() {
    super.initState();
    final userName = context.read<AuthProvider>().user?['name'] ?? '';
    _bookedBy = userName;
    _bookedByController = TextEditingController(text: userName);
    _billNoController = TextEditingController();
    _addressController = TextEditingController();
    _contactNoController = TextEditingController();
    _remarksController = TextEditingController();
    
    // Use postFrameCallback to avoid "setState() called during build" error
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.editId != null) {
        _loadExistingExchange();
      } else {
        _fetchNextBillNo();
      }
      
      // Fetch data for autocompletes
      context.read<LensGroupProvider>().fetchAllLensPower();
      context.read<AccountProvider>().fetchAllAccounts();
      context.read<ItemMasterProvider>().fetchItems();
    });
  }

  @override
  void dispose() {
    _billNoController.dispose();
    _addressController.dispose();
    _contactNoController.dispose();
    _remarksController.dispose();
    _bookedByController.dispose();
    super.dispose();
  }

  Future<void> _fetchNextBillNo() async {
    final provider = context.read<ProductExchangeProvider>();
    await provider.fetchExchanges();
    setState(() {
      _billNo = provider.getNextBillNo().toString();
      _billNoController.text = _billNo;
    });
  }

  Future<void> _loadExistingExchange() async {
    setState(() => _isLoading = true);
    final res = await context.read<ProductExchangeProvider>().getExchangeById(widget.editId!);
    if (res['success'] == true && res['data'] != null) {
      final exchange = ProductExchangeModel.fromJson(res['data']);
      setState(() {
        _billSeries = exchange.billData.billSeries;
        _billNo = exchange.billData.billNo;
        _date = exchange.billData.date != null ? DateTime.parse(exchange.billData.date!) : DateTime.now();
        _type = exchange.billData.type;
        _godown = exchange.billData.godown;
        _bookedBy = exchange.billData.bookedBy;
        _bookedByController.text = _bookedBy;
        
        _partyName = exchange.partyData.partyAccount;
        _address = exchange.partyData.address;
        _addressController.text = _address;
        _contactNo = exchange.partyData.contactNumber;
        _contactNoController.text = _contactNo;
        
        _exchangeOutItems = exchange.exchangeOutItems.isEmpty ? [const ExchangeItemModel()] : exchange.exchangeOutItems;
        _exchangeInItems = exchange.exchangeInItems.isEmpty ? [const ExchangeItemModel()] : exchange.exchangeInItems;
        
        _remarks = exchange.remarks;
        _remarksController.text = _remarks;
      });
    }
    setState(() => _isLoading = false);
  }

  void _addRow(bool isOut) {
    setState(() {
      if (isOut) {
        _exchangeOutItems = [..._exchangeOutItems, const ExchangeItemModel()];
      } else {
        _exchangeInItems = [..._exchangeInItems, const ExchangeItemModel()];
      }
    });
  }

  void _removeRow(bool isOut, int index) {
    setState(() {
      if (isOut) {
        if (_exchangeOutItems.length > 1) {
          _exchangeOutItems = List.from(_exchangeOutItems)..removeAt(index);
        }
      } else {
        if (_exchangeInItems.length > 1) {
          _exchangeInItems = List.from(_exchangeInItems)..removeAt(index);
        }
      }
    });
  }

  void _updateItem(bool isOut, int index, ExchangeItemModel item) {
    setState(() {
      if (isOut) {
        _exchangeOutItems[index] = item;
      } else {
        _exchangeInItems[index] = item;
      }
    });
  }

  double _totalQty(bool isOut) => (isOut ? _exchangeOutItems : _exchangeInItems).fold(0, (sum, item) => sum + item.qty).toDouble();
  double _totalAmount(bool isOut) => (isOut ? _exchangeOutItems : _exchangeInItems).fold(0, (sum, item) => sum + item.totalAmount);

  void _handleReset() {
    setState(() {
      _billSeries = 'Exchange';
      _type = 'Lens';
      _godown = 'MT-1';
      _partyName = '';
      _address = '';
      _addressController.clear();
      _contactNo = '';
      _contactNoController.clear();
      _exchangeOutItems = [const ExchangeItemModel()];
      _exchangeInItems = [const ExchangeItemModel()];
      _remarks = '';
      _remarksController.clear();
    });
    if (widget.editId == null) {
      _fetchNextBillNo();
    } else {
      _loadExistingExchange();
    }
  }

  Future<void> _handleSave() async {
    if (_partyName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a party')));
      return;
    }

    if (_billNo.isEmpty && _billNoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bill number generation failed. Please refresh or check connection.')));
      return;
    }
    if (_billNo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bill No is required')));
      return;
    }

    final validOut = _exchangeOutItems.where((it) => it.itemName.isNotEmpty).toList();
    final validIn = _exchangeInItems.where((it) => it.itemName.isNotEmpty).toList();

    if (validOut.isEmpty && validIn.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add at least one item')));
      return;
    }

    setState(() => _isLoading = true);
    final payload = {
      'billData': {
        'billSeries': _billSeries,
        'billNo': _billNo,
        'date': _date.toIso8601String(),
        'type': _type,
        'godown': _godown,
        'bookedBy': _bookedBy,
      },
      'partyData': {
        'partyAccount': _partyName,
        'address': _address,
        'contactNumber': _contactNo,
      },
      'exchangeOutItems': validOut.map((e) => e.toJson()).toList(),
      'exchangeInItems': validIn.map((e) => e.toJson()).toList(),
      'totals': {
        'totalExchOutQty': _totalQty(true).toInt(),
        'totalExchOutAmnt': _totalAmount(true),
        'totalExchInQty': _totalQty(false).toInt(),
        'totalExchInAmnt': _totalAmount(false),
      },
      'remarks': _remarks,
      'status': 'Completed',
    };

    final res = widget.editId != null
        ? await context.read<ProductExchangeProvider>().updateExchange(widget.editId!, payload)
        : await context.read<ProductExchangeProvider>().saveExchange(payload);

    setState(() => _isLoading = false);

    if (res['success'] == true) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.editId != null ? 'Exchange updated successfully' : 'Exchange saved successfully')),
      );
      context.go('/lenstransaction/productexchange');
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['error'] ?? 'Save failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && widget.editId != null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.editId != null ? 'Edit Product Exchange' : 'Add Product Exchange',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
            const Text(
              "Create a new product exchange transaction",
              style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.normal),
            ),
          ],
        ),
        toolbarHeight: 80,
        actions: [
          ElevatedButton.icon(
            onPressed: () => context.go('/lenstransaction/productexchange'),
            icon: const Icon(LucideIcons.x, size: 18),
            label: const Text('Cancel'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE2E8F0),
              foregroundColor: const Color(0xFF475569),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(width: 24),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildBillingCard(),
                  const SizedBox(height: 24),
                  _buildPartyCard(),
                  const SizedBox(height: 24),
                  _buildItemsCard(true, 'Exchange Out Product List', _exchangeOutItems),
                  const SizedBox(height: 24),
                  _buildItemsCard(false, 'Exchange In Product List', _exchangeInItems),
                  const SizedBox(height: 24),
                  _buildFooterCard(),
                ],
              ),
            ),
          ),
          _buildActionFooter(),
        ],
      ),
    );
  }

  Widget _buildActionFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildFooterButton(
            onPressed: _handleReset,
            label: "Reset",
            icon: LucideIcons.rotateCcw,
            color: const Color(0xFFE2E8F0),
            textColor: const Color(0xFF475569),
          ),
          const SizedBox(width: 16),
          _buildFooterButton(
            onPressed: _handleSave,
            label: "Save",
            icon: LucideIcons.save,
            color: const Color(0xFF16A34A),
            textColor: Colors.white,
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildFooterButton({
    required VoidCallback onPressed,
    required String label,
    required IconData icon,
    required Color color,
    required Color textColor,
    bool isBold = false,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildBillingCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFE2E8F0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Billing Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B))),
                Icon(LucideIcons.chevronUp, size: 18, color: Colors.grey.shade400),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Wrap(
              spacing: 16,
              runSpacing: 20,
              children: [
                SizedBox(width: 250, child: _headerDropdown('Bill Series', _billSeries, ['Exchange'], (v) => setState(() => _billSeries = v!))),
                SizedBox(width: 250, child: _headerInput('Bill No. (Auto)', _billNoController, (v) => _billNo = v, readOnly: true)),
                SizedBox(width: 250, child: _datePicker('Date', _date, (d) => setState(() => _date = d))),
                SizedBox(width: 250, child: _headerDropdown('Type', _type, ['Lens', 'Optics', 'Glasses'], (v) => setState(() => _type = v!))),
                SizedBox(width: 250, child: _headerDropdown('Godown', _godown, ['MT-1', 'MC-1', 'MB-1'], (v) => setState(() => _godown = v!))),
                SizedBox(width: 250, child: _headerInput('Booked By', _bookedByController, (v) => _bookedBy = v)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPartyCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFE2E8F0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Party Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B))),
                Icon(LucideIcons.chevronUp, size: 18, color: Colors.grey.shade400),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Autocomplete<AccountModel>(
                    initialValue: TextEditingValue(text: _partyName),
                    optionsBuilder: (textEditingValue) {
                      final accounts = context.read<AccountProvider>().accounts;
                      return accounts.where((a) => a.name.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                    },
                    displayStringForOption: (a) => a.name,
                    onSelected: (a) {
                      setState(() {
                        _partyName = a.name;
                        _address = a.address ?? '';
                        _addressController.text = _address;
                        _contactNo = a.mobileNumber ?? '';
                        _contactNoController.text = _contactNo;
                      });
                    },
                    fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                      return _headerInputField(controller: controller, focusNode: focusNode, label: 'Party A/c', hint: 'Search Party...');
                    },
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(flex: 1, child: _headerInput('Address', _addressController, (v) => _address = v)),
                const SizedBox(width: 24),
                Expanded(flex: 1, child: _headerInput('Contact No.', _contactNoController, (v) => _contactNo = v)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsCard(bool isOut, String title, List<ExchangeItemModel> items) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFE2E8F0))),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFFEFF6FF), Color(0xFFF8FAFC)]),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B))),
                ElevatedButton.icon(
                  onPressed: () => _addRow(isOut),
                  icon: const Icon(LucideIcons.plus, size: 14),
                  label: const Text('Add Row'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF16A34A),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
          _buildTable(isOut, items),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _summaryLabel('Total Qty:', _totalQty(isOut).toInt().toString()),
                const SizedBox(width: 48),
                _summaryLabel('Total Amt:', '₹${NumberFormat('#,##0.00').format(_totalAmount(isOut))}', isBold: true, color: const Color(0xFF2563EB)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTable(bool isOut, List<ExchangeItemModel> items) {
    return Column(
      children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: const Color(0xFFF8FAFC),
            child: const Row(
              children: [
                SizedBox(width: 30, child: Text('SR', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Color(0xFF64748B)))),
                SizedBox(width: 60, child: Text('CODE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Color(0xFF64748B)))),
                Expanded(flex: 3, child: Text('ITEM NAME', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Color(0xFF64748B)))),
                SizedBox(width: 12),
                SizedBox(width: 40, child: Text('DIA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Color(0xFF64748B)))),
                SizedBox(width: 40, child: Text('EYE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Color(0xFF64748B)))),
                SizedBox(width: 40, child: Text('SPH', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Color(0xFF64748B)))),
                SizedBox(width: 40, child: Text('CYL', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Color(0xFF64748B)))),
                SizedBox(width: 40, child: Text('AXIS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Color(0xFF64748B)))),
                SizedBox(width: 40, child: Text('ADD', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Color(0xFF64748B)))),
                SizedBox(width: 12),
                Expanded(flex: 2, child: Text('REMARK', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Color(0xFF64748B)))),
                SizedBox(width: 40, child: Text('QTY', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Color(0xFF64748B)))),
                SizedBox(width: 60, child: Text('PRICE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Color(0xFF64748B)))),
                SizedBox(width: 80, child: Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Color(0xFF2563EB)))),
                SizedBox(width: 30, child: Text('DEL', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Color(0xFF64748B)))),
              ],
            ),
          ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (c, i) => const Divider(height: 1),
          itemBuilder: (c, i) => _buildRow(isOut, i),
        ),
      ],
    );
  }

  Widget _buildRow(bool isOut, int index) {
    final item = isOut ? _exchangeOutItems[index] : _exchangeInItems[index];
    final sn = index + 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 30, child: Text('$sn', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)))),
          SizedBox(width: 60, child: _gridInputSnippet(item.code, (v) => _updateItem(isOut, index, item.copyWith(code: v)), key: ValueKey('code_${index}_${item.code}'))),
          const SizedBox(width: 4),
          Expanded(
            flex: 3,
            child: Autocomplete<Object>(
              key: ValueKey('item_name_${index}_${item.itemName}'),
              initialValue: TextEditingValue(text: item.itemName),
              optionsBuilder: (textEditingValue) {
                final search = textEditingValue.text.toLowerCase();
                final lenses = context.read<LensGroupProvider>().lensGroups;
                final masterItems = context.read<ItemMasterProvider>().items;
                
                final List<Object> combined = [...lenses, ...masterItems];
                
                if (search.isEmpty) {
                  return combined.take(10);
                }

                return combined.where((it) {
                  if (it is LensGroupModel) {
                    return it.productName.toLowerCase().contains(search) || 
                           it.groupName.toLowerCase().contains(search) ||
                           it.vendorItemName.toLowerCase().contains(search);
                  } else if (it is ItemMasterModel) {
                    return it.itemName.toLowerCase().contains(search) || 
                           it.alias.toLowerCase().contains(search) ||
                           it.billItemName.toLowerCase().contains(search);
                  }
                  return false;
                }).take(20);
              },
              displayStringForOption: (it) {
                if (it is LensGroupModel) return it.productName.isNotEmpty ? it.productName : it.groupName;
                if (it is ItemMasterModel) return it.itemName;
                return '';
              },
              onSelected: (it) async {
                String name = '';
                String code = '';
                String eye = '';
                double axis = 0.0;
                double price = 0.0;

                if (it is LensGroupModel) {
                  // Fetch full details from API for Eye, Axis, and Price
                  final fullLens = await context.read<LensGroupProvider>().getLensPower(
                    productName: it.productName.isNotEmpty ? it.productName : null,
                    groupName: it.productName.isEmpty ? it.groupName : null,
                  );

                  final data = fullLens ?? it;
                  
                  name = data.productName.isNotEmpty ? data.productName : data.groupName;
                  code = data.id ?? (data.vendorItemName.isNotEmpty ? data.vendorItemName : (data.productName.isNotEmpty ? data.productName : data.groupName));
                  eye = data.eye;
                  axis = double.tryParse(data.axis) ?? 0.0;
                  price = double.tryParse(data.salePrice?['default']?.toString() ?? '0') ?? 
                          double.tryParse(data.salePrice?['price']?.toString() ?? '0') ?? 0.0;
                } else if (it is ItemMasterModel) {
                  name = it.itemName;
                  code = it.barcode.isNotEmpty ? it.barcode : (it.alias.isNotEmpty ? it.alias : (it.id ?? ''));
                  price = it.salePrice ?? 0.0;
                }

                _updateItem(isOut, index, item.copyWith(
                  itemName: name,
                  code: code,
                  eye: eye,
                  axis: axis,
                  price: price,
                  totalAmount: item.qty * price,
                ));
              },
              fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                return _gridInputField(controller: controller, focusNode: focusNode, hint: 'Search Item...');
              },
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(width: 40, child: _gridInputSnippet(item.dia, (v) => _updateItem(isOut, index, item.copyWith(dia: v)), key: ValueKey('dia_${index}_${item.dia}'))),
          SizedBox(width: 40, child: _gridInputSnippet(item.eye, (v) => _updateItem(isOut, index, item.copyWith(eye: v)), key: ValueKey('eye_${index}_${item.eye}'))),
          SizedBox(width: 40, child: _gridInputNumberSnippet(item.sph.toString(), (v) => _updateItem(isOut, index, item.copyWith(sph: double.tryParse(v) ?? 0.0)), key: ValueKey('sph_${index}_${item.sph}'))),
          SizedBox(width: 40, child: _gridInputNumberSnippet(item.cyl.toString(), (v) => _updateItem(isOut, index, item.copyWith(cyl: double.tryParse(v) ?? 0.0)), key: ValueKey('cyl_${index}_${item.cyl}'))),
          SizedBox(width: 40, child: _gridInputNumberSnippet(item.axis.toString(), (v) => _updateItem(isOut, index, item.copyWith(axis: double.tryParse(v) ?? 0.0)), key: ValueKey('axis_${index}_${item.axis}'))),
          SizedBox(width: 40, child: _gridInputNumberSnippet(item.add.toString(), (v) => _updateItem(isOut, index, item.copyWith(add: double.tryParse(v) ?? 0.0)), key: ValueKey('add_${index}_${item.add}'))),
          const SizedBox(width: 12),
          Expanded(flex: 2, child: _gridInputSnippet(item.remark, (v) => _updateItem(isOut, index, item.copyWith(remark: v)))),
          SizedBox(width: 40, child: _gridInputNumberSnippet(item.qty.toString(), (v) {
            final q = int.tryParse(v) ?? 0;
            _updateItem(isOut, index, item.copyWith(qty: q, totalAmount: q * item.price));
          }, isInt: true)),
          SizedBox(width: 60, child: _gridInputNumberSnippet(item.price.toString(), (v) {
            final p = double.tryParse(v) ?? 0.0;
            _updateItem(isOut, index, item.copyWith(price: p, totalAmount: item.qty * p));
          }, key: ValueKey('price_${index}_${item.price}'))),
          SizedBox(width: 80, child: Text('₹${item.totalAmount.toStringAsFixed(2)}', textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF1E293B)))),
          SizedBox(width: 30, child: IconButton(onPressed: () => _removeRow(isOut, index), icon: const Icon(LucideIcons.x, size: 14, color: Color(0xFFEF4444)))),
        ],
      ),
    );
  }

  Widget _buildFooterCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFE2E8F0))),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
             _headerInput('Remarks', _remarksController, (v) => _remarks = v),
             const SizedBox(height: 24),
             Row(
               mainAxisAlignment: MainAxisAlignment.end,
               children: [
                 _summaryLabel('Net Difference:', '₹${NumberFormat('#,##0.00').format(_totalAmount(false) - _totalAmount(true))}', isBold: true, color: Colors.indigo.shade700),
               ],
             )
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _headerInput(String label, TextEditingController controller, Function(String) onChanged, {bool readOnly = false}) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      readOnly: readOnly,
      style: TextStyle(fontSize: 13, color: readOnly ? Colors.blueGrey.shade600 : const Color(0xFF1E293B)),
      decoration: InputDecoration(
        labelText: label,
        fillColor: readOnly ? const Color(0xFFF1F5F9) : null,
        filled: readOnly,
        labelStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
      ),
    );
  }

  Widget _headerInputField({TextEditingController? controller, FocusNode? focusNode, String? label, String? hint}) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
      ),
    );
  }

  Widget _headerDropdown(String label, String value, List<String> options, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      items: options.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13)))).toList(),
      onChanged: onChanged,
      style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
      ),
    );
  }

  Widget _datePicker(String label, DateTime date, Function(DateTime) onSelected) {
    return TextFormField(
      readOnly: true,
      onTap: () async {
        final d = await showDatePicker(context: context, initialDate: date, firstDate: DateTime(2000), lastDate: DateTime(2100));
        if (d != null) onSelected(d);
      },
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
        suffixIcon: const Icon(LucideIcons.calendar, size: 16, color: Color(0xFF64748B)),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
      ),
      controller: TextEditingController(text: DateFormat('dd-MM-yyyy').format(date)),
    );
  }

  Widget _gridInputSnippet(String value, Function(String) onChanged, {Key? key}) {
    return TextFormField(
      key: key,
      initialValue: value,
      onChanged: onChanged,
      decoration: InputDecoration(isDense: true, contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8), border: OutlineInputBorder(borderRadius: BorderRadius.circular(4))),
      style: const TextStyle(fontSize: 11),
    );
  }

  Widget _gridInputField({TextEditingController? controller, FocusNode? focusNode, String? hint}) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(hintText: hint, hintStyle: const TextStyle(fontSize: 11), isDense: true, contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8), border: OutlineInputBorder(borderRadius: BorderRadius.circular(4))),
      style: const TextStyle(fontSize: 11),
    );
  }

  Widget _gridInputNumberSnippet(String value, Function(String) onChanged, {bool isInt = false, Key? key}) {
    return TextFormField(
      key: key,
      initialValue: value == '0' || value == '0.0' ? '' : value,
      onChanged: onChanged,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textAlign: TextAlign.center,
      decoration: InputDecoration(isDense: true, contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8), border: OutlineInputBorder(borderRadius: BorderRadius.circular(4))),
      style: const TextStyle(fontSize: 11),
    );
  }

  Widget _summaryLabel(String label, String value, {bool isBold = false, Color? color}) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.blueGrey)),
        const SizedBox(width: 8),
        Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.w600, fontSize: 12, color: color ?? Colors.blueGrey.shade800)),
      ],
    );
  }
}
