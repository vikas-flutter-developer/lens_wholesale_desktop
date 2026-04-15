import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:lens_wholesale_desktop/features/purchases/data/providers/purchase_provider.dart';
import 'package:lens_wholesale_desktop/features/purchases/data/models/purchase_model.dart';

class ContactLensPurchaseListPage extends StatefulWidget {
  const ContactLensPurchaseListPage({super.key});

  @override
  State<ContactLensPurchaseListPage> createState() => _ContactLensPurchaseListPageState();
}

class _ContactLensPurchaseListPageState extends State<ContactLensPurchaseListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PurchaseProvider>().fetchCLOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("Contact Lens Procurement", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.refreshCcw, size: 18),
            onPressed: () => context.read<PurchaseProvider>().fetchCLOrders(),
          ),
        ],
      ),
      body: Consumer<PurchaseProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) return const Center(child: CircularProgressIndicator());
          
          final list = provider.clOrders;

          if (list.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.shoppingBag, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text("No Contact Lens purchase records found", style: TextStyle(color: Colors.grey[500])),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFE2E8F0))),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  title: Text("${item.billData.billSeries}-${item.billData.billNo}", style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("${item.partyData.partyAccount} • ${item.billData.date}"),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("₹${item.netAmount.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.indigoAccent)),
                      const SizedBox(height: 4),
                      _StatusBadge(status: item.status),
                    ],
                  ),
                  onTap: () {
                    // View/Edit logic
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/purchases/cl/add'),
        label: const Text("New CL Order"),
        icon: const Icon(LucideIcons.plus),
        backgroundColor: Colors.indigo[700],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color = Colors.grey;
    if (status == 'Completed' || status == 'Received') color = Colors.green;
    else if (status == 'Pending') {
      color = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6), border: Border.all(color: color.withOpacity(0.5))),
      child: Text(status, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}
