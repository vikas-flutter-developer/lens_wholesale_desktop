import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../data/providers/ledger_provider.dart';
import '../../data/models/ledger_model.dart' as model;
import '../../../masters/data/providers/account_provider.dart';
import '../../../masters/data/models/account_model.dart';
import '../../../../features/masters/data/providers/account_group_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';


class AccountLedgerDetailsPage extends StatefulWidget {
  const AccountLedgerDetailsPage({super.key});

  @override
  State<AccountLedgerDetailsPage> createState() => _AccountLedgerDetailsPageState();
}

class _AccountLedgerDetailsPageState extends State<AccountLedgerDetailsPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  final ScrollController _horizontalScrollController = ScrollController();

  // --- Soft Web Colors ---
  final Color _borderColor = const Color(0xFFCBD5E1); // Light slate-300
  final Color _textColor = const Color(0xFF334155);   // Soft slate-700
  final Color _hintColor = const Color(0xFF94A3B8);   // Lighter slate-400
  final Color _iconColor = const Color(0xFF64748B);   // Medium slate-500

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountProvider>().fetchAllAccounts();
      context.read<AccountGroupProvider>().fetchAllAccountGroups();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _horizontalScrollController.dispose();
    super.dispose();
  }

  String _formatDrCr(double val) {
    if (val == 0) return "0.00";
    final side = val < 0 ? "CR" : "DR";
    return "${val.abs().toStringAsFixed(2)} $side";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // bg-gray-100
      body: Consumer<LedgerProvider>(builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Text(
                'Ledger Book Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withValues(alpha: 0.8),
                ),
              ),
            ),
            _buildFilterBar(provider),
            Expanded(
              child: provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildDetailsTable(provider),
            ),
            // Bottom summary
            _buildSummaryFooter(provider),
          ],
        );
      }),
    );
  }

  Widget _buildSummaryFooter(LedgerProvider provider) {
    if (!provider.hasSearched || provider.report == null) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _sumItem('Total Debit', provider.report!.totalDebit.toStringAsFixed(2), Colors.blue),
          const SizedBox(width: 24),
          _sumItem('Total Credit', provider.report!.totalCredit.toStringAsFixed(2), Colors.indigo),
          const SizedBox(width: 24),
          _sumItem('Grand Balance', _formatDrCr(provider.report!.closingBalance), Colors.green),
        ],
      ),
    );
  }

  Widget _sumItem(String label, String val, Color c) {
    return Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
      Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
      Text(val, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: c)),
    ]);
  }

  void _showColumnFilter(BuildContext context, LedgerProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Columns'),
        content: SizedBox(
          width: 300,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...[
                  {'id': 'sn', 'label': 'SN'},
                  {'id': 'date', 'label': 'Date'},
                  {'id': 'voucherType', 'label': 'Voucher Type'},
                  {'id': 'voucherDetail', 'label': 'Voucher Detail'},
                  {'id': 'itemName', 'label': 'Item Name'},
                  {'id': 'orderNo', 'label': 'Order No'},
                  {'id': 'lensPower', 'label': 'Lens Power'},
                  {'id': 'qty', 'label': 'Qty'},
                  {'id': 'price', 'label': 'Price'},
                  {'id': 'amount', 'label': 'Amount'},
                  {'id': 'debit', 'label': 'Debit'},
                  {'id': 'credit', 'label': 'Credit'},
                  {'id': 'balance', 'label': 'Balance'},
                  {'id': 'remarks', 'label': 'Remarks'},
                ].map((c) {
                  return Consumer<LedgerProvider>(builder: (context, p, _) {
                    bool isChecked = false;
                    if (c['id'] == 'lensPower') {
                      isChecked = p.detailsVisibleColumns['eye'] ?? false;
                    } else {
                      isChecked = p.detailsVisibleColumns[c['id']!] ?? false;
                    }
                    return CheckboxListTile(
                      title: Text(c['label']!, style: const TextStyle(fontSize: 13)),
                      value: isChecked,
                      dense: true,
                      onChanged: (v) {
                        if (c['id'] == 'lensPower') {
                          for (var id in ['eye', 'sph', 'cyl', 'axis', 'add']) {
                            p.toggleColumn(id, isDetails: true);
                          }
                        } else {
                          p.toggleColumn(c['id']!, isDetails: true);
                        }
                      },
                    );
                  });
                }),
              ],
            ),
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
      ),
    );
  }

  Widget _buildFilterBar(LedgerProvider provider) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _filterCol('Date From', SizedBox(width: 140, child: _dateBox(provider.fromDate, (d) => provider.setFromDate(d)))),
              const SizedBox(width: 12),
              _filterCol('To', SizedBox(width: 140, child: _dateBox(provider.toDate, (d) => provider.setToDate(d)))),
              const SizedBox(width: 12),

              // Standardized Station Name Input
              _filterCol('Station Name', SizedBox(width: 180, child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(color: Colors.white, border: Border.all(color: _borderColor), borderRadius: BorderRadius.circular(4)),
                child: Center(
                  child: TextField(
                    style: TextStyle(fontSize: 13, color: _textColor),
                    decoration: _noBorderDeco('Select Station'),
                    onChanged: (v) => provider.setStationName(v),
                  ),
                ),
              ))),

              const SizedBox(width: 12),
              _filterCol('Acc Group', SizedBox(width: 160, child: _groupDropdown(provider))),
              const SizedBox(width: 12),
              Expanded(child: _filterCol('Account Name', _accountAutocomplete(provider))),
              const SizedBox(width: 12),

              // Action Buttons
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => provider.fetchLedger(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                        fixedSize: const Size.fromHeight(40),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        elevation: 0,
                      ),
                      child: Row(
                        children: const [
                          Icon(LucideIcons.search, size: 16),
                          SizedBox(width: 6),
                          Text('Search', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () { _searchCtrl.clear(); provider.reset(); },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                        fixedSize: const Size.fromHeight(40),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        elevation: 0,
                      ),
                      child: Row(
                        children: const [
                          Icon(LucideIcons.rotateCw, size: 16),
                          SizedBox(width: 6),
                          Text('Reset', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildActionRow(provider),
        ],
      ),
    );
  }

  Widget _buildActionRow(LedgerProvider provider) {
    return Row(
      children: [
        _buildColumnSelectorBtn(provider),
        const SizedBox(width: 8),
        _iconBtn(LucideIcons.mail, const Color(0xFFF59E0B), () {}), // Orange
        const SizedBox(width: 8),
        _iconBtn(FontAwesomeIcons.whatsapp, const Color(0xFF22C55E), () => _handleWhatsApp(provider)), // Green
        const SizedBox(width: 8),
        _iconBtn(LucideIcons.printer, const Color(0xFF3B82F6), () => _printLedger(provider)), // Blue
        const Spacer(),
        if (provider.hasSearched)
          Text(
            'Debit: ${provider.report?.totalDebit.toStringAsFixed(2)} | Credit: ${provider.report?.totalCredit.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
      ],
    );
  }

  Widget _buildColumnSelectorBtn(LedgerProvider provider) {
    final selectedCount = provider.detailsVisibleColumns.values.where((v) => v).length;
    return OutlinedButton.icon(
      onPressed: () => _showColumnFilter(context, provider),
      icon: const Icon(LucideIcons.chevronDown, size: 14),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Columns', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
            child: Text('$selectedCount selected', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        minimumSize: const Size(0, 34),
        side: const BorderSide(color: Colors.grey),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }

  Widget _iconBtn(dynamic icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
        child: icon is IconData
            ? Icon(icon, size: 18, color: Colors.white)
            : FaIcon(icon, size: 16, color: Colors.white),
      ),
    );
  }

  Future<void> _handleWhatsApp(LedgerProvider provider) async {
    if (!provider.hasSearched || provider.report == null) return;
    final text = "Ledger Book Details - ${provider.searchName}\n"
        "Date: ${DateFormat('dd-MM-yy').format(provider.fromDate)} to ${DateFormat('dd-MM-yy').format(provider.toDate)}\n"
        "Debit: ${provider.report!.totalDebit.toStringAsFixed(2)}\n"
        "Credit: ${provider.report!.totalCredit.toStringAsFixed(2)}\n"
        "Grand Balance: ${_formatDrCr(provider.report!.closingBalance)}";
    final url = Uri.parse("https://wa.me/?text=${Uri.encodeComponent(text)}");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _printLedger(LedgerProvider provider) async {
    if (!provider.hasSearched || provider.report == null) return;

    final pdf = pw.Document();
    final font = await PdfGoogleFonts.interRegular();
    final fontBold = await PdfGoogleFonts.interBold();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (context) => [
          pw.Header(level: 0, child: pw.Text("Ledger Book Details - ${provider.searchName}", style: pw.TextStyle(font: fontBold, fontSize: 16))),
          pw.SizedBox(height: 10),
          pw.TableHelper.fromTextArray(
            headers: _getReportHeaders(provider.detailsVisibleColumns),
            data: _getReportData(provider.report!.data, provider.detailsVisibleColumns),
            headerStyle: pw.TextStyle(font: fontBold, fontSize: 8),
            cellStyle: pw.TextStyle(font: font, fontSize: 7),
            cellAlignment: pw.Alignment.centerLeft,
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  List<String> _getReportHeaders(Map<String, bool> v) {
    final list = <String>[];
    if (v['sn'] ?? false) list.add('SN');
    if (v['date'] ?? false) list.add('Date');
    if (v['voucherType'] ?? false) list.add('Type');
    if (v['voucherDetail'] ?? false) list.add('Detail');
    if (v['itemName'] ?? false) list.add('Item');
    if (v['orderNo'] ?? false) list.add('Order');
    if (v['qty'] ?? false) list.add('Qty');
    if (v['amount'] ?? false) list.add('Amt');
    if (v['debit'] ?? false) list.add('Dr');
    if (v['credit'] ?? false) list.add('Cr');
    if (v['balance'] ?? false) list.add('Bal');
    return list;
  }

  List<List<dynamic>> _getReportData(List<model.LedgerRow> data, Map<String, bool> v) {
    final list = <List<dynamic>>[];
    for (var i = 0; i < data.length; i++) {
      final r = data[i];
      final items = r.items ?? [];
      if (items.isEmpty) {
        list.add(_pdfRow(r, i+1, null, v, true));
      } else {
        for (var j = 0; j < items.length; j++) {
          list.add(_pdfRow(r, i+1, items[j], v, j == 0));
        }
      }
    }
    return list;
  }

  List<dynamic> _pdfRow(model.LedgerRow r, int sn, model.LedgerItemDetail? it, Map<String, bool> v, bool first) {
    final row = <dynamic>[];
    if (v['sn'] ?? false) row.add(first ? '$sn' : '');
    if (v['date'] ?? false) row.add(first ? DateFormat('dd-MM').format(DateTime.parse(r.date)) : '');
    if (v['voucherType'] ?? false) row.add(first ? r.transType : '');
    if (v['voucherDetail'] ?? false) row.add(first ? (r.voucherNo ?? '') : '');
    if (v['itemName'] ?? false) row.add(it?.itemName ?? '');
    if (v['orderNo'] ?? false) row.add(it?.orderNo ?? '');
    if (v['qty'] ?? false) row.add(it?.qty?.toString() ?? '');
    if (v['amount'] ?? false) row.add(it?.amount?.toStringAsFixed(2) ?? '');
    if (v['debit'] ?? false) row.add(first ? r.debit.toStringAsFixed(2) : '');
    if (v['credit'] ?? false) row.add(first ? r.credit.toStringAsFixed(2) : '');
    if (v['balance'] ?? false) row.add(first ? _formatDrCr(r.balance) : '');
    return row;
  }

  Widget _buildDetailsTable(LedgerProvider provider) {
    if (!provider.hasSearched) return const Center(child: Text('Search an account to view details'));

    final rows = provider.report!.data;
    final visible = provider.detailsVisibleColumns;

    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.grey.shade300,
        dataTableTheme: const DataTableThemeData(
          headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 13),
          dataTextStyle: TextStyle(fontSize: 12, color: Colors.black87),
        ),
      ),
      child: LayoutBuilder(
          builder: (context, constraints) {
            final double dynamicSpacing = constraints.maxWidth < 1000 ? 12.0 : 24.0;

            return Scrollbar(
              controller: _horizontalScrollController,
              thumbVisibility: true,
              trackVisibility: true,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  controller: _horizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: constraints.maxWidth,
                    ),
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(const Color(0xFFF3F4F6)),
                      dataRowMinHeight: 30,
                      dataRowMaxHeight: 36,
                      headingRowHeight: 38,
                      columnSpacing: dynamicSpacing,
                      horizontalMargin: 16,
                      border: TableBorder.all(color: Colors.grey.shade200, width: 0.5),
                      columns: _buildColumns(visible),
                      rows: [
                        DataRow(
                          color: WidgetStateProperty.all(const Color(0xFFDBEAFE)),
                          cells: _buildAccountHeaderCells(provider),
                        ),
                        DataRow(
                          color: WidgetStateProperty.all(const Color(0xFFF9FAFB)),
                          cells: _buildOpeningCells(provider, visible),
                        ),
                        ..._buildDataRows(rows, visible),
                        DataRow(
                          color: WidgetStateProperty.all(const Color(0xFFF3F4F6)),
                          cells: _buildTotalsRowCells(provider, visible),
                        ),
                        DataRow(
                          color: WidgetStateProperty.all(const Color(0xFFF9FAFB)),
                          cells: _buildClosingCells(provider, visible),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
      ),
    );
  }

  List<DataCell> _buildTotalsRowCells(LedgerProvider p, Map<String, bool> v) {
    int totalQty = 0;
    double totalAmount = 0.0;

    for (var r in p.report!.data) {
      if (r.items != null) {
        for (var it in r.items!) {
          totalQty += (it.qty ?? 0).toInt();
          totalAmount += (it.amount ?? 0.0).toDouble();
        }
      }
    }

    final cells = <DataCell>[];
    const styleBold = TextStyle(fontWeight: FontWeight.bold, color: Colors.black87);
    const styleBlue = TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A));

    if (v['sn'] ?? false) cells.add(const DataCell(Text('')));
    if (v['date'] ?? false) cells.add(const DataCell(Text('')));
    if (v['voucherType'] ?? false) cells.add(const DataCell(Text('')));
    if (v['voucherDetail'] ?? false) cells.add(const DataCell(Text('')));
    if (v['itemName'] ?? false) cells.add(const DataCell(Text('')));
    if (v['orderNo'] ?? false) cells.add(const DataCell(Text('')));
    if (v['eye'] ?? false) cells.add(const DataCell(Text('')));
    if (v['sph'] ?? false) cells.add(const DataCell(Text('')));
    if (v['cyl'] ?? false) cells.add(const DataCell(Text('')));
    if (v['axis'] ?? false) cells.add(const DataCell(Text('')));
    if (v['add'] ?? false) cells.add(const DataCell(Text('')));

    if (v['qty'] ?? false) cells.add(DataCell(Align(alignment: Alignment.centerRight, child: Text(totalQty.toString(), style: styleBold))));
    if (v['price'] ?? false) cells.add(const DataCell(Text('')));
    if (v['amount'] ?? false) cells.add(DataCell(Align(alignment: Alignment.centerRight, child: Text(totalAmount.toStringAsFixed(2), style: styleBold))));
    if (v['debit'] ?? false) cells.add(DataCell(Align(alignment: Alignment.centerRight, child: Text(p.report!.totalDebit.toStringAsFixed(2), style: styleBlue))));
    if (v['credit'] ?? false) cells.add(DataCell(Align(alignment: Alignment.centerRight, child: Text(p.report!.totalCredit.toStringAsFixed(2), style: styleBlue))));
    if (v['balance'] ?? false) cells.add(DataCell(Align(alignment: Alignment.centerRight, child: Text(_formatDrCr(p.report!.closingBalance), style: styleBlue))));
    if (v['remarks'] ?? false) cells.add(const DataCell(Text('')));

    return cells;
  }

  List<DataCell> _buildAccountHeaderCells(LedgerProvider p) {
    final v = p.detailsVisibleColumns;
    final visibleCount = v.values.where((v) => v).length;
    String name = p.searchName.toUpperCase();

    return [
      DataCell(
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
        ),
      ),
      ...List.generate(visibleCount - 1, (index) => const DataCell(Text(''))),
    ];
  }

  List<DataColumn> _buildColumns(Map<String, bool> visible) {
    final list = <DataColumn>[];
    if (visible['sn'] ?? false) list.add(const DataColumn(label: Text('SN')));
    if (visible['date'] ?? false) list.add(const DataColumn(label: Text('Date')));
    if (visible['voucherType'] ?? false) list.add(const DataColumn(label: Text('Voucher Type')));
    if (visible['voucherDetail'] ?? false) list.add(DataColumn(label: Expanded(child: const Text('Voucher Detail'))));
    if (visible['itemName'] ?? false) list.add(DataColumn(label: Expanded(child: const Text('Item Name'))));
    if (visible['orderNo'] ?? false) list.add(DataColumn(label: Text('Order No')));
    if (visible['eye'] ?? false) list.add(const DataColumn(label: Text('Eye')));
    if (visible['sph'] ?? false) list.add(const DataColumn(label: Text('Sph')));
    if (visible['cyl'] ?? false) list.add(const DataColumn(label: Text('Cyl')));
    if (visible['axis'] ?? false) list.add(const DataColumn(label: Text('Axis')));
    if (visible['add'] ?? false) list.add(const DataColumn(label: Text('Add')));
    if (visible['qty'] ?? false) list.add(const DataColumn(label: Text('Qty', textAlign: TextAlign.right)));
    if (visible['price'] ?? false) list.add(const DataColumn(label: Text('Price', textAlign: TextAlign.right)));
    if (visible['amount'] ?? false) list.add(const DataColumn(label: Text('Amount', textAlign: TextAlign.right)));
    if (visible['debit'] ?? false) list.add(const DataColumn(label: Text('Debit', textAlign: TextAlign.right)));
    if (visible['credit'] ?? false) list.add(const DataColumn(label: Text('Credit', textAlign: TextAlign.right)));
    if (visible['balance'] ?? false) list.add(const DataColumn(label: Text('Balance', textAlign: TextAlign.right)));
    if (visible['remarks'] ?? false) list.add(DataColumn(label: Expanded(child: const Text('Remarks'))));
    return list;
  }

  List<DataCell> _buildOpeningCells(LedgerProvider p, Map<String, bool> v) {
    return _buildSummaryRowCells(v, 'Opening Balance', _formatDrCr(p.report!.openingBalance));
  }

  List<DataCell> _buildClosingCells(LedgerProvider p, Map<String, bool> v) {
    return _buildSummaryRowCells(v, 'Closing Balance', _formatDrCr(p.report!.closingBalance));
  }

  List<DataCell> _buildSummaryRowCells(Map<String, bool> v, String label, String balance) {
    final cells = <DataCell>[];
    if (v['sn'] ?? false) cells.add(const DataCell(Text('-')));
    if (v['date'] ?? false) cells.add(const DataCell(Text('')));
    if (v['voucherType'] ?? false) { cells.add(DataCell(Text(label, style: const TextStyle(fontWeight: FontWeight.bold)))); }

    final midKeys = ['voucherDetail', 'itemName', 'orderNo', 'eye', 'sph', 'cyl', 'axis', 'add', 'qty', 'price', 'amount', 'debit', 'credit'];
    for (var k in midKeys) {
      if (v[k] ?? false) cells.add(const DataCell(Text('')));
    }

    if (v['balance'] ?? false) cells.add(DataCell(Align(alignment: Alignment.centerRight, child: Text(balance, style: const TextStyle(fontWeight: FontWeight.bold)))));
    if (v['remarks'] ?? false) cells.add(const DataCell(Text('')));

    return cells;
  }

  List<DataRow> _buildDataRows(List<model.LedgerRow> data, Map<String, bool> v) {
    final list = <DataRow>[];
    for (var i = 0; i < data.length; i++) {
      final r = data[i];
      final items = r.items ?? [];

      if (items.isEmpty) {
        list.add(_buildSingleDataRow(r, i + 1, null, v, i));
      } else {
        for (var j = 0; j < items.length; j++) {
          list.add(_buildSingleDataRow(r, i + 1, items[j], v, i, isFirstItem: j == 0));
        }
      }
    }
    return list;
  }

  DataRow _buildSingleDataRow(model.LedgerRow r, int sn, model.LedgerItemDetail? item, Map<String, bool> v, int rowIndex, {bool isFirstItem = true}) {
    final cells = <DataCell>[];
    if (v['sn'] ?? false) cells.add(DataCell(Text(isFirstItem ? '$sn' : '')));
    if (v['date'] ?? false) cells.add(DataCell(Text(isFirstItem ? DateFormat('dd-MM-yy').format(DateTime.parse(r.date)) : '')));
    if (v['voucherType'] ?? false) cells.add(DataCell(Text(isFirstItem ? r.transType : '')));
    if (v['voucherDetail'] ?? false) cells.add(DataCell(Text(isFirstItem ? (r.voucherNo ?? '-') : '')));
    if (v['itemName'] ?? false) cells.add(DataCell(Text(item?.itemName ?? '-')));
    if (v['orderNo'] ?? false) cells.add(DataCell(Text(item?.orderNo ?? '-')));
    if (v['eye'] ?? false) cells.add(DataCell(Text(item?.eye ?? '-')));
    if (v['sph'] ?? false) cells.add(DataCell(Text(item?.sph ?? '-')));
    if (v['cyl'] ?? false) cells.add(DataCell(Text(item?.cyl ?? '-')));
    if (v['axis'] ?? false) cells.add(DataCell(Text(item?.axis ?? '-')));
    if (v['add'] ?? false) cells.add(DataCell(Text(item?.add ?? '-')));
    if (v['qty'] ?? false) cells.add(DataCell(Align(alignment: Alignment.centerRight, child: Text(item?.qty?.toString() ?? '-'))));
    if (v['price'] ?? false) cells.add(DataCell(Align(alignment: Alignment.centerRight, child: Text(item?.price?.toStringAsFixed(2) ?? '-'))));
    if (v['amount'] ?? false) cells.add(DataCell(Align(alignment: Alignment.centerRight, child: Text(item?.amount?.toStringAsFixed(2) ?? '-'))));
    if (v['debit'] ?? false) cells.add(DataCell(Align(alignment: Alignment.centerRight, child: Text(isFirstItem ? r.debit.toStringAsFixed(2) : ''))));
    if (v['credit'] ?? false) cells.add(DataCell(Align(alignment: Alignment.centerRight, child: Text(isFirstItem ? r.credit.toStringAsFixed(2) : ''))));
    if (v['balance'] ?? false) cells.add(DataCell(Align(alignment: Alignment.centerRight, child: Text(isFirstItem ? _formatDrCr(r.balance) : ''))));
    if (v['remarks'] ?? false) cells.add(DataCell(Text(isFirstItem ? (r.remarks ?? '-') : '')));

    return DataRow(
      color: WidgetStateProperty.all(rowIndex % 2 == 0 ? Colors.white : const Color(0xFFF9FAFB)),
      cells: cells,
    );
  }

  // Standardized Date Box
  Widget _dateBox(DateTime date, Function(DateTime) onSelect) {
    return InkWell(
      onTap: () async {
        final d = await showDatePicker(context: context, initialDate: date, firstDate: DateTime(2000), lastDate: DateTime(2100));
        if (d != null) onSelect(d);
      },
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: _borderColor), borderRadius: BorderRadius.circular(4)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(DateFormat('dd-MM-yyyy').format(date), style: TextStyle(fontSize: 13, color: _textColor)),
            Icon(LucideIcons.calendar, size: 16, color: _iconColor),
          ],
        ),
      ),
    );
  }

  // Standardized Autocomplete Input
  Widget _accountAutocomplete(LedgerProvider provider) {
    return Consumer<AccountProvider>(builder: (context, accProv, _) => Autocomplete<AccountModel>(
      key: ValueKey(provider.searchName.isEmpty),
      displayStringForOption: (a) => a.name,
      optionsBuilder: (v) => v.text.isEmpty ? [] : accProv.accounts.where((a) => a.name.toLowerCase().contains(v.text.toLowerCase())),
      onSelected: (a) { provider.setSearchName(a.name); _searchCtrl.text = a.name; },
      fieldViewBuilder: (ctx, ctrl, focus, onSub) {
        return Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(color: Colors.white, border: Border.all(color: _borderColor), borderRadius: BorderRadius.circular(4)),
          child: Center(
            child: TextField(
              controller: ctrl,
              focusNode: focus,
              style: TextStyle(fontSize: 13, color: _textColor),
              decoration: _noBorderDeco('Account...'),
              onChanged: (v) => provider.setSearchName(v),
            ),
          ),
        );
      },
    ));
  }

  // Standardized Group Dropdown
  Widget _groupDropdown(LedgerProvider provider) {
    return Consumer<AccountGroupProvider>(builder: (context, groupProv, _) {
      final currentValue = provider.accountGroup.isEmpty ? '' : provider.accountGroup;

      return Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: _borderColor),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              isDense: true,
              value: currentValue,
              icon: Icon(LucideIcons.chevronDown, size: 16, color: _iconColor),
              style: TextStyle(fontSize: 13, color: _textColor),
              items: [
                DropdownMenuItem(
                    value: '',
                    child: Text('Select Group', style: TextStyle(color: _hintColor))
                ),
                ...groupProv.accountGroups.map((g) => DropdownMenuItem(
                    value: g.accountGroupName,
                    child: Text(g.accountGroupName)
                )),
              ],
              onChanged: (v) => provider.setAccountGroup(v ?? ''),
            ),
          ),
        ),
      );
    });
  }

  // New Borderless Decoration for the TextFields inside Containers
  InputDecoration _noBorderDeco(String hint) {
    return InputDecoration(
      isDense: true,
      contentPadding: EdgeInsets.zero,
      border: InputBorder.none,
      hintText: hint,
      hintStyle: TextStyle(fontSize: 13, color: _hintColor),
    );
  }

  Widget _filterCol(String label, Widget child) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
      Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF334155))),
      const SizedBox(height: 6),
      child,
    ]);
  }
}