import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../data/providers/account_group_provider.dart';
import '../../data/models/account_group_model.dart';

class AddAccountGroupPage extends StatefulWidget {
  final AccountGroupModel? accountGroup;
  const AddAccountGroupPage({super.key, this.accountGroup});

  @override
  State<AddAccountGroupPage> createState() => _AddAccountGroupPageState();
}

class _AddAccountGroupPageState extends State<AddAccountGroupPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _ledgerCtrl;
  String _primaryGroup = "Y";

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.accountGroup?.accountGroupName ?? "");
    _ledgerCtrl = TextEditingController(text: widget.accountGroup?.ledgerGroup ?? "");
    _primaryGroup = widget.accountGroup?.primaryGroup ?? "Y";
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _ledgerCtrl.dispose();
    super.dispose();
  }

  void _handleReset() {
    setState(() {
      _nameCtrl.clear();
      _ledgerCtrl.clear();
      _primaryGroup = "Y";
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<AccountGroupProvider>();
    final isEdit = widget.accountGroup != null;
    
    final group = AccountGroupModel(
      id: isEdit ? widget.accountGroup!.id : "",
      accountGroupName: _nameCtrl.text.trim(),
      primaryGroup: _primaryGroup,
      ledgerGroup: _ledgerCtrl.text.trim(),
    );

    bool success;
    if (isEdit) {
      success = await provider.updateAccountGroup(group.id, group);
    } else {
      success = await provider.addAccountGroup(group);
    }

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isEdit ? "Account Group Updated Successfully!" : "Account Group Created Successfully!")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AccountGroupProvider>().isLoading;
    final isEdit = widget.accountGroup != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(isEdit ? "Edit Account Group" : "Add Account Group Master", style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              padding: const EdgeInsets.all(32),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Group Information", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                    const SizedBox(height: 24),
                    
                    Wrap(
                      spacing: 32,
                      runSpacing: 24,
                      children: [
                        // Group Name
                        SizedBox(
                          width: 300,
                          child: _buildTextField("Group Name *", _nameCtrl, "Enter group name", required: true),
                        ),

                        // Primary Group
                        SizedBox(
                          width: 300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Primary Group *", style: TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w600, fontSize: 13)),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  _buildRadio("Yes", "Y"),
                                  const SizedBox(width: 24),
                                  _buildRadio("No", "N"),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Ledger Group
                        SizedBox(
                          width: 300,
                          child: _buildTextField("Ledger Group *", _ledgerCtrl, "Enter ledger group", required: true),
                        ),
                      ],
                    ),

                    const SizedBox(height: 48),

                    // Controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: isLoading ? null : _handleSubmit,
                          icon: isLoading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(LucideIcons.save, size: 18),
                          label: Text(isEdit ? "Update Group" : "Save Group", style: const TextStyle(fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B82F6),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: _handleReset,
                          icon: const Icon(LucideIcons.rotateCcw, size: 18),
                          label: const Text("Reset", style: TextStyle(fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF1F5F9),
                            foregroundColor: const Color(0xFF475569),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController ctrl, String hint, {bool required = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 8),
        TextFormField(
          controller: ctrl,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.normal),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF3B82F6))),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          validator: (val) {
            if (required && (val == null || val.trim().isEmpty)) return "Required";
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildRadio(String label, String value) {
    return InkWell(
      onTap: () => setState(() => _primaryGroup = value),
      borderRadius: BorderRadius.circular(8),
      child: Row(
        children: [
          Radio<String>(
            value: value,
            groupValue: _primaryGroup,
            activeColor: const Color(0xFF3B82F6),
            onChanged: (val) => setState(() => _primaryGroup = val!),
          ),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF475569))),
        ],
      ),
    );
  }
}
