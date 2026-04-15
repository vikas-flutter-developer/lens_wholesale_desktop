import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/inventory_provider.dart';
import '../../../masters/data/providers/inventory_providers.dart' as master_providers;
import '../widgets/lens_power_matrix_view.dart';

class LensStockReportPage extends StatefulWidget {
  const LensStockReportPage({super.key});

  @override
  State<LensStockReportPage> createState() => _LensStockReportPageState();
}

class _LensStockReportPageState extends State<LensStockReportPage> with SingleTickerProviderStateMixin {
  final TextEditingController _scanController = TextEditingController();
  final FocusNode _scanFocusNode = FocusNode();
  late TabController _tabController;
  
  String? _selectedLensGroupId;
  String? _selectedItemId;
  String _selectedEye = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scanFocusNode.requestFocus();
      Provider.of<master_providers.LensGroupProvider>(context, listen: false).fetchAllLensPower();
      Provider.of<master_providers.ItemMasterProvider>(context, listen: false).fetchItems();
    });
  }

  @override
  void dispose() {
    _scanController.dispose();
    _scanFocusNode.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _handleScan(String value) async {
    if (value.isEmpty) return;
    
    final provider = Provider.of<InventoryProvider>(context, listen: false);
    final barcodeData = await provider.lookupBarcode(value);

    if (barcodeData != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Found Item: ${barcodeData.productId}'),
          backgroundColor: Colors.green,
        ),
      );
      setState(() {
        _selectedLensGroupId = barcodeData.productId;
      });
      provider.fetchStockReport(
        lensGroup: barcodeData.productId,
        sph: barcodeData.sph,
        cyl: barcodeData.cyl,
        add: barcodeData.add,
      );
    } else if (mounted) {
      final deliveryData = await provider.checkDeliveryQR(value);
      if (deliveryData != null) {
        _showDeliveryConfirmation(deliveryData);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Not found'), backgroundColor: Colors.orange),
        );
      }
    }
    
    _scanController.clear();
    _scanFocusNode.requestFocus();
  }

  void _showDeliveryConfirmation(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delivery Confirmed'),
        content: Text('Order ID: ${data['lensData']?['orderId'] ?? 'N/A'}'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final inventoryProvider = Provider.of<InventoryProvider>(context);
    final lensGroupProvider = Provider.of<master_providers.LensGroupProvider>(context);
    final itemProvider = Provider.of<master_providers.ItemMasterProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildFastScanBar(),
            const SizedBox(height: 24),
            _buildFilters(lensGroupProvider, itemProvider),
            const SizedBox(height: 24),
            
            // Tab Header
            Container(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: const Color(0xFF3B82F6),
                unselectedLabelColor: const Color(0xFF64748B),
                indicatorColor: const Color(0xFF3B82F6),
                tabs: const [
                  Tab(text: "Stock Details"),
                  Tab(text: "SPH/CYL Matrix"),
                  Tab(text: "Analysis Summary"),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildStockTable(inventoryProvider),
                  LensPowerMatrixView(reportData: inventoryProvider.stockReport),
                  _buildAnalysisSummary(inventoryProvider),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Lens Stock Report",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF0F172A), letterSpacing: -1),
        ),
        Text(
          "📊 Parity Powered: Combined View With & Without Barcodes",
          style: TextStyle(fontSize: 14, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildFastScanBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.scanLine, color: Color(0xFF3B82F6), size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: KeyboardListener(
              focusNode: FocusNode(),
              onKeyEvent: (event) {
                if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
                  _handleScan(_scanController.text);
                }
              },
              child: TextField(
                controller: _scanController,
                focusNode: _scanFocusNode,
                onSubmitted: _handleScan,
                decoration: const InputDecoration(
                  hintText: "Fast Input: SCAN barcode or QR...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(master_providers.LensGroupProvider lensGroups, master_providers.ItemMasterProvider items) {
    return Row(
      children: [
        // Item Select (Primary)
        Expanded(
          flex: 2,
          child: DropdownButtonFormField<String>(
            value: _selectedItemId,
            decoration: const InputDecoration(labelText: "Select Item (Auto-fills Group)", filled: true, fillColor: Colors.white, border: OutlineInputBorder()),
            items: items.items.map((it) => DropdownMenuItem(value: it.id, child: Text(it.itemName))).toList(),
            onChanged: (val) {
              setState(() => _selectedItemId = val);
              if (val != null) {
                final selectedItem = items.items.firstWhere((it) => it.id == val);
                // Auto-fill logic from React: find the lens group that matches this item name
                final matchedGroup = lensGroups.lenses.cast<Map<String, dynamic>?>().firstWhere(
                  (lg) => lg?['productName'] == selectedItem.itemName,
                  orElse: () => null,
                );
                if (matchedGroup != null) {
                  setState(() => _selectedLensGroupId = matchedGroup['_id']);
                  Provider.of<InventoryProvider>(context, listen: false).fetchStockReport(lensGroup: matchedGroup['_id']);
                }
              }
            },
          ),
        ),
        const SizedBox(width: 16),
        // Group Filter
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _selectedLensGroupId,
            decoration: const InputDecoration(labelText: "Lens Group", filled: true, fillColor: Colors.white, border: OutlineInputBorder()),
            items: lensGroups.lenses.map((lg) => DropdownMenuItem(value: lg['_id']?.toString(), child: Text(lg['productName'] ?? ''))).toList(),
            onChanged: (val) {
              setState(() => _selectedLensGroupId = val);
              if (val != null) {
                Provider.of<InventoryProvider>(context, listen: false).fetchStockReport(lensGroup: val);
              }
            },
          ),
        ),
        const SizedBox(width: 16),
        // Eye Filter
        DropdownButton<String>(
          value: _selectedEye,
          items: ['All', 'R', 'L'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (val) => setState(() => _selectedEye = val!),
        ),
      ],
    );
  }

  Widget _buildStockTable(InventoryProvider provider) {
    if (provider.isLoading) return const Center(child: CircularProgressIndicator());
    final filteredData = _selectedEye == 'All' 
        ? provider.stockReport 
        : provider.stockReport.where((r) => r['eye'] == _selectedEye).toList();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Color(0xFFE2E8F0))),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(const Color(0xFFF1F5F9)),
              columns: const [
                DataColumn(label: Text("Product")),
                DataColumn(label: Text("Power (S/C/A)")),
                DataColumn(label: Text("Eye")),
                DataColumn(label: Text("Stock")),
                DataColumn(label: Text("B.Code")),
              ],
              rows: filteredData.map((r) => DataRow(cells: [
                DataCell(Text(r['productName'] ?? '--')),
                DataCell(Text("${r['sph']}/${r['cyl']}/${r['add']}")),
                DataCell(Text(r['eye'] ?? '--')),
                DataCell(Text(r['stock'].toString(), style: const TextStyle(fontWeight: FontWeight.bold))),
                DataCell(Text(r['barcode'] ?? '--', style: const TextStyle(fontSize: 10, color: Colors.blue))),
              ])).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnalysisSummary(InventoryProvider provider) {
    final data = provider.stockReport;
    final rStock = data.where((r) => r['eye'] == 'R').fold(0, (sum, r) => sum + (r['stock'] as int? ?? 0));
    final lStock = data.where((r) => r['eye'] == 'L').fold(0, (sum, r) => sum + (r['stock'] as int? ?? 0));
    final totalStock = data.fold(0, (sum, r) => sum + (r['stock'] as int? ?? 0));

    return Column(
      children: [
        Row(
          children: [
            _buildSummaryCard("Left Eye (L)", lStock, Colors.orange),
            const SizedBox(width: 16),
            _buildSummaryCard("Right Eye (R)", rStock, Colors.blue),
            const SizedBox(width: 16),
            _buildSummaryCard("Total Inventory", totalStock, Colors.green),
          ],
        ),
        const SizedBox(height: 24),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
            child: const Center(child: Text("📊 More detailed group charts can be added here as needed.")),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, int value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: color.withOpacity(0.2))),
        child: Column(
          children: [
            Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(value.toString(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: color)),
          ],
        ),
      ),
    );
  }
}
