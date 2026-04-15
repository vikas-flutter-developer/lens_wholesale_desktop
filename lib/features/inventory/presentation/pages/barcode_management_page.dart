import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BarcodeManagementPage extends StatefulWidget {
  const BarcodeManagementPage({super.key});

  @override
  State<BarcodeManagementPage> createState() => _BarcodeManagementPageState();
}

class _BarcodeManagementPageState extends State<BarcodeManagementPage> {
  String _selectedTemplate = 'Standard Lens Sticker (25x15mm)';
  bool _includePrice = true;
  bool _includeBrand = true;
  int _copies = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Barcode & Label Management', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Row(
        children: [
          Expanded(flex: 2, child: _buildPreviewArea()),
          const VerticalDivider(width: 1),
          Expanded(flex: 1, child: _buildSettingsPanel()),
        ],
      ),
    );
  }

  Widget _buildPreviewArea() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Label Preview', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey)),
          const SizedBox(height: 24),
          Center(
            child: Container(
              width: 300,
              height: 180,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 20)],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   if (_includeBrand)
                    const Text('PREMIUM OPTICS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 8),
                  const Icon(Icons.qr_code, size: 80, color: Colors.black),
                  const Text('LENS-V1-10293', style: TextStyle(fontSize: 10, letterSpacing: 2)),
                  const SizedBox(height: 8),
                  if (_includePrice)
                    const Text('MRP: ₹1,299.00', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
            ),
          ),
          const Spacer(),
          const Text('Instructions:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const Text('1. Ensure your thermal label printer is connected.', style: TextStyle(fontSize: 13)),
          const Text('2. Select the correct template matching your label roll.', style: TextStyle(fontSize: 13)),
          const Text('3. Print a test label before batch printing.', style: TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildSettingsPanel() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Print Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 24),
          _label('Label Template'),
          DropdownButtonFormField<String>(
            value: _selectedTemplate,
            items: ['Standard Lens Sticker (25x15mm)', 'Large Box Label (50x30mm)', 'Small Jewelry Tag']
                .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 12))))
                .toList(),
            onChanged: (v) => setState(() => _selectedTemplate = v!),
            decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
          ),
          const SizedBox(height: 20),
          _label('Fields to Include'),
          CheckboxListTile(
            title: const Text('Show Price (MRP)', style: TextStyle(fontSize: 13)),
            value: _includePrice,
            onChanged: (v) => setState(() => _includePrice = v!),
            contentPadding: EdgeInsets.zero,
            dense: true,
          ),
          CheckboxListTile(
            title: const Text('Show Brand Name', style: TextStyle(fontSize: 13)),
            value: _includeBrand,
            onChanged: (v) => setState(() => _includeBrand = v!),
            contentPadding: EdgeInsets.zero,
            dense: true,
          ),
          const SizedBox(height: 20),
          _label('Number of Copies'),
          Row(
            children: [
              IconButton(onPressed: () => setState(() => _copies = (_copies > 1 ? _copies - 1 : 1)), icon: const Icon(LucideIcons.minusCircle)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('$_copies', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              IconButton(onPressed: () => setState(() => _copies++), icon: const Icon(LucideIcons.plusCircle)),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(LucideIcons.printer),
              label: const Text('Print Labels'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
    );
  }
}
