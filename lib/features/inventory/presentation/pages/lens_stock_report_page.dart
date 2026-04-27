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

import '../../../../core/network/loading_provider.dart';
import '../../../masters/data/providers/inventory_providers.dart';
import '../../../reports/data/models/lens_stock_report_models.dart';
import '../../../reports/data/providers/inventory_report_provider.dart';
import '../widgets/lens_power_matrix_view.dart';
import '../widgets/searchable_multi_select.dart';

enum LensReportViewMode { stockDetails, analysis }

class LensStockReportPage extends StatefulWidget {
  const LensStockReportPage({super.key});

  @override
  State<LensStockReportPage> createState() => _LensStockReportPageState();
}

class _LensStockReportPageState extends State<LensStockReportPage> with SingleTickerProviderStateMixin {
  LensReportViewMode _viewMode = LensReportViewMode.stockDetails;
  late TabController _analysisTabController;
  
  // Filter States
  String? _selectedGroupName;
  List<String> _selectedItemIds = [];
  List<String> _selectedPowerGroupIds = [];
  final TextEditingController _boxNoController = TextEditingController();
  final TextEditingController _barcodeController = TextEditingController();
  String _showQty = "All";
  String _eye = "All";
  bool _orderByAdd = false;
  bool _showEye = true;

  int _currentPage = 1;
  int _limit = 50;

