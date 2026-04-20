import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
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
  late TextEditingController _cessCtrl;
  late TextEditingController _remarksCtrl;

  String _type = "goods";
  String _taxOnMRP = "no";
  String _isDefaultStr = "no";

  @override
  void initState() {
    super.initState();
    final cat = widget.taxCategory;
    _nameCtrl = TextEditingController(text: cat?.name ?? "");
    _cgstCtrl = TextEditingController(text: cat?.localTax1.toString() ?? "0");
    _sgstCtrl = TextEditingController(text: cat?.localTax2.toString() ?? "0");
    _igstCtrl = TextEditingController(text: cat?.centralTax.toString() ?? "0");
    _cessCtrl = TextEditingController(text: cat?.cessTax.toString() ?? "0");
    _remarksCtrl = TextEditingController(text: cat?.remarks ?? "");
    _type = cat?.type ?? "goods";
    _taxOnMRP = cat?.taxOnMRP ?? "no";
    _isDefaultStr = (cat?.isDefault ?? false) ? "yes" : "no";
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _cgstCtrl.dispose();
    _sgstCtrl.dispose();
    _igstCtrl.dispose();
    _cessCtrl.dispose();
    _remarksCtrl.dispose();
    super.dispose();
  }

  void _handleNameChange(String val) {
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
    final cess = double.tryParse(_cessCtrl.text) ?? 0;

    if (cgst > 0 && sgst == 0) {
      _showError("Please enter SGST value");
      return;
    }
    if (sgst > 0 && cgst == 0) {
      _showError("Please enter CGST value");
      return;
    }
    if (cgst == 0 && sgst == 0 && igst == 0) {
      _showError("Enter at least one tax value (CGST/SGST or IGST)");
      return;
    }

    final category = TaxCategoryModel(
      id: widget.taxCategory?.id ?? "",
      name: _nameCtrl.text.trim(),
      type: _type,
      localTax1: cgst,
      localTax2: sgst,
      centralTax: igst,
      cessTax: cess,
      taxOnMRP: _taxOnMRP,
      isDefault: _isDefaultStr == "yes",
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(widget.taxCategory != null ? "Tax Category updated!" : "Tax Category saved successfully!"),
        backgroundColor: Colors.green,
      ));
      Navigator.pop(context);
    } else if (mounted) {
      _showError(provider.error ?? "Operation failed");
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<TaxCategoryProvider>().isLoading;
    final isEdit = widget.taxCategory != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(isEdit ? "Edit Tax Category" : "Add Tax Category", 
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF1E293B))),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 70,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1000),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildFieldLabelled(
                          "Category Name", 
                          _nameCtrl, 
                          hint: "Ex: GST @12%", 
                          required: true,
                          onChanged: _handleNameChange,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: _buildDropdownLabelled(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildFieldLabelled("Local Tax 1 (CGST %)", _cgstCtrl, isNumber: true, hint: "0")),
                      const SizedBox(width: 24),
                      Expanded(child: _buildFieldLabelled("Local Tax 2 (SGST %)", _sgstCtrl, isNumber: true, hint: "0")),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildFieldLabelled("Central Tax (IGST %)", _igstCtrl, isNumber: true, hint: "0")),
                      const SizedBox(width: 24),
                      Expanded(
                        child: _buildDropdownLabelled(
                          "Default Tax", 
                          _isDefaultStr, 
                          ["no", "yes"], 
                          (val) => setState(() => _isDefaultStr = val!)
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildFieldLabelled(
                    "Remarks", 
                    _remarksCtrl, 
                    maxLines: 4, 
                    hint: "Remarks (optional)"
                  ),
                  const SizedBox(height: 32),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                      child: isLoading 
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Text(isEdit ? "Update Category" : "Save Category", 
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabelled(String label, TextEditingController ctrl, {String? hint, bool required = false, bool isNumber = false, int maxLines = 1, Function(String)? onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w500, fontSize: 13)),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl,
          maxLines: maxLines,
          keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
          onChanged: onChanged,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF2563EB))),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
          validator: (val) => required && (val == null || val.trim().isEmpty) ? "Please Enter $label" : null,
        ),
      ],
    );
  }

  Widget _buildDropdownLabelled(String label, String value, List<String> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w500, fontSize: 13)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          items: items.map((e) => DropdownMenuItem(
            value: e, 
            child: Text(e == "no" ? "No" : e == "yes" ? "Yes" : e[0].toUpperCase() + e.substring(1), 
              style: const TextStyle(fontSize: 13))
          )).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          ),
        ),
      ],
    );
  }
}
