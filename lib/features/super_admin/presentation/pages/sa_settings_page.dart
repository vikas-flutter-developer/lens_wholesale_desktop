import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../data/providers/settings_provider.dart';
import '../../data/models/settings_model.dart';

class SASettingsPage extends StatefulWidget {
  const SASettingsPage({super.key});

  @override
  State<SASettingsPage> createState() => _SASettingsPageState();
}

class _SASettingsPageState extends State<SASettingsPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _appNameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _currencyCtrl;
  late TextEditingController _gstCtrl;
  late TextEditingController _addressCtrl;
  late TextEditingController _trialDaysCtrl;
  bool _maintenanceMode = false;
  bool _allowNewRegistrations = true;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _appNameCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _phoneCtrl = TextEditingController();
    _currencyCtrl = TextEditingController();
    _gstCtrl = TextEditingController();
    _addressCtrl = TextEditingController();
    _trialDaysCtrl = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SettingsProvider>().fetchSettings().then((_) {
        _populateForm();
      });
    });
  }

  void _populateForm() {
    final s = context.read<SettingsProvider>().settings;
    if (s != null && mounted) {
      setState(() {
        _appNameCtrl.text = s.appName;
        _emailCtrl.text = s.supportEmail;
        _phoneCtrl.text = s.supportPhone;
        _currencyCtrl.text = s.currency;
        _gstCtrl.text = s.gstNumber;
        _addressCtrl.text = s.address;
        _trialDaysCtrl.text = s.trialDays.toString();
        _maintenanceMode = s.maintenanceMode;
        _allowNewRegistrations = s.allowNewRegistrations;
        _initialized = true;
      });
    }
  }

  @override
  void dispose() {
    _appNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _currencyCtrl.dispose();
    _gstCtrl.dispose();
    _addressCtrl.dispose();
    _trialDaysCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<SettingsProvider>();
    final current = provider.settings;

    final updated = SystemSettingsModel(
      id: current?.id ?? '',
      appName: _appNameCtrl.text.trim(),
      supportEmail: _emailCtrl.text.trim(),
      supportPhone: _phoneCtrl.text.trim(),
      currency: _currencyCtrl.text.trim(),
      gstNumber: _gstCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      trialDays: int.tryParse(_trialDaysCtrl.text) ?? 14,
      maintenanceMode: _maintenanceMode,
      allowNewRegistrations: _allowNewRegistrations,
    );

    await provider.saveSettings(updated);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SettingsProvider>();

    if (provider.isLoading && !_initialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            "System Settings",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Color(0xFF0F172A), letterSpacing: -0.5),
          ),
          const SizedBox(height: 8),
          const Text(
            "Configure global platform defaults and operational parameters.",
            style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 32),

          // Success Banner
          if (provider.successMessage != null)
            Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                border: Border.all(color: Colors.green.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(LucideIcons.checkCircle, color: Colors.green.shade700),
                  const SizedBox(width: 12),
                  Text(provider.successMessage!, style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.w600)),
                ],
              ),
            ),

          // Error Banner
          if (provider.error != null)
            Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                border: Border.all(color: Colors.red.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(LucideIcons.alertCircle, color: Colors.red.shade700),
                  const SizedBox(width: 12),
                  Expanded(child: Text(provider.error!, style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w500))),
                ],
              ),
            ),

          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- General Settings Card ---
                _buildCard(
                  title: "General Configuration",
                  icon: LucideIcons.settings,
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildTextField("App / Platform Name *", _appNameCtrl, required: true)),
                        const SizedBox(width: 24),
                        Expanded(child: _buildTextField("Currency Code", _currencyCtrl, hint: "INR")),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: _buildTextField("Support Email", _emailCtrl, isEmail: true)),
                        const SizedBox(width: 24),
                        Expanded(child: _buildTextField("Support Phone", _phoneCtrl)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: _buildTextField("GST Number", _gstCtrl)),
                        const SizedBox(width: 24),
                        Expanded(child: _buildTextField("Free Trial Days", _trialDaysCtrl, isNum: true)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildTextField("Registered Address", _addressCtrl, maxLines: 3),
                  ],
                ),
                const SizedBox(height: 24),

                // --- Platform Controls Card ---
                _buildCard(
                  title: "Platform Controls",
                  icon: LucideIcons.shieldCheck,
                  children: [
                    _buildToggleRow(
                      label: "Maintenance Mode",
                      subtitle: "Temporarily lock the platform from all user access (Super Admin still accessible).",
                      value: _maintenanceMode,
                      onChanged: (val) => setState(() => _maintenanceMode = val),
                      warningColor: true,
                    ),
                    const Divider(height: 32, color: Color(0xFFF1F5F9)),
                    _buildToggleRow(
                      label: "Allow New Registrations",
                      subtitle: "Enable or disable new company sign-ups on the public landing page.",
                      value: _allowNewRegistrations,
                      onChanged: (val) => setState(() => _allowNewRegistrations = val),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Save Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: provider.isSaving ? null : _save,
                      icon: provider.isSaving
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(LucideIcons.save, size: 18, color: Colors.white),
                      label: Text(
                        provider.isSaving ? "Saving..." : "Save Settings",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 20, color: const Color(0xFF3B82F6)),
                ),
                const SizedBox(width: 12),
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController ctrl, {bool required = false, bool isEmail = false, bool isNum = false, int maxLines = 1, String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w500, fontSize: 13)),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl,
          maxLines: maxLines,
          keyboardType: isNum ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF3B82F6))),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          validator: (val) {
            if (required && (val == null || val.trim().isEmpty)) return "Required";
            if (isEmail && val != null && val.isNotEmpty && !val.contains('@')) return "Invalid email";
            if (isNum && val != null && val.isNotEmpty && int.tryParse(val) == null) return "Must be a number";
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildToggleRow({required String label, required String subtitle, required bool value, required ValueChanged<bool> onChanged, bool warningColor = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: warningColor && value ? Colors.amber.shade700 : const Color(0xFF1E293B),
                      fontSize: 15)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Switch(
          value: value,
          activeTrackColor: warningColor ? Colors.amber.shade600 : const Color(0xFF10B981),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
