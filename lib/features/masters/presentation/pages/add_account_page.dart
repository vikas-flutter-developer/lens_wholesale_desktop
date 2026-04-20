import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../data/providers/account_provider.dart';
import '../../data/providers/account_group_provider.dart';
import '../../data/models/account_model.dart';

class AddAccountPage extends StatefulWidget {
  final AccountModel? account;
  const AddAccountPage({super.key, this.account});

  @override
  State<AddAccountPage> createState() => _AddAccountPageState();
}

class _AddAccountPageState extends State<AddAccountPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  late TextEditingController _nameCtrl;
  late TextEditingController _aliasCtrl;
  late TextEditingController _printNameCtrl;
  late TextEditingController _accountIdCtrl;
  late TextEditingController _contactPersonCtrl;
  late TextEditingController _mobileNumberCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _addressCtrl;
  late TextEditingController _stateCtrl;
  late TextEditingController _pincodeCtrl;
  late TextEditingController _gstinCtrl;
  late TextEditingController _transporterCtrl;
  late TextEditingController _openingBalCtrl;
  late TextEditingController _prevYearBalCtrl;
  late TextEditingController _creditLimitCtrl;
  late TextEditingController _passwordCtrl;
  late TextEditingController _remarkCtrl;
  late TextEditingController _tagsCtrl;

  // Selection states
  List<String> _selectedGroups = [""];
  List<String> _selectedStations = [""];
  String _dealerType = "unregisterd";
  String _openingBalType = "Dr";
  String _prevYearBalType = "Dr";
  String _accountType = "Sale";
  String _accountCategory = "default";
  bool _showPassword = false;

  final List<String> _mumbaiStations = [
    "Churchgate", "Marine Lines", "Charni Road", "Grant Road", "Mumbai Central", "Mahalaxmi", "Lower Parel", "Prabhadevi", "Dadar", "Matunga Road", "Mahim", "Bandra", "Khar Road", "Santacruz", "Vile Parle", "Andheri", "Jogeshwari", "Goregaon", "Malad", "Kandivali", "Borivali", "Dahisar", "Mira Road", "Bhayandar", "Naigaon", "Vasai Road", "Nala Sopara", "Virar",
    "CST", "Masjid", "Sandhurst Road", "Byculla", "Currey Road", "Parel", "Matunga", "Sion", "Kurla", "Vidyavihar", "Ghatkopar", "Vikhroli", "Kanjurmarg", "Bhandup", "Mulund", "Thane", "Kalwa", "Mumbra", "Diva", "Belapur", "Panvel", "Dockyard Road", "Reay Road", "Cotton Green", "Seepz", "Chembur", "Govandi", "Mankhurd", "Vashi", "Sanpada", "Kharghar"
  ];

  @override
  void initState() {
    super.initState();
    final acc = widget.account;
    _nameCtrl = TextEditingController(text: acc?.name ?? "");
    _aliasCtrl = TextEditingController(text: acc?.alias ?? "");
    _printNameCtrl = TextEditingController(text: acc?.printName ?? "");
    _accountIdCtrl = TextEditingController(text: acc?.accountId ?? "");
    _contactPersonCtrl = TextEditingController(text: acc?.contactPerson ?? "");
    _mobileNumberCtrl = TextEditingController(text: acc?.mobileNumber ?? "");
    _emailCtrl = TextEditingController(text: acc?.email ?? "");
    _addressCtrl = TextEditingController(text: acc?.address ?? "");
    _stateCtrl = TextEditingController(text: acc?.state ?? "");
    _pincodeCtrl = TextEditingController(text: acc?.pincode ?? "");
    _gstinCtrl = TextEditingController(text: acc?.gstin ?? "");
    _transporterCtrl = TextEditingController(text: acc?.transporter ?? "");
    _openingBalCtrl = TextEditingController(text: acc?.openingBalance?.balance.toString() ?? "0");
    _prevYearBalCtrl = TextEditingController(text: acc?.previousYearBalance?.balance.toString() ?? "0");
    _creditLimitCtrl = TextEditingController(text: acc?.creditLimit?.toString() ?? "0");
    _passwordCtrl = TextEditingController(text: acc?.password ?? "");
    _remarkCtrl = TextEditingController(text: acc?.remark ?? "");
    _tagsCtrl = TextEditingController(text: acc?.tags?.join(", ") ?? "");

    if (acc != null) {
      _selectedGroups = acc.groups.isEmpty ? [""] : List.from(acc.groups);
      _selectedStations = acc.stations.isEmpty ? [""] : List.from(acc.stations);
      _dealerType = acc.accountDealerType ?? "unregisterd";
      _openingBalType = acc.openingBalance?.type ?? "Dr";
      _prevYearBalType = acc.previousYearBalance?.type ?? "Dr";
      _accountType = acc.accountType ?? "Sale";
      _accountCategory = acc.accountCategory ?? "default";
    } else {
      _fetchNextId();
    }
  }

  Future<void> _fetchNextId() async {
    final nextId = await context.read<AccountProvider>().fetchNextAccountId();
    if (nextId != null) {
      setState(() => _accountIdCtrl.text = nextId);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose(); _aliasCtrl.dispose(); _printNameCtrl.dispose(); _accountIdCtrl.dispose();
    _contactPersonCtrl.dispose(); _mobileNumberCtrl.dispose(); _emailCtrl.dispose(); _addressCtrl.dispose();
    _stateCtrl.dispose(); _pincodeCtrl.dispose(); _gstinCtrl.dispose(); _transporterCtrl.dispose();
    _openingBalCtrl.dispose(); _prevYearBalCtrl.dispose(); _creditLimitCtrl.dispose(); _passwordCtrl.dispose();
    _remarkCtrl.dispose(); _tagsCtrl.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<AccountProvider>();
    final isEdit = widget.account != null;

    final account = AccountModel(
      id: isEdit ? widget.account!.id : "",
      name: _nameCtrl.text.trim(),
      alias: _aliasCtrl.text.trim(),
      printName: _printNameCtrl.text.trim(),
      accountId: _accountIdCtrl.text.trim(),
      groups: _selectedGroups.where((g) => g.isNotEmpty).toList(),
      stations: _selectedStations.where((s) => s.isNotEmpty).toList(),
      accountDealerType: _dealerType,
      gstin: _gstinCtrl.text.trim(),
      transporter: _transporterCtrl.text.trim(),
      contactPerson: _contactPersonCtrl.text.trim(),
      openingBalance: BalanceModel(balance: double.tryParse(_openingBalCtrl.text) ?? 0, type: _openingBalType),
      previousYearBalance: BalanceModel(balance: double.tryParse(_prevYearBalCtrl.text) ?? 0, type: _prevYearBalType),
      creditLimit: double.tryParse(_creditLimitCtrl.text),
      enableLoyalty: "Y",
      accountCategory: _accountCategory,
      address: _addressCtrl.text.trim(),
      state: _stateCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      mobileNumber: _mobileNumberCtrl.text.trim(),
      pincode: _pincodeCtrl.text.trim(),
      accountType: _accountType,
      password: _passwordCtrl.text.trim(),
      remark: _remarkCtrl.text.trim(),
      tags: _tagsCtrl.text.split(",").where((t) => t.trim().isNotEmpty).map((t) => t.trim()).toList(),
    );

    bool success;
    if (isEdit) {
      success = await provider.updateAccount(account.id, account);
    } else {
      success = await provider.addAccount(account);
    }

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(isEdit ? "Account updated successfully!" : "Account created successfully!"),
        backgroundColor: Colors.green,
      ));
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(provider.error ?? "An error occurred"),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AccountProvider>().isLoading;
    final groups = context.watch<AccountGroupProvider>().accountGroups;
    final isEdit = widget.account != null;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF8FAFC), Color(0xFFEFF6FF)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Row(
                  children: const [
                    Icon(LucideIcons.arrowLeft, size: 20, color: Color(0xFF64748B)),
                    SizedBox(width: 8),
                    Text("Back to List", style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isEdit ? "Edit Account" : "Add Account",
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
              ),
              const SizedBox(height: 32),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Section 1: Basic Information
                    _buildSectionCard(
                      title: "Basic Information",
                      children: [
                        _buildGrid([
                          _buildTextField("Name *", _nameCtrl, required: true, hint: "Enter account name"),
                          _buildTextField("Print Name *", _printNameCtrl, required: true, hint: "Enter print name"),
                          _buildTextField("Account Id *", _accountIdCtrl, required: true, hint: "Unique ID"),
                          _buildTextField("Alias", _aliasCtrl, hint: "Short name"),
                        ]),
                      ],
                    ),

                    // Section 2: Groups & Stations
                    _buildSectionCard(
                      title: "Groups & Stations",
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _buildDynamicList("Groups", _selectedGroups, (idx) {
                              return Autocomplete<String>(
                                optionsBuilder: (textEditingValue) {
                                  return groups
                                      .map((e) => e.accountGroupName)
                                      .where((element) => element.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                                },
                                onSelected: (val) => setState(() => _selectedGroups[idx] = val),
                                fieldViewBuilder: (ctx, ctrl, focus, onFieldSubmitted) {
                                  if (ctrl.text != _selectedGroups[idx]) {
                                    Future.microtask(() => ctrl.text = _selectedGroups[idx]);
                                  }
                                  return _buildTextField(
                                    "", 
                                    ctrl, 
                                    hint: "Select Group", 
                                    focusNode: focus,
                                    onChanged: (val) => _selectedGroups[idx] = val,
                                  );
                                },
                              );
                            }, () => setState(() => _selectedGroups.add("")))),
                            const SizedBox(width: 32),
                            Expanded(child: _buildDynamicList("Stations", _selectedStations, (idx) {
                              return Autocomplete<String>(
                                optionsBuilder: (textEditingValue) {
                                  return _mumbaiStations.where((element) => element.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                                },
                                onSelected: (val) => setState(() => _selectedStations[idx] = val),
                                fieldViewBuilder: (ctx, ctrl, focus, onFieldSubmitted) {
                                  if (ctrl.text != _selectedStations[idx]) {
                                    Future.microtask(() => ctrl.text = _selectedStations[idx]);
                                  }
                                  return _buildTextField(
                                    "", 
                                    ctrl, 
                                    hint: "Select Station", 
                                    focusNode: focus,
                                    onChanged: (val) => _selectedStations[idx] = val,
                                  );
                                },
                              );
                            }, () => setState(() => _selectedStations.add("")))),
                          ],
                        ),
                      ],
                    ),

                    // Section 3: Contact & Identifiers
                    _buildSectionCard(
                      title: "Contact & Identifiers",
                      children: [
                        _buildGrid([
                          _buildTextField("Contact Person", _contactPersonCtrl, hint: "Name"),
                          _buildTextField("Mobile Number", _mobileNumberCtrl, hint: "10-digit number"),
                          _buildTextField("Email", _emailCtrl, hint: "example@mail.com"),
                          _buildDropdownField("Account Type", _accountType, ["Sale", "Purchase", "Both"], (val) => setState(() => _accountType = val!)),
                        ]),
                        const SizedBox(height: 24),
                        _buildGrid([
                          _buildTextField("Address", _addressCtrl, hint: "Full address", spans: 2),
                          _buildTextField("State", _stateCtrl, hint: "e.g. Maharashtra"),
                          _buildTextField("Pincode", _pincodeCtrl, hint: "6 digits"),
                        ]),
                      ],
                    ),

                    // Section 4: GST & Financials
                    _buildSectionCard(
                      title: "GST & Financials",
                      children: [
                        _buildGrid([
                          _buildTextField("GSTIN", _gstinCtrl, hint: "GST Number"),
                          _buildDropdownField("Dealer Type", _dealerType, ["Registerd", "unregisterd", "composition", "uin holder"], (val) => setState(() => _dealerType = val!)),
                          _buildTextField("Transporter", _transporterCtrl, hint: "Transporter name"),
                          _buildTextField("Credit Limit", _creditLimitCtrl, hint: "Max credit"),
                        ]),
                        const SizedBox(height: 24),
                        _buildGrid([
                          _buildBalanceInputField("Opening Balance", _openingBalCtrl, _openingBalType, (val) => setState(() => _openingBalType = val!)),
                          _buildBalanceInputField("Prev Year Balance", _prevYearBalCtrl, _prevYearBalType, (val) => setState(() => _prevYearBalType = val!)),
                          _buildDropdownField("Account Category", _accountCategory, ["default", "category1", "category2", "category3", "category4", "category5"], (val) => setState(() => _accountCategory = val!)),
                          const SizedBox(), // Spacer
                        ]),
                      ],
                    ),

                    // Section 5: Notes & Tags
                    _buildSectionCard(
                      title: "Notes & Tags",
                      children: [
                        _buildGrid([
                          _buildTextField("Remark", _remarkCtrl, hint: "Internal notes", maxLines: 2, spans: 2),
                          _buildTextField("Tags", _tagsCtrl, hint: "e.g. VIP, Wholesale (comma separated)", maxLines: 2, spans: 2),
                        ]),
                      ],
                    ),

                    const SizedBox(height: 48),

                    // Actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSubmitButton(
                          onPressed: isLoading ? null : _handleSubmit,
                          isLoading: isLoading,
                          label: isEdit ? "Update Account" : "Save Account",
                          icon: LucideIcons.save,
                          color: const Color(0xFF2563EB),
                        ),
                        const SizedBox(width: 16),
                        _buildSubmitButton(
                          onPressed: () => Navigator.pop(context),
                          isLoading: false,
                          label: "Cancel",
                          icon: LucideIcons.rotateCcw,
                          color: const Color(0xFF64748B),
                          isSecondary: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 20, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 4, height: 20, decoration: BoxDecoration(color: const Color(0xFF2563EB), borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 12),
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            ],
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildGrid(List<Widget> children) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: 16,
          runSpacing: 24,
          children: children.map((c) {
            final w = (constraints.maxWidth - 48) / 4;
            return SizedBox(width: w, child: c);
          }).toList(),
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController ctrl, {bool required = false, String? hint, int maxLines = 1, FocusNode? focusNode, int spans = 1, Function(String)? onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(label, style: const TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: ctrl,
          maxLines: maxLines,
          focusNode: focusNode,
          onChanged: onChanged,
          style: const TextStyle(fontSize: 14),
          decoration: _inputDecoration(hint: hint),
          validator: (val) => required && (val == null || val.trim().isEmpty) ? "Field is required" : null,
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String value, List<String> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14)))).toList(),
          onChanged: onChanged,
          decoration: _inputDecoration(),
        ),
      ],
    );
  }

  Widget _buildBalanceInputField(String label, TextEditingController ctrl, String type, Function(String?) onTypeChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: TextFormField(controller: ctrl, decoration: _inputDecoration())),
            const SizedBox(width: 8),
            SizedBox(
              width: 90,
              child: DropdownButtonFormField<String>(
                value: type,
                items: const [
                  DropdownMenuItem(value: "Dr", child: Text("Dr", style: TextStyle(fontSize: 13))),
                  DropdownMenuItem(value: "Cr", child: Text("Cr", style: TextStyle(fontSize: 13))),
                ],
                onChanged: onTypeChanged,
                decoration: _inputDecoration().copyWith(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                ),
                icon: const Icon(LucideIcons.chevronDown, size: 14),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDynamicList(String label, List<String> items, Widget Function(int) builder, VoidCallback onAdd) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: const TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.bold, fontSize: 13)),
            const Spacer(),
            TextButton.icon(
              onPressed: onAdd,
              icon: const Icon(LucideIcons.plusCircle, size: 16),
              label: const Text("Add More", style: TextStyle(fontWeight: FontWeight.bold)),
              style: TextButton.styleFrom(foregroundColor: const Color(0xFF16A34A)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...List.generate(items.length, (idx) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              children: [
                Expanded(child: builder(idx)),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(LucideIcons.trash2, size: 20, color: Color(0xFFDC2626)),
                  onPressed: () {
                    if (items.length > 1) {
                      setState(() => items.removeAt(idx));
                    }
                  },
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSubmitButton({required VoidCallback? onPressed, required bool isLoading, required String label, required IconData icon, required Color color, bool isSecondary = false}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Icon(icon, size: 20),
      label: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSecondary ? const Color(0xFFF1F5F9) : color,
        foregroundColor: isSecondary ? const Color(0xFF475569) : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
    );
  }

  InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2)),
      errorStyle: const TextStyle(fontSize: 12),
    );
  }
}
