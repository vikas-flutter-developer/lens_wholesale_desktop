import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart' as xl;
import 'package:file_picker/file_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/network/loading_provider.dart';
import '../../../masters/data/providers/inventory_providers.dart';
import '../../../masters/data/models/lens_group_model.dart';
import '../../data/providers/inventory_report_provider.dart';

class LensSphCylWiseStockPage extends StatefulWidget {
  const LensSphCylWiseStockPage({super.key});

  @override
  State<LensSphCylWiseStockPage> createState() => _LensSphCylWiseStockPageState();
}

class _LensSphCylWiseStockPageState extends State<LensSphCylWiseStockPage> {
  final TextEditingController _groupController = TextEditingController();
  final TextEditingController _productController = TextEditingController();
  
  // Filter States
  final Map<String, TextEditingController> _rangeControllers = {
    'sphMin': TextEditingController(),
    'sphMax': TextEditingController(),
    'sphStep': TextEditingController(text: '0.25'),
    'cylMin': TextEditingController(),
    'cylMax': TextEditingController(),
    'cylStep': TextEditingController(text: '0.25'),
    'addMin': TextEditingController(),
    'addMax': TextEditingController(),
    'addStep': TextEditingController(text: '0.25'),
    'axis': TextEditingController(),
  };

  String _selectedEye = "";
  int? _activePowerGroupIdx;
  
