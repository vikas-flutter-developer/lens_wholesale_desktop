import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../data/providers/inventory_report_provider.dart';
import '../../data/models/inventory_report_models.dart';
import '../../../masters/data/providers/inventory_providers.dart';
import '../../../masters/data/providers/account_provider.dart';

class PowerMovementReportPage extends StatefulWidget {
  const PowerMovementReportPage({super.key});

  @override
  State<PowerMovementReportPage> createState() => _PowerMovementReportPageState();
}

class _PowerMovementReportPageState extends State<PowerMovementReportPage> {
  final ScrollController _horizontalScroll = ScrollController();
  
  DateTime _fromDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _toDate = DateTime.now();
  String _itemName = '';
  String _groupName = '';
  String _vendorName = '';
  String _movementStatus = 'All';
  
  // Power Group filters
  double? _minSph;
  double? _maxSph;
  double? _minCyl;
  double? _maxCyl;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountProvider>().fetchAllAccounts();
      context.read<ItemGroupProvider>().fetchGroups();
      context.read<ItemMasterProvider>().fetchItems();
    });
  }

  void _handleSearch() {
    final Map<String, dynamic> filters = {
      'fromDate': DateFormat('yyyy-MM-dd').format(_fromDate),
      'toDate': DateFormat('yyyy-MM-dd').format(_toDate),
      'itemName': _itemName,
      'groupName': _groupName,
      'vendorName': _vendorName,
      'movementStatus': _movementStatus,
      'minSph': _minSph,
      'maxSph': _maxSph,
      'minCyl': _minCyl,
      'maxCyl': _maxCyl,
    };
    context.read<InventoryReportProvider>().fetchPowerMovementReport(filters);
  }

  void _showMatrixModal(List<PowerMovementItem> data) {
    showDialog(
      context: context,
      builder: (context) => _PowerMatrixModal(data: data),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('Power Movement Analytics', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
        actions: [
          Consumer<InventoryReportProvider>(
            builder: (context, provider, _) => IconButton(
              icon: const Icon(LucideIcons.grid),
              onPressed: provider.powerMovementData == null 
                ? null 
                : () => _showMatrixModal(provider.powerMovementData!.data),
              tooltip: 'Power Matrix View',
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
              else if (provider.powerMovementData == null)
                const Expanded(child: Center(child: Text('Apply filters to generate analytics')))
              else
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildAnalyticsDashboard(provider.powerMovementData!.analytics),
                      const SizedBox(height: 24),
                      _buildDataTable(provider.powerMovementData!.data),
                    ],
                  ),
                ),
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
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          _filterItem('Date From', _datePicker(_fromDate, (d) => setState(() => _fromDate = d))),
          _filterItem('Date To', _datePicker(_toDate, (d) => setState(() => _toDate = d))),
          _filterItem('Item', _itemAutocomplete()),
          _filterItem('Status', _dropdown(_movementStatus, ['All', 'Fast', 'Moderate', 'Slow', 'Dead'], (v) => setState(() => _movementStatus = v!))),
          _filterItem('Group', _groupAutocomplete()),
          
          ElevatedButton.icon(
            onPressed: _handleSearch,
            icon: const Icon(LucideIcons.lineChart, size: 16),
            label: const Text('Analyze'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E293B),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsDashboard(PowerMovementAnalytics analytics) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 2.2,
      children: [
        _statCard('Total Quantity Sold', analytics.totalSummary?.totalQty.toString() ?? '0', LucideIcons.package, Colors.blue),
        _statCard('Total Revenue', '₹${analytics.totalSummary?.totalRevenue.toStringAsFixed(0) ?? '0'}', LucideIcons.indianRupee, const Color(0xFF10B981)),
        _statCard('Top Fast Moving', analytics.topFastMoving?.first.eye ?? '-', LucideIcons.trendingUp, Colors.orange),
        _statCard('Highest Revenue Power', analytics.highestRevenue?.totalRevenue.toStringAsFixed(0) ?? '-', LucideIcons.crown, Colors.amber),
      ],
    );
  }

  Widget _buildDataTable(List<PowerMovementItem> data) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Movement Details by Power', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          Scrollbar(
            controller: _horizontalScroll,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: _horizontalScroll,
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 24,
                headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                columns: const [
                  DataColumn(label: Text('EYE')),
                  DataColumn(label: Text('SPH')),
                  DataColumn(label: Text('CYL')),
                  DataColumn(label: Text('AXIS')),
                  DataColumn(label: Text('ADD')),
                  DataColumn(label: Text('ORDERS', textAlign: TextAlign.right)),
                  DataColumn(label: Text('QTY', textAlign: TextAlign.right)),
                  DataColumn(label: Text('REVENUE', textAlign: TextAlign.right)),
                  DataColumn(label: Text('STATUS')),
                ],
                rows: data.map((item) => DataRow(
                  cells: [
                    DataCell(Text(item.eye)),
                    DataCell(Text(item.sph.toStringAsFixed(2))),
                    DataCell(Text(item.cyl.toStringAsFixed(2))),
                    DataCell(Text(item.axis.toString())),
                    DataCell(Text(item.add.toStringAsFixed(2))),
                    DataCell(Align(alignment: Alignment.centerRight, child: Text(item.orderCount.toString()))),
                    DataCell(Align(alignment: Alignment.centerRight, child: Text(item.totalQty.toString()))),
                    DataCell(Align(alignment: Alignment.centerRight, child: Text('₹${item.totalRevenue.toStringAsFixed(0)}'))),
                    DataCell(_statusTag(item.movementStatus)),
                  ],
                )).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: color)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusTag(String status) {
    Color color = Colors.grey;
    if (status == 'Fast') color = Colors.green;
    if (status == 'Moderate') color = Colors.blue;
    if (status == 'Slow') color = Colors.orange;
    if (status == 'Dead') color = Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
      child: Text(status.toUpperCase(), style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
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

class _PowerMatrixModal extends StatelessWidget {
  final List<PowerMovementItem> data;

  const _PowerMatrixModal({required this.data});

  @override
  Widget build(BuildContext context) {
    // Logic to build matrix
    final List<double> sphList = data.map((e) => e.sph).toSet().toList()..sort();
    final List<double> addCylList = data.map((e) => e.add != 0 ? e.add : e.cyl).toSet().toList()..sort();

    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(24),
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
        child: Column(
          children: [
            Row(
              children: [
                const Text('Power Movement Matrix (SPH vs ADD/CYL)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(icon: const Icon(LucideIcons.x), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: Table(
                      defaultColumnWidth: const FixedColumnWidth(80),
                      border: TableBorder.all(color: Colors.grey.shade300),
                      children: [
                        // Header Row
                        TableRow(
                          children: [
                            _cell('SPH \\ AC', isHeader: true),
                            ...addCylList.map((ac) => _cell(ac.toStringAsFixed(2), isHeader: true)),
                          ],
                        ),
                        // Data Rows
                        ...sphList.map((sph) => TableRow(
                          children: [
                            _cell(sph.toStringAsFixed(2), isHeader: true),
                            ...addCylList.map((ac) {
                              final item = data.where((e) => e.sph == sph && (e.add == ac || (e.add == 0 && e.cyl == ac))).firstOrNull;
                              return _cell(item != null ? item.totalQty.toString() : '-', 
                                color: _getHeatMapColor(item?.totalQty ?? 0));
                            }),
                          ],
                        )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cell(String text, {bool isHeader = false, Color? color}) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: color ?? (isHeader ? Colors.grey.shade100 : Colors.white),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: isHeader ? const Color(0xFF475569) : const Color(0xFF1E293B),
        ),
      ),
    );
  }

  Color? _getHeatMapColor(int qty) {
    if (qty == 0) return null;
    if (qty > 50) return Colors.blue.shade100;
    if (qty > 20) return Colors.blue.shade50;
    return Colors.blue.shade50.withValues(alpha: 0.5);
  }
}
