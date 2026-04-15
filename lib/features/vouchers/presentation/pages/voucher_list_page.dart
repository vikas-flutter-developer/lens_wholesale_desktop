import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:excel/excel.dart' as exc;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/voucher_provider.dart';
import '../../data/models/voucher_model.dart';

class VoucherListPage extends StatefulWidget {
  const VoucherListPage({super.key});

  @override
  State<VoucherListPage> createState() => _VoucherListPageState();
}

class _VoucherListPageState extends State<VoucherListPage> {
  String _recordType = 'All';
  String _billSeries = 'All';
  DateTime? _dateFrom;
  DateTime? _dateTo;
  final TextEditingController _searchCtrl = TextEditingController();
  String? _expandedVoucherId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VoucherProvider>().fetchVouchers();
    });
  }

  List<String> _getBillSeriesOptions(String type) {
    if (type == 'All') return ['All'];
    if (type == 'Payment') return ['All', 'P(25-26)', 'PUR_26', 'BPAY_25'];
    if (type == 'Receipt') return ['All', 'S(25-26)', 'SAL_26', 'BRCPT_25'];
    if (type == 'Journal') return ['All', 'JRNL_25-26'];
    if (type == 'Contra') return ['All', 'CONTRA_25-26'];
    if (type == 'Debit') return ['All', 'DR_NOTE_25'];
    if (type == 'Credit') return ['All', 'CR_NOTE_25'];
    return ['All', 'GEN_25'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Consumer<VoucherProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.vouchers.isEmpty) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF2563EB)));
                }

                final filtered = provider.vouchers.where((v) {
                  if (_recordType != 'All' && v.recordType != _recordType) return false;
                  if (_billSeries != 'All' && v.billSeries != _billSeries) return false;
                  if (_dateFrom != null) {
                    final d = v.date != null ? DateTime.parse(v.date!) : null;
                    if (d != null && d.isBefore(_dateFrom!)) return false;
                  }
                  if (_dateTo != null) {
                    final d = v.date != null ? DateTime.parse(v.date!) : null;
                    if (d != null && d.isAfter(_dateTo!.add(const Duration(days: 1)))) return false;
                  }
                  if (_searchCtrl.text.isNotEmpty) {
                    final q = _searchCtrl.text.toLowerCase();
                    final matchBill = v.billNo.toString().toLowerCase().contains(q);
                    final matchRemarks = (v.remarks ?? '').toLowerCase().contains(q);
                    final matchAccount = v.rows.any((r) => r.account.toLowerCase().contains(q));
                    if (!matchBill && !matchRemarks && !matchAccount) return false;
                  }
                  return true;
                }).toList();

                return Column(
                  children: [
                    _buildFilterSection(filtered),
                    Expanded(
                      child: filtered.isEmpty
                          ? _buildEmptyState()
                          : _buildTableView(filtered),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(28, 32, 28, 12),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add Voucher',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Manage payment and receipt vouchers',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(List<VoucherModel> filtered) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            spacing: 16,
            children: [
              Expanded(
                child: _filterDropdown('Record Type', _recordType,
                  ['All', 'Payment', 'Receipt', 'Journal', 'Contra', 'Debit', 'Credit'],
                  (v) => setState(() { _recordType = v!; _billSeries = 'All'; })),
              ),
              Expanded(
                child: _filterDropdown('Bill Series', _billSeries, _getBillSeriesOptions(_recordType),
                  (v) => setState(() => _billSeries = v!)),
              ),
              Expanded(child: _dateFilter('Date From', _dateFrom, (d) => setState(() => _dateFrom = d))),
              Expanded(child: _dateFilter('Date To', _dateTo, (d) => setState(() => _dateTo = d))),
              Expanded(
                child: _filterTextField('Search Text', _searchCtrl),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () => context.read<VoucherProvider>().fetchVouchers(),
                icon: const Icon(LucideIcons.search, size: 18),
                label: const Text('Search', style: TextStyle(fontWeight: FontWeight.w700)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _recordType = 'All';
                    _billSeries = 'All';
                    _dateFrom = null;
                    _dateTo = null;
                    _searchCtrl.clear();
                  });
                },
                icon: const Icon(LucideIcons.rotateCcw, size: 18),
                label: const Text('Reset', style: TextStyle(fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF64748B),
                  side: const BorderSide(color: Color(0xFFCBD5E1)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => context.go('/transaction/add-voucher'),
                icon: const Icon(LucideIcons.plus, size: 18),
                label: const Text('Add', style: TextStyle(fontWeight: FontWeight.w700)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
              ),
              const SizedBox(width: 12),
              _buildIconButton(LucideIcons.sheet, const Color(0xFFD1FAE5), const Color(0xFF10B981), 
                onPressed: () => _handleExportAll(filtered)),
              const SizedBox(width: 8),
              _buildIconButton(LucideIcons.printer, const Color(0xFFDBEafe), const Color(0xFF2563EB), 
                onPressed: () => _handlePrintAll(filtered)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, Color bg, Color iconColor, {required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        icon: Icon(icon, size: 20, color: iconColor),
        onPressed: onPressed,
      ),
    );
  }

  Widget _filterTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF475569))),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter text...',
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
          ),
        ),
      ],
    );
  }


  Widget _buildTableView(List<VoucherModel> filtered) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            _buildTableHeader(),
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final v = filtered[index];
                  return Column(
                    children: [
                      _buildTableRow(v, index),
                      if (_expandedVoucherId == v.id) _buildExpandedRow(v),
                      const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    ],
                  );
                },
              ),
            ),
            _buildSummarySection(filtered),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: const [
          Expanded(flex: 4, child: Text('Sr. No.', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF475569)))),
          Expanded(flex: 10, child: Text('Bill Date', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF475569)))),
          Expanded(flex: 11, child: Text('Bill Series', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF475569)))),
          Expanded(flex: 7, child: Text('Bill No.', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF475569)))),
          Expanded(flex: 17, child: Text('Party Name', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF475569)))),
          Expanded(flex: 8, child: Text('Debit', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF475569)))),
          Expanded(flex: 8, child: Text('Credit', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF475569)))),
          Expanded(flex: 13, child: Text('Remarks', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF475569)))),
          Expanded(flex: 22, child: Text('Action', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF475569)))),
        ],
      ),
    );
  }

  Widget _buildTableRow(VoucherModel v, int index) {
    final dateStr = v.date != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(v.date!)) : '-';
    final isExpanded = _expandedVoucherId == v.id;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: isExpanded ? const Color(0xFFF8FAFC) : Colors.transparent,
      child: Row(
        children: [
          Expanded(flex: 4, child: Text((index + 1).toString(), style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)))),
          Expanded(flex: 10, child: Text(dateStr, style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)))),
          Expanded(flex: 11, child: Text(v.billSeries, style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)))),
          Expanded(flex: 7, child: Text(v.billNo.toString(), style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)))),
          Expanded(flex: 17, child: Text(_getPartyName(v), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)))),
          Expanded(flex: 8, child: Text(v.totalDebit > 0 ? '₹${v.totalDebit.toStringAsFixed(0)}' : '-', textAlign: TextAlign.right, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)))),
          Expanded(flex: 8, child: Text(v.totalCredit > 0 ? '₹${v.totalCredit.toStringAsFixed(0)}' : '-', textAlign: TextAlign.right, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)))),
          Expanded(flex: 13, child: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Text(v.remarks ?? '-', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
          )),
          Expanded(
            flex: 22,
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _tableActionIcon(
                  v.id == _expandedVoucherId ? LucideIcons.chevronUp : LucideIcons.info,
                  isExpanded ? const Color(0xFF2563EB) : const Color(0xFF3B82F6),
                  isExpanded ? Colors.white : const Color(0xFFEFF6FF),
                  () => setState(() => _expandedVoucherId = isExpanded ? null : v.id),
                  tooltip: 'View Details',
                ),
                _tableActionIcon(LucideIcons.pencil, const Color(0xFF2563EB), const Color(0xFFEFF6FF), 
                  () => context.go('/transaction/add-voucher?id=${v.id}'), tooltip: 'Edit'),
                _tableActionIcon(LucideIcons.trash2, const Color(0xFFEF4444), const Color(0xFFFEF2F2), 
                  () => _confirmDelete(v), tooltip: 'Delete'),
                _tableActionIcon(LucideIcons.sheet, const Color(0xFF10B981), const Color(0xFFECFDF5), 
                  () => _handleExportVoucher(v), tooltip: 'Export Row'),
                _whatsappButton(v),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableActionIcon(IconData icon, Color color, Color bg, VoidCallback onTap, {String? tooltip}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Tooltip(
        message: tooltip ?? '',
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 16, color: color),
          ),
        ),
      ),
    );
  }

  Widget _whatsappButton(VoucherModel v) {
    return Tooltip(
      message: 'Share on WhatsApp',
      child: InkWell(
        onTap: () => _handleWhatsApp(v),
        child: Container(
          padding: const EdgeInsets.all(7),
          decoration: const BoxDecoration(color: Color(0xFF25D366), shape: BoxShape.circle),
          child: const FaIcon(FontAwesomeIcons.whatsapp, size: 14, color: Colors.white),
        ),
      ),
    );
  }

  // --- Logic Implementations ---

  Future<void> _handleWhatsApp(VoucherModel v) async {
    final party = _getPartyName(v);
    final date = v.date != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(v.date!)) : '-';
    // Match React concise format or keep it detailed but professional
    final text = "Voucher Details:\nSeries: ${v.billSeries}\nBill No: ${v.billNo}\nDate: $date\nParty: $party\nTotal: ₹${(v.totalDebit > 0 ? v.totalDebit : v.totalCredit).toStringAsFixed(2)}\nRemarks: ${v.remarks ?? '-'}";
    
    final url = Uri.parse("https://wa.me/?text=${Uri.encodeComponent(text)}");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not launch WhatsApp')));
    }
  }

  Future<void> _handleExportAll(List<VoucherModel> data) async {
    var excel = exc.Excel.createExcel();
    exc.Sheet sheet = excel['Vouchers'];
    excel.delete('Sheet1'); // Remove default sheet

    // Header styling
    exc.CellStyle headerStyle = exc.CellStyle(
      bold: true,
      backgroundColorHex: exc.ExcelColor.fromHexString('#F1F5F9'),
      fontColorHex: exc.ExcelColor.fromHexString('#1E293B'),
      horizontalAlign: exc.HorizontalAlign.Center,
    );

    // Append Header
    sheet.appendRow([
      exc.TextCellValue("Sr. No."),
      exc.TextCellValue("Bill Date"),
      exc.TextCellValue("Bill Series"),
      exc.TextCellValue("Bill No."),
      exc.TextCellValue("Party Name"),
      exc.TextCellValue("Debit"),
      exc.TextCellValue("Credit"),
      exc.TextCellValue("Remarks")
    ]);

    // Apply header style
    for (var i = 0; i < 8; i++) {
      sheet.cell(exc.CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0)).cellStyle = headerStyle;
    }
    
    for (int i = 0; i < data.length; i++) {
       final v = data[i];
       final dateStr = v.date != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(v.date!)) : '-';
       sheet.appendRow([
         exc.IntCellValue(i + 1),
         exc.TextCellValue(dateStr),
         exc.TextCellValue(v.billSeries),
         exc.IntCellValue(v.billNo),
         exc.TextCellValue(_getPartyName(v)),
         exc.DoubleCellValue(v.totalDebit),
         exc.DoubleCellValue(v.totalCredit),
         exc.TextCellValue(v.remarks ?? '-')
       ]);
    }

    try {
      final fileBytes = excel.save();
      final directory = await getApplicationDocumentsDirectory();
      final fileName = "vouchers_export_${DateTime.now().millisecondsSinceEpoch}.xlsx";
      final path = "${directory.path}/$fileName";
      final file = File(path);
      await file.writeAsBytes(fileBytes!);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Exported to Excel: $fileName'),
        backgroundColor: const Color(0xFF10B981),
        action: SnackBarAction(label: 'OK', textColor: Colors.white, onPressed: () {}),
      ));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Export failed: $e'), backgroundColor: Colors.red));
    }
  }

  Future<void> _handleExportVoucher(VoucherModel v) async {
     var excel = exc.Excel.createExcel();
     exc.Sheet sheet = excel['Voucher Details'];
     excel.delete('Sheet1');

     sheet.appendRow([
       exc.TextCellValue("SN"),
       exc.TextCellValue("Account"),
       exc.TextCellValue("Debit"),
       exc.TextCellValue("Credit"),
       exc.TextCellValue("Mode"),
       exc.TextCellValue("Remark")
     ]);

     for (var r in v.rows) {
       sheet.appendRow([
         exc.IntCellValue(r.sn),
         exc.TextCellValue(r.account),
         exc.DoubleCellValue(r.debit),
         exc.DoubleCellValue(r.credit),
         exc.TextCellValue(r.modeOfPayment),
         exc.TextCellValue(r.remark ?? '-')
       ]);
     }
     
     try {
       final fileBytes = excel.save();
       final directory = await getApplicationDocumentsDirectory();
       final fileName = "voucher_${v.billSeries}_${v.billNo}.xlsx";
       final path = "${directory.path}/$fileName";
       await File(path).writeAsBytes(fileBytes!);
       if (!mounted) return;
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
         content: Text('Voucher exported as Excel: $fileName'),
         backgroundColor: const Color(0xFF10B981),
       ));
     } catch (e) {
       if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Export failed: $e'), backgroundColor: Colors.red));
     }
  }

  Future<void> _handlePrintAll(List<VoucherModel> data) async {
    final pdf = pw.Document();
    
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Header(level: 0, child: pw.Text("Vouchers Report", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18))),
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
            cellStyle: const pw.TextStyle(fontSize: 9),
            headers: ["Sr.", "Date", "Series", "Bill No", "Party", "Debit", "Credit"],
            data: data.asMap().entries.map((e) {
              final v = e.value;
              final dateStr = v.date != null ? DateFormat('dd-MM-yy').format(DateTime.parse(v.date!)) : '-';
              return [
                e.key + 1,
                dateStr,
                v.billSeries,
                v.billNo,
                _getPartyName(v),
                v.totalDebit.toStringAsFixed(2),
                v.totalCredit.toStringAsFixed(2)
              ];
            }).toList(),
          ),
          pw.SizedBox(height: 20),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Text("Total Debit: ₹${data.fold(0.0, (s, v) => s + v.totalDebit).toStringAsFixed(2)}  ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text("Total Credit: ₹${data.fold(0.0, (s, v) => s + v.totalCredit).toStringAsFixed(2)}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ],
          )
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  Widget _buildExpandedRow(VoucherModel v) {
    if (v.rows.isEmpty) return const SizedBox.shrink();
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      color: const Color(0xFFF8FAFC),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFDBEAFE)),
          boxShadow: [BoxShadow(color: Colors.blue.withValues(alpha: 0.05), blurRadius: 10)],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(color: Color(0xFFDBEAFE), borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
              child: Row(
                children: const [
                  Expanded(flex: 1, child: Text('SN', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: Color(0xFF1E40AF)))),
                  Expanded(flex: 5, child: Text('Account', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: Color(0xFF1E40AF)))),
                  Expanded(flex: 2, child: Text('Debit', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: Color(0xFF1E40AF)))),
                  Expanded(flex: 2, child: Text('Credit', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: Color(0xFF1E40AF)))),
                  Expanded(flex: 2, child: Text('Mode', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: Color(0xFF1E40AF)))),
                  Expanded(flex: 5, child: Text('Remark', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: Color(0xFF1E40AF)))),
                ],
              ),
            ),
                      for (var row in v.rows)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFEFF6FF)))),
                          child: Row(
                            children: [
                              Expanded(flex: 1, child: Text(row.sn.toString(), style: const TextStyle(fontSize: 12, color: Color(0xFF475569)))),
                              Expanded(flex: 5, child: Text(row.account, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)))),
                              Expanded(flex: 2, child: Text(row.debit > 0 ? '₹${row.debit.toStringAsFixed(0)}' : '-', textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, color: Color(0xFF1E293B)))),
                              Expanded(flex: 2, child: Text(row.credit > 0 ? '₹${row.credit.toStringAsFixed(0)}' : '-', textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, color: Color(0xFF1E293B)))),
                              Expanded(flex: 2, child: Text(row.modeOfPayment, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)))),
                              Expanded(flex: 5, child: Text(row.remark ?? '-', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontStyle: FontStyle.italic))),
                            ],
                          ),
                        ),
                    ],
                  ),
      ),
    );
  }


  String _getPartyName(VoucherModel voucher) {
    if (voucher.rows.isEmpty) return 'No Account';
    // Try to find first account that isn't Cash or Bank
    for (var row in voucher.rows) {
      final name = row.account.toLowerCase();
      if (!name.contains('cash') && !name.contains('bank')) {
        return row.account;
      }
    }
    // Fallback to first row
    return voucher.rows[0].account;
  }

  Widget _buildSummarySection(List<VoucherModel> filtered) {
    final totalDr = filtered.fold(0.0, (sum, v) => sum + v.totalDebit);
    final totalCr = filtered.fold(0.0, (sum, v) => sum + v.totalCredit);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _summaryText('Total : (Dr) ₹${totalDr.toStringAsFixed(0)}'),
          const SizedBox(width: 32),
          _summaryText('Total : (Cr) ₹${totalCr.toStringAsFixed(0)}'),
        ],
      ),
    );
  }

  Widget _summaryText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: Color(0xFF1E293B),
      ),
    );
  }

  Widget _filterDropdown(String label, String value, List<String> options, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF475569))),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value,
          items: options.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13)))).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
          ),
        ),
      ],
    );
  }

  Widget _dateFilter(String label, DateTime? date, Function(DateTime?) onSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF475569))),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final d = await showDatePicker(
              context: context,
              initialDate: date ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            onSelected(d);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE2E8F0)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    date != null ? DateFormat('dd-MM-yyyy').format(date) : 'dd-mm-yyyy',
                    style: TextStyle(
                      fontSize: 13,
                      color: date != null ? const Color(0xFF1E293B) : const Color(0xFF94A3B8),
                    ),
                  ),
                ),
                const Icon(LucideIcons.calendar, size: 16, color: Color(0xFF94A3B8)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Loading vouchers...',
            style: TextStyle(fontSize: 15, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(VoucherModel voucher) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete voucher ${voucher.billNo}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), style: TextButton.styleFrom(foregroundColor: Colors.red), child: const Text('Delete')),
        ],
      ),
    );

    if (confirm == true) {
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      final res = await context.read<VoucherProvider>().deleteVoucher(voucher.id!);
      if (!mounted) return;
      if (res['success'] == true) {
        messenger.showSnackBar(const SnackBar(content: Text('Voucher deleted successfully')));
      } else {
        messenger.showSnackBar(SnackBar(content: Text(res['error'] ?? 'Delete failed')));
      }
    }
  }
}
