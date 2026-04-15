import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:lens_wholesale_desktop/features/sales/data/providers/lens_sale_order_provider.dart';
import 'package:lens_wholesale_desktop/features/sales/data/providers/rx_sale_order_provider.dart';
import 'package:lens_wholesale_desktop/features/sales/data/providers/contact_lens_sale_order_provider.dart';
import 'package:lens_wholesale_desktop/features/sales/data/models/rx_sale_order_model.dart'; // Reuse RxOrderItem for consistency

class SaleItemSelectionModal extends StatefulWidget {
  final String partyAccount;

  const SaleItemSelectionModal({super.key, required this.partyAccount});

  @override
  State<SaleItemSelectionModal> createState() => _SaleItemSelectionModalState();
}

class _SaleItemSelectionModalState extends State<SaleItemSelectionModal> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _allOrders = [];
  Map<String, bool> _selectedItems = {}; // key: "orderId-itemIndex"
  String _searchQuery = '';
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    setState(() => _isLoading = true);
    try {
      final lensProv = context.read<LensSaleOrderProvider>();
      final rxProv = context.read<RxSaleOrderProvider>();
      final clProv = context.read<ContactLensSaleOrderProvider>();

      await Future.wait([
        lensProv.fetchAllOrders(),
        rxProv.fetchAllOrders(),
        clProv.fetchAllOrders(),
      ]);

      final List<Map<String, dynamic>> orders = [];

      // Combine and filter by party
      for (var o in lensProv.orders) {
        if (o.partyData.partyAccount == widget.partyAccount) {
          orders.add({'order': o, 'type': 'Lens Sale', 'id': o.id});
        }
      }
      for (var o in rxProv.orders) {
        if (o.partyData.partyAccount == widget.partyAccount) {
          orders.add({'order': o, 'type': 'Rx Sale', 'id': o.id});
        }
      }
      for (var o in clProv.orders) {
        if (o.partyData.partyAccount == widget.partyAccount) {
          orders.add({'order': o, 'type': 'Contact Lens', 'id': o.id});
        }
      }

      setState(() {
        _allOrders = orders;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching orders for selection: $e');
      setState(() => _isLoading = false);
    }
  }

  List<Map<String, dynamic>> get _filteredOrders {
    return _allOrders.where((o) {
      final order = o['order'];
      final dateStr = order.billData.date;
      final date = dateStr != null ? DateTime.tryParse(dateStr) : null;

      if (_startDate != null && date != null && date.isBefore(_startDate!)) return false;
      if (_endDate != null && date != null && date.isAfter(_endDate!)) return false;

      if (_searchQuery.isNotEmpty) {
        final matches = (order.items as List).any((it) => 
            (it.itemName ?? '').toLowerCase().contains(_searchQuery.toLowerCase()));
        if (!matches) return false;
      }
      return true;
    }).toList();
  }

  void _onAddItems() {
    final List<RxOrderItem> selected = [];
    for (var o in _allOrders) {
      final order = o['order'];
      final items = order.items as List;
      for (int i = 0; i < items.length; i++) {
        if (_selectedItems["${o['id']}-$i"] == true) {
          final it = items[i];
          // Map different item types to RxOrderItem (the most complete one)
          selected.add(RxOrderItem(
            id: it.id,
            barcode: it.barcode ?? '',
            itemName: it.itemName ?? '',
            billItemName: it.billItemName ?? '',
            vendorItemName: it.vendorItemName ?? '',
            unit: it.unit ?? '',
            orderNo: order.billData.billNo,
            eye: it.eye ?? '',
            sph: it.sph ?? 0.0,
            cyl: it.cyl ?? 0.0,
            axis: it.axis ?? 0.0,
            add: it.add ?? 0.0,
            qty: it.qty ?? 0,
            salePrice: it.salePrice ?? 0.0,
            discount: it.discount ?? 0.0,
            totalAmount: it.totalAmount ?? 0.0,
            combinationId: it.combinationId ?? '',
            customer: it is RxOrderItem ? (it as RxOrderItem).customer : '',
          ));
        }
      }
    }
    Navigator.pop(context, selected);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 900,
        height: 700,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Select Sale Items for Return', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('Party: ${widget.partyAccount}', style: const TextStyle(color: Color(0xFF64748B))),
                  ],
                ),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(LucideIcons.x)),
              ],
            ),
            const SizedBox(height: 20),
            _buildFilters(),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : _filteredOrders.isEmpty
                  ? const Center(child: Text('No matching orders found'))
                  : ListView.builder(
                      itemCount: _filteredOrders.length,
                      itemBuilder: (context, index) {
                        final o = _filteredOrders[index];
                        return _buildOrderCard(o);
                      },
                    ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _selectedItems.containsValue(true) ? _onAddItems : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Add Selected Items'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: (v) => setState(() => _searchQuery = v),
            decoration: InputDecoration(
              hintText: 'Search by item name...',
              prefixIcon: const Icon(LucideIcons.search, size: 16),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(width: 12),
        _buildDatePicker('Start', _startDate, (d) => setState(() => _startDate = d)),
        const SizedBox(width: 12),
        _buildDatePicker('End', _endDate, (d) => setState(() => _endDate = d)),
      ],
    );
  }

  Widget _buildDatePicker(String label, DateTime? value, Function(DateTime?) onSelected) {
    return InkWell(
      onTap: () async {
        final d = await showDatePicker(
          context: context, 
          initialDate: value ?? DateTime.now(), 
          firstDate: DateTime(2000), 
          lastDate: DateTime(2100)
        );
        onSelected(d);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE2E8F0)), borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            const Icon(LucideIcons.calendar, size: 14, color: Color(0xFF64748B)),
            const SizedBox(width: 8),
            Text(value == null ? label : DateFormat('dd/MM/yy').format(value), style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> o) {
    final order = o['order'];
    final items = order.items as List;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFE2E8F0))),
      child: ExpansionTile(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(4)),
              child: Text(o['type'], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
            ),
            const SizedBox(width: 12),
            Text('${order.billData.billSeries}-${order.billData.billNo}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const Spacer(),
            Text(order.billData.date ?? '', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
          ],
        ),
        subtitle: Text('Items: ${items.length} | Amount: ₹${order.netAmount}', style: const TextStyle(fontSize: 11)),
        children: [
          Container(
            color: const Color(0xFFF8FAFC),
            child: Column(
              children: items.asMap().entries.map((entry) {
                final idx = entry.key;
                final it = entry.value;
                final key = "${o['id']}-$idx";
                return CheckboxListTile(
                  value: _selectedItems[key] ?? false,
                  onChanged: (val) => setState(() => _selectedItems[key] = val ?? false),
                  title: Text(it.itemName ?? '', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  subtitle: Text('Power: SPH ${it.sph}, CYL ${it.cyl} | Qty: ${it.qty} | Price: ₹${it.salePrice}', style: const TextStyle(fontSize: 10)),
                  dense: true,
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
