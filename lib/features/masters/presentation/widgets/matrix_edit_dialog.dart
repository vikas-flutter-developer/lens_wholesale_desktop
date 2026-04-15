import 'package:flutter/material.dart';
import '../../data/models/lens_group_model.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MatrixEditDialog extends StatefulWidget {
  final LensGroupModel lensData;
  final String title;
  final bool isStockMatrix; // If true implies Stock/Barcode editing, otherwise Alert Qty

  const MatrixEditDialog({
    super.key,
    required this.lensData,
    required this.title,
    this.isStockMatrix = false,
  });

  @override
  State<MatrixEditDialog> createState() => _MatrixEditDialogState();
}

class _MatrixEditDialogState extends State<MatrixEditDialog> {
  // A map to store active edits keyed by unique combination hash
  final Map<String, String> _qtyEdits = {};

  @override
  Widget build(BuildContext context) {
    // For brevity, we render a flattened list of all combinations across all power groups
    List<LensCombination> allCombinations = [];
    if (widget.lensData.addGroups.isNotEmpty) {
      for (var ag in widget.lensData.addGroups) {
        allCombinations.addAll(ag.combinations);
      }
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 800,
        height: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.x),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(height: 32),
            Expanded(
              child: allCombinations.isEmpty
                  ? const Center(child: Text("No combinations found."))
                  : ListView.separated(
                      itemCount: allCombinations.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final comb = allCombinations[index];
                        final key = '${comb.sph}_${comb.cyl}_${comb.eye}';
                        
                        return Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                'SPH: ${comb.sph} | CYL: ${comb.cyl} | EYE: ${comb.eye}',
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                            if (widget.isStockMatrix)
                              Expanded(
                                flex: 2,
                                child: Text('Barcode: ${comb.barcode}'),
                              ),
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                  initialValue: widget.isStockMatrix
                                      ? comb.initStock.toString()
                                      : comb.alertQty.toString(),
                                decoration: const InputDecoration(
                                  labelText: 'Qty',
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (val) {
                                  _qtyEdits[key] = val;
                                },
                              ),
                            )
                          ],
                        );
                      },
                    ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    // Pass the edits back to the caller
                    Navigator.of(context).pop(_qtyEdits);
                  },
                  child: const Text('Save Matrix'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
