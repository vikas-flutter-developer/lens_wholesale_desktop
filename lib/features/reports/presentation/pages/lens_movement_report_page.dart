import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';

import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../data/providers/inventory_report_provider.dart';
import '../../data/models/inventory_report_models.dart';
import '../../../masters/data/providers/inventory_providers.dart';
import '../../../masters/data/providers/account_provider.dart';

class LensMovementReportPage extends StatefulWidget {
  const LensMovementReportPage({super.key});

  @override
  State<LensMovementReportPage> createState() => _LensMovementReportPageState();
}

class _LensMovementReportPageState extends State<LensMovementReportPage> {
  final TextEditingController _itemSearchCtrl = TextEditingController();
  final TextEditingController _barcodeSearchCtrl = TextEditingController();
  final TextEditingController _partySearchCtrl = TextEditingController();

  // Scroll Controllers for horizontal tables
  final ScrollController _inwardScrollCtrl = ScrollController();
  final ScrollController _outwardScrollCtrl = ScrollController();

  DateTime _fromDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _toDate = DateTime.now();
  String _groupName = '';
  String _itemName = '';
  String _barcode = '';
  String _partyName = '';
  String _searchType = 'All I/O Movement'; // Updated to match React

  // Lens Power Filters
  String _eye = '';
  String _sph = '';
  String _cyl = '';
  String _axis = '';
  String _add = '';

