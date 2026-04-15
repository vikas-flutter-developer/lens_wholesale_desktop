import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:lens_wholesale_desktop/features/purchases/data/models/purchase_model.dart';
import 'package:lens_wholesale_desktop/features/masters/data/providers/inventory_providers.dart';
import 'package:lens_wholesale_desktop/features/masters/data/models/account_model.dart';
import 'package:lens_wholesale_desktop/features/masters/data/providers/account_wise_price_provider.dart';
import 'package:lens_wholesale_desktop/features/sales/presentation/widgets/bulk_lens_matrix_modal.dart';
import 'package:lens_wholesale_desktop/features/masters/data/providers/inventory_providers.dart';

class PurchaseGridWidget extends StatefulWidget {
  final List<PurchaseItem> items;
  final AccountModel? selectedAccount;
  final ValueChanged<List<PurchaseItem>> onItemsChanged;
  final Function(List<PurchaseItem>) onAddItems;

  const PurchaseGridWidget({
    super.key,
    required this.items,
    this.selectedAccount,
    required this.onItemsChanged,
    required this.onAddItems,
  });

  @override
  State<PurchaseGridWidget> createState() => _PurchaseGridWidgetState();
}

class _PurchaseGridWidgetState extends State<PurchaseGridWidget> {
  
  void _addRow() {
    final newList = List<PurchaseItem>.from(widget.items);
    newList.add(PurchaseItem());
    widget.onItemsChanged(newList);
  }

  void _removeRow(int index) {
    final newList = List<PurchaseItem>.from(widget.items);
    newList.removeAt(index);
    widget.onItemsChanged(newList);
  }

  void _updateRow(int index, PurchaseItem updated) {
    final newList = List<PurchaseItem>.from(widget.items);
    newList[index] = updated;
    widget.onItemsChanged(newList);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Grid Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                _buildHeaderCell("#", 40),
                _buildHeaderCell("Barcode", 120),
                _buildHeaderCell("Product Details", 180),
                _buildHeaderCell("Order #", 100),
                _buildHeaderCell("Dia", 60),
                _buildHeaderCell("Power (S/C/A/Ad)", 280),
                _buildHeaderCell("Qty", 70),
                _buildHeaderCell("P. Price", 100),
                _buildHeaderCell("Disc", 80),
                _buildHeaderCell("Total", 100),
                const Spacer(),
                const SizedBox(width: 40),
              ],
            ),
          ),
          
          if (widget.items.isEmpty)
            _buildEmptyState()
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.items.length,
              separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
              itemBuilder: (context, index) => _buildRow(index),
            ),
          
          Padding(
            padding: const EdgeInsets.all(16),
            child: OutlinedButton.icon(
              onPressed: _addRow,
              icon: const Icon(LucideIcons.plus, size: 16),
              label: const Text("Add New Row"),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 16)),
                foregroundColor: MaterialStateProperty.all(Colors.blue[600]),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(int index) {
    final item = widget.items[index];
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildTextCell("${index + 1}", 40),
          
          // Barcode
          SizedBox(
            width: 120,
            height: 35,
            child: TextField(
              controller: TextEditingController(text: item.barcode)..selection = TextSelection.collapsed(offset: item.barcode.length),
              onChanged: (v) => _updateRow(index, item.copyWith(barcode: v)),
              style: const TextStyle(fontSize: 12),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[50],
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              ),
            ),
          ),
          
          const SizedBox(width: 8),

          // Product Search
          SizedBox(
            width: 172,
            child: _ProductLookup(
              value: item.itemName,
              onSelected: (prod) => _handleProductSelected(index, prod),
            ),
          ),
          
          const SizedBox(width: 8),

          // Order #
          _buildTextInput(
            value: item.orderNo,
            width: 92,
            onChanged: (v) => _updateRow(index, item.copyWith(orderNo: v)),
            hint: "Order#",
          ),
          
          const SizedBox(width: 8),

          // Dia
          _buildTextInput(
            value: item.dia,
            width: 52,
            onChanged: (v) => _updateRow(index, item.copyWith(dia: v)),
            hint: "Dia",
          ),
          
          const SizedBox(width: 8),
          
          // Power Components
          SizedBox(
             width: 280,
             child: _PowerMatrix(
               sph: item.sph,
               cyl: item.cyl,
               axis: item.axis,
               add: item.add,
               onChanged: (s, c, a, ad) {
                 _updateRow(index, item.copyWith(sph: s, cyl: c, axis: a, add: ad));
               },
             ),
          ),

          // Bulk Matrix Button
          IconButton(
            icon: const Icon(LucideIcons.grid, size: 16, color: Colors.blueAccent),
            tooltip: 'Open Matrix Entry',
            onPressed: item.itemName.isEmpty ? null : () async {
               final lenses = await context.read<LensGroupProvider>().getAllLensPower();
               final product = lenses.firstWhere((l) => (l['productName'] ?? '') == item.itemName, orElse: () => {});
               if (product.isNotEmpty) {
                 showDialog(
                   context: context,
                   builder: (context) => BulkLensMatrixModal(
                     product: product,
                     baseItem: item.toJson(),
                     priceKey: 'purchasePrice',
                     onAddItems: (maps) {
                        final items = maps.map((m) => PurchaseItem.fromJson(m)).toList();
                        widget.onAddItems(items);
                     },
                   ),
                 );
               }
            },
          ),
          
          const SizedBox(width: 8),
          
          // Qty
          _buildNumericInput(
            value: item.qty.toString(),
            width: 70,
            onChanged: (v) {
              final val = int.tryParse(v) ?? 0;
              final sub = (val * item.purchasePrice) - item.discount;
              _updateRow(index, item.copyWith(qty: val, totalAmount: sub));
            }
          ),
          
          const SizedBox(width: 8),
          
          // Price
          _buildNumericInput(
            value: item.purchasePrice.toString(),
            width: 100,
            onChanged: (v) {
              final val = double.tryParse(v) ?? 0;
              final sub = (item.qty * val) - item.discount;
              _updateRow(index, item.copyWith(purchasePrice: val, totalAmount: sub));
            }
          ),
          
          const SizedBox(width: 8),

          // Discount
          _buildNumericInput(
            value: item.discount.toString(),
            width: 80,
            onChanged: (v) {
              final val = double.tryParse(v) ?? 0;
              final sub = (item.qty * item.purchasePrice) - val;
              _updateRow(index, item.copyWith(discount: val, totalAmount: sub));
            }
          ),

          const SizedBox(width: 8),
          
          // Total
          _buildTextCell("₹${item.totalAmount.toStringAsFixed(2)}", 100, bold: true),
          
          IconButton(
            onPressed: () => _removeRow(index),
            icon: const Icon(LucideIcons.trash2, color: Colors.red, size: 18),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  void _handleProductSelected(int index, Map<String, dynamic> prod) {
    final item = widget.items[index];
    double pPrice = double.tryParse(prod['purchasePrice']?.toString() ?? "0") ?? 0.0;
    _updateRow(index, item.copyWith(
      itemName: prod['productName'] ?? "",
      purchasePrice: pPrice,
      combinationId: prod['_id'] ?? "",
    ));
  }

  Widget _buildHeaderCell(String label, double width) => SizedBox(width: width, child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blueGrey)));
  Widget _buildTextCell(String text, double width, {bool bold = false}) => SizedBox(width: width, child: Text(text, style: TextStyle(fontSize: 13, fontWeight: bold ? FontWeight.bold : FontWeight.normal)));

  Widget _buildNumericInput({required String value, required double width, required ValueChanged<String> onChanged}) {
    return SizedBox(
      width: width,
      height: 35,
      child: TextField(
        controller: TextEditingController(text: value == '0.0' || value == '0' ? '' : value)..selection = TextSelection.collapsed(offset: value.length),
        onChanged: onChanged,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        ),
      ),
    );
  }

  Widget _buildTextInput({required String value, required double width, required ValueChanged<String> onChanged, String? hint}) {
    return SizedBox(
      width: width,
      height: 35,
      child: TextField(
        controller: TextEditingController(text: value)..selection = TextSelection.collapsed(offset: value.length),
        onChanged: onChanged,
        style: const TextStyle(fontSize: 12),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 11),
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        ),
      ),
    );
  }

  Widget _buildEmptyState() => const Padding(padding: EdgeInsets.all(48), child: Center(child: Column(children: [Icon(LucideIcons.package, size: 48, color: Color(0xFFCBD5E1)), SizedBox(height: 16), Text("No items added yet.", style: TextStyle(color: Colors.blueGrey))])));
}

