import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../data/providers/plan_provider.dart';
import '../../data/models/plan_model.dart';

class SAPlansPage extends StatefulWidget {
  const SAPlansPage({super.key});

  @override
  State<SAPlansPage> createState() => _SAPlansPageState();
}

class _SAPlansPageState extends State<SAPlansPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlanProvider>().fetchPlans();
    });
  }

  void _showPlanModal([PlanModel? plan]) {
    showDialog(
      context: context,
      builder: (ctx) => PlanModal(plan: plan),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PlanProvider>();

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
                    "SaaS Plans",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Configure subscription tiers and global account limitations.",
                    style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _showPlanModal(),
                icon: const Icon(LucideIcons.plus, size: 18, color: Colors.white),
                label: const Text("New Plan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
            child: provider.isLoading && provider.plans.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(48.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : provider.plans.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(48.0),
                        child: Center(
                          child: Text(
                            "No plans found. Click 'New Plan' to create one.",
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
                            DataColumn(label: Text("Plan Name")),
                            DataColumn(label: Text("Monthly (₹)")),
                            DataColumn(label: Text("Yearly (₹)")),
                            DataColumn(label: Text("Max Users")),
                            DataColumn(label: Text("Max Branches")),
                            DataColumn(label: Text("Status")),
                            DataColumn(label: Text("Actions")),
                          ],
                          rows: provider.plans.map((plan) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  Text(plan.planName, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
                                ),
                                DataCell(Text(plan.monthlyPrice.toStringAsFixed(2))),
                                DataCell(Text(plan.yearlyPrice.toStringAsFixed(2))),
                                DataCell(Text(plan.maxUsers.toString())),
                                DataCell(Text(plan.maxBranches.toString())),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: plan.isActive ? Colors.green.shade50 : Colors.red.shade50,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: plan.isActive ? Colors.green.shade200 : Colors.red.shade200,
                                      ),
                                    ),
                                    child: Text(
                                      plan.isActive ? "Active" : "Archived",
                                      style: TextStyle(
                                        color: plan.isActive ? Colors.green.shade700 : Colors.red.shade700,
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
                                        onPressed: () => _showPlanModal(plan),
                                      ),
                                      Switch(
                                        value: plan.isActive,
                                        activeTrackColor: const Color(0xFF10B981),
                                        onChanged: (val) {
                                          provider.togglePlanStatus(plan.id, plan.isActive);
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

class PlanModal extends StatefulWidget {
  final PlanModel? plan;

  const PlanModal({super.key, this.plan});

  @override
  State<PlanModal> createState() => _PlanModalState();
}

class _PlanModalState extends State<PlanModal> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameCtrl;
  late TextEditingController _monthlyCtrl;
  late TextEditingController _yearlyCtrl;
  late TextEditingController _usersCtrl;
  late TextEditingController _branchesCtrl;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.plan?.planName ?? '');
    _monthlyCtrl = TextEditingController(text: widget.plan?.monthlyPrice.toString() ?? '0');
    _yearlyCtrl = TextEditingController(text: widget.plan?.yearlyPrice.toString() ?? '0');
    _usersCtrl = TextEditingController(text: widget.plan?.maxUsers.toString() ?? '1');
    _branchesCtrl = TextEditingController(text: widget.plan?.maxBranches.toString() ?? '1');
    _isActive = widget.plan?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _monthlyCtrl.dispose();
    _yearlyCtrl.dispose();
    _usersCtrl.dispose();
    _branchesCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<PlanProvider>();
    final newModel = PlanModel(
      id: widget.plan?.id ?? '',
      planName: _nameCtrl.text.trim(),
      monthlyPrice: double.tryParse(_monthlyCtrl.text) ?? 0,
      yearlyPrice: double.tryParse(_yearlyCtrl.text) ?? 0,
      maxUsers: int.tryParse(_usersCtrl.text) ?? 1,
      maxBranches: int.tryParse(_branchesCtrl.text) ?? 1,
      features: widget.plan?.features ?? [],
      isActive: _isActive,
    );

    bool success;
    if (widget.plan == null) {
      success = await provider.addPlan(newModel);
    } else {
      success = await provider.updatePlan(newModel);
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
        width: 500,
        padding: const EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.plan == null ? "Create Plan" : "Edit Plan",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 24),
              _buildTextField("Plan Name *", _nameCtrl, required: true),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextField("Monthly Price", _monthlyCtrl, isNum: true)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField("Yearly Price", _yearlyCtrl, isNum: true)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextField("Max Users", _usersCtrl, isNum: true)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField("Max Branches", _branchesCtrl, isNum: true)),
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
                  Text(_isActive ? "Active" : "Archived", style: const TextStyle(color: Color(0xFF64748B))),
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
                      widget.plan == null ? "Save Plan" : "Update Plan",
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

  Widget _buildTextField(String label, TextEditingController controller, {bool required = false, bool isNum = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w500, fontSize: 13)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: isNum ? TextInputType.number : TextInputType.text,
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
            if (isNum && val != null && val.isNotEmpty && double.tryParse(val) == null) {
              return "Invalid number";
            }
            return null;
          },
        ),
      ],
    );
  }
}
