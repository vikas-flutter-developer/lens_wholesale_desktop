import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:lens_wholesale_desktop/features/purchases/data/providers/purchase_provider.dart';
import 'package:lens_wholesale_desktop/features/purchases/data/models/purchase_model.dart';

class PurchaseChallanListPage extends StatefulWidget {
  const PurchaseChallanListPage({super.key});

  @override
  State<PurchaseChallanListPage> createState() => _PurchaseChallanListPageState();
}

class _PurchaseChallanListPageState extends State<PurchaseChallanListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PurchaseProvider>().fetchPurchaseChallans();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PurchaseProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("Purchase Challans", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () => context.push('/purchases/add-purchase-challan'),
              icon: const Icon(LucideIcons.plus, size: 18),
              label: const Text("Receive Goods"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green[600], foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            ),
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.purchaseChallans.isEmpty
              ? _buildEmptyState()
              : _buildList(provider.purchaseChallans),
    );
  }

  Widget _buildList(List<PurchaseModel> challans) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: challans.length,
      itemBuilder: (context, index) {
        final pc = challans[index];
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFE2E8F0))),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            leading: CircleAvatar(backgroundColor: Colors.green[50], child: Icon(LucideIcons.package, color: Colors.green[600], size: 20)),
            title: Text("${pc.billData.billSeries}${pc.billData.billNo}", style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pc.partyData.partyAccount, style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w500)),
                Text("Date: ${pc.billData.date}"),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("₹${pc.netAmount.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(6)),
                      child: Text(pc.status, style: TextStyle(color: Colors.blue[600], fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                IconButton(icon: const Icon(LucideIcons.edit3, size: 18), onPressed: () => context.push('/purchases/add-purchase-challan?id=${pc.id}')),
                IconButton(
                  icon: const Icon(LucideIcons.trash2, size: 18, color: Colors.redAccent),
                  onPressed: () => _confirmDelete(pc.id!),
                ),
              ],
            ),
            onTap: () => context.push('/purchases/add-purchase-challan?id=${pc.id}'),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.truck, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text("No Purchase Challans Found", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          const SizedBox(height: 8),
          const Text("Keep track of your inward shipments here.", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Purchase Challan"),
        content: const Text("Are you sure you want to delete this challan? This action cannot be undone."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              await context.read<PurchaseProvider>().deletePurchase(id, 'PC');
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
