import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../data/models/lens_group_model.dart';
import '../../data/models/item_master_model.dart';
import '../../data/models/power_range_library_model.dart';
import '../../data/providers/inventory_providers.dart';
import '../widgets/matrix_edit_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'dart:async';

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
  final TextEditingController _vendorItemNameController = TextEditingController();
  final TextEditingController _billItemNameController = TextEditingController();
  final TextEditingController _groupController = TextEditingController();
  final TextEditingController _productController = TextEditingController();
  
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

  /// Maps any API eye-value variant → a valid dropdown item
  String _normalizeEye(String value) {
    final v = value.trim().toUpperCase().replaceAll('/', '').replaceAll(' ', '');
    if (v == 'BOTH' || v == 'RL') return 'RL';
    if (v == 'R') return 'R';
    if (v == 'L') return 'L';
    return 'RL'; // safe default
  }

  bool _addBarcodeWithPower = false;
  LensGroupModel? _currentLensData;
  bool _isLoading = false;

  // Registry
  final TextEditingController _registrySearchController = TextEditingController();

  // Power Range Library States
  List<PowerRangeLibraryModel> _libraryRanges = [];
  List<PowerRangeLibraryModel> _selectedLibraryRanges = [];
  bool _showLibrary = false;
  bool _loadingLibrary = false;

  // Suggestion states
  List<String> _groupSuggestions = [];
  List<String> _productSuggestions = [];
  bool _showGroupSuggestions = false;
  bool _showProductSuggestions = false;
  final LayerLink _groupLayerLink = LayerLink();
  final LayerLink _productLayerLink = LayerLink();
  OverlayEntry? _groupOverlayEntry;
  OverlayEntry? _productOverlayEntry;
  
  final FocusNode _groupFocusNode = FocusNode();
  final FocusNode _productFocusNode = FocusNode();

  // Prevents overlay from closing before onTap fires (focus-loss race fix)
  bool _isSelectingFromDropdown = false;

  // Matrix State
  List<LensAddGroup> _generatedAddGroups = [];
  String _matrixMode = 'view'; // 'view' or 'stock'
  bool _showDetails = false;
  
  // Inline Edit State
  String? _editingAddGroup;
  final Map<String, Map<String, String>> _inlineEdits = {};
  
  // Dedicated controller for horizontal scrolling of the lens matrix
  final ScrollController _matrixHorizontalController = ScrollController();

  // Registry for Matrix FocusNodes to allow coordinate-based navigation (React style)
  final Map<String, FocusNode> _matrixFocusNodes = {};

  FocusNode _getFocusNode(int row, int col, String field) {
    final key = "mat_${row}_${col}_$field";
    if (!_matrixFocusNodes.containsKey(key)) {
      _matrixFocusNodes[key] = FocusNode();
    }
    return _matrixFocusNodes[key]!;
  }
  
  @override
  void initState() {
    super.initState();
    _groupFocusNode.addListener(() {
      if (_groupFocusNode.hasFocus) {
        _showAllGroupSuggestions();
      } else {
        // Delay hiding so onTap on the overlay item can fire first (desktop race fix)
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted && !_isSelectingFromDropdown) _hideOverlays();
        });
      }
    });
    _productFocusNode.addListener(() {
      if (_productFocusNode.hasFocus) {
        _showAllProductSuggestions();
      } else {
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted && !_isSelectingFromDropdown) _hideOverlays();
        });
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<ItemGroupProvider>().fetchGroups();
      context.read<ItemMasterProvider>().fetchItems();
      context.read<LensGroupProvider>().fetchAllLensPower();
      
      if (widget.id != null) {
        setState(() => _isLoading = true);
        final provider = context.read<LensGroupProvider>();
        final all = await provider.getAllLensPower();
        final lens = all.firstWhere((element) => (element['_id'] ?? element['id']) == widget.id, orElse: () => {});
        if (lens.isNotEmpty) {
           setState(() {
             _selectedProductName = lens['productName'];
             _productController.text = lens['productName'] ?? '';
             _groupController.text = lens['groupName'] ?? '';
           });
           await _syncLensConfiguration();
        }
        setState(() => _isLoading = false);
      }
    });
  }

  @override
  void dispose() {
    _hideOverlays();
    _vendorItemNameController.dispose();
    _billItemNameController.dispose();
    _sphMinController.dispose();
    _sphMaxController.dispose();
    _sphStepController.dispose();
    _cylMinController.dispose();
    _cylMaxController.dispose();
    _cylStepController.dispose();
    _addMinController.dispose();
    _addMaxController.dispose();
    _addStepController.dispose();
    _axisController.dispose();
    _groupController.dispose();
    _productController.dispose();
    _groupFocusNode.dispose();
    _productFocusNode.dispose();
    _registrySearchController.dispose();
    for (var node in _matrixFocusNodes.values) {
      node.dispose();
    }
    _matrixFocusNodes.clear();
    _matrixHorizontalController.dispose();
    super.dispose();
  }

  void _hideOverlays() {
    _groupOverlayEntry?.remove();
    _groupOverlayEntry = null;
    _productOverlayEntry?.remove();
    _productOverlayEntry = null;
    setState(() {
       _showGroupSuggestions = false;
       _showProductSuggestions = false;
    });
  }

  Future<void> _syncLensConfiguration() async {
    final prod = _productController.text.trim();
    if (prod.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final result = await context.read<LensGroupProvider>().getLensPower(productName: prod);
      if (!mounted) return;
      if (result != null) {
          setState(() {
            _currentLensData = result;
            _selectedGroupName = result.groupName;
            _selectedProductName = result.productName;
            _groupController.text = result.groupName;
            _productController.text = result.productName;
            _vendorItemNameController.text = result.vendorItemName;
            _billItemNameController.text = result.billItemName;
            
            _sphMinController.text = result.sphMin?.toString() ?? '0.00';
            _sphMaxController.text = result.sphMax?.toString() ?? '0.00';
            _sphStepController.text = result.sphStep;
            _cylMinController.text = result.cylMin?.toString() ?? '0.00';
            _cylMaxController.text = result.cylMax?.toString() ?? '0.00';
            _cylStepController.text = result.cylStep;
            _addMinController.text = result.addMin?.toString() ?? '0.00';
            _addMaxController.text = result.addMax?.toString() ?? '0.00';
            _addStepController.text = result.addStep;
            _axisController.text = result.axis?.toString() ?? '0';
            _selectedEye = _normalizeEye(result.eye.isEmpty ? 'RL' : result.eye);
            
            _showDetails = false;
            _generatedAddGroups = [];
          });
          // Fetch the library for this group name
          if (result.groupName.isNotEmpty) {
            _fetchLibrary(result.groupName);
          }
        }
    } catch (e) {
      debugPrint('Sync Error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleViewPower() async {
    final prod = _productController.text.trim();
    if (prod.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter product name to search'), backgroundColor: Colors.red),
      );
      return;
    }

    if (_showDetails) {
      setState(() => _showDetails = false);
      return;
    }

    try {
      setState(() => _isLoading = true);
      final result = await context.read<LensGroupProvider>().getLensPower(productName: prod);
      
      if (!mounted) return;
      if (result != null) {
          setState(() {
            _currentLensData = result;
            _generateLocalMatrix();
            _showDetails = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lens group loaded successully.')));
        } else {
          setState(() => _currentLensData = null);
          _generateLocalMatrix();
          setState(() => _showDetails = true);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Generating fresh matrix range...')));
        }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _generateLocalMatrix() {
    try {
      double sphMin = double.tryParse(_sphMinController.text) ?? 0;
      double sphMax = double.tryParse(_sphMaxController.text) ?? 0;
      double sphStep = double.tryParse(_sphStepController.text) ?? 0.25;
      if (sphStep <= 0) sphStep = 0.25;

      double cylMin = double.tryParse(_cylMinController.text) ?? 0;
      double cylMax = double.tryParse(_cylMaxController.text) ?? 0;
      double cylStep = double.tryParse(_cylStepController.text) ?? 0.25;
      if (cylStep <= 0) cylStep = 0.25;

      double addMin = double.tryParse(_addMinController.text) ?? 0;
      double addMax = double.tryParse(_addMaxController.text) ?? 0;
      double addStep = double.tryParse(_addStepController.text) ?? 0.25;
      if (addStep <= 0) addStep = 0.25;

      List<LensAddGroup> resultAddGroups = [];

      for (double add = addMin; add <= addMax; add = double.parse((add + addStep).toStringAsFixed(2))) {
        final addStr = add.toStringAsFixed(2);
        List<LensCombination> combinations = [];
        
        for (double sph = sphMin; sph <= sphMax; sph = double.parse((sph + sphStep).toStringAsFixed(2))) {
          final sphStr = sph.toStringAsFixed(2);
          for (double cyl = cylMin; cyl <= cylMax; cyl = double.parse((cyl + cylStep).toStringAsFixed(2))) {
            final cylStr = cyl.toStringAsFixed(2);
            
            // Robust data lookup (smart merging for eyes R/L/RL)
            LensCombination? findAndMerge() {
              if (_currentLensData == null) return null;
              
              List<LensCombination> matches = [];
              
              for (var g in _currentLensData!.addGroups) {
                // Fuzzy match ADD value (numeric comparison instead of string)
                final groupAddValueNum = double.tryParse(g.addValue ?? '') ?? 
                                         double.tryParse(RegExp(r"(\d+\.?\d*)").firstMatch(g.label ?? g.name ?? '')?.group(1) ?? '');
                
                if (groupAddValueNum != null && (groupAddValueNum - add).abs() < 0.01) {
                  for (var c in g.combinations) {
                    final cSphNum = double.tryParse(c.sph) ?? 0.0;
                    final cCylNum = double.tryParse(c.cyl) ?? 0.0;
                    
                    if ((cSphNum - sph).abs() < 0.01 && (cCylNum - cyl).abs() < 0.01) {
                      final cEye = c.eye.toUpperCase();
                      final targetEye = _selectedEye.toUpperCase();
                      
                      bool eyeMatch = (cEye == targetEye);
                      if (!eyeMatch) {
                        // Merging logic: If viewing RL, match R or L or RL
                        if (targetEye == 'RL' && (cEye == 'R' || cEye == 'L' || cEye == 'RL')) eyeMatch = true;
                        // If viewing R or L, match if database entry is RL
                        if ((targetEye == 'R' || targetEye == 'L') && cEye == 'RL') eyeMatch = true;
                      }
                      
                      if (eyeMatch) matches.add(c);
                    }
                  }
                }
              }

              if (matches.isEmpty) return null;
              if (matches.length == 1) return matches.first;

              // Merging multiple matches (e.g., R and L records into one RL view)
              // Prioritize the one with a barcode or non-zero price
              var primary = matches.firstWhere((m) => m.barcode.isNotEmpty, orElse: () => 
                             matches.firstWhere((m) => m.pPrice > 0, orElse: () => matches.first));
              
              if (_selectedEye == 'RL') {
                var eyesFound = matches.map((m) => m.eye).toSet();
                String mergedEye = eyesFound.contains('R') && eyesFound.contains('L') ? 'R/L' : primary.eye;
                return primary.copyWith(eye: mergedEye);
              }
              return primary;
            }

            final existing = findAndMerge();

            combinations.add(existing ?? LensCombination(
              sph: sphStr,
              cyl: cylStr,
              add: addStr,
              eye: _selectedEye,
              axis: _axisController.text,
            ));
          }
        }
        resultAddGroups.add(LensAddGroup(
          name: 'ADD $addStr',
          label: 'ADD $addStr',
          addValue: addStr,
          combinations: combinations,
        ));
      }

      setState(() {
        _generatedAddGroups = resultAddGroups;
        if (_currentLensData != null) {
          _currentLensData = _currentLensData!.copyWith(addGroups: resultAddGroups);
        }
      });
    } catch (e) {
      debugPrint('Error generating matrix: $e');
    }
  }

  Future<String?> _generateBarcodeForCombination(String? prefix) async {
    try {
      final res = await context.read<LensGroupProvider>().generateUniqueBarcode({
        'prefix': prefix ?? (_selectedProductName?.substring(0, 3).toUpperCase() ?? 'LNS'),
        'excludeLensId': _currentLensData?.id,
      });
      return res;
    } catch (e) {
      debugPrint('Error generating barcode: $e');
      return null;
    }
  }


  Future<void> _fetchLibrary(String? groupName) async {
    if (groupName == null || groupName.isEmpty) return;
    setState(() => _loadingLibrary = true);
    try {
      final res = await context.read<LensGroupProvider>().getPowerRangeLibrary(groupName);
      setState(() {
        _libraryRanges = res.map((e) => PowerRangeLibraryModel.fromJson(e)).toList();
      });
    } catch (e) {
      debugPrint('Error fetching library: $e');
    } finally {
      setState(() => _loadingLibrary = false);
    }
  }

  PowerRangeLibraryModel? _getMergedPreview() {
    if (_selectedLibraryRanges.isEmpty) return null;
    double sphMin = _selectedLibraryRanges.map((r) => r.sphMin).reduce((a, b) => a < b ? a : b);
    double sphMax = _selectedLibraryRanges.map((r) => r.sphMax).reduce((a, b) => a > b ? a : b);
    double cylMin = _selectedLibraryRanges.map((r) => r.cylMin).reduce((a, b) => a < b ? a : b);
    double cylMax = _selectedLibraryRanges.map((r) => r.cylMax).reduce((a, b) => a > b ? a : b);
    double addMin = _selectedLibraryRanges.map((r) => r.addMin).reduce((a, b) => a < b ? a : b);
    double addMax = _selectedLibraryRanges.map((r) => r.addMax).reduce((a, b) => a > b ? a : b);

    return PowerRangeLibraryModel(
      sphMin: sphMin, sphMax: sphMax, sphStep: _selectedLibraryRanges.first.sphStep,
      cylMin: cylMin, cylMax: cylMax, cylStep: _selectedLibraryRanges.first.cylStep,
      addMin: addMin, addMax: addMax, addStep: _selectedLibraryRanges.first.addStep,
    );
  }

  void _applyLibraryRange() {
    final merged = _getMergedPreview();
    if (merged == null) return;
    setState(() {
      _sphMinController.text = merged.sphMin.toStringAsFixed(2);
      _sphMaxController.text = merged.sphMax.toStringAsFixed(2);
      _sphStepController.text = merged.sphStep.toStringAsFixed(2);
      _cylMinController.text = merged.cylMin.toStringAsFixed(2);
      _cylMaxController.text = merged.cylMax.toStringAsFixed(2);
      _cylStepController.text = merged.cylStep.toStringAsFixed(2);
      _addMinController.text = merged.addMin.toStringAsFixed(2);
      _addMaxController.text = merged.addMax.toStringAsFixed(2);
      _addStepController.text = merged.addStep.toStringAsFixed(2);
      _showLibrary = false;
      _selectedLibraryRanges = [];
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Library values applied!')));
  }

  void _showAllGroupSuggestions() {
    final groups = context.read<ItemGroupProvider>().groups;
    final query = _groupController.text.toLowerCase().trim();
    final all = groups
        .map((g) => (g.groupName ?? '') as String)
        .where((name) => name.isNotEmpty)
        .where((name) => query.isEmpty || name.toLowerCase().contains(query))
        .toList();
    if (all.isEmpty) return;
    setState(() {
      _groupSuggestions = all;
      _showGroupSuggestions = true;
    });
    _showGroupSuggestionsOverlay();
  }

  void _showAllProductSuggestions() {
    final items = context.read<ItemMasterProvider>().items;
    final query = _productController.text.toLowerCase().trim();
    final groupQuery = _groupController.text.toLowerCase().trim();
    var filtered = items.where((i) => i.itemName.isNotEmpty).toList();
    if (groupQuery.isNotEmpty) {
      filtered = filtered.where((i) => i.groupName.toLowerCase() == groupQuery).toList();
    }
    if (query.isNotEmpty) {
      filtered = filtered.where((i) => i.itemName.toLowerCase().contains(query)).toList();
    }
    if (filtered.isEmpty) return;
    setState(() {
      _productSuggestions = filtered.map((i) => i.itemName).toList();
      _showProductSuggestions = true;
    });
    _showProductSuggestionsOverlay();
  }

  void _handleGroupInputChange(String value) {
     final groups = context.read<ItemGroupProvider>().groups;
     final query = value.toLowerCase().trim();
     setState(() {
       _selectedGroupName = value;
       if (query.isEmpty) {
         _groupSuggestions = groups
             .map((g) => (g.groupName ?? '') as String)
             .where((name) => name.isNotEmpty)
             .toList();
         _showGroupSuggestions = _groupSuggestions.isNotEmpty;
         if (_showGroupSuggestions) _showGroupSuggestionsOverlay();
       } else {
         _groupSuggestions = groups
             .map((g) => (g.groupName ?? '') as String)
             .where((name) => name.toLowerCase().contains(query))
             .toList();
         _showGroupSuggestions = _groupSuggestions.isNotEmpty;
         if (_showGroupSuggestions) _showGroupSuggestionsOverlay();
         else {
           _groupOverlayEntry?.remove();
           _groupOverlayEntry = null;
         }
       }
     });
     if (value.isNotEmpty) _fetchLibrary(value);
  }

  void _handleProductInputChange(String value) {
     final items = context.read<ItemMasterProvider>().items;
     final query = value.toLowerCase().trim();
     final groupQuery = _groupController.text.toLowerCase().trim();

     setState(() {
       _selectedProductName = value;
       var filtered = items.where((i) => i.itemName.isNotEmpty).toList();

       if (groupQuery.isNotEmpty) {
         filtered = filtered.where((i) => i.groupName.toLowerCase() == groupQuery).toList();
       }
       if (query.isNotEmpty) {
         filtered = filtered.where((i) => i.itemName.toLowerCase().contains(query)).toList();
       }

       _productSuggestions = filtered.map((i) => i.itemName).toList();
       _showProductSuggestions = _productSuggestions.isNotEmpty;
       if (_showProductSuggestions) {
         _showProductSuggestionsOverlay();
       } else {
         _productOverlayEntry?.remove();
         _productOverlayEntry = null;
       }
     });
  }

  void _showGroupSuggestionsOverlay() {
    _groupOverlayEntry?.remove();
    _groupOverlayEntry = _createOverlayEntry(
      link: _groupLayerLink,
      suggestions: _groupSuggestions,
      onSelect: (val) {
        setState(() {
          _selectedGroupName = val;
          _groupController.text = val ?? '';
          _showGroupSuggestions = false;
        });
        _hideOverlays();
        if (val != null) _fetchLibrary(val);
      },
    );
    Overlay.of(context).insert(_groupOverlayEntry!);
  }

  void _showProductSuggestionsOverlay() {
    _productOverlayEntry?.remove();
    _productOverlayEntry = _createOverlayEntry(
      link: _productLayerLink,
      suggestions: _productSuggestions,
      onSelect: (val) {
        if (val == null) return;
        
        final items = context.read<ItemMasterProvider>().items;
        final selectedItem = items.firstWhere(
          (i) => i.itemName == val,
          orElse: () => items.firstWhere((i) => i.itemName.toLowerCase() == val.toLowerCase(), orElse: () => const ItemMasterModel()),
        );

        setState(() {
          _selectedProductName = val;
          _productController.text = val;
          _showProductSuggestions = false;
          
          if (selectedItem.groupName.isNotEmpty) {
            _selectedGroupName = selectedItem.groupName;
            _groupController.text = selectedItem.groupName;
          }
        });
        
        _hideOverlays();
        // Auto-load power groups if product exists
        if (val.isNotEmpty) {
          _syncLensConfiguration();
        }
      },
    );
    Overlay.of(context).insert(_productOverlayEntry!);
  }

  OverlayEntry _createOverlayEntry({
    required LayerLink link,
    required List<String> suggestions,
    required Function(String?) onSelect,
  }) {
    return OverlayEntry(
      builder: (context) => Positioned(
        width: link.leaderSize?.width ?? 300,
        child: CompositedTransformFollower(
          link: link,
          showWhenUnlinked: false,
          offset: const Offset(0, 50),
          child: Material(
            elevation: 12,
            shadowColor: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 250),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                shrinkWrap: true,
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = suggestions[index];
                  return InkWell(
                    onTapDown: (_) {
                      // Set flag immediately — fires before focus loss event
                      _isSelectingFromDropdown = true;
                    },
                    onTap: () {
                      _isSelectingFromDropdown = false;
                      onSelect(suggestion);
                    },
                    hoverColor: const Color(0xFFF1F5FF),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                          border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9), width: 0.5)),
                        ),
                        child: Text(
                          suggestion,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF334155),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
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
      'visionType': (double.tryParse(_addMinController.text) ?? 0) > 0 ? 'bifocal' : 'single',
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
      'addGroups': _generatedAddGroups.map((e) => e.toJson()).toList(),
    };

    try {
      setState(() => _isLoading = true);
      await context.read<LensGroupProvider>().addLensPower(data);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lens Power Created Successfully!')));
      await _handleViewPower();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }


  Future<void> _handleUpdate() async {
    if (_currentLensData == null) return;
    try {
      setState(() => _isLoading = true);
      
      final updatedJson = _currentLensData!.toJson();
      updatedJson['groupName'] = _selectedGroupName;
      updatedJson['productName'] = _selectedProductName;
      updatedJson['vendorItemName'] = _vendorItemNameController.text.trim();
      updatedJson['billItemName'] = _billItemNameController.text.trim();
      updatedJson['sphMin'] = double.tryParse(_sphMinController.text) ?? 0;
      updatedJson['sphMax'] = double.tryParse(_sphMaxController.text) ?? 0;
      updatedJson['cylMin'] = double.tryParse(_cylMinController.text) ?? 0;
      updatedJson['cylMax'] = double.tryParse(_cylMaxController.text) ?? 0;
      updatedJson['addMin'] = double.tryParse(_addMinController.text) ?? 0;
      updatedJson['addMax'] = double.tryParse(_addMaxController.text) ?? 0;
      updatedJson['sphStep'] = double.tryParse(_sphStepController.text) ?? 0.25;
      updatedJson['cylStep'] = double.tryParse(_cylStepController.text) ?? 0.25;
      updatedJson['addStep'] = double.tryParse(_addStepController.text) ?? 0.25;
      updatedJson['axis'] = int.tryParse(_axisController.text) ?? 0;
      updatedJson['eye'] = _selectedEye;
      updatedJson['addGroups'] = _generatedAddGroups.map((e) => e.toJson()).toList();
      updatedJson['id'] = _currentLensData!.id;

      await context.read<LensGroupProvider>().editLensPower(updatedJson);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lens Power Updated Successfully!')));
      await _handleViewPower();
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

  @override
  Widget build(BuildContext context) {
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
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!widget.hideHeader) ...[
                const Text(
                  'Lens Group Master',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Configure optical power matrices and inventory requirements',
                  style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 32),
              ],

              _buildFormSection(),

              const SizedBox(height: 24),

              _buildPowerSection(),

              const SizedBox(height: 24),

              _buildActionRow(),

              const SizedBox(height: 32),

              if (_showDetails && _generatedAddGroups.isNotEmpty) ...[
                _buildMatrixActionBar(),
                const SizedBox(height: 24),
                _buildMatrixTable(),
              ] else ...[
                const SizedBox(height: 48),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(64),
                    child: Column(
                      children: [
                        Icon(LucideIcons.mousePointer2, size: 48, color: const Color(0xFF64748B).withOpacity(0.1)),
                        const SizedBox(height: 16),
                        const Text(
                          'Select or create a lens product to view power matrix.',
                          style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 48),

              _buildRegistrySection(),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Registry: auto-fill when product name is clicked ───────────────────────

  void _loadFromRegistry(Map<String, dynamic> lens) {
    final productName = (lens['productName'] ?? '').toString();
    final groupName   = (lens['groupName']   ?? '').toString();

    setState(() {
      _selectedProductName = productName;
      _selectedGroupName   = groupName;
      _productController.text = productName;
      _groupController.text   = groupName;
      _vendorItemNameController.text = (lens['vendorItemName'] ?? '').toString();
      _billItemNameController.text   = (lens['billItemName']   ?? '').toString();

      _sphMinController.text  = (lens['sphMin']  ?? '0.00').toString();
      _sphMaxController.text  = (lens['sphMax']  ?? '0.00').toString();
      _sphStepController.text = (lens['sphStep'] ?? '0.25').toString();
      _cylMinController.text  = (lens['cylMin']  ?? '0.00').toString();
      _cylMaxController.text  = (lens['cylMax']  ?? '0.00').toString();
      _cylStepController.text = (lens['cylStep'] ?? '0.25').toString();
      _addMinController.text  = (lens['addMin']  ?? '0.00').toString();
      _addMaxController.text  = (lens['addMax']  ?? '0.00').toString();
      _addStepController.text = (lens['addStep'] ?? '0.25').toString();
      _axisController.text    = (lens['axis']    ?? '0').toString();
      _selectedEye = _normalizeEye((lens['eye'] ?? 'RL').toString());
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Auto-filled from: $productName'),
        backgroundColor: const Color(0xFF2563EB),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );

    // Fetch full data (matrix) from API after pre-filling
    _syncLensConfiguration();
  }

  Widget _buildRegistrySection() {
    final lensProvider = context.watch<LensGroupProvider>();
    final allLenses = lensProvider.lenses;
    final q = _registrySearchController.text.toLowerCase();
    final filtered = allLenses.where((l) {
      final product = (l['productName'] ?? '').toString().toLowerCase();
      final group   = (l['groupName']   ?? '').toString().toLowerCase();
      return product.contains(q) || group.contains(q);
    }).toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 4))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.list, color: Color(0xFF2563EB), size: 20),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('SAVED LENS PRODUCTS', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF1E293B), letterSpacing: 0.5)),
                    Text('${filtered.length} record(s) — click Product Name to auto-fill'.toUpperCase(), style: const TextStyle(color: Color(0xFF64748B), fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    SizedBox(
                      width: 280,
                      child: TextField(
                        controller: _registrySearchController,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: 'Search products or groups…',
                          hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: const Icon(LucideIcons.search, size: 16, color: Color(0xFF94A3B8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Tooltip(
                      message: 'Refresh list',
                      child: IconButton(
                        onPressed: () => context.read<LensGroupProvider>().fetchAllLensPower(),
                        icon: const Icon(LucideIcons.refreshCw, size: 18, color: Color(0xFF2563EB)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Loading state
          if (lensProvider.isLoading)
            const Padding(
              padding: EdgeInsets.all(48),
              child: CircularProgressIndicator(),
            )
          // Empty state
          else if (filtered.isEmpty)
            Padding(
              padding: const EdgeInsets.all(48),
              child: Column(
                children: [
                  Icon(LucideIcons.packageX, size: 40, color: const Color(0xFF94A3B8).withOpacity(0.5)),
                  const SizedBox(height: 12),
                  const Text('No lens products found', style: TextStyle(color: Color(0xFF94A3B8), fontStyle: FontStyle.italic)),
                ],
              ),
            )
          else
            // Table
            LayoutBuilder(builder: (context, constraints) {
              final w = constraints.maxWidth;
              return Table(
                columnWidths: {
                  0: FixedColumnWidth(w * 0.05),  // Sr
                  1: FixedColumnWidth(w * 0.18),  // Product Name (clickable)
                  2: FixedColumnWidth(w * 0.15),  // Group
                  3: FixedColumnWidth(w * 0.12),  // Vendor Item
                  4: FixedColumnWidth(w * 0.10),  // Bill Item
                  5: FixedColumnWidth(w * 0.07),  // SPH
                  6: FixedColumnWidth(w * 0.07),  // CYL
                  7: FixedColumnWidth(w * 0.07),  // ADD
                  8: FixedColumnWidth(w * 0.07),  // Axis
                  9: FixedColumnWidth(w * 0.07),  // Eye
                },
                border: TableBorder(
                  horizontalInside: const BorderSide(color: Color(0xFFF1F5F9)),
                  bottom: const BorderSide(color: Color(0xFFF1F5F9)),
                ),
                children: [
                  // Header row
                  TableRow(
                    decoration: const BoxDecoration(color: Color(0xFFF8FAFC)),
                    children: [
                      _regHeader('SR'),
                      _regHeader('PRODUCT NAME ↗'),
                      _regHeader('GROUP'),
                      _regHeader('VENDOR NAME'),
                      _regHeader('BILL NAME'),
                      _regHeader('SPH'),
                      _regHeader('CYL'),
                      _regHeader('ADD'),
                      _regHeader('AXIS'),
                      _regHeader('EYE'),
                    ],
                  ),
                  // Data rows
                  ...filtered.asMap().entries.map((entry) {
                    final idx  = entry.key;
                    final lens = entry.value;
                    final productName = (lens['productName'] ?? '-').toString();
                    final groupName   = (lens['groupName']   ?? '-').toString();
                    final vendor      = (lens['vendorItemName'] ?? '-').toString();
                    final bill        = (lens['billItemName']   ?? '-').toString();
                    final sphMin = (lens['sphMin'] ?? '-').toString();
                    final sphMax = (lens['sphMax'] ?? '-').toString();
                    final cylMin = (lens['cylMin'] ?? '-').toString();
                    final cylMax = (lens['cylMax'] ?? '-').toString();
                    final addMin = (lens['addMin'] ?? '-').toString();
                    final addMax = (lens['addMax'] ?? '-').toString();
                    final axis   = (lens['axis']   ?? '-').toString();
                    final eye    = (lens['eye']    ?? '-').toString();
                    final isActive = _selectedProductName == productName;

                    return TableRow(
                      decoration: BoxDecoration(
                        color: isActive ? const Color(0xFFEFF6FF) : (idx.isEven ? Colors.white : const Color(0xFFFAFAFF)),
                      ),
                      children: [
                        _regCell(Text('${idx + 1}', style: const TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.w700, fontSize: 12))),
                        // Clickable product name
                        TableCell(
                          child: InkWell(
                            onTap: () => _loadFromRegistry(lens),
                            borderRadius: BorderRadius.circular(6),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      productName,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w900,
                                        color: isActive ? const Color(0xFF1D4ED8) : const Color(0xFF2563EB),
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                  const Icon(LucideIcons.arrowUpRight, size: 12, color: Color(0xFF93C5FD)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        _regCell(Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(20)),
                          child: Text(groupName, style: const TextStyle(color: Color(0xFF4F46E5), fontSize: 11, fontWeight: FontWeight.w800)),
                        )),
                        _regCell(Text(vendor, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w600))),
                        _regCell(Text(bill, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w600))),
                        _regCell(Text('$sphMin~$sphMax', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF334155)))),
                        _regCell(Text('$cylMin~$cylMax', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF334155)))),
                        _regCell(Text('$addMin~$addMax', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF334155)))),
                        _regCell(Text(axis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF334155)))),
                        _regCell(Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: const Color(0xFFF0FDF4), borderRadius: BorderRadius.circular(20)),
                          child: Text(eye, style: const TextStyle(color: Color(0xFF16A34A), fontSize: 11, fontWeight: FontWeight.w800)),
                        )),
                      ],
                    );
                  }),
                ],
              );
            }),
        ],
      ),
    );
  }

  Widget _regHeader(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Text(
        label,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 0.8),
      ),
    );
  }

  Widget _regCell(Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: child,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────

  Widget _buildFormSection() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: CompositedTransformTarget(
                  link: _groupLayerLink,
                  child: _buildTextField(
                    label: 'GROUP NAME',
                    hint: 'e.g. High Index',
                    controller: _groupController,
                    focusNode: _groupFocusNode,
                    onChanged: _handleGroupInputChange,
                    onTap: _showAllGroupSuggestions,
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: CompositedTransformTarget(
                  link: _productLayerLink,
                  child: _buildTextField(
                    label: 'PRODUCT NAME',
                    hint: 'e.g. 1.67 Blue Cut',
                    controller: _productController,
                    focusNode: _productFocusNode,
                    onChanged: _handleProductInputChange,
                    onTap: _showAllProductSuggestions,
                    suffixIcon: _isLoading 
                      ? const SizedBox(width: 20, height: 20, child: Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator(strokeWidth: 2))) 
                      : null,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildTextField(controller: _vendorItemNameController, label: 'VENDOR ITEM NAME', hint: "Internal name")),
              const SizedBox(width: 24),
              Expanded(child: _buildTextField(controller: _billItemNameController, label: 'BILL ITEM NAME', hint: "Name on invoice")),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPowerSection() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Power Range", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
          const SizedBox(height: 24),
          LayoutBuilder(builder: (context, constraints) {
            final double fieldWidth = (constraints.maxWidth - 64) / 5;
            return Column(
              children: [
                Row(
                  children: [
                    _buildMatrixField('SPH Min', _sphMinController, fieldWidth),
                    const SizedBox(width: 16),
                    _buildMatrixField('SPH Max', _sphMaxController, fieldWidth),
                    const SizedBox(width: 16),
                    _buildMatrixField('SPH Step', _sphStepController, fieldWidth),
                    const SizedBox(width: 16),
                    _buildMatrixField('CYL Min', _cylMinController, fieldWidth),
                    const SizedBox(width: 16),
                    _buildMatrixField('CYL Max', _cylMaxController, fieldWidth),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildMatrixField('CYL Step', _cylStepController, fieldWidth),
                    const SizedBox(width: 16),
                    _buildMatrixField('Add Min', _addMinController, fieldWidth),
                    const SizedBox(width: 16),
                    _buildMatrixField('Add Max', _addMaxController, fieldWidth),
                    const SizedBox(width: 16),
                    _buildMatrixField('Add Step', _addStepController, fieldWidth),
                    const SizedBox(width: 16),
                    _buildMatrixField('Axis', _axisController, fieldWidth),
                  ],
                ),
              ],
            );
          }),
          const SizedBox(height: 24),
          Row(
            children: [
              SizedBox(width: 150, child: _buildDropdown(label: 'EYE (RL)', value: _selectedEye, items: ['RL', 'R', 'L', 'BOTH'], onChanged: (v) => setState(() => _selectedEye = v!))),
              const SizedBox(width: 16),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ElevatedButton.icon(
                  onPressed: _handleViewPower,
                  icon: Icon(_showDetails ? LucideIcons.eyeOff : LucideIcons.eye, size: 16),
                  label: Text(_showDetails ? 'Hide' : 'Show'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Divider(color: Color(0xFFF1F5F9)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(LucideIcons.bookOpen, color: Color(0xFF2563EB), size: 20),
                  SizedBox(width: 12),
                  Text("Power Range Library", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                ],
              ),
              TextButton(
                onPressed: () => setState(() => _showLibrary = !_showLibrary),
                child: Text(_showLibrary ? "Close Library" : "Open Library", style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          if (_showLibrary) ...[
            const SizedBox(height: 16),
            const Text("POWER GROUP FILTER (PRODUCT SPECIFIC)", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF64748B))),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Builder(
                    builder: (context) {
                      // Priority 1: Product specific ranges
                      final List<dynamic> productSpecific = _currentLensData?.powerGroups ?? [];
                      // Priority 2: General library ranges for the group
                      final List<dynamic> generalLibrary = _libraryRanges;
                      
                      final List<dynamic> combinedList = [...productSpecific, ...generalLibrary];
                      
                      return _buildDropdown(
                        label: 'Power Group List',
                        value: null,
                        items: combinedList.map((r) => (r.label ?? 'Unnamed Range').toString()).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            final selected = combinedList.firstWhere((r) => r.label == val);
                            setState(() {
                              // If it's a model-like object (productSpecific uses LensPowerGroup, generalLibrary uses PowerRangeLibraryModel)
                              // we handle both or just access properties directly if they share names
                              _sphMinController.text = (selected is LensPowerGroup ? selected.sphMin : selected.sphMin.toString()) ?? '0.00';
                              _sphMaxController.text = (selected is LensPowerGroup ? selected.sphMax : selected.sphMax.toString()) ?? '0.00';
                              _sphStepController.text = (selected is LensPowerGroup ? selected.sphStep : selected.sphStep.toString()) ?? '0.25';
                              _cylMinController.text = (selected is LensPowerGroup ? selected.cylMin : selected.cylMin.toString()) ?? '0.00';
                              _cylMaxController.text = (selected is LensPowerGroup ? selected.cylMax : selected.cylMax.toString()) ?? '0.00';
                              _cylStepController.text = (selected is LensPowerGroup ? selected.cylStep : selected.cylStep.toString()) ?? '0.25';
                              _addMinController.text = (selected is LensPowerGroup ? selected.addMin : selected.addMin.toString()) ?? '0.00';
                              _addMaxController.text = (selected is LensPowerGroup ? selected.addMax : selected.addMax.toString()) ?? '0.00';
                              _addStepController.text = (selected is LensPowerGroup ? selected.addStep : selected.addStep.toString()) ?? '0.25';
                              
                              if (selected is LensPowerGroup && selected.eye != null && selected.eye!.isNotEmpty) {
                                _selectedEye = selected.eye!;
                              }
                            });
                          }
                        },
                      );
                    }
                  ),
                ),
                const SizedBox(width: 16),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    onPressed: _applyLibraryRange,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF1F5F9),
                      foregroundColor: const Color(0xFF2563EB),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: const BorderSide(color: Color(0xFFE2E8F0))),
                    ),
                    child: const Text('Apply Selection', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            if (_selectedLibraryRanges.isNotEmpty) ...[
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: _selectedLibraryRanges.map((r) => Chip(
                  label: Text(r.label, style: const TextStyle(fontSize: 12)),
                  onDeleted: () => setState(() => _selectedLibraryRanges.remove(r)),
                  backgroundColor: const Color(0xFFEFF6FF),
                  deleteIconColor: const Color(0xFF2563EB),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                )).toList(),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildMatrixField(String label, TextEditingController controller, double width) {
    return SizedBox(
      width: width,
      child: _buildTextField(controller: controller, label: label, hint: '0.00'),
    );
  }

  Widget _buildActionRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Checkbox(
            value: _addBarcodeWithPower, 
            onChanged: (v) => setState(() => _addBarcodeWithPower = v!), 
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            activeColor: const Color(0xFF2563EB),
          ),
          const Text('Add Barcode With Lens Power', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
          const Spacer(),
          _buildActionButton(
            label: 'Create Lens Power', 
            icon: LucideIcons.plus, 
            color: const Color(0xFF16A34A), // Tailwind Green 600
            onPressed: _handleCreate,
          ),
          const SizedBox(width: 12),
          _buildActionButton(
            label: 'Update', 
            icon: LucideIcons.pencil, 
            color: const Color(0xFF2563EB), // Tailwind Blue 600
            onPressed: _handleUpdate,
          ),
          const SizedBox(width: 12),
          _buildActionButton(
            label: 'Delete', 
            icon: LucideIcons.trash2, 
            color: const Color(0xFFDC2626), // Tailwind Red 600
            onPressed: _handleDelete,
          ),
          const SizedBox(width: 12),
          _buildActionButton(
            label: 'Reset', 
            icon: LucideIcons.rotateCcw, 
            color: const Color(0xFFF1F5F9), 
            textColor: const Color(0xFF334155), // Tailwind Slate 700
            onPressed: () => setState(() {
              _currentLensData = null;
              _generatedAddGroups = [];
              _inlineEdits.clear();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPowerInputField(String label, TextEditingController min, TextEditingController max, TextEditingController step) {
    return Row(
      children: [
        SizedBox(width: 100, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF64748B), fontSize: 12))),
        Expanded(child: _buildTextField(controller: min, label: 'Min')),
        const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Icon(LucideIcons.arrowRight, size: 14, color: Color(0xFFCBD5E1))),
        Expanded(child: _buildTextField(controller: max, label: 'Max')),
        const SizedBox(width: 24),
        SizedBox(width: 120, child: _buildTextField(controller: step, label: 'Step Increment')),
      ],
    );
  }

  Widget _buildMatrixActionBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Row(
            children: [
              Checkbox(
                value: _addBarcodeWithPower,
                onChanged: (v) => setState(() => _addBarcodeWithPower = v!),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
              const Text('Add Barcode With Lens Power', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
            ],
          ),
          const SizedBox(width: 24),
          _buildActionButton(
            label: 'Generate Barcodes',
            icon: LucideIcons.qrCode,
            color: const Color(0xFF9333EA), // Tailwind Purple 600
            onPressed: _handleGenerateBarcodes,
          ),
          const SizedBox(width: 12),
          _buildActionButton(
            label: 'Matrix View',
            icon: LucideIcons.layoutGrid,
            color: _matrixMode == 'view' ? const Color(0xFF4F46E5) : const Color(0xFFF1F5F9), // Tailwind Indigo 600
            textColor: _matrixMode == 'view' ? Colors.white : const Color(0xFF334155),
            onPressed: () => _handleToggleMatrixMode('view'),
          ),
          const SizedBox(width: 12),
          _buildActionButton(
            label: 'Stock Matrix',
            icon: LucideIcons.layoutGrid, // Matches React's Grid3X3 icon for both
            color: _matrixMode == 'stock' ? const Color(0xFF059669) : const Color(0xFFF1F5F9), // Tailwind Emerald 600
            textColor: _matrixMode == 'stock' ? Colors.white : const Color(0xFF334155),
            onPressed: () => _handleToggleMatrixMode('stock'),
          ),
        ],
      ),
    );
  }

  Widget _buildMatrixTable() {
    final Map<String, List<LensCombination>> rows = {};
    for (var group in _generatedAddGroups) {
      for (var comb in group.combinations) {
        final key = '${comb.sph}_${comb.cyl}';
        if (!rows.containsKey(key)) rows[key] = [];
        rows[key]!.add(comb);
      }
    }

    final sortedRowKeys = rows.keys.toList()..sort((a, b) {
      final aParts = a.split('_').map((e) => double.tryParse(e) ?? 0).toList();
      final bParts = b.split('_').map((e) => double.tryParse(e) ?? 0).toList();
      if (aParts[0] != bParts[0]) return aParts[0].compareTo(bParts[0]);
      return aParts[1].compareTo(bParts[1]);
    });

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMatrixHeader(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sticky Identifier Columns
              _buildStickyColumns(sortedRowKeys),
              // Scrollable Matrix Data
              Expanded(
                child: Scrollbar(
                  controller: _matrixHorizontalController,
                  thumbVisibility: true,
                  thickness: 8,
                  radius: const Radius.circular(4),
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                        PointerDeviceKind.trackpad,
                      },
                    ),
                    child: SingleChildScrollView(
                      controller: _matrixHorizontalController,
                      scrollDirection: Axis.horizontal,
                      child: _buildDataTable(rows, sortedRowKeys),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMatrixHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top row: title + mode badge ──────────────────────────────
          Row(
            children: [
              const Icon(LucideIcons.grid, color: Color(0xFF2563EB), size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "SPH(${_sphMinController.text} to ${_sphMaxController.text}) "
                  "CYL(${_cylMinController.text} to ${_cylMaxController.text}) "
                  "ADD(${_addMinController.text} to ${_addMaxController.text})",
                  style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF1E293B), fontSize: 16),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
                child: Text(
                  _matrixMode.toUpperCase(),
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // ── Sub-header pills: SPH: x to y | CYL: x to y | ADD: x to y ─
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _rangeChip('SPH', _sphMinController.text, _sphMaxController.text, const Color(0xFF2563EB), const Color(0xFFEFF6FF)),
              _separatorDot(),
              _rangeChip('CYL', _cylMinController.text, _cylMaxController.text, const Color(0xFF7C3AED), const Color(0xFFF5F3FF)),
              _separatorDot(),
              _rangeChip('ADD', _addMinController.text, _addMaxController.text, const Color(0xFF059669), const Color(0xFFECFDF5)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _rangeChip(String label, String min, String max, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: textColor),
            ),
            TextSpan(
              text: '$min to $max',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: textColor.withValues(alpha: 0.75)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _separatorDot() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Text('|', style: TextStyle(fontSize: 12, color: Color(0xFFCBD5E1), fontWeight: FontWeight.w900)),
    );
  }

  Widget _buildStickyColumns(List<String> sortedRowKeys) {
    return Column(
      children: [
        // Header
        Container(
          height: 80,
          width: 180,
          decoration: const BoxDecoration(
            color: Color(0xFFF8FAFC),
            border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9)), right: BorderSide(color: Color(0xFFF1F5F9))),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('SPH', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11)),
              Text('CYL', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11)),
              Text('STOCK', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11)),
            ],
          ),
        ),
        // Rows
        ...sortedRowKeys.map((key) {
          final parts = key.split('_');
          final matches = _generatedAddGroups.isNotEmpty 
              ? _generatedAddGroups.first.combinations.where((c) => c.sph == parts[0] && c.cyl == parts[1]).toList()
              : [];
          int rowStock = 0;
          for (var c in matches) {
            rowStock += (c.initStock as num).toInt();
          }

          return Container(
            height: 48,
            width: 180,
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9)), right: BorderSide(color: Color(0xFFF1F5F9)))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(4)),
                  child: Text(parts[0], style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF2563EB), fontSize: 11)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: const Color(0xFFF5F3FF), borderRadius: BorderRadius.circular(4)),
                  child: Text(parts[1], style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF7C3AED), fontSize: 11)),
                ),
                Text(rowStock.toString(), style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF10B981), fontSize: 11)),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDataTable(Map<String, List<LensCombination>> rows, List<String> sortedRowKeys) {
    return DataTable(
      headingRowHeight: 80,
      dataRowMinHeight: 48,
      dataRowMaxHeight: 48,
      columnSpacing: 0,
      horizontalMargin: 0,
      border: TableBorder.all(color: const Color(0xFFF1F5F9)),
      columns: _generatedAddGroups.map((g) {
        final firstCombAdd = g.combinations.isNotEmpty ? g.combinations.first.add : '';
        final columnTitle = (g.label?.isNotEmpty == true) ? g.label! : 
                           ((g.name?.isNotEmpty == true) ? g.name! : 
                           ((g.addValue?.isNotEmpty == true) ? 'ADD ${g.addValue}' : 
                           (firstCombAdd.isNotEmpty ? 'ADD $firstCombAdd' : 'ADD Group')));
        final isEditing = _editingAddGroup != null && _editingAddGroup == columnTitle;
        final double groupWidth = _matrixMode == 'view' ? 460.0 : 190.0;
        
        return DataColumn(
        label: Container(
          width: groupWidth,
          decoration: const BoxDecoration(color: Color(0xFFF8FAFC)),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── ADD group label and Edit row ──
              SizedBox(
                width: groupWidth,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    // Center title text
                    Text(
                      columnTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E293B),
                        fontSize: 12,
                        letterSpacing: 0.5,
                      ),
                    ),
                    // Right aligned action buttons
                    Positioned(
                      right: 16,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isEditing) ...[
                            ElevatedButton(
                              onPressed: () => _handleSaveInlineMatrix(columnTitle),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF16A34A),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                minimumSize: const Size(0, 24),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              ),
                              child: const Text('Save', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800)),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _editingAddGroup = null;
                                  _inlineEdits.clear();
                                });
                              },
                              child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B), fontSize: 10, fontWeight: FontWeight.w800)),
                            ),
                          ] else ...[
                            Tooltip(
                              message: 'Edit Row',
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _editingAddGroup = columnTitle;
                                    _inlineEdits.clear();
                                    for (var comb in g.combinations) {
                                      final key = "${comb.sph}_${comb.cyl}_${comb.eye}";
                                      _inlineEdits[key] = {
                                        'alertQty': comb.alertQty.toString(),
                                        'pPrice': comb.pPrice.toString(),
                                        'sPrice': comb.sPrice.toString(),
                                        'initStock': comb.initStock.toString(),
                                      };
                                    }
                                  });
                                },
                                borderRadius: BorderRadius.circular(4),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: const Color(0xFF3B82F6).withValues(alpha: 0.3)),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Icon(LucideIcons.pencil, size: 12, color: Color(0xFF3B82F6)),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // ── Sub-column headers ─────────────────────────────────────────
              Row(
                children: [
                   _HeaderCell('BARCODE'),
                  if (_matrixMode == 'view') ...[
                     _HeaderCell('EYE'),
                     _HeaderCell('AXIS'),
                     _HeaderCell('ALERT', onCopy: isEditing ? () => _copyFirstRowToAll('alertQty', sortedRowKeys) : null),
                     _HeaderCell('P-PRICE', onCopy: isEditing ? () => _copyFirstRowToAll('pPrice', sortedRowKeys) : null),
                     _HeaderCell('S-PRICE', onCopy: isEditing ? () => _copyFirstRowToAll('sPrice', sortedRowKeys) : null),
                  ],
                   _HeaderCell('STOCK', onCopy: isEditing ? () => _copyFirstRowToAll('initStock', sortedRowKeys) : null),
                ],
              ),
            ],
          ),
        ),
      );
      }).toList(),
      rows: sortedRowKeys.asMap().entries.map((rowEntry) {
        final rowIdx = rowEntry.key;
        final key = rowEntry.value;
        final parts = key.split('_');
        return DataRow(cells: _generatedAddGroups.asMap().entries.map((groupEntry) {
          final colIdx = groupEntry.key;
          final group = groupEntry.value;
          final firstCombAdd = group.combinations.isNotEmpty ? group.combinations.first.add : '';
          final columnTitle = (group.label?.isNotEmpty == true) ? group.label! : 
                             ((group.name?.isNotEmpty == true) ? group.name! : 
                             ((group.addValue?.isNotEmpty == true) ? 'ADD ${group.addValue}' : 
                             (firstCombAdd.isNotEmpty ? 'ADD $firstCombAdd' : 'ADD Group')));
                             
          final isEditing = _editingAddGroup != null && _editingAddGroup == columnTitle;
          
          final matches = group.combinations.where((c) => c.sph == parts[0] && c.cyl == parts[1]).toList();
          final comb = matches.isNotEmpty 
              ? matches.firstWhere((c) => c.barcode.isNotEmpty || c.pPrice > 0, orElse: () => matches.first)
              : const LensCombination();
              
          // If we have both R and L but it's a merged view, use RL as the displayed eye
          String displayedEye = comb.eye;
          if (matches.length > 1) {
             final eyes = matches.map((m) => m.eye).toSet();
             if (eyes.contains('R') && eyes.contains('L')) {
                displayedEye = 'RL';
             }
          }
              
          final combKey = "${comb.sph}_${comb.cyl}_${comb.eye}";

          return DataCell(
            Row(
              children: [
                _BodyCell(comb.barcode, width: 140),
                if (_matrixMode == 'view') ...[
                  _BodyCell(displayedEye, width: 40),
                  _BodyCell(comb.axis, width: 40),
                  isEditing
                      ? _InputCell(
                          initialValue: _inlineEdits[combKey]?['alertQty'] ?? comb.alertQty.toString(), 
                          width: 50, combKey: combKey, field: 'alertQty', 
                          rowIdx: rowIdx, colIdx: colIdx,
                          focusNode: _getFocusNode(rowIdx, colIdx, 'alertQty'),
                          onNavigate: (r, c, f) => _getFocusNode(r, c, f).requestFocus(),
                          totalCols: _generatedAddGroups.length,
                          totalRows: sortedRowKeys.length,
                          mode: _matrixMode,
                          onChanged: (v) {
                            _inlineEdits[combKey]?['alertQty'] = v;
                            if (displayedEye == 'RL' && matches.length > 1) {
                              for (var m in matches) {
                                final k = "${m.sph}_${m.cyl}_${m.eye}";
                                if (_inlineEdits.containsKey(k)) _inlineEdits[k]!['alertQty'] = v;
                                else _inlineEdits[k] = {'alertQty': v};
                              }
                            }
                          }
                        )
                      : _BodyCell(comb.alertQty.toString(), width: 50, isNumeric: true),
                  isEditing
                      ? _InputCell(
                          initialValue: _inlineEdits[combKey]?['pPrice'] ?? comb.pPrice.toString(), 
                          width: 70, combKey: combKey, field: 'pPrice', 
                          rowIdx: rowIdx, colIdx: colIdx,
                          focusNode: _getFocusNode(rowIdx, colIdx, 'pPrice'),
                          onNavigate: (r, c, f) => _getFocusNode(r, c, f).requestFocus(),
                          totalCols: _generatedAddGroups.length,
                          totalRows: sortedRowKeys.length,
                          mode: _matrixMode,
                          onChanged: (v) {
                            _inlineEdits[combKey]?['pPrice'] = v;
                            if (displayedEye == 'RL' && matches.length > 1) {
                              for (var m in matches) {
                                final k = "${m.sph}_${m.cyl}_${m.eye}";
                                if (_inlineEdits.containsKey(k)) _inlineEdits[k]!['pPrice'] = v;
                                else _inlineEdits[k] = {'pPrice': v};
                              }
                            }
                          }
                        )
                      : _BodyCell('₹${comb.pPrice}', width: 70, isNumeric: true),
                  isEditing
                      ? _InputCell(
                          initialValue: _inlineEdits[combKey]?['sPrice'] ?? comb.sPrice.toString(), 
                          width: 70, combKey: combKey, field: 'sPrice', 
                          rowIdx: rowIdx, colIdx: colIdx,
                          focusNode: _getFocusNode(rowIdx, colIdx, 'sPrice'),
                          onNavigate: (r, c, f) => _getFocusNode(r, c, f).requestFocus(),
                          totalCols: _generatedAddGroups.length,
                          totalRows: sortedRowKeys.length,
                          mode: _matrixMode,
                          onChanged: (v) {
                            _inlineEdits[combKey]?['sPrice'] = v;
                            if (displayedEye == 'RL' && matches.length > 1) {
                              for (var m in matches) {
                                final k = "${m.sph}_${m.cyl}_${m.eye}";
                                if (_inlineEdits.containsKey(k)) _inlineEdits[k]!['sPrice'] = v;
                                else _inlineEdits[k] = {'sPrice': v};
                              }
                            }
                          }
                        )
                      : _BodyCell('₹${comb.sPrice}', width: 70, isNumeric: true),
                ],
                isEditing
                    ? _InputCell(
                        initialValue: _inlineEdits[combKey]?['initStock'] ?? comb.initStock.toString(), 
                        width: 50, combKey: combKey, field: 'initStock', 
                        rowIdx: rowIdx, colIdx: colIdx,
                        focusNode: _getFocusNode(rowIdx, colIdx, 'initStock'),
                        onNavigate: (r, c, f) => _getFocusNode(r, c, f).requestFocus(),
                        totalCols: _generatedAddGroups.length,
                        totalRows: sortedRowKeys.length,
                        mode: _matrixMode,
                        onChanged: (v) {
                          _inlineEdits[combKey]?['initStock'] = v;
                          if (displayedEye == 'RL' && matches.length > 1) {
                            for (var m in matches) {
                              final k = "${m.sph}_${m.cyl}_${m.eye}";
                              if (_inlineEdits.containsKey(k)) _inlineEdits[k]!['initStock'] = v;
                              else _inlineEdits[k] = {'initStock': v};
                            }
                          }
                        }
                      )
                    : _BodyCell(comb.initStock.toString(), width: 50, isNumeric: true, bold: true),
              ],
            ),
          );
        }).toList());
      }).toList(),
    );
  }

  Future<void> _handleGenerateBarcodes() async {
    if (_generatedAddGroups.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please generate a matrix first')));
      return;
    }

    try {
      setState(() => _isLoading = true);
      final prefix = _selectedProductName?.substring(0, 3).toUpperCase() ?? 'LNS';
      
      final updatedGroups = <LensAddGroup>[];

      for (var group in _generatedAddGroups) {
        final newCombinations = <LensCombination>[];
        for (var comb in group.combinations) {
          if (comb.barcode.isNotEmpty) {
            newCombinations.add(comb);
            continue;
          }

          final barcode = await _generateBarcodeForCombination(prefix);
          newCombinations.add(comb.copyWith(barcode: barcode ?? ''));
        }
        updatedGroups.add(group.copyWith(combinations: newCombinations));
      }

      setState(() {
        _generatedAddGroups = updatedGroups;
        if (_currentLensData != null) {
          _currentLensData = _currentLensData!.copyWith(addGroups: updatedGroups);
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Barcodes generated! Click Update to save permanently.')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error generating barcodes: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleToggleMatrixMode(String mode) async {
    if (mode == 'view' || mode == 'stock') {
      showDialog(
        context: context,
        builder: (context) => MatrixEditDialog(
          addGroups: _generatedAddGroups,
          powerGroups: _currentLensData?.powerGroups ?? [],
          mode: mode == 'view' ? MatrixEditMode.alert : MatrixEditMode.stock,
          initialEye: _selectedEye,
          onSave: (edits) => _handleSaveBulkMatrix(edits, mode == 'stock'),
        ),
      );
    } else {
      setState(() => _matrixMode = mode);
    }
  }

  Future<void> _handleSaveBulkMatrix(Map<String, String> edits, bool isStock) async {
    if (edits.isEmpty) return;
    
    // 1. Update local UI state (works for both Create and Edit modes)
    setState(() {
      for (int i = 0; i < _generatedAddGroups.length; i++) {
        final group = _generatedAddGroups[i];
        final updatedCombinations = group.combinations.map((comb) {
          final idStr = comb.id ?? '';
          final coordKey = '${comb.sph}_${comb.cyl}_${comb.add}_${comb.eye}_${comb.axis.isEmpty ? '0' : comb.axis}';
          
          String? newVal;
          if (idStr.isNotEmpty && edits.containsKey(idStr)) {
            newVal = edits[idStr];
          } else if (edits.containsKey(coordKey)) {
            newVal = edits[coordKey];
          }
          
          if (newVal != null) {
            final parsedVal = int.tryParse(newVal) ?? 0;
            if (isStock) {
              return comb.copyWith(initStock: parsedVal);
            } else {
              return comb.copyWith(alertQty: parsedVal);
            }
          }
          return comb;
        }).toList();
        
        _generatedAddGroups[i] = _generatedAddGroups[i].copyWith(combinations: updatedCombinations);
      }
    });

    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${edits.length} combinations updated in view!')));

    // 2. If editing an existing lens group in the database, also update the backend immediately
    if (_currentLensData == null) return;
    try {
      setState(() => _isLoading = true);
      
      final updatedAddGroups = _currentLensData!.addGroups.map((group) {
        final newCombs = group.combinations.map((comb) {
          final idStr = comb.id ?? '';
          final coordKey = '${comb.sph}_${comb.cyl}_${comb.add}_${comb.eye}_${comb.axis.isEmpty ? '0' : comb.axis}';
          
          String? newVal;
          if (idStr.isNotEmpty && edits.containsKey(idStr)) {
            newVal = edits[idStr];
          } else if (edits.containsKey(coordKey)) {
            newVal = edits[coordKey];
          }
          
          if (newVal != null) {
            final parsedVal = int.tryParse(newVal) ?? 0;
            return isStock ? comb.copyWith(initStock: parsedVal) : comb.copyWith(alertQty: parsedVal);
          }
          return comb;
        }).toList();
        return group.copyWith(combinations: newCombs);
      }).toList();

      final updatedJson = _currentLensData!.copyWith(
        addGroups: updatedAddGroups,
        groupName: _selectedGroupName ?? '',
        productName: _selectedProductName ?? '',
        vendorItemName: _vendorItemNameController.text.trim(),
        billItemName: _billItemNameController.text.trim(),
        eye: _selectedEye,
      ).toJson();
      
      // The API strictly validates that matrix boundary params must be Number type.
      // We override the Freezed String bindings with doubles/ints.
      updatedJson['sphMin'] = double.tryParse(_sphMinController.text) ?? 0;
      updatedJson['sphMax'] = double.tryParse(_sphMaxController.text) ?? 0;
      updatedJson['cylMin'] = double.tryParse(_cylMinController.text) ?? 0;
      updatedJson['cylMax'] = double.tryParse(_cylMaxController.text) ?? 0;
      updatedJson['addMin'] = double.tryParse(_addMinController.text) ?? 0;
      updatedJson['addMax'] = double.tryParse(_addMaxController.text) ?? 0;
      updatedJson['sphStep'] = double.tryParse(_sphStepController.text) ?? 0.25;
      updatedJson['cylStep'] = double.tryParse(_cylStepController.text) ?? 0.25;
      updatedJson['addStep'] = double.tryParse(_addStepController.text) ?? 0.25;
      updatedJson['axis'] = int.tryParse(_axisController.text) ?? 0;
      
      // Freezed generates 'addGroups' as a List of objects, force it into a list of JSON dicts
      updatedJson['addGroups'] = updatedAddGroups.map((group) {
        final groupJson = group.toJson();
        groupJson['combinations'] = group.combinations.map((c) => c.toJson()).toList();
        return groupJson;
      }).toList();
      
      // CRITICAL FIX: The React backend editLensPower route destructures 'id' explicitly from req.body,
      // but Mongoose Freezed Data outputs it as '_id'. We MUST map it to 'id' to prevent a 400 Bad Request.
      updatedJson['id'] = _currentLensData!.id;
      
      await context.read<LensGroupProvider>().editLensPower(updatedJson);
      await _handleViewPower();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error pushing matrix to server: $e'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _copyFirstRowToAll(String field, List<String> sortedRowKeys) {
    if (_editingAddGroup == null || sortedRowKeys.isEmpty) return;
    
    // In our inline edits, the keys are formatted as sph_cyl_eye mapping. We just need to find the correct eye value.
    // The sortedRowKeys gives us sph_cyl. We need to find the corresponding full keys in _inlineEdits.
    final firstPrefix = sortedRowKeys.first;
    
    // Find the first actual matched key in _inlineEdits that starts with this prefix
    String? firstFullKey;
    for (var k in _inlineEdits.keys) {
      if (k.startsWith('${firstPrefix}_')) {
        firstFullKey = k;
        break;
      }
    }
    
    if (firstFullKey == null) return;
    
    final String? valueToCopy = _inlineEdits[firstFullKey]?[field];
    if (valueToCopy == null) return;
    
    setState(() {
      for (var prefix in sortedRowKeys) {
        for (var k in _inlineEdits.keys) {
           if (k.startsWith('${prefix}_')) {
             _inlineEdits[k]![field] = valueToCopy;
           }
        }
      }
    });
  }

  Future<void> _handleSaveInlineMatrix(String groupLabel) async {
    if (_currentLensData == null) return;
    try {
      setState(() => _isLoading = true);
      
      final List<Map<String, dynamic>> finalAddGroups = [];
      
      for (var group in _currentLensData!.addGroups) {
        final gLabel = group.label ?? '';
        final gName = group.name ?? '';
        final firstCombAdd = group.combinations.isNotEmpty ? group.combinations.first.add : '';
        final columnTitle = gLabel.isNotEmpty ? gLabel : 
                           (gName.isNotEmpty ? gName : 
                           ((group.addValue?.isNotEmpty == true) ? 'ADD ${group.addValue}' : 
                           (firstCombAdd.isNotEmpty ? 'ADD $firstCombAdd' : 'ADD Group')));

        final List<Map<String, dynamic>> finalCombinations = [];
        
        for (var comb in group.combinations) {
          final combMap = comb.toJson();
          if (columnTitle == groupLabel) {
            final key = "${comb.sph}_${comb.cyl}_${comb.eye}";
            final edits = _inlineEdits[key];
            if (edits != null) {
              if (edits.containsKey('alertQty')) combMap['alertQty'] = int.tryParse(edits['alertQty']!) ?? comb.alertQty;
              if (edits.containsKey('pPrice')) combMap['pPrice'] = double.tryParse(edits['pPrice']!) ?? comb.pPrice;
              if (edits.containsKey('sPrice')) combMap['sPrice'] = double.tryParse(edits['sPrice']!) ?? comb.sPrice;
              if (edits.containsKey('initStock')) combMap['initStock'] = int.tryParse(edits['initStock']!) ?? comb.initStock;
            }
          }
          finalCombinations.add(combMap);
        }
        
        final groupMap = group.toJson();
        groupMap['combinations'] = finalCombinations;
        finalAddGroups.add(groupMap);
      }
      
      final updatedJson = _currentLensData!.toJson();
      updatedJson['groupName'] = _selectedGroupName;
      updatedJson['productName'] = _selectedProductName;
      updatedJson['vendorItemName'] = _vendorItemNameController.text.trim();
      updatedJson['billItemName'] = _billItemNameController.text.trim();
      updatedJson['sphMin'] = double.tryParse(_sphMinController.text) ?? 0;
      updatedJson['sphMax'] = double.tryParse(_sphMaxController.text) ?? 0;
      updatedJson['cylMin'] = double.tryParse(_cylMinController.text) ?? 0;
      updatedJson['cylMax'] = double.tryParse(_cylMaxController.text) ?? 0;
      updatedJson['addMin'] = double.tryParse(_addMinController.text) ?? 0;
      updatedJson['addMax'] = double.tryParse(_addMaxController.text) ?? 0;
      updatedJson['sphStep'] = double.tryParse(_sphStepController.text) ?? 0.25;
      updatedJson['cylStep'] = double.tryParse(_cylStepController.text) ?? 0.25;
      updatedJson['addStep'] = double.tryParse(_addStepController.text) ?? 0.25;
      updatedJson['axis'] = int.tryParse(_axisController.text) ?? 0;
      updatedJson['eye'] = _selectedEye;
      updatedJson['addGroups'] = finalAddGroups;
      updatedJson['id'] = _currentLensData!.id;
      
      await context.read<LensGroupProvider>().editLensPower(updatedJson);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Matrix updated successfully!')));
      
      setState(() {
        _editingAddGroup = null;
        _inlineEdits.clear();
      });
      await _handleViewPower();
    } catch (e) {
      String errMsg = e.toString();
      if (e is DioException) {
        errMsg = e.response?.data?.toString() ?? e.message ?? errMsg;
      }
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating matrix: $errMsg'), backgroundColor: Colors.red));
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
               comb['initStock'] = int.tryParse(edits[key]!) ?? 0;
             } else {
               comb['alertQty'] = int.tryParse(edits[key]!) ?? 0;
             }
          }
        }
      }

      updatedJson['groupName'] = _selectedGroupName;
      updatedJson['productName'] = _selectedProductName;
      updatedJson['vendorItemName'] = _vendorItemNameController.text.trim();
      updatedJson['billItemName'] = _billItemNameController.text.trim();
      updatedJson['sphMin'] = double.tryParse(_sphMinController.text) ?? 0;
      updatedJson['sphMax'] = double.tryParse(_sphMaxController.text) ?? 0;
      updatedJson['cylMin'] = double.tryParse(_cylMinController.text) ?? 0;
      updatedJson['cylMax'] = double.tryParse(_cylMaxController.text) ?? 0;
      updatedJson['addMin'] = double.tryParse(_addMinController.text) ?? 0;
      updatedJson['addMax'] = double.tryParse(_addMaxController.text) ?? 0;
      updatedJson['sphStep'] = double.tryParse(_sphStepController.text) ?? 0.25;
      updatedJson['cylStep'] = double.tryParse(_cylStepController.text) ?? 0.25;
      updatedJson['addStep'] = double.tryParse(_addStepController.text) ?? 0.25;
      updatedJson['axis'] = int.tryParse(_axisController.text) ?? 0;
      updatedJson['eye'] = _selectedEye;
      updatedJson['id'] = _currentLensData!.id;
      
      await context.read<LensGroupProvider>().editLensPower(updatedJson);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Matrix updated successfully!')));
      await _handleViewPower();
    } catch (e) {
      String errMsg = e.toString();
      if (e is DioException) {
        errMsg = e.response?.data?.toString() ?? e.message ?? errMsg;
      }
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating matrix: $errMsg'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildTextField({
    TextEditingController? controller,
    required String label,
    String? hint,
    Function(String)? onChanged,
    VoidCallback? onTap,
    FocusNode? focusNode,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF64748B), letterSpacing: 0.8)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          onChanged: onChanged,
          onTap: onTap,
          focusNode: focusNode,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.w500),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2)),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({required String label, required String? value, required List<String> items, required ValueChanged<String?> onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF64748B), letterSpacing: 0.8)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1E293B))))).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2)),
          ),
          icon: const Icon(LucideIcons.chevronDown, size: 16, color: Color(0xFF64748B)),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label, 
    required IconData icon, 
    required Color color, 
    Color? textColor,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 14),
      label: Text(
        label,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor ?? Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: color == const Color(0xFFF1F5F9) 
              ? const BorderSide(color: Color(0xFFE2E8F0)) 
              : BorderSide.none,
        ),
        elevation: 0,
      ),
    );
  }
}

