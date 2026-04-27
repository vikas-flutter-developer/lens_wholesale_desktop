import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../data/providers/inventory_providers.dart';
import '../../../../core/utils/color_utils.dart';

class LensPriceScreen extends StatefulWidget {
  const LensPriceScreen({super.key});

  @override
  State<LensPriceScreen> createState() => _LensPriceScreenState();
}

class _LensPriceScreenState extends State<LensPriceScreen> {
  List<Map<String, dynamic>> _lensData = [];
  bool _isLoading = false;
  bool _isDeleting = false;
  String _searchText = '';
  final TextEditingController _searchController = TextEditingController();

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
        content: const Text("Are you sure you want to reset all price highlights?"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true), 
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFCA8A04), foregroundColor: Colors.white),
            child: const Text("Reset Highlights")
          ),
        ],
      )
    );
    if (confirm != true) return;

    final provider = Provider.of<LensGroupProvider>(context, listen: false);
    final success = await provider.resetAllLensPriceHighlights();
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Price highlights reset')));
      _fetchData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to reset highlights')));
    }
  }

  void _handleDelete(String id) async {
     final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this lens power?"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626), foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(ctx, true), 
            child: const Text("Delete")
          ),
        ],
      )
    );
    if (confirm != true) return;

    final provider = Provider.of<LensGroupProvider>(context, listen: false);
    setState(() => _isDeleting = true);
    try {
      await provider.removeLensPower([id]);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lens power deleted successfully')));
        _fetchData();
      }
    } catch(e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
  }

  List<Map<String, dynamic>> get _visibleLenses {
    final q = _searchText.trim().toLowerCase();
    
    final filtered = q.isEmpty 
        ? _lensData 
        : _lensData.where((lens) {
            final fields = '${lens['productName']} ${lens['groupName']} ${lens['eye']}'.toLowerCase();
            return fields.contains(q);
          }).toList();

    final List<Map<String, dynamic>> flattened = [];
    for (var lens in filtered) {
       final rawGroups = lens['powerGroups'];
       List<dynamic>? pGroups;
       if (rawGroups is List) {
         pGroups = rawGroups;
       } else if (rawGroups is Map) {
         pGroups = [rawGroups];
       }
       
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
      backgroundColor: const Color(0xFFF1F5F9), // bg-slate-100
      body: Padding(
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
                  Text("Lens Price List", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                  SizedBox(height: 4),
                  Text("Manage lens pricing and specifications", style: TextStyle(color: Color(0xFF475569), fontSize: 14)),
                ],
              ),
            ),

            // Search and Actions Bar
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))],
              ),
              child: Row(
                children: [
                  // Floating Label Search Input
                  Expanded(
                    flex: 2,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 42,
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFCBD5E1)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (val) => setState(() => _searchText = val),
                            style: const TextStyle(fontSize: 14),
                            decoration: const InputDecoration(
                              hintText: "Search by Name, Group, Power Group...",
                              hintStyle: TextStyle(color: Color(0xFF94A3B8)),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 8,
                          top: -8,
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: const Text("Search", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF64748B))),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Action Buttons
                  Expanded(
                    flex: 3,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _buildActionButton(
                          label: "Search",
                          icon: LucideIcons.search,
                          bgColor: const Color(0xFF2563EB), // text-white
                          textColor: Colors.white,
                          onPressed: () {},
                        ),
                        _buildActionButton(
                          label: "Reset",
                          icon: LucideIcons.refreshCw,
                          bgColor: const Color(0xFFF3F4F6), // bg-gray-100
                          textColor: const Color(0xFF374151), // text-gray-700
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchText = '');
                          },
                        ),
                        _buildActionButton(
                          label: "Reset Highlights",
                          icon: LucideIcons.refreshCw,
                          bgColor: const Color(0xFFFEF9C3), // bg-yellow-100
                          textColor: const Color(0xFFA16207), // text-yellow-700
                          onPressed: _resetHighlights,
                        ),
                        _buildActionButton(
                          label: "Add Lens Price",
                          icon: LucideIcons.plus,
                          bgColor: const Color(0xFF16A34A), // bg-green-600
                          textColor: Colors.white,
                          onPressed: () => context.push('/lenstransaction/lensratemaster'),
                        ),
                        _buildIconButton(
                          icon: LucideIcons.sheet,
                          bgColor: const Color(0xFFD1FAE5), // emerald-100
                          iconColor: const Color(0xFF047857), // emerald-700
                          onPressed: () {},
                        ),
                        _buildIconButton(
                          icon: LucideIcons.printer,
                          bgColor: const Color(0xFFDBEAFE), // blue-100
                          iconColor: const Color(0xFF1D4ED8), // blue-700
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Table Section
            Expanded(
              child: Container(
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
                      // Header Row
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFEFF6FF), Color(0xFFF8FAFC)], // from-blue-50 to-slate-50
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            _headerCell("Sr\nNo.", width: 50, center: true),
                            _headerCell("Title", flex: 3),
                            _headerCell("Group", flex: 2, center: true),
                            _headerCell("Power Group", flex: 2, center: true),
                            _headerCell("Price", flex: 1, center: true),
                            _headerCell("Eye", flex: 1, center: true),
                            _headerCell("SPH", flex: 2, center: true),
                            _headerCell("CYL", flex: 2, center: true),
                            _headerCell("AXIS", flex: 1, center: true),
                            _headerCell("ADD", flex: 2, center: true),
                            _headerCell("Actions", flex: 1, center: true),
                          ],
                        ),
                      ),
                      
                      // Body
                      Expanded(
                        child: _isLoading 
                          ? const Center(child: CircularProgressIndicator()) 
                          : lenses.isEmpty 
                            ? _buildEmptyState()
                            : ListView.separated(
                                padding: EdgeInsets.zero,
                                itemCount: lenses.length,
                                separatorBuilder: (ctx, i) => const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
                                itemBuilder: (ctx, index) {
                                  final lens = lenses[index];
                                  final pg = lens['currentPowerGroup'];
                                  
                                  final price = pg != null ? (pg['salePrice'] ?? 0) : ((lens['salePrice'] as Map?)?['default'] ?? 0);
                                  final isPriceUpdated = lens['isPriceUpdated'] == true;
                                  
                                  final sph = pg != null ? '${pg['sphMin']} to ${pg['sphMax']}' : '${lens['sphMin']} to ${lens['sphMax']}';
                                  final cyl = pg != null ? '${pg['cylMin']} to ${pg['cylMax']}' : '${lens['cylMin']} to ${lens['cylMax']}';
                                  final axis = pg?['axis'] ?? lens['axis'] ?? "-";
                                  final addVal = pg != null ? '${pg['addMin']} to ${pg['addMax']}' : '${lens['addMin']} to ${lens['addMax']}';

                                  return Container(
                                    color: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        _cellText('${index + 1}', width: 50, center: true),
                                        Expanded(flex: 3, child: _cellText(lens['productName']?.toString() ?? '-', bold: true)),
                                        Expanded(
                                          flex: 2, 
                                          child: Center(
                                            child: () {
                                              final gColor = getGroupColor(lens['groupName']?.toString() ?? '-');
                                              return _badge(lens['groupName']?.toString() ?? '-', gColor.background, gColor.text);
                                            }(),
                                          ),
                                        ),
                                        Expanded(flex: 2, child: Center(child: _badge(pg?['label']?.toString() ?? '-', const Color(0xFFF3E8FF), const Color(0xFF6B21A8)))), // purple-100/purple-800
                                        Expanded(
                                          flex: 1, 
                                          child: Center(
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                                              decoration: BoxDecoration(
                                                color: isPriceUpdated ? const Color(0xFFFEF9C3) : Colors.transparent, // yellow-100
                                                border: isPriceUpdated ? const Border(left: BorderSide(color: Color(0xFFFEF08A)), right: BorderSide(color: Color(0xFFFEF08A))) : null,
                                              ),
                                              child: Text('₹$price', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isPriceUpdated ? const Color(0xFF713F12) : const Color(0xFF0F172A))),
                                            )
                                          )
                                        ),
                                        Expanded(flex: 1, child: Center(child: _eyeBadge((lens['eye']?.toString() ?? '').toUpperCase()))),
                                        Expanded(flex: 2, child: Center(child: _cellText(sph, fontSize: 11, color: const Color(0xFF64748B)))),
                                        Expanded(flex: 2, child: Center(child: _cellText(cyl, fontSize: 11, color: const Color(0xFF64748B)))),
                                        Expanded(flex: 1, child: Center(child: _cellText(axis.toString(), fontSize: 11, color: const Color(0xFF64748B)))),
                                        Expanded(flex: 2, child: Center(child: _cellText(addVal, fontSize: 11, color: const Color(0xFF64748B)))),
                                        Expanded(
                                          flex: 1,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                               _actionIcon(LucideIcons.pencil, const Color(0xFF2563EB), () {
                                                 final lensId = lens['originalLensId'] ?? lens['_id'] ?? lens['id'];
                                                 final pgId = lens['originalPowerGroupId'] ?? (lens['currentPowerGroup'] is Map ? (lens['currentPowerGroup']['_id'] ?? lens['currentPowerGroup']['id']) : '');
                                                 context.push('/lenstransaction/lensratemaster?id=$lensId&powerGroupId=$pgId');
                                               }),
                                               const SizedBox(width: 4),
                                               _isDeleting ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : _actionIcon(LucideIcons.trash2, const Color(0xFFDC2626), () {
                                                 if (_isDeleting) return;
                                                 _handleDelete(lens['originalLensId'] ?? lens['_id'] ?? lens['id'] ?? '');
                                               }),
                                            ],
                                          )
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerCell(String label, {double? width, int? flex, bool center = false}) {
    final text = Text(
      label, 
      style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF334155), fontSize: 12),
      textAlign: center ? TextAlign.center : TextAlign.left,
    );
    if (width != null) return SizedBox(width: width, child: text);
    if (flex != null) return Expanded(flex: flex, child: center ? Center(child: text) : text);
    return text;
  }

  Widget _cellText(String text, {double? width, bool bold = false, double fontSize = 13, Color color = const Color(0xFF334155), bool center = false}) {
    final t = Text(
      text, 
      style: TextStyle(fontWeight: bold ? FontWeight.w600 : FontWeight.normal, fontSize: fontSize, color: color),
      textAlign: center ? TextAlign.center : TextAlign.left,
      overflow: TextOverflow.ellipsis,
    );
    if (width != null) return SizedBox(width: width, child: center ? Center(child: t) : t);
    return t;
  }

  Widget _badge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
      child: Text(text, style: TextStyle(color: textColor, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }

  Widget _eyeBadge(String eye) {
    if (eye.isEmpty) return const SizedBox();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(color: const Color(0xFFFFEDD5), borderRadius: BorderRadius.circular(12)), // orange-100
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(LucideIcons.eye, size: 12, color: Color(0xFF9A3412)), // orange-800
          const SizedBox(width: 4),
          Text(eye, style: const TextStyle(color: Color(0xFF9A3412), fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _actionIcon(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }

  Widget _buildActionButton({required String label, required IconData icon, required Color bgColor, required Color textColor, required VoidCallback onPressed}) {
    return MaterialButton(
      onPressed: onPressed,
      color: bgColor,
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: textColor, fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildIconButton({required IconData icon, required Color bgColor, required Color iconColor, required VoidCallback onPressed}) {
    return MaterialButton(
      onPressed: onPressed,
      color: bgColor,
      elevation: 0,
      minWidth: 40,
      padding: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Icon(icon, size: 16, color: iconColor),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(LucideIcons.eye, size: 48, color: Color(0xFFCBD5E1)),
          const SizedBox(height: 16),
          const Text("No lens prices found", style: TextStyle(fontSize: 18, color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text("Try adjusting your search criteria or add a new lens price", style: TextStyle(color: Color(0xFF94A3B8))),
        ],
      ),
    );
  }
}
