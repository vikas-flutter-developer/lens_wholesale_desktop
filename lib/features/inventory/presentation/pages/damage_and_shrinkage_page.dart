import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:excel/excel.dart' as excel_lib;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../providers/inventory_provider.dart';
import '../../data/models/damage_entry_model.dart';

class DamageAndShrinkagePage extends StatefulWidget {
  const DamageAndShrinkagePage({super.key});

  @override
  State<DamageAndShrinkagePage> createState() => _DamageAndShrinkagePageState();
}

class _DamageAndShrinkagePageState extends State<DamageAndShrinkagePage> {
  final TextEditingController _searchCtrl = TextEditingController();
  final TextEditingController _billSeriesCtrl = TextEditingController();
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InventoryProvider>().fetchAllDamageEntries();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _billSeriesCtrl.dispose();
    super.dispose();
  }

  void _handleReset() {
    setState(() {
      _searchCtrl.clear();
      _billSeriesCtrl.clear();
      _fromDate = null;
      _toDate = null;
    });
  }

  List<DamageEntryModel> _getFilteredEntries(List<DamageEntryModel> entries) {
    return entries.where((v) {
      final q = _searchCtrl.text.toLowerCase();
      final series = _billSeriesCtrl.text.toLowerCase();

      // Search Text Filter
      if (q.isNotEmpty) {
        final itemNames = v.items.map((it) => it.itemName).join(" ").toLowerCase();
        final searchString = "${v.billNo} ${v.billSeries} ${v.type} ${v.godown} $itemNames".toLowerCase();
        if (!searchString.contains(q)) return false;
      }

      // Bill Series Filter
      if (series.isNotEmpty && !v.billSeries.toLowerCase().contains(series)) {
        return false;
      }

      // Date Range Filter
      if (v.date != null) {
        final entryDate = DateTime.parse(v.date!);
        if (_fromDate != null && entryDate.isBefore(_fromDate!)) return false;
        if (_toDate != null && entryDate.isAfter(_toDate!.add(const Duration(days: 1)))) return false;
      }

      return true;
    }).toList();
  }

  Future<void> _exportToExcel(List<DamageEntryModel> data) async {
    if (data.isEmpty) return;

    final excel = excel_lib.Excel.createExcel();
    final sheet = excel['DamageAndShrinkage'];
    excel.delete('Sheet1');

    // Headers
    sheet.appendRow([
      excel_lib.TextCellValue("Sr No."),
      excel_lib.TextCellValue("Bill Date"),
      excel_lib.TextCellValue("Bill Series"),
      excel_lib.TextCellValue("Bill No."),
      excel_lib.TextCellValue("Type"),
      excel_lib.TextCellValue("Godown"),
      excel_lib.TextCellValue("Items"),
      excel_lib.TextCellValue("Total Qty"),
      excel_lib.TextCellValue("Total Amt (₹)"),
    ]);

    // Data
    for (int i = 0; i < data.length; i++) {
      final v = data[i];
      final itemNames = v.items.map((it) => it.itemName).join(", ");
      sheet.appendRow([
        excel_lib.IntCellValue(i + 1),
        excel_lib.TextCellValue(v.date != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(v.date!)) : "-"),
        excel_lib.TextCellValue(v.billSeries),
        excel_lib.TextCellValue(v.billNo),
        excel_lib.TextCellValue(v.type),
        excel_lib.TextCellValue(v.godown),
        excel_lib.TextCellValue(itemNames),
        excel_lib.IntCellValue(v.totalQty),
        excel_lib.DoubleCellValue(v.totalAmt),
      ]);
    }

    // Totals
    final totalQty = data.fold(0, (sum, e) => sum + e.totalQty);
    final totalAmt = data.fold(0.0, (sum, e) => sum + e.totalAmt);
    sheet.appendRow([
      excel_lib.TextCellValue(""),
      excel_lib.TextCellValue(""),
      excel_lib.TextCellValue(""),
      excel_lib.TextCellValue(""),
      excel_lib.TextCellValue(""),
      excel_lib.TextCellValue(""),
      excel_lib.TextCellValue("TOTALS"),
      excel_lib.IntCellValue(totalQty),
      excel_lib.DoubleCellValue(totalAmt),
    ]);

    final bytes = excel.save();
    if (bytes != null) {
      await Printing.sharePdf(bytes: Uint8List.fromList(bytes), filename: "DamageAndShrinkage_${DateFormat('yyyyMMdd').format(DateTime.now())}.xlsx");
    }
  }

  Future<void> _printAll(List<DamageEntryModel> data) async {
    final pdf = pw.Document();
    final totalQty = data.fold(0, (sum, e) => sum + e.totalQty);
    final totalAmt = data.fold(0.0, (sum, e) => sum + e.totalAmt);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(32),
        header: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("Damage & Shrinkage Report", style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
            pw.SizedBox(height: 4),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("Total Records: ${data.length}", style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                pw.Text("Printed: ${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now())}", style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
              ],
            ),
            pw.Divider(thickness: 2, color: PdfColors.blue900),
            pw.SizedBox(height: 10),
          ],
        ),
        build: (pw.Context context) => [
          pw.TableHelper.fromTextArray(
            headers: ["#", "Date", "Series", "Bill No", "Type", "Godown", "Items", "Qty", "Amt"],
            data: data.asMap().entries.map((e) {
              final v = e.value;
              return [
                (e.key + 1).toString(),
                v.date != null ? DateFormat('dd/MM/yy').format(DateTime.parse(v.date!)) : "-",
                v.billSeries,
                v.billNo,
                v.type,
                v.godown,
                v.items.map((it) => it.itemName).join(", "),
                v.totalQty.toString(),
                "₹${v.totalAmt.toStringAsFixed(2)}"
              ];
            }).toList(),
            headerStyle: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 10),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.blue900),
            cellPadding: const pw.EdgeInsets.all(5),
            cellStyle: const pw.TextStyle(fontSize: 9),
            columnWidths: {
              0: const pw.FixedColumnWidth(25),
              1: const pw.FixedColumnWidth(60),
              2: const pw.FixedColumnWidth(40),
              3: const pw.FixedColumnWidth(40),
              4: const pw.FixedColumnWidth(50),
              5: const pw.FixedColumnWidth(50),
              6: const pw.IntrinsicColumnWidth(),
              7: const pw.FixedColumnWidth(40),
              8: const pw.FixedColumnWidth(60),
            },
          ),
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: const pw.BoxDecoration(color: PdfColors.blue50, border: pw.Border(top: pw.BorderSide(color: PdfColors.blue900, width: 2))),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Text("GRAND TOTAL", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                pw.SizedBox(width: 40),
                pw.Text("$totalQty", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                pw.SizedBox(width: 40),
                pw.Text("₹${totalAmt.toStringAsFixed(2)}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
              ],
            ),
          ),
        ],
        footer: (pw.Context context) => pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 10),
          child: pw.Text("Page ${context.pageNumber} of ${context.pagesCount}", style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey)),
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  Future<void> _deleteEntry(DamageEntryModel entry) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Delete this ${entry.type.toLowerCase()} entry (${entry.billSeries}-${entry.billNo})?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCEL')),
          TextButton(onPressed: () => Navigator.pop(context, true), style: TextButton.styleFrom(foregroundColor: Colors.red), child: const Text('DELETE')),
        ],
      ),
    );

    if (confirm == true && entry.id != null) {
      final res = await context.read<InventoryProvider>().deleteDamageEntry(entry.id!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['success'] == true ? 'Entry deleted' : (res['error'] ?? 'Delete failed'))));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InventoryProvider>();
    final filtered = _getFilteredEntries(provider.damageEntries);
    final totalQty = filtered.fold(0, (sum, e) => sum + e.totalQty);
    final totalAmt = filtered.fold(0.0, (sum, e) => sum + e.totalAmt);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // bg-slate-100
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Damage and Shrinkage", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                    const SizedBox(height: 4),
                    Text("Manage damage and shrinkage inventory records", style: TextStyle(fontSize: 14, color: Colors.blueGrey.shade400)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Filters Card
            _buildFiltersCard(provider, filtered),
            const SizedBox(height: 20),

            // Table Card
            _buildTableCard(provider, filtered, totalQty, totalAmt),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersCard(InventoryProvider provider, List<DamageEntryModel> filtered) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.blueGrey.shade100)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _buildInput("Bill Series", _billSeriesCtrl)),
                const SizedBox(width: 16),
                Expanded(child: _buildDatePicker("From Date", _fromDate, (d) => setState(() => _fromDate = d))),
                const SizedBox(width: 16),
                Expanded(child: _buildDatePicker("To Date", _toDate, (d) => setState(() => _toDate = d))),
                const SizedBox(width: 16),
                Expanded(child: _buildInput("Search", _searchCtrl, placeholder: "Search entries...")),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => provider.fetchAllDamageEntries(),
                      icon: const Icon(LucideIcons.search, size: 16),
                      label: const Text("Search"),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16)),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: _handleReset,
                      icon: const Icon(LucideIcons.rotateCcw, size: 16),
                      label: const Text("Reset"),
                      style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFF475569), side: BorderSide(color: Colors.grey.shade300), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16)),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await context.push('/lenstransaction/add-damage-entry');
                        if (mounted) context.read<InventoryProvider>().fetchAllDamageEntries();
                      },
                      icon: const Icon(LucideIcons.plus, size: 16),
                      label: const Text("Add Entry"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF16A34A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _exportToExcel(filtered),
                      icon: const Icon(LucideIcons.fileSpreadsheet, color: Color(0xFF059669)),
                      tooltip: "Export to Excel",
                      style: IconButton.styleFrom(backgroundColor: const Color(0xFFECFDF5), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      onPressed: () => _printAll(filtered),
                      icon: const Icon(LucideIcons.printer, color: Color(0xFF2563EB)),
                      tooltip: "Print All",
                      style: IconButton.styleFrom(backgroundColor: const Color(0xFFEFF6FF), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableCard(InventoryProvider provider, List<DamageEntryModel> filtered, int totalQty, double totalAmt) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.blueGrey.shade100)),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFEFF6FF), Color(0xFFF8FAFC)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: const Row(
              children: [
                SizedBox(width: 50, child: Text("Sr No.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF475569)))),
                SizedBox(width: 100, child: Text("Bill Date", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF475569)))),
                SizedBox(width: 80, child: Text("Series", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF475569)))),
                SizedBox(width: 80, child: Text("Bill No", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF475569)))),
                SizedBox(width: 100, child: Text("Type", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF475569)))),
                SizedBox(width: 100, child: Text("Godown", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF475569)))),
                Expanded(child: Text("Items", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF475569)))),
                SizedBox(width: 80, child: Text("Total Qty", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF475569)))),
                SizedBox(width: 120, child: Text("Total Amt", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF475569)))),
                SizedBox(width: 120, child: Text("Action", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF475569)), textAlign: TextAlign.center)),
              ],
            ),
          ),

          // Body
          if (provider.isLoading)
            const Padding(padding: EdgeInsets.all(48.0), child: Center(child: CircularProgressIndicator()))
          else if (filtered.isEmpty)
            const Padding(padding: EdgeInsets.all(48.0), child: Center(child: Text("No records found", style: TextStyle(fontSize: 16, color: Colors.blueGrey))))
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              separatorBuilder: (c, i) => const Divider(height: 1),
              itemBuilder: (c, i) {
                final v = filtered[i];
                final itemNames = v.items.map((it) => it.itemName).join(", ");
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  color: i.isEven ? Colors.transparent : Colors.blueGrey.shade50.withValues(alpha: 0.3),
                  child: Row(
                    children: [
                      SizedBox(width: 50, child: Text("${i + 1}", style: const TextStyle(color: Colors.blueGrey))),
                      SizedBox(width: 100, child: Text(v.date != null ? DateFormat('dd/MM/yyyy').format(DateTime.parse(v.date!)) : "-")),
                      SizedBox(width: 80, child: Text(v.billSeries)),
                      SizedBox(width: 80, child: Text(v.billNo, style: const TextStyle(fontWeight: FontWeight.bold))),
                      SizedBox(width: 100, child: _buildBadge(v.type)),
                      SizedBox(width: 100, child: Text(v.godown)),
                      Expanded(child: Text(itemNames, overflow: TextOverflow.ellipsis, maxLines: 1, style: const TextStyle(fontSize: 12))),
                      SizedBox(width: 80, child: Text("${v.totalQty}", style: const TextStyle(fontWeight: FontWeight.w600))),
                      SizedBox(width: 120, child: Text("₹${v.totalAmt.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.w600))),
                      SizedBox(
                        width: 120,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () async {
                                await context.push('/lenstransaction/add-damage-entry?id=${v.id}');
                                if (mounted) context.read<InventoryProvider>().fetchAllDamageEntries();
                              },
                              icon: const Icon(LucideIcons.pencil, size: 16, color: Color(0xFF2563EB)),
                            ),
                            IconButton(onPressed: () => _deleteEntry(v), icon: const Icon(LucideIcons.trash2, size: 16, color: Color(0xFFEF4444))),
                            IconButton(onPressed: () => _printSingle(v), icon: const Icon(LucideIcons.printer, size: 16, color: Color(0xFF16A34A))),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

          // Total Footer
          if (!provider.isLoading && filtered.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(color: const Color(0xFFEFF6FF), border: Border(top: BorderSide(color: Colors.blue.shade200, width: 2))),
              child: Row(
                children: [
                  const Expanded(flex: 7, child: Text("Totals", textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E40AF)))),
                  const SizedBox(width: 32),
                  SizedBox(width: 80, child: Text("$totalQty", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E40AF)))),
                  SizedBox(width: 120, child: Text("₹${totalAmt.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E40AF)))),
                  const SizedBox(width: 120),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBadge(String type) {
    final isDamage = type.toLowerCase() == 'damage';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDamage ? const Color(0xFFFEE2E2) : const Color(0xFFFEF9C3),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Center(
        child: Text(type, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isDamage ? const Color(0xFFB91C1C) : const Color(0xFF854D0E))),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController ctrl, {String? placeholder}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          decoration: InputDecoration(
            hintText: placeholder,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
          ),
          style: const TextStyle(fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildDatePicker(String label, DateTime? date, Function(DateTime) onSelect) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final d = await showDatePicker(context: context, initialDate: date ?? DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
            if (d != null) onSelect(d);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                Icon(LucideIcons.calendar, size: 16, color: Colors.blueGrey.shade400),
                const SizedBox(width: 8),
                Text(date != null ? DateFormat('dd/MM/yyyy').format(date) : "dd/mm/yyyy", style: TextStyle(fontSize: 13, color: date == null ? Colors.grey : Colors.black)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _printSingle(DamageEntryModel entry) async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(
      build: (pw.Context context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text("Damage & Shrinkage Entry", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 20),
          pw.Row(children: [
            pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Text("Bill Series: ${entry.billSeries}"),
              pw.Text("Bill No: ${entry.billNo}"),
              pw.Text("Date: ${entry.date != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(entry.date!)) : '-'}"),
            ]),
            pw.SizedBox(width: 50),
            pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Text("Type: ${entry.type}"),
              pw.Text("Godown: ${entry.godown}"),
              if (entry.remark.isNotEmpty) pw.Text("Remark: ${entry.remark}"),
            ]),
          ]),
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            headers: ["#", "Item Name", "Eye", "SPH", "CYL", "Axis", "Add", "Qty", "Price", "Total"],
            data: entry.items.asMap().entries.map((e) {
              final it = e.value;
              return [(e.key + 1).toString(), it.itemName, it.eye, it.sph.toString(), it.cyl.toString(), it.axis.toString(), it.add.toString(), it.qty.toString(), it.price.toStringAsFixed(2), it.totalAmt.toStringAsFixed(2)];
            }).toList(),
          ),
          pw.SizedBox(height: 10),
          pw.Align(alignment: pw.Alignment.centerRight, child: pw.Text("Grand Total: ₹${entry.totalAmt.toStringAsFixed(2)}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
        ]
      )
    ));
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }
}
