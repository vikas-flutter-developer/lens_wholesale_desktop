import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:excel/excel.dart' as xl;
import 'package:file_picker/file_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../data/providers/inventory_report_provider.dart';
import '../../data/models/inventory_report_models.dart';
import '../../../masters/data/providers/account_provider.dart';
import '../../../masters/data/providers/inventory_providers.dart';
import '../../../masters/data/models/account_model.dart';
import '../../../masters/data/models/item_group_model.dart';

class PartyWiseItemReportPage extends StatefulWidget {
  const PartyWiseItemReportPage({super.key});

  @override
  State<PartyWiseItemReportPage> createState() => _PartyWiseItemReportPageState();
}

class _PartyWiseItemReportPageState extends State<PartyWiseItemReportPage> {
  final ScrollController _horizontalScroll = ScrollController();
  final ScrollController _verticalScroll = ScrollController();

  DateTime _fromDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime _toDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
  
  String _partyName = '';
  String _groupName = '';
  String _searchText = '';
  
  List<String> _selectedTransTypes = ['Sale'];
  
  final Map<String, bool> _visibleColumns = {
    'sNo': true,
    'transType': true,
    'vchSeries': true,
    'vchNo': true,
    'vchDate': true,
    'partyName': true,
    'mobNo': true,
    'barcode': true,
    'productName': true,
    'eye': true,
    'sph': true,
    'cyl': true,
    'axis': true,
    'add': true,
    'qty': true,
    'pricePerUnit': true,
    'totalPrice': true,
    'margin': true,
    'remark': true,
    'vendorName': true,
    'dcId': true,
  };

  final Map<String, String> _columnLabels = {
    'sNo': 'SNo',
    'transType': 'Trans Type',
    'vchSeries': 'Vch Series',
    'vchNo': 'Vch No',
    'vchDate': 'Vch Date',
    'partyName': 'Party Name',
    'mobNo': 'Mob.No',
    'barcode': 'Barcode',
    'productName': 'Product Name',
    'eye': 'EYE',
    'sph': 'SPH',
    'cyl': 'CYL',
    'axis': 'AXIS',
    'add': 'ADD',
    'qty': 'Qty',
    'pricePerUnit': 'Price/Unit',
    'totalPrice': 'Total Price',
    'margin': 'Margin',
    'remark': 'Remarks',
    'vendorName': 'Vendor Name',
    'dcId': 'DC ID',
  };

