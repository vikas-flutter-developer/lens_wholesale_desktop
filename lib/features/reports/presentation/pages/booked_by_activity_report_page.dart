import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:excel/excel.dart' as xl;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';
import '../../data/providers/inventory_report_provider.dart';
import '../../data/models/inventory_report_models.dart';

class BookedByActivityReportPage extends StatefulWidget {
  const BookedByActivityReportPage({super.key});

  @override
  State<BookedByActivityReportPage> createState() => _BookedByActivityReportPageState();
}

class _BookedByActivityReportPageState extends State<BookedByActivityReportPage> {
  DateTime _dateFrom = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime _dateTo = DateTime.now();
  String _selectedBookedBy = '';
  String _searchText = '';
  final TextEditingController _bookedByController = TextEditingController();
  final FocusNode _bookedByFocusNode = FocusNode();

  final Map<String, bool> _visibleCols = {
    'sn': true,
    'date': true,
    'time': true,
    'billNo': true,
    'bookedBy': true,
    'itemName': true,
    'eye': true,
    'sph': true,
    'cyl': true,
    'axis': true,
    'add': true,
    'remark': true,
    'qty': true,
    'netAmt': true,
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InventoryReportProvider>().fetchBookedByReport();
    });
  }

  @override
  void dispose() {
    _bookedByController.dispose();
    _bookedByFocusNode.dispose();
    super.dispose();
  }

  List<BookedByReportItem> get _filteredData {
    final provider = context.read<InventoryReportProvider>();
    final items = provider.bookedByItems ?? [];
    
    return items.where((item) {
      // Date filtering
      if (item.orderDate != null) {
        try {
          final date = DateTime.parse(item.orderDate!);
          if (date.isBefore(DateTime(_dateFrom.year, _dateFrom.month, _dateFrom.day)) ||
              date.isAfter(DateTime(_dateTo.year, _dateTo.month, _dateTo.day, 23, 59, 59))) {
            return false;
          }
        } catch (_) {}
      }

      // Booked By filtering
      if (_selectedBookedBy.isNotEmpty && item.bookedBy != _selectedBookedBy) {
        return false;
      }

      // Quick Search
      if (_searchText.isNotEmpty) {
        final q = _searchText.toLowerCase();
        final matches = (item.billNo?.toLowerCase().contains(q) ?? false) ||
                        (item.itemName?.toLowerCase().contains(q) ?? false) ||
                        (item.partyName?.toLowerCase().contains(q) ?? false) ||
                        (item.bookedBy?.toLowerCase().contains(q) ?? false);
        if (!matches) return false;
      }

      return true;
    }).toList();
  }

  List<Map<String, dynamic>> get _performanceStats {
    final data = _filteredData;
    final Map<String, Map<String, dynamic>> stats = {};

    for (var item in data) {
      final person = item.bookedBy;
      if (person == null || person.isEmpty) continue;

      if (!stats.containsKey(person)) {
        stats[person] = {'person': person, 'count': 0, 'totalQty': 0, 'totalAmount': 0.0};
      }
      stats[person]!['count'] += 1;
      stats[person]!['totalQty'] += item.qty;
      stats[person]!['totalAmount'] += item.netAmount;
    }

    final ranked = stats.values.toList();
    ranked.sort((a, b) => b['count'].compareTo(a['count']));
    return ranked;
  }


  String _getColumnLabel(String id) {
    switch (id) {
      case 'sn': return 'Sr. No.';
      case 'date': return 'Date';
      case 'time': return 'Time';
      case 'billNo': return 'Bill No.';
      case 'bookedBy': return 'Booked By';
      case 'itemName': return 'Item Name';
      case 'eye': return 'Eye';
      case 'sph': return 'Sph';
      case 'cyl': return 'Cyl';
      case 'axis': return 'Axis';
      case 'add': return 'Add';
      case 'remark': return 'Remark';
      case 'qty': return 'Qty';
      case 'netAmt': return 'Net Amt';
      default: return id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverToBoxAdapter(child: _buildFilters()),
          SliverToBoxAdapter(child: _buildActionToolbar()),
          SliverToBoxAdapter(child: _buildStats()),
          SliverToBoxAdapter(child: _buildResultSummary()),
          _buildTable(),
        ],
      ),
    );
  }

  Widget _buildActionToolbar() {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Row(
          children: [
            _buildActionButton('Export to Excel', LucideIcons.download, const Color(0xFF16A34A), _exportToExcel),
            const SizedBox(width: 12),
            _buildActionButton('Print', LucideIcons.printer, const Color(0xFF2563EB), _printReport),
            const SizedBox(width: 12),
            _buildActionButton('Reset', LucideIcons.rotateCcw, const Color(0xFF64748B), _handleReset),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.users, color: Color(0xFF2563EB), size: 32),
              const SizedBox(width: 12),
              const Text(
                'Booked By Activity Report',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Track and analyze booking person performance',
            style: TextStyle(fontSize: 15, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  void _handleReset() {
    debugPrint('Resetting filters');
    setState(() {
      _dateFrom = DateTime(DateTime.now().year, DateTime.now().month, 1);
      _dateTo = DateTime.now();
      _selectedBookedBy = '';
      _bookedByController.clear();
      _searchText = '';
    });
  }

  Widget _buildFilters() {
    final provider = context.watch<InventoryReportProvider>();
    final allPersons = (provider.bookedByItems ?? [])
        .map((e) => e.bookedBy)
        .whereType<String>()
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();
    allPersons.sort();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 15, offset: const Offset(0, 4))],
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(child: _buildDateFilter('Date From', _dateFrom, (d) => setState(() => _dateFrom = d))),
                const SizedBox(width: 16),
                Expanded(child: _buildDateFilter('Date To', _dateTo, (d) => setState(() => _dateTo = d))),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const LabelWithIcon(label: 'Booked By', icon: LucideIcons.users),
                      const SizedBox(height: 8),
                      RawAutocomplete<String>(
                        textEditingController: _bookedByController,
                        focusNode: _bookedByFocusNode,
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) {
                            return allPersons;
                          }
                          return allPersons.where((String option) {
                            return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                          });
                        },
                        onSelected: (String selection) {
                          setState(() => _selectedBookedBy = selection);
                        },
                        fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                          return TextField(
                            controller: controller,
                            focusNode: focusNode,
                            onTap: () {
                              if (controller.text.isEmpty) {
                                // This triggers the options menu to show all when empty on click
                                controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
                              }
                            },
                            decoration: InputDecoration(
                              hintText: 'Search or select...',
                              suffixIcon: const Icon(LucideIcons.chevronDown, size: 20, color: Color(0xFF94A3B8)),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              constraints: const BoxConstraints(maxHeight: 45),
                            ),
                          );
                        },
                        optionsViewBuilder: (context, onSelected, options) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Material(
                              elevation: 4.0,
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                width: 280, // Approximate width, can be improved with LayoutBuilder if needed
                                constraints: const BoxConstraints(maxHeight: 300),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                ),
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: options.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    final String option = options.elementAt(index);
                                    return InkWell(
                                      onTap: () => onSelected(option),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9)))),
                                        child: Text(option, style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B))),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const LabelWithIcon(label: 'Quick Search', icon: LucideIcons.search),
                      const SizedBox(height: 8),
                      TextField(
                        onChanged: (val) => setState(() => _searchText = val),
                        decoration: InputDecoration(
                          hintText: 'Bill No, Item, Party...',
                          suffixIcon: const Icon(LucideIcons.search, size: 20, color: Color(0xFF94A3B8)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          constraints: const BoxConstraints(maxHeight: 45),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildDateFilter(String label, DateTime date, Function(DateTime) onSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelWithIcon(label: label, icon: LucideIcons.calendar),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final d = await showDatePicker(context: context, initialDate: date, firstDate: DateTime(2000), lastDate: DateTime(2100));
            if (d != null) onSelected(d);
          },
          child: Container(
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE2E8F0)), borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat('dd-MM-yyyy').format(date), style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B))),
                const Icon(LucideIcons.calendar, size: 18, color: Color(0xFF94A3B8)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
    );
  }

  Widget _buildStats() {
    final stats = _performanceStats;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(LucideIcons.trendingUp, color: Color(0xFF2563EB), size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    'Performance Statistics',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                ],
              ),
              if (stats.isNotEmpty)
                Text(
                  'Top ${stats.length} Contributors',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (stats.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Column(
                children: [
                  Icon(LucideIcons.barChart, size: 32, color: Color(0xFFE2E8F0)),
                  SizedBox(height: 8),
                  Text('No statistics available for current filters', style: TextStyle(color: Color(0xFF94A3B8))),
                ],
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = (constraints.maxWidth / 300).floor().clamp(1, 4);
                double spacing = 16;
                double cardWidth = (constraints.maxWidth - (spacing * (crossAxisCount - 1))) / crossAxisCount;
                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: stats.map((stat) {
                    final index = stats.indexOf(stat);
                    return Container(
                      width: cardWidth,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFFEFF6FF), Color(0xFFDBEAFE)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFBFDBFE)),
                        boxShadow: [BoxShadow(color: const Color(0xFF2563EB).withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Text(stat['person'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF334155)), overflow: TextOverflow.ellipsis)),
                              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: const Color(0xFF2563EB), borderRadius: BorderRadius.circular(6)), child: Text('#${index + 1}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text('${stat['count']}', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildStatMini('Qty', '${stat['totalQty']}'),
                              _buildStatMini('Amount', '₹${stat['totalAmount'].toStringAsFixed(2)}'),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildStatMini(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
        Text(value, style: const TextStyle(fontSize: 12, color: Color(0xFF1E293B), fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildResultSummary() {
    final count = _filteredData.length;
    final String personSuffix = _selectedBookedBy.isNotEmpty ? ' for $_selectedBookedBy' : '';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE2E8F0))),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 13, color: Color(0xFF475569)),
            children: [
              const TextSpan(text: 'Showing '),
              TextSpan(text: '$count', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
              const TextSpan(text: ' booking records'),
              if (personSuffix.isNotEmpty) TextSpan(text: personSuffix, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
              TextSpan(text: ' from ${DateFormat('d/M/yyyy').format(_dateFrom)} to ${DateFormat('d/M/yyyy').format(_dateTo)}'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTable() {
    final provider = context.watch<InventoryReportProvider>();
    if (provider.isLoading) return const SliverToBoxAdapter(child: Center(child: Padding(padding: EdgeInsets.all(48), child: CircularProgressIndicator())));
    
    final data = _filteredData;
    if (data.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 48),
              const Icon(LucideIcons.users, size: 64, color: Color(0xFFE2E8F0)),
              const SizedBox(height: 16),
              const Text('No booking records found', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 16)),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(24),
      sliver: SliverToBoxAdapter(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
              ),
              clipBehavior: Clip.antiAlias,
              child: SelectionArea(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(const Color(0xFF1E293B)),
                      headingRowHeight: 48,
                      dataRowMinHeight: 48,
                      dataRowMaxHeight: 48,
                      columnSpacing: 24,
                      dividerThickness: 0.5,
                      columns: _visibleCols.keys.where((k) => _visibleCols[k]!).map((k) => DataColumn(
                        label: Text(
                          _getColumnLabel(k), 
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)
                        )
                      )).toList(),
                      rows: data.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final item = entry.value;
                        return DataRow(
                          color: WidgetStateProperty.resolveWith((states) => idx % 2 != 0 ? const Color(0xFFF8FAFC) : Colors.white),
                          cells: _visibleCols.keys.where((k) => _visibleCols[k]!).map((k) {
                            return DataCell(_buildCell(k, item, idx));
                          }).toList(),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCell(String id, BookedByReportItem item, int idx) {
    String text = '';
    switch (id) {
      case 'sn': text = '${idx + 1}'; break;
      case 'date': text = item.orderDate != null ? DateFormat('d/M/yyyy').format(DateTime.parse(item.orderDate!)) : '-'; break;
      case 'time': text = item.orderTime ?? '-'; break;
      case 'billNo': text = item.billNo ?? '-'; break;
      case 'bookedBy': return Text(item.bookedBy ?? '-', style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E293B), fontSize: 12));
      case 'itemName': text = item.itemName ?? '-'; break;
      case 'eye': text = item.eye ?? '-'; break;
      case 'sph': text = item.sph?.toString() ?? '-'; break;
      case 'cyl': text = item.cyl?.toString() ?? '-'; break;
      case 'axis': text = item.axis?.toString() ?? '-'; break;
      case 'add': text = item.add?.toString() ?? '-'; break;
      case 'remark': text = item.remark ?? '-'; break;
      case 'qty': text = item.qty.toString(); break;
      case 'netAmt': return Text('₹${item.netAmount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B), fontSize: 12));
    }
    return Text(text, style: const TextStyle(fontSize: 12, color: Color(0xFF475569)));
  }

  Future<void> _exportToExcel() async {
    final data = _filteredData;
    debugPrint('Exporting to Excel. Found ${data.length} records.');
    if (data.isEmpty) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No data found to export.')));
      return;
    }

    try {
      var excel = xl.Excel.createExcel();
      xl.Sheet sheetObject = excel['BookedByReport'];
      
      List<xl.CellValue> headers = _visibleCols.keys.where((k) => _visibleCols[k]!).map((k) => xl.TextCellValue(_getColumnLabel(k))).toList();
      sheetObject.appendRow(headers);

      for (int i = 0; i < data.length; i++) {
        final item = data[i];
        List<xl.CellValue> row = [];
        for (var k in _visibleCols.keys.where((k) => _visibleCols[k]!)) {
          switch (k) {
            case 'sn': row.add(xl.IntCellValue(i + 1)); break;
            case 'date': row.add(xl.TextCellValue(item.orderDate ?? '')); break;
            case 'time': row.add(xl.TextCellValue(item.orderTime ?? '')); break;
            case 'billNo': row.add(xl.TextCellValue(item.billNo ?? '')); break;
            case 'bookedBy': row.add(xl.TextCellValue(item.bookedBy ?? '')); break;
            case 'itemName': row.add(xl.TextCellValue(item.itemName ?? '')); break;
            case 'eye': row.add(xl.TextCellValue(item.eye ?? '')); break;
            case 'sph': row.add(xl.TextCellValue(item.sph?.toString() ?? '')); break;
            case 'cyl': row.add(xl.TextCellValue(item.cyl?.toString() ?? '')); break;
            case 'axis': row.add(xl.TextCellValue(item.axis?.toString() ?? '')); break;
            case 'add': row.add(xl.TextCellValue(item.add?.toString() ?? '')); break;
            case 'remark': row.add(xl.TextCellValue(item.remark ?? '')); break;
            case 'qty': row.add(xl.IntCellValue(item.qty)); break;
            case 'netAmt': row.add(xl.DoubleCellValue(item.netAmount)); break;
          }
        }
        sheetObject.appendRow(row);
      }

      String? outputFile = await FilePicker.saveFile(
        dialogTitle: 'Save Excel File',
        fileName: 'BookedByActivityReport.xlsx',
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );

      if (outputFile != null) {
        final bytes = excel.encode();
        if (bytes != null) {
          File(outputFile).writeAsBytesSync(bytes);
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Excel exported successfully!')));
        }
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error exporting excel: $e')));
    }
  }

  Future<void> _printReport() async {
    final data = _filteredData;
    debugPrint('Printing Report. Found ${data.length} records.');
    if (data.isEmpty) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No data found to print.')));
      return;
    }

    final pdf = pw.Document();
    final headers = _visibleCols.keys.where((k) => _visibleCols[k]!).map((k) => _getColumnLabel(k)).toList();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            pw.Header(level: 0, child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Booked By Activity Report', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
                pw.Text('Records: ${data.length}', style: const pw.TextStyle(fontSize: 12)),
              ],
            )),
            pw.SizedBox(height: 20),
            pw.TableHelper.fromTextArray(
              headers: headers,
              data: data.asMap().entries.map((entry) {
                final i = entry.key;
                final item = entry.value;
                return _visibleCols.keys.where((k) => _visibleCols[k]!).map((k) {
                  switch (k) {
                    case 'sn': return '${i + 1}';
                    case 'date': return item.orderDate ?? '';
                    case 'time': return item.orderTime ?? '';
                    case 'billNo': return item.billNo ?? '';
                    case 'bookedBy': return item.bookedBy ?? '';
                    case 'itemName': return item.itemName ?? '';
                    case 'eye': return item.eye ?? '';
                    case 'sph': return item.sph?.toString() ?? '';
                    case 'cyl': return item.cyl?.toString() ?? '';
                    case 'axis': return item.axis?.toString() ?? '';
                    case 'add': return item.add?.toString() ?? '';
                    case 'remark': return item.remark ?? '';
                    case 'qty': return item.qty.toString();
                    case 'netAmt': return item.netAmount.toStringAsFixed(2);
                    default: return '';
                  }
                }).toList();
              }).toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
              cellStyle: const pw.TextStyle(fontSize: 7),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
              cellAlignment: pw.Alignment.centerLeft,
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }
}

class LabelWithIcon extends StatelessWidget {
  final String label;
  final IconData icon;
  const LabelWithIcon({super.key, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF64748B)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF475569))),
      ],
    );
  }
}
