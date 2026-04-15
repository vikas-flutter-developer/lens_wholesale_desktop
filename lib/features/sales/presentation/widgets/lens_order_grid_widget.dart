import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../data/models/lens_sale_order_model.dart';
import '../../../masters/data/providers/inventory_providers.dart';
import '../../../masters/data/models/account_model.dart';
import 'bulk_lens_matrix_modal.dart';

class LensOrderGridWidget extends StatefulWidget {
  final List<SaleOrderItem> items;
  final AccountModel? selectedAccount;
  final ValueChanged<List<SaleOrderItem>> onItemsChanged;
  final Function(List<SaleOrderItem>) onAddItems;

  const LensOrderGridWidget({
    super.key,
    required this.items,
    this.selectedAccount,
    required this.onItemsChanged,
    required this.onAddItems,
  });

  @override
  State<LensOrderGridWidget> createState() => _LensOrderGridWidgetState();
}

class _LensOrderGridWidgetState extends State<LensOrderGridWidget> {
  
  void _addRow() {
    final newList = List<SaleOrderItem>.from(widget.items);
    newList.add(const SaleOrderItem());
    widget.onItemsChanged(newList);
  }

  void _removeRow(int index) {
    final newList = List<SaleOrderItem>.from(widget.items);
    newList.removeAt(index);
    widget.onItemsChanged(newList);
  }

