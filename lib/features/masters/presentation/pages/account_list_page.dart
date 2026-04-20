import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart' as excel_pkg;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../data/providers/account_provider.dart';
import '../../data/providers/account_group_provider.dart';
import '../../data/models/account_model.dart';
import 'add_account_page.dart';

class AccountListPage extends StatefulWidget {
  const AccountListPage({super.key});

  @override
  State<AccountListPage> createState() => _AccountListPageState();
}

class _AccountListPageState extends State<AccountListPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchTerm = "";
  String _selectedGroup = "";
  String _selectedType = ""; // 'Sale', 'Purchase', 'Both'
  DateTime? _fromDate;
  DateTime? _toDate;

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
    super.dispose();
  }

  void _handleReset() {
    setState(() {
      _searchCtrl.clear();
      _searchTerm = "";
      _selectedGroup = "";
      _selectedType = "";
      _fromDate = null;
      _toDate = null;
    });
  }

  void _handleDelete(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this account?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final success = await context.read<AccountProvider>().deleteAccount(id);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Account deleted successfully!")));
      }
    }
  }

  Future<void> _exportToExcel(List<AccountModel> accounts) async {
    var excel = excel_pkg.Excel.createExcel();
    var sheet = excel['Accounts'];
    
    sheet.appendRow([
      excel_pkg.TextCellValue("Sr. No."),
      excel_pkg.TextCellValue("Date"),
      excel_pkg.TextCellValue("Account Name"),
      excel_pkg.TextCellValue("Mobile No."),
      excel_pkg.TextCellValue("GST No."),
      excel_pkg.TextCellValue("Parent Group"),
      excel_pkg.TextCellValue("Address"),
      excel_pkg.TextCellValue("Station"),
      excel_pkg.TextCellValue("State"),
      excel_pkg.TextCellValue("Opn. Bal (Dr)"),
      excel_pkg.TextCellValue("Opn. Bal (Cr)"),
    ]);

    for (var i = 0; i < accounts.length; i++) {
      final acc = accounts[i];
      sheet.appendRow([
        excel_pkg.IntCellValue(i + 1),
        excel_pkg.TextCellValue(acc.createdAt != null ? DateFormat('dd/MM/yyyy').format(acc.createdAt!) : "-"),
        excel_pkg.TextCellValue(acc.name),
        excel_pkg.TextCellValue(acc.mobileNumber ?? "-"),
        excel_pkg.TextCellValue(acc.gstin ?? "-"),
        excel_pkg.TextCellValue(acc.groups.join(", ")),
        excel_pkg.TextCellValue(acc.address ?? "-"),
        excel_pkg.TextCellValue(acc.stations.join(", ")),
        excel_pkg.TextCellValue(acc.state ?? "-"),
        excel_pkg.DoubleCellValue(acc.openingBalance?.type == "Dr" ? acc.openingBalance!.balance : 0.0),
        excel_pkg.DoubleCellValue(acc.openingBalance?.type == "Cr" ? acc.openingBalance!.balance : 0.0),
      ]);
    }

    final bytes = excel.save();
    if (bytes != null) {
      final directory = await getDownloadsDirectory();
      final file = File('${directory!.path}/AccountMaster_${DateTime.now().millisecondsSinceEpoch}.xlsx');
      await file.writeAsBytes(bytes);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Excel saved to: ${file.path}")));
      }
    }
  }

  Future<void> _printReport(List<AccountModel> accounts) async {
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
                pw.Text("Account Master", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.Text("Generated on: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}"),
              ],
            ),
          ),
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            headers: ["Sr.", "Date", "Account Name", "Mobile No.", "GST No.", "Parent Group", "Address", "Station", "State", "Dr Bal", "Cr Bal"],
            data: accounts.asMap().entries.map((entry) {
              final i = entry.key;
              final acc = entry.value;
              return [
                "${i + 1}",
                acc.createdAt != null ? DateFormat('dd/MM/yyyy').format(acc.createdAt!) : "-",
                acc.name,
                acc.mobileNumber ?? "-",
                acc.gstin ?? "-",
                acc.groups.join(", "),
                acc.address ?? "-",
                acc.stations.join(", "),
                acc.state ?? "-",
                acc.openingBalance?.type == "Dr" ? acc.openingBalance!.balance.toStringAsFixed(2) : "0.00",
                acc.openingBalance?.type == "Cr" ? acc.openingBalance!.balance.toStringAsFixed(2) : "0.00",
              ];
            }).toList(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
            cellStyle: const pw.TextStyle(fontSize: 9),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
            cellAlignment: pw.Alignment.centerLeft,
          ),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AccountProvider>();
    final groupProvider = context.watch<AccountGroupProvider>();

    final filteredAccounts = provider.accounts.where((account) {
      final matchesSearch = _searchTerm.isEmpty ||
          account.name.toLowerCase().contains(_searchTerm) ||
          (account.mobileNumber?.contains(_searchTerm) ?? false) ||
          (account.gstin?.toLowerCase().contains(_searchTerm) ?? false);

      final matchesGroup = _selectedGroup.isEmpty ||
          account.groups.any((g) => g.toLowerCase().contains(_selectedGroup.toLowerCase()));

      final matchesType = _selectedType.isEmpty ||
          account.accountType == "Both" ||
          account.accountType == _selectedType;

      bool matchesDate = true;
      if (_fromDate != null || _toDate != null) {
        if (account.createdAt == null) {
          matchesDate = false;
        } else {
          final created = account.createdAt!;
          if (_fromDate != null && created.isBefore(_fromDate!)) matchesDate = false;
          if (_toDate != null && created.isAfter(_toDate!.add(const Duration(days: 1)))) matchesDate = false;
        }
      }

      return matchesSearch && matchesGroup && matchesType && matchesDate;
    }).toList();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF8FAFC), Color(0xFFEFF6FF)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(),
              const SizedBox(height: 24),

              // Filters
              _buildFilterSection(groupProvider, provider),
              const SizedBox(height: 24),

              // Table
              _buildTableSection(provider, filteredAccounts),
              
              // Footer info
              const SizedBox(height: 24),
              Center(
                child: Text(
                  "Showing ${filteredAccounts.length} of ${provider.accounts.length} account records",
                  style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Account Master",
          style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: Color(0xFF1E293B), letterSpacing: -1),
        ),
        SizedBox(height: 4),
        Text(
          "Manage customer and vendor account information",
          style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
        ),
      ],
    );
  }

  Widget _buildFilterSection(AccountGroupProvider groupProvider, AccountProvider accountProvider) {
    final uniqueNames = accountProvider.accounts.map((a) => a.name).toSet().toList()..sort();
    
    // Extract unique groups from accounts to match React logic
    final uniqueGroups = accountProvider.accounts
        .expand((a) => a.groups)
        .toSet()
        .toList()
      ..sort();

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 30, offset: const Offset(0, 10))],
      ),
      child: Column(
        children: [
          // Row 1: Filters
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Group Selector
              Expanded(
                flex: 2,
                child: _buildFilterDropdown(
                  label: "Group Name",
                  value: _selectedGroup.isEmpty ? null : _selectedGroup,
                  hint: "All Groups",
                  items: uniqueGroups,
                  onChanged: (val) => setState(() => _selectedGroup = val ?? ""),
                ),
              ),
              const SizedBox(width: 16),
              // Search Box with Autocomplete
              Expanded(
                flex: 3,
                child: _buildAutocompleteSearch(uniqueNames),
              ),
              const SizedBox(width: 16),
              // From Date
              SizedBox(
                width: 160,
                child: _buildDatePickerField(
                  label: "Register From",
                  date: _fromDate,
                  onTap: () async {
                    final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
                    if (date != null) setState(() => _fromDate = date);
                  },
                ),
              ),
              const SizedBox(width: 16),
              // To Date
              SizedBox(
                width: 160,
                child: _buildDatePickerField(
                  label: "Register To",
                  date: _toDate,
                  onTap: () async {
                    final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
                    if (date != null) setState(() => _toDate = date);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Row 2: Account Type + Buttons
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Type Selector
              SizedBox(
                width: 160,
                child: _buildFilterDropdown(
                  label: "Account Type",
                  value: _selectedType.isEmpty ? null : _selectedType,
                  hint: "All Types",
                  items: const ["Sale", "Purchase", "Both"],
                  onChanged: (val) => setState(() => _selectedType = val ?? ""),
                ),
              ),
              const SizedBox(width: 24),
              // Action Buttons
              _buildActionButton(
                label: "Search",
                icon: LucideIcons.search,
                color: const Color(0xFF2563EB),
                onPressed: () {},
              ),
              const SizedBox(width: 12),
              _buildActionButton(
                label: "Reset",
                icon: LucideIcons.rotateCcw,
                color: const Color(0xFFF1F5F9),
                textColor: const Color(0xFF475569),
                onPressed: _handleReset,
              ),
              const SizedBox(width: 12),
              _buildActionButton(
                label: "Add",
                icon: LucideIcons.plus,
                color: const Color(0xFF16A34A),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddAccountPage())),
              ),
              const Spacer(),
              // Excel & Print
              _buildIconAction(
                icon: LucideIcons.fileSpreadsheet,
                color: const Color(0xFF10B981),
                bgColor: const Color(0xFFECFDF5),
                onPressed: () => _exportToExcel(accountProvider.accounts),
              ),
              const SizedBox(width: 12),
              _buildIconAction(
                icon: LucideIcons.printer,
                color: const Color(0xFF3B82F6),
                bgColor: const Color(0xFFEFF6FF),
                onPressed: () => _printReport(accountProvider.accounts),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAutocompleteSearch(List<String> options) {
    return Autocomplete<String>(
      initialValue: TextEditingValue(text: _searchTerm),
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return options.where((String option) {
          return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        setState(() => _searchTerm = selection.toLowerCase());
      },
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          onChanged: (val) => setState(() => _searchTerm = val.toLowerCase()),
          decoration: _inputDecoration(label: "Search Name, Number", hint: "Start typing..."),
          style: const TextStyle(fontSize: 14),
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 400, // Fixed width for the autocomplete list
              constraints: const BoxConstraints(maxHeight: 300),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
                itemBuilder: (context, index) {
                  final String option = options.elementAt(index);
                  return ListTile(
                    title: Text(option, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                    onTap: () => onSelected(option),
                    hoverColor: const Color(0xFFF8FAFC),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterDropdown({
    required String label,
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: [
        DropdownMenuItem<String>(value: null, child: Text(hint, style: const TextStyle(color: Color(0xFF94A3B8)))),
        ...items.map((it) => DropdownMenuItem(value: it, child: Text(it))),
      ],
      onChanged: onChanged,
      decoration: _inputDecoration(label: label),
      icon: const Icon(LucideIcons.chevronDown, size: 16),
      style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B), fontWeight: FontWeight.w500),
    );
  }

  Widget _buildDatePickerField({required String label, DateTime? date, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: _inputDecoration(label: label),
        child: Row(
          children: [
            Text(
              date == null ? "dd-mm-yyyy" : DateFormat('dd/MM/yyyy').format(date),
              style: TextStyle(color: date == null ? const Color(0xFF94A3B8) : const Color(0xFF1E293B), fontSize: 13),
            ),
            const Spacer(),
            const Icon(LucideIcons.calendar, size: 16, color: Color(0xFF64748B)),
          ],
        ),
      ),
    );
  }

  Widget _buildTableSection(AccountProvider provider, List<AccountModel> accounts) {
    return LayoutBuilder(builder: (context, constraints) {
      final totalWidth = constraints.maxWidth;
      
      // Percentage-based width calculation (Total = 1.0)
      double w(double p) => totalWidth * p;

      final widths = {
        'sr': w(0.05),
        'date': w(0.07),
        'name': w(0.14),
        'mobile': w(0.09),
        'gst': w(0.10),
        'group': w(0.11),
        'address': w(0.15),
        'station': w(0.08),
        'state': w(0.07),
        'dr': w(0.07),
        'cr': w(0.07),
      };

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 30, offset: const Offset(0, 10))],
        ),
        clipBehavior: Clip.antiAlias,
        child: provider.isLoading && provider.accounts.isEmpty
            ? const Padding(padding: EdgeInsets.all(100.0), child: Center(child: CircularProgressIndicator()))
            : accounts.isEmpty
                ? const Padding(padding: EdgeInsets.all(100.0), child: Center(child: Text("No records found", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 20, fontWeight: FontWeight.w500))))
                : DataTable(
                    headingRowHeight: 56,
                    dataRowMinHeight: 110,
                    dataRowMaxHeight: 140,
                    horizontalMargin: 0,
                    columnSpacing: 0,
                    headingRowColor: WidgetStateProperty.all(const Color(0xFFF1F5F9).withValues(alpha: 0.5)),
                    dividerThickness: 1,
                    columns: [
                      _buildColumn("Sr.No.", width: widths['sr']!, centered: true),
                      _buildColumn("Date", width: widths['date']!),
                      _buildColumn("Name", width: widths['name']!),
                      _buildColumn("Mobile", width: widths['mobile']!),
                      _buildColumn("GST No.", width: widths['gst']!),
                      _buildColumn("Group", width: widths['group']!),
                      _buildColumn("Address", width: widths['address']!),
                      _buildColumn("Station", width: widths['station']!),
                      _buildColumn("State", width: widths['state']!),
                      _buildColumn("Bal(Dr)", width: widths['dr']!),
                      _buildColumn("Bal(Cr)", width: widths['cr']!),
                    ],
                    rows: accounts.asMap().entries.map((entry) {
                      final i = entry.key;
                      final acc = entry.value;
                      return DataRow(
                        cells: [
                          _buildCell(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("${i + 1}", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Color(0xFF1E293B))),
                                const SizedBox(height: 10),
                                _buildTableIconButton(LucideIcons.pencil, const Color(0xFF2563EB), () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddAccountPage(account: acc))), size: 14),
                                const SizedBox(height: 6),
                                _buildTableIconButton(LucideIcons.trash, const Color(0xFFDC2626), () => _handleDelete(acc.id), size: 14),
                              ],
                            ),
                            width: widths['sr']!,
                            centered: true,
                          ),
                          _buildCell(child: Text(acc.createdAt != null ? DateFormat('d/M/yy').format(acc.createdAt!) : "-", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)), width: widths['date']!),
                          _buildCell(child: Text(acc.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))), width: widths['name']!),
                          _buildCell(child: Text(acc.mobileNumber != null && acc.mobileNumber!.isNotEmpty ? acc.mobileNumber! : "-", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)), width: widths['mobile']!),
                          _buildCell(child: Text(acc.gstin != null && acc.gstin!.isNotEmpty ? acc.gstin! : "-", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)), width: widths['gst']!),
                          _buildCell(child: Text(acc.groups.join(", "), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500), maxLines: 2, overflow: TextOverflow.ellipsis), width: widths['group']!),
                          _buildCell(child: Text(acc.address != null && acc.address!.isNotEmpty ? acc.address! : "-", maxLines: 4, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, height: 1.3)), width: widths['address']!),
                          _buildCell(child: Text(acc.stations.join(", "), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500), maxLines: 2, overflow: TextOverflow.ellipsis), width: widths['station']!),
                          _buildCell(child: Text(acc.state != null && acc.state!.isNotEmpty ? acc.state! : "-", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)), width: widths['state']!),
                          _buildCell(child: Text(acc.openingBalance?.type == "Dr" ? "₹${acc.openingBalance!.balance.toStringAsFixed(0)}" : "₹0", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1E293B))), width: widths['dr']!),
                          _buildCell(child: Text(acc.openingBalance?.type == "Cr" ? "₹${acc.openingBalance!.balance.toStringAsFixed(0)}" : "0", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)), width: widths['cr']!),
                        ],
                      );
                    }).toList(),
                  ),
      );
    });
  }

  DataColumn _buildColumn(String label, {required double width, bool centered = false}) {
    return DataColumn(
      label: Container(
        width: width,
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: centered ? Alignment.center : Alignment.centerLeft,
        decoration: const BoxDecoration(
          border: Border(right: BorderSide(color: Color(0xFFE2E8F0))),
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF475569), fontSize: 13, letterSpacing: 0.5)),
      ),
    );
  }

  DataCell _buildCell({required Widget child, required double width, bool centered = false}) {
    return DataCell(
      Container(
        width: width,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        alignment: centered ? Alignment.center : Alignment.centerLeft,
        decoration: const BoxDecoration(
          border: Border(right: BorderSide(color: Color(0xFFE2E8F0))),
        ),
        child: child,
      ),
    );
  }

  Widget _buildActionButton({required String label, required IconData icon, required Color color, Color? textColor, required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: textColor ?? Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
    );
  }

  Widget _buildIconAction({required IconData icon, required Color color, required Color bgColor, required VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withValues(alpha: 0.1), width: 1.5)),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }
  Widget _buildTableIconButton(IconData icon, Color color, VoidCallback onPressed, {double size = 16}) {
    return IconButton(
      icon: Icon(icon, size: size),
      color: color,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      onPressed: onPressed,
      hoverColor: color.withValues(alpha: 0.1),
    );
  }

  InputDecoration _inputDecoration({required String label, String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
      floatingLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF2563EB)),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2)),
    );
  }
}
