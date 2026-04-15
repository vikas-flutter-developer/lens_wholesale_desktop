import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../data/providers/inventory_report_provider.dart';
import '../../data/models/inventory_report_models.dart';
import '../../../masters/data/providers/account_provider.dart';
import '../../../masters/data/providers/inventory_providers.dart';

class PartyWiseItemReportPage extends StatefulWidget {
  const PartyWiseItemReportPage({super.key});

  @override
  State<PartyWiseItemReportPage> createState() => _PartyWiseItemReportPageState();
}

class _PartyWiseItemReportPageState extends State<PartyWiseItemReportPage> {
  final ScrollController _horizontalScroll = ScrollController();
  
  DateTime _fromDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _toDate = DateTime.now();
  String _partyName = '';
  String _groupName = '';
  String _searchText = '';
  List<String> _selectedTransTypes = ['Sale', 'Sale Order', 'Sale Return', 'Purchase', 'Purchase Return'];

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
      'fromDate': DateFormat('yyyy-MM-dd').format(_fromDate),
      'toDate': DateFormat('yyyy-MM-dd').format(_toDate),
      'partyName': _partyName,
      'groupName': _groupName,
      'searchText': _searchText,
      'transTypes': _selectedTransTypes,
    };
    context.read<InventoryReportProvider>().fetchPartyWiseItemReport(filters);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('Party Wise Item Report', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: Consumer<InventoryReportProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              _buildFilterSection(),
              if (provider.isLoading)
                const Expanded(child: Center(child: CircularProgressIndicator()))
              else if (provider.partyWiseItems == null)
                const Expanded(child: Center(child: Text('Apply filters to generate report')))
              else
                Expanded(child: _buildReportContent(provider.partyWiseItems!)),
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
              _filterItem('Party', _partyAutocomplete()),
              _filterItem('Group', _groupAutocomplete()),
              _filterItem('Search', _textField('Barcode, Item...', (v) => _searchText = v)),
              
              ElevatedButton.icon(
                onPressed: _handleSearch,
                icon: const Icon(LucideIcons.search, size: 16),
                label: const Text('Generate'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTransTypeFilters(),
        ],
      ),
    );
  }

  Widget _buildTransTypeFilters() {
    final types = ['Sale', 'Sale Order', 'Sale Return', 'Purchase', 'Purchase Return'];
    return Row(
      children: [
        const Text('TRANS TYPES:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
        const SizedBox(width: 12),
        Expanded(
          child: Wrap(
            spacing: 8,
            children: types.map((t) {
              final isSelected = _selectedTransTypes.contains(t);
              return FilterChip(
                label: Text(t, style: TextStyle(fontSize: 11, color: isSelected ? Colors.white : Colors.blueGrey)),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedTransTypes.add(t);
                    } else {
                      _selectedTransTypes.remove(t);
                    }
                  });
                },
                selectedColor: const Color(0xFF1E293B),
                checkmarkColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                visualDensity: VisualDensity.compact,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildReportContent(List<PartyWiseItem> items) {
    return Column(
      children: [
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
                  headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF475569), fontSize: 11),
                  columns: const [
                    DataColumn(label: Text('DATE')),
                    DataColumn(label: Text('TRANS TYPE')),
                    DataColumn(label: Text('SERIES')),
                    DataColumn(label: Text('VCH NO')),
                    DataColumn(label: Text('PARTY NAME')),
                    DataColumn(label: Text('PRODUCT')),
                    DataColumn(label: Text('BARCODE')),
                    DataColumn(label: Text('POWER')),
                    DataColumn(label: Text('QTY', textAlign: TextAlign.right)),
                    DataColumn(label: Text('PRICE', textAlign: TextAlign.right)),
                    DataColumn(label: Text('VALUE', textAlign: TextAlign.right)),
                    DataColumn(label: Text('MARGIN', textAlign: TextAlign.right)),
                  ],
                  rows: items.map((item) {
                    final isExpense = item.transType?.contains('Purchase') ?? false;
                    final price = item.pricePerUnit;
                    final purchasePrice = item.purchasePrice ?? 0;
                    final margin = isExpense ? 0.0 : (price - purchasePrice);
                    final marginTotal = margin * item.qty;

                    return DataRow(
                      cells: [
                        DataCell(Text(item.vchDate != null ? DateFormat('dd-MM-yy').format(DateTime.parse(item.vchDate!)) : '-')),
                        DataCell(_transTag(item.transType ?? '-')),
                        DataCell(Text(item.vchSeries ?? '-')),
                        DataCell(Text(item.vchNo ?? '-')),
                        DataCell(Text(item.partyName ?? '-')),
                        DataCell(Text(item.productName ?? '-')),
                        DataCell(Text(item.barcode ?? '-')),
                        DataCell(Text("${item.eye ?? ''} S:${item.sph ?? ''} C:${item.cyl ?? ''}", style: const TextStyle(fontSize: 10))),
                        DataCell(Align(alignment: Alignment.centerRight, child: Text(item.qty.toStringAsFixed(0)))),
                        DataCell(Align(alignment: Alignment.centerRight, child: Text('₹${price.toStringAsFixed(2)}'))),
                        DataCell(Align(alignment: Alignment.centerRight, child: Text('₹${item.totalPrice.toStringAsFixed(2)}'))),
                        DataCell(Align(
                          alignment: Alignment.centerRight, 
                          child: Text(
                            marginTotal != 0 ? '₹${marginTotal.toStringAsFixed(0)}' : '-',
                            style: TextStyle(color: marginTotal > 0 ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
                          )
                        )),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
        _buildFooterSummary(items),
      ],
    );
  }

  Widget _buildFooterSummary(List<PartyWiseItem> items) {
    final totalQty = items.fold(0.0, (s, i) => s + i.qty);
    final totalVal = items.fold(0.0, (s, i) => s + i.totalPrice);
    
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _sumItem('Total Items', items.length.toString()),
          const SizedBox(width: 32),
          _sumItem('Total Qty', totalQty.toStringAsFixed(0)),
          const SizedBox(width: 32),
          _sumItem('Grand Total', '₹${totalVal.toStringAsFixed(2)}', color: Colors.blue.shade900),
        ],
      ),
    );
  }

  Widget _sumItem(String label, String value, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: color ?? const Color(0xFF1E293B))),
      ],
    );
  }

  Widget _transTag(String type) {
    Color color = Colors.grey;
    if (type.contains('Sale')) color = Colors.blue;
    if (type.contains('Purchase')) color = Colors.orange;
    if (type.contains('Return')) color = Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
      child: Text(type.toUpperCase(), style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
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
        decoration: BoxDecoration(border: Border.all(color: const Color(0xFFCBD5E1)), borderRadius: BorderRadius.circular(4)),
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

  Widget _textField(String hint, Function(String) onChanged) {
    return SizedBox(
      width: 150,
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
      border: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFFCBD5E1)), borderRadius: BorderRadius.circular(4)),
      enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFFCBD5E1)), borderRadius: BorderRadius.circular(4)),
    );
  }
}
