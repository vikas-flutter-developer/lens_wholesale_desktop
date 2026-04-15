import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BarcodeLabelPrinter extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const BarcodeLabelPrinter({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Barcode Print Preview", style: TextStyle(fontWeight: FontWeight.w900)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.printer),
            onPressed: () {
              // Trigger OS print dialog if needed, or simple placeholder
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Printing is not yet implemented for desktop (requires 'printing' package)")),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      backgroundColor: const Color(0xFFF1F5F9),
      body: GridView.builder(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 2.0,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  item['productName'] ?? 'Lens Product',
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'S:${item['sph']} C:${item['cyl']} A:${item['add']}',
                  style: const TextStyle(fontSize: 9),
                ),
                const Spacer(),
                Expanded(
                  child: BarcodeWidget(
                    barcode: Barcode.code128(),
                    data: item['barcode']?.toString() ?? 'ERR-000',
                    width: double.infinity,
                    height: 50,
                    drawText: true,
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
