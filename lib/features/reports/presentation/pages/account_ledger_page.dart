import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:csv/csv.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:go_router/go_router.dart';

import '../../data/providers/ledger_provider.dart';
import '../../data/models/ledger_model.dart' as model;
import '../../../masters/data/providers/account_provider.dart';
import '../../../masters/data/models/account_model.dart';

class AccountLedgerPage extends StatefulWidget {
  final String? initialAccount;
  final String? initialFromDate;
  final String? initialToDate;

  const AccountLedgerPage({
    super.key,
    this.initialAccount,
    this.initialFromDate,
    this.initialToDate,
  });

  @override
  State<AccountLedgerPage> createState() => _AccountLedgerPageState();
}

class _AccountLedgerPageState extends State<AccountLedgerPage> {
  final ScrollController _horizontalScroll = ScrollController();
  final TextEditingController _searchCtrl = TextEditingController();
  final TextEditingController _paymentAmountCtrl = TextEditingController();
  final TextEditingController _paymentDateCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<LedgerProvider>();
      context.read<AccountProvider>().fetchAllAccounts();
      
      if (widget.initialAccount != null) {
        if (widget.initialFromDate != null) {
          provider.setFromDate(DateTime.parse(widget.initialFromDate!));
        }
        if (widget.initialToDate != null) {
          provider.setToDate(DateTime.parse(widget.initialToDate!));
        }
        provider.setSearchName(widget.initialAccount!);
        _searchCtrl.text = widget.initialAccount!;
        provider.fetchLedger();
      }
    });
  }

  @override
  void dispose() {
    _horizontalScroll.dispose();
    _searchCtrl.dispose();
    _paymentAmountCtrl.dispose();
    _paymentDateCtrl.dispose();
    super.dispose();
  }


  String _formatDrCr(double val) {
    if (val == 0) return "0.00";
    final side = val < 0 ? "CR" : "DR";
    return "${val.abs().toStringAsFixed(2)} $side";
  }

  Future<void> _shareWhatsApp(LedgerProvider provider) async {
    if (provider.report == null) return;

    final report = provider.report!;
    final rowsToShare = provider.selectedRows.isNotEmpty 
        ? report.data.asMap().entries.where((e) => provider.selectedRows.contains(e.key)).map((e) => e.value).toList()
        : report.data;

    var message = "*Ledger Statement for ${provider.searchName}*\n";
    message += "Period: ${DateFormat('d/M/yyyy').format(provider.fromDate)} to ${DateFormat('d/M/yyyy').format(provider.toDate)}\n";
    message += "--------------------------------\n";
    if (provider.selectedRows.isEmpty) {
      message += "*Opening Balance:* ${_formatDrCr(report.openingBalance)}\n";
      message += "--------------------------------\n";
    }
    
    message += "`Date       | Vch   | Amount`\n";

    for (var r in rowsToShare) {
      final dateStr = DateFormat('d/M/yyyy').format(DateTime.parse(r.date));
      final vch = (r.voucherNo ?? "-").padRight(6).substring(0, 6);
      String amountStr = "";
      if (r.debit > 0) {
        amountStr = "${r.debit.toStringAsFixed(0)} Dr";
      } else if (r.credit > 0) {
        amountStr = "${r.credit.toStringAsFixed(0)} Cr";
      } else {
        amountStr = "0";
      }

      message += "`$dateStr | $vch | $amountStr`\n";
    }

    if (provider.selectedRows.isEmpty) {
      message += "--------------------------------\n";
      message += "*Closing Balance:* ${_formatDrCr(report.closingBalance)}\n";
    }

    final url = "https://wa.me/?text=${Uri.encodeComponent(message)}";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  Future<void> _exportToCSV(LedgerProvider provider) async {
    if (provider.report == null) return;
    
    final rowsToExport = provider.selectedRows.isNotEmpty 
        ? provider.report!.data.asMap().entries.where((e) => provider.selectedRows.contains(e.key)).map((e) => e.value).toList()
        : provider.report!.data;

    final csvRows = [
      ['SN', 'Date', 'Transaction Type', 'Vch No', 'Debit', 'Credit', 'Balance', 'Short Narr', 'Remarks']
    ];
    
    for (var r in rowsToExport) {
      csvRows.add([
        (r.sn ?? '').toString(),
        DateFormat('d/M/yyyy').format(DateTime.parse(r.date)),
        r.transType,
        (r.voucherNo ?? '').toString(),
        r.debit.toString(),
        r.credit.toString(),
        r.balance.toString(),
        (r.shortNarr ?? '').toString(),
        (r.remarks ?? '').toString()
      ]);
    }

    final csvData = const ListToCsvConverter().convert(csvRows);
    final directory = await getApplicationDocumentsDirectory();
    final file = File("${directory.path}/Ledger_${provider.searchName}_${DateTime.now().millisecondsSinceEpoch}.csv");
    await file.writeAsString(csvData);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Exported to ${file.path}')));
    }
  }

  Future<void> _printLedger(LedgerProvider provider) async {
    if (provider.report == null) return;
    final pdf = pw.Document();
    
    final rowsToPrint = provider.selectedRows.isNotEmpty 
        ? provider.report!.data.asMap().entries.where((e) => provider.selectedRows.contains(e.key)).map((e) => e.value).toList()
        : provider.report!.data;

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4.landscape,
      build: (context) => [
        pw.Header(level: 0, child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text("Ledger Statement", style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.Text(provider.searchName, style: pw.TextStyle(fontSize: 18)),
            pw.Text("Period: ${DateFormat('d/M/yyyy').format(provider.fromDate)} to ${DateFormat('d/M/yyyy').format(provider.toDate)}", style: pw.TextStyle(fontSize: 12)),
            pw.SizedBox(height: 10),
          ]
        )),
        pw.TableHelper.fromTextArray(
          headers: ['SN', 'Date', 'Type', 'Vch No', 'Debit', 'Credit', 'Balance', 'Narrative', 'Remarks'],
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
          cellStyle: const pw.TextStyle(fontSize: 9),
          headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
          data: [
            if (provider.selectedRows.isEmpty)
              ['-', '', 'Opening Balance', '', '', '', _formatDrCr(provider.report!.openingBalance), '', ''],
            ...rowsToPrint.map((r) => [
              r.sn?.toString() ?? '',
              DateFormat('d/M/yyyy').format(DateTime.parse(r.date)),
              r.transType,
              r.voucherNo ?? '-',
              r.debit.toStringAsFixed(2),
              r.credit.toStringAsFixed(2),
              _formatDrCr(r.balance),
              r.shortNarr ?? '',
              r.remarks ?? '',
            ]),
            if (provider.selectedRows.isEmpty)
              ['-', '', 'Closing Balance', '', '', '', _formatDrCr(provider.report!.closingBalance), '', ''],
          ],
        ),
      ]
    ));
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('Ledger Book', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: const Color(0xFFF3F4F6), // match gray-100
        foregroundColor: Colors.black,
        centerTitle: false,
      ),
      body: Consumer<LedgerProvider>(builder: (context, provider, child) {
        return Column(
          children: [
            _buildFilterBar(provider),
            _buildReconciliationBar(provider),
            if (provider.error != null)
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.red.shade50,
                width: double.infinity,
                child: Text(
                  provider.error!, 
                  style: TextStyle(color: Colors.red.shade700, fontSize: 13, fontWeight: FontWeight.bold), 
                  textAlign: TextAlign.center
                ),
              ),
            Expanded(
              child: provider.isLoading 
                ? const Center(child: CircularProgressIndicator()) 
                : _buildLedgerTable(provider),
            ),
            _buildSummaryFooter(provider),
          ],
        );
      }),
    );
  }

  Widget _buildFilterBar(LedgerProvider provider) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: const Color(0xFFEFF6FF), // bg-blue-50
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              _filterCol('Date From', SizedBox(width: 130, child: InkWell(
                onTap: () async {
                  final d = await showDatePicker(context: context, initialDate: provider.fromDate, firstDate: DateTime(2000), lastDate: DateTime(2100));
                  if (d != null) {
                    provider.setFromDate(d);
                  }
                },
                child: _box(DateFormat('dd-MM-yyyy').format(provider.fromDate), LucideIcons.calendar),
              ))),
              _filterCol('To', SizedBox(width: 130, child: InkWell(
                onTap: () async {
                  final d = await showDatePicker(context: context, initialDate: provider.toDate, firstDate: DateTime(2000), lastDate: DateTime(2100));
                  if (d != null) {
                    provider.setToDate(d);
                  }
                },
                child: _box(DateFormat('dd-MM-yyyy').format(provider.toDate), LucideIcons.calendar),
              ))),
              _filterCol('Search Name / Mob', SizedBox(width: 180, child: Consumer<AccountProvider>(
                builder: (context, accProv, _) => Autocomplete<AccountModel>(
                  displayStringForOption: (a) => a.name,
                  optionsBuilder: (v) => v.text.isEmpty ? [] : accProv.accounts.where((a) => a.name.toLowerCase().contains(v.text.toLowerCase()) || (a.mobileNumber != null && a.mobileNumber!.contains(v.text))),
                  onSelected: (a) { 
                    provider.setSearchName(a.name); 
                    _searchCtrl.text = a.name; 
                  },
                  fieldViewBuilder: (ctx, ctrl, focus, onSub) {
                    if (_searchCtrl.text.isNotEmpty && ctrl.text.isEmpty && provider.searchName.isNotEmpty) {
                      ctrl.text = provider.searchName;
                    }
                    return SizedBox(
                      height: 34,
                      child: TextField(
                        controller: ctrl,
                        focusNode: focus,
                        style: const TextStyle(fontSize: 13),
                        decoration: _inputDeco('Name / Mob'),
                        onChanged: (v) {
                          provider.setSearchName(v);
                          _searchCtrl.text = v;
                        },
                      ),
                    );
                  },
                ),
              ))),
              _filterCol('Payment Receive', SizedBox(width: 140, child: SizedBox(
                height: 34,
                child: TextField(
                  controller: _paymentAmountCtrl,
                  style: const TextStyle(fontSize: 13),
                  decoration: _inputDeco('Enter Amount'),
                  keyboardType: TextInputType.number,
                  onSubmitted: (v) {
                    final amt = double.tryParse(v) ?? 0;
                    if (amt > 0) {
                      provider.runReconciliationMagic(amt);
                    }
                  },
                ),
              ))),
              _filterCol('Payment Date', SizedBox(width: 130, child: InkWell(
                onTap: () async {
                  final d = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
                  if (d != null) {
                    final ds = DateFormat('yyyy-MM-dd').format(d);
                    provider.setPaymentDate(ds);
                    _paymentDateCtrl.text = ds;
                  }
                },
                child: _box(provider.paymentDate.isNotEmpty ? DateFormat('dd-MM-yyyy').format(DateTime.parse(provider.paymentDate)) : 'dd-mm-yyyy', LucideIcons.calendar),
              ))),
              
              const SizedBox(width: 8),
              // Search & Reset on the same line if space permits
              ElevatedButton.icon(
                onPressed: () => provider.fetchLedger(),
                icon: const Icon(LucideIcons.search, size: 14),
                label: const Text('Search'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade500, 
                  foregroundColor: Colors.white, 
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14), 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  elevation: 1,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () { 
                  _searchCtrl.clear(); 
                  provider.reset(); 
                },
                icon: const Icon(LucideIcons.rotateCcw, size: 14),
                label: const Text('Reset'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0EA5E9), 
                  foregroundColor: Colors.white, 
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14), 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  elevation: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Second line Actions
          Row(
            children: [
              _actionBtn(LucideIcons.fileOutput, Colors.yellow.shade600, () => _exportToCSV(provider), 'CSV'),
              const SizedBox(width: 8),
              _actionBtn(LucideIcons.messageSquare, Colors.green.shade500, () => _shareWhatsApp(provider), 'WhatsApp'),
              const SizedBox(width: 8),
              _actionBtn(LucideIcons.printer, Colors.blue.shade600, () => _printLedger(provider), 'Print'),
              const SizedBox(width: 12),
              _buildColumnSelector(provider),
              
              if (provider.reconciledIndices.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: ElevatedButton(
                    onPressed: () async {
                      final res = await provider.saveSettlement();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['success'] == true ? 'Settled successfully' : (res['error'] ?? 'Error'))));
                      }
                      if (res['success'] == true) {
                        _paymentAmountCtrl.clear();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600, 
                      foregroundColor: Colors.white, 
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), 
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    child: const Text('Confirm & Save', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionBtn(IconData icon, Color color, VoidCallback onTap, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)]),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  Widget _buildColumnSelector(LedgerProvider provider) {
    return PopupMenuButton<String>(
      tooltip: 'Columns',
      offset: const Offset(0, 45),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
        child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(LucideIcons.columns, size: 16), SizedBox(width: 8), Text('COLUMNS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))]),
      ),
      itemBuilder: (context) {
        final cols = [
            {'id': 'sn', 'label': 'SN'},
            {'id': 'date', 'label': 'Date'},
            {'id': 'transType', 'label': 'Transaction Type'},
            {'id': 'voucherNo', 'label': 'Vch/Bill No'},
            {'id': 'debit', 'label': 'Debit'},
            {'id': 'credit', 'label': 'Credit'},
            {'id': 'balance', 'label': 'Balance (Dr/Cr)'},
            {'id': 'shortNarr', 'label': 'Short Narr'},
            {'id': 'remarks', 'label': 'Remarks'},
            {'id': 'settlementDate', 'label': 'Recv Date'},
            {'id': 'view', 'label': 'View'},
        ];
        return cols.map((c) => PopupMenuItem<String>(
          child: StatefulBuilder(builder: (context, setState) {
            final isChecked = provider.visibleColumns[c['id']] ?? false;
            return CheckboxListTile(
              title: Text(c['label']!, style: const TextStyle(fontSize: 12)),
              value: isChecked,
              dense: true,
              onChanged: (v) {
                provider.toggleColumn(c['id']!);
                setState(() {});
              },
            );
          }),
        )).toList();
      },
    );
  }

  Widget _buildReconciliationBar(LedgerProvider provider) {
    if (!provider.hasSearched) {
      return const SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.blue.shade50.withAlpha(128),
      child: Row(
        children: [
          const Text('Reconcile Payment:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(width: 12),
          SizedBox(width: 120, child: TextField(
            controller: _paymentAmountCtrl,
            decoration: _inputDeco('Amount').copyWith(fillColor: Colors.white),
            keyboardType: TextInputType.number,
            onSubmitted: (v) => provider.runReconciliationMagic(double.tryParse(v) ?? 0),
          )),
          const SizedBox(width: 12),
          SizedBox(width: 140, child: InkWell(
            onTap: () async {
              final d = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
              if (d != null) {
                final ds = DateFormat('yyyy-MM-dd').format(d);
                provider.setPaymentDate(ds);
                _paymentDateCtrl.text = ds;
              }
            },
            child: IgnorePointer(child: TextField(controller: _paymentDateCtrl, decoration: _inputDeco('Date'), readOnly: true)),
          )),
          const SizedBox(width: 12),
          if (provider.reconciledIndices.isNotEmpty)
            ElevatedButton(
              onPressed: () async {
                final res = await provider.saveSettlement();
                if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['success'] == true ? 'Settled successfully' : (res['error'] ?? 'Error'))));
                if (res['success'] == true) _paymentAmountCtrl.clear();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600, foregroundColor: Colors.white),
              child: const Text('Confirm & Save'),
            ),
        ],
      ),
    );
  }

  Widget _buildLedgerTable(LedgerProvider provider) {
    if (!provider.hasSearched) {
      return const Center(child: Text('No data. Use the filters and press Search.', style: TextStyle(color: Colors.grey)));
    }
    final data = provider.report!.data;
    
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.grey.shade300,
        dataTableTheme: const DataTableThemeData(
          headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 13),
          dataTextStyle: TextStyle(fontSize: 12, color: Colors.black),
        ),
      ),
      child: Scrollbar(
        controller: _horizontalScroll,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _horizontalScroll,
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(const Color(0xFFF3F4F6)), // bg-gray-100
              dataRowMinHeight: 30,
              dataRowMaxHeight: 36,
              headingRowHeight: 38,
              columnSpacing: 12,
              horizontalMargin: 12,
              showCheckboxColumn: false,
              border: TableBorder.all(color: Colors.grey.shade200, width: 0.5),
              columns: _buildColumns(provider),
              rows: [
                // Account Name Header Row (Parity with React)
                DataRow(
                  color: WidgetStateProperty.all(Colors.white),
                  cells: _buildAccountHeaderCells(provider),
                ),
                // Opening Balance Row
                DataRow(
                  color: WidgetStateProperty.all(const Color(0xFFF9FAFB)), // bg-gray-50
                  cells: _buildSummaryCells(provider, 'Opening Balance', _formatDrCr(provider.report!.openingBalance)),
                ),
                // Transaction Rows
                ...List.generate(data.length, (index) {
                  final r = data[index];
                  final isSavedRec = r.settlementDate != null && r.settlementDate!.isNotEmpty;
                  final isTempRec = provider.reconciledIndices.contains(index) && !isSavedRec;
                  final isSelected = provider.selectedRows.contains(index);
                  
                  Color? rowColor;
                  if (isSavedRec) {
                    rowColor = const Color(0xFFDCFCE7); // green-100 (more visible)
                  } else if (isTempRec) {
                    rowColor = const Color(0xFFFEF9C3); // yellow-100 (more visible)
                  } else if (isSelected) {
                    rowColor = Colors.blue.shade50;
                  }
                  
                  return DataRow(
                    color: WidgetStateProperty.all(rowColor),
                    cells: _buildDataCells(r, index, provider, isTempRec, isSavedRec, isSelected),
                  );
                }),
                // Closing Balance Row
                DataRow(
                  color: WidgetStateProperty.all(const Color(0xFFF9FAFB)), // bg-gray-50
                  cells: _buildSummaryCells(provider, 'Closing Balance', _formatDrCr(provider.report!.closingBalance)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns(LedgerProvider provider) {
    final v = provider.visibleColumns;
    final list = <DataColumn>[];
    
    if (v['sn'] ?? false) {
      list.add(DataColumn(label: Row(children: [
        Checkbox(
          value: provider.isAllSelected,
          onChanged: (val) => provider.toggleAllSelection(val ?? false),
          visualDensity: VisualDensity.compact,
        ),
        const Text('SN'),
      ])));
    }
    if (v['date'] ?? false) list.add(const DataColumn(label: Text('Date')));
    if (v['transType'] ?? false) list.add(const DataColumn(label: Text('Transaction Type')));
    if (v['voucherNo'] ?? false) list.add(const DataColumn(label: Text('Vch/Bill No')));
    if (v['debit'] ?? false) list.add(const DataColumn(label: Text('Debit', textAlign: TextAlign.right)));
    if (v['credit'] ?? false) list.add(const DataColumn(label: Text('Credit', textAlign: TextAlign.right)));
    if (v['balance'] ?? false) list.add(const DataColumn(label: Text('Balance (Dr/Cr)', textAlign: TextAlign.right)));
    if (v['shortNarr'] ?? false) list.add(const DataColumn(label: Text('Short Narr')));
    if (v['remarks'] ?? false) list.add(const DataColumn(label: Text('Remarks')));
    if (v['settlementDate'] ?? false) list.add(const DataColumn(label: Text('Recv Date')));
    if (v['view'] ?? false) list.add(const DataColumn(label: Text('View')));
    
    return list;
  }

  List<DataCell> _buildSummaryCells(LedgerProvider p, String label, String balance) {
    final v = p.visibleColumns;
    final cells = <DataCell>[];
    
    if (v['sn'] ?? false) cells.add(const DataCell(Text('-')));
    if (v['date'] ?? false) cells.add(const DataCell(Text('')));
    if (v['transType'] ?? false) cells.add(DataCell(Text(label, style: const TextStyle(fontWeight: FontWeight.bold))));
    if (v['voucherNo'] ?? false) cells.add(const DataCell(Text('')));
    if (v['debit'] ?? false) cells.add(const DataCell(Text('')));
    if (v['credit'] ?? false) cells.add(const DataCell(Text('')));
    if (v['balance'] ?? false) cells.add(DataCell(Align(alignment: Alignment.centerRight, child: Text(balance, style: const TextStyle(fontWeight: FontWeight.bold)))));
    if (v['shortNarr'] ?? false) cells.add(const DataCell(Text('')));
    if (v['remarks'] ?? false) cells.add(const DataCell(Text('')));
    if (v['settlementDate'] ?? false) cells.add(const DataCell(Text('')));
    if (v['view'] ?? false) cells.add(const DataCell(Text('')));
    
    return cells;
  }

  List<DataCell> _buildDataCells(model.LedgerRow r, int index, LedgerProvider p, bool isTemp, bool isSaved, bool isSelected) {
    final v = p.visibleColumns;
    final cells = <DataCell>[];
    
    if (v['sn'] ?? false) {
      cells.add(DataCell(Row(children: [
        Checkbox(
          value: isSelected,
          onChanged: (val) => p.toggleRowSelection(index),
          visualDensity: VisualDensity.compact,
        ),
        Text('${r.sn ?? index + 1}'),
      ])));
    }
    
    if (v['date'] ?? false) cells.add(DataCell(Text(DateFormat('d/M/yyyy').format(DateTime.parse(r.date)))));
    if (v['transType'] ?? false) cells.add(DataCell(Text(r.transType)));
    if (v['voucherNo'] ?? false) cells.add(DataCell(Text(r.voucherNo ?? '-')));
    
    // Debit / Credit with parity styling
    final amtStyle = isTemp ? const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, decoration: TextDecoration.underline) : null;
    
    if (v['debit'] ?? false) cells.add(DataCell(Align(alignment: Alignment.centerRight, child: Text(r.debit.toStringAsFixed(2), style: amtStyle))));
    if (v['credit'] ?? false) cells.add(DataCell(Align(alignment: Alignment.centerRight, child: Text(r.credit.toStringAsFixed(2), style: amtStyle))));
    
    if (v['balance'] ?? false) {
      final balBox = isTemp ? BoxDecoration(color: const Color(0xFFFEF9C3), border: Border.all(color: const Color(0xFFFDE047))) : (isSaved ? BoxDecoration(color: const Color(0xFFDCFCE7)) : null);
      cells.add(DataCell(Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: balBox,
          child: Text(_formatDrCr(r.balance), style: TextStyle(fontWeight: (isTemp || isSaved) ? FontWeight.bold : FontWeight.normal, color: isSaved ? const Color(0xFF166534) : null)),
        ),
      )));
    }
    
    if (v['shortNarr'] ?? false) cells.add(DataCell(SizedBox(width: 150, child: Text(r.shortNarr ?? '-', overflow: TextOverflow.ellipsis))));
    if (v['remarks'] ?? false) cells.add(DataCell(Text(r.remarks ?? '-')));
    if (v['settlementDate'] ?? false) cells.add(DataCell(Center(child: (isSaved || isTemp) ? _recvDateWidget(r, p, isTemp) : const Text(''))));
    
    if (v['view'] ?? false) {
      cells.add(DataCell(InkWell(
        onTap: () => _handleView(r),
        child: const Text('View', style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline)),
      )));
    }
    
    return cells;
  }

  Widget _recvDateWidget(model.LedgerRow r, LedgerProvider p, bool isTemp) {
     if (isTemp) return Text(p.paymentDate.isNotEmpty ? DateFormat('d/M').format(DateTime.parse(p.paymentDate)) : 'SET DATE', style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 10));
     
     return InkWell(
      onTap: () async {
        final d = await showDatePicker(context: context, initialDate: DateTime.parse(r.settlementDate!), firstDate: DateTime(2000), lastDate: DateTime(2100));
        if (d != null) {
          p.updateSingleSettlement(r, DateFormat('yyyy-MM-dd').format(d));
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFBBF7D0))),
        child: Text(DateFormat('d/M').format(DateTime.parse(r.settlementDate!)), style: const TextStyle(color: Color(0xFF166534), fontSize: 10, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _handleView(model.LedgerRow r) {
    final id = r.sourceId;
    if (id == null) {
      return;
    }
    
    final type = r.transType.toLowerCase();
    
    if (type.contains('purchase challan')) {
      context.push('/lenstransaction/purchase/AddLensPurchaseChallan/$id');
    } else if (type.contains('purchase order')) {
      context.push('/lenstransaction/purchase/AddLensPurchaseOrder/$id');
    } else if (type.contains('purchase')) {
      context.push('/lenstransaction/purchase/AddLensPurchase/$id');
    } else if (type.contains('sale challan')) {
      context.push('/lenstransaction/sale/AddLensSaleChallan/$id');
    } else if (type.contains('sale order')) {
      context.push('/lenstransaction/sale/AddLensSaleOrder/$id');
    } else if (type.contains('sale')) {
      context.push('/lenstransaction/sale/AddLensSale/$id');
    }
  }

  Widget _buildSummaryFooter(LedgerProvider provider) {
    if (!provider.hasSearched) {
      return const SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _sumItem('Total Debit', provider.report!.totalDebit.toStringAsFixed(2), Colors.blue),
          const SizedBox(width: 32),
          _sumItem('Total Credit', provider.report!.totalCredit.toStringAsFixed(2), Colors.indigo),
          const SizedBox(width: 32),
          _sumItem('Grand Balance', _formatDrCr(provider.report!.closingBalance), Colors.green.shade700),
        ],
      ),
    );
  }

  Widget _filterCol(String label, Widget child) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF374151))), // gray-700
      const SizedBox(height: 4),
      child,
    ]);
  }

  Widget _box(String text, IconData icon) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
      child: Row(children: [
        Text(text, style: const TextStyle(fontSize: 13)),
        const Spacer(),
        Icon(icon, size: 14, color: Colors.grey.shade600),
      ]),
    );
  }

  InputDecoration _inputDeco(String hint) {
    return InputDecoration(
      hintText: hint, 
      hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
      filled: true, 
      fillColor: Colors.white, 
      isDense: true, 
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Colors.grey.shade300)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Colors.blue)),
    );
  }

  List<DataCell> _buildAccountHeaderCells(LedgerProvider p) {
    final v = p.visibleColumns;
    final cells = <DataCell>[];
    String name = p.searchName.toUpperCase();
    
    if (v['sn'] ?? false) cells.add(const DataCell(Text('')));
    if (v['date'] ?? false) cells.add(const DataCell(Text('')));
    if (v['transType'] ?? false) {
      cells.add(DataCell(Center(child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1.2)))));
    } else {
       cells.add(const DataCell(Text('')));
    }

    final remainingIds = ['voucherNo', 'debit', 'credit', 'balance', 'shortNarr', 'remarks', 'settlementDate', 'view'];
    for (var id in remainingIds) {
      if (v[id] ?? false) cells.add(const DataCell(Text('')));
    }
    
    return cells;
  }

  Widget _sumItem(String label, String val, Color c) {
    return Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
        Text(val, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: c)),
    ]);
  }
}
