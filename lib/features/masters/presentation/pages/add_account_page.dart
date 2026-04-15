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
      _selectedGroups = acc.groups.isEmpty ? [""] : acc.groups;
      _selectedStations = acc.stations.isEmpty ? [""] : acc.stations;
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
      tags: _tagsCtrl.text.split(",").map((t) => t.trim()).toList(),
    );

    bool success;
    if (isEdit) {
      success = await provider.updateAccount(account.id, account);
    } else {
      success = await provider.addAccount(account);
    }

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isEdit ? "Account updated successfully!" : "Account created successfully!")));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AccountProvider>().isLoading;
    final groups = context.watch<AccountGroupProvider>().accountGroups;
    final isEdit = widget.account != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(isEdit ? "Edit Account" : "Add Account Master", style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection("Basic Information", [
                _buildRow([
                  _buildTextField("Name *", _nameCtrl, required: true),
                  _buildTextField("Print Name *", _printNameCtrl, required: true),
                  _buildTextField("Account Id *", _accountIdCtrl, required: true),
                  _buildTextField("Alias", _aliasCtrl),
                ]),
                const SizedBox(height: 24),
                _buildDynamicList("Groups *", _selectedGroups, (idx) {
                  return Autocomplete<String>(
                    optionsBuilder: (textEditingValue) {
                      return groups.map((e) => e.accountGroupName).where((element) => element.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                    },
                    onSelected: (val) => setState(() => _selectedGroups[idx] = val),
                    fieldViewBuilder: (ctx, ctrl, focus, onFieldSubmitted) {
                      if (ctrl.text != _selectedGroups[idx]) ctrl.text = _selectedGroups[idx];
                      return _buildTextField("", ctrl, hint: "Select Group", focusNode: focus);
                    },
                  );
                }, () => setState(() => _selectedGroups.add(""))),
                const SizedBox(height: 16),
                _buildDynamicList("Stations *", _selectedStations, (idx) {
                  return Autocomplete<String>(
                    optionsBuilder: (textEditingValue) {
                      return _mumbaiStations.where((element) => element.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                    },
                    onSelected: (val) => setState(() => _selectedStations[idx] = val),
                    fieldViewBuilder: (ctx, ctrl, focus, onFieldSubmitted) {
                      if (ctrl.text != _selectedStations[idx]) ctrl.text = _selectedStations[idx];
                      return _buildTextField("", ctrl, hint: "Select Station", focusNode: focus);
                    },
                  );
                }, () => setState(() => _selectedStations.add(""))),
              ]),

              _buildSection("Contact Information", [
                _buildRow([
                  _buildTextField("Contact Person", _contactPersonCtrl),
                  _buildTextField("Mobile Number", _mobileNumberCtrl),
                  _buildTextField("Email", _emailCtrl),
                  _buildDropdown("Account Type", _accountType, ["Sale", "Purchase", "Both"], (val) => setState(() => _accountType = val!)),
                ]),
                const SizedBox(height: 16),
                _buildRow([
                  _buildTextField("Address", _addressCtrl, flex: 2),
                  _buildTextField("State", _stateCtrl),
                  _buildTextField("Pincode", _pincodeCtrl),
                ]),
                if (_accountType == "Sale") ...[
                  const SizedBox(height: 16),
                  _buildTextField("App Password", _passwordCtrl, isPassword: !_showPassword, suffixIcon: IconButton(icon: Icon(_showPassword ? LucideIcons.eye : LucideIcons.eyeOff), onPressed: () => setState(() => _showPassword = !_showPassword))),
                ]
              ]),

              _buildSection("GST & Financials", [
                _buildRow([
                  _buildTextField("GSTIN", _gstinCtrl),
                  _buildDropdown("Dealer Type", _dealerType, ["Registerd", "unregisterd", "composition", "uin holder"], (val) => setState(() => _dealerType = val!)),
                  _buildTextField("Transporter", _transporterCtrl),
                  _buildTextField("Credit Limit", _creditLimitCtrl),
                ]),
                const SizedBox(height: 16),
                _buildRow([
                  _buildBalanceField("Opening Balance", _openingBalCtrl, _openingBalType, (val) => setState(() => _openingBalType = val!)),
                  _buildBalanceField("Prev Year Balance", _prevYearBalCtrl, _prevYearBalType, (val) => setState(() => _prevYearBalType = val!)),
                  _buildDropdown("Account Category", _accountCategory, ["default", "category1", "category2", "category3", "category4", "category5"], (val) => setState(() => _accountCategory = val!)),
                ]),
              ]),

              _buildSection("Notes & Tags", [
                _buildTextField("Remark", _remarkCtrl, maxLines: 2),
                const SizedBox(height: 16),
                _buildTextField("Tags (comma separated)", _tagsCtrl, hint: "e.g. VIP, Wholesale"),
              ]),

              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: isLoading ? null : _handleSubmit,
                    icon: isLoading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(LucideIcons.save, size: 18),
                    label: Text(isEdit ? "Update Account" : "Save Account", style: const TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(LucideIcons.x, size: 18),
                    label: const Text("Cancel"),
                    style: TextButton.styleFrom(foregroundColor: const Color(0xFF64748B), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20)),
                  ),
                ],
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        const SizedBox(height: 24),
        ...children,
      ]),
    );
  }

  Widget _buildRow(List<Widget> children) {
    return Wrap(spacing: 16, runSpacing: 16, children: children.map((c) => SizedBox(width: 250, child: c)).toList());
  }

  Widget _buildTextField(String label, TextEditingController ctrl, {bool required = false, bool isPassword = false, Widget? suffixIcon, String? hint, int maxLines = 1, FocusNode? focusNode, int flex = 1}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (label.isNotEmpty) ...[Text(label, style: const TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w600, fontSize: 13)), const SizedBox(height: 8)],
      TextFormField(
        controller: ctrl,
        obscureText: isPassword,
        maxLines: maxLines,
        focusNode: focusNode,
        decoration: InputDecoration(
          hintText: hint,
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: const Color(0xFFF8FAFC),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF3B82F6))),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        validator: (val) => required && (val == null || val.trim().isEmpty) ? "Required" : null,
      ),
    ]);
  }

  Widget _buildDropdown(String label, String value, List<String> items, Function(String?) onChanged) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w600, fontSize: 13)),
      const SizedBox(height: 8),
      DropdownButtonFormField<String>(
        value: value,
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF8FAFC),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    ]);
  }

  Widget _buildBalanceField(String label, TextEditingController ctrl, String type, Function(String?) onTypeChanged) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w600, fontSize: 13)),
      const SizedBox(height: 8),
      Row(children: [
        Expanded(child: _buildTextField("", ctrl)),
        const SizedBox(width: 8),
        SizedBox(
          width: 80,
          child: DropdownButtonFormField<String>(
            value: type,
            items: const [DropdownMenuItem(value: "Dr", child: Text("Dr")), DropdownMenuItem(value: "Cr", child: Text("Cr"))],
            onChanged: onTypeChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            ),
          ),
        ),
      ]),
    ]);
  }

  Widget _buildDynamicList(String label, List<String> items, Widget Function(int) builder, VoidCallback onAdd) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text(label, style: const TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w600, fontSize: 13)),
        const Spacer(),
        TextButton.icon(onPressed: onAdd, icon: const Icon(LucideIcons.plus, size: 14), label: const Text("Add More", style: TextStyle(fontSize: 12))),
      ]),
      const SizedBox(height: 8),
      ...List.generate(items.length, (idx) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(children: [
            Expanded(child: builder(idx)),
            const SizedBox(width: 8),
            IconButton(icon: const Icon(LucideIcons.trash2, size: 18, color: Colors.red), onPressed: () => setState(() => items.removeAt(idx))),
          ]),
        );
      }),
    ]);
  }
}
