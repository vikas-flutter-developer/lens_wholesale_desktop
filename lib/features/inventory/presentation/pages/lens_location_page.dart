import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../masters/data/providers/inventory_providers.dart';
import '../../../masters/data/models/lens_group_model.dart';
import '../providers/inventory_provider.dart';
import '../widgets/lens_location_matrix_view.dart';
import '../../data/models/lens_location_model.dart';

class LensLocationPage extends StatefulWidget {
  const LensLocationPage({super.key});

  @override
  State<LensLocationPage> createState() => _LensLocationPageState();
}

class _LensLocationPageState extends State<LensLocationPage> {
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _godownController = TextEditingController();
  final TextEditingController _rackController = TextEditingController();
  final TextEditingController _boxController = TextEditingController();

  LensGroupModel? _selectedLens;
  bool _showMatrix = false;

  // Filters
  double? _sphMin, _sphMax, _cylMin, _cylMax;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("Lens Location Management"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.rotateCcw),
            onPressed: _reset,
            tooltip: "Reset All",
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          _buildFilters(),
          _buildLocationSettings(),
          Expanded(
            child: _showMatrix && _selectedLens != null
                ? LensLocationMatrixView(
                    lensGroup: _selectedLens!,
                    activeLocation: LensLocationModel(
                      godown: _godownController.text.isEmpty ? '-' : _godownController.text,
                      rack: _rackController.text.isEmpty ? '-' : _rackController.text,
                      box: _boxController.text.isEmpty ? '-' : _boxController.text,
                    ),
                    onSave: _saveMapping,
                  )
                : const Center(
                    child: Text(
                      "Select an item and click 'Show' to manage locations",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.filter, size: 18, color: Colors.blue),
              const SizedBox(width: 8),
              const Text(
                "STOCK FILTERS",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: _handleShow,
                icon: const Icon(LucideIcons.eye, size: 16),
                label: const Text("Show Matrix"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => _exportExcel(),
                icon: const Icon(LucideIcons.fileSpreadsheet, color: Color(0xFF10B981)),
                tooltip: "Export to Excel",
              ),
              IconButton(
                onPressed: () => _printMatrix(),
                icon: const Icon(LucideIcons.printer, color: Colors.blue),
                tooltip: "Print Matrix",
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildItemSelector(),
              ),
              const SizedBox(width: 12),
              _buildRangeInput("SPH", (min, max) {
                _sphMin = min;
                _sphMax = max;
              }),
              const SizedBox(width: 12),
              _buildRangeInput("CYL", (min, max) {
                _cylMin = min;
                _cylMax = max;
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Item Name", style: TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 4),
        TextField(
          controller: _itemController,
          decoration: InputDecoration(
            hintText: "Search item...",
            prefixIcon: const Icon(LucideIcons.search, size: 16),
            isDense: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onSubmitted: (_) => _handleShow(),
        ),
      ],
    );
  }

  Widget _buildRangeInput(String label, Function(double?, double?) onChanged) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(hintText: "Min", isDense: true),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => onChanged(double.tryParse(v), _sphMax),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text("-"),
              ),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(hintText: "Max", isDense: true),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => onChanged(_sphMin, double.tryParse(v)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSettings() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDCFCE7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(LucideIcons.mapPin, size: 18, color: Color(0xFF10B981)),
              SizedBox(width: 8),
              Text(
                "LOCATION SETTINGS",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF166534)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildLocField("Godown", _godownController),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildLocField("Rack No", _rackController),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildLocField("Box No", _boxController),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _showShiftDialog,
                icon: const Icon(LucideIcons.move, size: 16),
                label: const Text("Quick Shift"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD97706), // Amber-700 hex
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            isDense: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Future<void> _handleShow() async {
    if (_itemController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter an item name")),
      );
      return;
    }

    final provider = context.read<LensGroupProvider>();
    final lens = await provider.getLensPower(productName: _itemController.text);
    
    if (lens == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lens not found")),
      );
      return;
    }

    setState(() {
      _selectedLens = lens;
      _showMatrix = true;
    });
  }

  void _saveMapping(LensGroupModel updatedLens) async {
    try {
      final provider = context.read<LensGroupProvider>();
      await provider.updateLocations(updatedLens.toJson());
      
      setState(() {
        _selectedLens = updatedLens;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Stock locations saved successfully!")),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving locations: $e")),
      );
    }
  }

  void _reset() {
    setState(() {
      _itemController.clear();
      _godownController.clear();
      _rackController.clear();
      _boxController.clear();
      _selectedLens = null;
      _showMatrix = false;
    });
  }

  void _showShiftDialog() {
    final fromController = TextEditingController();
    final toController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Quick Shift Stock"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: fromController, decoration: const InputDecoration(labelText: "From Godown")),
            TextField(controller: toController, decoration: const InputDecoration(labelText: "To Godown")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              _applyShift(fromController.text, toController.text);
              Navigator.pop(context);
            },
            child: const Text("Shift All"),
          ),
        ],
      ),
    );
  }

  void _applyShift(String from, String to) {
    if (_selectedLens == null) return;
    
    final updatedLens = _selectedLens!.copyWith(
      addGroups: _selectedLens!.addGroups.map((ag) {
        return ag.copyWith(
          combinations: ag.combinations.map((comb) {
            final locs = comb.locations.map((loc) {
              if (loc.godown == from) return loc.copyWith(godown: to);
              return loc;
            }).toList();
            return comb.copyWith(locations: locs);
          }).toList(),
        );
      }).toList(),
    );

    _saveMapping(updatedLens);
  }

  void _exportExcel() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Exporting Matrix to Excel...")),
    );
  }

  void _printMatrix() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Generating Printable View...")),
    );
  }
}
