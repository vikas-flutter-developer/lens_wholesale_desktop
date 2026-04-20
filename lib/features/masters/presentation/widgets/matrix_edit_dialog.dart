import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:file_picker/file_picker.dart' as file_picker;
import 'package:excel/excel.dart' as excel;
import '../../data/models/lens_group_model.dart';

enum MatrixEditMode { alert, stock }

class MatrixEditDialog extends StatefulWidget {
  final List<LensAddGroup> addGroups;
  final List<LensPowerGroup> powerGroups;
  final MatrixEditMode mode;
  final String initialEye;
  final Function(Map<String, String> editedValues) onSave;

  const MatrixEditDialog({
    super.key,
    required this.addGroups,
    required this.powerGroups,
    required this.mode,
    required this.initialEye,
    required this.onSave,
  });

  @override
  State<MatrixEditDialog> createState() => _MatrixEditDialogState();
}

class _MatrixEditDialogState extends State<MatrixEditDialog> {
  late List<LensPowerGroup> _selectedPowerGroups;
  late List<LensPowerGroup> _appliedPowerGroups;
  late String _eyeMode;
  final Map<String, String> _editedValues = {};
  final TextEditingController _bulkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _eyeMode = (widget.initialEye == 'R' || widget.initialEye == 'L') ? widget.initialEye : 'RL';
    _selectedPowerGroups = List.from(widget.powerGroups);
    _appliedPowerGroups = List.from(widget.powerGroups);
  }

  @override
  void dispose() {
    _bulkController.dispose();
    super.dispose();
  }

  // --- Logic ---

  bool _matchesAnyPowerGroup(double sph, double cyl, double add) {
    if (_appliedPowerGroups.isEmpty) return true;
    for (var pg in _appliedPowerGroups) {
      final sMin = double.tryParse(pg.sphMin ?? '');
      final sMax = double.tryParse(pg.sphMax ?? '');
      final cMin = double.tryParse(pg.cylMin ?? '');
      final cMax = double.tryParse(pg.cylMax ?? '');
      final aMin = double.tryParse(pg.addMin ?? '');
      final aMax = double.tryParse(pg.addMax ?? '');

      bool sphOk = (sMin != null && sMax != null) 
          ? (sph >= sMin - 0.001 && sph <= sMax + 0.001) : true;
      bool cylOk = (cMin != null && cMax != null) 
          ? (cyl >= cMin - 0.001 && cyl <= cMax + 0.001) : true;
      bool addOk = (aMin != null && aMax != null) 
          ? (add >= aMin - 0.001 && add <= aMax + 0.001) : true;
      if (sphOk && cylOk && addOk) return true;
    }
    return false;
  }

  Map<String, dynamic> _getMatrixData() {
    final Set<double> sphSet = {};
    final Set<double> cylSet = {};
    final Set<double> addSet = {};
    final Set<String> rowKeys = {};

    final List<String> eyeFilter = _eyeMode == 'RL' ? ['R', 'L', 'RL', 'R/L'] : [_eyeMode];

    for (var group in widget.addGroups) {
      final addVal = double.tryParse(group.addValue ?? '') ?? 0.0;
      for (var c in group.combinations) {
        final cEye = (c.eye).toUpperCase();
        if (!eyeFilter.contains(cEye) && _eyeMode != 'RL') continue;

        final s = double.tryParse(c.sph) ?? 0.0;
        final cv = double.tryParse(c.cyl) ?? 0.0;

        if (_matchesAnyPowerGroup(s, cv, addVal)) {
          sphSet.add(s);
          cylSet.add(cv);
          addSet.add(addVal);
          rowKeys.add('${s.toStringAsFixed(2)}_${cv.toStringAsFixed(2)}_${c.axis.isEmpty ? '0' : c.axis}');
        }
      }
    }

    final sphList = sphSet.toList()..sort();
    final cylList = cylSet.toList()..sort();
    final addList = addSet.toList()..sort();

    final List<Map<String, dynamic>> rows = [];
    for (var s in sphList) {
      for (var c in cylList) {
        final prefix = '${s.toStringAsFixed(2)}_${c.toStringAsFixed(2)}_';
        final relevantKeys = rowKeys.where((k) => k.startsWith(prefix)).toList();
        for (var k in relevantKeys) {
           final axis = k.split('_').last;
           rows.add({
             'sph': s.toStringAsFixed(2),
             'cyl': c.toStringAsFixed(2),
             'axis': axis,
           });
        }
      }
    }

    return {
      'rows': rows,
      'columns': addList.map((a) => a.toStringAsFixed(2)).toList(),
    };
  }

  LensCombination? _findCombination(String sph, String cyl, String add, String axis) {
    final double sVal = double.tryParse(sph) ?? 0.0;
    final double cVal = double.tryParse(cyl) ?? 0.0;
    final double aVal = double.tryParse(add) ?? 0.0;

    try {
      final group = widget.addGroups.firstWhere(
        (g) => ((double.tryParse(g.addValue ?? '') ?? 0.0) - aVal).abs() < 0.01,
      );

      for (var c in group.combinations) {
        final matchesSph = ((double.tryParse(c.sph) ?? 0.0) - sVal).abs() < 0.01;
        final matchesCyl = ((double.tryParse(c.cyl) ?? 0.0) - cVal).abs() < 0.01;
        final matchesAxis = (c.axis.isEmpty ? '0' : c.axis) == axis;
        
        if (matchesSph && matchesCyl && matchesAxis) {
          final cEye = (c.eye).toUpperCase();
          if (_eyeMode == 'RL') return c;
          if (cEye == _eyeMode || cEye == 'RL' || cEye == 'R/L') return c;
        }
      }
    } catch (_) {}
    return null;
  }

  String _getComboKey(LensCombination combo) {
    if (combo.id != null) return combo.id!;
    // Fallback key
    return '${combo.sph}_${combo.cyl}_${combo.add}_${combo.eye}_${combo.axis.isEmpty ? '0' : combo.axis}';
  }

  String _getCellValue(LensCombination combo) {
    final key = _getComboKey(combo);
    if (_editedValues.containsKey(key)) return _editedValues[key]!;
    return widget.mode == MatrixEditMode.alert 
        ? combo.alertQty.toString()
        : combo.initStock.toString();
  }

  void _handleBulkApply(List<Map<String, dynamic>> rows, List<String> columns) {
    if (_bulkController.text.isEmpty) return;
    
    setState(() {
      for (var row in rows) {
        for (var add in columns) {
          final combo = _findCombination(row['sph'], row['cyl'], add, row['axis']);
          if (combo != null) {
            _editedValues[_getComboKey(combo)] = _bulkController.text;
          }
        }
      }
    });
  }

  void _handleCopyColToAll(String add, List<Map<String, dynamic>> rows) {
    if (rows.isEmpty) return;
    
    String? sourceValue;
    
    // Find the first valid value going down the column
    for (var row in rows) {
      final combo = _findCombination(row['sph'], row['cyl'], add, row['axis']);
      if (combo != null) {
        final val = _getCellValue(combo);
        if (val.isNotEmpty && val != '-') {
          sourceValue = val;
          break;
        }
      }
    }

    if (sourceValue == null) return;

    setState(() {
      for (var row in rows) {
        final combo = _findCombination(row['sph'], row['cyl'], add, row['axis']);
        if (combo != null) {
          _editedValues[_getComboKey(combo)] = sourceValue!;
        }
      }
    });
  }

  // --- UI Components ---

  @override
  Widget build(BuildContext context) {
    final data = _getMatrixData();
    final rows = data['rows'] as List<Map<String, dynamic>>;
    final columns = data['columns'] as List<String>;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              _buildHeader(),
              _buildFilterBar(rows, columns),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: _buildMatrixTable(rows, columns),
                ),
              ),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      color: const Color(0xFF0F172A),
      child: Row(
        children: [
          Icon(
            widget.mode == MatrixEditMode.alert ? LucideIcons.layoutGrid : LucideIcons.grid,
            color: const Color(0xFF60A5FA),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.mode == MatrixEditMode.alert ? 'Alert Quantity Matrix' : 'Stock Quantity Matrix',
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text(
                widget.mode == MatrixEditMode.alert 
                    ? 'Bulk update Alert Quantities across ADD Groups'
                    : 'Bulk update Stock Quantities across ADD Groups',
                style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(LucideIcons.x, color: Colors.white),
            hoverColor: Colors.white.withOpacity(0.1),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(List<Map<String, dynamic>> rows, List<String> columns) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: const Color(0xFFF8FAFC),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Power Group Multi-select
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'POWER GROUP  ${_selectedPowerGroups.length} SELECTED',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF64748B), letterSpacing: 0.5),
                    ),
                    const SizedBox(height: 8),
                    _buildPGDropdown(),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Show Button
              _buildActionButton(
                label: 'Show',
                icon: LucideIcons.search,
                color: const Color(0xFF2563EB),
                onPressed: () => setState(() => _appliedPowerGroups = List.from(_selectedPowerGroups)),
              ),
              const SizedBox(width: 16),
              if (widget.mode == MatrixEditMode.alert)
                _buildBulkApplySection(rows, columns)
              else
                _buildImportExcelSection(),
            ],
          ),
          const SizedBox(height: 16),
          // Eye Selector & Applied Ranges
          Row(
            children: [
              const Text('SELECTED EYE:  ', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF64748B))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(_eyeMode, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _appliedPowerGroups.map<Widget>((pg) => _buildRangeChip(pg)).toList(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPGDropdown() {
    return PopupMenuButton<LensPowerGroup>(
      offset: const Offset(0, 48),
      tooltip: 'Filter by Power Group',
      itemBuilder: (context) {
        return widget.powerGroups.map<PopupMenuEntry<LensPowerGroup>>((pg) {
          final isChecked = _selectedPowerGroups.contains(pg);
          return PopupMenuItem<LensPowerGroup>(
            enabled: false,
            child: StatefulBuilder(
              builder: (context, setPopupState) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      if (isChecked) {
                        _selectedPowerGroups.remove(pg);
                      } else {
                        _selectedPowerGroups.add(pg);
                      }
                    });
                    setPopupState(() {});
                  },
                  child: Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (val) {
                          setState(() {
                            if (val!) {
                              _selectedPowerGroups.add(pg);
                            } else {
                              _selectedPowerGroups.remove(pg);
                            }
                          });
                          setPopupState(() {});
                        },
                        activeColor: const Color(0xFF2563EB),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      Expanded(
                        child: Text(
                          pg.label ?? 'Range ${widget.powerGroups.indexOf(pg) + 1}',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _selectedPowerGroups.isEmpty 
                    ? 'Select power ranges...' 
                    : '${_selectedPowerGroups.length} range(s) selected',
                style: TextStyle(
                  color: _selectedPowerGroups.isEmpty ? Colors.grey : const Color(0xFF334155),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(LucideIcons.chevronDown, size: 16, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }

  Widget _buildBulkApplySection(List<Map<String, dynamic>> rows, List<String> columns) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(left: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      padding: const EdgeInsets.only(left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('APPLY TO ALL', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Color(0xFF94A3B8))),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                width: 80,
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                ),
                child: TextField(
                  controller: _bulkController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(hintText: 'Val', border: InputBorder.none, isDense: true),
                  onSubmitted: (_) => _handleBulkApply(rows, columns),
                ),
              ),
              GestureDetector(
                onTap: () => _handleBulkApply(rows, columns),
                child: Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E293B),
                    borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
                  ),
                  alignment: Alignment.center,
                  child: const Text('APPLY', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _handleExcelImport() async {
    try {
      final result = await file_picker.FilePicker.pickFiles(
        type: file_picker.FileType.custom,
        allowedExtensions: ['xlsx', 'xls', 'csv'],
        allowMultiple: false,
      );

      if (result == null || result.files.single.path == null) return;

      final fileBytes = io.File(result.files.single.path!).readAsBytesSync();
      final excelFile = excel.Excel.decodeBytes(fileBytes);
      final sheetName = excelFile.tables.keys.first;
      final sheet = excelFile.tables[sheetName];

      if (sheet == null) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid Excel format.'), backgroundColor: Colors.red));
        return;
      }

      int headerRowIdx = -1;
      Map<int, String> headerMap = {};

      // 1. Detect headers
      for (int i = 0; i < sheet.maxRows && i < 20; i++) {
        final row = sheet.rows[i];
        final normalised = row.map((c) => c?.value?.toString().toUpperCase().trim().replaceAll(RegExp(r'[\s\.]'), '') ?? '').toList();
        
        if (normalised.any((c) => c == 'SPH')) {
          headerRowIdx = i;
          for (int idx = 0; idx < normalised.length; idx++) {
            final col = normalised[idx];
            if (col == 'SPH') headerMap[idx] = 'SPH';
            else if (col == 'CYL') headerMap[idx] = 'CYL';
            else if (col.startsWith('AXI') || col == 'AXIS') headerMap[idx] = 'AXIS';
            else if (col == 'ADD') headerMap[idx] = 'ADD';
            else if (col == 'EYE') headerMap[idx] = 'EYE';
            else if (col.contains('QTY') || col.contains('QUANTITY') || col.contains('STOCK')) headerMap[idx] = 'QTY';
            else if (col.contains('BARCODE') || col.contains('CODE')) headerMap[idx] = 'BARCODE';
            else {
              final match = RegExp(r'ADD([+-]?\d+)').firstMatch(col);
              if (match != null) {
                final addVal = (double.parse(match.group(1)!) / 100).toStringAsFixed(2);
                headerMap[idx] = 'ADD_$addVal';
              }
            }
          }
          break;
        }
      }

      if (headerRowIdx == -1) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cannot find column headers. Ensure the file has an SPH column.', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red));
        return;
      }

      int importsCount = 0;
      int skippedCount = 0;

      // 2. Process data
      for (int i = headerRowIdx + 1; i < sheet.maxRows; i++) {
        final row = sheet.rows[i];
        if (row.where((c) => c != null && c.value != null && c.value.toString().trim().isNotEmpty).isEmpty) continue;

        String? getField(String field) {
          final entry = headerMap.entries.where((e) => e.value == field).firstOrNull;
          if (entry != null && entry.key < row.length) {
            return row[entry.key]?.value?.toString();
          }
          return null;
        }

        bool processCombo(double sph, double cyl, double add, double axis, dynamic qtyRaw) {
          if (qtyRaw == null) return false;
          final qtyStr = qtyRaw.toString();
          final qty = double.tryParse(qtyStr);
          if (qty == null) return false;

          LensAddGroup? exactGroup = widget.addGroups.where((g) => (double.tryParse(g.addValue ?? '') ?? 0) == add).firstOrNull;
          List<LensAddGroup> targetGroups = exactGroup != null ? [exactGroup] : (add == 0.0 ? widget.addGroups : []);
          
          if (targetGroups.isEmpty) return false;
          bool matched = false;

          for (var group in targetGroups) {
            for (var combo in group.combinations) {
              final dbSph = double.tryParse(combo.sph) ?? 0.0;
              final dbCyl = double.tryParse(combo.cyl) ?? 0.0;
              final dbAxis = double.tryParse(combo.axis) ?? 0.0;

              bool matchesSph = (dbSph - sph).abs() < 0.01;
              bool matchesCyl = (dbCyl - cyl).abs() < 0.01;
              bool matchesAxis = (axis == 0) ? true : (dbAxis - axis).abs() < 1;

              if (matchesSph && matchesCyl && matchesAxis) {
                final cEye = combo.eye.toUpperCase().replaceAll(RegExp(r'[\/\s]'), '');
                final modeNorm = _eyeMode.replaceAll(RegExp(r'[\/\s]'), '');
                if (_eyeMode == 'RL' || cEye == modeNorm || cEye == 'RL' || cEye == 'R/L' || cEye == '' || cEye == 'BOTH') {
                  final key = _getComboKey(combo);
                  setState(() => _editedValues[key] = qtyStr);
                  matched = true;
                }
              }
            }
          }
          return matched;
        }

        final sphStr = getField('SPH');
        final cylStr = getField('CYL');
        final sph = double.tryParse(sphStr ?? '') ?? double.nan;
        final cyl = double.tryParse(cylStr ?? '') ?? double.nan;
        final axis = double.tryParse(getField('AXIS') ?? '') ?? 0.0;

        if (sph.isNaN || cyl.isNaN) {
          skippedCount++;
          continue;
        }

        final matrixAddCols = headerMap.entries.where((e) => e.value.startsWith('ADD_')).toList();
        
        if (matrixAddCols.isNotEmpty) {
          for (var e in matrixAddCols) {
            final addVal = double.tryParse(e.value.replaceAll('ADD_', '')) ?? 0.0;
            final qtyRaw = row.length > e.key ? row[e.key]?.value : null;
            if (processCombo(sph, cyl, addVal, axis, qtyRaw)) importsCount++;
            else if (qtyRaw != null && qtyRaw.toString().trim().isNotEmpty) skippedCount++;
          }
        } else {
          final add = double.tryParse(getField('ADD') ?? '') ?? 0.0;
          final qtyRaw = getField('QTY');
          if (qtyRaw != null && qtyRaw.trim().isNotEmpty) {
            if (processCombo(sph, cyl, add, axis, qtyRaw)) importsCount++;
            else skippedCount++;
          }
        }
      }

      if (mounted) {
        if (importsCount > 0) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Imported $importsCount matched combinations.' + (skippedCount > 0 ? ' ($skippedCount rows skipped or unmapped)' : '')), backgroundColor: Colors.green));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No combinations matched! $skippedCount rows checked. Verify SPH/CYL match your matrix.'), backgroundColor: Colors.orange));
        }
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to read Excel file! Error: $e'), backgroundColor: Colors.red));
    }
  }

  Widget _buildImportExcelSection() {
    return Container(
      padding: const EdgeInsets.only(left: 16),
      child: ElevatedButton.icon(
        onPressed: _handleExcelImport,
        icon: const Icon(LucideIcons.upload, size: 16),
        label: const Text('Import Excel', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E293B),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildRangeChip(LensPowerGroup pg) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFDBEAFE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        pg.label ?? 'Range',
        style: const TextStyle(color: Color(0xFF2563EB), fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildMatrixTable(List<Map<String, dynamic>> rows, List<String> columns) {
    if (rows.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.filter, size: 48, color: Colors.grey.withOpacity(0.3)),
            const SizedBox(height: 16),
            const Text('Select power groups and click Show to load the matrix', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Scrollbar(
            notificationPredicate: (n) => n.depth == 1,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(const Color(0xFFF8FAFC)),
                dataRowMaxHeight: widget.mode == MatrixEditMode.stock ? 70 : 52,
                columnSpacing: 0,
                horizontalMargin: 0,
                border: const TableBorder(
                  horizontalInside: BorderSide(color: Color(0xFFE2E8F0)),
                  verticalInside: BorderSide(color: Color(0xFFE2E8F0)),
                ),
                columns: [
                   _buildDataColumn('SPH', width: 80),
                   _buildDataColumn('CYL', width: 80),
                   _buildDataColumn('AXIS', width: 80),
                   ...columns.map((add) => DataColumn(
                     label: Container(
                       width: 140,
                       alignment: Alignment.center,
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Text(add, style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF334155))),
                           const SizedBox(width: 8),
                           InkWell(
                             onTap: () => _handleCopyColToAll(add, rows),
                             child: const Icon(LucideIcons.copy, size: 14, color: Color(0xFF3B82F6)),
                           ),
                         ],
                       ),
                     ),
                   )),
                ],
                rows: rows.map((row) {
                  return DataRow(
                    cells: [
                      _buildDataCell(row['sph'], width: 80, isHeader: true),
                      _buildDataCell(row['cyl'], width: 80, isHeader: true),
                      _buildDataCell(row['axis'], width: 80, isHeader: false, textColor: const Color(0xFF64748B)),
                      ...columns.map((add) {
                        final combo = _findCombination(row['sph'], row['cyl'], add, row['axis']);
                        if (combo == null) {
                          return DataCell(
                            Container(
                              width: 140,
                              alignment: Alignment.center,
                              child: const Text('-', style: TextStyle(color: Color(0xFFCBD5E1))),
                            ),
                          );
                        }
                        
                        return DataCell(
                          MatrixCell(
                            key: ValueKey(_getComboKey(combo)),
                            initialValue: _getCellValue(combo),
                            barcode: widget.mode == MatrixEditMode.stock ? combo.barcode : null,
                            isEdited: _editedValues.containsKey(_getComboKey(combo)),
                            onChanged: (val) {
                              setState(() {
                                _editedValues[_getComboKey(combo)] = val;
                              });
                            },
                          ),
                        );
                      }),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  DataColumn _buildDataColumn(String label, {required double width}) {
    return DataColumn(
      label: Container(
        width: width,
        alignment: Alignment.center,
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF334155))),
      ),
    );
  }

  DataCell _buildDataCell(String text, {required double width, bool isHeader = false, Color? textColor}) {
    return DataCell(
      Container(
        width: width,
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontWeight: isHeader ? FontWeight.bold : FontWeight.w500,
            color: textColor ?? const Color(0xFF1E293B),
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Row(
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${_editedValues.length} ',
                  style: const TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const TextSpan(
                  text: 'combinations modified',
                  style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                ),
              ],
            ),
          ),
          const Spacer(),
          _buildActionButton(
            label: 'Reset',
            icon: LucideIcons.rotateCcw,
            color: const Color(0xFF64748B),
            isOutline: true,
            onPressed: () => setState(() => _editedValues.clear()),
          ),
          const SizedBox(width: 16),
          _buildActionButton(
            label: 'Save Changes',
            icon: LucideIcons.save,
            color: const Color(0xFF2563EB),
            onPressed: _editedValues.isEmpty ? () {} : () {
              widget.onSave(_editedValues);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label, 
    required IconData icon, 
    required Color color, 
    bool isOutline = false,
    required VoidCallback onPressed
  }) {
    if (isOutline) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: const BorderSide(color: Color(0xFFE2E8F0)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
      ),
    );
  }
}

class MatrixCell extends StatefulWidget {
  final String initialValue;
  final bool isEdited;
  final ValueChanged<String> onChanged;
  final String? barcode;

  const MatrixCell({
    super.key,
    required this.initialValue,
    required this.isEdited,
    required this.onChanged,
    this.barcode,
  });

  @override
  State<MatrixCell> createState() => _MatrixCellState();
}

class _MatrixCellState extends State<MatrixCell> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.selection = TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
      }
    });
  }

  @override
  void didUpdateWidget(MatrixCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue && widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 32,
            margin: EdgeInsets.only(bottom: (widget.barcode != null && widget.barcode!.isNotEmpty) ? 6 : 0),
            decoration: BoxDecoration(
              color: widget.isEdited ? const Color(0xFFEFF6FF) : const Color(0xFFF8FAFC),
              border: Border.all(color: widget.isEdited ? const Color(0xFF3B82F6) : const Color(0xFFE2E8F0)),
              borderRadius: BorderRadius.circular(6),
            ),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: widget.isEdited ? const Color(0xFF2563EB) : const Color(0xFF1E293B),
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(bottom: 12),
                isDense: true,
              ),
              onChanged: widget.onChanged,
            ),
          ),
          if (widget.barcode != null && widget.barcode!.isNotEmpty)
            Text(
              widget.barcode!,
              style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5),
            ),
        ],
      ),
    );
  }
}
