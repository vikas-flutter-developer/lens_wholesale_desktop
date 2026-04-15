import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:lens_wholesale_desktop/features/purchases/data/providers/purchase_provider.dart';
import 'package:lens_wholesale_desktop/features/purchases/data/models/purchase_model.dart';
import 'package:intl/intl.dart';

class PurchaseOrderListPage extends StatefulWidget {
  const PurchaseOrderListPage({super.key});

  @override
  State<PurchaseOrderListPage> createState() => _PurchaseOrderListPageState();
}

class _PurchaseOrderListPageState extends State<PurchaseOrderListPage> {
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

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("Purchase Orders", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () => context.push('/purchases/add-purchase-order'),
              icon: const Icon(LucideIcons.plus, size: 18),
              label: const Text("Create PO"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[600], foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            ),
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.purchaseOrders.isEmpty
              ? _buildEmptyState()
              : _buildList(provider.purchaseOrders),
    );
  }

  Widget _buildList(List<PurchaseModel> orders) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFE2E8F0))),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            leading: CircleAvatar(backgroundColor: Colors.blue[50], child: Icon(LucideIcons.shoppingBag, color: Colors.blue[600], size: 20)),
            title: Text("${order.billData.billSeries}${order.billData.billNo}", style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order.partyData.partyAccount, style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w500)),
                Text("Date: ${order.billData.date}"),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("₹${order.netAmount.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: _getStatusColor(order.status).withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                      child: Text(order.status, style: TextStyle(color: _getStatusColor(order.status), fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                IconButton(icon: const Icon(LucideIcons.edit3, size: 18), onPressed: () => context.push('/purchases/add-purchase-order?id=${order.id}')),
                IconButton(
                  icon: const Icon(LucideIcons.trash2, size: 18, color: Colors.redAccent),
                  onPressed: () => _confirmDelete(order.id!),
                ),
              ],
            ),
            onTap: () => context.push('/purchases/add-purchase-order?id=${order.id}'),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending': return Colors.orange;
      case 'done': return Colors.green;
      case 'cancelled': return Colors.red;
      default: return Colors.grey;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.shoppingCart, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text("No Purchase Orders Found", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          const SizedBox(height: 8),
          const Text("Create your first PO to start tracking orders.", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Purchase Order"),
        content: const Text("Are you sure you want to delete this PO? This action cannot be undone."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              await context.read<PurchaseProvider>().deletePurchase(id, 'PO');
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
