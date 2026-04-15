import 'dart:io';
import 'package:excel/excel.dart' as xl;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import '../providers/product_exchange_provider.dart';

class ProductExchangeListPage extends StatefulWidget {
  const ProductExchangeListPage({super.key});

  @override
  State<ProductExchangeListPage> createState() => _ProductExchangeListPageState();
}

class _ProductExchangeListPageState extends State<ProductExchangeListPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  final TextEditingController _billSeriesCtrl = TextEditingController();
  DateTime? _dateFrom;
  DateTime? _dateTo;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductExchangeProvider>().fetchExchanges();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _billSeriesCtrl.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _filterExchanges(List<Map<String, dynamic>> exchanges) {
    String q = _searchCtrl.text.toLowerCase();
    String series = _billSeriesCtrl.text.toLowerCase();

    return exchanges.where((e) {
      final billData = e['billData'] ?? {};
      final partyData = e['partyData'] ?? {};
      
      final billNo = billData['billNo']?.toString() ?? '';
      final billSeries = billData['billSeries']?.toString() ?? '';
      final partyName = partyData['partyAccount']?.toString() ?? '';
      final status = e['status']?.toString() ?? '';
      final type = billData['type']?.toString() ?? '';
      final dateStr = billData['date'];
      DateTime? date = dateStr != null ? DateTime.parse(dateStr) : null;

      if (q.isNotEmpty && 
          !('$billNo $billSeries $partyName $status $type').toLowerCase().contains(q)) {
        return false;
      }
      if (series.isNotEmpty && !billSeries.toLowerCase().contains(series)) {
        return false;
      }
      if (_dateFrom != null && date != null && date.isBefore(_dateFrom!)) {
        return false;
      }
      if (_dateTo != null && date != null && date.isAfter(_dateTo!.add(const Duration(days: 1)))) {
        return false;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductExchangeProvider>();
    final filteredExchanges = _filterExchanges(provider.exchanges);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(filteredExchanges),
            const SizedBox(height: 16),
            _buildFilterCard(filteredExchanges),
            const SizedBox(height: 16),
            Expanded(
              child: _buildTableCard(filteredExchanges, provider.isLoading),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(List<Map<String, dynamic>> filteredExchanges) {
    int totalRecords = filteredExchanges.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Product Exchange",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          "Total Records: $totalRecords",
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterCard(List<Map<String, dynamic>> filteredExchanges) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildFilterInput(
                  label: "Bill Series",
                  hint: "Bill Series",
                  controller: _billSeriesCtrl,
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDatePicker(
                  label: "From Date",
                  selectedDate: _dateFrom,
                  onSelected: (d) => setState(() => _dateFrom = d),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDatePicker(
                  label: "To Date",
                  selectedDate: _dateTo,
                  onSelected: (d) => setState(() => _dateTo = d),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFilterInput(
                  label: "Search",
                  hint: "Search...",
                  controller: _searchCtrl,
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => context.read<ProductExchangeProvider>().fetchExchanges(),
                    icon: const Icon(LucideIcons.search, size: 14),
                    label: const Text("Search"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () => setState(() {
                      _billSeriesCtrl.clear();
                      _searchCtrl.clear();
                      _dateFrom = null;
                      _dateTo = null;
                    }),
                    icon: const Icon(LucideIcons.rotateCcw, size: 14),
                    label: const Text("Reset"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF475569),
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () => context.go('/lenstransaction/add-product-exchange'),
                    icon: const Icon(LucideIcons.plus, size: 14),
                    label: const Text("Add Exchange"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF16A34A),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => _exportToExcel(filteredExchanges),
                    icon: const Icon(LucideIcons.fileSpreadsheet, color: Color(0xFF059669)),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFFECFDF5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    tooltip: "Export to Excel",
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => _printAllReport(filteredExchanges),
                    icon: const Icon(LucideIcons.printer, color: Color(0xFF2563EB)),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFFEFF6FF),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    tooltip: "Print All",
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _exportToExcel(List<Map<String, dynamic>> exchanges) async {
    try {
      var excel = xl.Excel.createExcel();
      xl.Sheet sheetObject = excel['Product Exchange'];
      excel.delete('Sheet1');

      // Headers
      List<String> headers = [
        "Sr No.", "Bill Series", "Bill No.", "Bill Date", "Party Name", 
        "Type", "In Qty", "In Amnt", "Out Qty", "Out Amnt", "Status"
      ];
      sheetObject.appendRow(headers.map((h) => xl.TextCellValue(h)).toList());

      // Data
      for (int i = 0; i < exchanges.length; i++) {
        final e = exchanges[i];
        final billData = e['billData'] ?? {};
        final partyData = e['partyData'] ?? {};
        final totals = e['totals'] ?? {};
        
        DateTime? date = billData['date'] != null ? DateTime.parse(billData['date']) : null;
        String dateStr = date != null ? DateFormat('dd/MM/yyyy').format(date) : '-';

        sheetObject.appendRow([
          xl.IntCellValue(i + 1),
          xl.TextCellValue(billData['billSeries']?.toString() ?? ''),
          xl.TextCellValue(billData['billNo']?.toString() ?? ''),
          xl.TextCellValue(dateStr),
          xl.TextCellValue(partyData['partyAccount']?.toString() ?? '-'),
          xl.TextCellValue(billData['type']?.toString() ?? '-'),
          xl.DoubleCellValue((totals['totalExchInQty'] ?? 0).toDouble()),
          xl.DoubleCellValue((totals['totalExchInAmnt'] ?? 0).toDouble()),
          xl.DoubleCellValue((totals['totalExchOutQty'] ?? 0).toDouble()),
          xl.DoubleCellValue((totals['totalExchOutAmnt'] ?? 0).toDouble()),
          xl.TextCellValue(e['status']?.toString() ?? 'COMPLETED'),
        ]);
      }

      var fileBytes = excel.save();
      var directory = await getApplicationDocumentsDirectory();
      String fileName = "Product_Exchange_${DateTime.now().millisecondsSinceEpoch}.xlsx";
      String filePath = "${directory.path}/$fileName";
      
      File(filePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Exported to $fileName"),
            action: SnackBarAction(label: "Open Folder", onPressed: () {
              // On Windows, documents directory is easily accessible
            }),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Excel Export Failed: $e")));
      }
    }
  }

  Widget _buildFilterInput({
    required String label,
    required String hint,
    required TextEditingController controller,
    required Function(String) onChanged,
  }) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildDatePicker({
    required String label,
    DateTime? selectedDate,
    required Function(DateTime?) onSelected,
  }) {
    return TextFormField(
      readOnly: true,
      onTap: () async {
        DateTime? d = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        onSelected(d);
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
        hintText: "dd-mm-yyyy",
        hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
        suffixIcon: const Icon(LucideIcons.calendar, size: 16, color: Color(0xFF64748B)),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
        ),
      ),
      controller: TextEditingController(
        text: selectedDate != null ? DateFormat('dd-MM-yyyy').format(selectedDate) : "",
      ),
      style: const TextStyle(fontSize: 13),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required Color color,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
            color: Colors.grey.shade50,
          ),
          child: Icon(icon, size: 18, color: color),
        ),
      ),
    );
  }

  Widget _buildTableCard(List<Map<String, dynamic>> exchanges, bool isLoading) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (exchanges.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.searchX, size: 64, color: Colors.grey.shade200),
            const SizedBox(height: 16),
            Text(
              "No exchange records found",
              style: TextStyle(fontSize: 16, color: Colors.grey.shade400),
            ),
          ],
        ),
      );
    }

    // Totals
    double totalInQty = 0;
    double totalInAmnt = 0;
    double totalOutQty = 0;
    double totalOutAmnt = 0;

    for (var e in exchanges) {
      final t = e['totals'] ?? {};
      totalInQty += (t['totalExchInQty'] ?? 0).toDouble();
      totalInAmnt += (t['totalExchInAmnt'] ?? 0).toDouble();
      totalOutQty += (t['totalExchOutQty'] ?? 0).toDouble();
      totalOutAmnt += (t['totalExchOutAmnt'] ?? 0).toDouble();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(Colors.grey.shade50),
                    dataRowMinHeight: 48,
                    dataRowMaxHeight: 48,
                    headingTextStyle: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                      letterSpacing: 0.5,
                    ),
                    columns: const [
                       DataColumn(label: SizedBox(width: 30, child: Text("SR"))),
                       DataColumn(label: Text("SERIES")),
                       DataColumn(label: Text("NO.")),
                       DataColumn(label: Text("DATE")),
                       DataColumn(label: SizedBox(width: 180, child: Text("PARTY NAME"))),
                       DataColumn(label: Text("IN QTY")),
                       DataColumn(label: Text("IN AMNT")),
                       DataColumn(label: Text("OUT QTY")),
                       DataColumn(label: Text("OUT AMNT")),
                       DataColumn(label: Text("STATUS")),
                       DataColumn(label: Text("ACTION")),
                    ],
                    rows: List.generate(exchanges.length, (index) {
                       final e = exchanges[index];
                       final billData = e['billData'] ?? {};
                       final partyData = e['partyData'] ?? {};
                       final totals = e['totals'] ?? {};
                       final status = e['status'] ?? 'COMPLETED';

                       return DataRow(
                         cells: [
                           DataCell(Text("${index + 1}")),
                           DataCell(Text("${billData['billSeries'] ?? ''}")),
                           DataCell(Text("${billData['billNo'] ?? ''}")),
                           DataCell(Text(billData['date'] != null 
                              ? DateFormat('dd/MM/yyyy').format(DateTime.parse(billData['date'])) 
                              : '-')),
                           DataCell(Text(partyData['partyAccount'] ?? '-')),
                           DataCell(Text("${totals['totalExchInQty'] ?? 0}")),
                           DataCell(Text("₹${NumberFormat('#,##0.00').format(totals['totalExchInAmnt'] ?? 0)}")),
                           DataCell(Text("${totals['totalExchOutQty'] ?? 0}")),
                           DataCell(Text("₹${NumberFormat('#,##0.00').format(totals['totalExchOutAmnt'] ?? 0)}")),
                           DataCell(_buildStatusBadge(status)),
                           DataCell(_buildActionButtons(e['_id'])),
                         ],
                       );
                    }),
                  ),
                ),
              ),
            ),
            _buildTotalsRow(totalInQty, totalInAmnt, totalOutQty, totalOutAmnt),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg = Colors.green.shade50;
    Color text = Colors.green.shade700;

    if (status.toUpperCase() == 'COMPLETED') {
      bg = Colors.green.shade50;
      text = Colors.green.shade700;
    } else if (status.contains('In')) {
      bg = Colors.blue.shade50;
      text = Colors.blue.shade700;
    } else if (status.contains('Out')) {
      bg = Colors.red.shade50;
      text = Colors.red.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: text,
        ),
      ),
    );
  }

  Widget _buildActionButtons(String? id) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () => context.go('/lenstransaction/add-product-exchange?id=$id'),
          icon: const Icon(LucideIcons.pencil, size: 14, color: Color(0xFF3B82F6)),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          tooltip: "Edit",
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () => _handleDelete(id),
          icon: const Icon(LucideIcons.trash, size: 14, color: Color(0xFFEF4444)),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          tooltip: "Delete",
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () => _printSingleVoucher(id),
          icon: const Icon(LucideIcons.printer, size: 14, color: Color(0xFF10B981)),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          tooltip: "Print",
        ),
      ],
    );
  }

  Future<void> _handleDelete(String? id) async {
    if (id == null) return;
    
    bool confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this exchange record?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true), 
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      )
    ) ?? false;

    if (confirm) {
       final res = await context.read<ProductExchangeProvider>().deleteExchange(id);
       if (!mounted) return;
       if (res['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Record deleted successfully")));
       } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['error'] ?? "Delete failed")));
       }
    }
  }

  Widget _buildTotalsRow(double inQty, double inAmnt, double outQty, double outAmnt) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text(
            "TOTALS:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1E293B)),
          ),
          const SizedBox(width: 48),
          _buildTotalItem("IN QTY", inQty.toStringAsFixed(2)),
          const SizedBox(width: 32),
          _buildTotalItem("IN AMNT", "₹${NumberFormat('#,##0.00').format(inAmnt)}"),
          const SizedBox(width: 32),
          _buildTotalItem("OUT QTY", outQty.toStringAsFixed(2)),
          const SizedBox(width: 32),
          _buildTotalItem("OUT AMNT", "₹${NumberFormat('#,##0.00').format(outAmnt)}"),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildTotalItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 9, color: Colors.grey.shade500, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
        ),
      ],
    );
  }

  Future<void> _printAllReport(List<Map<String, dynamic>> exchanges) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Product Exchange Report", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                  pw.Text(DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    "Sr", "Series", "No", "Date", "Party Name", "Type", "In Qty", "In Amnt", "Out Qty", "Out Amnt", "Status"
                  ].map((h) => pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(h, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                  )).toList(),
                ),
                ...exchanges.asMap().entries.map((entry) {
                   final i = entry.key;
                   final e = entry.value;
                   final billData = e['billData'] ?? {};
                   final partyData = e['partyData'] ?? {};
                   final totals = e['totals'] ?? {};
                   
                   DateTime? date = billData['date'] != null ? DateTime.parse(billData['date']) : null;
                   String dateStr = date != null ? DateFormat('dd/MM/yyyy').format(date) : '-';

                   return pw.TableRow(
                     children: [
                        "${i + 1}",
                        "${billData['billSeries'] ?? ''}",
                        "${billData['billNo'] ?? ''}",
                        dateStr,
                        "${partyData['partyAccount'] ?? '-'}",
                        "${billData['type'] ?? '-'}",
                        "${totals['totalExchInQty'] ?? 0}",
                        "Rs. ${(totals['totalExchInAmnt'] ?? 0).toStringAsFixed(2)}",
                        "${totals['totalExchOutQty'] ?? 0}",
                        "Rs. ${(totals['totalExchOutAmnt'] ?? 0).toStringAsFixed(2)}",
                        "${e['status'] ?? 'COMPLETED'}",
                     ].map((v) => pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(v, style: const pw.TextStyle(fontSize: 9)),
                     )).toList(),
                   );
                }),
              ],
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  Future<void> _printSingleVoucher(String? id) async {
    if (id == null) return;
    
    final provider = context.read<ProductExchangeProvider>();
    final e = provider.exchanges.firstWhere((item) => item['_id'] == id, orElse: () => {});
    if (e.isEmpty) return;

    final billData = e['billData'] ?? {};
    final partyData = e['partyData'] ?? {};
    final outItems = List<Map<String, dynamic>>.from(e['exchangeOutItems'] ?? []);
    final inItems = List<Map<String, dynamic>>.from(e['exchangeInItems'] ?? []);
    final totals = e['totals'] ?? {};
    
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Center(child: pw.Text("PRODUCT EXCHANGE VOUCHER", style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold))),
            pw.Divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("Party: ${partyData['partyAccount'] ?? '-'}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text("Address: ${partyData['address'] ?? '-'}"),
                    pw.Text("Contact: ${partyData['contactNumber'] ?? '-'}"),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text("Bill No: ${billData['billSeries']}/${billData['billNo']}"),
                    pw.Text("Date: ${billData['date'] != null ? DateFormat('dd/MM/yyyy').format(DateTime.parse(billData['date'])) : '-'}"),
                    pw.Text("Type: ${billData['type']}"),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            
            pw.Text("EXCHANGE OUT ITEMS", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
            _buildItemTable(outItems),
            pw.SizedBox(height: 20),

            pw.Text("EXCHANGE IN ITEMS", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
            _buildItemTable(inItems),
            
            pw.SizedBox(height: 20),
            pw.Divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text("Total Out: Rs. ${(totals['totalExchOutAmnt'] ?? 0).toStringAsFixed(2)}"),
                    pw.Text("Total In: Rs. ${(totals['totalExchInAmnt'] ?? 0).toStringAsFixed(2)}"),
                    pw.Text("Net Difference: Rs. ${((totals['totalExchOutAmnt'] ?? 0) - (totals['totalExchInAmnt'] ?? 0)).toStringAsFixed(2)}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 40),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("Authorized Signatory"),
                pw.Text("Receiver's Signature"),
              ],
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  pw.Widget _buildItemTable(List<Map<String, dynamic>> items) {
    return pw.Table(
      border: pw.TableBorder.all(),
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            "Sr", "Item Name", "SPH", "CYL", "AXIS", "ADD", "Qty", "Price", "Total"
          ].map((h) => pw.Padding(
            padding: const pw.EdgeInsets.all(3),
            child: pw.Text(h, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
          )).toList(),
        ),
        ...items.asMap().entries.map((entry) {
           final i = entry.key;
           final it = entry.value;
           return pw.TableRow(
             children: [
                "${i + 1}",
                "${it['itemName'] ?? '-'}",
                "${it['sph'] ?? '0.0'}",
                "${it['cyl'] ?? '0.0'}",
                "${it['axis'] ?? '0.0'}",
                "${it['add'] ?? '0.0'}",
                "${it['qty'] ?? 0}",
                "${it['price'] ?? 0}",
                "${it['totalAmount'] ?? 0}",
             ].map((v) => pw.Padding(
                padding: const pw.EdgeInsets.all(3),
                child: pw.Text(v, style: const pw.TextStyle(fontSize: 8)),
             )).toList(),
           );
        }),
      ],
    );
  }
}
