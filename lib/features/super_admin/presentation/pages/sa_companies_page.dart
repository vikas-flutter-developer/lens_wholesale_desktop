import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../data/providers/company_provider.dart';
import '../../data/models/company_model.dart';

class SACompaniesPage extends StatefulWidget {
  const SACompaniesPage({super.key});

  @override
  State<SACompaniesPage> createState() => _SACompaniesPageState();
}

class _SACompaniesPageState extends State<SACompaniesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CompanyProvider>().fetchCompanies();
    });
  }

  void _showCompanyModal([CompanyModel? company]) {
    showDialog(
      context: context,
      builder: (ctx) => CompanyModal(company: company),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CompanyProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Manage Companies",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Add, update, or deactivate branch and tenant accounts.",
                    style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _showCompanyModal(),
                icon: const Icon(LucideIcons.plus, size: 18, color: Colors.white),
                label: const Text("Add Company", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981), // emerald-500
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Error Block
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

          // Data Table Container
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
            child: provider.isLoading && provider.companies.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(48.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : provider.companies.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(48.0),
                        child: Center(
                          child: Text(
                            "No companies found. Click 'Add Company' to create one.",
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
                            DataColumn(label: Text("Company Name")),
                            DataColumn(label: Text("Owner")),
                            DataColumn(label: Text("Contact")),
                            DataColumn(label: Text("GSTIN")),
                            DataColumn(label: Text("Status")),
                            DataColumn(label: Text("Actions")),
                          ],
                          rows: provider.companies.map((company) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  Text(company.companyName, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
                                ),
                                DataCell(Text(company.ownerName)),
                                DataCell(
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(company.phone),
                                      Text(company.email, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                                    ],
                                  ),
                                ),
                                DataCell(Text(company.gstin.isEmpty ? "N/A" : company.gstin)),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: company.isActive ? Colors.green.shade50 : Colors.red.shade50,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: company.isActive ? Colors.green.shade200 : Colors.red.shade200,
                                      ),
                                    ),
                                    child: Text(
                                      company.isActive ? "Active" : "Inactive",
                                      style: TextStyle(
                                        color: company.isActive ? Colors.green.shade700 : Colors.red.shade700,
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
                                        onPressed: () => _showCompanyModal(company),
                                      ),
                                      Switch(
                                        value: company.isActive,
                                        activeTrackColor: const Color(0xFF10B981),
                                        onChanged: (val) {
                                          provider.toggleCompanyStatus(company.id, company.isActive);
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

class CompanyModal extends StatefulWidget {
  final CompanyModel? company;

  const CompanyModal({super.key, this.company});

  @override
  State<CompanyModal> createState() => _CompanyModalState();
}

class _CompanyModalState extends State<CompanyModal> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameCtrl;
  late TextEditingController _ownerCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _gstinCtrl;
  late TextEditingController _addressCtrl;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.company?.companyName ?? '');
    _ownerCtrl = TextEditingController(text: widget.company?.ownerName ?? '');
    _emailCtrl = TextEditingController(text: widget.company?.email ?? '');
    _phoneCtrl = TextEditingController(text: widget.company?.phone ?? '');
    _gstinCtrl = TextEditingController(text: widget.company?.gstin ?? '');
    _addressCtrl = TextEditingController(text: widget.company?.address ?? '');
    _isActive = widget.company?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _ownerCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _gstinCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<CompanyProvider>();
    final newModel = CompanyModel(
      id: widget.company?.id ?? '',
      companyName: _nameCtrl.text.trim(),
      ownerName: _ownerCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      gstin: _gstinCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      isActive: _isActive,
    );

    bool success;
    if (widget.company == null) {
      success = await provider.addCompany(newModel);
    } else {
      success = await provider.updateCompany(newModel);
    }

    if (success && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.company == null ? "Add New Company" : "Edit Company",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField("Company Name *", _nameCtrl, required: true),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField("Owner Name", _ownerCtrl),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField("Email", _emailCtrl, isEmail: true),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField("Phone *", _phoneCtrl, required: true),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField("GSTIN", _gstinCtrl),
              const SizedBox(height: 16),
              _buildTextField("Address", _addressCtrl, maxLines: 2),
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
                      widget.company == null ? "Save Company" : "Update Company",
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

  Widget _buildTextField(String label, TextEditingController controller, {bool required = false, bool isEmail = false, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w500, fontSize: 13)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
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
              return "This field is required";
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
