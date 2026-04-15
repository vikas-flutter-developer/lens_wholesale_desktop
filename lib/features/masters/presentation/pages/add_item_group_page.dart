import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../data/models/item_group_model.dart';
import '../../data/providers/inventory_providers.dart';
import '../../../../core/network/api_client.dart';

class AddItemGroupPage extends StatefulWidget {
  final bool hideHeader;
  final Function(String)? onSaveSuccess;

  const AddItemGroupPage({
    super.key,
    this.hideHeader = false,
    this.onSaveSuccess,
  });

  @override
  State<AddItemGroupPage> createState() => _AddItemGroupPageState();
}

class _AddItemGroupPageState extends State<AddItemGroupPage> {
  final _formKey = GlobalKey<FormState>();
  final _groupNameController = TextEditingController();
  final _dateController = TextEditingController();
  final _saleDiscountController = TextEditingController();
  final _purchaseDiscountController = TextEditingController();
  final _hsnCodeController = TextEditingController();
  final _loyaltyPointController = TextEditingController();
  final _textCategory1Controller = TextEditingController();
  final _codeg1LimitController = TextEditingController();
  final _taxCategory2Controller = TextEditingController();
  final _searchController = TextEditingController();

  bool _saleDiscountApplyAll = false;
  bool _hsnApplyAll = false;
  bool _loyaltyApplyAll = false;
  bool _textCategory1ApplyAll = false;
  bool _alertNegativeQty = false;
  bool _restrictNegativeQty = false;