  // Column Visibility State
  Map<String, bool> _columns = {
    'sno': true,
    'date': true,
    'transType': true,
    'voucherNo': true,
    'partyName': true,
    'groupName': true,
    'itemName': true,
    'barcode': true,
    'eye': true,
    'sph': true,
    'cyl': true,
    'axis': true,
    'add': true,
    'opening': true,
    'inwards': true,
    'outwards': true,
    'closing': true,
    'price': true,
    'action': true,
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountProvider>().fetchAllAccounts();
      context.read<ItemGroupProvider>().fetchGroups();
      context.read<ItemMasterProvider>().fetchItems();
    });
  }

  @override
  void dispose() {
    _itemSearchCtrl.dispose();
    _barcodeSearchCtrl.dispose();
    _partySearchCtrl.dispose();
    _inwardScrollCtrl.dispose();
    _outwardScrollCtrl.dispose();
    super.dispose();
  }

  void _handleSearch() {
    final Map<String, dynamic> filters = {
      'dateFrom': DateFormat('yyyy-MM-dd').format(_fromDate),
      'dateTo': DateFormat('yyyy-MM-dd').format(_toDate),
      'groupName': _groupName.isEmpty ? null : _groupName,
      'productName': _itemName.isEmpty ? null : _itemName,
      'barcode': _barcode.isEmpty ? null : _barcode,
      'partyName': _partyName.isEmpty ? null : _partyName,
      'searchType': _searchType,
      'eye': _eye.isEmpty ? null : _eye,
      'sph': _sph.isEmpty ? null : _sph,
      'cyl': _cyl.isEmpty ? null : _cyl,
      'axis': _axis.isEmpty ? null : _axis,
      'add': _add.isEmpty ? null : _add,
    };
    context.read<InventoryReportProvider>().fetchLensMovementReport(filters);
  }

  List<LensMovementItem> _processMovementData(LensMovementReportData data) {
    List<LensMovementItem> allMovements = [];
    
    // Combine and sort by date
    allMovements.addAll(data.purchaseData.map((e) => e.copyWith(mType: 'inward')));
    allMovements.addAll(data.saleData.map((e) => e.copyWith(mType: 'outward')));
    
    allMovements.sort((a, b) {
      final dateA = DateTime.tryParse(a.date ?? '') ?? DateTime(2000);
      final dateB = DateTime.tryParse(b.date ?? '') ?? DateTime(2000);
      return dateA.compareTo(dateB);
    });

    double runningBalance = data.openingStock;
    return allMovements.map((item) {
      double inward = item.mType == 'inward' ? item.quantity : 0;
      double outward = item.mType == 'outward' ? item.quantity : 0;
      
      double prevBalance = runningBalance;
      runningBalance = runningBalance + inward - outward;
      
      return item.copyWith(
        opening: prevBalance,
        inwardQty: inward,
        outwardQty: outward,
        closing: runningBalance,
      );
    }).toList();
  }

  Future<void> _exportToCSV(List<LensMovementItem> items, double opening, double closing) async {
    List<List<dynamic>> rows = [];
    rows.add([
      "Date", "Trans Type", "Vch No", "Party Name", "Item Name", 
      "Power", "Opening", "Inward", "Outward", "Closing"
    ]);

    for (var item in items) {
      String power = "${item.eye} S:${item.sph} C:${item.cyl} A:${item.axis} Ad:${item.add}";
      rows.add([
        item.date ?? '',
        item.transType ?? '',
        item.voucherNo ?? '',
        item.partyName ?? '',
        item.itemName,
        power,
        item.opening,
        item.inwardQty,
        item.outwardQty,
        item.closing,
      ]);
    }

    String csvData = rows.map((row) => row.map((cell) => '"${cell.toString().replaceAll('"', '"""')}"').join(',')).join('\n');
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = "${directory.path}/Lens_Movement_${DateTime.now().millisecondsSinceEpoch}.csv";
      final file = File(path);
      await file.writeAsString(csvData);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Exported to $path')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(LucideIcons.package, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('Item Movement Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        elevation: 0,
        backgroundColor: const Color(0xFF2563EB), // Blue-600
        foregroundColor: Colors.white,
        actions: [
          Consumer<InventoryReportProvider>(
            builder: (context, provider, _) => IconButton(
            icon: const Icon(LucideIcons.printer, size: 18),
            onPressed: _handlePrint,
            tooltip: 'Print',
          ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<InventoryReportProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              _buildFilterSection(),
              if (provider.isLoading)
                const Expanded(child: Center(child: CircularProgressIndicator()))
              else if (provider.lensMovementData == null)
                const Expanded(child: Center(child: Text('Select filters and click search to view report')))
              else
                Expanded(child: _buildReportContent(provider.lensMovementData!)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              _filterItem('SEARCH TYPE', _dropdown(_searchType, ['All I/O Movement', 'Item Movement', 'Item Unmovement'], (v) => setState(() => _searchType = v!))),
              const SizedBox(width: 12),
              _filterItem('DATE FROM', _datePicker(_fromDate, (d) => setState(() => _fromDate = d))),
              const SizedBox(width: 12),
              _filterItem('TO', _datePicker(_toDate, (d) => setState(() => _toDate = d))),
              const SizedBox(width: 12),
              Expanded(child: _filterItem('', _groupAutocomplete())),
              const SizedBox(width: 12),
              Expanded(child: _filterItem('', _itemAutocomplete())),
              const SizedBox(width: 12),
              Expanded(child: _filterItem('', _textField('Barcode', (v) => _barcode = v))),
              const SizedBox(width: 12),
              Expanded(child: _filterItem('', _partyAutocomplete())),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _miniInput('Eye', _eye, (v) => setState(() => _eye = v)),
              const SizedBox(width: 4),
              _miniInput('Sph', _sph, (v) => setState(() => _sph = v)),
              const SizedBox(width: 4),
              _miniInput('Cyl', _cyl, (v) => setState(() => _cyl = v)),
              const SizedBox(width: 4),
              _miniInput('Axis', _axis, (v) => setState(() => _axis = v)),
              const SizedBox(width: 4),
              _miniInput('Add', _add, (v) => setState(() => _add = v)),
              const SizedBox(width: 16),
              _actionBtn("Search", const Color(0xFFF1F5F9), const Color(0xFF475569), LucideIcons.search, _handleSearch, isOutline: true),
              const SizedBox(width: 8),
              _actionBtn("Reset", const Color(0xFF38BDF8), Colors.white, LucideIcons.rotateCcw, _handleReset, isSolid: true),
              const SizedBox(width: 8),
              _actionBtn("Excel", const Color(0xFF16A34A), Colors.white, LucideIcons.fileSpreadsheet, _handleExcel, isSolid: true),
              const SizedBox(width: 8),
              _actionBtn("COLUMNS", Colors.white, const Color(0xFF64748B), LucideIcons.layout, () => _showColumnsVisibilityPopup(context), isOutline: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionBtn(String label, Color bg, Color fg, IconData icon, VoidCallback onTap, {bool isSolid = false, bool isOutline = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(4),
          border: isOutline ? Border.all(color: const Color(0xFFCBD5E1)) : null,
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: fg),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: fg)),
          ],
        ),
      ),
    );
  }

  void _handleExcel() {
    final provider = context.read<InventoryReportProvider>();
    if (provider.lensMovementData != null) {
      _exportToCSV(_processMovementData(provider.lensMovementData!), provider.lensMovementData!.openingStock, provider.lensMovementData!.closingStock);
    }
  }

  void _handleReset() {
    setState(() {
      _fromDate = DateTime.now().subtract(const Duration(days: 30));
      _toDate = DateTime.now();
      _groupName = '';
      _itemName = '';
      _barcode = '';
      _partyName = '';
      _itemSearchCtrl.clear();
      _partySearchCtrl.clear();
      _barcodeSearchCtrl.clear();
      _eye = ''; _sph = ''; _cyl = ''; _axis = ''; _add = '';
    });
    context.read<InventoryReportProvider>().resetAll();
  }

  Future<void> _handlePrint() async {
    final provider = context.read<InventoryReportProvider>();
    final data = provider.lensMovementData;
    if (data == null) return;

    final allMovements = _processMovementData(data);
    
    final pdf = pw.Document();
    
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Item Movement Details', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18)),
                pw.Text('Date: ${DateFormat('dd-MM-yyyy').format(_fromDate)} to ${DateFormat('dd-MM-yyyy').format(_toDate)}'),
              ],
            ),
          ),
          pw.Row(
            children: [
              pw.Text('Opening Stock: ${data.openingStock.toStringAsFixed(0)}   ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.orange)),
              pw.Text('Closing Stock: ${data.closingStock.toStringAsFixed(0)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.orange)),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.TableHelper.fromTextArray(
            headers: ['SNO', 'Date', 'Type', 'Voucher', 'Party', 'Item', 'Code', 'Eye', 'SPH', 'CYL', 'AXIS', 'ADD', 'In Qty', 'Out Qty', 'Closing'],
            data: allMovements.asMap().entries.map((entry) {
              final i = entry.value;
              return [
                (entry.key + 1).toString(),
                i.date != null ? DateFormat('dd/MM/yy').format(DateTime.tryParse(i.date!) ?? DateTime.now()) : '-',
                i.transType ?? '-',
                i.voucherNo ?? '-',
                i.partyName ?? '-',
                i.itemName,
                i.barcode ?? '-',
                i.eye ?? '-',
                i.sph?.toString() ?? '-',
                i.cyl?.toString() ?? '-',
                i.axis?.toString() ?? '-',
                i.add?.toString() ?? '-',
                i.inwardQty != 0 ? i.inwardQty.abs().toStringAsFixed(0) : '-',
                i.outwardQty != 0 ? i.outwardQty.abs().toStringAsFixed(0) : '-',
                i.closing.toStringAsFixed(0),
              ];
            }).toList(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
            cellStyle: const pw.TextStyle(fontSize: 7),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
            cellAlignment: pw.Alignment.center,
          ),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  void _handleView(LensMovementItem item) {
    String? route;
    if (item.transType == 'Purchase Invoice') {
      route = '/lenstransaction/purchase/AddLensPurchase/${item.docId}';
    } else if (item.transType == 'Sale Invoice') {
      route = '/lenstransaction/sale/AddLensSale/${item.docId}';
    }

    if (route != null) {
      context.push(route);
    }
  }

  void _showColumnsVisibilityPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Visible Columns', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              content: SizedBox(
                width: 300,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _columns.keys.map((key) {
                      return CheckboxListTile(
                        title: Text(key.replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(0)}').toUpperCase(), style: const TextStyle(fontSize: 12)),
                        value: _columns[key],
                        dense: true,
                        onChanged: (val) {
                          setDialogState(() => _columns[key] = val!);
                          setState(() {}); // Update main page
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildReportContent(LensMovementReportData data) {
    final allMovements = _processMovementData(data);
    final inwardList = allMovements.where((e) => e.mType == 'inward').toList();
    final outwardList = allMovements.where((e) => e.mType == 'outward').toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Opening / Closing Summary
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.white,
          child: Row(
            children: [
              const Text("Opening stock : ", style: TextStyle(color: Color(0xFFEA580C), fontWeight: FontWeight.bold, fontSize: 12)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFFFF7ED), borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xFFFED7AA))),
                child: Text(data.openingStock.toStringAsFixed(0), style: const TextStyle(color: Color(0xFFEA580C), fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 24),
              const Text("Closing stock : ", style: TextStyle(color: Color(0xFFEA580C), fontWeight: FontWeight.bold, fontSize: 12)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFFFF7ED), borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xFFFED7AA))),
                child: Text(data.closingStock.toStringAsFixed(0), style: const TextStyle(color: Color(0xFFEA580C), fontWeight: FontWeight.bold)),
              ),
              const Spacer(),
              const Text("Note: Initial stock is not included", style: TextStyle(color: Colors.red, fontStyle: FontStyle.italic, fontSize: 11)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (_searchType != 'Item Unmovement') ...[
                  _buildSectionTable('Purchase & Inward Movements', const Color(0xFF059669), LucideIcons.arrowDownCircle, inwardList, true, controller: _inwardScrollCtrl),
                  const SizedBox(height: 24),
                  _buildSectionTable('Sale & Outward Movements', const Color(0xFFDC2626), LucideIcons.arrowUpCircle, outwardList, false, controller: _outwardScrollCtrl),
                  const SizedBox(height: 24),
                ] else ...[
                  _buildUnmovedTable(data.unmovedItems),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUnmovedTable(List<UnmovedItem> items) {
    // Map UnmovedItem to LensMovementItem for reusing _buildSectionTable logic
    final mappedItems = items.map((e) => LensMovementItem(
      itemName: e.itemName ?? e.productName ?? '',
      groupName: e.groupName ?? e.group,
      barcode: e.barcode,
      eye: e.eye,
      sph: e.sph,
      cyl: e.cyl,
      axis: e.axis,
      add: e.add,
      opening: e.currentStock,
      closing: e.currentStock,
      price: e.price,
      unit: e.unit,
      transType: 'Unmoved',
    )).toList();

    return _buildSectionTable('Unmoved Items Summary', Colors.grey, LucideIcons.package, mappedItems, false, emptyMessage: 'No unmoved items found for the selected criteria');
  }

  Widget _buildSectionTable(String title, Color color, IconData icon, List<LensMovementItem> items, bool isInward, {String emptyMessage = 'No movements found', ScrollController? controller}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              border: Border(bottom: BorderSide(color: color.withOpacity(0.1))),
            ),
            child: Row(
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 8),
                Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          ),
          // Table layout
          Scrollbar(
            thumbVisibility: true,
            controller: controller,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: controller,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTableHeaderRow(),
                  if (items.isEmpty)
                    Container(
                      width: 1000, // Reduced approximate width
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      alignment: Alignment.center,
                      child: Text(emptyMessage, style: const TextStyle(fontSize: 12, color: Colors.black45, fontStyle: FontStyle.italic)),
                    )
                  else
                    ...items.asMap().entries.map((e) => _buildTableRow(e.key + 1, e.value, isInward)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeaderRow() {
    Widget th(String text, double width, {Color? color, int lines = 1, bool visible = true}) {
      if (!visible) return const SizedBox.shrink();
      return Container(
        width: width,
        height: 40,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          border: Border(right: BorderSide(color: Color(0xFFE2E8F0)), bottom: BorderSide(color: Color(0xFFE2E8F0))),
        ),
        child: Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color ?? const Color(0xFF2563EB)), textAlign: TextAlign.center, maxLines: lines),
      );
    }
    
    Widget thDouble(String top, String b1, String b2, double w1, double w2, Color color, {bool visible = true}) {
      if (!visible) return const SizedBox.shrink();
      return Container(
        decoration: const BoxDecoration(
          border: Border(right: BorderSide(color: Color(0xFFE2E8F0))),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 20, 
              alignment: Alignment.center, 
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0)))), 
              child: Text(top, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color), overflow: TextOverflow.ellipsis),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: w1, height: 20, alignment: Alignment.center, decoration: const BoxDecoration(border: Border(right: BorderSide(color: Color(0xFFE2E8F0)), bottom: BorderSide(color: Color(0xFFE2E8F0)))), child: Text(b1, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color))),
                Container(width: w2, height: 20, alignment: Alignment.center, decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0)))), child: Text(b2, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color))),
              ],
            )
          ],
        ),
      );
    }

    return Container(
      color: const Color(0xFFF8FAFC), // Light gray header bg
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          th("SNO", 30, visible: _columns['sno'] ?? true),
          th("DATE", 70, visible: _columns['date'] ?? true),
          th("TRANS TYPE", 80, lines: 2, visible: _columns['transType'] ?? true),
          th("VOUCHERNO", 60, visible: _columns['voucherNo'] ?? true),
          th("PARTY NAME", 180, visible: _columns['partyName'] ?? true),
          th("GROUP NAME", 200, visible: _columns['groupName'] ?? true),
          th("ITEM NAME", 180, visible: _columns['itemName'] ?? true),
          th("CODE", 70, visible: _columns['barcode'] ?? true),
          th("EYE", 30, visible: _columns['eye'] ?? true),
          th("SPH", 35, visible: _columns['sph'] ?? true),
          th("CYL", 35, visible: _columns['cyl'] ?? true),
          th("AXIS", 35, visible: _columns['axis'] ?? true),
          th("ADD", 35, visible: _columns['add'] ?? true),
          th("OPENING STK", 70, color: const Color(0xFFEA580C), visible: _columns['opening'] ?? true),
          thDouble("INWARDS", "QTY", "VALUE", 40, 50, const Color(0xFF059669), visible: _columns['inwards'] ?? true),
          thDouble("OUTWARDS", "QTY", "VALUE", 40, 50, const Color(0xFFDC2626), visible: _columns['outwards'] ?? true),
          th("CLOSING", 50, visible: _columns['closing'] ?? true),
          th("UNIT", 50, visible: _columns['unit'] ?? true),
          th("PRICE", 55, visible: _columns['price'] ?? true),
          th("ACTION", 80, visible: _columns['action'] ?? true),
        ],
      ),
    );
  }

  Widget _buildTableRow(int sno, LensMovementItem item, bool isInward) {
    Widget td(String text, double width, {Color? color, FontWeight? weight, bool isAction = false, bool visible = true, bool isItalic = false, Color? bgColor}) {
      if (!visible) return const SizedBox.shrink();
      return Container(
        width: width,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor,
          border: const Border(right: BorderSide(color: Color(0xFFE2E8F0)), bottom: BorderSide(color: Color(0xFFE2E8F0))),
        ),
        child: isAction 
          ? MouseRegion(
              cursor: SystemMouseCursors.click,
              child: InkWell(
                onTap: () => _handleView(item),
                child: Container(
                  padding: const EdgeInsets.all(6), 
                  decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xFFDBEAFE))), 
                  child: const Icon(LucideIcons.eye, size: 16, color: Color(0xFF2563EB)),
                ),
              ),
            )
          : Text(text, style: TextStyle(fontSize: 10, color: color ?? const Color(0xFF0F172A), fontWeight: weight, fontStyle: isItalic ? FontStyle.italic : FontStyle.normal), textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
      );
    }

    final dateStr = item.date != null ? DateFormat('dd/M/yyyy').format(DateTime.tryParse(item.date!) ?? DateTime.now()) : '-';
    final inQty = item.inwardQty != 0 ? item.inwardQty.abs().toStringAsFixed(0) : '-'; // Using abs() for display
    final inVal = item.inwardValue != 0 ? item.inwardValue.abs().toStringAsFixed(2) : '-';
    final outQty = item.outwardQty != 0 ? item.outwardQty.abs().toStringAsFixed(0) : '-';
    final outVal = item.outwardValue != 0 ? item.outwardValue.abs().toStringAsFixed(2) : '-';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        td(sno.toString(), 30, visible: _columns['sno'] ?? true),
        td(dateStr, 70, visible: _columns['date'] ?? true),
        td(item.transType ?? '-', 80, visible: _columns['transType'] ?? true),
        td(item.voucherNo ?? '-', 60, weight: FontWeight.bold, color: const Color(0xFF2563EB), visible: _columns['voucherNo'] ?? true),
        td(item.partyName ?? '-', 180, visible: _columns['partyName'] ?? true),
        td(item.groupName ?? '-', 200, visible: _columns['groupName'] ?? true),
        td(item.itemName, 180, weight: FontWeight.bold, visible: _columns['itemName'] ?? true),
        td(item.barcode ?? item.barCode ?? '-', 70, visible: _columns['barcode'] ?? true),
        td(item.eye ?? '-', 30, color: const Color(0xFF2563EB), bgColor: const Color(0xFFF0F9FF), visible: _columns['eye'] ?? true),
        td(item.sph?.toString() ?? '-', 35, bgColor: const Color(0xFFF0F9FF), visible: _columns['sph'] ?? true),
        td(item.cyl?.toString() ?? '-', 35, bgColor: const Color(0xFFF0F9FF), visible: _columns['cyl'] ?? true),
        td(item.axis?.toString() ?? '-', 35, bgColor: const Color(0xFFF0F9FF), visible: _columns['axis'] ?? true),
        td(item.add?.toString() ?? '-', 35, bgColor: const Color(0xFFF0F9FF), visible: _columns['add'] ?? true),
        td(item.opening.toStringAsFixed(0), 70, color: const Color(0xFFEA580C), weight: FontWeight.bold, bgColor: const Color(0xFFFFF7ED), visible: _columns['opening'] ?? true),
        td(inQty, 40, color: const Color(0xFF059669), weight: FontWeight.bold, isItalic: true, bgColor: const Color(0xFFF0FDF4), visible: _columns['inwards'] ?? true),
        td(inVal, 50, color: const Color(0xFF059669), weight: FontWeight.bold, bgColor: const Color(0xFFF0FDF4), visible: _columns['inwards'] ?? true),
        td(outQty, 40, color: const Color(0xFFDC2626), weight: FontWeight.bold, isItalic: true, bgColor: const Color(0xFFFEF2F2), visible: _columns['outwards'] ?? true),
        td(outVal, 50, color: const Color(0xFFDC2626), weight: FontWeight.bold, bgColor: const Color(0xFFFEF2F2), visible: _columns['outwards'] ?? true),
        td(item.closing.toStringAsFixed(0), 50, color: const Color(0xFF2563EB), weight: FontWeight.bold, bgColor: const Color(0xFFEFF6FF), visible: _columns['closing'] ?? true),
        td(item.unit ?? 'PCS', 50, visible: _columns['unit'] ?? true),
        td(item.price?.toStringAsFixed(2) ?? '0.00', 55, weight: FontWeight.bold, visible: _columns['price'] ?? true),
        td('', 80, isAction: true, visible: _columns['action'] ?? true),
      ],
    );
  }

  // --- Helper Widgets ---

  Widget _filterItem(String label, Widget child) {
    if (label.isEmpty) return child;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
        const SizedBox(width: 8),
        child,
      ],
    );
  }

  Widget _datePicker(DateTime date, Function(DateTime) onPicked) {
    return InkWell(
      onTap: () async {
        final d = await showDatePicker(context: context, initialDate: date, firstDate: DateTime(2000), lastDate: DateTime(2100));
        if (d != null) onPicked(d);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(border: Border.all(color: const Color(0xFFCBD5E1)), borderRadius: BorderRadius.circular(4)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(DateFormat('dd-MM-yyyy').format(date), style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 8),
            const Icon(LucideIcons.calendar, size: 14, color: Color(0xFF64748B)),
          ],
        ),
      ),
    );
  }

  Widget _dropdown(String value, List<String> items, Function(String?) onChanged) {
    return Container(
      width: 150,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(border: Border.all(color: const Color(0xFFCBD5E1)), borderRadius: BorderRadius.circular(4)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          isDense: true,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _reusableSearchableDropdown({
    required String currentValue,
    required Function(String) onSelected,
    required List<String> items,
    String hint = "Select...",
    String searchHint = "Search...",
    String emptyText = "No results found",
  }) {
    return PopupMenuButton<String>(
      tooltip: hint,
      offset: const Offset(0, 36),
      color: Colors.white,
      surfaceTintColor: Colors.white,
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFCBD5E1)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                currentValue.isEmpty ? hint : currentValue,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: currentValue.isEmpty ? FontWeight.normal : FontWeight.w500,
                  color: currentValue.isEmpty ? const Color(0xFF94A3B8) : const Color(0xFF0F172A),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(LucideIcons.chevronDown, size: 14, color: Color(0xFF64748B)),
          ],
        ),
      ),
      itemBuilder: (context) {
        String localSearchQuery = "";
        return [
          PopupMenuItem<String>(
            enabled: false,
            padding: EdgeInsets.zero,
            child: StatefulBuilder(
              builder: (context, setPopupState) {
                final filtered = items.where((item) => 
                  item.toLowerCase().contains(localSearchQuery.toLowerCase())
                ).toList();

                return Container(
                  width: 250,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          autofocus: true,
                          style: const TextStyle(fontSize: 12),
                          decoration: InputDecoration(
                            hintText: searchHint,
                            hintStyle: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                            prefixIcon: const Icon(LucideIcons.search, size: 14),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                          ),
                          onChanged: (v) {
                            setPopupState(() { localSearchQuery = v; });
                          },
                        ),
                      ),
                      const Divider(height: 1),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 250),
                        child: filtered.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(emptyText, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: filtered.length,
                                itemBuilder: (context, index) {
                                  final item = filtered[index];
                                  final isSelected = currentValue == item;

                                  return InkWell(
                                    onTap: () {
                                      onSelected(item);
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: isSelected ? const Color(0xFFEFF6FF) : Colors.transparent,
                                        border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.1))),
                                      ),
                                      child: Text(
                                        item,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                          color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF1E293B),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                      if (currentValue.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              onSelected('');
                              Navigator.pop(context);
                            },
                            child: const Text("Clear Selection", style: TextStyle(fontSize: 11, color: Colors.red, fontWeight: FontWeight.bold)),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ];
      },
    );
  }

  Widget _groupAutocomplete() {
    return Consumer<ItemGroupProvider>(
      builder: (context, provider, _) {
        final groups = provider.groups.map((e) => e.groupName ?? '').where((e) => e.isNotEmpty).toList();
        return _reusableSearchableDropdown(
          currentValue: _groupName,
          items: groups,
          hint: "Group Name",
          searchHint: "Search Groups...",
          onSelected: (val) => setState(() => _groupName = val),
        );
      },
    );
  }

  Widget _itemAutocomplete() {
    return Consumer<ItemMasterProvider>(
      builder: (context, provider, _) {
        final itemsList = provider.items.map((e) => e.itemName).where((e) => e.isNotEmpty).toList();
        return _reusableSearchableDropdown(
          currentValue: _itemName,
          items: itemsList,
          hint: "Item Name",
          searchHint: "Search Items...",
          onSelected: (val) => setState(() => _itemName = val),
        );
      },
    );
  }

  Widget _partyAutocomplete() {
    return Consumer<AccountProvider>(
      builder: (context, provider, _) {
        final parties = provider.accounts.map((e) => e.name ?? '').where((e) => e.isNotEmpty).toList();
        return _reusableSearchableDropdown(
          currentValue: _partyName,
          items: parties,
          hint: "Party Name",
          searchHint: "Search Parties...",
          onSelected: (val) => setState(() => _partyName = val),
        );
      },
    );
  }

  Widget _textField(String hint, Function(String) onChanged) {
    return Container(
      height: 32,
      child: TextField(
        decoration: _inputDeco(hint),
        style: const TextStyle(fontSize: 12),
        onChanged: onChanged,
      ),
    );
  }

  Widget _miniInput(String hint, String value, Function(String) onChanged) {
    return Container(
      width: 60,
      height: 32, // Matched with Search button height
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(fontSize: 11),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 10, color: Colors.black26),
          contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }

  InputDecoration _inputDeco(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      border: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFFCBD5E1)), borderRadius: BorderRadius.circular(4)),
      enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFFCBD5E1)), borderRadius: BorderRadius.circular(4)),
    );
  }
}
