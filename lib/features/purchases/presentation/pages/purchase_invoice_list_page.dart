import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:lens_wholesale_desktop/features/purchases/data/providers/purchase_provider.dart';
import 'package:lens_wholesale_desktop/features/purchases/data/models/purchase_model.dart';

class PurchaseInvoiceListPage extends StatefulWidget {
  const PurchaseInvoiceListPage({super.key});

  @override
  State<PurchaseInvoiceListPage> createState() => _PurchaseInvoiceListPageState();
}

class _PurchaseInvoiceListPageState extends State<PurchaseInvoiceListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PurchaseProvider>().fetchPurchaseEntries();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PurchaseProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("Purchase Invoices", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () => context.push('/purchases/add-purchase-invoice'),
              icon: const Icon(LucideIcons.plus, size: 18),
              label: const Text("Final Purchase Entry"),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E293B), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            ),
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.purchaseEntries.isEmpty
              ? _buildEmptyState()
              : _buildList(provider.purchaseEntries),
    );
  }

  Widget _buildList(List<PurchaseModel> invoices) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: invoices.length,
      itemBuilder: (context, index) {
        final pi = invoices[index];
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFE2E8F0))),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            leading: CircleAvatar(backgroundColor: Colors.blueGrey[50], child: Icon(LucideIcons.fileText, color: Colors.blueGrey[800], size: 20)),
            title: Text("${pi.billData.billSeries}${pi.billData.billNo}", style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pi.partyData.partyAccount, style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w500)),
                Text("Date: ${pi.billData.date}"),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("₹${pi.netAmount.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(6)),
                      child: Text("COMMITTED", style: TextStyle(color: Colors.green[700], fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                IconButton(icon: const Icon(LucideIcons.edit3, size: 18), onPressed: () => context.push('/purchases/add-purchase-invoice?id=${pi.id}')),
                IconButton(
                  icon: const Icon(LucideIcons.trash2, size: 18, color: Colors.redAccent),
                  onPressed: () => _confirmDelete(pi.id!),
                ),
              ],
            ),
            onTap: () => context.push('/purchases/add-purchase-invoice?id=${pi.id}'),
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
          Icon(LucideIcons.receipt, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text("No Purchase Invoices Found", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          const SizedBox(height: 8),
          const Text("Record your official purchases to update stock and accounts.", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Purchase Invoice"),
        content: const Text("CAUTION: Deleting this invoice may reverse some associated stock entries. Are you sure?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              await context.read<PurchaseProvider>().deletePurchase(id, 'PI');
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