  String? _editingId;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ItemGroupProvider>().fetchGroups();
    });
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    _dateController.dispose();
    _saleDiscountController.dispose();
    _purchaseDiscountController.dispose();
    _hsnCodeController.dispose();
    _loyaltyPointController.dispose();
    _textCategory1Controller.dispose();
    _codeg1LimitController.dispose();
    _taxCategory2Controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _handleEdit(ItemGroupModel group) {
    setState(() {
      _editingId = group.id;
      _groupNameController.text = group.groupName;
      _dateController.text = group.date ?? '';
      _saleDiscountController.text = group.saleDiscount?.toString() ?? '';
      _saleDiscountApplyAll = group.saleDiscountApplyAll;
      _purchaseDiscountController.text = group.purchaseDiscount?.toString() ?? '';
      _hsnCodeController.text = group.hsnCode ?? '';
      _hsnApplyAll = group.hsnApplyAll;
      _loyaltyPointController.text = group.loyaltyPoint?.toString() ?? '';
      _loyaltyApplyAll = group.loyaltyApplyAll;
      _textCategory1Controller.text = group.textCategory1 ?? '';
      _textCategory1ApplyAll = group.textCategory1ApplyAll;
      _codeg1LimitController.text = group.codeg1Limit ?? '';
      _taxCategory2Controller.text = group.taxCategory2 ?? '';
      _alertNegativeQty = group.alertNegativeQty;
      _restrictNegativeQty = group.restrictNegativeQty;
    });
    // Scroll to top
    Scrollable.ensureVisible(_formKey.currentContext!);
  }

  void _handleReset() {
    setState(() {
      _editingId = null;
      _formKey.currentState?.reset();
      _groupNameController.clear();
      _saleDiscountController.clear();
      _purchaseDiscountController.clear();
      _hsnCodeController.clear();
      _loyaltyPointController.clear();
      _textCategory1Controller.clear();
      _codeg1LimitController.clear();
      _taxCategory2Controller.clear();
      _saleDiscountApplyAll = false;
      _hsnApplyAll = false;
      _loyaltyApplyAll = false;
      _textCategory1ApplyAll = false;
      _alertNegativeQty = false;
      _restrictNegativeQty = false;
      _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    try {
      final group = ItemGroupModel(
        groupName: _groupNameController.text.trim(),
        date: _dateController.text,
        saleDiscount: double.tryParse(_saleDiscountController.text),
        saleDiscountApplyAll: _saleDiscountApplyAll,
        purchaseDiscount: double.tryParse(_purchaseDiscountController.text),
        hsnCode: _hsnCodeController.text.trim(),
        hsnApplyAll: _hsnApplyAll,
        loyaltyPoint: int.tryParse(_loyaltyPointController.text),
        loyaltyApplyAll: _loyaltyApplyAll,
        textCategory1: _textCategory1Controller.text.trim(),
        textCategory1ApplyAll: _textCategory1ApplyAll,
        codeg1Limit: _codeg1LimitController.text.trim(),
        taxCategory2: _taxCategory2Controller.text.trim(),
        alertNegativeQty: _alertNegativeQty,
        restrictNegativeQty: _restrictNegativeQty,
      );

      final provider = context.read<ItemGroupProvider>();
      if (_editingId != null) {
        await provider.updateGroup(_editingId!, group);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item group updated successfully')),
        );
      } else {
        await provider.addGroup(group);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item group created successfully')),
        );
        if (widget.onSaveSuccess != null) {
          widget.onSaveSuccess!(group.groupName);
        }
      }
      _handleReset();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ItemGroupProvider>();
    final filteredGroups = provider.groups.where((g) {
      final query = _searchController.text.toLowerCase();
      return g.groupName.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!widget.hideHeader) ...[
              const Text(
                'Item Group Master',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              ),
              const SizedBox(height: 8),
              const Text(
                'Manage item groups and their default settings',
                style: TextStyle(color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 32),
            ],

            // Form Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildTextField(
                            controller: _groupNameController,
                            label: 'Group Name',
                            icon: LucideIcons.layers,
                            validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller: _dateController,
                            label: 'Date',
                            icon: LucideIcons.calendar,
                            readOnly: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Discounts & HSN
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextFieldWithCheckbox(
                            controller: _saleDiscountController,
                            label: 'Sale Discount (%)',
                            isChecked: _saleDiscountApplyAll,
                            onChanged: (v) => setState(() => _saleDiscountApplyAll = v!),
                            checkboxLabel: 'Apply All',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller: _purchaseDiscountController,
                            label: 'Purchase Discount (%)',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextFieldWithCheckbox(
                            controller: _hsnCodeController,
                            label: 'HSN Code',
                            isChecked: _hsnApplyAll,
                            onChanged: (v) => setState(() => _hsnApplyAll = v!),
                            checkboxLabel: 'Apply All',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Loyalty & Categories
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextFieldWithCheckbox(
                            controller: _loyaltyPointController,
                            label: 'Loyalty Points',
                            isChecked: _loyaltyApplyAll,
                            onChanged: (v) => setState(() => _loyaltyApplyAll = v!),
                            checkboxLabel: 'Apply All',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextFieldWithCheckbox(
                            controller: _textCategory1Controller,
                            label: 'Text Category 1',
                            isChecked: _textCategory1ApplyAll,
                            onChanged: (v) => setState(() => _textCategory1ApplyAll = v!),
                            checkboxLabel: 'Apply All',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller: _codeg1LimitController,
                            label: 'Code G1 Limit',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Tax Category 2 & Checkboxes
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _taxCategory2Controller,
                            label: 'Tax Category 2',
                          ),
                        ),
                        const SizedBox(width: 24),
                        Row(
                          children: [
                            _buildCheckbox('Alert -ve Qty', _alertNegativeQty, (v) => setState(() => _alertNegativeQty = v!)),
                            const SizedBox(width: 16),
                            _buildCheckbox('Restrict -ve Qty', _restrictNegativeQty, (v) => setState(() => _restrictNegativeQty = v!)),
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),

                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 300,
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search groups...',
                              prefixIcon: const Icon(LucideIcons.search, size: 18),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            TextButton.icon(
                              onPressed: _handleReset,
                              icon: const Icon(LucideIcons.rotateCcw, size: 18),
                              label: const Text('Reset'),
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF64748B),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              onPressed: _isSubmitting ? null : _handleSubmit,
                              icon: _isSubmitting 
                                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : const Icon(LucideIcons.save, size: 18),
                              label: Text(_editingId != null ? 'Update Group' : 'Save Group'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Table Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Existing Item Groups', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Text('Total: ${filteredGroups.length}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                  DataTable(
                    headingRowColor: MaterialStateProperty.all(const Color(0xFFF8FAFC)),
                    columns: const [
                      DataColumn(label: Text('SR NO.')),
                      DataColumn(label: Text('DATE')),
                      DataColumn(label: Text('GROUP NAME')),
                      DataColumn(label: Text('ACTION', textAlign: TextAlign.center)),
                    ],
                    rows: List.generate(filteredGroups.length, (index) {
                      final group = filteredGroups[index];
                      return DataRow(
                        cells: [
                          DataCell(Text('${index + 1}')),
                          DataCell(Text(group.date ?? '-')),
                          DataCell(Text(group.groupName, style: const TextStyle(fontWeight: FontWeight.bold))),
                          DataCell(Row(
                            children: [
                              IconButton(
                                icon: const Icon(LucideIcons.pencil, size: 16, color: Color(0xFF2563EB)),
                                onPressed: () => _handleEdit(group),
                                tooltip: 'Edit',
                              ),
                              IconButton(
                                icon: Icon(
                                  LucideIcons.trash2, 
                                  size: 16, 
                                  color: group.canDelete ? const Color(0xFFEF4444) : const Color(0xFFCBD5E1)
                                ),
                                onPressed: !group.canDelete ? null : () => _showDeleteDialog(group),
                                tooltip: group.canDelete ? 'Delete' : 'Cannot delete (contains items)',
                              ),
                            ],
                          )),
                        ],
                      );
                    }),
                  ),
                  if (filteredGroups.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(32),
                      child: Text('No groups found.', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF94A3B8), fontStyle: FontStyle.italic)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    String? Function(String?)? validator,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon, size: 18) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        filled: true,
        fillColor: readOnly ? const Color(0xFFF1F5F9) : Colors.white,
      ),
    );
  }

  Widget _buildTextFieldWithCheckbox({
    required TextEditingController controller,
    required String label,
    required bool isChecked,
    required ValueChanged<bool?> onChanged,
    required String checkboxLabel,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(controller: controller, label: label),
        Row(
          children: [
            Checkbox(value: isChecked, onChanged: onChanged, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
            Text(checkboxLabel, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          ],
        ),
      ],
    );
  }

  Widget _buildCheckbox(String label, bool value, ValueChanged<bool?> onChanged) {
    return Row(
      children: [
        Checkbox(value: value, onChanged: onChanged, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
        Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF475569))),
      ],
    );
  }

  void _showDeleteDialog(ItemGroupModel group) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Group'),
        content: Text('Are you sure you want to delete "${group.groupName}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await context.read<ItemGroupProvider>().deleteGroup(group.id!);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Group deleted')));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
