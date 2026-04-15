import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../data/providers/audit_provider.dart';
import '../../../masters/data/providers/inventory_providers.dart';

class VerifyLensStockPage extends StatefulWidget {
  const VerifyLensStockPage({super.key});

  @override
  State<VerifyLensStockPage> createState() => _VerifyLensStockPageState();
}

class _VerifyLensStockPageState extends State<VerifyLensStockPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  final ScrollController _horizontalScroll = ScrollController();
  String _selectedGroup = 'All';
  bool _scanMode = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ItemGroupProvider>().fetchGroups();
      _handleSearch();
    });
  }

  void _handleSearch() {
    context.read<AuditProvider>().fetchStockAudit({
      'group': _selectedGroup == 'All' ? null : _selectedGroup,
      'search': _searchCtrl.text,
    });
  }

  void _commitAdjustments() async {
    final res = await context.read<AuditProvider>().commitStockAdjustment();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res['message']?.toString() ?? (res['success'] == true ? 'Adjustments committed' : 'Error')),
          backgroundColor: res['success'] == true ? Colors.green : Colors.red,
        ),
      );
      if (res['success'] == true) _handleSearch();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Verify Lens Stock', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Row(
            children: [
              const Text('Scan Mode', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
              Switch(
                value: _scanMode,
                onChanged: (v) => setState(() => _scanMode = v),
                activeThumbColor: Colors.blue[700],
              ),
            ],
          ),
          const SizedBox(width: 16),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ElevatedButton.icon(
              onPressed: _commitAdjustments,
              icon: const Icon(LucideIcons.save, size: 18),
              label: const Text('Commit Adjustments'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(child: _buildTable()),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Search Barcode or Item...',
                prefixIcon: const Icon(LucideIcons.search, size: 20),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onSubmitted: (_) => _handleSearch(),
            ),
          ),
          const SizedBox(width: 16),
          Consumer<ItemGroupProvider>(
            builder: (context, provider, _) => Container(
              width: 200,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedGroup,
                  isExpanded: true,
                  items: ['All', ...provider.groups.map((e) => e.groupName)]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13))))
                      .toList(),
                  onChanged: (v) {
                    setState(() => _selectedGroup = v!);
                    _handleSearch();
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            onPressed: _handleSearch,
            icon: const Icon(LucideIcons.refreshCcw),
            tooltip: 'Reload',
          ),
        ],
      ),
    );
  }

  Widget _buildTable() {
    return Consumer<AuditProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) return const Center(child: CircularProgressIndicator());
        if (provider.error != null) {
          return Center(child: Text('Error: ${provider.error}', style: const TextStyle(color: Colors.red)));
        }
        if (provider.stockAuditItems.isEmpty) return const Center(child: Text('No stock data found.'));

        return Scrollbar(
          controller: _horizontalScroll,
          child: SingleChildScrollView(
            controller: _horizontalScroll,
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(Colors.grey[100]),
                columns: const [
                  DataColumn(label: Text('Barcode')),
                  DataColumn(label: Text('Item Name')),
                  DataColumn(label: Text('Group')),
                  DataColumn(label: Text('Lens Info')),
                  DataColumn(label: Text('System Stock'), numeric: true),
                  DataColumn(label: Text('Physical Stock'), numeric: true),
                  DataColumn(label: Text('Variance'), numeric: true),
                  DataColumn(label: Text('Actions')),
                ],
                rows: List.generate(provider.stockAuditItems.length, (index) {
                  final it = provider.stockAuditItems[index];
                  final variance = it.variance;
                  return DataRow(
                    cells: [
                      DataCell(Text(it.barcode ?? '-', style: const TextStyle(fontWeight: FontWeight.bold))),
                      DataCell(Text(it.productName)),
                      DataCell(Text(it.groupName)),
                      DataCell(Text('${it.lensInfo?.eye ?? ""} ${it.lensInfo?.sph ?? ""} ${it.lensInfo?.cyl ?? ""}')),
                      DataCell(Text(it.systemStock.toStringAsFixed(0))),
                      DataCell(
                        SizedBox(
                          width: 80,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            onChanged: (v) {
                              final val = double.tryParse(v) ?? 0;
                              provider.updatePhysicalStock(index, val);
                            },
                            decoration: const InputDecoration(contentPadding: EdgeInsets.zero),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: variance == 0
                                ? Colors.green[50]
                                : (variance < 0 ? Colors.red[50] : Colors.blue[50]),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            variance.toStringAsFixed(0),
                            style: TextStyle(
                              color: variance == 0
                                  ? Colors.green[800]
                                  : (variance < 0 ? Colors.red[800] : Colors.blue[800]),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Icon(
                          it.isVerified ? LucideIcons.checkCircle : LucideIcons.circle,
                          color: it.isVerified ? Colors.green : Colors.grey,
                          size: 20,
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }
}
