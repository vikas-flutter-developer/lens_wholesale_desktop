import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'dart:io';
import 'package:path_provider/path_provider.dart';

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
  final ScrollController _horizontalScroll = ScrollController();
  final TextEditingController _itemSearchCtrl = TextEditingController();
  final TextEditingController _partySearchCtrl = TextEditingController();

  DateTime _fromDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _toDate = DateTime.now();
  String _groupName = '';
  String _itemName = '';
  String _barcode = '';
  String _partyName = '';
  String _searchType = 'Movement'; // Movement, Unmoved, All

  // Lens Power Filters
  String _eye = '';
  String _sph = '';
  String _cyl = '';
  String _axis = '';
  String _add = '';

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
    _horizontalScroll.dispose();
    _itemSearchCtrl.dispose();
    _partySearchCtrl.dispose();
    super.dispose();
  }

  void _handleSearch() {
    final Map<String, dynamic> filters = {
      'fromDate': DateFormat('yyyy-MM-dd').format(_fromDate),
      'toDate': DateFormat('yyyy-MM-dd').format(_toDate),
      'groupName': _groupName,
      'itemName': _itemName,
      'barcode': _barcode,
      'partyName': _partyName,
      'searchType': _searchType,
      'eye': _eye,
      'sph': _sph,
      'cyl': _cyl,
      'axis': _axis,
      'add': _add,
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
        title: const Text('Lens Movement Report', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        actions: [
          Consumer<InventoryReportProvider>(
            builder: (context, provider, _) => IconButton(
              icon: const Icon(LucideIcons.fileOutput),
              onPressed: provider.lensMovementData == null 
                ? null 
                : () => _exportToCSV(_processMovementData(provider.lensMovementData!), provider.lensMovementData!.openingStock, provider.lensMovementData!.closingStock),
              tooltip: 'Export CSV',
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
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              _filterItem('From Date', _datePicker(_fromDate, (d) => setState(() => _fromDate = d))),
              _filterItem('To Date', _datePicker(_toDate, (d) => setState(() => _toDate = d))),
              
              _filterItem('Search Type', _dropdown(_searchType, ['Movement', 'Unmoved', 'All'], (v) => setState(() => _searchType = v!))),
              
              _filterItem('Group', _groupAutocomplete()),
              _filterItem('Item Name', _itemAutocomplete()),
              _filterItem('Party', _partyAutocomplete()),
              _filterItem('Barcode', _textField('Barcode', (v) => _barcode = v)),

              // Lens Power Row
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _powerField('EYE', (v) => _eye = v),
                  _powerField('SPH', (v) => _sph = v),
                  _powerField('CYL', (v) => _cyl = v),
                  _powerField('AXIS', (v) => _axis = v),
                  _powerField('ADD', (v) => _add = v),
                ],
              ),

              ElevatedButton.icon(
                onPressed: _handleSearch,
                icon: const Icon(LucideIcons.search, size: 16),
                label: const Text('Search'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _groupName = '';
                    _itemName = '';
                    _barcode = '';
                    _partyName = '';
                    _itemSearchCtrl.clear();
                    _partySearchCtrl.clear();
                  });
                },
                child: const Text('Clear'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReportContent(LensMovementReportData data) {
    final movements = _processMovementData(data);
    
    return Column(
      children: [
        // Summary Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            color: Color(0xFFF1F5F9),
            border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
          ),
          child: Row(
            children: [
              _summaryItem('Opening Stock', data.openingStock, const Color(0xFF64748B)),
              const SizedBox(width: 32),
              _summaryItem('Total Inward', movements.fold(0.0, (s, i) => s + i.inwardQty), const Color(0xFF0F172A)),
              const SizedBox(width: 32),
              _summaryItem('Total Outward', movements.fold(0.0, (s, i) => s + i.outwardQty), const Color(0xFF0F172A)),
              const Spacer(),
              _summaryItem('Closing Balance', data.closingStock, const Color(0xFF2563EB), isHighlight: true),
            ],
          ),
        ),

        // Table
        Expanded(
          child: Scrollbar(
            controller: _horizontalScroll,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: _horizontalScroll,
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columnSpacing: 20,
                  headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                  headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF475569), fontSize: 12),
                  dataTextStyle: const TextStyle(color: Color(0xFF1E293B), fontSize: 12),
                  border: const TableBorder(horizontalInside: BorderSide(color: Color(0xFFF1F5F9))),
                  columns: const [
                    DataColumn(label: Text('DATE')),
                    DataColumn(label: Text('TRANS')),
                    DataColumn(label: Text('VCH NO')),
                    DataColumn(label: Text('PARTY NAME')),
                    DataColumn(label: Text('ITEM NAME')),
                    DataColumn(label: Text('POWER')),
                    DataColumn(label: Text('OPENING', textAlign: TextAlign.right)),
                    DataColumn(label: Text('INWARD', textAlign: TextAlign.right)),
                    DataColumn(label: Text('OUTWARD', textAlign: TextAlign.right)),
                    DataColumn(label: Text('CLOSING', textAlign: TextAlign.right)),
                  ],
                  rows: movements.map((item) {
                    final powerStr = "${item.eye ?? ''} S:${item.sph ?? ''} C:${item.cyl ?? ''} A:${item.axis ?? ''} Ad:${item.add ?? ''}";
                    return DataRow(
                      cells: [
                        DataCell(Text(item.date != null ? DateFormat('dd-MM-yy').format(DateTime.parse(item.date!)) : '-')),
                        DataCell(Text(item.transType ?? '-')),
                        DataCell(Text(item.voucherNo ?? '-')),
                        DataCell(Text(item.partyName ?? '-')),
                        DataCell(Text(item.itemName)),
                        DataCell(Text(powerStr, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)))),
                        DataCell(Align(alignment: Alignment.centerRight, child: Text(item.opening.toStringAsFixed(0)))),
                        DataCell(Align(alignment: Alignment.centerRight, child: Text(item.inwardQty > 0 ? '+${item.inwardQty.toStringAsFixed(0)}' : '-', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)))),
                        DataCell(Align(alignment: Alignment.centerRight, child: Text(item.outwardQty > 0 ? '-${item.outwardQty.toStringAsFixed(0)}' : '-', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)))),
                        DataCell(Align(alignment: Alignment.centerRight, child: Text(item.closing.toStringAsFixed(0), style: const TextStyle(fontWeight: FontWeight.bold)))),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),

        // Unmoved Items Section (if any)
        if (data.unmovedItems.isNotEmpty) _buildUnmovedSection(data.unmovedItems),
      ],
    );
  }

  Widget _buildUnmovedSection(List<UnmovedItem> items) {
    return Container(
      height: 200,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0), width: 2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text('Unmoved Items (Items with no transactions in period)', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  dense: true,
                  title: Text(item.itemName ?? item.productName ?? 'Unnamed Item', style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text("${item.eye} S:${item.sph} C:${item.cyl} A:${item.axis} Ad:${item.add}", style: const TextStyle(fontSize: 10)),
                  trailing: Text("Stock: ${item.currentStock.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _filterItem(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label.toUpperCase(), style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
        const SizedBox(height: 4),
        child,
      ],
    );
  }

  Widget _summaryItem(String label, double value, Color color, {bool isHighlight = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
        Text(value.toStringAsFixed(0), style: TextStyle(
          fontSize: isHighlight ? 20 : 16,
          fontWeight: FontWeight.w900,
          color: color,
        )),
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
            const Icon(LucideIcons.calendar, size: 14, color: Color(0xFF64748B)),
            const SizedBox(width: 8),
            Text(DateFormat('dd-MM-yy').format(date), style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _dropdown(String value, List<String> items, Function(String?) onChanged) {
    return Container(
      width: 120,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(border: Border.all(color: const Color(0xFFCBD5E1)), borderRadius: BorderRadius.circular(4)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 12)))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _groupAutocomplete() {
    return SizedBox(
      width: 150,
      child: Consumer<ItemGroupProvider>(
        builder: (context, provider, _) => Autocomplete<String>(
          optionsBuilder: (textEditingValue) {
            return provider.groups
                .map((e) => e.groupName)
                .where((e) => e.toLowerCase().contains(textEditingValue.text.toLowerCase()));
          },
          onSelected: (v) => _groupName = v,
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

  Widget _itemAutocomplete() {
    return SizedBox(
      width: 200,
      child: Consumer<ItemMasterProvider>(
        builder: (context, provider, _) => Autocomplete<String>(
          optionsBuilder: (textEditingValue) {
            return provider.items
                .map((e) => e.itemName)
                .where((e) => e.toLowerCase().contains(textEditingValue.text.toLowerCase()));
          },
          onSelected: (v) => _itemName = v,
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            _itemSearchCtrl.text = controller.text;
            return TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: _inputDeco('Select Item'),
              style: const TextStyle(fontSize: 12),
            );
          },
        ),
      ),
    );
  }

  Widget _partyAutocomplete() {
    return SizedBox(
      width: 200,
      child: Consumer<AccountProvider>(
        builder: (context, provider, _) => Autocomplete<String>(
          optionsBuilder: (textEditingValue) {
            return provider.accounts
                .map((e) => e.name)
                .where((e) => e.toLowerCase().contains(textEditingValue.text.toLowerCase()));
          },
          onSelected: (v) => _partyName = v,
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            _partySearchCtrl.text = controller.text;
            return TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: _inputDeco('Select Party'),
              style: const TextStyle(fontSize: 12),
            );
          },
        ),
      ),
    );
  }

  Widget _textField(String hint, Function(String) onChanged) {
    return SizedBox(
      width: 120,
      child: TextField(
        decoration: _inputDeco(hint),
        style: const TextStyle(fontSize: 12),
        onChanged: onChanged,
      ),
    );
  }

  Widget _powerField(String hint, Function(String) onChanged) {
    return Container(
      width: 50,
      margin: const EdgeInsets.only(right: 4),
      child: TextField(
        decoration: _inputDeco(hint).copyWith(contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8)),
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
        onChanged: onChanged,
      ),
    );
  }

  InputDecoration _inputDeco(String hint) {
    return InputDecoration(
      hintText: hint,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      border: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFFCBD5E1)), borderRadius: BorderRadius.circular(4)),
      enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFFCBD5E1)), borderRadius: BorderRadius.circular(4)),
    );
  }
}
