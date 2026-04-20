import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../data/providers/inventory_providers.dart';
import '../../data/models/item_group_model.dart';
import '../../data/models/item_master_model.dart';

class LensRateMasterScreen extends StatefulWidget {
  final String? id;
  final String? powerGroupId;

  const LensRateMasterScreen({super.key, this.id, this.powerGroupId});

  @override
  State<LensRateMasterScreen> createState() => _LensRateMasterScreenState();
}

class _LensRateMasterScreenState extends State<LensRateMasterScreen> {
  bool _collapsed = false;

  final TextEditingController _groupNameCtrl = TextEditingController();
  final TextEditingController _itemNameCtrl = TextEditingController();
  final TextEditingController _axisCtrl = TextEditingController();
  final TextEditingController _purchasePriceCtrl = TextEditingController();
  final TextEditingController _saleDefaultCtrl = TextEditingController();
  
  String _selectedPowerGroupId = "";
  String _selectedEye = "";

  Map<String, dynamic>? _newData;
  List<dynamic> _powerGroups = [];
  bool _showDetails = false;

  List<Map<String, dynamic>>? _filteredRows;
  bool _filtersApplied = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    final itemProvider = Provider.of<ItemMasterProvider>(context, listen: false);
    final groupProvider = Provider.of<ItemGroupProvider>(context, listen: false);
    if (itemProvider.items.isEmpty) await itemProvider.fetchItems();
    if (groupProvider.groups.isEmpty) await groupProvider.fetchGroups();

