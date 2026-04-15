import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../data/providers/utility_provider.dart';
import '../../data/models/utility_models.dart';

class OffersManagementPage extends StatefulWidget {
  const OffersManagementPage({super.key});

  @override
  State<OffersManagementPage> createState() => _OffersManagementPageState();
}

class _OffersManagementPageState extends State<OffersManagementPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UtilityProvider>().fetchOffers();
    });
  }

  void _showAddOfferDialog() {
    // Dialog for adding/editing offers
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Campaign / Offer'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const TextField(decoration: InputDecoration(labelText: 'Offer Title')),
              const SizedBox(height: 12),
              const TextField(decoration: InputDecoration(labelText: 'Description')),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Expanded(child: TextField(decoration: InputDecoration(labelText: 'Discount Value'))),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      items: ['Percent', 'Flat'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (v) {},
                      decoration: const InputDecoration(labelText: 'Type'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Create Offer')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('Offers & Promotions', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ElevatedButton.icon(
              onPressed: _showAddOfferDialog,
              icon: const Icon(LucideIcons.plus, size: 18),
              label: const Text('New Offer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E293B),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
      body: Consumer<UtilityProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) return const Center(child: CircularProgressIndicator());
          if (provider.offers.isEmpty) return _buildEmptyState();

          return GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 1.6,
            ),
            itemCount: provider.offers.length,
            itemBuilder: (context, index) {
              final offer = provider.offers[index];
              return _buildOfferCard(offer);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.megaphone, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text('No Active Offers', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blueGrey)),
          const Text('Create promotional campaigns for your clients here.', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildOfferCard(AppOffer offer) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.white, Colors.indigo.withAlpha(13)], // 0.05 alpha ~ 13
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: offer.isActive ? Colors.green[50] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    offer.isActive ? 'ACTIVE' : 'INACTIVE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: offer.isActive ? Colors.green[800] : Colors.grey[600],
                    ),
                  ),
                ),
                PopupMenuButton(
                  itemBuilder: (context) => [
                    const PopupMenuItem(child: ListTile(leading: Icon(LucideIcons.edit2, size: 16), title: Text('Edit'))),
                    const PopupMenuItem(child: ListTile(leading: Icon(LucideIcons.trash, size: 16), title: Text('Delete'))),
                  ],
                  icon: const Icon(LucideIcons.moreVertical, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(offer.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            if (offer.description != null)
              Text(offer.description!, maxLines: 2, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Discount Value', style: TextStyle(fontSize: 10, color: Colors.grey)),
                    Text(
                      offer.discountType == 'Percent' ? '${offer.discountValue}% OFF' : '₹${offer.discountValue} OFF',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.indigo[900]),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Expiry', style: TextStyle(fontSize: 10, color: Colors.grey)),
                    Text(DateFormat('dd MMM yyyy').format(offer.validTo), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
