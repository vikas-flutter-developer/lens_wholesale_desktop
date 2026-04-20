import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../data/models/item_group_model.dart';
import '../../data/providers/inventory_providers.dart';

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
  final _searchController = TextEditingController();

  // Reference fields from React - keeping them but UI will be cleaner
  final _saleDiscountController = TextEditingController();
  final _purchaseDiscountController = TextEditingController();
  final _hsnCodeController = TextEditingController();
  final _loyaltyPointController = TextEditingController();
  final _textCategory1Controller = TextEditingController();
  final _codeg1LimitController = TextEditingController();
  final _taxCategory2Controller = TextEditingController();

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
    _groupNameController.dispose(); _dateController.dispose(); _searchController.dispose();
    _saleDiscountController.dispose(); _purchaseDiscountController.dispose(); _hsnCodeController.dispose();
    _loyaltyPointController.dispose(); _textCategory1Controller.dispose(); _codeg1LimitController.dispose();
    _taxCategory2Controller.dispose();
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
    Scrollable.ensureVisible(_formKey.currentContext!, duration: const Duration(milliseconds: 300));
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
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item group updated!')));
      } else {
        await provider.addGroup(group);
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item group created!')));
        if (widget.onSaveSuccess != null) widget.onSaveSuccess!(group.groupName);
      }
      _handleReset();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ItemGroupProvider>();
    final filteredGroups = provider.groups.where((g) => g.groupName.toLowerCase().contains(_searchController.text.toLowerCase())).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF8FAFC), Color(0xFFEFF6FF)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Form Section: Group Information
              _buildFormSection(),
              const SizedBox(height: 32),

              // Table Section: Existing Item Groups
              _buildTableSection(filteredGroups, provider.isLoading),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormSection() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 20, offset: const Offset(0, 4))],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Group Information", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(flex: 3, child: _buildTextField("GROUP NAME *", _groupNameController, hint: "Enter group name", required: true)),
                const SizedBox(width: 24),
                Expanded(flex: 2, child: _buildTextField("DATE", _dateController, icon: LucideIcons.calendar, readOnly: true)),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                SizedBox(
                  width: 320,
                  child: TextField(
                    controller: _searchController,
                    decoration: _inputDecoration(hint: "Search groups...", prefixIcon: LucideIcons.search),
                  ),
                ),
                const Spacer(),
                _buildActionButton(label: "Reset", icon: LucideIcons.rotateCcw, color: const Color(0xFFF1F5F9), textColor: const Color(0xFF475569), onPressed: _handleReset),
                const SizedBox(width: 12),
                _buildActionButton(
                  label: _editingId != null ? "Update Group" : "Save Group",
                  icon: _isSubmitting ? LucideIcons.loader2 : LucideIcons.save,
                  color: const Color(0xFF2563EB),
                  onPressed: _isSubmitting ? null : _handleSubmit,
                  isLoading: _isSubmitting,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableSection(List<ItemGroupModel> groups, bool isLoading) {
    return LayoutBuilder(builder: (context, constraints) {
      final totalWidth = constraints.maxWidth;
      double w(double p) => totalWidth * p;

      final widths = {
        'sr': w(0.12),
        'date': w(0.28),
        'name': w(0.45),
        'action': w(0.15),
      };

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 15, offset: const Offset(0, 4))],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: const BoxDecoration(color: Color(0xFFF8FAFC), border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0)))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("EXISTING ITEM GROUPS", style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF475569), fontSize: 13, letterSpacing: 0.5)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6), border: Border.all(color: const Color(0xFFE2E8F0))),
                    child: Text("Total: ${groups.length}", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                  ),
                ],
              ),
            ),
            if (isLoading && groups.isEmpty)
              const Padding(padding: EdgeInsets.all(64), child: Center(child: CircularProgressIndicator()))
            else if (groups.isEmpty)
              const Padding(padding: EdgeInsets.all(64), child: Center(child: Text("No groups found.", style: TextStyle(color: Color(0xFF94A3B8), fontStyle: FontStyle.italic))))
            else
              DataTable(
                headingRowHeight: 44,
                dataRowMinHeight: 60,
                dataRowMaxHeight: 75,
                horizontalMargin: 0,
                columnSpacing: 0,
                headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                dividerThickness: 1,
                columns: [
                  _buildColumn("SR NO.", width: widths['sr']!, centered: true),
                  _buildColumn("DATE", width: widths['date']!),
                  _buildColumn("GROUP NAME", width: widths['name']!),
                  _buildColumn("ACTION", width: widths['action']!, centered: true),
                ],
                rows: groups.asMap().entries.map((entry) {
                  final i = entry.key;
                  final g = entry.value;
                  // Format date to dd/M/yyyy matching react toLocaleDateString
                  String formattedDate = "-";
                  try {
                    if (g.date != null) {
                      final dt = DateTime.parse(g.date!);
                      formattedDate = DateFormat('d/M/yyyy').format(dt);
                    }
                  } catch (_) {}

                  return DataRow(
                    cells: [
                      _buildCell(
                        child: Text("${i + 1}", style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: Color(0xFF64748B))),
                        width: widths['sr']!,
                        centered: true,
                      ),
                      _buildCell(child: Text(formattedDate, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF475569))), width: widths['date']!),
                      _buildCell(child: Text(g.groupName, style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF1E293B), fontSize: 13.5)), width: widths['name']!),
                      _buildCell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildTableIconButton(LucideIcons.pencil, const Color(0xFF2563EB), () => _handleEdit(g), size: 15),
                            const SizedBox(width: 8),
                            _buildTableIconButton(LucideIcons.trash2, const Color(0xFFDC2626), () => _showDeleteDialog(g), size: 15),
                          ],
                        ),
                        width: widths['action']!,
                        centered: true,
                      ),
                    ],
                  );
                }).toList(),
              ),
          ],
        ),
      );
    });
  }

  DataColumn _buildColumn(String label, {required double width, bool centered = false}) {
    return DataColumn(
      label: Container(
        width: width,
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: centered ? Alignment.center : Alignment.centerLeft,
        decoration: const BoxDecoration(border: Border(right: BorderSide(color: Color(0xFFE2E8F0)))),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF64748B), fontSize: 10, letterSpacing: 0.8)),
      ),
    );
  }

  DataCell _buildCell({required Widget child, required double width, bool centered = false}) {
    return DataCell(
      Container(
        width: width,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: centered ? Alignment.center : Alignment.centerLeft,
        decoration: const BoxDecoration(border: Border(right: BorderSide(color: Color(0xFFE2E8F0)))),
        child: child,
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController ctrl, {String? hint, bool required = false, bool readOnly = false, IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF475569), letterSpacing: 1.0)),
        const SizedBox(height: 8),
        TextFormField(
          controller: ctrl,
          readOnly: readOnly,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
          decoration: _inputDecoration(hint: hint, prefixIcon: icon),
          validator: (val) => required && (val == null || val.trim().isEmpty) ? "Required" : null,
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({String? hint, IconData? prefixIcon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 16, color: const Color(0xFF94A3B8)) : null,
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5)),
      hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
    );
  }

  Widget _buildActionButton({required String label, required IconData icon, required Color color, Color? textColor, required VoidCallback? onPressed, bool isLoading = false}) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: color == const Color(0xFF2563EB) ? [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))] : null,
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: isLoading 
          ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) 
          : Icon(icon, size: 16, color: textColor ?? Colors.white),
        label: Text(label, style: TextStyle(color: textColor ?? Colors.white, fontWeight: FontWeight.w900, fontSize: 13)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildTableIconButton(IconData icon, Color color, VoidCallback onPressed, {double size = 16}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: size, color: color),
        ),
      ),
    );
  }

  void _showDeleteDialog(ItemGroupModel group) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Group', style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
        content: Text('Are you sure you want to delete "${group.groupName}"? This action cannot be undone.', style: const TextStyle(fontSize: 14, color: Color(0xFF475569))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold))),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await context.read<ItemGroupProvider>().deleteGroup(group.id!);
                if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Group deleted successfully')));
              } catch (e) {
                if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            child: const Text('Delete', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
