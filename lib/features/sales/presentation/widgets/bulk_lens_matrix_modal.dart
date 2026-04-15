import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BulkLensMatrixModal extends StatefulWidget {
  final Map<String, dynamic> product;
  final Function(List<Map<String, dynamic>>) onAddItems;
  final Map<String, dynamic> baseItem;
  final String priceKey;

  const BulkLensMatrixModal({
    super.key,
    required this.product,
    required this.onAddItems,
    required this.baseItem,
    this.priceKey = 'salePrice',
  });

  @override
  State<BulkLensMatrixModal> createState() => _BulkLensMatrixModalState();
}

class _BulkLensMatrixModalState extends State<BulkLensMatrixModal> {
  // --- Range State ---
  double sphFrom = 0;
  double sphTo = 0;
  double cylFrom = 0;
  double cylTo = 0;
  double addFrom = 0;
  double addTo = 0;
  String selectedEye = 'R/L';
  String selectedDia = '';

  // --- Matrix State ---
  // Key: "sph_cyl", Value: { axis: "", adds: { "addValue": "qty" } }
  Map<String, Map<String, dynamic>> matrixData = {};

  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeRanges();
  }

  void _initializeRanges() {
    final product = widget.product;
    final Set<double> sphSet = {};
    final Set<double> cylSet = {};
    final Set<double> addSet = {};

    final addGroups = product['addGroups'] as List?;
    if (addGroups != null) {
      for (var ag in addGroups) {
        if (ag['addValue'] != null) {
          addSet.add(double.tryParse(ag['addValue'].toString()) ?? 0);
        }
        final combinations = ag['combinations'] as List?;
        if (combinations != null) {
          for (var c in combinations) {
            if (c['sph'] != null) sphSet.add(double.tryParse(c['sph'].toString()) ?? 0);
            if (c['cyl'] != null) cylSet.add(double.tryParse(c['cyl'].toString()) ?? 0);
          }
        }
      }
    }

    setState(() {
      if (sphSet.isNotEmpty) {
        sphFrom = sphSet.reduce((a, b) => a < b ? a : b);
        sphTo = sphSet.reduce((a, b) => a > b ? a : b);
      }
      if (cylSet.isNotEmpty) {
        cylFrom = cylSet.reduce((a, b) => a < b ? a : b);
        cylTo = cylSet.reduce((a, b) => a > b ? a : b);
      }
      if (addSet.isNotEmpty) {
        addFrom = addSet.reduce((a, b) => a < b ? a : b);
        addTo = addSet.reduce((a, b) => a > b ? a : b);
      }
    });
  }

  List<String> _generateRange(double start, double end, {double step = 0.25}) {
    List<double> fullList = [];
    double minVal = start < end ? start : end;
    double maxVal = start > end ? start : end;

    for (double i = minVal; i <= maxVal + 0.0001; i += step) {
      fullList.add(double.parse(i.toStringAsFixed(2)));
    }

    final zeroVal = fullList.where((v) => v == 0).toList();
    final negativeVals = fullList.where((v) => v < 0).toList()..sort((a, b) => b.compareTo(a));
    final positiveVals = fullList.where((v) => v > 0).toList()..sort((a, b) => a.compareTo(b));

    return [...zeroVal, ...negativeVals, ...positiveVals].map((v) => v.toStringAsFixed(2)).toList();
  }

  bool get hasAdd {
    final adds = _generateRange(addFrom, addTo);
    return adds.any((a) => (double.tryParse(a) ?? 0).abs() > 0.001);
  }

  void _handleQtyChange(String sph, String cyl, String add, String val) {
    final rowKey = "${sph}_$cyl";
    setState(() {
      if (!matrixData.containsKey(rowKey)) {
        matrixData[rowKey] = {'axis': '', 'adds': {}};
      }
      matrixData[rowKey]!['adds'][add] = val;
    });
  }

  void _handleAxisChange(String sph, String cyl, String val) {
    final rowKey = "${sph}_$cyl";
    setState(() {
      if (!matrixData.containsKey(rowKey)) {
        matrixData[rowKey] = {'axis': '', 'adds': {}};
      }
      matrixData[rowKey]!['axis'] = val;
    });
  }

  String? _getCombinationId(String sph, String cyl, String add, String eye) {
    final product = widget.product;
    final tSph = double.tryParse(sph) ?? 0;
    final tCyl = double.tryParse(cyl) ?? 0;
    final tAdd = double.tryParse(add) ?? 0;
    final tEyeNorm = eye.toUpperCase().replaceAll(RegExp(r'[\/\s]'), '');

    final addGroups = product['addGroups'] as List?;
    if (addGroups == null) return null;

    for (var ag in addGroups) {
      final agAdd = double.tryParse(ag['addValue'].toString()) ?? 0;
      if ((agAdd - tAdd).abs() < 0.001) {
        final combinations = ag['combinations'] as List?;
        if (combinations == null) continue;

        for (var c in combinations) {
          final cSph = double.tryParse(c['sph'].toString()) ?? 0;
          final cCyl = double.tryParse(c['cyl'].toString()) ?? 0;
          final cEyeNorm = (c['eye']?.toString() ?? '').toUpperCase().replaceAll(RegExp(r'[\/\s]'), '');

          bool eyeMatch = false;
          if (tEyeNorm == 'RL') {
            eyeMatch = (cEyeNorm == 'RL' || cEyeNorm == 'BOTH' || cEyeNorm == '');
          } else {
            eyeMatch = (cEyeNorm == tEyeNorm || cEyeNorm == 'RL' || cEyeNorm == 'BOTH' || cEyeNorm == '');
          }

          if ((cSph - tSph).abs() < 0.001 && (cCyl - tCyl).abs() < 0.001 && eyeMatch) {
            return c['_id']?.toString();
          }
        }
      }
    }
    return null;
  }

  void _handleSubmit() {
    final List<Map<String, dynamic>> items = [];
    final sphRows = _generateRange(sphFrom, sphTo);
    final cylRows = _generateRange(cylFrom, cylTo);
    final addCols = _generateRange(addFrom, addTo);

    final price = double.tryParse(widget.baseItem[widget.priceKey]?.toString() ?? '0') ?? 0;
    final discount = double.tryParse(widget.baseItem['discount']?.toString() ?? '0') ?? 0;

    if (!hasAdd) {
      for (var sph in sphRows) {
        for (var cyl in cylRows) {
          final rowKey = "${sph}_$cyl";
          final data = matrixData[rowKey];
          final fixedAdd = addCols.isNotEmpty ? addCols[0] : "0.00";
          final qtyStr = data?['adds']?[fixedAdd]?.toString() ?? '';
          final qty = int.tryParse(qtyStr) ?? 0;

          if (qty > 0) {
            final comboId = _getCombinationId(sph, cyl, fixedAdd, selectedEye);
            items.add({
              ...widget.baseItem,
              'id': DateTime.now().millisecondsSinceEpoch + (items.length * 100),
              'sph': double.parse(sph),
              'cyl': double.parse(cyl),
              'axis': double.tryParse(data?['axis']?.toString() ?? '') ?? widget.baseItem['axis'] ?? 0.0,
              'add': double.parse(fixedAdd),
              'qty': qty,
              'eye': selectedEye,
              'dia': selectedDia.isNotEmpty ? selectedDia : widget.baseItem['dia'] ?? '',
              'combinationId': comboId ?? '',
              'totalAmount': (qty * price * (1 - discount / 100)).toStringAsFixed(2),
            });
          }
        }
      }
    } else {
      matrixData.forEach((rowKey, data) {
        final parts = rowKey.split('_');
        final sph = parts[0];
        final cyl = parts[1];
        final adds = data['adds'] as Map;
        final axis = data['axis']?.toString() ?? '';

        adds.forEach((add, qtyStr) {
          final qty = int.tryParse(qtyStr.toString()) ?? 0;
          if (qty > 0) {
            final comboId = _getCombinationId(sph, cyl, add, selectedEye);
            items.add({
              ...widget.baseItem,
              'id': DateTime.now().millisecondsSinceEpoch + (items.length * 100),
              'sph': double.parse(sph),
              'cyl': double.parse(cyl),
              'axis': double.tryParse(axis) ?? widget.baseItem['axis'] ?? 0.0,
              'add': double.parse(add),
              'qty': qty,
              'eye': selectedEye,
              'dia': selectedDia.isNotEmpty ? selectedDia : widget.baseItem['dia'] ?? '',
              'combinationId': comboId ?? '',
              'totalAmount': (qty * price * (1 - discount / 100)).toStringAsFixed(2),
            });
          }
        });
      });
    }

    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No items entered')),
      );
      return;
    }

    widget.onAddItems(items);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final sphRows = _generateRange(sphFrom, sphTo);
    final cylRows = _generateRange(cylFrom, cylTo);
    final addCols = _generateRange(addFrom, addTo);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            _buildHeader(),
            // Filters
            _buildFilters(),
            // Eye Selector & Mode Badge
            _buildEyeSelectorAndMode(),
            // Matrix Table
            Expanded(child: _buildMatrixTable(sphRows, cylRows, addCols)),
            // Footer
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bulk Lens Order Matrix',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.product['productName'] ?? 'Unknown Product',
                style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
              ),
            ],
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFFF8FAFC),
      child: Row(
        children: [
          _buildFilterField('SPH From', sphFrom, (val) => setState(() => sphFrom = val)),
          _buildFilterField('SPH To', sphTo, (val) => setState(() => sphTo = val)),
          const SizedBox(width: 16),
          _buildFilterField('CYL From', cylFrom, (val) => setState(() => cylFrom = val)),
          _buildFilterField('CYL To', cylTo, (val) => setState(() => cylTo = val)),
          const SizedBox(width: 16),
          _buildFilterField('ADD From', addFrom, (val) => setState(() => addFrom = val)),
          _buildFilterField('ADD To', addTo, (val) => setState(() => addTo = val)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('DIA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                const SizedBox(height: 4),
                SizedBox(
                  height: 36,
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                      isDense: true,
                    ),
                    controller: TextEditingController(text: selectedDia),
                    onChanged: (val) => selectedDia = val,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () => setState(() {}),
            icon: const Icon(Icons.search, size: 16),
            label: const Text('Show'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterField(String label, double value, Function(double) onChanged) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 36,
            child: TextField(
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                isDense: true,
              ),
              controller: TextEditingController(text: value.toStringAsFixed(2)),
              onSubmitted: (val) => onChanged(double.tryParse(val) ?? 0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEyeSelectorAndMode() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          const Text(
            'SELECT EYE:',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: ['R/L', 'R', 'L'].map((eye) {
                bool isSelected = selectedEye == eye;
                return GestureDetector(
                  onTap: () => setState(() => selectedEye = eye),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF1E293B) : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: isSelected ? [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)] : null,
                    ),
                    child: Text(
                      eye,
                      style: TextStyle(
                        color: isSelected ? Colors.white : const Color(0xFF64748B),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(width: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: hasAdd ? const Color(0xFFEEF2FF) : const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(99),
            ),
            child: Text(
              hasAdd ? 'SPH+CYL × ADD Mode' : 'SPH × CYL Mode',
              style: TextStyle(
                color: hasAdd ? const Color(0xFF4338CA) : const Color(0xFF047857),
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatrixTable(List<String> sphRows, List<String> cylRows, List<String> addCols) {
    if (sphRows.isEmpty && cylRows.isEmpty) {
      return const Center(child: Text('Adjust filters and click Show to view matrix'));
    }

    return Scrollbar(
      controller: _verticalScrollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _verticalScrollController,
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(16),
        child: Scrollbar(
          controller: _horizontalScrollController,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _horizontalScrollController,
            scrollDirection: Axis.horizontal,
            child: hasAdd
                ? _buildWithAddTable(sphRows, cylRows, addCols)
                : _buildNoAddTable(sphRows, cylRows, addCols),
          ),
        ),
      ),
    );
  }

  Widget _buildWithAddTable(List<String> sphRows, List<String> cylRows, List<String> addCols) {
    final List<Map<String, String>> matrixRows = [];
    for (var sph in sphRows) {
      for (var cyl in cylRows) {
        matrixRows.add({'sph': sph, 'cyl': cyl});
      }
    }

    return Table(
      defaultColumnWidth: const IntrinsicColumnWidth(),
      border: TableBorder.all(color: const Color(0xFFE2E8F0)),
      children: [
        TableRow(
          decoration: const BoxDecoration(color: Color(0xFFF8FAFC)),
          children: [
            _buildTableHeaderCell('SPH'),
            _buildTableHeaderCell('CYL'),
            _buildTableHeaderCell('AXIS'),
            ...addCols.map((add) => _buildTableHeaderCell('ADD ${double.parse(add).toStringAsFixed(2)}')),
          ],
        ),
        ...matrixRows.asMap().entries.map((entry) {
          int rowIdx = entry.key;
          var row = entry.value;
          final rowKey = "${row['sph']}_${row['cyl']}";
          final rowData = matrixData[rowKey] ?? {'axis': '', 'adds': {}};

          return TableRow(
            children: [
              _buildTableCell(double.parse(row['sph']!).toStringAsFixed(2), bold: true),
              _buildTableCell(double.parse(row['cyl']!).toStringAsFixed(2), bold: true),
              _buildInputCell(
                value: rowData['axis'].toString(),
                onChanged: (val) => _handleAxisChange(row['sph']!, row['cyl']!, val),
              ),
              ...addCols.asMap().entries.map((addEntry) {
                int colIdx = addEntry.key;
                var add = addEntry.value;
                final qty = rowData['adds'][add] ?? '';
                return _buildInputCell(
                  value: qty.toString(),
                  onChanged: (val) => _handleQtyChange(row['sph']!, row['cyl']!, add, val),
                  isQty: true,
                  hasValue: qty.toString().isNotEmpty && (int.tryParse(qty.toString()) ?? 0) > 0,
                );
              }),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildNoAddTable(List<String> sphRows, List<String> cylRows, List<String> addCols) {
    final fixedAdd = addCols.isNotEmpty ? addCols[0] : "0.00";

    return Table(
      defaultColumnWidth: const IntrinsicColumnWidth(),
      border: TableBorder.all(color: const Color(0xFFE2E8F0)),
      children: [
        TableRow(
          decoration: const BoxDecoration(color: Color(0xFFF8FAFC)),
          children: [
            _buildTableHeaderCell('SPH \\ CYL'),
            ...cylRows.map((cyl) => _buildTableHeaderCell(double.parse(cyl).toStringAsFixed(2), color: const Color(0xFF2563EB))),
            _buildTableHeaderCell('ROW Σ', color: const Color(0xFF059669)),
          ],
        ),
        ...sphRows.asMap().entries.map((entry) {
          int sphIdx = entry.key;
          var sph = entry.value;
          int rowSum = 0;
          for (var cyl in cylRows) {
            rowSum += int.tryParse(matrixData["${sph}_$cyl"]?['adds'][fixedAdd]?.toString() ?? '0') ?? 0;
          }

          return TableRow(
            children: [
              _buildTableCell(double.parse(sph).toStringAsFixed(2), bold: true, bgColor: const Color(0xFFF8FAFC)),
              ...cylRows.asMap().entries.map((cylEntry) {
                int cylIdx = cylEntry.key;
                var cyl = cylEntry.value;
                final rowKey = "${sph}_$cyl";
                final qty = matrixData[rowKey]?['adds'][fixedAdd] ?? '';
                return _buildInputCell(
                  value: qty.toString(),
                  onChanged: (val) => _handleQtyChange(sph, cyl, fixedAdd, val),
                  isQty: true,
                  hasValue: qty.toString().isNotEmpty && (int.tryParse(qty.toString()) ?? 0) > 0,
                );
              }),
              _buildTableCell(rowSum.toString(), bold: true, color: rowSum > 0 ? const Color(0xFF059669) : const Color(0xFFCBD5E1), bgColor: const Color(0xFFECFDF5).withValues(alpha: 0.5)),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildTableHeaderCell(String text, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color ?? const Color(0xFF475569),
        ),
      ),
    );
  }

  Widget _buildTableCell(String text, {bool bold = false, Color? color, Color? bgColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      alignment: Alignment.center,
      color: bgColor,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          color: color ?? const Color(0xFF334155),
        ),
      ),
    );
  }

  Widget _buildInputCell({required String value, required Function(String) onChanged, bool isQty = false, bool hasValue = false}) {
    return Container(
      width: isQty ? 60 : 80,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: hasValue ? const Color(0xFFDBEAFE) : Colors.transparent,
      ),
      child: TextField(
        controller: TextEditingController(text: value)..selection = TextSelection.fromPosition(TextPosition(offset: value.length)),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: '-',
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          hintStyle: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 11),
        ),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: hasValue ? const Color(0xFF1D4ED8) : const Color(0xFF334155),
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildFooter() {
    int totalItems = 0;
    int totalQty = 0;
    matrixData.forEach((key, data) {
      final adds = data['adds'] as Map;
      adds.forEach((add, qtyStr) {
        final qty = int.tryParse(qtyStr.toString()) ?? 0;
        if (qty > 0) {
          totalItems++;
          totalQty += qty;
        }
      });
    });

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildFooterStat('Total Items:', totalItems.toString()),
              const SizedBox(width: 24),
              _buildFooterStat('Total Qty:', totalQty.toString()),
            ],
          ),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () => setState(() => matrixData = {}),
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Reset'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _handleSubmit,
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Items'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooterStat(String label, String value) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
        const SizedBox(width: 4),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
      ],
    );
  }
}
