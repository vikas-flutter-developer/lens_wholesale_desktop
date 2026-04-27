import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../masters/data/models/lens_group_model.dart';
import '../../data/models/lens_location_model.dart';

class LensLocationMatrixView extends StatelessWidget {
  final LensGroupModel lensData;
  final Map<String, dynamic> matrixData;
  final Map<String, List<LensLocationModel>> locationMap;
  final Map<String, String> locationQtyMap;
  final Map<String, String> filters;
  final LensLocationModel activeLocation;
  final Function(String, LensLocationModel) onLocationAdd;
  final Function(String, int) onLocationRemove;
  final Function(String, String) onQtyChange;

  const LensLocationMatrixView({
    super.key,
    required this.lensData,
    required this.matrixData,
    required this.locationMap,
    required this.locationQtyMap,
    required this.filters,
    required this.activeLocation,
    required this.onLocationAdd,
    required this.onLocationRemove,
    required this.onQtyChange,
  });

  @override
  Widget build(BuildContext context) {
    final matrix = _constructMatrix();
    if (matrix.rows.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Text("No data matching filters.", style: TextStyle(color: Colors.grey, fontSize: 16)),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Table(
            defaultColumnWidth: const IntrinsicColumnWidth(),
            border: TableBorder.all(color: const Color(0xFFF1F5F9), width: 1),
            children: [
              _buildHeader(matrix.addValues),
              ...matrix.rows.map((row) => _buildRow(row, matrix.addValues)),
              _buildTotalRow(matrix),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildHeader(List<double> addValues) {
    return TableRow(
      decoration: const BoxDecoration(color: Color(0xFFF8FAFC)),
      children: [
        _headerCell("SPH", width: 100),
        _headerCell("CYL", width: 100),
        _headerCell("Eye", width: 80),
        ...addValues.expand((add) => [
              _headerCell("+${add.toStringAsFixed(2)}", color: Colors.blue.shade700, bgColor: const Color(0xFFEFF6FF), width: 100),
              _headerCell("Qty", color: const Color(0xFFB45309), bgColor: const Color(0xFFFFFBEB), width: 100),
              _headerCell("G/R/B", color: const Color(0xFF64748B), bgColor: const Color(0xFFF1F5F9), width: 150),
            ]),
        _headerCell("Row Total", color: const Color(0xFF047857), bgColor: const Color(0xFFECFDF5), width: 100),
      ],
    );
  }

  Widget _headerCell(String text, {Color? color, Color? bgColor, double? width}) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      color: bgColor,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, color: color ?? const Color(0xFF475569)),
      ),
    );
  }

  TableRow _buildRow(MatrixRow row, List<double> addValues) {
    return TableRow(
      children: [
        _dataCell(row.sph.toStringAsFixed(2), isBold: true),
        _dataCell(row.cyl.toStringAsFixed(2), isBold: true),
        _dataCell(row.eye, color: const Color(0xFF64748B)),
        ...addValues.expand((add) {
          final cellKey = "${row.sph.toStringAsFixed(2)}_${row.cyl.toStringAsFixed(2)}_${row.eye}_${add.toStringAsFixed(2)}";
          return [
            _qtyDisplayCell(matrixData[cellKey] ?? 0),
            _qtyInputCell(cellKey),
            _locationCell(cellKey),
          ];
        }),
        _dataCell(_calculateRowTotal(row, addValues).toString(), color: const Color(0xFF047857), isBold: true, bgColor: const Color(0xFFF0FDF4)),
      ],
    );
  }

