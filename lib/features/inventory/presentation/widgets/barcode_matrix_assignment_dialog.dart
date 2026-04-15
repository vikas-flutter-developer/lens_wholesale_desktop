import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../masters/data/models/lens_group_model.dart';
import '../providers/inventory_provider.dart';

class BarcodeMatrixAssignmentDialog extends StatefulWidget {
  final LensGroupModel lensData;

  const BarcodeMatrixAssignmentDialog({
    super.key,
    required this.lensData,
  });

  @override
  State<BarcodeMatrixAssignmentDialog> createState() => _BarcodeMatrixAssignmentDialogState();
}

class _BarcodeMatrixAssignmentDialogState extends State<BarcodeMatrixAssignmentDialog> {
  final Map<String, String> _barcodeEdits = {};
  bool _isGenerating = false;
  final TextEditingController _prefixController = TextEditingController();

  @override
  void dispose() {
    _prefixController.dispose();
    super.dispose();
  }

  Future<void> _generateAutoBarcodes() async {
    setState(() => _isGenerating = true);
    final prefix = _prefixController.text;

    try {
      int count = 1;
      for (var ag in widget.lensData.addGroups) {
        for (var comb in ag.combinations) {
          final key = '${comb.sph}_${comb.cyl}_${comb.eye}_${ag.name}';
          final uniquePart = count.toString().padLeft(4, '0');
          _barcodeEdits[key] = '$prefix$uniquePart';
          count++;
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Auto-generated barcodes based on prefix')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> allCombinations = [];
    for (var ag in widget.lensData.addGroups) {
      for (var comb in ag.combinations) {
        allCombinations.add({
          'comb': comb,
          'addValue': ag.name,
          'key': '${comb.sph}_${comb.cyl}_${comb.eye}_${ag.name}',
        });
      }
    }

    return Dialog(
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
       child: Container(
         width: 900,
         height: 700,
         padding: const EdgeInsets.all(28),
         decoration: BoxDecoration(
           color: Colors.white,
           borderRadius: BorderRadius.circular(20),
         ),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     const Text("Bulk Barcode Assignment", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                     Text(widget.lensData.productName, style: const TextStyle(color: Color(0xFF64748B))),
                   ],
                 ),
                 IconButton(icon: const Icon(LucideIcons.x), onPressed: () => Navigator.pop(context)),
               ],
             ),
             const Divider(height: 48),
             
             // Generator Row
             Container(
               padding: const EdgeInsets.all(16),
               decoration: BoxDecoration(
                 color: const Color(0xFFF8FAFC),
                 borderRadius: BorderRadius.circular(16),
                 border: Border.all(color: const Color(0xFFE2E8F0)),
               ),
               child: Row(
                 children: [
                   Expanded(
                     child: TextField(
                       controller: _prefixController,
                       decoration: const InputDecoration(
                         labelText: "Barcode Prefix (e.g., LENS-)",
                         border: OutlineInputBorder(),
                         filled: true,
                         fillColor: Colors.white,
                       ),
                     ),
                   ),
                   const SizedBox(width: 16),
                   ElevatedButton.icon(
                     onPressed: _isGenerating ? null : _generateAutoBarcodes,
                     icon: const Icon(LucideIcons.zap),
                     label: const Text("Auto-Generate All"),
                     style: ElevatedButton.styleFrom(
                       backgroundColor: const Color(0xFF3B82F6),
                       foregroundColor: Colors.white,
                       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                     ),
                   ),
                 ],
               ),
             ),
             const SizedBox(height: 24),

             // Table
             Expanded(
               child: Container(
                 decoration: BoxDecoration(
                   border: Border.all(color: const Color(0xFFE2E8F0)),
                   borderRadius: BorderRadius.circular(16),
                 ),
                 child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: ListView.builder(
                      itemCount: allCombinations.length,
                      itemBuilder: (context, index) {
                        final item = allCombinations[index];
                        final comb = item['comb'] as LensCombination;
                        final key = item['key'] as String;

                        return Container(
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
                          ),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
                              child: Text('${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            title: Text('SPH: ${comb.sph} | CYL: ${comb.cyl} | ADD: ${item['addValue']}'),
                            subtitle: Text('Side: ${comb.eye}'),
                            trailing: SizedBox(
                              width: 250,
                              child: TextFormField(
                                initialValue: _barcodeEdits[key] ?? comb.barcode,
                                key: Key('${key}_${_barcodeEdits[key]}'), // Force rebuild on auto-gen
                                decoration: const InputDecoration(
                                  hintText: "Scan/Type Barcode",
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  prefixIcon: Icon(LucideIcons.scan, size: 16),
                                ),
                                onChanged: (val) => _barcodeEdits[key] = val,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                 ),
               ),
             ),
             const SizedBox(height: 24),

             // Actions
             Row(
               mainAxisAlignment: MainAxisAlignment.end,
               children: [
                 TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                 const SizedBox(width: 16),
                 ElevatedButton(
                   onPressed: () {
                     // Collect bulk data to save
                     final List<Map<String, dynamic>> scans = [];
                     _barcodeEdits.forEach((key, barcode) {
                       if (barcode.isNotEmpty) {
                         final parts = key.split('_');
                         scans.add({
                           'barcode': barcode,
                           'productId': widget.lensData.id,
                           'sph': double.parse(parts[0]),
                           'cyl': double.parse(parts[1]),
                           'eye': parts[2],
                           'add': double.parse(parts[3]),
                         });
                       }
                     });
                     Provider.of<InventoryProvider>(context, listen: false).bulkSaveBarcodes(scans);
                     Navigator.pop(context, true);
                   },
                   style: ElevatedButton.styleFrom(
                     backgroundColor: const Color(0xFF0F172A),
                     foregroundColor: Colors.white,
                     padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                   ),
                   child: const Text("Save & Apply All"),
                 ),
               ],
             ),
           ],
         ),
       ),
    );
  }
}