  @override
  void initState() {
    super.initState();
    _analysisTabController = TabController(length: 3, vsync: this);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LensGroupProvider>().fetchAllLensPower();
      context.read<ItemMasterProvider>().fetchItems();
      _handleSearch();
    });
  }

  @override
  void dispose() {
    _analysisTabController.dispose();
    _boxNoController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  void _handleSearch() {
    final provider = context.read<InventoryReportProvider>();
    provider.fetchLensStockReport({
      'groupName': _selectedGroupName ?? '',
      'productName': '', // Added to match React
      'itemIds': _selectedItemIds,
      'powerGroupIds': _selectedPowerGroupIds,
      'boxNo': _boxNoController.text,
      'barcode': _barcodeController.text,
      'showQty': _showQty,
      'eye': _eye,
      'orderByAdd': _orderByAdd,
      'showEye': _showEye, // Added to match React
      'page': _currentPage,
      'limit': _limit,
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedGroupName = null;
      _selectedItemIds = [];
      _selectedPowerGroupIds = [];
      _boxNoController.clear();
      _barcodeController.clear();
      _showQty = "All";
      _eye = "All";
      _orderByAdd = false;
      _showEye = true;
      _currentPage = 1;
    });
    _handleSearch();
  }

  Future<void> _exportToExcel() async {
    final response = context.read<InventoryReportProvider>().lensStockResponse;
    if (response == null || response.data.isEmpty) return;

    final excel = xl.Excel.createExcel();
    final sheet = excel['Lens Stock Report'];
    excel.setDefaultSheet('Lens Stock Report');

    final header = [
      'S NO.', 'LENS NAME', 'GROUP NAME', 'SPH', 'CYL', 'AXIS', 'ADD', 'EYE', 
      'B.CODE', 'VERIFIED', 'ALERT QTY', 'EXCESS QTY', 'STOCK', 'PUR PRICE', 'SALE PRICE',
      'TTL AMT(P)', 'TTL AMT(S)'
    ];
    
    sheet.appendRow(header.map((e) => xl.TextCellValue(e)).toList());

    for (var i = 0; i < response.data.length; i++) {
      final row = response.data[i];
      sheet.appendRow([
        xl.IntCellValue(i + 1),
        xl.TextCellValue(row.productName ?? ''),
        xl.TextCellValue(row.groupName ?? ''),
        xl.TextCellValue(row.sph?.toString() ?? ''),
        xl.TextCellValue(row.cyl?.toString() ?? ''),
        xl.TextCellValue(row.axis?.toString() ?? ''),
        xl.TextCellValue(row.addValue?.toString() ?? ''),
        xl.TextCellValue(row.eye ?? ''),
        xl.TextCellValue(row.barcode ?? ''),
        xl.TextCellValue(row.isVerified == true ? 'Yes' : 'No'),
        xl.IntCellValue(row.alertQty ?? 0),
        xl.IntCellValue(row.excess_qty ?? 0),
        xl.IntCellValue(row.currentStock ?? 0),
        xl.DoubleCellValue(row.pPrice ?? 0.0),
        xl.DoubleCellValue(row.sPrice ?? 0.0),
        xl.DoubleCellValue((row.currentStock ?? 0) * (row.pPrice ?? 0.0)),
        xl.DoubleCellValue((row.currentStock ?? 0) * (row.sPrice ?? 0.0)),
      ]);
    }

    String? path = await FilePicker.saveFile(
      dialogTitle: 'Save Excel File',
      fileName: 'Lens_Stock_Report_${DateTime.now().millisecondsSinceEpoch}.xlsx',
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
    final response = context.read<InventoryReportProvider>().lensStockResponse;
    if (response == null || response.data.isEmpty) return;

    final doc = pw.Document();
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(10),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Text("Lens Stock Report - ${DateTime.now().toString().split('.')[0]}", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            ),
            pw.TableHelper.fromTextArray(
              headers: ['Lens Name', 'Group', 'Sph', 'Cyl', 'Add', 'Eye', 'Stock', 'Pur Price', 'Sale Price'],
              data: response.data.map((row) => [
                row.productName ?? '',
                row.groupName ?? '',
                row.sph?.toString() ?? '',
                row.cyl?.toString() ?? '',
                row.addValue?.toString() ?? '',
                row.eye ?? '',
                row.currentStock?.toString() ?? '0',
                row.pPrice?.toStringAsFixed(2) ?? '0.00',
                row.sPrice?.toStringAsFixed(2) ?? '0.00',
              ]).toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
              cellStyle: const pw.TextStyle(fontSize: 7),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => doc.save());
  }

  @override
    Widget build(BuildContext context) {
      final reportProvider = context.watch<InventoryReportProvider>();
      final lensProvider = context.watch<LensGroupProvider>();
      final itemProvider = context.watch<ItemMasterProvider>();
      final response = reportProvider.lensStockResponse;
      
      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _viewMode == LensReportViewMode.stockDetails 
                ? _buildStockDetailsView(reportProvider, lensProvider, itemProvider)
                : _buildAnalysisView(reportProvider, lensProvider, itemProvider),
            ),
            if (_viewMode == LensReportViewMode.stockDetails) _buildPaginationFooter(response),
          ],
        ),
      );
    }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(LucideIcons.barChart3, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Lens Stock Report",
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(LucideIcons.fileText, color: Colors.white.withOpacity(0.7), size: 14),
                          const SizedBox(width: 6),
                          const Text(
                            "Combined View With & Without Barcode Data",
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFFDBEAFE)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: 40),
                  // Tabs moved here
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E40AF).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Row(
                      children: [
                        _buildCapsuleToggle(
                          label: "STOCK DETAILS",
                          icon: LucideIcons.table,
                          isActive: _viewMode == LensReportViewMode.stockDetails,
                          onTap: () => setState(() => _viewMode = LensReportViewMode.stockDetails),
                        ),
                        _buildCapsuleToggle(
                          label: "ANALYSIS & SUMMARY",
                          icon: LucideIcons.pieChart,
                          isActive: _viewMode == LensReportViewMode.analysis,
                          onTap: () => setState(() => _viewMode = LensReportViewMode.analysis),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildActionButton(
                    icon: LucideIcons.fileSpreadsheet,
                    label: "Excel",
                    color: const Color(0xFF10B981),
                    textColor: Colors.white,
                    onTap: _exportToExcel,
                  ),
                  const SizedBox(width: 12),
                  _buildActionButton(
                    icon: LucideIcons.printer,
                    label: "Print",
                    color: Colors.white,
                    textColor: const Color(0xFF2563EB),
                    onTap: _printPdf,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required Color color, required Color textColor, required VoidCallback onTap}) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildCapsuleToggle({required String label, required IconData icon, required bool isActive, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isActive ? [const BoxShadow(color: Colors.black12, blurRadius: 4)] : null,
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: isActive ? const Color(0xFF1D4ED8) : const Color(0xFFDBEAFE)),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isActive ? const Color(0xFF1D4ED8) : const Color(0xFFDBEAFE),
                fontWeight: isActive ? FontWeight.w900 : FontWeight.w600,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterGrid(LensGroupProvider lensGroups, ItemMasterProvider items, InventoryReportProvider reports) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          // Row 1
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 2,
                child: _buildDropdownFilter(
                  label: "GROUP NAME",
                  value: _selectedGroupName,
                  items: lensGroups.lensGroups.map((l) => l.groupName).toSet().toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedGroupName = val;
                      _selectedPowerGroupIds = [];
                    });
                    if (val != null) reports.fetchPowerRangeLibrary(val);
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: SearchableMultiSelect<String>(
                  label: "ITEM NAME",
                  placeholder: "Select Items",
                  options: items.items.map((i) => SearchableMultiSelectItem(label: i.itemName, value: i.id!)).toList(),
                  selectedValues: _selectedItemIds,
                  onChanged: (vals) {
                    setState(() {
                      _selectedItemIds = vals;
                      if (vals.length == 1) {
                        final selectedId = vals[0];
                        final item = items.items.firstWhere((i) => i.id == selectedId);
                        if (item.groupName.isNotEmpty && (_selectedGroupName == null || _selectedGroupName!.isEmpty)) {
                          _selectedGroupName = item.groupName;
                          reports.fetchPowerRangeLibrary(item.groupName);
                        }
                      }
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 4,
                child: SearchableMultiSelect<String>(
                  label: "POWER GROUP",
                  placeholder: "Select Power Groups",
                  isLoading: reports.isLoadingLibrary,
                  options: reports.powerRangeLibrary.map((p) {
                    if (p is Map) {
                      return SearchableMultiSelectItem(label: p['label']?.toString() ?? 'N/A', value: p['_id']?.toString() ?? '');
                    }
                    return SearchableMultiSelectItem(label: p.toString(), value: p.toString());
                  }).toList(),
                  selectedValues: _selectedPowerGroupIds,
                  onChanged: (vals) => setState(() => _selectedPowerGroupIds = vals),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: _buildTextFilter("BOX NO", _boxNoController),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Row 2
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 2,
                child: _buildTextFilter("BARCODE", _barcodeController),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: _buildSimpleDropdown("SHOW QTY", _showQty, ["All", "Positive", "Negative", "Zero"], (v) => setState(() => _showQty = v!)),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: _buildSimpleDropdown("EYE", _eye, ["All", "R", "L", "RL", "Both"], (v) => setState(() => _eye = v!)),
              ),
              const SizedBox(width: 16),
              _buildCheckboxFilter("Order by Add", _orderByAdd, (v) => setState(() => _orderByAdd = v!)),
              const SizedBox(width: 12),
              _buildCheckboxFilter("Show Eye", _showEye, (v) => setState(() => _showEye = v!)),
              const Spacer(),
              SizedBox(
                width: 140,
                height: 40,
                child: ElevatedButton.icon(
                  onPressed: _handleSearch,
                  icon: const Icon(LucideIcons.search, size: 16),
                  label: const Text("Search", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(LucideIcons.rotateCcw, size: 18, color: Color(0xFF64748B)),
                  onPressed: _resetFilters,
                  tooltip: "Reset Filters",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownFilter({required String label, required String? value, required List<String> items, required Function(String?) onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE2E8F0)), borderRadius: BorderRadius.circular(8)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              hint: const Text("Select...", style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
              items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, style: const TextStyle(fontSize: 13)))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleDropdown(String label, String value, List<String> items, Function(String?) onChanged) {
    return _buildDropdownFilter(label: label, value: value, items: items, onChanged: onChanged);
  }

  Widget _buildTextFilter(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: "Enter $label",
            hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
          ),
          style: const TextStyle(fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildCheckboxFilter(String label, bool value, Function(bool?) onChanged) {
    return Row(
      children: [
        Checkbox(value: value, onChanged: onChanged, activeColor: Colors.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
      ],
    );
  }

  Widget _buildStockDetailsView(InventoryReportProvider provider, LensGroupProvider lensGroups, ItemMasterProvider items) {
    final response = provider.lensStockResponse;
    if (provider.isLoading) return const Center(child: CircularProgressIndicator());
    if (response == null || response.data.isEmpty) {
      return Column(
        children: [
          _buildFilterGrid(lensGroups, items, provider),
          const Expanded(child: Center(child: Text("No data found matching filters"))),
        ],
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final tableWidth = constraints.maxWidth > 1350.0 ? constraints.maxWidth : 1350.0;

        return Container(
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: tableWidth,
                    child: CustomScrollView(
                      slivers: [
                        // Filters as a scrollable sliver
                        SliverToBoxAdapter(
                          child: _buildFilterGrid(lensGroups, items, provider),
                        ),
                        // Sticky Header
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: _StickyTableHeaderDelegate(
                            child: _buildTableHeaders(tableWidth),
                          ),
                        ),
                        // Table Body
                        SliverToBoxAdapter(
                          child: Table(
                            columnWidths: _getTableColumnWidths(),
                            border: TableBorder.all(color: const Color(0xFFE2E8F0), width: 0.5),
                            children: response.data.asMap().entries.map((entry) {
                              return _buildDataRow(entry.key, entry.value);
                            }).toList(),
                          ),
                        ),
                        // Footer totals at the end of the list
                        SliverToBoxAdapter(
                          child: _buildGrandTotalFooter(response.totals),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Map<int, TableColumnWidth> _getTableColumnWidths() {
    return const {
      0: FixedColumnWidth(40),   // S No
      1: FlexColumnWidth(2),     // Lens Name (Flexible like React)
      2: FixedColumnWidth(100),  // Group Name
      3: FixedColumnWidth(50),   // SPH
      4: FixedColumnWidth(50),   // CYL
      5: FixedColumnWidth(40),   // Axis
      6: FixedColumnWidth(50),   // ADD
      7: FixedColumnWidth(40),   // EYE
      8: FlexColumnWidth(2),     // B.Code (Flexible like React)
      9: FixedColumnWidth(80),   // Verified
      10: FixedColumnWidth(60),  // Alert
      11: FixedColumnWidth(60),  // Excess
      12: FixedColumnWidth(65),  // Stock
      13: FixedColumnWidth(50),  // Min
      14: FixedColumnWidth(50),  // Max
      15: FixedColumnWidth(90),  // Pur Price
      16: FixedColumnWidth(90),  // Sale Price
      17: FixedColumnWidth(100), // Ttl Amt(P)
      18: FixedColumnWidth(100), // Ttl Amt(S)
    };
  }

  Widget _buildTableHeaders(double tableWidth) {
    final widths = _getTableColumnWidths();
    
    // Calculate 1 flex unit value
    double fixedTotal = 0;
    double flexTotal = 0;
    widths.forEach((_, width) {
      if (width is FixedColumnWidth) fixedTotal += width.value;
      if (width is FlexColumnWidth) flexTotal += width.value;
    });
    
    double flexUnitValue = (tableWidth - fixedTotal) / flexTotal;

    double getActualWidth(int start, int end) {
      double total = 0;
      for (int i = start; i <= end; i++) {
        final w = widths[i]!;
        if (w is FixedColumnWidth) total += w.value;
        if (w is FlexColumnWidth) total += w.value * flexUnitValue;
      }
      return total;
    }

    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Color(0xFF2563EB),
        border: Border(bottom: BorderSide(color: Colors.white24, width: 1)),
      ),
      child: Row(
        children: [
          _verticalHeaderCell("S NO.", width: getActualWidth(0, 0)),
          _verticalHeaderCell("LENS NAME", width: getActualWidth(1, 1)),
          _verticalHeaderCell("GROUP NAME", width: getActualWidth(2, 2)),
          
          _groupedHeaderCell("LENSE CONFIGURATION", width: getActualWidth(3, 7), children: [
            _subHeaderCell("SPH", width: getActualWidth(3, 3)),
            _subHeaderCell("CYL", width: getActualWidth(4, 4)),
            _subHeaderCell("AXIS", width: getActualWidth(5, 5)),
            _subHeaderCell("ADD", width: getActualWidth(6, 6)),
            _subHeaderCell("EYE", width: getActualWidth(7, 7)),
          ]),
          
          _verticalHeaderCell("B.CODE", width: getActualWidth(8, 8)),
          _verticalHeaderCell("VERIFIED", width: getActualWidth(9, 9)),
          
          _groupedHeaderCell("QUANTITY", width: getActualWidth(10, 14), children: [
            _subHeaderCell("ALERT", width: getActualWidth(10, 10)),
            _subHeaderCell("EXCESS QTY", width: getActualWidth(11, 11)),
            _subHeaderCell("STOCK", width: getActualWidth(12, 12)),
            _subHeaderCell("MIN", width: getActualWidth(13, 13)),
            _subHeaderCell("MAX", width: getActualWidth(14, 14)),
          ]),
          
          _groupedHeaderCell("PRICE", width: getActualWidth(15, 16), children: [
            _subHeaderCell("PUR PRICE", width: getActualWidth(15, 15)),
            _subHeaderCell("SALE PRICE", width: getActualWidth(16, 16)),
          ]),
          
          _groupedHeaderCell("AMOUNT", width: getActualWidth(17, 18), children: [
            _subHeaderCell("TTL AMT(P)", width: getActualWidth(17, 17)),
            _subHeaderCell("TTL AMT(S)", width: getActualWidth(18, 18)),
          ]),
        ],
      ),
    );
  }

  Widget _verticalHeaderCell(String label, {required double width}) {
    return Container(
      width: width,
      height: 80,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.white.withOpacity(0.1), width: 0.5)),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 0.5),
      ),
    );
  }

  Widget _groupedHeaderCell(String label, {required double width, required List<Widget> children}) {
    return Container(
      width: width,
      height: 80,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.white.withOpacity(0.1), width: 0.5)),
      ),
      child: Column(
        children: [
          Container(
            height: 45,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.1), width: 0.5)),
            ),
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 0.5),
            ),
          ),
          Container(
            height: 34, // 80 - 45 - 1(border)
            color: const Color(0xFF3B82F6),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              child: Row(children: children),
            ),
          ),
        ],
      ),
    );
  }

  Widget _subHeaderCell(String label, {required double width}) {
    return Container(
      width: width,
      height: double.infinity,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.white.withOpacity(0.1), width: 0.5)),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Color(0xFFDBEAFE), fontWeight: FontWeight.w800, fontSize: 9, letterSpacing: 0.2),
      ),
    );
  }

  TableRow _buildDataRow(int index, LensStockRow row) {
    final bgColor = index % 2 == 0 ? Colors.white : const Color(0xFFF8FAFC);
    final ttlAmtP = (row.currentStock ?? 0) * (row.pPrice ?? 0.0);
    final ttlAmtS = (row.currentStock ?? 0) * (row.sPrice ?? 0.0);

    return TableRow(
      decoration: BoxDecoration(color: bgColor),
      children: [
        _dataCell("${((_currentPage - 1) * _limit) + index + 1}", alignment: Alignment.center, size: 11),
        _dataCell(row.productName ?? '—', weight: FontWeight.w600, color: const Color(0xFF1E293B), size: 11),
        _dataCell(row.groupName ?? '—', size: 11, color: const Color(0xFF64748B)),
        _dataCell(row.sph?.toStringAsFixed(2) ?? '0.00', alignment: Alignment.center, color: const Color(0xFF0F172A), weight: FontWeight.w700, size: 11),
        _dataCell(row.cyl?.toStringAsFixed(2) ?? '0.00', alignment: Alignment.center, color: const Color(0xFF0F172A), weight: FontWeight.w700, size: 11),
        _dataCell("${row.axis ?? 0}", alignment: Alignment.center, size: 11),
        _dataCell(row.addValue?.toStringAsFixed(2) ?? '0.00', alignment: Alignment.center, color: const Color(0xFF0F172A), weight: FontWeight.w700, size: 11),
        _dataCell(row.eye ?? '—', alignment: Alignment.center, size: 10, color: const Color(0xFF64748B)),
        _dataCell(row.barcode ?? '—', color: const Color(0xFF2563EB), size: 10, isMono: true),
        _verifiedCell(row),
        _dataCell("${row.alertQty ?? 0}", alignment: Alignment.center, color: const Color(0xFFDC2626), weight: FontWeight.w700, size: 11),
        _dataCell("${row.excess_qty ?? 0}", alignment: Alignment.center, color: (row.excess_qty ?? 0) > 0 ? const Color(0xFF16A34A) : const Color(0xFFDC2626), weight: FontWeight.w700, size: 11),
        _dataCell("${row.currentStock ?? 0}", alignment: Alignment.center, color: const Color(0xFF15803D), weight: FontWeight.w900, size: 12),
        _dataCell("${row.alertQty ?? 0}", alignment: Alignment.center, color: const Color(0xFF94A3B8), size: 11),
        _dataCell("0", alignment: Alignment.center, color: const Color(0xFF94A3B8), size: 11),
        _dataCell("₹${row.pPrice?.toStringAsFixed(2) ?? '0.00'}", alignment: Alignment.centerRight, size: 11),
        _dataCell("₹${row.sPrice?.toStringAsFixed(2) ?? '0.00'}", alignment: Alignment.centerRight, weight: FontWeight.w600, size: 11),
        _dataCell("₹${ttlAmtP.toStringAsFixed(2)}", alignment: Alignment.centerRight, color: const Color(0xFF475569), weight: FontWeight.w700, size: 11),
        _dataCell("₹${ttlAmtS.toStringAsFixed(2)}", alignment: Alignment.centerRight, color: const Color(0xFF1D4ED8), weight: FontWeight.w800, size: 11),
      ],
    );
  }

  Widget _dataCell(String text, {Alignment alignment = Alignment.centerLeft, Color color = const Color(0xFF334155), FontWeight weight = FontWeight.normal, double size = 11, bool isMono = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      alignment: alignment,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: const Color(0xFFE2E8F0).withOpacity(0.5), width: 0.5)),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color, 
          fontWeight: weight, 
          fontSize: size, 
          fontFamily: isMono ? 'monospace' : null,
        ),
      ),
    );
  }

  Widget _verifiedCell(LensStockRow row) {
    if (row.isVerified != true) return _dataCell("—", alignment: Alignment.center);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(LucideIcons.check, color: Colors.green, size: 14),
          if (row.lastVerifiedDate != null)
            Text(
              row.lastVerifiedDate!.split('T')[0],
              style: const TextStyle(fontSize: 8, color: Colors.grey),
            ),
        ],
      ),
    );
  }

  Widget _buildAnalysisView(InventoryReportProvider provider, LensGroupProvider lensGroups, ItemMasterProvider items) {
    final response = provider.lensStockResponse;
    if (provider.isLoading) return const Center(child: CircularProgressIndicator());
    if (response == null || response.data.isEmpty) {
      return Column(
        children: [
          _buildFilterGrid(lensGroups, items, provider),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.barChart2, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  const Text("No Data for Analysis", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8))),
                  const Text("Search and select items to generate insights", style: TextStyle(color: Color(0xFF94A3B8))),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        _buildFilterGrid(lensGroups, items, provider),
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _analysisTabController,
            labelColor: Colors.blue,
            unselectedLabelColor: const Color(0xFF64748B),
            indicatorColor: Colors.blue,
            indicatorWeight: 3,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            tabs: const [
              Tab(text: "SPH/CYL MATRIX"),
              Tab(text: "EYE WISE SUMMARY"),
              Tab(text: "GROUP SUMMARY"),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _analysisTabController,
            children: [
              _buildMatrixTab(response.data),
              _buildEyeSummaryTab(response.data),
              _buildGroupSummaryTab(response.data),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMatrixTab(List<LensStockRow> data) {
    // Map LensStockRow to the format expected by LensPowerMatrixView
    final matrixData = data.map((r) => {
      'sph': double.tryParse(r.sph?.toString() ?? '0') ?? 0.0,
      'cyl': double.tryParse(r.cyl?.toString() ?? '0') ?? 0.0,
      'stock': r.currentStock ?? 0,
    }).toList();
    
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: LensPowerMatrixView(reportData: matrixData),
    );
  }

  Widget _buildEyeSummaryTab(List<LensStockRow> data) {
    final rData = data.where((r) => r.eye == 'R').toList();
    final lData = data.where((r) => r.eye == 'L').toList();
    final otherData = data.where((r) => r.eye != 'R' && r.eye != 'L').toList();

    return _buildSummaryTable(
      title: "EYE WISE SUMMARY",
      color: Colors.blue,
      headers: ["EYE", "TOTAL ITEMS", "TOTAL QUANTITY", "TOTAL VALUE (SALE)"],
      rows: [
        if (rData.isNotEmpty) _buildEyeSummaryRow("👁️ Right", rData, Colors.blue),
        if (lData.isNotEmpty) _buildEyeSummaryRow("👁️ Left", lData, Colors.indigo),
        if (otherData.isNotEmpty) _buildEyeSummaryRow("Not Specified", otherData, Colors.blueGrey),
      ],
      footer: _buildEyeSummaryFooter(data),
    );
  }

  List<String> _buildEyeSummaryRow(String label, List<LensStockRow> data, Color color) {
    final totalQty = data.fold(0, (sum, r) => sum + (r.currentStock ?? 0));
    final totalValue = data.fold(0.0, (sum, r) => sum + ((r.currentStock ?? 0) * (r.sPrice ?? 0.0)));
    return [label, data.length.toString(), totalQty.toString(), "₹${totalValue.toStringAsFixed(2)}"];
  }

  List<String> _buildEyeSummaryFooter(List<LensStockRow> data) {
    final totalQty = data.fold(0, (sum, r) => sum + (r.currentStock ?? 0));
    final totalValue = data.fold(0.0, (sum, r) => sum + ((r.currentStock ?? 0) * (r.sPrice ?? 0.0)));
    return ["GRAND TOTAL", "", totalQty.toString(), "₹${totalValue.toStringAsFixed(2)}"];
  }

  Widget _buildGroupSummaryTab(List<LensStockRow> data) {
    final groups = data.map((r) => r.groupName).toSet().toList()..sort();
    
    return _buildSummaryTable(
      title: "GROUP WISE SUMMARY",
      color: Colors.purple,
      headers: ["GROUP NAME", "ITEMS", "TOTAL QTY", "PUR VALUE", "SALE VALUE"],
      rows: groups.map((g) {
        final gData = data.where((r) => r.groupName == g).toList();
        final totalQty = gData.fold(0, (sum, r) => sum + (r.currentStock ?? 0));
        final purValue = gData.fold(0.0, (sum, r) => sum + ((r.currentStock ?? 0) * (r.pPrice ?? 0.0)));
        final saleValue = gData.fold(0.0, (sum, r) => sum + ((r.currentStock ?? 0) * (r.sPrice ?? 0.0)));
        return [g ?? 'N/A', gData.length.toString(), totalQty.toString(), "₹${purValue.toStringAsFixed(2)}", "₹${saleValue.toStringAsFixed(2)}"];
      }).toList(),
      footer: [
        "TOTAL",
        "",
        data.fold(0, (sum, r) => sum + (r.currentStock ?? 0)).toString(),
        "₹${data.fold(0.0, (sum, r) => sum + ((r.currentStock ?? 0) * (r.pPrice ?? 0.0))).toStringAsFixed(2)}",
        "₹${data.fold(0.0, (sum, r) => sum + ((r.currentStock ?? 0) * (r.sPrice ?? 0.0))).toStringAsFixed(2)}"
      ],
    );
  }

  Widget _buildSummaryTable({required String title, required Color color, required List<String> headers, required List<List<String>> rows, required List<String> footer}) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: color,
              child: Row(children: [Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1))]),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Table(
                  border: TableBorder.all(color: const Color(0xFFF1F5F9)),
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: color.withOpacity(0.05)),
                      children: headers.map((h) => Padding(padding: const EdgeInsets.all(12.0), child: Text(h, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: color)))).toList(),
                    ),
                    ...rows.map((row) => TableRow(
                      children: row.map((cell) => Padding(padding: const EdgeInsets.all(12.0), child: Text(cell, style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B))))).toList(),
                    )),
                    TableRow(
                      decoration: BoxDecoration(color: color.withOpacity(0.1)),
                      children: footer.map((f) => Padding(padding: const EdgeInsets.all(12.0), child: Text(f, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: color)))).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationFooter(LensStockReportResponse? response) {
    if (response == null) return const SizedBox.shrink();
    final totalPages = (response.total / _limit).ceil();
    final startEntry = response.data.isEmpty ? 0 : ((_currentPage - 1) * _limit) + 1;
    final endEntry = startEntry + response.data.length - 1;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Showing $startEntry to $endEntry of ${response.total} records", 
            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
          ),
          Row(
            children: [
              const Text("Rows:", style: TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
              const SizedBox(width: 8),
              Container(
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.white,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: _limit,
                    isDense: true,
                    icon: const Icon(LucideIcons.chevronDown, size: 14, color: Color(0xFF64748B)),
                    style: const TextStyle(fontSize: 12, color: Color(0xFF1E293B), fontWeight: FontWeight.w700),
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    items: [50, 100, 200, 500].map((l) => DropdownMenuItem(
                      value: l, 
                      child: Text(l.toString()),
                    )).toList(),
                    onChanged: (v) {
                      if (v != null) {
                        setState(() {
                          _limit = v;
                          _currentPage = 1;
                        });
                        _handleSearch();
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: 24),
              _pageButton(LucideIcons.chevronLeft, _currentPage > 1 ? () { setState(() => _currentPage--); _handleSearch(); } : null),
              const SizedBox(width: 8),
              ..._buildPageNumbers(totalPages),
              const SizedBox(width: 8),
              _pageButton(LucideIcons.chevronRight, _currentPage < totalPages ? () { setState(() => _currentPage++); _handleSearch(); } : null),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageNumbers(int totalPages) {
    List<Widget> buttons = [];
    int startPage = (_currentPage - 2).clamp(1, totalPages);
    int endPage = (startPage + 4).clamp(1, totalPages);
    
    if (endPage - startPage < 4) {
      startPage = (endPage - 4).clamp(1, totalPages);
    }

    for (int i = startPage; i <= endPage; i++) {
      buttons.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: _pageNumButton(i, i == _currentPage),
        ),
      );
    }
    return buttons;
  }

  Widget _pageNumButton(int page, bool isActive) {
    return InkWell(
      onTap: isActive ? null : () {
        setState(() => _currentPage = page);
        _handleSearch();
      },
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF2563EB) : Colors.white,
          border: Border.all(color: isActive ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          "$page",
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive ? Colors.white : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  Widget _pageButton(IconData icon, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: onTap == null ? const Color(0xFFF1F5F9) : Colors.white,
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 14, color: onTap == null ? const Color(0xFFCBD5E1) : const Color(0xFF64748B)),
      ),
    );
  }

  Widget _buildGrandTotalFooter(LensStockTotals totals) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFF2563EB), width: 2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text(
            "GRAND TOTAL", 
            style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 1.5),
          ),
          const SizedBox(width: 40),
          _buildTotalItem("Stock", totals.stockTotal.toString(), const Color(0xFF1D4ED8)),
          const SizedBox(width: 32),
          _buildTotalItem("Pur Value", "₹${totals.purValueTotal.toStringAsFixed(2)}", const Color(0xFF16A34A)),
          const SizedBox(width: 32),
          _buildTotalItem("Sale Value", "₹${totals.saleValueTotal.toStringAsFixed(2)}", const Color(0xFF1D4ED8)),
        ],
      ),
    );
  }

  Widget _buildTotalItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(), 
          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 0.5),
        ),
        Text(
          value, 
          style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.w900),
        ),
      ],
    );
  }
}

class _StickyTableHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _StickyTableHeaderDelegate({required this.child});

  @override
  double get minExtent => 80;
  @override
  double get maxExtent => 80;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(_StickyTableHeaderDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}
