import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:lens_wholesale_desktop/features/purchases/data/providers/purchase_provider.dart';
import 'package:lens_wholesale_desktop/features/purchases/data/models/purchase_model.dart';
import 'package:intl/intl.dart';

class PendingPOModal extends StatefulWidget {
  final String partyAccount;
  final Function(List<PurchaseItem>, String) onOrderSelected; // items, poId

  const PendingPOModal({
    super.key,
    required this.partyAccount,
    required this.onOrderSelected,
  });

  @override
  State<PendingPOModal> createState() => _PendingPOModalState();
}

class _PendingPOModalState extends State<PendingPOModal> {
  final Set<String> _selectedIds = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PurchaseProvider>().fetchPurchaseOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PurchaseProvider>();
    final pendingOrders = provider.purchaseOrders.where((o) => 
      o.partyData.partyAccount == widget.partyAccount && 
      (o.balQty > 0 || o.status.toLowerCase() == 'pending')
    ).toList();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 1000,
        height: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Select Pending Purchase Orders", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text("Vendor: ${widget.partyAccount}", style: TextStyle(color: Colors.blue[600], fontWeight: FontWeight.bold)),
                  ],
                ),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(LucideIcons.x)),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : pendingOrders.isEmpty
                      ? const Center(child: Text("No pending orders found for this vendor."))
                      : _buildOrderList(pendingOrders),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _selectedIds.isEmpty ? null : () {
                    final selectedOrder = pendingOrders.firstWhere((o) => _selectedIds.contains(o.id));
                    widget.onOrderSelected(selectedOrder.items, selectedOrder.id ?? "");
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: const Text("Load Items"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(List<PurchaseModel> orders) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        final isSelected = _selectedIds.contains(order.id);

        return Card(
           margin: const EdgeInsets.only(bottom: 12),
           elevation: 0,
             shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(12),
               side: BorderSide(color: isSelected ? Colors.blue[300]! : const Color(0xFFE2E8F0), width: isSelected ? 2 : 1),
             ),
           child: InkWell(
             onTap: () => setState(() {
               _selectedIds.clear(); // Only single PO selection for now as per React base logic
               _selectedIds.add(order.id!);
             }),
             borderRadius: BorderRadius.circular(12),
             child: Padding(
               padding: const EdgeInsets.all(16),
               child: Row(
                 children: [
                   Checkbox(
                     value: isSelected, 
                     onChanged: (v) => setState(() {
                        _selectedIds.clear();
                        if (v == true) _selectedIds.add(order.id!);
                     })
                   ),
                   const SizedBox(width: 16),
                   Expanded(
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text("PO No: ${order.billData.billSeries}${order.billData.billNo}", style: const TextStyle(fontWeight: FontWeight.bold)),
                         Text("Date: ${order.billData.date ?? 'N/A'}", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                       ],
                     ),
                   ),
                   _buildStatCell("Qty", "${order.orderQty}"),
                   _buildStatCell("Bal", "${order.balQty}"),
                   _buildStatCell("Total", "₹${order.netAmount.toStringAsFixed(2)}", bold: true),
                 ],
               ),
             ),
           ),
        );
      },
    );
  }

  Widget _buildStatCell(String label, String value, {bool bold = false}) {
    return Container(
      width: 100,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          Text(value, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