  final List<String> _allTransactionTypes = [
    'All', 'Sale', 'Sale Order', 'Sale Challan', 'Sale Return',
    'Purchase', 'Purchase Order', 'Purchase Challan', 'Purchase Return',
    'Rx Sale Order', 'Rx Purchase Order',
    'Contact Lens & Sol Sale Order', 'Contact Lens & Sol Purchase Order',
    'Product Exchange', 'Damage & Shrinkage', 'Cancelled',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountProvider>().fetchAllAccounts();
      context.read<ItemGroupProvider>().fetchGroups();
    });
  }

  void _handleSearch() {
    final Map<String, dynamic> filters = {
      'dateFrom': DateFormat('yyyy-MM-dd').format(_fromDate),
      'dateTo': DateFormat('yyyy-MM-dd').format(_toDate),
      'customerName': _partyName,
      'groupName': _groupName,
      'searchText': _searchText,
      'transType': _selectedTransTypes,
    };
    context.read<InventoryReportProvider>().fetchPartyWiseItemReport(filters);
  }

  Future<void> _exportExcel(List<PartyWiseItem> data) async {
    if (data.isEmpty) return;
    
    final excel = xl.Excel.createExcel();
    final sheet = excel['Report'];
    excel.setDefaultSheet('Report');

    // Header
    final List<String> headers = _visibleColumns.entries
        .where((e) => e.value)
        .map((e) => _columnLabels[e.key] ?? e.key)
        .toList();
    
    sheet.appendRow(headers.map((e) => xl.TextCellValue(e)).toList());

    // Data
    for (var i = 0; i < data.length; i++) {
      final item = data[i];
      final List<xl.CellValue> row = [];
      
      if (_visibleColumns['sNo']!) row.add(xl.IntCellValue(i + 1));
      if (_visibleColumns['transType']!) row.add(xl.TextCellValue(item.transType ?? '-'));
      if (_visibleColumns['vchSeries']!) row.add(xl.TextCellValue(item.vchSeries ?? '-'));
      if (_visibleColumns['vchNo']!) row.add(xl.TextCellValue(item.vchNo ?? '-'));
      if (_visibleColumns['vchDate']!) row.add(xl.TextCellValue(item.vchDate ?? '-'));
      if (_visibleColumns['partyName']!) row.add(xl.TextCellValue(item.partyName ?? '-'));
      if (_visibleColumns['mobNo']!) row.add(xl.TextCellValue(item.mobNo ?? '-'));
      if (_visibleColumns['barcode']!) row.add(xl.TextCellValue(item.barcode ?? '-'));
      if (_visibleColumns['productName']!) row.add(xl.TextCellValue(item.productName ?? '-'));
      if (_visibleColumns['eye']!) row.add(xl.TextCellValue(item.eye ?? '-'));
      if (_visibleColumns['sph']!) row.add(xl.TextCellValue(item.sph?.toString() ?? '0.00'));
      if (_visibleColumns['cyl']!) row.add(xl.TextCellValue(item.cyl?.toString() ?? '0.00'));
      if (_visibleColumns['axis']!) row.add(xl.TextCellValue(item.axis?.toString() ?? '0'));
      if (_visibleColumns['add']!) row.add(xl.TextCellValue(item.add?.toString() ?? '0.00'));
      if (_visibleColumns['qty']!) row.add(xl.DoubleCellValue(item.qty));
      if (_visibleColumns['pricePerUnit']!) row.add(xl.DoubleCellValue(item.pricePerUnit));
      if (_visibleColumns['totalPrice']!) row.add(xl.DoubleCellValue(item.totalPrice));
      
      if (_visibleColumns['margin']!) {
        final margin = (item.totalPrice - ((item.purchasePrice ?? 0) * item.qty));
        row.add(xl.DoubleCellValue(margin));
      }
      
      if (_visibleColumns['remark']!) row.add(xl.TextCellValue(item.remark ?? '-'));
      if (_visibleColumns['vendorName']!) row.add(xl.TextCellValue(item.vendorName ?? '-'));
      if (_visibleColumns['dcId']!) row.add(xl.TextCellValue(item.dc_id ?? '-'));

      sheet.appendRow(row);
    }

    // Grand Total Row
    final totalQty = data.fold(0.0, (sum, item) => sum + item.qty);
    final totalVal = data.fold(0.0, (sum, item) => sum + item.totalPrice);
    final totalMargin = data.fold(0.0, (sum, item) => sum + (item.totalPrice - ((item.purchasePrice ?? 0) * item.qty)));

    final List<xl.CellValue> totalRow = [];
    bool labelPlaced = false;
    for (var col in _visibleColumns.entries) {
      if (col.value) {
        if (!labelPlaced && col.key == 'productName') {
          totalRow.add(xl.TextCellValue('GRAND TOTAL'));
          labelPlaced = true;
        } else if (col.key == 'qty') {
          totalRow.add(xl.DoubleCellValue(totalQty));
        } else if (col.key == 'totalPrice') {
          totalRow.add(xl.DoubleCellValue(totalVal));
        } else if (col.key == 'margin') {
          totalRow.add(xl.DoubleCellValue(totalMargin));
        } else {
          totalRow.add(xl.TextCellValue(''));
        }
      }
    }
    sheet.appendRow(totalRow);

    String? path = await FilePicker.saveFile(
      dialogTitle: 'Save Excel File',
      fileName: 'PartyWiseItemReport_${DateFormat('ddMMyyyy').format(DateTime.now())}.xlsx',
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );
    
    if (path != null) {
      if (!path.endsWith('.xlsx')) path += '.xlsx';
      final fileBytes = excel.save();
      if (fileBytes != null) {
        File(path).writeAsBytesSync(fileBytes);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Exported to $path')),
          );
        }
      }
    }
  }

  Future<void> _printPdf(List<PartyWiseItem> data) async {
    if (data.isEmpty) return;
    
    final doc = pw.Document();
    
    // Header
    final List<String> headers = _visibleColumns.entries
        .where((e) => e.value)
        .map((e) => _columnLabels[e.key] ?? e.key)
        .toList();

    // Data rows
    final List<List<String>> tableData = [];
    for (var i = 0; i < data.length; i++) {
      final item = data[i];
      final List<String> row = [];
      
      if (_visibleColumns['sNo']!) row.add((i + 1).toString());
      if (_visibleColumns['transType']!) row.add(item.transType ?? '-');
      if (_visibleColumns['vchSeries']!) row.add(item.vchSeries ?? '-');
      if (_visibleColumns['vchNo']!) row.add(item.vchNo ?? '-');
      if (_visibleColumns['vchDate']!) row.add(item.vchDate ?? '-');
      if (_visibleColumns['partyName']!) row.add(item.partyName ?? '-');
      if (_visibleColumns['mobNo']!) row.add(item.mobNo ?? '-');
      if (_visibleColumns['barcode']!) row.add(item.barcode ?? '-');
      if (_visibleColumns['productName']!) row.add(item.productName ?? '-');
      if (_visibleColumns['eye']!) row.add(item.eye ?? '-');
      if (_visibleColumns['sph']!) row.add(item.sph?.toString() ?? '0.00');
      if (_visibleColumns['cyl']!) row.add(item.cyl?.toString() ?? '0.00');
      if (_visibleColumns['axis']!) row.add(item.axis?.toString() ?? '0');
      if (_visibleColumns['add']!) row.add(item.add?.toString() ?? '0.00');
      if (_visibleColumns['qty']!) row.add(item.qty.toStringAsFixed(0));
      if (_visibleColumns['pricePerUnit']!) row.add(item.pricePerUnit.toStringAsFixed(2));
      if (_visibleColumns['totalPrice']!) row.add(item.totalPrice.toStringAsFixed(2));
      
      if (_visibleColumns['margin']!) {
        final margin = (item.totalPrice - ((item.purchasePrice ?? 0) * item.qty));
        row.add(margin.toStringAsFixed(2));
      }
      
      if (_visibleColumns['remark']!) row.add(item.remark ?? '-');
      if (_visibleColumns['vendorName']!) row.add(item.vendorName ?? '-');
      if (_visibleColumns['dcId']!) row.add(item.dc_id ?? '-');

      tableData.add(row);
    }

    // Totals for PDF
    final totalQty = data.fold(0.0, (sum, item) => sum + item.qty);
    final totalVal = data.fold(0.0, (sum, item) => sum + item.totalPrice);
    
    final List<String> totalRow = [];
    bool labelPlaced = false;
    for (var col in _visibleColumns.entries) {
      if (col.value) {
        if (!labelPlaced && col.key == 'productName') {
          totalRow.add('GRAND TOTAL');
          labelPlaced = true;
        } else if (col.key == 'qty') {
          totalRow.add(totalQty.toStringAsFixed(0));
        } else if (col.key == 'totalPrice') {
          totalRow.add(totalVal.toStringAsFixed(2));
        } else {
          totalRow.add('');
        }
      }
    }
    tableData.add(totalRow);

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(10),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Party Wise Item Report', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Date: ${DateFormat('dd/MM/yyyy').format(_fromDate)} to ${DateFormat('dd/MM/yyyy').format(_toDate)}'),
                ],
              ),
            ),
            pw.SizedBox(height: 10),
            pw.TableHelper.fromTextArray(
              headers: headers,
              data: tableData,
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
              cellStyle: const pw.TextStyle(fontSize: 7),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
              cellAlignment: pw.Alignment.centerLeft,
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
      name: 'PartyWiseItemReport.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Consumer<InventoryReportProvider>(
        builder: (context, provider, child) {
          final data = provider.partyWiseItems ?? [];
          return Column(
            children: [
              _buildTopHeader(provider),
              _buildFilterSection(),
              Expanded(
                child: provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : provider.partyWiseItems == null
                        ? const Center(child: Text('Apply filters to generate report'))
                        : Container(
                            margin: const EdgeInsets.symmetric(horizontal: 24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                scrollbarTheme: ScrollbarThemeData(
                                  thumbColor: WidgetStateProperty.all(const Color(0xFF64748B)),
                                  trackColor: WidgetStateProperty.all(const Color(0xFFE2E8F0)),
                                  trackVisibility: WidgetStateProperty.all(true),
                                  radius: const Radius.circular(0),
                                  thickness: WidgetStateProperty.all(14),
                                ),
                              ),
                              child: Scrollbar(
                                controller: _horizontalScroll,
                                thumbVisibility: true,
                                child: SingleChildScrollView(
                                  controller: _horizontalScroll,
                                  scrollDirection: Axis.horizontal,
                                  child: SizedBox(
                                    width: _calculateTableWidth(),
                                    child: Column(
                                      children: [
                                        // --- STICKY HEADER ---
                                        Container(
                                          color: const Color(0xFF2563EB),
                                          child: Table(
                                            columnWidths: _getColumnWidths(),
                                            children: [
                                              TableRow(
                                                children: [
                                                  ..._visibleColumns.entries.where((e) => e.value).map((e) => _headerCell(_columnLabels[e.key] ?? e.key)),
                                                  _headerCell('Actions', align: TextAlign.center),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        // --- SCROLLABLE BODY ---
                                        Expanded(
                                          child: Scrollbar(
                                            controller: _verticalScroll,
                                            thumbVisibility: true,
                                            thickness: 8,
                                            radius: const Radius.circular(4),
                                            child: SingleChildScrollView(
                                              controller: _verticalScroll,
                                              child: Table(
                                                columnWidths: _getColumnWidths(),
                                                border: const TableBorder(horizontalInside: BorderSide(color: Color(0xFFF1F5F9))),
                                                children: data.asMap().entries.map((entry) {
                                                  return _buildDataRow(entry.value, entry.key + 1);
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // --- STICKY GRAND TOTAL ---
                                        _buildGrandTotalRow(data),
                                        const SizedBox(height: 14), // Added space for horizontal scrollbar
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
              ),
              if (provider.partyWiseItems != null) _buildPaginationFooter(data.length),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTopHeader(InventoryReportProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: const Color(0xFF2563EB),
      child: Row(
        children: [
          const Icon(LucideIcons.fileText, color: Colors.white, size: 24),
          const SizedBox(width: 12),
          const Text(
            'Party Wise Item Report',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: provider.partyWiseItems != null ? () => _exportExcel(provider.partyWiseItems!) : null,
            icon: const Icon(LucideIcons.fileSpreadsheet, size: 16),
            label: const Text('Excel'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              elevation: 0,
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: provider.partyWiseItems != null ? () => _printPdf(provider.partyWiseItems!) : null,
            icon: const Icon(LucideIcons.printer, size: 16),
            label: const Text('Print'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF475569),
              foregroundColor: Colors.white,
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 16,
            runSpacing: 16,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              _filterItem('Date From', _datePicker(_fromDate, (d) => setState(() => _fromDate = d))),
              _filterItem('To', _datePicker(_toDate, (d) => setState(() => _toDate = d))),
              _filterItem('Trans Type', _buildMultiSelectDropdown(
                label: _selectedTransTypes.isEmpty ? 'None' : (_selectedTransTypes.contains('All') ? 'All Types' : _selectedTransTypes.join(', ')),
                items: _allTransactionTypes,
                selectedItems: _selectedTransTypes,
                onChanged: (item, selected) {
                  setState(() {
                    if (item == 'All') {
                      _selectedTransTypes.clear();
                      if (selected) _selectedTransTypes.add('All');
                    } else {
                      _selectedTransTypes.remove('All');
                      if (selected) {
                        if (!_selectedTransTypes.contains(item)) _selectedTransTypes.add(item);
                      } else {
                        _selectedTransTypes.remove(item);
                      }
                      // If all individual items are selected, switch to 'All'
                      if (_selectedTransTypes.length == _allTransactionTypes.length - 1) {
                        _selectedTransTypes.clear();
                        _selectedTransTypes.add('All');
                      }
                      if (_selectedTransTypes.isEmpty) {
                         _selectedTransTypes.add('Sale'); // Default if none selected
                      }
                    }
                  });
                },
              )),
              _filterItem('Group', _groupAutocomplete()),
              _filterItem('Custmr Name', _partyAutocomplete()),
              _filterItem('Search Text', _textField('Search...', (v) => _searchText = v)),
              _filterItem('Columns', _buildMultiSelectDropdown(
                label: '${_visibleColumns.values.where((v) => v).length} selected',
                items: _columnLabels.keys.toList(),
                selectedItems: _visibleColumns.entries.where((e) => e.value).map((e) => e.key).toList(),
                itemLabel: (key) => _columnLabels[key] ?? key,
                onChanged: (key, selected) {
                  setState(() => _visibleColumns[key] = selected);
                },
              )),
              
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    onPressed: _handleSearch,
                    icon: const Icon(LucideIcons.search, size: 16),
                    label: const Text('Search'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF22C55E),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _fromDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
                        _toDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
                        _partyName = '';
                        _groupName = '';
                        _searchText = '';
                        _selectedTransTypes = ['Sale'];
                      });
                    },
                    icon: const Icon(LucideIcons.rotateCcw),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFFF1F5F9),
                      foregroundColor: const Color(0xFF64748B),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: const BorderSide(color: Color(0xFFCBD5E1))),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMultiSelectDropdown({
    required String label,
    required List<String> items,
    required List<String> selectedItems,
    required Function(String, bool) onChanged,
    String Function(String)? itemLabel,
  }) {
    return PopupMenuButton<void>(
      tooltip: 'Select options',
      offset: const Offset(0, 45),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 10,
      splashRadius: 0,
      child: Container(
        width: 180,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF60A5FA)),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF1E293B)),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(LucideIcons.chevronDown, size: 16, color: Color(0xFF64748B)),
          ],
        ),
      ),
      itemBuilder: (context) {
        return [
          PopupMenuItem<void>(
            enabled: false,
            padding: EdgeInsets.zero,
            child: _MultiSelectMenu(
              items: items,
              selectedItems: selectedItems,
              onChanged: onChanged,
              itemLabel: itemLabel,
            ),
          ),
        ];
      },
    );
  }

  double _calculateTableWidth() {
    double width = 0;
    for (var col in _visibleColumns.entries) {
      if (col.value) width += _getColumnWidthValue(col.key);
    }
    return width + 80;
  }

  double _getColumnWidthValue(String key) {
    switch (key) {
      case 'sNo': return 50;
      case 'transType': return 120;
      case 'vchSeries': return 80;
      case 'vchNo': return 100;
      case 'vchDate': return 100;
      case 'partyName': return 200;
      case 'mobNo': return 110;
      case 'barcode': return 120;
      case 'productName': return 220;
      case 'eye': return 50;
      case 'sph': case 'cyl': case 'axis': case 'add': case 'qty': return 60;
      case 'pricePerUnit': return 100;
      case 'totalPrice': return 120;
      case 'margin': return 100;
      case 'remark': return 150;
      case 'vendorName': return 180;
      case 'dcId': return 100;
      default: return 100;
    }
  }

  Map<int, TableColumnWidth> _getColumnWidths() {
    final Map<int, TableColumnWidth> widths = {};
    int index = 0;
    for (var col in _visibleColumns.entries) {
      if (col.value) {
        widths[index] = FixedColumnWidth(_getColumnWidthValue(col.key));
        index++;
      }
    }
    widths[index] = const FixedColumnWidth(80);
    return widths;
  }

  TableRow _buildDataRow(PartyWiseItem item, int sNo) {
    final List<Widget> cells = [];
    
    if (_visibleColumns['sNo']!) cells.add(_cell(sNo.toString(), align: TextAlign.center, textColor: const Color(0xFF64748B)));
    if (_visibleColumns['transType']!) cells.add(_cellTag(item.transType ?? '-'));
    if (_visibleColumns['vchSeries']!) cells.add(_cell(item.vchSeries ?? '-', fontStyle: FontStyle.italic));
    if (_visibleColumns['vchNo']!) cells.add(_cell(item.vchNo ?? '-', textColor: const Color(0xFF2563EB), fontWeight: FontWeight.bold));
    if (_visibleColumns['vchDate']!) {
      DateTime? dt;
      if (item.vchDate != null) {
        dt = _tryParseDate(item.vchDate!);
      }
      cells.add(_cell(dt != null ? DateFormat('dd/MM/yyyy').format(dt) : (item.vchDate ?? '-')));
    }
    if (_visibleColumns['partyName']!) cells.add(_cell(item.partyName ?? '-', fontWeight: FontWeight.w500));
    if (_visibleColumns['mobNo']!) cells.add(_cell(item.mobNo ?? '-'));
    if (_visibleColumns['barcode']!) cells.add(_cell(item.barcode ?? '-', textColor: const Color(0xFF2563EB)));
    if (_visibleColumns['productName']!) cells.add(_cell(item.productName ?? '-', fontWeight: FontWeight.w500));
    if (_visibleColumns['eye']!) cells.add(_cell(item.eye ?? '-', align: TextAlign.center, textColor: item.eye == 'R' ? Colors.green : (item.eye == 'L' ? Colors.blue : null)));
    if (_visibleColumns['sph']!) cells.add(_cell(item.sph?.toString() ?? '0.00', align: TextAlign.center, fontWeight: FontWeight.bold));
    if (_visibleColumns['cyl']!) cells.add(_cell(item.cyl?.toString() ?? '0.00', align: TextAlign.center, fontWeight: FontWeight.bold));
    if (_visibleColumns['axis']!) cells.add(_cell(item.axis?.toString() ?? '0', align: TextAlign.center));
    if (_visibleColumns['add']!) cells.add(_cell(item.add?.toString() ?? '0.00', align: TextAlign.center, fontWeight: FontWeight.bold));
    if (_visibleColumns['qty']!) cells.add(_cell(item.qty.toStringAsFixed(0), align: TextAlign.center, fontWeight: FontWeight.bold, textColor: item.qty > 0 ? Colors.green : Colors.red));
    if (_visibleColumns['pricePerUnit']!) cells.add(_cell(item.pricePerUnit.toStringAsFixed(2), align: TextAlign.right));
    if (_visibleColumns['totalPrice']!) cells.add(_cell(item.totalPrice.toStringAsFixed(2), align: TextAlign.right, fontWeight: FontWeight.bold, textColor: const Color(0xFF1E40AF)));
    
    if (_visibleColumns['margin']!) {
      final margin = (item.totalPrice - ((item.purchasePrice ?? 0) * item.qty));
      cells.add(_cell(margin.toStringAsFixed(2), align: TextAlign.right, fontWeight: FontWeight.bold, textColor: margin >= 0 ? Colors.green : Colors.red));
    }
    
    if (_visibleColumns['remark']!) cells.add(_cell(item.remark ?? '-', textColor: Colors.grey));
    if (_visibleColumns['vendorName']!) cells.add(_cell(item.vendorName ?? '-'));
    if (_visibleColumns['dcId']!) cells.add(_cell(item.dc_id ?? '-', align: TextAlign.center));
    
    cells.add(Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: IconButton(
        onPressed: () {},
        icon: const Icon(LucideIcons.eye, size: 14),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        color: const Color(0xFF64748B),
      ),
    ));

    return TableRow(
      children: cells.map((c) => TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: c)).toList(),
    );
  }

  Widget _cell(String text, {TextAlign align = TextAlign.left, Color? textColor, FontWeight? fontWeight, FontStyle? fontStyle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(
          fontSize: 11,
          color: textColor ?? const Color(0xFF334155),
          fontWeight: fontWeight,
          fontStyle: fontStyle,
        ),
      ),
    );
  }

  Widget _cellTag(String type) {
    Color color = Colors.grey;
    if (type.contains('Sale')) color = Colors.blue;
    else if (type.contains('Purchase')) color = Colors.orange;
    else if (type.contains('Return')) color = Colors.red;
    else if (type.contains('Rx')) color = Colors.purple;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
        child: Text(
          type.toUpperCase(),
          style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildGrandTotalRow(List<PartyWiseItem> items) {
    final totalQty = items.fold(0.0, (sum, item) => sum + item.qty);
    final totalVal = items.fold(0.0, (sum, item) => sum + item.totalPrice);
    final totalMargin = items.fold(0.0, (sum, item) => sum + (item.totalPrice - ((item.purchasePrice ?? 0) * item.qty)));

    final List<Widget> cells = [];
    bool labelPlaced = false;
    
    for (var col in _visibleColumns.entries) {
      if (col.value) {
        if (!labelPlaced && col.key == 'productName') {
          cells.add(_cell('GRAND TOTAL', align: TextAlign.right, fontWeight: FontWeight.bold, textColor: Colors.white));
          labelPlaced = true;
        } else if (col.key == 'qty') {
          cells.add(_cell(totalQty.toStringAsFixed(0), align: TextAlign.center, fontWeight: FontWeight.bold, textColor: Colors.yellow));
        } else if (col.key == 'totalPrice') {
          cells.add(_cell('₹${totalVal.toStringAsFixed(2)}', align: TextAlign.right, fontWeight: FontWeight.bold, textColor: Colors.greenAccent));
        } else if (col.key == 'margin') {
          cells.add(_cell('₹${totalMargin.toStringAsFixed(2)}', align: TextAlign.right, fontWeight: FontWeight.bold, textColor: Colors.yellowAccent));
        } else {
          cells.add(const SizedBox());
        }
      }
    }
    cells.add(const SizedBox());

    return Container(
      color: const Color(0xFF475569),
      child: Table(
        columnWidths: _getColumnWidths(),
        children: [TableRow(children: cells)],
      ),
    );
  }

  Widget _buildPaginationFooter(int totalRecords) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          const Text('Total Records: ', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: const Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(4)),
            child: Text(totalRecords.toString(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E40AF))),
          ),
          const Spacer(),
          Text(
            'Date Range: ${DateFormat('dd/MM/yyyy').format(_fromDate)} to ${DateFormat('dd/MM/yyyy').format(_toDate)}',
            style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
          ),
        ],
      ),
    );
  }

  // --- Filter Helpers ---

  Widget _filterItem(String label, Widget child) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label.toUpperCase(), style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
      const SizedBox(height: 4),
      child,
    ]);
  }

  Widget _datePicker(DateTime date, Function(DateTime) onPicked) {
    return InkWell(
      onTap: () async {
        final d = await showDatePicker(context: context, initialDate: date, firstDate: DateTime(2000), lastDate: DateTime(2100));
        if (d != null) onPicked(d);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(border: Border.all(color: const Color(0xFF60A5FA)), borderRadius: BorderRadius.circular(4), color: Colors.white),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(LucideIcons.calendar, size: 14, color: Color(0xFF64748B)),
          const SizedBox(width: 8),
          Text(DateFormat('dd-MM-yy').format(date), style: const TextStyle(fontSize: 12)),
        ]),
      ),
    );
  }

  Widget _partyAutocomplete() {
    return SizedBox(
      width: 180,
      child: Consumer<AccountProvider>(
        builder: (context, provider, _) => Autocomplete<AccountModel>(
          displayStringForOption: (option) => option.name,
          optionsBuilder: (textEditingValue) {
            return provider.accounts.where((e) => e.name.toLowerCase().contains(textEditingValue.text.toLowerCase()));
          },
          onSelected: (v) => _partyName = v.name,
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: _inputDeco('Select Party'),
              style: const TextStyle(fontSize: 12),
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4,
                child: SizedBox(
                  width: 250,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options.elementAt(index);
                      return ListTile(
                        dense: true,
                        title: Text(option.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        subtitle: (option.mobileNumber != null && option.mobileNumber!.isNotEmpty) ? Text(option.mobileNumber!, style: const TextStyle(fontSize: 10, color: Colors.grey)) : null,
                        onTap: () => onSelected(option),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _groupAutocomplete() {
    return SizedBox(
      width: 140,
      child: Consumer<ItemGroupProvider>(
        builder: (context, provider, _) => Autocomplete<ItemGroupModel>(
          displayStringForOption: (option) => option.groupName,
          optionsBuilder: (textEditingValue) {
            return provider.groups.where((e) => e.groupName.toLowerCase().contains(textEditingValue.text.toLowerCase()));
          },
          onSelected: (v) => _groupName = v.groupName,
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: _inputDeco('Select Group'),
              style: const TextStyle(fontSize: 12),
            );
          },
        ),
      ),
    );
  }

  Widget _textField(String hint, Function(String) onChanged) {
    return SizedBox(
      width: 140,
      child: TextField(
        decoration: _inputDeco(hint),
        style: const TextStyle(fontSize: 12),
        onChanged: onChanged,
      ),
    );
  }

  InputDecoration _inputDeco(String hint) {
    return InputDecoration(
      hintText: hint,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      fillColor: Colors.white,
      filled: true,
      border: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF60A5FA)), borderRadius: BorderRadius.circular(4)),
      enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF60A5FA)), borderRadius: BorderRadius.circular(4)),
      focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2), borderRadius: BorderRadius.circular(4)),
    );
  }

  DateTime? _tryParseDate(String dateStr) {
    if (dateStr.isEmpty) return null;
    try {
      return DateTime.parse(dateStr);
    } catch (_) {
      try {
        final parts = dateStr.split('/');
        if (parts.length == 3) {
          final day = int.parse(parts[0]);
          final month = int.parse(parts[1]);
          final year = int.parse(parts[2]);
          return DateTime(year, month, day);
        }
      } catch (_) {}
    }
    return null;
  }

  Widget _headerCell(String text, {TextAlign align = TextAlign.left}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Text(
        text.toUpperCase(),
        textAlign: align,
        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
      ),
    );
  }
}

class _MultiSelectMenu extends StatefulWidget {
  final List<String> items;
  final List<String> selectedItems;
  final Function(String, bool) onChanged;
  final String Function(String)? itemLabel;

  const _MultiSelectMenu({
    required this.items,
    required this.selectedItems,
    required this.onChanged,
    this.itemLabel,
  });

  @override
  State<_MultiSelectMenu> createState() => _MultiSelectMenuState();
}

class _MultiSelectMenuState extends State<_MultiSelectMenu> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "SELECT OPTIONS",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF64748B),
                    letterSpacing: 0.5,
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(LucideIcons.x, size: 14, color: Color(0xFF94A3B8)),
                ),
              ],
            ),
          ),
          Expanded(
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  final item = widget.items[index];
                  final isSelected = widget.selectedItems.contains(item);
                  return InkWell(
                    onTap: () {
                      widget.onChanged(item, !isSelected);
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
                              border: Border.all(
                                color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFCBD5E1),
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: isSelected ? const Icon(LucideIcons.check, size: 12, color: Colors.white) : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              widget.itemLabel?.call(item) ?? item,
                              style: TextStyle(
                                fontSize: 13,
                                color: isSelected ? const Color(0xFF1E293B) : const Color(0xFF475569),
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
