import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/rx_sale_order_model.dart';
import '../../data/models/lens_sale_order_model.dart';
import '../../../masters/data/models/account_model.dart';
import '../../../masters/data/providers/inventory_providers.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SaleReturnGridWidget extends StatefulWidget {
  final List<RxOrderItem> items;
  final AccountModel? selectedAccount;
  final Map<String, dynamic> customPrices;
  final Function(List<RxOrderItem>) onItemsChanged;
  final bool isRx;

  const SaleReturnGridWidget({
    super.key,
    required this.items,
    this.selectedAccount,
    required this.customPrices,
    required this.onItemsChanged,
    this.isRx = false,
  });

  @override
  State<SaleReturnGridWidget> createState() => _SaleReturnGridWidgetState();
}

class _SaleReturnGridWidgetState extends State<SaleReturnGridWidget> {
  Map<int, String> rowErrors = {};

  void _updateItem(int index, RxOrderItem newItem) {
    final newItems = List<RxOrderItem>.from(widget.items);
    newItems[index] = newItem;
    widget.onItemsChanged(newItems);
  }

  void _deleteItem(int index) {
    final newItems = List<RxOrderItem>.from(widget.items);
    newItems.removeAt(index);
    widget.onItemsChanged(newItems);
  }

  void _addNewRow() {
    final newItems = List<RxOrderItem>.from(widget.items);
    newItems.add(const RxOrderItem());
    widget.onItemsChanged(newItems);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFE2E8F0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.isRx ? 'RX Prescription Return Items' : 'Sale Return Items List', 
                   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF64748B), letterSpacing: 1)),
                ElevatedButton.icon(
                  onPressed: _addNewRow,
                  icon: const Icon(LucideIcons.plus, size: 14),
                  label: const Text('Add Row', style: TextStyle(fontSize: 11)),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E293B), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                )
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowHeight: 40,
              dataRowMinHeight: 48,
              dataRowMaxHeight: 48,
              headingTextStyle: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 0.5),
              columnSpacing: 12,
              horizontalMargin: 16,
              columns: [
                const DataColumn(label: SizedBox(width: 30, child: Text('SR.'))),
                const DataColumn(label: SizedBox(width: 180, child: Text('ITEM NAME'))),
                if (widget.isRx) const DataColumn(label: SizedBox(width: 120, child: Text('CUSTOMER/PATIENT'))),
                const DataColumn(label: SizedBox(width: 40, child: Text('EYE'))),
                const DataColumn(label: SizedBox(width: 55, child: Text('SPH'))),
                const DataColumn(label: SizedBox(width: 55, child: Text('CYL'))),
                const DataColumn(label: SizedBox(width: 55, child: Text('AXIS'))),
                const DataColumn(label: SizedBox(width: 55, child: Text('ADD'))),
                const DataColumn(label: SizedBox(width: 50, child: Text('RET QTY'))),
                const DataColumn(label: SizedBox(width: 80, child: Text('SALE PRICE'))),
                const DataColumn(label: SizedBox(width: 60, child: Text('DISC %'))),
                const DataColumn(label: SizedBox(width: 80, child: Text('TOTAL'))),
                const DataColumn(label: SizedBox(width: 120, child: Text('REASON/REMARK'))),
                const DataColumn(label: SizedBox(width: 40, child: Text('ACT'))),
              ],
              rows: widget.items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;

                return DataRow(
                  cells: [
                    DataCell(Text('${index + 1}', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)))),
                    DataCell(Text(item.itemName.isEmpty ? '-' : item.itemName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
                    if (widget.isRx) DataCell(Text(item.customer.isEmpty ? '-' : item.customer, style: const TextStyle(fontSize: 11))),
                    DataCell(Text(item.eye.isEmpty ? '-' : item.eye, style: const TextStyle(fontSize: 11))),
                    DataCell(Text(item.sph.toString(), style: const TextStyle(fontSize: 11))),
                    DataCell(Text(item.cyl.toString(), style: const TextStyle(fontSize: 11))),
                    DataCell(Text(item.axis.toString(), style: const TextStyle(fontSize: 11))),
                    DataCell(Text(item.add.toString(), style: const TextStyle(fontSize: 11))),
                    DataCell(_buildNumberField(item.qty.toString(), (v) {
                       final qty = int.tryParse(v) ?? 0;
                       _updateItem(index, item.copyWith(qty: qty, totalAmount: qty * item.salePrice * (1.0 - item.discount / 100)));
                    })),
                    DataCell(_buildNumberField(item.salePrice.toStringAsFixed(2), (v) {
                       final p = double.tryParse(v) ?? 0;
                       _updateItem(index, item.copyWith(salePrice: p, totalAmount: item.qty * p * (1.0 - item.discount / 100)));
                    })),
                     DataCell(_buildNumberField(item.discount.toString(), (v) {
                       final disc = double.tryParse(v) ?? 0;
                       _updateItem(index, item.copyWith(discount: disc, totalAmount: item.qty * item.salePrice * (1.0 - disc / 100)));
                    })),
                    DataCell(Text(item.totalAmount.toStringAsFixed(2), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFE11D48)))),
                    DataCell(_buildTextField(item.remark ?? '', (v) => _updateItem(index, item.copyWith(remark: v)), hint: 'Return reason')),
                    DataCell(
                      IconButton(
                        icon: const Icon(LucideIcons.x, size: 16, color: Colors.red),
                        onPressed: () => _deleteItem(index),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTextField(String value, Function(String) onChanged, {Color? backgroundColor, String? hint}) {
    return SizedBox(
      height: 32,
      child: TextField(
        controller: TextEditingController(text: value)..selection = TextSelection.fromPosition(TextPosition(offset: value.length)),
        onChanged: onChanged,
        style: const TextStyle(fontSize: 11),
        decoration: InputDecoration(
          hintText: hint,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          filled: true,
          fillColor: backgroundColor ?? const Color(0xFFF8FAFC),
        ),
      ),
    );
  }

  Widget _buildNumberField(String value, Function(String) onChanged, {Color? backgroundColor}) {
    return SizedBox(
      height: 32,
      child: TextField(
        controller: TextEditingController(text: value == '0.0' || value == '0' ? '' : value)..selection = TextSelection.fromPosition(TextPosition(offset: value == '0.0' || value == '0' ? 0 : value.length)),
        onChanged: onChanged,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 11),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          filled: true,
          fillColor: backgroundColor ?? const Color(0xFFF8FAFC),
        ),
      ),
    );
  }
}