  void _updateRow(int index, SaleOrderItem updated) {
    final newList = List<SaleOrderItem>.from(widget.items);
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
                _buildHeaderCell("Product Details", 250),
                _buildHeaderCell("Power (S/C/A/D/A)", 350),
                _buildHeaderCell("Qty", 80),
                _buildHeaderCell("Price", 120),
                _buildHeaderCell("Total", 120),
                const Spacer(),
                const SizedBox(width: 40), // For delete button
              ],
            ),
          ),
          
          // Grid Rows
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
          
          // Add Row Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: OutlinedButton.icon(
              onPressed: _addRow,
              icon: const Icon(LucideIcons.plus, size: 16),
              label: const Text("Add New Item (F2)"),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 16)),
                foregroundColor: MaterialStateProperty.all(Colors.blue[300]!),
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
          
          // Product Search/Display
          Expanded(
            flex: 4,
            child: _ProductLookup(
              value: item.itemName,
              onSelected: (prod) => _handleProductSelected(index, prod),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Power Matrix
          Expanded(
             flex: 6,
             child: _PowerMatrix(
               sph: item.sph,
               cyl: item.cyl,
               axis: item.axis,
               dia: item.dia,
               add: item.add,
               onChanged: (s, c, a, d, ad) {
                 _updateRow(index, item.copyWith(sph: s, cyl: c, axis: a, dia: d, add: ad));
               },
             ),
          ),
          const SizedBox(width: 8),
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
                     onAddItems: (maps) {
                        final items = maps.map((m) => SaleOrderItem.fromJson(m)).toList();
                        widget.onAddItems(items);
                     },
                   ),
                 );
               }
            },
          ),
          
          const SizedBox(width: 12),
          
          // Qty
          _buildNumericInput(
            value: item.qty.toString(),
            width: 80,
            onChanged: (v) {
              final val = int.tryParse(v) ?? 0;
              _updateRow(index, item.copyWith(qty: val, totalAmount: (val * item.salePrice)));
            }
          ),
          
          const SizedBox(width: 12),
          
          // Price
          _buildNumericInput(
            value: item.salePrice.toString(),
            width: 120,
            prefix: "₹",
            onChanged: (v) {
              final val = double.tryParse(v) ?? 0;
              _updateRow(index, item.copyWith(salePrice: val, totalAmount: (item.qty * val)));
            }
          ),
          
          const SizedBox(width: 12),
          
          // Total
          _buildTextCell("₹${item.totalAmount.toStringAsFixed(2)}", 120, bold: true),
          
          const Spacer(),
          
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
    // Logic to handle product selection and auto-linking category price
    final item = widget.items[index];
    
    double initialPrice = 0.0;
    if (widget.selectedAccount != null) {
       // Logic to fetch custom price based on Step 15 mappings
       // For now, defaulting to standard sale price
       initialPrice = double.tryParse(prod['salePrice']?['default'].toString() ?? "0") ?? 0.0;
    }

    _updateRow(index, item.copyWith(
      itemName: prod['productName'] ?? prod['itemName'] ?? "",
      salePrice: initialPrice,
      dia: prod['dia'] ?? "",
      combinationId: prod['_id'] ?? "",
    ));
  }

  // Helper widgets...
  Widget _buildHeaderCell(String label, double width) {
    return SizedBox(width: width, child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blueGrey)));
  }

  Widget _buildTextCell(String text, double width, {bool bold = false}) {
    return SizedBox(width: width, child: Text(text, style: TextStyle(fontSize: 13, fontWeight: bold ? FontWeight.bold : FontWeight.normal)));
  }

  Widget _buildNumericInput({required String value, required double width, String? prefix, required ValueChanged<String> onChanged}) {
    return SizedBox(
      width: width,
      height: 40,
      child: TextField(
        controller: TextEditingController(text: value)..selection = TextSelection.collapsed(offset: value.length),
        onChanged: onChanged,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          prefixText: prefix,
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Padding(
      padding: EdgeInsets.all(48),
      child: Center(
        child: Column(
          children: [
            Icon(LucideIcons.shoppingCart, size: 48, color: Color(0xFFCBD5E1)),
            SizedBox(height: 16),
            Text("No items added to this order yet.", style: TextStyle(color: Colors.blueGrey)),
          ],
        ),
      ),
    );
  }
}

class _ProductLookup extends StatelessWidget {
  final String value;
  final Function(Map<String, dynamic>) onSelected;

  const _ProductLookup({required this.value, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    // In a real app, this would be a search-enabled dropdown or autocomplete
    // For this demonstration, we'll use a mocked lookup
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: Colors.blue[50]?.withOpacity(0.5), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.blue[100]!)),
      child: TextField(
        controller: TextEditingController(text: value),
        onTap: () async {
           // Mock lookup - in production this triggers a searchable overlay
           final items = await context.read<LensGroupProvider>().getAllLensPower();
           if (items.isNotEmpty) onSelected(items.first);
        },
        readOnly: true,
        decoration: const InputDecoration(
          hintText: "Select Product...",
          border: InputBorder.none,
          suffixIcon: Icon(LucideIcons.search, size: 14),
        ),
      ),
    );
  }
}

class _PowerMatrix extends StatelessWidget {
  final double sph, cyl, axis, add;
  final String dia;
  final Function(double, double, double, String, double) onChanged;

  const _PowerMatrix({required this.sph, required this.cyl, required this.axis, required this.dia, required this.add, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _miniIn(context, sph.toString(), "S", (v) => onChanged(double.tryParse(v)??0, cyl, axis, dia, add)),
        const SizedBox(width: 4),
        _miniIn(context, cyl.toString(), "C", (v) => onChanged(sph, double.tryParse(v)??0, axis, dia, add)),
        const SizedBox(width: 4),
        _miniIn(context, axis.toString(), "A", (v) => onChanged(sph, cyl, double.tryParse(v)??0, dia, add)),
        const SizedBox(width: 4),
        _miniIn(context, dia, "D", (v) => onChanged(sph, cyl, axis, v, add)),
        const SizedBox(width: 4),
        _miniIn(context, add.toString(), "Ad", (v) => onChanged(sph, cyl, axis, dia, double.tryParse(v)??0)),
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
            height: 32,
            child: TextFormField(
              initialValue: value == '0.0' || value == '0' ? '' : value,
              key: Key("${label}_$value"),
              onChanged: onChanged,
              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              style: const TextStyle(fontSize: 11),
              textAlign: TextAlign.center,
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
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
