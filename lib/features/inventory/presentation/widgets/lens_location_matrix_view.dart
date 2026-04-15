import 'package:flutter/material.dart';
import '../../../masters/data/models/lens_group_model.dart';
import '../../data/models/lens_location_model.dart';
import 'package:lucide_icons/lucide_icons.dart';

class LensLocationMatrixView extends StatefulWidget {
  final LensGroupModel lensGroup;
  final LensLocationModel activeLocation;
  final Function(LensGroupModel) onSave;

  const LensLocationMatrixView({
    super.key,
    required this.lensGroup,
    required this.activeLocation,
    required this.onSave,
  });

  @override
  State<LensLocationMatrixView> createState() => _LensLocationMatrixViewState();
}

class _LensLocationMatrixViewState extends State<LensLocationMatrixView> {
  late LensGroupModel _draftLens;
  final Set<String> _modifiedKeys = {};

  @override
  void initState() {
    super.initState();
    _draftLens = widget.lensGroup;
  }

  @override
  void didUpdateWidget(LensLocationMatrixView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lensGroup != widget.lensGroup) {
      setState(() {
        _draftLens = widget.lensGroup;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final sphValues = _extractUniqueSph();
    final cylValues = _extractUniqueCyl();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const Text(
                "ASSIGN LOCATION MATRIX",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const Spacer(),
              const Text(
                "Click a cell to assign current location",
                style: TextStyle(fontSize: 10, color: Colors.grey, fontStyle: FontStyle.italic),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: _modifiedKeys.isEmpty ? null : () => widget.onSave(_draftLens),
                icon: const Icon(LucideIcons.save, size: 16),
                label: const Text("Save Mapping"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Table(
                  defaultColumnWidth: const FixedColumnWidth(140),
                  border: TableBorder.all(color: Colors.grey.shade200),
                  children: [
                    // Header Row
                    TableRow(
                      decoration: const BoxDecoration(color: Color(0xFF0F172A)),
                      children: [
                        const TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Text("CYL / SPH", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                          ),
                        ),
                        ...sphValues.map((sph) => TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(sph, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                          ),
                        )),
                      ],
                    ),
                    // Data Rows
                    ...cylValues.map((cyl) => TableRow(
                      children: [
                        TableCell(
                          child: Container(
                            color: Colors.grey.shade50,
                            padding: const EdgeInsets.all(12),
                            child: Text(cyl, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                          ),
                        ),
                        ...sphValues.map((sph) {
                          final comb = _findCombination(sph, cyl);
                          return TableCell(
                            child: _buildLocationCell(sph, cyl, comb),
                          );
                        }),
                      ],
                    )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationCell(String sph, String cyl, LensCombination? comb) {
    if (comb == null) {
      return Container(
        height: 80,
        color: Colors.grey.shade100,
        child: const Center(child: Text("—", style: TextStyle(color: Colors.grey))),
      );
    }

    final hasLocations = comb.locations.isNotEmpty;
    
    return InkWell(
      onTap: () => _toggleLocation(comb),
      child: Container(
        height: 80,
        padding: const EdgeInsets.all(8),
        color: hasLocations ? Colors.blue.withOpacity(0.05) : Colors.transparent,
        child: Column(
          children: [
            if (hasLocations)
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: comb.locations.length,
                  itemBuilder: (context, index) {
                    final loc = comb.locations[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Row(
                        children: [
                          const Icon(LucideIcons.mapPin, size: 8, color: Colors.blue),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              "${loc.godown}/${loc.rack}/${loc.box}",
                              style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(LucideIcons.x, size: 8, color: Colors.red),
                            onPressed: () => _removeLocation(comb, index),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            else
              const Center(
                child: Icon(LucideIcons.plus, size: 12, color: Colors.grey),
              ),
            const Divider(height: 8),
            SizedBox(
              height: 20,
              child: TextFormField(
                initialValue: comb.locationQty,
                style: const TextStyle(fontSize: 9),
                decoration: const InputDecoration(
                  hintText: "Qty",
                  isDense: true,
                  border: InputBorder.none,
                ),
                onChanged: (val) {
                  _updateQty(comb, val);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Methods
  List<String> _extractUniqueSph() {
    final sphs = _draftLens.addGroups
        .flatMap((g) => g.combinations.map((c) => c.sph))
        .toSet()
        .toList();
    sphs.sort((a, b) => double.parse(a).compareTo(double.parse(b)));
    return sphs;
  }

  List<String> _extractUniqueCyl() {
    final cyls = _draftLens.addGroups
        .flatMap((g) => g.combinations.map((c) => c.cyl))
        .toSet()
        .toList();
    cyls.sort((a, b) => double.parse(a).compareTo(double.parse(b)));
    return cyls;
  }

  LensCombination? _findCombination(String sph, String cyl) {
    for (var ag in _draftLens.addGroups) {
      for (var comb in ag.combinations) {
        if (comb.sph == sph && comb.cyl == cyl) return comb;
      }
    }
    return null;
  }

  void _toggleLocation(LensCombination comb) {
    final isDuplicate = comb.locations.any((l) =>
        l.godown == widget.activeLocation.godown &&
        l.rack == widget.activeLocation.rack &&
        l.box == widget.activeLocation.box);

    if (isDuplicate) return;

    final updatedComb = comb.copyWith(
      locations: [...comb.locations, widget.activeLocation],
    );

    _updateDraft(updatedComb);
  }

  void _removeLocation(LensCombination comb, int index) {
    final updatedLocs = [...comb.locations]..removeAt(index);
    final updatedComb = comb.copyWith(locations: updatedLocs);
    _updateDraft(updatedComb);
  }

  void _updateQty(LensCombination comb, String qty) {
     final updatedComb = comb.copyWith(locationQty: qty);
     _updateDraft(updatedComb);
  }

  void _updateDraft(LensCombination updatedComb) {
    setState(() {
      _draftLens = _draftLens.copyWith(
        addGroups: _draftLens.addGroups.map((ag) {
          return ag.copyWith(
            combinations: ag.combinations.map((c) {
              return c.id == updatedComb.id || (c.sph == updatedComb.sph && c.cyl == updatedComb.cyl && c.eye == updatedComb.eye && c.add == updatedComb.add)
                  ? updatedComb
                  : c;
            }).toList(),
          );
        }).toList(),
      );
      _modifiedKeys.add("${updatedComb.sph}_${updatedComb.cyl}");
    });
  }
}

extension IterableExtension<T> on Iterable<T> {
  Iterable<R> flatMap<R>(Iterable<R> Function(T) f) => expand(f);
}