    if (widget.id != null && widget.id!.isNotEmpty) {
       final lensProvider = Provider.of<LensGroupProvider>(context, listen: false);
       try {
         final data = await lensProvider.getLensPower(id: widget.id);
         if (data != null) {
            // Pre-fetch power groups for this products
            final pgData = await lensProvider.getPowerGroupsForProduct(data.productName ?? '');
            if (mounted) {
              setState(() {
                 _powerGroups = pgData;
              });
              _populateFromData(data.toJson());
            }
         }
       } catch (e) {
         debugPrint('Error loading initial data: $e');
       }
    }
    if (mounted) setState(() => _isLoading = false);
  }

  void _populateFromData(Map<String, dynamic> data, {bool updateControllers = true}) {
      debugPrint('Populating LensRateMaster with: $data');
      _newData = data;
      _showDetails = true;
      
      if (updateControllers) {
        _groupNameCtrl.text = data['groupName']?.toString() ?? '';
        _itemNameCtrl.text = data['productName']?.toString() ?? '';
        _axisCtrl.text = data['axis']?.toString() ?? '';
        _selectedEye = data['eye']?.toString() ?? '';
      }
      
      final dynamic pgs = data['powerGroups'];
      if (pgs is Map) {
         _powerGroups = [Map<String, dynamic>.from(pgs)];
      } else if (pgs is List) {
         _powerGroups = pgs.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      } else {
         _powerGroups = [];
      }
      
      _selectedPowerGroupId = widget.powerGroupId ?? '';
      if (_selectedPowerGroupId.isNotEmpty) {
          final pg = _powerGroups.firstWhere(
            (p) => (p['_id'] ?? p['id']).toString() == _selectedPowerGroupId, 
            orElse: () => <String, dynamic>{}
          );
          if (pg.isNotEmpty) {
              _purchasePriceCtrl.text = (pg['purchasePrice'] ?? 0).toString();
              _saleDefaultCtrl.text = (pg['salePrice'] is Map ? pg['salePrice']['default'] : pg['salePrice'])?.toString() ?? '0';
          }
      } else if (updateControllers) {
         _purchasePriceCtrl.text = (data['purchasePrice'] ?? '').toString();
         final salePrice = data['salePrice'];
         if (salePrice is Map) {
             _saleDefaultCtrl.text = (salePrice['default'] ?? '').toString();
         } else {
             _saleDefaultCtrl.text = salePrice?.toString() ?? '';
         }
      }
      setState((){});
   }

  Future<bool> _ensureDataLoaded() async {
    if (_newData != null) return true;
    
    final groupName = _groupNameCtrl.text.trim();
    final itemName = _itemNameCtrl.text.trim();
    
    if (groupName.isEmpty || itemName.isEmpty) return false;

    final lensProvider = Provider.of<LensGroupProvider>(context, listen: false);
    final data = await lensProvider.getLensPower(
       groupName: groupName,
       productName: itemName,
    );

    if (data != null) {
       _populateFromData(data.toJson(), updateControllers: false);
       return true;
    }
    return false;
  }

  Future<void> _handleShowList() async {
    if (_showDetails) {
       setState(() {
         _showDetails = false;
         _newData = null;
         _powerGroups = [];
       });
       return;
    }
    
    if (_itemNameCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter item name')));
      return;
    }
    if (_groupNameCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter group name')));
      return;
    }

    final lensProvider = Provider.of<LensGroupProvider>(context, listen: false);
    final data = await lensProvider.getLensPower(
       groupName: _groupNameCtrl.text,
       productName: _itemNameCtrl.text,
    );

    if (data == null) {
       if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No lens records found for this combination')));
       setState(() {
         _showDetails = false;
         _filteredRows = null;
         _filtersApplied = false;
       });
    } else {
       _populateFromData(data.toJson());
       if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Loaded items')));
    }
  }

  void _handleFilter() {
     final axis = _axisCtrl.text.trim();
     final eye = _selectedEye;
     
     List<Map<String, dynamic>> filtered = _flattenedRows;
     
     if (axis.isNotEmpty) {
        filtered = filtered.where((row) => row['axis']?.toString() == axis).toList();
     }
     
     if (eye.isNotEmpty) {
        filtered = filtered.where((row) => row['eye']?.toString() == eye).toList();
     }

     setState(() {
        _filteredRows = filtered;
        _filtersApplied = true;
     });
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Applied filters: ${filtered.length} results found')));
  }

  void _clearFilters() {
     setState(() {
        _axisCtrl.clear();
        _selectedEye = "";
        _filteredRows = null;
        _filtersApplied = false;
     });
     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Filters cleared')));
  }

  void _handleSave() async {
     try {
        final bool dataLoaded = await _ensureDataLoaded();
        if (!dataLoaded) {
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a valid Lens Group first')));
           return;
        }

        final String? recordId = _newData?['id']?.toString() ?? _newData?['_id']?.toString();
        final Map<String, dynamic> payload = {
            if (recordId != null && recordId.isNotEmpty) 'id': recordId,
            'powerGroupId': _selectedPowerGroupId.isEmpty ? null : _selectedPowerGroupId,
            'groupName': _groupNameCtrl.text,
            'productName': _itemNameCtrl.text,
            'purchasePrice': double.tryParse(_purchasePriceCtrl.text) ?? 0.0,
            'salePrice': {
                'default': double.tryParse(_saleDefaultCtrl.text) ?? 0.0,
            }
        };

        final provider = Provider.of<LensGroupProvider>(context, listen: false);
        await provider.editLensRate(payload);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lens group price updated successfully')));
        
        Future.delayed(const Duration(seconds: 1), () {
            if (mounted) context.pop();
        });
     } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
     }
  }

  void _handleCancel() {
      setState(() {
          _groupNameCtrl.clear();
          _itemNameCtrl.clear();
          _axisCtrl.clear();
          _purchasePriceCtrl.clear();
          _saleDefaultCtrl.clear();
          _selectedPowerGroupId = "";
          _selectedEye = "";
          _powerGroups = [];
          _showDetails = false;
          _newData = null;
      });
  }

  List<Map<String, dynamic>> get _flattenedRows {
    if (_newData == null) return [];
    final List<Map<String, dynamic>> flattened = [];
    final rawGroups = _newData!['addGroups'];
    if (rawGroups is List) {
       for (var g in rawGroups) {
          if (g is Map && g['combinations'] is List) {
             for (var c in g['combinations']) {
                if (c is Map) {
                   flattened.add({
                      ...c,
                      'addValue': g['addValue'],
                   });
                }
             }
          }
       }
    }
    flattened.sort((a, b) {
       final sphA = double.tryParse(a['sph'].toString()) ?? 0;
       final sphB = double.tryParse(b['sph'].toString()) ?? 0;
       if (sphA != sphB) return sphA.compareTo(sphB);
       
       final cylA = double.tryParse(a['cyl'].toString()) ?? 0;
       final cylB = double.tryParse(b['cyl'].toString()) ?? 0;
       if (cylA != cylB) return cylA.compareTo(cylB);

       final addA = double.tryParse(a['addValue'].toString()) ?? 0;
       final addB = double.tryParse(b['addValue'].toString()) ?? 0;
       return addA.compareTo(addB);
    });
    return flattened;
  }

  String _formatPowerGroupLabel(Map<String, dynamic> pg) {
    if (pg['label'] != null && pg['label'].toString().isNotEmpty && pg['label'] != 'Group') return pg['label'];
    String label = "";
    if (pg['sphMin'] != null) label += "SPH(${pg['sphMin']} to ${pg['sphMax']}) ";
    if (pg['cylMin'] != null) label += "CYL(${pg['cylMin']} to ${pg['cylMax']}) ";
    if (pg['addMin'] != null) label += "ADD(${pg['addMin']} to ${pg['addMax']}) ";
    return label.trim().isEmpty ? "Power Group" : label.trim();
  }

  @override
  Widget build(BuildContext context) {
    final displayRows = _filteredRows ?? _flattenedRows;
    final groups = Provider.of<ItemGroupProvider>(context).groups;
    final items = Provider.of<ItemMasterProvider>(context).items;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          SelectionArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  const Padding(
                    padding: EdgeInsets.only(bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Lens Rate", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                        SizedBox(height: 4),
                        Text("Manage lens pricing and power specifications", style: TextStyle(color: Color(0xFF475569), fontSize: 14)),
                      ],
                    ),
                  ),

                  // Form Section
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2))],
                    ),
                    child: Column(
                      children: [
                        // Collapse Header
                        InkWell(
                          onTap: () => setState(() => _collapsed = !_collapsed),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Settings", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                                    Text("Collapse to hide all controls", style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                     color: const Color(0xFFF8FAFC),
                                     border: Border.all(color: const Color(0xFFE2E8F0)),
                                     borderRadius: BorderRadius.circular(6)
                                  ),
                                  child: Icon(_collapsed ? LucideIcons.chevronDown : LucideIcons.chevronUp, size: 16),
                                )
                              ],
                            ),
                          ),
                        ),

                        // Collapsible Content
                        if (!_collapsed)
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 // Group & Item Row
                                 Row(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                      Expanded(flex: 4, child: _buildAutoComplete("Group Name", _groupNameCtrl, groups.map((e) => e.groupName ?? '').toList(), (val) async {
                                         _groupNameCtrl.text = val;
                                         _itemNameCtrl.clear();
                                         _newData = null;
                                         setState(() {});
                                         await _ensureDataLoaded();
                                      })),
                                      const SizedBox(width: 16),
                                      Expanded(flex: 4, child: _buildAutocompleteItem("Item Name", _itemNameCtrl, items, (item) async {
                                         _itemNameCtrl.text = item.itemName ?? '';
                                         if (_groupNameCtrl.text.isEmpty && item.groupName != null) {
                                            _groupNameCtrl.text = item.groupName!;
                                         }
                                         
                                         // Logic Parity: Fetch power groups immediately on selection
                                         final lp = Provider.of<LensGroupProvider>(context, listen: false);
                                         final res = await lp.getPowerGroupsForProduct(item.itemName ?? '');
                                         setState(() {
                                            _powerGroups = res;
                                         });
                                         await _ensureDataLoaded();
                                      })),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        flex: 2, 
                                        child: Container(
                                          height: 44,
                                          margin: const EdgeInsets.only(top: 6),
                                          child: MaterialButton(
                                            onPressed: _handleShowList,
                                            color: _showDetails ? const Color(0xFFD1D5DB) : const Color(0xFF2563EB), 
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(LucideIcons.eye, size: 16, color: _showDetails ? const Color(0xFF6B7280) : Colors.white),
                                                const SizedBox(width: 8),
                                                Text(_showDetails ? "Hide" : "Show", style: TextStyle(color: _showDetails ? const Color(0xFF6B7280) : Colors.white, fontWeight: FontWeight.w600)),
                                              ],
                                            ),
                                          ),
                                        )
                                      )
                                   ],
                                 ),
                                 
                                 const SizedBox(height: 24),
                                 const Text("Power Range", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
                                 const SizedBox(height: 12),
                                 
                                 Row(
                                   children: [
                                      Expanded(flex: 2, child: _buildDropdown(
                                        "Power Group", 
                                        ["", ..._powerGroups.map<String>((e) => (e['_id'] ?? e['id'] ?? '').toString())], 
                                        ["Select Power Group", ..._powerGroups.map<String>((e) => _formatPowerGroupLabel(e))], 
                                        _selectedPowerGroupId, 
                                        (val) {
                                         _selectedPowerGroupId = val ?? '';
                                         final pg = _powerGroups.firstWhere(
                                           (p) => (p['_id'] ?? p['id'] ?? '').toString() == val, 
                                           orElse: () => <String, dynamic>{}
                                         );
                                         if (pg.isNotEmpty) {
                                            _purchasePriceCtrl.text = (pg['purchasePrice'] ?? 0).toString();
                                            _saleDefaultCtrl.text = (pg['salePrice'] is Map ? pg['salePrice']['default'] : pg['salePrice'])?.toString() ?? '0';
                                         }
                                         setState((){});
                                      })),
                                     const SizedBox(width: 16),
                                     Expanded(flex: 2, child: _buildTextField("Axis", _axisCtrl)),
                                     const SizedBox(width: 16),
                                     Expanded(flex: 2, child: _buildDropdown("Eye (R/L)", ["", "R", "L", "RL"], ["Select Eye", "R", "L", "RL"], _selectedEye, (val) => setState(()=>_selectedEye = val ?? ''))),
                                     const SizedBox(width: 16),
                                     Expanded(
                                       flex: 3, 
                                       child: Row(
                                          children: [
                                             Container(
                                               height: 44, margin: const EdgeInsets.only(top: 6),
                                               child: MaterialButton(
                                                 onPressed: _handleFilter, 
                                                 color: const Color(0xFF2563EB), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), elevation: 0,
                                                 child: const Icon(LucideIcons.filter, size: 16, color: Colors.white),
                                               )
                                             ),
                                             const SizedBox(width: 12),
                                             Container(
                                               height: 44, margin: const EdgeInsets.only(top: 6),
                                               child: MaterialButton(
                                                 onPressed: _clearFilters, 
                                                 color: const Color(0xFFF1F5F9), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), elevation: 0,
                                                 child: const Text("Clear Filters", style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF334155))),
                                               )
                                             )
                                          ]
                                       )
                                     )
                                   ]
                                 ),

                                 const SizedBox(height: 24),
                                 const Text("Enter Purchase Price", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
                                 const SizedBox(height: 12),
                                 SizedBox(width: 300, child: _buildTextField("Purchase Price", _purchasePriceCtrl, isNumber: true)),

                                 const SizedBox(height: 24),
                                 const Text("Enter Sale Price", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
                                 const SizedBox(height: 12),
                                 SizedBox(width: 300, child: _buildTextField("Sale Price (Default)", _saleDefaultCtrl, isNumber: true)),

                                 const SizedBox(height: 24),
                                 Row(
                                   children: [
                                     MaterialButton(
                                        onPressed: _handleSave, color: const Color(0xFF16A34A),
                                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), elevation: 0,
                                        child: const Row(children: [Icon(LucideIcons.save, size: 16, color: Colors.white), SizedBox(width: 8), Text("Save", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600))])
                                     ),
                                     const SizedBox(width: 16),
                                     MaterialButton(
                                        onPressed: _handleCancel, color: const Color(0xFFDC2626),
                                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), elevation: 0,
                                        child: const Row(children: [Icon(LucideIcons.x, size: 16, color: Colors.white), SizedBox(width: 8), Text("Cancel", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600))])
                                     )
                                   ]
                                 )
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Results Table Section
          if (_showDetails && _newData != null)
            Positioned(
              bottom: 0,
              left: 24,
              right: 24,
              height: MediaQuery.of(context).size.height * 0.45,
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                        // Updated Table Header
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF1F5F9),
                            border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0)))
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 40, child: Text("Sr No.", style: _headerStyle())),
                              const Expanded(flex: 4, child: Text("Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1E293B)))),
                              SizedBox(width: 70, child: Center(child: Text("SPH", style: _headerStyle()))),
                              SizedBox(width: 70, child: Center(child: Text("CYL", style: _headerStyle()))),
                              SizedBox(width: 70, child: Center(child: Text("Add", style: _headerStyle()))),
                              SizedBox(width: 60, child: Center(child: Text("Eye", style: _headerStyle()))),
                              SizedBox(width: 60, child: Center(child: Text("Axis", style: _headerStyle()))),
                              const Expanded(flex: 3, child: Center(child: Text("Barcode", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1E293B))))),
                              SizedBox(width: 100, child: Center(child: Text("Pur Price", style: _headerStyle()))),
                              SizedBox(width: 100, child: Center(child: Text("Sale Price", style: _headerStyle()))),
                            ],
                          ),
                        ),
                        // Table Body
                        Expanded(
                          child: ListView.separated(
                             itemCount: displayRows.length,
                             separatorBuilder: (ctx, i) => const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
                             itemBuilder: (ctx, idx) {
                                final row = displayRows[idx];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  child: Row(
                                     children: [
                                       SizedBox(width: 40, child: Text('${idx + 1}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 13))),
                                       Expanded(
                                          flex: 4, 
                                          child: Column(
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                                               Text(row['name']?.toString() ?? _itemNameCtrl.text, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF1E293B))),
                                               Text(_groupNameCtrl.text, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                                             ],
                                          )
                                       ),
                                       SizedBox(width: 70, child: Center(child: _buildBadge(row['sph']?.toString() ?? '', color: const Color(0xFFEFF6FF), textColor: const Color(0xFF2563EB)))),
                                       SizedBox(width: 70, child: Center(child: _buildBadge(row['cyl']?.toString() ?? '', color: const Color(0xFFEFF6FF), textColor: const Color(0xFF2563EB)))),
                                       SizedBox(width: 70, child: Center(child: _buildBadge(row['addValue']?.toString() ?? '', color: const Color(0xFFF8FAFC), textColor: const Color(0xFF475569)))),
                                       SizedBox(width: 60, child: Center(child: _buildBadge(row['eye']?.toString() ?? '', color: const Color(0xFFF0FDF4), textColor: const Color(0xFF16A34A)))),
                                       SizedBox(width: 60, child: Center(child: Text(row['axis']?.toString() ?? '', style: const TextStyle(fontSize: 13, color: Color(0xFF475569))))),
                                       Expanded(flex: 3, child: Center(child: Text(row['barcode']?.toString() ?? '-', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontFamily: 'monospace')))),
                                       SizedBox(width: 100, child: Center(child: Text('₹${row['pPrice']?.toString() ?? '0'}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))))),
                                       SizedBox(width: 100, child: Center(child: Text('₹${row['sPrice']?.toString() ?? '0'}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))))),
                                     ]
                                  )
                                );
                             }
                          )
                        )
                    ]
                  )
                )
              )
            ),

          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.1),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isNumber = false}) {
     return Stack(
       clipBehavior: Clip.none,
       children: [
         Container(
           height: 48,
           margin: const EdgeInsets.only(top: 6),
           decoration: BoxDecoration(
             border: Border.all(color: const Color(0xFFCBD5E1), width: 1.5),
             borderRadius: BorderRadius.circular(10),
           ),
           child: TextField(
             controller: controller,
             keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
             style: const TextStyle(fontSize: 14),
             decoration: InputDecoration(
               hintText: label,
               hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
               border: InputBorder.none,
               contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
             ),
           ),
         ),
         Positioned(
           left: 10, top: -2,
           child: Container(color: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 4), child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF64748B))))
         )
       ],
     );
  }

  Widget _buildDropdown(String label, List<String> values, List<String> labels, String selected, Function(String?) onChanged) {
     return Stack(
       clipBehavior: Clip.none,
       children: [
         Container(
           height: 48,
           margin: const EdgeInsets.only(top: 6),
           decoration: BoxDecoration(
             border: Border.all(color: const Color(0xFFCBD5E1), width: 1.5),
             borderRadius: BorderRadius.circular(10),
             color: Colors.white,
           ),
           child: Theme(
             data: Theme.of(context).copyWith(
               hoverColor: Colors.transparent,
               focusColor: Colors.transparent,
               splashColor: Colors.transparent,
             ),
             child: DropdownButtonHideUnderline(
               child: DropdownButton<String>(
                 isExpanded: true,
                 value: values.contains(selected) ? selected : (values.isNotEmpty ? values[0] : null),
                 icon: const Padding(padding: EdgeInsets.only(right: 12), child: Icon(LucideIcons.chevronDown, size: 16, color: Color(0xFF94A3B8))),
                 padding: const EdgeInsets.only(left: 14),
                 dropdownColor: Colors.white,
                 borderRadius: BorderRadius.circular(10),
                 elevation: 8,
                 style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
                 items: List.generate(values.length, (idx) => DropdownMenuItem(
                   value: values[idx], 
                   child: Text(
                     labels[idx], 
                     style: const TextStyle(fontSize: 14, overflow: TextOverflow.ellipsis),
                   )
                 )),
                 onChanged: onChanged,
               )
             ),
           )
         ),
         Positioned(
           left: 10, top: -2,
           child: Container(color: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 4), child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF64748B))))
         )
       ],
     );
  }

  Widget _buildAutoComplete(String label, TextEditingController controller, List<String> options, Function(String) onSelected) {
     return Stack(
       clipBehavior: Clip.none,
       children: [
         Container(
           height: 48,
           margin: const EdgeInsets.only(top: 6),
           decoration: BoxDecoration(border: Border.all(color: const Color(0xFFCBD5E1), width: 1.5), borderRadius: BorderRadius.circular(10)),
           child: Autocomplete<String>(
              initialValue: TextEditingValue(text: controller.text),
              optionsBuilder: (val) => val.text.isEmpty 
                  ? options 
                  : options.where((e) => e.toLowerCase().contains(val.text.toLowerCase())),
              onSelected: (val) {
                 controller.text = val;
                 onSelected(val);
              },
              fieldViewBuilder: (ctx, ctrl, fNode, onSubmit) {
                 if (ctrl.text != controller.text && !fNode.hasFocus) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                       if (ctrl.text != controller.text) ctrl.text = controller.text;
                    });
                 }
                 ctrl.addListener(() { if (controller.text != ctrl.text) controller.text = ctrl.text; });
                 return TextField(
                   controller: ctrl,
                   focusNode: fNode,
                   onTap: () {
                     if (ctrl.text.isEmpty) {
                       final current = ctrl.text;
                       ctrl.text = current + ' ';
                       ctrl.text = current;
                     }
                   },
                   style: const TextStyle(fontSize: 14),
                   decoration: InputDecoration(hintText: label, hintStyle: const TextStyle(color: Color(0xFF94A3B8)), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12))
                 );
              }
           )
         ),
         Positioned(left: 10, top: -2, child: Container(color: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 4), child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF64748B)))))
       ]
     );
  }
  
  Widget _buildAutocompleteItem(String label, TextEditingController controller, List<ItemMasterModel> items, Function(ItemMasterModel) onSelected) {
     return Stack(
       clipBehavior: Clip.none,
       children: [
         Container(
           height: 48,
           margin: const EdgeInsets.only(top: 6),
           decoration: BoxDecoration(border: Border.all(color: const Color(0xFFCBD5E1), width: 1.5), borderRadius: BorderRadius.circular(10)),
           child: Autocomplete<ItemMasterModel>(
              initialValue: TextEditingValue(text: controller.text),
              optionsBuilder: (val) => val.text.isEmpty 
                  ? items 
                  : items.where((e) => (e.itemName ?? '').toLowerCase().contains(val.text.toLowerCase())),
              displayStringForOption: (item) => item.itemName ?? '',
              onSelected: (item) {
                 controller.text = item.itemName ?? '';
                 onSelected(item);
              },
              fieldViewBuilder: (ctx, ctrl, fNode, onSubmit) {
                 if (ctrl.text != controller.text && !fNode.hasFocus) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                       if (ctrl.text != controller.text) ctrl.text = controller.text;
                    });
                 }
                 ctrl.addListener(() { if (controller.text != ctrl.text) controller.text = ctrl.text; });
                 return TextField(
                   controller: ctrl,
                   focusNode: fNode,
                   onTap: () {
                     if (ctrl.text.isEmpty) {
                       final current = ctrl.text;
                       ctrl.text = current + ' ';
                       ctrl.text = current;
                     }
                   },
                   style: const TextStyle(fontSize: 14),
                   decoration: InputDecoration(hintText: label, hintStyle: const TextStyle(color: Color(0xFF94A3B8)), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12))
                 );
              }
           )
         ),
         Positioned(left: 10, top: -2, child: Container(color: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 4), child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF64748B)))))
       ]
     );
   }

   TextStyle _headerStyle() => const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF475569));

   Widget _buildBadge(String text, {required Color color, required Color textColor}) {
      if (text.isEmpty || text == '-') return const Text('-', style: TextStyle(color: Color(0xFF94A3B8)));
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(text, style: TextStyle(color: textColor, fontSize: 11, fontWeight: FontWeight.bold)),
      );
   }
}
