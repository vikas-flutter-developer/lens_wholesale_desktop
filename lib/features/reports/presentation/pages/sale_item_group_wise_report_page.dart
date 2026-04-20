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
import '../../../masters/data/providers/inventory_providers.dart';

class SaleItemGroupWiseReportPage extends StatefulWidget {
  const SaleItemGroupWiseReportPage({super.key});

  @override
  State<SaleItemGroupWiseReportPage> createState() => _SaleItemGroupWiseReportPageState();
}

class _SaleItemGroupWiseReportPageState extends State<SaleItemGroupWiseReportPage> {
  DateTime _dateFrom = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime _dateTo = DateTime.now();
  List<String> _selectedGroups = [];
  String _groupSearch = '';

  final Map<String, bool> _visibleCols = {
    'sn': true,
    'billNo': true,
    'date': true,
    'party': true,
    'group': true,
    'product': true,
    'qty': true,
    'price': true,
    'disPct': true,
    'disRs': true,
    'oDisPct': false,
    'oDisRs': false,
    'value': true,
    'taxable': true,
    'total': true,
    'cash': true,
    'bank': true,
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ItemGroupProvider>().fetchGroups();
      _handleSearch();
    });
  }

  void _handleSearch() {
    final filters = {
      'dateFrom': DateFormat('yyyy-MM-dd').format(_dateFrom),
      'dateTo': DateFormat('yyyy-MM-dd').format(_dateTo),
      'selectedGroups': _selectedGroups,
    };
    context.read<InventoryReportProvider>().fetchSaleItemGroupWiseReport(filters);
  }

  void _handleReset() {
    setState(() {
      _dateFrom = DateTime(DateTime.now().year, DateTime.now().month, 1);
      _dateTo = DateTime.now();
      _selectedGroups = [];
    });
    _handleSearch();
  }

  String _getColumnLabel(String id) {
    switch (id) {
      case 'sn': return 'SN';
      case 'billNo': return 'Bill No';
      case 'date': return 'Date';
      case 'party': return 'Party';
      case 'group': return 'Group';
      case 'product': return 'Product';
      case 'qty': return 'Qty';
      case 'price': return 'Price';
      case 'disPct': return 'Dis%';
      case 'disRs': return 'Dis Rs';
      case 'oDisPct': return 'O.Dis%';
      case 'oDisRs': return 'O.Dis Rs';
      case 'value': return 'Value';
      case 'taxable': return 'Taxable';
      case 'total': return 'Total';
      case 'cash': return 'Cash';
      case 'bank': return 'Bank';
      default: return id;
    }
  }

  void _showColumnVisibilityDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Column Visibility', style: TextStyle(fontWeight: FontWeight.bold)),
              content: SizedBox(
                width: 300,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ..._visibleCols.keys.map((col) {
                        return CheckboxListTile(
                          title: Text(_getColumnLabel(col), style: const TextStyle(fontSize: 13)),
                          value: _visibleCols[col],
                          onChanged: (val) {
                            setDialogState(() => _visibleCols[col] = val ?? false);
                            setState(() {});
                          },
                          dense: true,
                          controlAffinity: ListTileControlAffinity.leading,
                        );
                      }),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showGroupSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final groupProvider = context.watch<ItemGroupProvider>();
            final groups = groupProvider.groups.map((g) => g.groupName).toList();
            final filteredGroups = groups
                .where((g) => g.toLowerCase().contains(_groupSearch.toLowerCase()))
                .toList();

            return AlertDialog(
              title: const Text('Select Groups', style: TextStyle(fontWeight: FontWeight.bold)),
              content: SizedBox(
                width: 400,
                height: 500,
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Search groups...',
                        prefixIcon: const Icon(LucideIcons.search, size: 18),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        isDense: true,
                      ),
                      onChanged: (v) => setDialogState(() => _groupSearch = v),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            setDialogState(() {
                              if (_selectedGroups.length == groups.length) {
                                _selectedGroups = [];
                              } else {
                                _selectedGroups = List.from(groups);
                              }
                            });
                          },
                          child: Text(_selectedGroups.length == groups.length ? 'Deselect All' : 'Select All'),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredGroups.length,
                        itemBuilder: (context, index) {
                          final group = filteredGroups[index];
                          final isSelected = _selectedGroups.contains(group);
                          return CheckboxListTile(
                            title: Text(group, style: const TextStyle(fontSize: 13)),
                            value: isSelected,
                            onChanged: (val) {
                              setDialogState(() {
                                if (val == true) {
                                  _selectedGroups.add(group);
                                } else {
                                  _selectedGroups.remove(group);
                                }
                              });
                            },
                            dense: true,
                            controlAffinity: ListTileControlAffinity.leading,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {});
                    Navigator.pop(context);
                  },
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(LucideIcons.filter, size: 20),
            const SizedBox(width: 8),
            const Text(
              'PRODUCT GROUP WISE SALE REPORT',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 0.5),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF3B82F6),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.printer),
            onPressed: _printReport,
            tooltip: 'Print',
          ),
          IconButton(
            icon: const Icon(LucideIcons.fileSpreadsheet),
            onPressed: _exportToExcel,
            tooltip: 'Export Excel',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(child: _buildTableBody()),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          _filterItem('Date From', _dateSelector(_dateFrom, (d) => setState(() => _dateFrom = d))),
          _filterItem('Date To', _dateSelector(_dateTo, (d) => setState(() => _dateTo = d))),
          _filterItem(
            'Select Groups',
            _inkWellBox(
              onTap: _showGroupSelectionDialog,
              child: Text(
                _selectedGroups.isEmpty
                    ? 'All Groups'
                    : _selectedGroups.length == 1
                        ? _selectedGroups.first
                        : '${_selectedGroups.length} Groups Selected',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          _filterItem(
            'Table Columns',
            _inkWellBox(
              onTap: _showColumnVisibilityDialog,
              child: Row(
                children: [
                  const Icon(LucideIcons.filter, size: 12, color: Colors.blue),
                  const SizedBox(width: 4),
                  Text(
                    '${_visibleCols.values.where((v) => v).length} Columns',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: _handleSearch,
            icon: const Icon(LucideIcons.search, size: 16),
            label: const Text('Search', style: TextStyle(fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
          ),
          ElevatedButton.icon(
            onPressed: _handleReset,
            icon: const Icon(LucideIcons.rotateCcw, size: 16),
            label: const Text('Reset', style: TextStyle(fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF334155),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: const BorderSide(color: Color(0xFFCBD5E1)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterItem(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 4),
        child,
      ],
    );
  }

  Widget _dateSelector(DateTime date, Function(DateTime) onSelected) {
    return _inkWellBox(
      onTap: () async {
        final d = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (d != null) onSelected(d);
      },
      child: Text(
        DateFormat('dd-MM-yyyy').format(date),
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _inkWellBox({required VoidCallback onTap, required Widget child}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 140,
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: child,
      ),
    );
  }

  Widget _buildTableBody() {
    return Consumer<InventoryReportProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.error != null) {
          return Center(child: Text('Error: ${provider.error}'));
        }
        final items = provider.saleItemGroupWiseItems ?? [];
        if (items.isEmpty) {
          return const Center(child: Text('No data found'));
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              padding: const EdgeInsets.all(8),
              width: constraints.maxWidth,
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth - 16),
                    child: SingleChildScrollView(
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(const Color(0xFFF1F5F9)),
                        headingRowHeight: 40,
                        dataRowMinHeight: 35,
                        dataRowMaxHeight: 35,
                        columnSpacing: 12,
                        dividerThickness: 0.5,
                        horizontalMargin: 12,
                        columns: _visibleCols.keys
                            .where((k) => _visibleCols[k]!)
                            .map((k) => DataColumn(
                                  label: Text(
                                    _getColumnLabel(k).toUpperCase(),
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900),
                                  ),
                                ))
                            .toList(),
                        rows: [
                          ...items.asMap().entries.map((entry) {
                            final idx = entry.key;
                            final item = entry.value;
                            return DataRow(
                              cells: _visibleCols.keys.where((k) => _visibleCols[k]!).map((k) {
                                return DataCell(_buildCellContent(k, item, idx));
                              }).toList(),
                            );
                          }),
                          DataRow(
                            color: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                            cells: _visibleCols.keys.where((k) => _visibleCols[k]!).map((k) {
                              return DataCell(_buildFooterContent(k, items));
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCellContent(String id, SaleItemGroupWiseItem item, int idx) {
    String text = '';
    Color? color;
    bool bold = false;

    switch (id) {
      case 'sn': text = '${idx + 1}'; break;
      case 'billNo': text = item.billNo ?? ''; break;
      case 'date': text = item.date != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(item.date!)) : ''; break;
      case 'party': text = item.party ?? ''; break;
      case 'group': text = item.productGroup ?? ''; break;
      case 'product': text = item.productName ?? ''; break;
      case 'qty': text = item.qty.toStringAsFixed(0); break;
      case 'price': text = item.prodPrice.toStringAsFixed(2); break;
      case 'disPct': text = '${item.prodDisPct.toStringAsFixed(1)}%'; break;
      case 'disRs': text = item.prodDisRs.toStringAsFixed(2); break;
      case 'oDisPct': text = '${item.otherDisPct.toStringAsFixed(1)}%'; break;
      case 'oDisRs': text = item.otherDisRs.toStringAsFixed(2); break;
      case 'value': 
        text = item.prodValue.toStringAsFixed(2);
        color = const Color(0xFF1D4ED8);
        bold = true;
        break;
      case 'taxable': text = item.prodTxbleAmt.toStringAsFixed(2); break;
      case 'total':
        text = item.invoiceTotalAmt.toStringAsFixed(2);
        color = const Color(0xFF1E40AF);
        bold = true;
        break;
      case 'cash':
        text = item.cash.toStringAsFixed(2);
        color = const Color(0xFF16A34A);
        break;
      case 'bank':
        text = item.bank.toStringAsFixed(2);
        color = const Color(0xFF9333EA);
        break;
    }

    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        color: color,
        fontWeight: bold ? FontWeight.w900 : FontWeight.w600,
      ),
    );
  }

  Widget _buildFooterContent(String id, List<SaleItemGroupWiseItem> items) {
    if (id == 'product') {
      return const Text(
        'TOTALS:',
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900),
      );
    }

    double sum = 0;
    bool isSummable = ['qty', 'value', 'taxable', 'total', 'cash', 'bank'].contains(id);

    if (isSummable) {
      for (var item in items) {
        switch (id) {
          case 'qty': sum += item.qty; break;
          case 'value': sum += item.prodValue; break;
          case 'taxable': sum += item.prodTxbleAmt; break;
          case 'total': sum += item.invoiceTotalAmt; break;
          case 'cash': sum += item.cash; break;
          case 'bank': sum += item.bank; break;
        }
      }
    }

    if (!isSummable) return const SizedBox.shrink();

    return Text(
      id == 'qty' ? sum.toStringAsFixed(0) : sum.toStringAsFixed(2),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        color: id == 'total' ? const Color(0xFF1E40AF) : null,
      ),
    );
  }

  Future<void> _exportToExcel() async {
    final provider = context.read<InventoryReportProvider>();
    final items = provider.saleItemGroupWiseItems ?? [];
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No data to export')));
      return;
    }

    try {
      var excel = xl.Excel.createExcel();
      xl.Sheet sheetObject = excel['SaleItemGroupWiseReport'];
      
      // Header
      List<xl.CellValue> headers = _visibleCols.keys
          .where((k) => _visibleCols[k]!)
          .map((k) => xl.TextCellValue(_getColumnLabel(k)))
          .toList();
      sheetObject.appendRow(headers);

      // Data
      for (int i = 0; i < items.length; i++) {
        final item = items[i];
        List<xl.CellValue> row = [];
        for (var k in _visibleCols.keys.where((k) => _visibleCols[k]!)) {
          switch (k) {
            case 'sn': row.add(xl.IntCellValue(i + 1)); break;
            case 'billNo': row.add(xl.TextCellValue(item.billNo ?? '')); break;
            case 'date': row.add(xl.TextCellValue(item.date ?? '')); break;
            case 'party': row.add(xl.TextCellValue(item.party ?? '')); break;
            case 'group': row.add(xl.TextCellValue(item.productGroup ?? '')); break;
            case 'product': row.add(xl.TextCellValue(item.productName ?? '')); break;
            case 'qty': row.add(xl.DoubleCellValue(item.qty)); break;
            case 'price': row.add(xl.DoubleCellValue(item.prodPrice)); break;
            case 'disPct': row.add(xl.DoubleCellValue(item.prodDisPct)); break;
            case 'disRs': row.add(xl.DoubleCellValue(item.prodDisRs)); break;
            case 'oDisPct': row.add(xl.DoubleCellValue(item.otherDisPct)); break;
            case 'oDisRs': row.add(xl.DoubleCellValue(item.otherDisRs)); break;
            case 'value': row.add(xl.DoubleCellValue(item.prodValue)); break;
            case 'taxable': row.add(xl.DoubleCellValue(item.prodTxbleAmt)); break;
            case 'total': row.add(xl.DoubleCellValue(item.invoiceTotalAmt)); break;
            case 'cash': row.add(xl.DoubleCellValue(item.cash)); break;
            case 'bank': row.add(xl.DoubleCellValue(item.bank)); break;
          }
        }
        sheetObject.appendRow(row);
      }

      String? outputFile = await FilePicker.saveFile(
        dialogTitle: 'Save Excel File',
        fileName: 'ProductGroupWiseSaleReport.xlsx',
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );

      if (outputFile != null) {
        final bytes = excel.encode();
        if (bytes != null) {
          File(outputFile).writeAsBytesSync(bytes);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Excel exported successfully!')));
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error exporting excel: $e')));
      }
    }
  }

  Future<void> _printReport() async {
    final provider = context.read<InventoryReportProvider>();
    final items = provider.saleItemGroupWiseItems ?? [];
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No data to print')));
      return;
    }

    final pdf = pw.Document();
    
    final headers = _visibleCols.keys.where((k) => _visibleCols[k]!).map((k) => _getColumnLabel(k)).toList();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (pw.Context context) {
          return [
            pw.Header(level: 0, child: pw.Text('Product Group Wise Sale Report', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold))),
            pw.SizedBox(height: 10),
            pw.TableHelper.fromTextArray(
              headers: headers,
              data: items.asMap().entries.map((entry) {
                final i = entry.key;
                final item = entry.value;
                List<String> row = [];
                for (var k in _visibleCols.keys.where((k) => _visibleCols[k]!)) {
                  switch (k) {
                    case 'sn': row.add('${i + 1}'); break;
                    case 'billNo': row.add(item.billNo ?? ''); break;
                    case 'date': row.add(item.date != null ? DateFormat('dd-MM-yy').format(DateTime.parse(item.date!)) : ''); break;
                    case 'party': row.add(item.party ?? ''); break;
                    case 'group': row.add(item.productGroup ?? ''); break;
                    case 'product': row.add(item.productName ?? ''); break;
                    case 'qty': row.add(item.qty.toStringAsFixed(0)); break;
                    case 'price': row.add(item.prodPrice.toStringAsFixed(2)); break;
                    case 'disPct': row.add('${item.prodDisPct.toStringAsFixed(1)}%'); break;
                    case 'disRs': row.add(item.prodDisRs.toStringAsFixed(2)); break;
                    case 'oDisPct': row.add('${item.otherDisPct.toStringAsFixed(1)}%'); break;
                    case 'oDisRs': row.add(item.otherDisRs.toStringAsFixed(2)); break;
                    case 'value': row.add(item.prodValue.toStringAsFixed(2)); break;
                    case 'taxable': row.add(item.prodTxbleAmt.toStringAsFixed(2)); break;
                    case 'total': row.add(item.invoiceTotalAmt.toStringAsFixed(2)); break;
                    case 'cash': row.add(item.cash.toStringAsFixed(2)); break;
                    case 'bank': row.add(item.bank.toStringAsFixed(2)); break;
                  }
                }
                return row;
              }).toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
              cellStyle: const pw.TextStyle(fontSize: 7),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
