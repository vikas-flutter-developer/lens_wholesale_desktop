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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF8FAFC), Color(0xFFEFF6FF)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(48.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                isEdit ? "Edit Account Group" : "Add Account Group Master",
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              ),
              const SizedBox(height: 32),

              // Main Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                padding: const EdgeInsets.all(40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Group Information", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                      const SizedBox(height: 32),
                      
                      LayoutBuilder(
                        builder: (context, constraints) {
                          double spacing = 32.0;
                          double itemWidth = (constraints.maxWidth - (spacing * 2)) / 3;
                          return Wrap(
                            spacing: spacing,
                            runSpacing: 24,
                            children: [
                              // Group Name
                              SizedBox(
                                width: itemWidth > 300 ? itemWidth : (constraints.maxWidth - spacing) / 2 > 300 ? (constraints.maxWidth - spacing) / 2 : constraints.maxWidth,
                                child: _buildTextField("Group Name", _nameCtrl, "Enter group name", required: true),
                              ),

                              // Primary Group
                              SizedBox(
                                width: itemWidth > 300 ? itemWidth : (constraints.maxWidth - spacing) / 2 > 300 ? (constraints.maxWidth - spacing) / 2 : constraints.maxWidth,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: const TextSpan(
                                        children: [
                                          TextSpan(text: "Primary Group ", style: TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w600, fontSize: 13)),
                                          TextSpan(text: "*", style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600, fontSize: 13)),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        _buildRadio("Yes", "Y"),
                                        const SizedBox(width: 32),
                                        _buildRadio("No", "N"),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Ledger Group
                              SizedBox(
                                width: itemWidth > 300 ? itemWidth : (constraints.maxWidth - spacing) / 2 > 300 ? (constraints.maxWidth - spacing) / 2 : constraints.maxWidth,
                                child: _buildTextField("Ledger Group", _ledgerCtrl, "Enter ledger group", required: true),
                              ),
                            ],
                          );
                        },
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
                              backgroundColor: const Color(0xFF2563EB),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
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
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
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
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController ctrl, String hint, {bool required = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(text: label, style: const TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w600, fontSize: 13)),
              if (required) const TextSpan(text: " *", style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600, fontSize: 13)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: ctrl,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.normal),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
    bool isSelected = _primaryGroup == value;
    return InkWell(
      onTap: () => setState(() => _primaryGroup = value),
      borderRadius: BorderRadius.circular(12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFCBD5E1), width: 2),
            ),
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(label, style: TextStyle(fontWeight: FontWeight.w500, color: isSelected ? const Color(0xFF1E293B) : const Color(0xFF64748B), fontSize: 14)),
        ],
      ),
    );
  }
}