  LensGroupModel? _lensData;
  bool _showDetails = false;
  bool _onlyAddView = false;
  bool _filtersApplied = false;
  List<FlattenedLensRow> _filteredRows = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ItemGroupProvider>().fetchGroups();
      context.read<ItemMasterProvider>().fetchItems();
    });
  }

  @override
  void dispose() {
    _groupController.dispose();
    _productController.dispose();
    _rangeControllers.values.forEach((c) => c.dispose());
    super.dispose();
  }

  // --- Logic Helpers ---

  int _customSequenceSort(dynamic a, dynamic b) {
    final double? numA = double.tryParse(a.toString());
    final double? numB = double.tryParse(b.toString());

    if (numA == null && numB == null) return 0;
    if (numA == null) return 1;
    if (numB == null) return -1;

    int getGroup(double n) {
      if (n == 0) return 0; // zero first
      if (n < 0) return 1; // negatives second
      return 2; // positives last
    }

    final int groupA = getGroup(numA);
    final int groupB = getGroup(numB);

    if (groupA != groupB) return groupA - groupB;

    // Within negatives: sort descending (closest to zero first)
    if (groupA == 1) return numB.compareTo(numA);

    // Within positives (and zero): sort ascending
    return numA.compareTo(numB);
  }

  Future<void> _handleShow() async {
    if (_showDetails) {
      setState(() => _showDetails = false);
      return;
    }

    if (_groupController.text.isEmpty && _productController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a Group or Item Name")),
      );
      return;
    }

    final provider = context.read<LensGroupProvider>();
    final data = await provider.getLensPower(
      groupName: _groupController.text,
      productName: _productController.text,
    );

    if (data == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No lens powers found for the given inputs.")),
      );
      setState(() {
        _lensData = null;
        _showDetails = false;
      });
      return;
    }

    setState(() {
      _lensData = data;
      _showDetails = true;
      // Auto-load ranges if available
      if (data.sphMin != null) _rangeControllers['sphMin']!.text = data.sphMin!;
      if (data.sphMax != null) _rangeControllers['sphMax']!.text = data.sphMax!;
      if (data.cylMin != null) _rangeControllers['cylMin']!.text = data.cylMin!;
      if (data.cylMax != null) _rangeControllers['cylMax']!.text = data.cylMax!;
      if (data.addMin != null) _rangeControllers['addMin']!.text = data.addMin!;
      if (data.addMax != null) _rangeControllers['addMax']!.text = data.addMax!;
      if (data.axis.isNotEmpty) _rangeControllers['axis']!.text = data.axis;
      _selectedEye = data.eye;

      // Auto-select if only one power group exists
      if (data.powerGroups.length == 1) {
        _activePowerGroupIdx = 0;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _onPowerGroupSelect(0);
        });
      }
    });

    _applyFilters();
  }

  void _applyFilters() {
    if (_lensData == null) return;

    final List<FlattenedLensRow> allRows = [];
    for (var ag in _lensData!.addGroups) {
      for (var comb in ag.combinations) {
        allRows.add(FlattenedLensRow(
          combination: comb,
          addValue: ag.addValue ?? '',
          groupId: ag.id ?? '',
        ));
      }
    }

    final double? sphMin = double.tryParse(_rangeControllers['sphMin']!.text);
    final double? sphMax = double.tryParse(_rangeControllers['sphMax']!.text);
    final double? cylMin = double.tryParse(_rangeControllers['cylMin']!.text);
    final double? cylMax = double.tryParse(_rangeControllers['cylMax']!.text);
    final double? addMin = double.tryParse(_rangeControllers['addMin']!.text);
    final double? addMax = double.tryParse(_rangeControllers['addMax']!.text);
    
    final double? sphStep = double.tryParse(_rangeControllers['sphStep']!.text);
    final double? cylStep = double.tryParse(_rangeControllers['cylStep']!.text);
    final double? addStep = double.tryParse(_rangeControllers['addStep']!.text);

    final String axisFilter = _rangeControllers['axis']!.text;
    final String eyeFilter = _selectedEye;

    final filtered = allRows.where((row) {
      final double sph = double.tryParse(row.combination.sph) ?? 0;
      final double cyl = double.tryParse(row.combination.cyl) ?? 0;
      final double add = double.tryParse(row.addValue) ?? 0;

      if (sphMin != null && sph < sphMin) return false;
      if (sphMax != null && sph > sphMax) return false;
      if (cylMin != null && cyl < cylMin) return false;
      if (cylMax != null && cyl > cylMax) return false;
      if (addMin != null && add < addMin) return false;
      if (addMax != null && add > addMax) return false;

      // Step logic
      if (sphStep != null && sphMin != null) {
        final diff = (sph - sphMin).abs();
        if (diff % sphStep > 0.01 && (diff % sphStep - sphStep).abs() > 0.01) return false;
      }
      if (cylStep != null && cylMin != null) {
        final diff = (cyl - cylMin).abs();
        if (diff % cylStep > 0.01 && (diff % cylStep - cylStep).abs() > 0.01) return false;
      }
      if (addStep != null && addMin != null) {
        final diff = (add - addMin).abs();
        if (diff % addStep > 0.01 && (diff % addStep - addStep).abs() > 0.01) return false;
      }

      if (axisFilter.isNotEmpty) {
        final String rowAxis = row.combination.axis.isEmpty ? _lensData!.axis : row.combination.axis;
        if (rowAxis != axisFilter) return false;
      }

      if (eyeFilter.isNotEmpty) {
        final String rowEye = row.combination.eye.isEmpty ? _lensData!.eye : row.combination.eye;
        final String fe = eyeFilter.toUpperCase();
        final String re = rowEye.toUpperCase();
        
        if (fe == "RL") {
           if (!["RL", "R/L", "R", "L"].contains(re)) return false;
        } else if (fe == "BOTH") {
           if (!["R", "L", "RL", "R/L"].contains(re)) return false;
        } else if (re != fe) return false;
      }

      return true;
    }).toList();

    // Sort
    filtered.sort((a, b) {
      int res = _customSequenceSort(a.combination.sph, b.combination.sph);
      if (res != 0) return res;
      res = _customSequenceSort(a.combination.cyl, b.combination.cyl);
      if (res != 0) return res;
      return _customSequenceSort(a.addValue, b.addValue);
    });

    setState(() {
      _filteredRows = filtered;
      _filtersApplied = true;
    });
  }

  void _clearFilters() {
    setState(() {
      _rangeControllers.values.forEach((c) {
        if (c != _rangeControllers['sphStep'] && 
            c != _rangeControllers['cylStep'] && 
            c != _rangeControllers['addStep']) {
          c.clear();
        }
      });
      _selectedEye = "";
      _activePowerGroupIdx = null;
    });
    // Re-apply to show all data
    _applyFilters();
  }

  void _onPowerGroupSelect(int? index) {
    if (index == null || _lensData == null) {
       setState(() {
         _activePowerGroupIdx = null;
       });
       return;
    }
    final pg = _lensData!.powerGroups[index];
    
    setState(() {
      _activePowerGroupIdx = index;
      _rangeControllers['sphMin']!.text = pg.sphMin ?? '';
      _rangeControllers['sphMax']!.text = pg.sphMax ?? '';
      _rangeControllers['sphStep']!.text = pg.sphStep;
      _rangeControllers['cylMin']!.text = pg.cylMin ?? '';
      _rangeControllers['cylMax']!.text = pg.cylMax ?? '';
      _rangeControllers['cylStep']!.text = pg.cylStep;
      _rangeControllers['addMin']!.text = pg.addMin ?? '';
      _rangeControllers['addMax']!.text = pg.addMax ?? '';
      _rangeControllers['addStep']!.text = pg.addStep;
      _rangeControllers['axis']!.text = pg.axis ?? '';
      _selectedEye = pg.eye ?? '';
    });
  }

  // --- Export Logic ---

  Future<void> _exportToExcel() async {
    if (_filteredRows.isEmpty) return;

    final excel = xl.Excel.createExcel();
    final sheet = excel['Lens Stock'];
    excel.setDefaultSheet('Lens Stock');

    if (_onlyAddView) {
      // Pivot Export
      final pivot = _computePivotData();
      final header = ['SPH', 'CYL', 'EYE', 'AXIS', ...pivot.addValues.map((a) => 'ADD $a'), 'TOTAL'];
      sheet.appendRow(header.map((e) => xl.TextCellValue(e)).toList());

      for (var row in pivot.rows) {
        final dataRow = [
          xl.TextCellValue(row.sph.toStringAsFixed(2)),
          xl.TextCellValue(row.cyl.toStringAsFixed(2)),
          xl.TextCellValue(row.eye),
          xl.TextCellValue(row.axis),
          ...pivot.addValues.map((a) => xl.IntCellValue(row.stocks[a] ?? 0)),
          xl.IntCellValue(row.stockTotal),
        ];
        sheet.appendRow(dataRow);
      }
    } else {
      // Standard Export
      final header = ['SPH', 'CYL', 'ADD', 'EYE', 'AXIS', 'BARCODE', 'STOCK', 'P.PRICE', 'S.PRICE'];
      sheet.appendRow(header.map((e) => xl.TextCellValue(e)).toList());

      for (var row in _filteredRows) {
        sheet.appendRow([
          xl.TextCellValue(row.combination.sph),
          xl.TextCellValue(row.combination.cyl),
          xl.TextCellValue(row.addValue),
          xl.TextCellValue(row.combination.eye.isEmpty ? _lensData!.eye : row.combination.eye),
          xl.TextCellValue(row.combination.axis.isEmpty ? _lensData!.axis : row.combination.axis),
          xl.TextCellValue(row.combination.barcode),
          xl.IntCellValue(row.combination.initStock),
          xl.DoubleCellValue(row.combination.pPrice),
          xl.DoubleCellValue(row.combination.sPrice),
        ]);
      }
    }

    String? path = await FilePicker.saveFile(
      dialogTitle: 'Save Excel File',
      fileName: 'Lens_Stock_SPH_CYL_${DateTime.now().millisecondsSinceEpoch}.xlsx',
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (path != null) {
      if (!path.endsWith('.xlsx')) path += '.xlsx';
      final fileBytes = excel.save();
      if (fileBytes != null) {
        File(path).writeAsBytesSync(fileBytes);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Exported to $path")));
      }
    }
  }

  Future<void> _printPdf() async {
    if (_filteredRows.isEmpty) return;

    final doc = pw.Document();
    
    if (_onlyAddView) {
      final pivot = _computePivotData();
      doc.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4.landscape,
          build: (pw.Context context) => [
            pw.Header(level: 0, child: pw.Text("Lens Stock SPH/CYL Wise (Pivot)")),
            pw.TableHelper.fromTextArray(
              headers: ['SPH', 'CYL', 'EYE', 'AXIS', ...pivot.addValues.map((a) => 'ADD $a'), 'TOTAL'],
              data: pivot.rows.map((row) => [
                row.sph.toStringAsFixed(2),
                row.cyl.toStringAsFixed(2),
                row.eye,
                row.axis,
                ...pivot.addValues.map((a) => (row.stocks[a] ?? 0).toString()),
                row.stockTotal.toString(),
              ]).toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
              cellStyle: const pw.TextStyle(fontSize: 7),
            ),
          ],
        ),
      );
    } else {
      doc.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) => [
            pw.Header(level: 0, child: pw.Text("Lens Stock SPH/CYL Wise")),
            pw.TableHelper.fromTextArray(
              headers: ['SPH', 'CYL', 'ADD', 'EYE', 'AXIS', 'STOCK'],
              data: _filteredRows.map((row) => [
                row.combination.sph,
                row.combination.cyl,
                row.addValue,
                row.combination.eye.isEmpty ? _lensData!.eye : row.combination.eye,
                row.combination.axis.isEmpty ? _lensData!.axis : row.combination.axis,
                row.combination.initStock.toString(),
              ]).toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
              cellStyle: const pw.TextStyle(fontSize: 9),
            ),
          ],
        ),
      );
    }

    await Printing.layoutPdf(onLayout: (format) async => doc.save());
  }

  // --- Pivot Computation ---

  PivotData _computePivotData() {
    final Set<String> addSet = {};
    for (var row in _filteredRows) {
      addSet.add(row.addValue);
    }
    final List<String> addValues = addSet.toList()..sort(_customSequenceSort);

    final Map<String, PivotRow> rowMap = {};

    for (var row in _filteredRows) {
      final double sph = double.tryParse(row.combination.sph) ?? 0;
      final double cyl = double.tryParse(row.combination.cyl) ?? 0;
      
      final String rawEye = row.combination.eye.isEmpty ? _lensData!.eye : row.combination.eye;
      final String fe = _selectedEye.toUpperCase();
      final String configEye = _lensData!.eye.toUpperCase();
      
      String groupingEye = rawEye.toUpperCase();
      if (fe == "RL" || configEye == "RL") {
        if (["RL", "R/L", "R", "L"].contains(groupingEye)) groupingEye = "RL";
      }

      final String axis = row.combination.axis.isEmpty ? _lensData!.axis : row.combination.axis;
      
      final String key = "${sph}_${cyl}_${groupingEye}_$axis";
      
      if (!rowMap.containsKey(key)) {
        rowMap[key] = PivotRow(
          sph: sph, 
          cyl: cyl, 
          eye: groupingEye, 
          axis: axis, 
          stocks: {}, 
          shortages: {},
          excesses: {},
          eyeStocks: {},
          eyeShortages: {},
          eyeExcesses: {},
        );
      }

      final entry = rowMap[key]!;
      final String add = row.addValue;
      final int stock = row.combination.initStock;
      final int alert = row.combination.alertQty;
      final int shortage = (alert - stock > 0) ? alert - stock : 0;
      final int excess = (stock - alert > 0) ? stock - alert : 0;

      if (!entry.eyeStocks.containsKey(add)) entry.eyeStocks[add] = {};
      entry.eyeStocks[add]![rawEye.toUpperCase()] = (entry.eyeStocks[add]![rawEye.toUpperCase()] ?? 0) + stock;

      if (!entry.eyeShortages.containsKey(add)) entry.eyeShortages[add] = {};
      entry.eyeShortages[add]![rawEye.toUpperCase()] = (entry.eyeShortages[add]![rawEye.toUpperCase()] ?? 0) + shortage;

      if (!entry.eyeExcesses.containsKey(add)) entry.eyeExcesses[add] = {};
      entry.eyeExcesses[add]![rawEye.toUpperCase()] = (entry.eyeExcesses[add]![rawEye.toUpperCase()] ?? 0) + excess;
    }

    // Finalize stocks, shortages, and excesses
    final List<PivotRow> rows = rowMap.values.toList();
    for (var row in rows) {
      int stockTotal = 0;
      int shortageTotal = 0;
      int excessTotal = 0;
      
      for (var add in addValues) {
        if (row.eyeStocks.containsKey(add)) {
          final eyeVals = row.eyeStocks[add]!.values;
          if (row.eye == "RL") {
            row.stocks[add] = eyeVals.isEmpty ? 0 : eyeVals.reduce((a, b) => a > b ? a : b);
          } else {
            row.stocks[add] = eyeVals.fold(0, (a, b) => a + b);
          }
          stockTotal += row.stocks[add] ?? 0;
        }

        if (row.eyeShortages.containsKey(add)) {
          final eyeVals = row.eyeShortages[add]!.values;
          if (row.eye == "RL") {
            row.shortages[add] = eyeVals.isEmpty ? 0 : eyeVals.reduce((a, b) => a > b ? a : b);
          } else {
            row.shortages[add] = eyeVals.fold(0, (a, b) => a + b);
          }
          shortageTotal += row.shortages[add] ?? 0;
        }

        if (row.eyeExcesses.containsKey(add)) {
          final eyeVals = row.eyeExcesses[add]!.values;
          if (row.eye == "RL") {
            row.excesses[add] = eyeVals.isEmpty ? 0 : eyeVals.reduce((a, b) => a > b ? a : b);
          } else {
            row.excesses[add] = eyeVals.fold(0, (a, b) => a + b);
          }
          excessTotal += row.excesses[add] ?? 0;
        }
      }
      row.stockTotal = stockTotal;
      row.shortageTotal = shortageTotal;
      row.excessTotal = excessTotal;
    }

    // Sort rows
    rows.sort((a, b) {
      int res = _customSequenceSort(a.sph, b.sph);
      if (res != 0) return res;
      res = _customSequenceSort(a.cyl, b.cyl);
      if (res != 0) return res;
      res = a.eye.compareTo(b.eye);
      if (res != 0) return res;
      return a.axis.compareTo(b.axis);
    });

    return PivotData(addValues: addValues, rows: rows);
  }

  // --- UI Components ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          _buildSliverHeader(),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildMainFilters(),
                const SizedBox(height: 24),
                _buildPowerRangeFilters(),
                const SizedBox(height: 24),
                _buildPowerGroupFilter(),
                if (_showDetails) ...[
                  const SizedBox(height: 32),
                  _buildResultsSection(),
                ],
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverHeader() {
    return SliverAppBar(
      expandedHeight: 130,
      floating: false,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(LucideIcons.arrowLeft, color: Color(0xFF1E293B)),
        onPressed: () => context.pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(64, 40, 32, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                "Lens Stock SPH/CYL Wise",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "Manage lens stock inventory by SPH and CYL specifications",
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainFilters() {
    final itemProvider = context.watch<ItemMasterProvider>();
    final lensGroups = context.watch<LensGroupProvider>().lensGroups;

    return _buildCard(
      title: "Settings",
      subtitle: "Collapse to hide all controls",
      trailing: const Icon(LucideIcons.chevronUp, size: 18, color: Color(0xFF64748B)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: _buildSearchableDropdown(
              label: "Group Name",
              controller: _groupController,
              items: lensGroups.map((g) => g.groupName).toSet().toList(),
              onChanged: (val) {
                 // Clear product when group changes
                 _productController.clear();
                 _handleShow();
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildSearchableDropdown(
              label: "Item Name",
              controller: _productController,
              items: itemProvider.items.map((i) => i.itemName).toList(),
              onChanged: (val) {
                // Find group for this item
                final item = itemProvider.items.firstWhere((i) => i.itemName == val);
                if (item.groupName.isNotEmpty) {
                  _groupController.text = item.groupName;
                }
                _handleShow();
              },
            ),
          ),
          const SizedBox(width: 24),
          _showDetails 
            ? _buildSecondaryButton(
                label: "Hide",
                icon: LucideIcons.eyeOff,
                onPressed: _handleShow,
              )
            : _buildPrimaryButton(
                label: "Show",
                icon: LucideIcons.eye,
                onPressed: _handleShow,
              ),
          const SizedBox(width: 12),
          _buildSecondaryButton(
            label: _onlyAddView ? "Hide Add View" : "Show Only Add",
            onPressed: () => setState(() => _onlyAddView = !_onlyAddView),
            isActive: _onlyAddView,
          ),
          const SizedBox(width: 16),
          _buildIconButton(
            LucideIcons.download, 
            _exportToExcel, 
            tooltip: "Export to Excel",
            backgroundColor: const Color(0xFF10B981),
          ),
          const SizedBox(width: 8),
          _buildIconButton(
            LucideIcons.printer, 
            _printPdf, 
            tooltip: "Print Report",
            backgroundColor: const Color(0xFF8B5CF6),
          ),
        ],
      ),
    );
  }

  Widget _buildPowerRangeFilters() {
    return _buildCard(
      title: "Power Range",
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildRangeField("From SPH", _rangeControllers['sphMin']!)),
              const SizedBox(width: 12),
              Expanded(child: _buildRangeField("To SPH", _rangeControllers['sphMax']!)),
              const SizedBox(width: 12),
              Expanded(child: _buildRangeField("SPH Step", _rangeControllers['sphStep']!)),
              const SizedBox(width: 12),
              Expanded(child: _buildRangeField("From CYL", _rangeControllers['cylMin']!)),
              const SizedBox(width: 12),
              Expanded(child: _buildRangeField("To CYL", _rangeControllers['cylMax']!)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildRangeField("CYL Step", _rangeControllers['cylStep']!)),
              const SizedBox(width: 12),
              Expanded(child: _buildRangeField("From Add", _rangeControllers['addMin']!)),
              const SizedBox(width: 12),
              Expanded(child: _buildRangeField("To Add", _rangeControllers['addMax']!)),
              const SizedBox(width: 12),
              Expanded(child: _buildRangeField("ADD Step", _rangeControllers['addStep']!)),
              const SizedBox(width: 12),
              Expanded(child: _buildRangeField("Axis", _rangeControllers['axis']!)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSimpleDropdown(
                  label: "Eye (RL)",
                  value: _selectedEye,
                  items: ["", "R", "L", "RL", "Both"],
                  onChanged: (v) => setState(() => _selectedEye = v!),
                ),
              ),
              const Spacer(flex: 4),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPowerGroupFilter() {
    final List<String> pgs = _lensData?.powerGroups.map((pg) => pg.label ?? 'Group').toList() ?? [];

    return _buildCard(
      title: "Power Group Filter",
      icon: LucideIcons.plus,
      iconColor: const Color(0xFF3B82F6),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: _buildSimpleDropdown(
              label: "Power Group List",
              value: _activePowerGroupIdx?.toString() ?? "",
              items: ["", ...List.generate(pgs.length, (i) => i.toString())],
              itemLabels: ["Select a Power Group", ...pgs],
              onChanged: (v) => _onPowerGroupSelect(int.tryParse(v ?? '')),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            flex: 3,
            child: Text(
              "Select a previously saved range from Lens Group Creation to quickly fill all filters above.",
              style: TextStyle(fontSize: 12, color: Color(0xFF64748B), fontStyle: FontStyle.italic),
            ),
          ),
          const SizedBox(width: 24),
          _buildPrimaryButton(label: "Apply", icon: LucideIcons.check, onPressed: _applyFilters),
          const SizedBox(width: 12),
          _buildSecondaryButton(label: "Clear Filters", onPressed: _clearFilters),
        ],
      ),
    );
  }

  Widget _buildResultsSection() {
    if (_filteredRows.isEmpty) return const Center(child: Text("No matching lens powers found."));

    if (_onlyAddView) {
      return _buildOnlyAddSummaryView();
    }

    return _buildAddGroupedMatrixViews();
  }

  Widget _buildOnlyAddSummaryView() {
    final pivot = _computePivotData();
    if (pivot.rows.isEmpty) return const Center(child: Text("No data"));

    return Column(
      children: [
        _buildSinglePivotTable(
          title: "ADD SUMMARY (STOCK SUMMARY)",
          pivot: pivot,
          type: "Stock",
          headerBg: const Color(0xFFDBEAFE),
          mainText: const Color(0xFF1E293B),
        ),
        const SizedBox(height: 32),
        _buildSinglePivotTable(
          title: "REORDER SHORTAGE SUMMARY (MIN STOCK - CURRENT)",
          pivot: pivot,
          type: "Shortage",
          headerBg: const Color(0xFFFEE2E2),
          mainText: const Color(0xFF7F1D1D),
        ),
        const SizedBox(height: 32),
        _buildSinglePivotTable(
          title: "EXCESS STOCK SUMMARY (CURRENT - MIN STOCK)",
          pivot: pivot,
          type: "Excess",
          headerBg: const Color(0xFFD1FAE5),
          mainText: const Color(0xFF064E3B),
        ),
      ],
    );
  }

  Widget _buildSinglePivotTable({
    required String title,
    required PivotData pivot,
    required String type,
    required Color headerBg,
    required Color mainText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: mainText, letterSpacing: 0.5)),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final double minRequiredWidth = (pivot.addValues.length + 5) * 80.0;
              final double tableWidth = constraints.maxWidth > minRequiredWidth ? constraints.maxWidth : minRequiredWidth;
              
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: tableWidth,
                  child: Table(
                    defaultColumnWidth: const FlexColumnWidth(),
                    border: const TableBorder(
                      horizontalInside: BorderSide(color: Color(0xFFF1F5F9)),
                      bottom: BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    children: [
                      // Header
                      TableRow(
                        decoration: const BoxDecoration(
                          color: Color(0xFFF8FAFC),
                          border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
                        ),
                        children: [
                          _buildSummaryHeader("SPH", color: mainText),
                          _buildSummaryHeader("CYL", color: mainText),
                          _buildSummaryHeader("Eye", color: mainText),
                          _buildSummaryHeader("Axis", color: mainText),
                          ...pivot.addValues.map((a) => _buildSummaryHeader("+$a", bg: headerBg, color: mainText)),
                          _buildSummaryHeader("Row Σ", bg: const Color(0xFFDCFCE7), color: const Color(0xFF334155)),
                        ],
                      ),
                      // Rows
                      ...pivot.rows.map((row) {
                        return TableRow(
                          children: [
                            _buildSummaryCell(row.sph.toStringAsFixed(2), color: mainText, weight: FontWeight.w700),
                            _buildSummaryCell(row.cyl.toStringAsFixed(2), color: mainText, weight: FontWeight.w700),
                            _buildSummaryCell(row.eye, color: mainText, weight: FontWeight.w700),
                            _buildSummaryCell(row.axis, isMono: true, color: mainText, weight: FontWeight.w700),
                            ...pivot.addValues.map((a) {
                              int val = 0;
                              if (type == "Stock") val = row.stocks[a] ?? 0;
                              else if (type == "Shortage") val = row.shortages[a] ?? 0;
                              else if (type == "Excess") val = row.excesses[a] ?? 0;
                              return _buildSummaryStockCell(val, type: type);
                            }),
                            _buildSummaryCell(
                              type == "Stock" ? row.stockTotal.toString() : (type == "Shortage" ? row.shortageTotal.toString() : row.excessTotal.toString()), 
                              bg: const Color(0xFFF0FDF4), weight: FontWeight.w700
                            ),
                          ],
                        );
                      }),
                      // Footer
                      TableRow(
                        decoration: const BoxDecoration(
                          color: Color(0xFFFEFCE8), // yellow-50
                          border: Border(top: BorderSide(color: Color(0xFFCBD5E1), width: 2)), // slate-300
                        ),
                        children: [
                          const TableCell(
                            child: Padding(padding: EdgeInsets.all(8), child: Text("Col Σ:", textAlign: TextAlign.right, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155)))),
                          ),
                          const TableCell(child: SizedBox()),
                          const TableCell(child: SizedBox()),
                          const TableCell(child: SizedBox()),
                          ...pivot.addValues.map((a) {
                            int colTotal = 0;
                            if (type == "Stock") colTotal = pivot.rows.fold(0, (sum, r) => sum + (r.stocks[a] ?? 0));
                            else if (type == "Shortage") colTotal = pivot.rows.fold(0, (sum, r) => sum + (r.shortages[a] ?? 0));
                            else if (type == "Excess") colTotal = pivot.rows.fold(0, (sum, r) => sum + (r.excesses[a] ?? 0));
                            return _buildSummaryCell(colTotal.toString(), bg: const Color(0xFFFEF08A), weight: FontWeight.w700, align: Alignment.center);
                          }),
                          _buildSummaryCell(
                            (type == "Stock" ? pivot.rows.fold(0, (sum, r) => sum + r.stockTotal) : (type == "Shortage" ? pivot.rows.fold(0, (sum, r) => sum + r.shortageTotal) : pivot.rows.fold(0, (sum, r) => sum + r.excessTotal))).toString(),
                            bg: const Color(0xFFFFEDD5), weight: FontWeight.w800, align: Alignment.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          if (type == "Shortage") ...[
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: _buildPrimaryButton(
                label: "GENERATE PURCHASE ORDER (FROM SUMMARY)",
                icon: LucideIcons.plus,
                onPressed: () {
                   _handleBulkReorder(_filteredRows.where((row) => row.combination.alertQty - row.combination.initStock > 0).toList());
                },
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildSummaryHeader(String text, {Color? bg, Color color = const Color(0xFF334155)}) {
    return TableCell(
      child: Container(
        color: bg,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        alignment: Alignment.centerLeft,
        child: Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color)),
      ),
    );
  }

  Widget _buildSummaryCell(String text, {Color? bg, FontWeight weight = FontWeight.w500, bool isMono = false, Alignment align = Alignment.centerLeft, Color color = const Color(0xFF334155)}) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Container(
        color: bg,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        alignment: align,
        child: Text(
          text,
          style: TextStyle(
            fontSize: isMono ? 11 : 12,
            fontWeight: weight,
            color: color,
            fontFamily: isMono ? 'monospace' : null,
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryStockCell(int val, {String type = "Stock"}) {
    if (val == 0) {
      if (type == "Stock") {
         return _buildSummaryCell("-", align: Alignment.center, color: const Color(0xFF94A3B8));
      } else {
         return _buildSummaryCell("-", align: Alignment.center, color: const Color(0xFFCBD5E1));
      }
    }
    
    Color textColor = const Color(0xFF1E293B);
    Color bgColor = const Color(0xFFF8FAFC);
    Color borderColor = const Color(0xFFE2E8F0);
    
    if (type == "Shortage") {
       textColor = const Color(0xFF991B1B);
       bgColor = const Color(0xFFFEF2F2);
       borderColor = const Color(0xFFFECACA);
    } else if (type == "Excess") {
       textColor = const Color(0xFF065F46);
       bgColor = const Color(0xFFECFDF5);
       borderColor = const Color(0xFFA7F3D0);
    }

    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        child: type == "Stock" ? Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(val.toString(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: textColor)),
        ) : Text(val.toString(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: textColor)),
      ),
    );
  }

  Widget _buildAddGroupedMatrixViews() {
    final Map<String, List<FlattenedLensRow>> groupedByAdd = {};
    for (var row in _filteredRows) {
      groupedByAdd.putIfAbsent(row.addValue, () => []).add(row);
    }
    final addKeys = groupedByAdd.keys.toList()..sort(_customSequenceSort);

    return Column(
      children: addKeys.map((add) {
        final rows = groupedByAdd[add]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMatrixGrid(add, rows, "Stock"),
            const SizedBox(height: 24),
            _buildMatrixGrid(add, rows, "Shortage"),
            const SizedBox(height: 24),
            _buildMatrixGrid(add, rows, "Excess"),
            const SizedBox(height: 40),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildMatrixGrid(String addValue, List<FlattenedLensRow> data, String type) {
    // 1. Get unique SPH and CYL values for this ADD
    final Set<String> sphSet = {};
    final Set<String> cylSet = {};
    for (var d in data) {
      sphSet.add(d.combination.sph);
      cylSet.add(d.combination.cyl);
    }
    final List<String> sortedSph = sphSet.toList()..sort(_customSequenceSort);
    final List<String> sortedCyl = cylSet.toList()..sort(_customSequenceSort);

    // 2. Map data
    final Map<String, Map<String, List<FlattenedLensRow>>> lookup = {};
    for (var d in data) {
      lookup.putIfAbsent(d.combination.sph, () => {}).putIfAbsent(d.combination.cyl, () => []).add(d);
    }

    Color mainBg = const Color(0xFFFFFFFF);
    Color headerBg = const Color(0xFFEFF6FF); // blue-50
    Color titleBg = const Color(0xFFEFF6FF).withOpacity(0.5); // blue-50/50 approx
    Color borderColor = const Color(0xFFE2E8F0);
    Color textHeaderColor = const Color(0xFF475569); // slate-600
    Color titleColor = const Color(0xFF334155); // slate-700
    
    String title = "ADD $addValue - Stock";
    
    if (type == "Shortage") {
      title = "REORDER SHORTAGE (MIN STOCK - CURRENT)";
      mainBg = const Color(0xFFF8FAFC); // slate-50 equivalent bg
      headerBg = const Color(0xFFFEE2E2).withOpacity(0.5); // red-100/50
      titleBg = const Color(0xFFFEF2F2).withOpacity(0.5); // red-50/50
      borderColor = const Color(0xFFFECACA); // red-200
      textHeaderColor = const Color(0xFF7F1D1D); // red-900
      titleColor = const Color(0xFF7F1D1D); // red-900
    } else if (type == "Excess") {
      title = "EXCESS AMOUNT OF STOCK (CURRENT - MIN STOCK)";
      mainBg = const Color(0xFFF8FAFC); 
      headerBg = const Color(0xFFD1FAE5).withOpacity(0.5); // emerald-100/50
      titleBg = const Color(0xFFECFDF5); // emerald-50
      borderColor = const Color(0xFFA7F3D0); // emerald-200
      textHeaderColor = const Color(0xFF064E3B); // emerald-900
      titleColor = const Color(0xFF064E3B); // emerald-900
    }

    return Container(
      decoration: BoxDecoration(
        color: mainBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TITLE BAR
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: titleBg,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              border: Border(bottom: BorderSide(color: borderColor)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w800, color: titleColor, fontSize: 12, letterSpacing: type != "Stock" ? 0.5 : 0)),
                if (type == "Stock")
                  Text("Grand Total: ${data.fold(0, (sum, e) => sum + e.combination.initStock)}", style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
              ],
            ),
          ),
          
          // TABLE
          LayoutBuilder(
            builder: (context, constraints) {
              final double paddingWidth = 16.0; // Padding inside container
              final double availableWidth = constraints.maxWidth - paddingWidth;
              final double minRequiredWidth = (sortedCyl.length + 3) * 70.0;
              final double tableWidth = availableWidth > minRequiredWidth ? availableWidth : minRequiredWidth;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: tableWidth,
                    child: Table(
                      defaultColumnWidth: const FlexColumnWidth(),
                      border: TableBorder.all(color: borderColor, width: 1),
                      children: [
                        // HEADER ROW
                        TableRow(
                          decoration: BoxDecoration(color: headerBg),
                          children: [
                            _buildHeaderCell("SPH / CYL", textHeaderColor),
                            _buildHeaderCell("Axis", textHeaderColor),
                            ...sortedCyl.map((cyl) => _buildHeaderCell(double.tryParse(cyl)?.toStringAsFixed(2) ?? cyl, textHeaderColor)),
                            _buildHeaderCell("Row Σ", const Color(0xFF1E293B), bg: const Color(0xFFDCFCE7)), // green-100
                          ],
                        ),
                        
                        // DATA ROWS
                        ...sortedSph.map((sph) {
                          int rowTotal = 0;
                          return TableRow(
                            decoration: BoxDecoration(
                              color: type == "Shortage" ? const Color(0xFFFEF2F2).withOpacity(0.3) : (type == "Excess" ? const Color(0xFFECFDF5).withOpacity(0.3) : Colors.transparent),
                            ),
                            children: [
                              _buildDataCell(double.tryParse(sph)?.toStringAsFixed(2) ?? sph, isRowHeader: true, type: type),
                              _buildDataCell("1", isRowHeader: true, type: type), // Default axis
                              ...sortedCyl.map((cyl) {
                                final items = lookup[sph]?[cyl] ?? [];
                                int val = 0;
                                String barcode = "";
                                
                                if (items.isNotEmpty) {
                                   barcode = items.first.combination.barcode;
                                   if (type == "Stock") {
                                     val = items.fold(0, (sum, e) => sum + e.combination.initStock);
                                   } else if (type == "Shortage") {
                                     val = items.fold(0, (sum, e) => sum + (e.combination.alertQty - e.combination.initStock > 0 ? e.combination.alertQty - e.combination.initStock : 0));
                                   } else {
                                     val = items.fold(0, (sum, e) => sum + (e.combination.initStock - e.combination.alertQty > 0 ? e.combination.initStock - e.combination.alertQty : 0));
                                   }
                                }
                                rowTotal += val;
                                return _buildCellVal(val, barcode, type);
                              }),
                              _buildDataCell(rowTotal.toString(), isTotal: true),
                            ],
                          );
                        }),
                        
                        // FOOTER ROW
                        TableRow(
                          decoration: const BoxDecoration(
                            color: Color(0xFFFEFCE8), // yellow-50
                            border: Border(top: BorderSide(color: Color(0xFFCBD5E1), width: 2)), // slate-300
                          ),
                          children: [
                            const TableCell(
                              child: Padding(padding: EdgeInsets.all(8), child: Text("Col Σ:", textAlign: TextAlign.right, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155)))),
                            ),
                            const TableCell(child: SizedBox()),
                            ...sortedCyl.map((cyl) {
                              int colTotal = 0;
                              for (var sph in sortedSph) {
                                final items = lookup[sph]?[cyl] ?? [];
                                if (items.isNotEmpty) {
                                  if (type == "Stock") {
                                    colTotal += items.fold(0, (sum, e) => sum + e.combination.initStock);
                                  } else if (type == "Shortage") {
                                    colTotal += items.fold(0, (sum, e) => sum + (e.combination.alertQty - e.combination.initStock > 0 ? e.combination.alertQty - e.combination.initStock : 0));
                                  } else {
                                    colTotal += items.fold(0, (sum, e) => sum + (e.combination.initStock - e.combination.alertQty > 0 ? e.combination.initStock - e.combination.alertQty : 0));
                                  }
                                }
                              }
                              return TableCell(
                                child: Container(
                                  color: const Color(0xFFFEF08A), // yellow-100
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  alignment: Alignment.center,
                                  child: Text(colTotal.toString(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
                                ),
                              );
                            }),
                            TableCell(
                              child: Container(
                                color: const Color(0xFFFFEDD5), // orange-100
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                alignment: Alignment.center,
                                child: Text(
                                  data.fold(0, (sum, e) {
                                    if (type == "Stock") return sum + e.combination.initStock;
                                    if (type == "Shortage") return sum + (e.combination.alertQty - e.combination.initStock > 0 ? e.combination.alertQty - e.combination.initStock : 0);
                                    return sum + (e.combination.initStock - e.combination.alertQty > 0 ? e.combination.initStock - e.combination.alertQty : 0);
                                  }).toString(),
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF334155)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          
          if (type == "Shortage" && data.any((e) => e.combination.alertQty > e.combination.initStock))
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2).withOpacity(0.5),
                border: const Border(top: BorderSide(color: Color(0xFFFECACA))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _handleBulkReorder(data.where((e) => e.combination.alertQty > e.combination.initStock).toList()),
                    icon: const Icon(LucideIcons.plus, size: 14),
                    label: const Text("GENERATE PURCHASE ORDER", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 0.5)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F172A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ),
            
          if (type == "Stock")
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _handleBulkReorder(data),
                    icon: const Icon(LucideIcons.plus, size: 14),
                    label: const Text("GENERATE PURCHASE ORDER", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 0.5)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F172A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, Color color, {Color? bg}) {
    return TableCell(
      child: Container(
        color: bg,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        alignment: Alignment.center,
        child: Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: color)),
      ),
    );
  }

  Widget _buildDataCell(String text, {bool isRowHeader = false, bool isTotal = false, String type = "Stock"}) {
    Color textColor = const Color(0xFF334155);
    Color? bg;
    if (isTotal) {
      bg = const Color(0xFFF0FDF4); // green-50
      textColor = const Color(0xFF334155);
    } else if (isRowHeader) {
      if (type == "Stock") {
        textColor = const Color(0xFF1D4ED8); // blue-700
      } else if (type == "Shortage") {
        textColor = const Color(0xFF7F1D1D); // red-900
      } else {
        textColor = const Color(0xFF064E3B); // emerald-900
      }
    }

    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Container(
        color: bg,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isTotal || isRowHeader ? FontWeight.w700 : FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildCellVal(int val, String barcode, String type) {
    if (val == 0) {
      return const TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text("-", textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF94A3B8))),
        ),
      );
    }

    Color txtColor = const Color(0xFF1E293B);
    Color? bg;
    
    if (type == "Shortage") {
      txtColor = const Color(0xFFB91C1C); // red-700
      bg = const Color(0xFFFEE2E2).withOpacity(0.4); // red-100/40
    } else if (type == "Excess") {
      txtColor = const Color(0xFF047857); // emerald-700
      bg = const Color(0xFFD1FAE5).withOpacity(0.4); // emerald-100/40
    }

    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Container(
        color: bg,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        alignment: Alignment.center,
        child: type == "Shortage" ? 
            // Mocking the editable input text look for shortage
            Text(val.toString(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: txtColor, decoration: TextDecoration.underline, decorationStyle: TextDecorationStyle.dashed, decorationColor: const Color(0xFFFCA5A5)))
            :
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (type == "Stock")
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(val.toString(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
                  )
                else
                  Text(val.toString(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: txtColor)),
                
                if (barcode.isNotEmpty && type == "Stock")
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(barcode, style: const TextStyle(fontSize: 9, color: Color(0xFF334155), fontWeight: FontWeight.w700, letterSpacing: -0.5)),
                  ),
              ],
            ),
      ),
    );
  }

  void _handleBulkReorder(List<FlattenedLensRow> items) {
     final List<Map<String, dynamic>> itemsToOrder = items.map((row) => {
       'itemId': _lensData!.id,
       'add': row.addValue,
       'sph': row.combination.sph,
       'cyl': row.combination.cyl,
       'qty': row.combination.alertQty - row.combination.initStock > 0 ? row.combination.alertQty - row.combination.initStock : 1,
       'productName': _lensData!.productName,
       'groupName': _lensData!.groupName,
       'eye': row.combination.eye.isEmpty ? _lensData!.eye : row.combination.eye,
     }).toList();
     
     context.push('/lenstransaction/purchase/AddLensPurchaseOrder', extra: {'items': itemsToOrder});
  }

  void _handleReorder(FlattenedLensRow row) {
     final itemToOrder = {
       'itemId': _lensData!.id,
       'add': row.addValue,
       'sph': row.combination.sph,
       'cyl': row.combination.cyl,
       'qty': 1, // Default to 1 for quick order
       'productName': _lensData!.productName,
       'groupName': _lensData!.groupName,
       'eye': row.combination.eye.isEmpty ? _lensData!.eye : row.combination.eye,
     };
     
     context.push('/lenstransaction/purchase/AddLensPurchaseOrder', extra: {'items': [itemToOrder]});
  }

  // --- Base UI Components ---

  Widget _buildCard({required String title, String? subtitle, IconData? icon, Color? iconColor, Widget? trailing, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 4))],
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[Icon(icon, size: 18, color: iconColor ?? const Color(0xFF6366F1)), const SizedBox(width: 8)],
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
              if (subtitle != null) ...[
                const SizedBox(width: 8),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
              ],
              if (trailing != null) ...[
                const Spacer(),
                trailing,
              ],
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildRangeField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 2)),
            fillColor: const Color(0xFFF8FAFC),
            filled: true,
          ),
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildSearchableDropdown({required String label, required TextEditingController controller, required List<String> items, required Function(String) onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
        const SizedBox(height: 6),
        LayoutBuilder(
          builder: (context, constraints) => Autocomplete<String>(
            optionsBuilder: (TextEditingValue value) {
              if (value.text.isEmpty) return items;
              return items.where((i) => i.toLowerCase().contains(value.text.toLowerCase()));
            },
            onSelected: (val) {
              controller.text = val;
              onChanged(val);
            },
            fieldViewBuilder: (context, c, focusNode, onFieldSubmitted) {
              // Sync with manual controller
              if (c.text != controller.text) c.text = controller.text;
              return TextField(
                controller: c,
                focusNode: focusNode,
                decoration: InputDecoration(
                  hintText: "Select $label",
                  suffixIcon: const Icon(LucideIcons.chevronDown, size: 16),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                  fillColor: const Color(0xFFF8FAFC),
                  filled: true,
                ),
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleDropdown({required String label, required String value, required List<String> items, List<String>? itemLabels, required Function(String?) onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              items: List.generate(items.length, (i) => DropdownMenuItem(
                value: items[i],
                child: Text(itemLabels != null ? itemLabels[i] : (items[i].isEmpty ? "Select..." : items[i]), style: const TextStyle(fontSize: 13)),
              )),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryButton({required String label, required IconData icon, required VoidCallback onPressed}) {
    return SizedBox(
      height: 48,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4F46E5),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildSecondaryButton({required String label, IconData? icon, required VoidCallback onPressed, bool isActive = false}) {
    return SizedBox(
      height: 48,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon != null ? Icon(icon, size: 16) : const SizedBox.shrink(),
        label: Text(
          label, 
          style: TextStyle(
            fontWeight: FontWeight.w700, 
            fontSize: 13,
            color: isActive ? const Color(0xFF1E40AF) : const Color(0xFF475569), // blue-800 when active
          ),
          textAlign: TextAlign.center,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isActive ? const Color(0xFFEFF6FF) : const Color(0xFFF1F5F9), // blue-50 when active
          foregroundColor: isActive ? const Color(0xFF1E40AF) : const Color(0xFF475569),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: isActive ? const Color(0xFFBFDBFE) : Colors.transparent), // blue-200 border when active
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap, {String? tooltip, Color? backgroundColor}) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        border: backgroundColor == null ? Border.all(color: const Color(0xFFE2E8F0)) : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(icon, size: 20, color: backgroundColor != null ? Colors.white : const Color(0xFF64748B)),
        onPressed: onTap,
        tooltip: tooltip,
        padding: EdgeInsets.zero,
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;
  final bool isHeader;
  final Alignment alignment;
  final FontWeight? weight;
  final Color? color;

  const _TableCell(this.text, {this.isHeader = false, this.alignment = Alignment.centerLeft, this.weight, this.color});

  @override
  Widget build(BuildContext context) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        alignment: alignment,
        child: Text(
          text,
          style: TextStyle(
            fontSize: isHeader ? 11 : 12,
            fontWeight: isHeader ? FontWeight.w900 : (weight ?? FontWeight.w500),
            color: color ?? (isHeader ? const Color(0xFF64748B) : const Color(0xFF1E293B)),
            letterSpacing: isHeader ? 0.5 : 0,
          ),
        ),
      ),
    );
  }
}

// --- Data Models for Internal Usage ---

class FlattenedLensRow {
  final LensCombination combination;
  final String addValue;
  final String groupId;

  FlattenedLensRow({required this.combination, required this.addValue, required this.groupId});
}

class PivotData {
  final List<String> addValues;
  final List<PivotRow> rows;
  PivotData({required this.addValues, required this.rows});
}

class PivotRow {
  final double sph;
  final double cyl;
  final String eye;
  final String axis;
  final Map<String, int> stocks;
  final Map<String, int> shortages;
  final Map<String, int> excesses;
  final Map<String, Map<String, int>> eyeStocks;
  final Map<String, Map<String, int>> eyeShortages;
  final Map<String, Map<String, int>> eyeExcesses;
  int stockTotal;
  int shortageTotal;
  int excessTotal;

  PivotRow({
    required this.sph,
    required this.cyl,
    required this.eye,
    required this.axis,
    required this.stocks,
    required this.shortages,
    required this.excesses,
    required this.eyeStocks,
    required this.eyeShortages,
    required this.eyeExcesses,
    this.stockTotal = 0,
    this.shortageTotal = 0,
    this.excessTotal = 0,
  });
}
