import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../data/providers/user_provider.dart';
import '../../data/models/user_model.dart';
import '../../data/providers/company_provider.dart';

class SAUsersPage extends StatefulWidget {
  const SAUsersPage({super.key});

  @override
  State<SAUsersPage> createState() => _SAUsersPageState();
}

class _SAUsersPageState extends State<SAUsersPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().fetchUsers();
      // Pre-fetch companies for the dropdown in case it's not loaded
      if (context.read<CompanyProvider>().companies.isEmpty) {
        context.read<CompanyProvider>().fetchCompanies();
      }
    });
  }

  void _showUserModal([UserModel? user]) {
    showDialog(
      context: context,
      builder: (ctx) => UserModal(user: user),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();
    final companyProvider = context.watch<CompanyProvider>();

    String getCompanyName(String companyId) {
      if (companyId.isEmpty) return "Global";
      try {
        return companyProvider.companies.firstWhere((c) => c.id == companyId).companyName;
      } catch (e) {
        return companyId;
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Global Users",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Manage all platform users across various branches.",
                    style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _showUserModal(),
                icon: const Icon(LucideIcons.plus, size: 18, color: Colors.white),
                label: const Text("Add User", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          if (provider.error != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                border: Border.all(color: Colors.red.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(LucideIcons.alertCircle, color: Colors.red.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      provider.error!,
                      style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ],

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF1F5F9)),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            width: double.infinity,
            child: provider.isLoading && provider.users.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(48.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : provider.users.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(48.0),
                        child: Center(
                          child: Text(
                            "No users found. Click 'Add User' to create one.",
                            style: TextStyle(color: Color(0xFF64748B), fontSize: 16),
                          ),
                        ),
                      )
                    : Theme(
                        data: Theme.of(context).copyWith(
                          dataTableTheme: DataTableThemeData(
                            headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                            headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                          ),
                        ),
                        child: DataTable(
                          columnSpacing: 24,
                          horizontalMargin: 24,
                          showBottomBorder: true,
                          columns: const [
                            DataColumn(label: Text("Name")),
                            DataColumn(label: Text("Contact")),
                            DataColumn(label: Text("Company/Branch")),
                            DataColumn(label: Text("Role")),
                            DataColumn(label: Text("Status")),
                            DataColumn(label: Text("Actions")),
                          ],
                          rows: provider.users.map((user) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  Text(user.name, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
                                ),
                                DataCell(
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(user.phone),
                                      Text(user.email, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                                    ],
                                  ),
                                ),
                                DataCell(
                                  Text(getCompanyName(user.companyId), style: const TextStyle(fontWeight: FontWeight.w500)),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      user.role.toUpperCase(),
                                      style: TextStyle(color: Colors.blue.shade700, fontSize: 11, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: user.isActive ? Colors.green.shade50 : Colors.red.shade50,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: user.isActive ? Colors.green.shade200 : Colors.red.shade200,
                                      ),
                                    ),
                                    child: Text(
                                      user.isActive ? "Active" : "Inactive",
                                      style: TextStyle(
                                        color: user.isActive ? Colors.green.shade700 : Colors.red.shade700,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(LucideIcons.edit2, size: 18, color: Color(0xFF3B82F6)),
                                        tooltip: "Edit",
                                        onPressed: () => _showUserModal(user),
                                      ),
                                      Switch(
                                        value: user.isActive,
                                        activeTrackColor: const Color(0xFF10B981),
                                        onChanged: (val) {
                                          provider.toggleUserStatus(user.id, user.isActive);
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

class UserModal extends StatefulWidget {
  final UserModel? user;

  const UserModal({super.key, this.user});

  @override
  State<UserModal> createState() => _UserModalState();
}

class _UserModalState extends State<UserModal> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;
  String _role = 'staff';
  String _companyId = '';
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.user?.name ?? '');
    _emailCtrl = TextEditingController(text: widget.user?.email ?? '');
    _phoneCtrl = TextEditingController(text: widget.user?.phone ?? '');
    _role = widget.user?.role ?? 'staff';
    _companyId = widget.user?.companyId ?? '';
    _isActive = widget.user?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<UserProvider>();
    final newModel = UserModel(
      id: widget.user?.id ?? '',
      companyId: _companyId,
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      role: _role,
      isActive: _isActive,
    );

    bool success;
    if (widget.user == null) {
      success = await provider.addUser(newModel);
    } else {
      success = await provider.updateUser(newModel);
    }

    if (success && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final companies = context.read<CompanyProvider>().companies;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user == null ? "Add New User" : "Edit User",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 24),
              _buildTextField("Full Name *", _nameCtrl, required: true),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextField("Email", _emailCtrl, isEmail: true)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField("Phone *", _phoneCtrl, required: true)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Role", style: TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w500, fontSize: 13)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            underline: const SizedBox(),
                            value: _role,
                            items: const [
                              DropdownMenuItem(value: 'super_admin', child: Text("Super Admin")),
                              DropdownMenuItem(value: 'admin', child: Text("Admin")),
                              DropdownMenuItem(value: 'sales', child: Text("Sales")),
                              DropdownMenuItem(value: 'staff', child: Text("Staff")),
                            ],
                            onChanged: (val) => setState(() => _role = val ?? 'staff'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Company", style: TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w500, fontSize: 13)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            underline: const SizedBox(),
                            value: _companyId.isEmpty ? null : _companyId,
                            hint: const Text("Global / None"),
                            items: companies.map((c) {
                              return DropdownMenuItem(value: c.id, child: Text(c.companyName));
                            }).toList()
                              ..insert(0, const DropdownMenuItem(value: '', child: Text("Global / None"))),
                            onChanged: (val) => setState(() => _companyId = val ?? ''),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text("Status: ", style: TextStyle(fontWeight: FontWeight.w600)),
                  Switch(
                    value: _isActive,
                    activeTrackColor: const Color(0xFF10B981),
                    onChanged: (val) => setState(() => _isActive = val),
                  ),
                  Text(_isActive ? "Active" : "Inactive", style: const TextStyle(color: Color(0xFF64748B))),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Cancel", style: TextStyle(color: Color(0xFF64748B))),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      widget.user == null ? "Save User" : "Update User",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool required = false, bool isEmail = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w500, fontSize: 13)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF3B82F6))),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          validator: (val) {
            if (required && (val == null || val.trim().isEmpty)) {
              return "Required";
            }
            if (isEmail && val != null && val.isNotEmpty && !val.contains('@')) {
              return "Invalid email";
            }
            return null;
          },
        ),
      ],
    );
  }
}
