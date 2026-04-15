import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../data/models/lens_group_model.dart';
import '../../data/providers/inventory_providers.dart';
import '../widgets/matrix_edit_dialog.dart';

class AddLensGroupPage extends StatefulWidget {
  final bool hideHeader;
  final String? id;

  const AddLensGroupPage({super.key, this.hideHeader = false, this.id});

  @override
  State<AddLensGroupPage> createState() => _AddLensGroupPageState();
}

class _AddLensGroupPageState extends State<AddLensGroupPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Basic Info
  String? _selectedGroupName;
  String? _selectedProductName;
  final _vendorItemNameController = TextEditingController();
  final _billItemNameController = TextEditingController();
  
  // Power Range
  final _sphMinController = TextEditingController(text: '0.00');
  final _sphMaxController = TextEditingController(text: '0.00');
  final _sphStepController = TextEditingController(text: '0.25');
  final _cylMinController = TextEditingController(text: '0.00');
  final _cylMaxController = TextEditingController(text: '0.00');
  final _cylStepController = TextEditingController(text: '0.25');
  final _addMinController = TextEditingController(text: '0.00');
  final _addMaxController = TextEditingController(text: '0.00');
  final _addStepController = TextEditingController(text: '0.25');
  final _axisController = TextEditingController(text: '0');
  String _selectedEye = 'RL';

  bool _addBarcodeWithPower = false;
  LensGroupModel? _currentLensData;
  bool _isLoading = false;
  bool _showLibrary = false;
  List<dynamic> _libraryRanges = [];
  int? _activePowerGroupIdx;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<ItemGroupProvider>().fetchGroups();
      context.read<ItemMasterProvider>().fetchItems();
      
      if (widget.id != null) {
        // If ID provided, we need to find the product name first or fetch by ID
        // Assuming provider has getByProduct, but maybe we need getById
        final provider = context.read<LensGroupProvider>();
        final all = await provider.getAllLensPower();
        final lens = all.firstWhere((element) => (element['_id'] ?? element['id']) == widget.id, orElse: () => {});
        if (lens.isNotEmpty) {
           setState(() {
              _selectedProductName = lens['productName'];
           });
           await _fetchLensData();
        }
      }
    });
  }

  Future<void> _fetchLensData() async {
    if (_selectedProductName == null) return;
    setState(() => _isLoading = true);
    final data = await context.read<LensGroupProvider>().getLensPower(productName: _selectedProductName);
    if (mounted) {
      setState(() {
        _currentLensData = data;
        if (data != null) {
          _selectedGroupName = data.groupName;
          _vendorItemNameController.text = data.vendorItemName;
          _billItemNameController.text = data.billItemName;
          _activePowerGroupIdx = (data.powerGroups?.isNotEmpty ?? false) ? 0 : null;
        }
        _isLoading = false;
      });
    }
  }

  Future<void> _handleCreate() async {
    if (_selectedGroupName == null || _selectedProductName == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select Group and Product')));
      return;
    }

    final data = {
      'groupName': _selectedGroupName,
      'productName': _selectedProductName,
      'vendorItemName': _vendorItemNameController.text,
      'billItemName': _billItemNameController.text,
      'sphMin': double.tryParse(_sphMinController.text) ?? 0,
      'sphMax': double.tryParse(_sphMaxController.text) ?? 0,
      'sphStep': double.tryParse(_sphStepController.text) ?? 0.25,
      'cylMin': double.tryParse(_cylMinController.text) ?? 0,
      'cylMax': double.tryParse(_cylMaxController.text) ?? 0,
      'cylStep': double.tryParse(_cylStepController.text) ?? 0.25,
      'addMin': double.tryParse(_addMinController.text) ?? 0,
      'addMax': double.tryParse(_addMaxController.text) ?? 0,
      'addStep': double.tryParse(_addStepController.text) ?? 0.25,
      'axis': int.tryParse(_axisController.text) ?? 0,
      'eye': _selectedEye,
      'generateBarcodes': _addBarcodeWithPower,
    };

    try {
      setState(() => _isLoading = true);
      await context.read<LensGroupProvider>().addLensPower(data);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lens Power Created!')));
      await _fetchLensData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleUpdate() async {
    if (_currentLensData == null) return;
    try {
      setState(() => _isLoading = true);
      final data = _currentLensData!.toJson();
      data['vendorItemName'] = _vendorItemNameController.text;
      data['billItemName'] = _billItemNameController.text;
      
      await context.read<LensGroupProvider>().editLensPower(data);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lens Power Updated!')));
      await _fetchLensData();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleDelete() async {
    if (_currentLensData == null || _currentLensData!.id == null) return;
    try {
      setState(() => _isLoading = true);
      await context.read<LensGroupProvider>().removeLensPower([_currentLensData!.id!]);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lens Power Deleted!')));
      setState(() => _currentLensData = null);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGenerateBarcodes() async {
    if (_currentLensData == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please load a lens power first')));
      return;
    }
    
    setState(() => _isLoading = true);
    try {
      final prefix = _selectedProductName?.substring(0, 3).toUpperCase() ?? "LNS";
      final updatedJson = _currentLensData!.toJson();
      final addGroups = updatedJson['addGroups'] as List<dynamic>? ?? [];
      
      for (var group in addGroups) {
        final combinations = group['combinations'] as List<dynamic>? ?? [];
        for (var comb in combinations) {
          if (comb['barcode'] == null || comb['barcode'].toString().trim().isEmpty) {
            String? barcode;
            bool unique = false;
            for(int i=0; i<50; i++){
               barcode = await context.read<LensGroupProvider>().generateUniqueBarcode({'prefix': prefix});
               if(barcode != null){
                  unique = !(await context.read<LensGroupProvider>().checkBarcodeExists(barcode));
                  if(unique) break;
               }
            }
            if(unique) comb['barcode'] = barcode;
          }
        }
      }
      
      await context.read<LensGroupProvider>().editLensPower(updatedJson);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Barcodes generated!')));
      await _fetchLensData();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error generating barcodes: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleSaveMatrix(Map<String, String> edits, bool isStock) async {
    if (_currentLensData == null) return;
    try {
      setState(() => _isLoading = true);
      final updatedJson = _currentLensData!.toJson();
      final addGroups = updatedJson['addGroups'] as List<dynamic>? ?? [];
      
      for (var group in addGroups) {
        final combinations = group['combinations'] as List<dynamic>? ?? [];
        for (var comb in combinations) {
          final key = "${comb['sph']}_${comb['cyl']}_${comb['eye']}";
          if (edits.containsKey(key)) {
             if (isStock) {
               comb['initStock'] = num.tryParse(edits[key]!) ?? 0;
             } else {
               comb['alertQty'] = num.tryParse(edits[key]!) ?? 0;
             }
          }
        }
      }
      await context.read<LensGroupProvider>().editLensPower(updatedJson);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Matrix updated!')));
      await _fetchLensData();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating matrix: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final groups = context.watch<ItemGroupProvider>().groups;
    final items = context.watch<ItemMasterProvider>().items;
    final lensProvider = context.watch<LensGroupProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!widget.hideHeader) ...[
              const Text('Lens Group Master', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              const SizedBox(height: 8),
              const Text('Configure optical power matrices and barcodes', style: TextStyle(color: Color(0xFF64748B))),
              const SizedBox(height: 32),
            ],

            // Selection Section
            _buildCard(child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildDropdown(label: 'Select Group', value: _selectedGroupName, items: groups.map((g) => g.groupName).toList(), onChanged: (v) {
                      setState(() => _selectedGroupName = v);
                      context.read<LensGroupProvider>().getPowerRangeLibrary(v).then((ranges) => setState(() => _libraryRanges = ranges));
                    })),
                    const SizedBox(width: 16),
                    Expanded(child: _buildDropdown(label: 'Select Product', value: _selectedProductName, items: items.where((i) => i.forLensProduct).map((i) => i.itemName).toList(), onChanged: (v) {
                      setState(() => _selectedProductName = v);
                      _fetchLensData();
                    })),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildTextField(controller: _vendorItemNameController, label: 'Vendor Item Name')),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTextField(controller: _billItemNameController, label: 'Bill Item Name')),
                  ],
                ),
              ],
            )),

            const SizedBox(height: 24),

            // Power Range Section
            _buildCard(title: 'Power Range Configuration', child: Column(
              children: [
                _buildPowerRow('SPH', _sphMinController, _sphMaxController, _sphStepController),
                const SizedBox(height: 16),
                _buildPowerRow('CYL', _cylMinController, _cylMaxController, _cylStepController),
                const SizedBox(height: 16),
                _buildPowerRow('ADD', _addMinController, _addMaxController, _addStepController),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildTextField(controller: _axisController, label: 'Axis (0-180)')),
                    const SizedBox(width: 16),
                    Expanded(child: _buildDropdown(label: 'Eye', value: _selectedEye, items: ['RL', 'R', 'L', 'BOTH'], onChanged: (v) => setState(() => _selectedEye = v!))),
                    const SizedBox(width: 16),
                    Expanded(child: Row(
                      children: [
                        Checkbox(value: _addBarcodeWithPower, onChanged: (v) => setState(() => _addBarcodeWithPower = v!)),
                        const Text('Add Barcode with Power', style: TextStyle(fontSize: 13)),
                      ],
                    )),
                  ],
                ),
              ],
            )),

            const SizedBox(height: 32),

            // Main Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildActionButton(label: 'Reset', icon: LucideIcons.rotateCcw, color: Colors.blueGrey, onPressed: () => setState(() => _currentLensData = null)),
                const SizedBox(width: 12),
                _buildActionButton(label: 'Delete', icon: LucideIcons.trash2, color: Colors.red, onPressed: _handleDelete),
                const SizedBox(width: 12),
                _buildActionButton(label: 'Generate Barcodes', icon: LucideIcons.code, color: Colors.purple, onPressed: _handleGenerateBarcodes),
                const SizedBox(width: 12),
                _buildActionButton(label: 'Update', icon: LucideIcons.pencil, color: Colors.blue, onPressed: _handleUpdate),
                const SizedBox(width: 12),
                _buildActionButton(label: 'Create Lens Power', icon: LucideIcons.plus, color: Colors.green, onPressed: _handleCreate),
              ],
            ),

            const SizedBox(height: 32),

            // Matrix Table Placeholder
            if (_currentLensData != null)
              _buildMatrixTable(_currentLensData!)
            else
              const Center(child: Padding(
                padding: EdgeInsets.all(48),
                child: Text('Select or create a lens product to view power matrix.', style: TextStyle(color: Color(0xFF94A3B8), fontStyle: FontStyle.italic)),
              )),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({String? title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            const SizedBox(height: 20),
          ],
          child,
        ],
      ),
    );
  }

  Widget _buildPowerRow(String label, TextEditingController min, TextEditingController max, TextEditingController step) {
    return Row(
      children: [
        SizedBox(width: 60, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF475569)))),
        Expanded(child: _buildTextField(controller: min, label: 'Min')),
        const SizedBox(width: 12),
        const Text('to', style: TextStyle(color: Color(0xFF94A3B8))),
        const SizedBox(width: 12),
        Expanded(child: _buildTextField(controller: max, label: 'Max')),
        const SizedBox(width: 12),
        Expanded(child: _buildTextField(controller: step, label: 'Step')),
      ],
    );
  }

  Widget _buildMatrixTable(LensGroupModel data) {
    // This is a complex table implementation, for now showing a summary card
    return _buildCard(title: 'Lens Power Matrix', child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${data.productName} - ${data.groupName}', style: const TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                _buildActionButton(label: 'Alert Modal', icon: LucideIcons.grid, color: Colors.amber, onPressed: () async {
                  final result = await showDialog<Map<String, String>>(
                    context: context,
                    builder: (_) => MatrixEditDialog(
                      lensData: data,
                      title: 'Manage Alert Qty',
                      isStockMatrix: false,
                    ),
                  );
                  if (result != null) {
                    await _handleSaveMatrix(result, false);
                  }
                }),
                const SizedBox(width: 8),
                _buildActionButton(label: 'Stock Modal', icon: LucideIcons.layers, color: Colors.indigo, onPressed: () async {
                  final result = await showDialog<Map<String, String>>(
                    context: context,
                    builder: (_) => MatrixEditDialog(
                      lensData: data,
                      title: 'Manage Init Stock & Barcodes',
                      isStockMatrix: true,
                    ),
                  );
                  if (result != null) {
                    await _handleSaveMatrix(result, true);
                  }
                }),
              ],
            ),
          ],
        ),
        const Divider(height: 32),
        // Simplified view of power groups
        ...data.powerGroups?.map((pg) => ListTile(
          title: Text(pg.label ?? 'Power Range'),
          subtitle: Text('SPH: ${pg.sphMin} to ${pg.sphMax} | CYL: ${pg.cylMin} to ${pg.cylMax} | ADD: ${pg.addMin} to ${pg.addMax}'),
          trailing: const Icon(LucideIcons.chevronRight, size: 16),
        )).toList() ?? [],
      ],
    ));
  }

  Widget _buildTextField({required TextEditingController controller, required String label}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12)),
    );
  }

  Widget _buildDropdown({required String label, required String? value, required List<String> items, required ValueChanged<String?> onChanged}) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, style: const TextStyle(fontSize: 13)))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
    );
  }

  Widget _buildActionButton({required String label, required IconData icon, required Color color, required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
    );
  }
}
