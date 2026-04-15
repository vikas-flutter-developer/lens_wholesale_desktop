import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../data/models/lens_sale_order_model.dart';
import '../../../masters/data/providers/tax_category_provider.dart';
import '../../../masters/data/models/tax_category_model.dart';

class OrderSummaryWidget extends StatefulWidget {
  final List<SaleOrderItem> items;
  final VoidCallback onSave;

  const OrderSummaryWidget({
    super.key,
    required this.items,
    required this.onSave,
  });

  @override
  State<OrderSummaryWidget> createState() => _OrderSummaryWidgetState();
}

class _OrderSummaryWidgetState extends State<OrderSummaryWidget> {
  TaxCategoryModel? _selectedTaxCategory;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<TaxCategoryProvider>().fetchAllTaxCategories();
      }
    });
  }

  double get _subtotal => widget.items.fold(0, (sum, item) => sum + item.totalAmount);
  
  double get _taxAmount {
    if (_selectedTaxCategory == null) return 0;
    // Simplified calculation based on IGST (centralTax) as the reference percentage
    return _subtotal * (_selectedTaxCategory!.centralTax / 100);
  }

  double get _netAmount => _subtotal + _taxAmount;

  @override
  Widget build(BuildContext context) {
    final taxes = context.watch<TaxCategoryProvider>().taxCategories;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 20, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Discount / Tax Selection
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Tax Configuration", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<TaxCategoryModel>(
                      value: _selectedTaxCategory,
                      decoration: InputDecoration(
                        labelText: "Select GST Category",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        prefixIcon: const Icon(LucideIcons.percent, size: 16),
                      ),
                      items: taxes.map((t) => DropdownMenuItem(value: t, child: Text("${t.name} (${t.centralTax}%)"))).toList(),
                      onChanged: (v) => setState(() => _selectedTaxCategory = v),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Remarks / Internal Note",
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 48),
              
              // Right: Totals
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    _buildTotalRow("Items Subtotal", "₹${_subtotal.toStringAsFixed(2)}"),
                    const SizedBox(height: 12),
                    _buildTotalRow("Tax Amount", "₹${_taxAmount.toStringAsFixed(2)}"),
                    const Divider(height: 32),
                    _buildTotalRow(
                      "Net Payable", 
                      "₹${_netAmount.toStringAsFixed(2)}", 
                      isFinal: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: widget.onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.checkCircle, size: 20),
                  SizedBox(width: 12),
                  Text("Complete Order & Generate Bill", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, String value, {bool isFinal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(
          fontSize: isFinal ? 16 : 14, 
          color: isFinal ? const Color(0xFF1E293B) : Colors.blueGrey,
          fontWeight: isFinal ? FontWeight.bold : FontWeight.normal,
        )),
        Text(value, style: TextStyle(
          fontSize: isFinal ? 20 : 14, 
          color: isFinal ? Colors.blue[900] : const Color(0xFF1E293B),
          fontWeight: FontWeight.bold,
        )),
      ],
    );
  }
}
