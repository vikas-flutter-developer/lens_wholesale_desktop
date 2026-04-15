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
import '../../data/providers/outstanding_provider.dart';
import '../../../masters/data/providers/account_provider.dart';
import '../../../masters/data/models/account_model.dart';

class OutstandingPage extends StatefulWidget {
  const OutstandingPage({super.key});

  @override
  State<OutstandingPage> createState() => _OutstandingPageState();
}

class _OutstandingPageState extends State<OutstandingPage> {
  final ScrollController _horizontalScroll = ScrollController();
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<OutstandingProvider>();
      provider.fetchOptions();
      context.read<AccountProvider>().fetchAllAccounts();
    });
  }

  @override
  void dispose() {
    _horizontalScroll.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  String _formatCurrency(double amount) {
    return NumberFormat.currency(symbol: '₹', locale: 'en_IN', decimalDigits: 2)
        .format(amount);
  }

  Future<void> _shareWhatsApp(String? phone, String particular, double amount) async {
    if (phone == null || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No contact number available')),
      );
      return;
    }

    final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
    final message = "Outstanding Statement\n\n"
        "Party: $particular\n"
        "Total Outstanding: ${_formatCurrency(amount)}\n"
        "Please clear the dues at the earliest.";
    
    final url = "https://wa.me/$cleanPhone?text=${Uri.encodeComponent(message)}";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch WhatsApp')),
        );
      }
    }
  }

  Future<void> _printTotalReport(OutstandingProvider provider) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text("Outstanding Report (${provider.type.toUpperCase()}) - ${DateFormat('dd MMM yyyy').format(provider.fromDate)}"),
          ),
          pw.TableHelper.fromTextArray(
            headers: [
              'SNo', 'Particular', 'Contact', 'Address', 'Group', '1-30', '31-60', '61-90', '90+', 'Total'
            ],
            data: List.generate(provider.reportItems.length, (index) {
              final item = provider.reportItems[index];
              return [
                '${index + 1}',
                item.particular,
                item.contactNo ?? '',
                item.address ?? '',
                item.groupName ?? '',
                item.days1to30.toStringAsFixed(2),
                item.days31to60.toStringAsFixed(2),
                item.days61to90.toStringAsFixed(2),
                item.above90Days.toStringAsFixed(2),
                item.totalOutstanding.toStringAsFixed(2),
              ];
            }),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            cellAlignment: pw.Alignment.centerLeft,
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
          ),
          if (provider.summary != null) ...[
            pw.SizedBox(height: 10),
            pw.Divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Text("Total Accounts: ${provider.summary!.totalAccounts}   ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text("GRAND TOTAL: ₹${provider.summary!.grandTotal.toStringAsFixed(2)}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.green)),
              ],
            ),
          ]
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  Future<void> _exportToCSV(OutstandingProvider provider) async {
    if (provider.reportItems.isEmpty) return;

    List<List<dynamic>> rows = [];
    rows.add([
      "S.No",
      "Particular",
      "Contact No",
      "Address",
      "Group Name",
      "State",
      "1-30 Days",
      "31-60 Days",
      "61-90 Days",
      "90+ Days",
      "Total Outstanding"
    ]);

    for (var i = 0; i < provider.reportItems.length; i++) {
      final item = provider.reportItems[i];
      rows.add([
        i + 1,
        item.particular,
        item.contactNo ?? '',
        item.address ?? '',
        item.groupName ?? '',
        item.state ?? '',
        item.days1to30,
        item.days31to60,
        item.days61to90,
        item.above90Days,
        item.totalOutstanding,
      ]);
    }

    String csvData = const ListToCsvConverter().convert(rows);
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = "${directory.path}/Outstanding_Report_${DateTime.now().millisecondsSinceEpoch}.csv";
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<OutstandingProvider>(
          builder: (context, provider, child) {
            return Column(
              children: [
                _buildHeader(),
                _buildFilterSection(provider),
                Expanded(
                  child: provider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _buildTableSection(provider),
                ),
                if (provider.selectedIndices.isNotEmpty) _buildBottomActionBar(provider),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: const Text(
        'Outstanding',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFilterSection(OutstandingProvider provider) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF), // bg-blue-50
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Date From
            _filterItem(
              'Date From',
              InkWell(
                onTap: () async {
                  final d = await showDatePicker(
                    context: context,
                    initialDate: provider.fromDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (d != null) provider.setFromDate(d);
                },
                child: Container(
                  width: 140,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Text(DateFormat('dd-MM-yyyy').format(provider.fromDate), style: const TextStyle(fontSize: 13)),
                      const Spacer(),
                      const Icon(LucideIcons.calendar, size: 14, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Type Toggle
            _filterItem(
              '', // No label to match React's horizontal look
              Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    _radioOption('Receivable', provider.type == 'receivable', () => provider.setType('receivable')),
                    const SizedBox(width: 12),
                    _radioOption('Payable', provider.type == 'payable', () => provider.setType('payable')),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Station Name
            _filterItem(
              'Station Name',
              SizedBox(
                width: 160,
                height: 38,
                child: DropdownButtonFormField<String>(
                  value: provider.stationName.isEmpty ? null : provider.stationName,
                  decoration: _compactFieldDecoration('All Stations'),
                  isExpanded: true,
                  items: [
                    const DropdownMenuItem(value: null, child: Text('All Stations', style: TextStyle(fontSize: 13))),
                    ...provider.stations.map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 13)))),
                  ],
                  onChanged: (v) => provider.setStationName(v ?? ''),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Group Name
            _filterItem(
              'Group Name',
              SizedBox(
                width: 160,
                height: 38,
                child: DropdownButtonFormField<String>(
                  value: provider.groupName.isEmpty ? null : provider.groupName,
                  decoration: _compactFieldDecoration('All Groups'),
                  isExpanded: true,
                  items: [
                    const DropdownMenuItem(value: null, child: Text('All Groups', style: TextStyle(fontSize: 13))),
                    ...provider.groups.map((g) => DropdownMenuItem(value: g, child: Text(g, style: const TextStyle(fontSize: 13)))),
                  ],
                  onChanged: (v) => provider.setGroupName(v ?? ''),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Search
            _filterItem(
              'Search',
              SizedBox(
                width: 200,
                height: 38,
                child: Consumer<AccountProvider>(
                  builder: (context, accProvider, _) => Autocomplete<AccountModel>(
                    displayStringForOption: (acc) => acc.name,
                    optionsBuilder: (textEditingValue) {
                      if (textEditingValue.text.isEmpty) return const Iterable.empty();
                      return accProvider.accounts.where((acc) {
                        final q = textEditingValue.text.toLowerCase();
                        return acc.name.toLowerCase().contains(q) ||
                               (acc.mobileNumber?.contains(q) ?? false) ||
                               (acc.address?.toLowerCase().contains(q) ?? false);
                      });
                    },
                    onSelected: (acc) {
                      provider.setSearchText(acc.name);
                    },
                    fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        style: const TextStyle(fontSize: 13),
                        decoration: _compactFieldDecoration('Name, Mobile, Address...'),
                        onChanged: (v) => provider.setSearchText(v),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Action Buttons
            ElevatedButton.icon(
              onPressed: provider.isLoading ? null : () => provider.fetchReport(),
              icon: const Icon(LucideIcons.search, size: 14),
              label: Text(provider.isLoading ? 'Searching...' : 'Search', style: const TextStyle(fontSize: 13)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444), // bg-red-500
                foregroundColor: Colors.white,
                fixedSize: const Size(110, 38),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                elevation: 1,
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: () => provider.resetFilters(),
              icon: const Icon(LucideIcons.rotateCcw, size: 14),
              label: const Text('Reset', style: TextStyle(fontSize: 13)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0EA5E9), // bg-sky-500
                foregroundColor: Colors.white,
                fixedSize: const Size(100, 38),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                elevation: 1,
              ),
            ),
            const SizedBox(width: 20),

            // Export Buttons
            _iconActionBtn(LucideIcons.fileText, const Color(0xFFEAB308), () => _exportToCSV(provider), 'Export CSV'),
            const SizedBox(width: 8),
            _iconActionBtn(LucideIcons.printer, const Color(0xFF2563EB), () => _printTotalReport(provider), 'Print'),
          ],
        ),
      ),
    );
  }

  Widget _radioOption(String label, bool active, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: active ? const Color(0xFF2563EB) : Colors.grey.shade400, width: 1.5),
            ),
            child: active ? Center(child: Container(width: 6, height: 6, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF2563EB)))) : null,
          ),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  Widget _iconActionBtn(IconData icon, Color color, VoidCallback onTap, String tooltip) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2, offset: const Offset(0, 1))],
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _buildTableSection(OutstandingProvider provider) {
    if (!provider.hasSearched) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.filter, size: 64, color: Colors.blue.shade100),
            const SizedBox(height: 16),
            const Text(
              'Apply filters and click Search to view aging report',
              style: TextStyle(color: Colors.blueGrey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    // Build Rows
    List<DataRow> allRows = List.generate(provider.reportItems.length, (index) {
      final item = provider.reportItems[index];
      return DataRow(
        selected: provider.isSelected(index),
        onSelectChanged: (v) => provider.toggleSelection(index),
        color: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.selected)) return Colors.blue.withOpacity(0.08);
          return index % 2 == 0 ? Colors.white : const Color(0xFFF9FAFB);
        }),
        cells: [
          DataCell(Center(child: Checkbox(value: provider.isSelected(index), onChanged: (v) => provider.toggleSelection(index)))),
          DataCell(Center(child: Text('${index + 1}', style: const TextStyle(fontSize: 13, color: Colors.grey)))),
          DataCell(
            Center(
              child: IconButton(
                icon: const Icon(LucideIcons.messageSquare, color: Colors.green, size: 18),
                onPressed: () => _shareWhatsApp(item.contactNo, item.particular, item.totalOutstanding),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
          ),
          DataCell(Text(item.particular, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
          DataCell(Text(item.contactNo ?? '-', style: const TextStyle(fontSize: 13))),
          DataCell(
            SizedBox(
              width: 180,
              child: Text(item.address ?? '-', overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13)),
            ),
          ),
          DataCell(Text(item.groupName ?? '-', style: const TextStyle(fontSize: 13))),
          DataCell(Text(item.state ?? '-', style: const TextStyle(fontSize: 13))),
          DataCell(Align(alignment: Alignment.centerRight, child: Text(_formatCurrency(item.days1to30), style: const TextStyle(fontSize: 13)))),
          DataCell(Align(alignment: Alignment.centerRight, child: Text(_formatCurrency(item.days31to60), style: const TextStyle(fontSize: 13)))),
          DataCell(Align(alignment: Alignment.centerRight, child: Text(_formatCurrency(item.days61to90), style: const TextStyle(fontSize: 13)))),
          DataCell(Align(alignment: Alignment.centerRight, child: Text(
            _formatCurrency(item.above90Days),
            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 13),
          ))),
          DataCell(
            Center(
              child: TextButton(
                onPressed: () {
                   context.go('/reports/ledger/accountledger?account=${Uri.encodeComponent(item.particular)}');
                },
                child: const Text('View', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      );
    });

    // Add Summary Rows
    if (provider.summary != null) {
      final s = provider.summary!;
      // Total Row (Blue)
      allRows.add(DataRow(
        color: WidgetStateProperty.all(const Color(0xFFDBEAFE)), // bg-blue-100
        cells: [
          const DataCell(SizedBox.shrink()),
          const DataCell(Center(child: Text('-', style: TextStyle(color: Colors.grey)))),
          const DataCell(SizedBox.shrink()),
          DataCell(Text('Total (${s.totalAccounts} Accounts)', style: const TextStyle(fontWeight: FontWeight.bold))),
          ...List.generate(4, (_) => const DataCell(SizedBox.shrink())),
          DataCell(Align(alignment: Alignment.centerRight, child: Text(_formatCurrency(s.total1to30), style: const TextStyle(fontWeight: FontWeight.bold)))),
          DataCell(Align(alignment: Alignment.centerRight, child: Text(_formatCurrency(s.total31to60), style: const TextStyle(fontWeight: FontWeight.bold)))),
          DataCell(Align(alignment: Alignment.centerRight, child: Text(_formatCurrency(s.total61to90), style: const TextStyle(fontWeight: FontWeight.bold)))),
          DataCell(Align(alignment: Alignment.centerRight, child: Text(_formatCurrency(s.totalAbove90), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)))),
          // The last cell corresponds to 'View'
          const DataCell(SizedBox.shrink()),
        ],
      ));

      // Grand Total Row (Green)
      allRows.add(DataRow(
        color: WidgetStateProperty.all(const Color(0xFFDCFCE7)), // bg-green-100
        cells: [
          const DataCell(SizedBox.shrink()),
          const DataCell(SizedBox.shrink()),
          const DataCell(SizedBox.shrink()),
          const DataCell(Text('Grand Total Outstanding', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
          ...List.generate(7, (_) => const DataCell(SizedBox.shrink())),
          DataCell(Align(alignment: Alignment.centerRight, child: Text(
            _formatCurrency(s.grandTotal),
            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF15803D), fontSize: 16),
          ))),
          const DataCell(SizedBox.shrink()),
        ],
      ));
    }

    Widget table = DataTable(
      headingRowColor: WidgetStateProperty.all(const Color(0xFFF3F4F6)), // bg-gray-100
      dataRowMinHeight: 40,
      dataRowMaxHeight: 40,
      columnSpacing: 20,
      dividerThickness: 0.5,
      border: TableBorder.all(color: Colors.grey.shade300, width: 0.5),
      columns: [
        DataColumn(label: Center(child: Checkbox(value: provider.isAllSelected, onChanged: (v) => provider.toggleSelectAll(v ?? false)))),
        const DataColumn(label: Center(child: Text('SNo', style: TextStyle(fontWeight: FontWeight.bold)))),
        const DataColumn(label: Center(child: Text('Action', style: TextStyle(fontWeight: FontWeight.bold)))),
        const DataColumn(label: Text('Particular', style: TextStyle(fontWeight: FontWeight.bold))),
        const DataColumn(label: Text('Contact No', style: TextStyle(fontWeight: FontWeight.bold))),
        const DataColumn(label: Text('Address', style: TextStyle(fontWeight: FontWeight.bold))),
        const DataColumn(label: Text('Group Name', style: TextStyle(fontWeight: FontWeight.bold))),
        const DataColumn(label: Text('State', style: TextStyle(fontWeight: FontWeight.bold))),
        const DataColumn(label: Align(alignment: Alignment.centerRight, child: Text('1-30 Days', style: TextStyle(fontWeight: FontWeight.bold)))),
        const DataColumn(label: Align(alignment: Alignment.centerRight, child: Text('31-60 Days', style: TextStyle(fontWeight: FontWeight.bold)))),
        const DataColumn(label: Align(alignment: Alignment.centerRight, child: Text('61-90 Days', style: TextStyle(fontWeight: FontWeight.bold)))),
        const DataColumn(label: Align(alignment: Alignment.centerRight, child: Text('Above 90 Days', style: TextStyle(fontWeight: FontWeight.bold)))),
        const DataColumn(label: Center(child: Text('View', style: TextStyle(fontWeight: FontWeight.bold)))),
      ],
      rows: allRows,
    );

    return Scrollbar(
      controller: _horizontalScroll,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _horizontalScroll,
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              table,
              if (provider.reportItems.isEmpty)
                Container(
                  width: 1200, // Approximate width to show message centered relative to table
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  child: const Center(
                    child: Text(
                      'No outstanding records found.',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActionBar(OutstandingProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Sending SMS to ${provider.selectedIndices.length} accounts...')),
              );
            },
            icon: const Icon(LucideIcons.messageSquare, size: 16),
            label: Text('Send SMS (${provider.selectedIndices.length})'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
          ),
          const Spacer(),
          Text(
            '${provider.selectedIndices.length} of ${provider.reportItems.length} selected',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
        ],
      ),
    );
  }

  InputDecoration _compactFieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade500),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Colors.grey.shade300)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1)),
    );
  }

  Widget _filterItem(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF374151)), // text-gray-700
          ),
          const SizedBox(height: 4),
        ],
        child,
      ],
    );
  }
}
