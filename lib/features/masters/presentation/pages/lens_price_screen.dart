import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../data/providers/inventory_providers.dart';

class LensPriceScreen extends StatefulWidget {
  const LensPriceScreen({super.key});

  @override
  State<LensPriceScreen> createState() => _LensPriceScreenState();
}

class _LensPriceScreenState extends State<LensPriceScreen> {
  List<Map<String, dynamic>> _lensData = [];
  bool _isLoading = false;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    final provider = Provider.of<LensGroupProvider>(context, listen: false);
    final data = await provider.getAllLensPower();
    if (mounted) {
      setState(() {
        _lensData = data;
        _isLoading = false;
      });
    }
  }

  Future<void> _resetHighlights() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Reset Highlights", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("Are you sure you want to reset all price highlights? This cannot be undone."),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true), 
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber[700], foregroundColor: Colors.white),
            child: const Text("Reset Highlights")
          ),
        ],
      )
    );
    if (confirm != true) return;

    final provider = Provider.of<LensGroupProvider>(context, listen: false);
    final success = await provider.resetAllLensPriceHighlights();
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Highlights reset successfully.')));
      _fetchData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to reset highlights.')));
    }
  }

  void _handleDelete(String id) async {
     final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(LucideIcons.alertTriangle, color: Colors.red),
            SizedBox(width: 8),
            Text("Confirm Delete"),
          ],
        ),
        content: const Text("Are you sure you want to delete this lens power permanently?"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(ctx, true), 
            child: const Text("Delete")
          ),
        ],
      )
    );
    if (confirm != true) return;

    final provider = Provider.of<LensGroupProvider>(context, listen: false);
    try {
      await provider.removeLensPower([id]);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Deleted successfully.')));
      _fetchData();
    } catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  List<Map<String, dynamic>> get _visibleLenses {
    final q = _searchText.trim().toLowerCase();
    
    // Search filtering
    final filtered = q.isEmpty 
        ? _lensData 
        : _lensData.where((lens) {
            final fields = '${lens['productName']} ${lens['groupName']} ${lens['eye']}'.toLowerCase();
            return fields.contains(q);
          }).toList();

    // Flatten per power group matching React logic
    final List<Map<String, dynamic>> flattened = [];
    for (var lens in filtered) {
       final pGroups = lens['powerGroups'] as List?;
       if (pGroups != null && pGroups.isNotEmpty) {
          for (var pg in pGroups) {
             flattened.add({
               ...lens,
               'currentPowerGroup': pg,
               'rowId': '${lens['_id']}_${pg['_id']}',
               'originalLensId': lens['_id'],
               'originalPowerGroupId': pg['_id'],
             });
          }
       } else {
          flattened.add({
             ...lens,
             'currentPowerGroup': null,
             'rowId': lens['_id'],
             'originalLensId': lens['_id'],
             'originalPowerGroupId': null,
          });
       }
    }
    return flattened;
  }

  @override
  Widget build(BuildContext context) {
    final lenses = _visibleLenses;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Premium Header with Gradient
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[900]!, Colors.blue[700]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(color: Colors.blue.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Lens Price List", 
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -0.5)
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Manage lens pricing and specifications across categories", 
                      style: TextStyle(color: Colors.blue[100], fontSize: 14)
                    ),
                  ],
                ),
                Row(
                  children: [
                    _buildHeaderAction(
                      label: "Add Lens Price",
                      icon: LucideIcons.plus,
                      color: Colors.teal[500]!,
                      onPressed: () => context.push('/masters/inventorymaster/lensgroupcreation'),
                    ),
                    const SizedBox(width: 12),
                    _buildHeaderAction(
                      label: "Reset Highlights",
                      icon: LucideIcons.refreshCw,
                      color: Colors.amber[600]!,
                      onPressed: _resetHighlights,
                    ),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
                    ),
                    child: TextField(
                      onChanged: (val) => setState(() => _searchText = val),
                      decoration: InputDecoration(
                        hintText: "Search by Name, Group, Power Group...",
                        prefixIcon: const Icon(LucideIcons.search, size: 18),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                _buildCircularButton(LucideIcons.fileSpreadsheet, Colors.green, "Export Excel", () {
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Excel Exporting...')));
                }),
                const SizedBox(width: 8),
                _buildCircularButton(LucideIcons.printer, Colors.blue, "Print List", () {
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Preparing for Print...')));
                }),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Table Section
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15)],
              ),
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator()) 
                : lenses.isEmpty 
                  ? _buildEmptyState()
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowHeight: 56,
                            dataRowHeight: 64,
                            headingRowColor: MaterialStateProperty.all(const Color(0xFFF1F5F9)),
                            columnSpacing: 24,
                            columns: [
                              _buildColumn("SR."),
                              _buildColumn("TITLE", isSortable: true),
                              _buildColumn("GROUP"),
                              _buildColumn("POWER GROUP"),
                              _buildColumn("PRICE"),
                              _buildColumn("EYE"),
                              _buildColumn("SPH"),
                              _buildColumn("CYL"),
                              _buildColumn("AXIS"),
                              _buildColumn("ADD"),
                              _buildColumn("ACTIONS"),
                            ],
                            rows: List.generate(lenses.length, (index) {
                              final lens = lenses[index];
                              final pg = lens['currentPowerGroup'];
                              final isEven = index % 2 == 0;
                              
                              final price = pg != null 
                                ? (pg['salePrice'] ?? 0) 
                                : ((lens['salePrice'] as Map?)?['default'] ?? 0);
                              final isPriceUpdated = lens['isPriceUpdated'] == true;

                              final sph = pg != null ? '${pg['sphMin']} - ${pg['sphMax']}' : '${lens['sphMin']} - ${lens['sphMax']}';
                              final cyl = pg != null ? '${pg['cylMin']} - ${pg['cylMax']}' : '${lens['cylMin']} - ${lens['cylMax']}';
                              final axis = pg?['axis'] ?? lens['axis'] ?? "-";
                              final addVal = pg != null ? '${pg['addMin']} - ${pg['addMax']}' : '${lens['addMin']} - ${lens['addMax']}';

                              return DataRow(
                                color: MaterialStateProperty.all(isEven ? Colors.white : const Color(0xFFF8FAFC)),
                                cells: [
                                  DataCell(Text('${index + 1}', style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold))),
                                  DataCell(Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('${lens['productName']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                      if (isPriceUpdated) 
                                        const Text('PRICE UPDATED', style: TextStyle(fontSize: 9, color: Colors.orange, fontWeight: FontWeight.w900)),
                                    ],
                                  )),
                                  DataCell(Text('${lens['groupName']}', style: TextStyle(color: Colors.blueGrey[600], fontSize: 13))),
                                  DataCell(Text(pg?['label'] ?? '-', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))),
                                  DataCell(Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: isPriceUpdated ? Colors.yellow[100] : Colors.blue[50],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text('₹$price', style: TextStyle(fontWeight: FontWeight.bold, color: isPriceUpdated ? Colors.orange[900] : Colors.blue[900])),
                                  )),
                                  DataCell(Text((lens['eye'] ?? '').toString().toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                                  DataCell(Text(sph)),
                                  DataCell(Text(cyl)),
                                  DataCell(Text(axis.toString())),
                                  DataCell(Text(addVal)),
                                  DataCell(Row(
                                    children: [
                                      _buildIconButton(
                                        icon: LucideIcons.pencil, 
                                        color: Colors.blue, 
                                        onPressed: () => context.push('/masters/inventorymaster/lensgroupcreation?id=${lens['originalLensId']}'),
                                      ),
                                      const SizedBox(width: 8),
                                      _buildIconButton(
                                        icon: LucideIcons.trash2, 
                                        color: Colors.red, 
                                        onPressed: () => _handleDelete(lens['originalLensId']),
                                      ),
                                    ],
                                  )),
                                ],
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  DataColumn _buildColumn(String label, {bool isSortable = false}) {
    return DataColumn(
      label: Text(
        label, 
        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF475569), fontSize: 12, letterSpacing: 0.5)
      ),
    );
  }

  Widget _buildHeaderAction({required String label, required IconData icon, required Color color, required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildCircularButton(IconData icon, Color color, String tooltip, VoidCallback onPressed) {
    return Tooltip(
      message: tooltip,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: IconButton(
          icon: Icon(icon, color: color, size: 20),
          onPressed: onPressed,
        ),
      ),
    );
  }

  Widget _buildIconButton({required IconData icon, required Color color, required VoidCallback onPressed}) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 16, color: color),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.packageSearch, size: 64, color: Colors.blueGrey[200]),
          const SizedBox(height: 16),
          Text("No lens prices found", style: TextStyle(fontSize: 18, color: Colors.blueGrey[400], fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text("Try adjusting your search or add a new lens", style: TextStyle(color: Colors.blueGrey[300])),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.push('/masters/inventorymaster/lensgroupcreation'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[600], foregroundColor: Colors.white),
            child: const Text("Add New Lens"),
          ),
        ],
      ),
    );
  }
}
