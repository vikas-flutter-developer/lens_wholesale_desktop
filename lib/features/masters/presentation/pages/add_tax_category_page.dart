import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/providers/tax_category_provider.dart';
import '../../data/models/tax_category_model.dart';

class AddTaxCategoryPage extends StatefulWidget {
  final TaxCategoryModel? taxCategory;
  const AddTaxCategoryPage({super.key, this.taxCategory});

  @override
  State<AddTaxCategoryPage> createState() => _AddTaxCategoryPageState();
}

class _AddTaxCategoryPageState extends State<AddTaxCategoryPage> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameCtrl;
  late TextEditingController _cgstCtrl;
  late TextEditingController _sgstCtrl;
  late TextEditingController _igstCtrl;
  late TextEditingController _remarksCtrl;

  String _type = "goods";
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    final cat = widget.taxCategory;
    _nameCtrl = TextEditingController(text: cat?.name ?? "");
    _cgstCtrl = TextEditingController(text: cat?.localTax1.toString() ?? "0");
    _sgstCtrl = TextEditingController(text: cat?.localTax2.toString() ?? "0");
    _igstCtrl = TextEditingController(text: cat?.centralTax.toString() ?? "0");
    _remarksCtrl = TextEditingController(text: cat?.remarks ?? "");
    _type = cat?.type ?? "goods";
    _isDefault = cat?.isDefault ?? false;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _cgstCtrl.dispose();
    _sgstCtrl.dispose();
    _igstCtrl.dispose();
    _remarksCtrl.dispose();
    super.dispose();
  }

  void _handleNameChange(String val) {
    // Regex to find numbers in Name (e.g. GST 18%)
    final match = RegExp(r'\d+(\.\d+)?').firstMatch(val);
    if (match != null) {
      final double taxNum = double.tryParse(match.group(0)!) ?? 0;
      setState(() {
        _cgstCtrl.text = (taxNum / 2).toString();
        _sgstCtrl.text = (taxNum / 2).toString();
        _igstCtrl.text = taxNum.toString();
      });
    }
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final cgst = double.tryParse(_cgstCtrl.text) ?? 0;
    final sgst = double.tryParse(_sgstCtrl.text) ?? 0;
    final igst = double.tryParse(_igstCtrl.text) ?? 0;

    if (cgst > 0 && sgst == 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter SGST value")));
      return;
    }
    if (sgst > 0 && cgst == 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter CGST value")));
      return;
    }
    if (cgst == 0 && sgst == 0 && igst == 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter at least one tax value (CGST/SGST or IGST)")));
      return;
    }

    final category = TaxCategoryModel(
      id: widget.taxCategory?.id ?? "",
      name: _nameCtrl.text.trim(),
      type: _type,
      localTax1: cgst,
      localTax2: sgst,
      centralTax: igst,
      cessTax: 0,
      taxOnMRP: "no",
      isDefault: _isDefault,
      remarks: _remarksCtrl.text.trim(),
    );

    final provider = context.read<TaxCategoryProvider>();
    bool success;
    if (widget.taxCategory != null) {
      success = await provider.updateTaxCategory(widget.taxCategory!.id, category);
    } else {
      success = await provider.addTaxCategory(category);
    }

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(widget.taxCategory != null ? "Tax Category updated!" : "Tax Category saved!")));
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(provider.error ?? "Operation failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<TaxCategoryProvider>().isLoading;
    final isEdit = widget.taxCategory != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(isEdit ? "Edit Tax Category" : "Add Tax Category", style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 5))],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildTextField(
                          "Category Name *", 
                          _nameCtrl, 
                          hint: "Ex: GST 18%", 
                          required: true,
                          onChanged: _handleNameChange,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildDropdown(
                          "Type", 
                          _type, 
                          ["goods", "services"], 
                          (val) => setState(() => _type = val!)
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(child: _buildTextField("Local Tax 1 (CGST %)", _cgstCtrl, isNumber: true)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildTextField("Local Tax 2 (SGST %)", _sgstCtrl, isNumber: true)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildTextField("Central Tax (IGST %)", _igstCtrl, isNumber: true)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Set as Default", style: TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w600, fontSize: 14)),
                            const SizedBox(height: 8),
                            SwitchListTile(
                              title: const Text("Default Category", style: TextStyle(fontSize: 14)),
                              value: _isDefault,
                              onChanged: (val) => setState(() => _isDefault = val),
                              contentPadding: EdgeInsets.zero,
                              activeThumbColor: const Color(0xFF3B82F6),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildTextField("Remarks", _remarksCtrl, maxLines: 3, hint: "Optional notes..."),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel", style: TextStyle(color: Color(0xFF64748B))),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: isLoading ? null : _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: isLoading 
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : Text(isEdit ? "Update Category" : "Save Category", style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController ctrl, {String? hint, bool required = false, bool isNumber = false, int maxLines = 1, Function(String)? onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          controller: ctrl,
          maxLines: maxLines,
          keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF3B82F6))),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          validator: (val) => required && (val == null || val.trim().isEmpty) ? "Required" : null,
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e.toUpperCase(), style: const TextStyle(fontSize: 14)))).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }
}