class _ProductLookup extends StatelessWidget {
  final String value;
  final Function(Map<String, dynamic>) onSelected;

  const _ProductLookup({required this.value, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: Colors.blue[50]?.withOpacity(0.5), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.blue[100]!)),
      child: TextField(
        controller: TextEditingController(text: value),
        onTap: () async {
           final items = await context.read<LensGroupProvider>().getAllLensPower();
           if (items.isNotEmpty) onSelected(items.first);
        },
        readOnly: true,
        decoration: const InputDecoration(hintText: "Product...", border: InputBorder.none, suffixIcon: Icon(LucideIcons.search, size: 14)),
      ),
    );
  }
}

class _PowerMatrix extends StatelessWidget {
  final String sph, cyl, axis, add;
  final Function(String, String, String, String) onChanged;

  const _PowerMatrix({required this.sph, required this.cyl, required this.axis, required this.add, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _miniIn(context, sph, "S", (v) => onChanged(v, cyl, axis, add)),
        const SizedBox(width: 4),
        _miniIn(context, cyl, "C", (v) => onChanged(sph, v, axis, add)),
        const SizedBox(width: 4),
        _miniIn(context, axis, "A", (v) => onChanged(sph, cyl, v, add)),
        const SizedBox(width: 4),
        _miniIn(context, add, "Ad", (v) => onChanged(sph, cyl, axis, v)),
      ],
    );
  }

  Widget _miniIn(BuildContext context, String value, String label, ValueChanged<String> onChanged) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 9, color: Colors.grey)),
          const SizedBox(height: 2),
          SizedBox(
            height: 30,
            child: TextFormField(
              initialValue: value == '0.0' || value == '0' ? '' : value,
              onChanged: onChanged,
              style: const TextStyle(fontSize: 11),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