  Widget _dataCell(String text, {Color? color, bool isBold = false, Color? bgColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      color: bgColor,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: color ?? const Color(0xFF1E293B),
        ),
      ),
    );
  }

  Widget _qtyDisplayCell(dynamic qty) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFF1F5F9)),
        ),
        child: Text(
          qty.toString(),
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _qtyInputCell(String key) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: TextField(
        controller: TextEditingController(text: locationQtyMap[key] ?? "")..selection = TextSelection.collapsed(offset: (locationQtyMap[key] ?? "").length),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: "Qty...",
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
        ),
        style: const TextStyle(fontSize: 13),
        onChanged: (val) => onQtyChange(key, val),
      ),
    );
  }

  Widget _locationCell(String key) {
    final locs = locationMap[key] ?? [];
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          ...locs.asMap().entries.map((entry) {
            final loc = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 4),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${loc.godown}/${loc.rack}/${loc.box}",
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: () => onLocationRemove(key, entry.key),
                    child: const Icon(LucideIcons.x, size: 12, color: Colors.red),
                  ),
                ],
              ),
            );
          }),
          InkWell(
            onTap: () => onLocationAdd(key, activeLocation),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: const Icon(LucideIcons.plus, size: 12, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  TableRow _buildTotalRow(MatrixData matrix) {
    return TableRow(
      decoration: const BoxDecoration(color: Color(0xFF334155)),
      children: [
        _footerCell("COLUMN TOTALS", span: 3),
        const SizedBox(), // Spacer for CYL
        const SizedBox(), // Spacer for Eye
        ...matrix.addValues.expand((add) => [
              _footerCell(_calculateColTotal(matrix, add).toString(), span: 3),
              const SizedBox(), // Spacer for Input
              const SizedBox(), // Spacer for G/R/B
            ]),
        _footerCell(_calculateGrandTotal(matrix).toString(), color: Colors.white, isBold: true),
      ],
    );
  }

  Widget _footerCell(String text, {int span = 1, Color? color, bool isBold = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: color ?? Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }

  // Matrix Logic
  MatrixData _constructMatrix() {
    final List<CombinationWithAdd> sourceRows = [];
    for (var ag in lensData.addGroups) {
      final addValue = double.tryParse(ag.addValue ?? "0") ?? 0.0;
      for (var comb in ag.combinations) {
        if (_passesFilters(comb, addValue)) {
          sourceRows.add(CombinationWithAdd(comb: comb, addValue: addValue));
        }
      }
    }

    final addValues = sourceRows.map((r) => r.addValue).toSet().toList()..sort();
    
    final Map<String, MatrixRow> rowMap = {};
    for (var r in sourceRows) {
        final sph = double.tryParse(r.comb.sph) ?? 0.0;
        final cyl = double.tryParse(r.comb.cyl) ?? 0.0;
        final eye = r.comb.eye;
        final key = "${sph}_${cyl}_$eye";
        if (!rowMap.containsKey(key)) {
            rowMap[key] = MatrixRow(sph: sph, cyl: cyl, eye: eye);
        }
    }

    final rows = rowMap.values.toList()..sort((a, b) {
        if (a.sph != b.sph) return a.sph.compareTo(b.sph);
        if (a.cyl != b.cyl) return a.cyl.compareTo(b.cyl);
        return a.eye.compareTo(b.eye);
    });

    return MatrixData(addValues: addValues, rows: rows);
  }

  bool _passesFilters(LensCombination comb, double addValue) {
    final sph = double.tryParse(comb.sph) ?? 0.0;
    final cyl = double.tryParse(comb.cyl) ?? 0.0;

    final sMin = double.tryParse(filters["sphMin"] ?? "") ?? -double.infinity;
    final sMax = double.tryParse(filters["sphMax"] ?? "") ?? double.infinity;
    if (sph < sMin || sph > sMax) return false;

    final cMin = double.tryParse(filters["cylMin"] ?? "") ?? -double.infinity;
    final cMax = double.tryParse(filters["cylMax"] ?? "") ?? double.infinity;
    if (cyl < cMin || cyl > cMax) return false;

    final aMin = double.tryParse(filters["addMin"] ?? "") ?? -double.infinity;
    final aMax = double.tryParse(filters["addMax"] ?? "") ?? double.infinity;
    if (addValue < aMin || addValue > aMax) return false;

    return true;
  }

  int _calculateRowTotal(MatrixRow row, List<double> addValues) {
    int total = 0;
    for (var add in addValues) {
      final key = "${row.sph.toStringAsFixed(2)}_${row.cyl.toStringAsFixed(2)}_${row.eye}_${add.toStringAsFixed(2)}";
      total += (matrixData[key] ?? 0) as int;
    }
    return total;
  }

  int _calculateColTotal(MatrixData matrix, double add) {
    int total = 0;
    for (var row in matrix.rows) {
      final key = "${row.sph.toStringAsFixed(2)}_${row.cyl.toStringAsFixed(2)}_${row.eye}_${add.toStringAsFixed(2)}";
      total += (matrixData[key] ?? 0) as int;
    }
    return total;
  }

  int _calculateGrandTotal(MatrixData matrix) {
    int total = 0;
    for (var add in matrix.addValues) {
      total += _calculateColTotal(matrix, add);
    }
    return total;
  }
}

class CombinationWithAdd {
  final LensCombination comb;
  final double addValue;
  CombinationWithAdd({required this.comb, required this.addValue});
}

class MatrixRow {
  final double sph;
  final double cyl;
  final String eye;
  MatrixRow({required this.sph, required this.cyl, required this.eye});
}

class MatrixData {
  final List<double> addValues;
  final List<MatrixRow> rows;
  MatrixData({required this.addValues, required this.rows});
}