class _InputCell extends StatefulWidget {
  final String initialValue;
  final double width;
  final String combKey;
  final String field;
  final int rowIdx;
  final int colIdx;
  final String mode; // 'view' or 'stock'
  final int totalRows;
  final int totalCols;
  final FocusNode focusNode;
  final void Function(int, int, String) onNavigate;
  final ValueChanged<String> onChanged;

  const _InputCell({
    required this.initialValue,
    required this.width,
    required this.combKey,
    required this.field,
    required this.rowIdx,
    required this.colIdx,
    required this.mode,
    required this.totalRows,
    required this.totalCols,
    required this.focusNode,
    required this.onNavigate,
    required this.onChanged,
  });

  @override
  State<_InputCell> createState() => _InputCellState();
}

class _InputCellState extends State<_InputCell> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    
    // Assign navigation logic to the focusNode
    widget.focusNode.onKeyEvent = (node, event) {
      _handleKeyNavigation(event);
      return KeyEventResult.ignored;
    };

    // Select all text when the cell gains focus
    widget.focusNode.addListener(() {
      if (widget.focusNode.hasFocus) {
        _controller.selection = TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
      }
    });
  }

  void _handleKeyNavigation(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    final key = event.logicalKey;
    final bool isView = widget.mode == 'view';
    final List<String> fields = isView ? ['alertQty', 'pPrice', 'sPrice', 'initStock'] : ['initStock'];
    final int fieldIdx = fields.indexOf(widget.field);

    if (key == LogicalKeyboardKey.arrowRight) {
       if (fieldIdx < fields.length - 1) {
         // Move to next field in SAME column
         widget.onNavigate(widget.rowIdx, widget.colIdx, fields[fieldIdx + 1]);
       } else if (widget.colIdx < widget.totalCols - 1) {
         // Move to first field of NEXT column
         widget.onNavigate(widget.rowIdx, widget.colIdx + 1, fields[0]);
       }
    } else if (key == LogicalKeyboardKey.arrowLeft) {
       if (fieldIdx > 0) {
         // Move to prev field in SAME column
         widget.onNavigate(widget.rowIdx, widget.colIdx, fields[fieldIdx - 1]);
       } else if (widget.colIdx > 0) {
         // Move to last field of PREV column
         widget.onNavigate(widget.rowIdx, widget.colIdx - 1, fields.last);
       }
    } else if (key == LogicalKeyboardKey.arrowDown) {
       if (widget.rowIdx < widget.totalRows - 1) {
         widget.onNavigate(widget.rowIdx + 1, widget.colIdx, widget.field);
       }
    } else if (key == LogicalKeyboardKey.arrowUp) {
       if (widget.rowIdx > 0) {
         widget.onNavigate(widget.rowIdx - 1, widget.colIdx, widget.field);
       }
    } else if (key == LogicalKeyboardKey.enter) {
       if (widget.rowIdx < widget.totalRows - 1) {
         widget.onNavigate(widget.rowIdx + 1, widget.colIdx, widget.field);
       } else if (widget.colIdx < widget.totalCols - 1) {
         widget.onNavigate(0, widget.colIdx + 1, fields[0]);
       }
    }
  }

  @override
  void didUpdateWidget(_InputCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue && widget.initialValue != _controller.text) {
      final selection = _controller.selection;
      _controller.text = widget.initialValue;
      if (selection.baseOffset >= 0 && selection.baseOffset <= _controller.text.length) {
        _controller.selection = selection;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: 48,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: TextFormField(
        controller: _controller,
        focusNode: widget.focusNode,
        onChanged: widget.onChanged,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          isDense: true,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xFF2563EB))),
        ),
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String label;
  final VoidCallback? onCopy;
  const _HeaderCell(this.label, {this.onCopy});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: label == 'BARCODE' ? 140 : (label == 'P-PRICE' || label == 'S-PRICE' ? 70 : (label == 'EYE' || label == 'AXIS' ? 40 : 50)),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF64748B))),
          if (onCopy != null) ...[
            const SizedBox(width: 4),
            Tooltip(
              message: 'Copy first row to all',
              child: GestureDetector(
                onTap: onCopy,
                child: const Icon(LucideIcons.copy, size: 10, color: Color(0xFF3B82F6)),
              ),
            ),
          ]
        ],
      ),
    );
  }
}

class _BodyCell extends StatelessWidget {
  final String text;
  final double width;
  final bool isNumeric;
  final bool bold;
  const _BodyCell(this.text, {required this.width, this.isNumeric = false, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 48,
      alignment: Alignment.center,
      decoration: const BoxDecoration(border: Border(right: BorderSide(color: Color(0xFFF1F5F9)))),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: (isNumeric || bold) ? FontWeight.w900 : FontWeight.w600,
          color: (isNumeric || bold) ? const Color(0xFF1E293B) : const Color(0xFF334155),
        ),
      ),
    );
  }
}
