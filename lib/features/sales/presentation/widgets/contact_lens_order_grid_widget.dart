import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/contact_lens_sale_order_model.dart';
import '../../data/models/lens_sale_order_model.dart';
import '../../../masters/data/models/account_model.dart';
import '../../../masters/data/providers/inventory_providers.dart';
import '../../../masters/data/providers/account_wise_price_provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'bulk_lens_matrix_modal.dart';

class ContactLensOrderGridWidget extends StatefulWidget {
  final List<ContactLensOrderItem> items;
  final AccountModel? selectedAccount;
  final Map<String, dynamic> customPrices;
  final Function(List<ContactLensOrderItem>) onItemsChanged;
  final Function(List<ContactLensOrderItem>) onAddItems;

  const ContactLensOrderGridWidget({
    super.key,
    required this.items,
    this.selectedAccount,
    required this.customPrices,
    required this.onItemsChanged,
    required this.onAddItems,
  });

  @override
  State<ContactLensOrderGridWidget> createState() => _ContactLensOrderGridWidgetState();
}

class _ContactLensOrderGridWidgetState extends State<ContactLensOrderGridWidget> {
  Map<int, String> rowErrors = {};
  Map<int, dynamic> rowStocks = {};

  Map<String, dynamic> _combinationExistsForRow(ContactLensOrderItem row) {
    if (row.itemName.isEmpty) return {'exists': false, 'reason': 'Item Name missing'};
    
    final lenses = context.read<LensGroupProvider>().lenses;
    final lens = lenses.firstWhere((l) => (l['productName'] ?? '').toLowerCase() == row.itemName.toLowerCase(), orElse: () => {});
    if (lens.isEmpty) return {'exists': false, 'reason': 'Product not found'};

    if (row.sph == 0 && row.sph.toString().isEmpty) return {'exists': false, 'reason': 'SPH missing'};
    if (row.cyl == 0 && row.cyl.toString().isEmpty) return {'exists': false, 'reason': 'CYL missing'};
    if (row.add == 0 && row.add.toString().isEmpty) return {'exists': false, 'reason': 'Add missing'};
    if (row.eye.isEmpty) return {'exists': false, 'reason': 'Eye missing'};

    final addGroups = lens['addGroups'] is List ? lens['addGroups'] as List : [];
    final targetSph = row.sph;
    final targetCyl = row.cyl;
    final targetAdd = row.add;
    final targetEye = row.eye.trim().toUpperCase();

    for (var ag in addGroups) {
      final agAddValue = double.tryParse(ag['addValue'].toString()) ?? 0.0;
      if (agAddValue != targetAdd) continue;

      final combos = ag['combinations'] is List ? ag['combinations'] as List : [];
      for (var comb in combos) {
        final combSph = double.tryParse(comb['sph'].toString()) ?? 0.0;
        final combCyl = double.tryParse(comb['cyl'].toString()) ?? 0.0;
        final combEye = (comb['eye']?.toString() ?? '').trim().toUpperCase();

        final sphMatch = combSph == targetSph;
        final cylMatch = combCyl == targetCyl;
        final eyeMatch = targetEye == 'RL' ? (combEye == 'R' || combEye == 'L' || combEye == 'RL') : combEye == targetEye;
        
        if (sphMatch && cylMatch && eyeMatch) {
           return {
             'exists': true,
             'combinationId': comb['_id'],
             'initStock': comb['initStock'] ?? comb['stock'] ?? comb['available'] ?? comb['quantity'] ?? 0,
           };
        }
      }
    }
    return {'exists': false, 'reason': 'Combo not found for SPH/CYL/ADD/Eye'};
  }

  void _validateRow(int index, ContactLensOrderItem row) {
     final res = _combinationExistsForRow(row);
     setState(() {
        if (res['exists'] == false) {
           rowErrors[index] = res['reason'] ?? '';
           rowStocks.remove(index);
        } else {
           rowErrors.remove(index);
           rowStocks[index] = res['initStock'] ?? '-';
        }
     });
     
     final newComboId = res['exists'] == true ? res['combinationId'].toString() : '';
     if (row.combinationId != newComboId) {
       _updateItem(index, row.copyWith(combinationId: newComboId));
     }
  }

  // Using an approach similar to `LensOrderGridWidget` for auto-calculations
  
  double _getSalePriceForCategory(Map<String, dynamic> lens, String categoryName) {
    if (lens.isEmpty) return 0.0;
    
    // Check salePrices map
    var sp = lens['salePrice'];
    if (sp == null) {
      sp = lens['salePrices'];
    }

    if (sp is Map) {
      // iterate keys case-insensitively
      for (var key in sp.keys) {
        if (key.toString().toLowerCase() == categoryName.toLowerCase()) {
          return double.tryParse(sp[key].toString()) ?? 0.0;
        }
      }
      // fallbacks
      if (sp.containsKey('default') || sp.containsKey('Default') || sp.containsKey('retail')) {
         return double.tryParse((sp['default'] ?? sp['Default'] ?? sp['retail']).toString()) ?? 0.0;
      }
      
      // return first non-zero
      for (var val in sp.values) {
        final d = double.tryParse(val.toString()) ?? 0.0;
        if (d != 0) return d;
      }
    }
    
    if (sp is num) return sp.toDouble();
    if (sp is String) return double.tryParse(sp) ?? 0.0;
    
    return 0.0;
  }

  void _handleProductSelected(int index, Map<String, dynamic> prod) {
    final item = widget.items[index];
    final cat = widget.selectedAccount?.accountCategory ?? '';
    
    double computedPrice = _getSalePriceForCategory(prod, cat);
    double discount = 0.0;
    
    // Check if custom price exists in AccountWisePrices
    if (widget.selectedAccount != null && prod['_id'] != null) {
      final customPriceObj = widget.customPrices[prod['_id'].toString()];
      if (customPriceObj != null) {
         final pct = double.tryParse(customPriceObj['percentage'].toString()) ?? 0.0;
         final cp = double.tryParse(customPriceObj['customPrice'].toString()) ?? 0.0;
         if (pct > 0) {
            discount = pct;
         } else if (cp > 0) {
            computedPrice = cp;
         }
      }
    }
    
    // Auto populate power if first combo exists
    String eye = '';
    double sph = 0.0, cyl = 0.0, axis = 0.0, add = 0.0;
    String comboId = '';
    
    if (prod['addGroups'] != null && prod['addGroups'] is List && (prod['addGroups'] as List).isNotEmpty) {
      final ag = (prod['addGroups'] as List)[0];
      if (ag['combinations'] != null && ag['combinations'] is List && (ag['combinations'] as List).isNotEmpty) {
         final comb = (ag['combinations'] as List)[0];
         eye = comb['eye']?.toString() ?? '';
         sph = double.tryParse(comb['sph'].toString()) ?? 0.0;
         cyl = double.tryParse(comb['cyl'].toString()) ?? 0.0;
         axis = double.tryParse(comb['axis'].toString()) ?? 0.0;
         add = double.tryParse(ag['addValue'].toString()) ?? 0.0;
         comboId = comb['_id']?.toString() ?? '';
      }
    }

    final mrp = double.tryParse(prod['mrp'].toString()) ?? 0.0;
    final total = 1 * computedPrice * (1.0 - (discount / 100.0));
    
    final updated = item.copyWith(
       itemName: prod['productName'] ?? '',
       billItemName: prod['billItemName'] ?? '',
       vendorItemName: prod['vendorItemName'] ?? '',
       mrp: mrp,
       salePrice: computedPrice,
       discount: discount,
       qty: 1,
       eye: eye,
       sph: sph,
       cyl: cyl,
       axis: axis,
       add: add,
       totalAmount: total,
       combinationId: comboId,
    );
    _updateItem(index, updated);
  }

  void _updateItem(int index, ContactLensOrderItem newItem) {
    final newItems = List<ContactLensOrderItem>.from(widget.items);
    newItems[index] = newItem;
    widget.onItemsChanged(newItems);
    Future.microtask(() => _validateRow(index, newItem));
  }

  void _deleteItem(int index) {
    final newItems = List<ContactLensOrderItem>.from(widget.items);
    newItems.removeAt(index);
    widget.onItemsChanged(newItems);
  }

  void _addNewRow() {
    final newItems = List<ContactLensOrderItem>.from(widget.items);
    newItems.add(const ContactLensOrderItem());
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
                const Text('Contact Lens Items List', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF64748B), letterSpacing: 1)),
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
              columnSpacing: 16,
              horizontalMargin: 16,
              columns: const [
                DataColumn(label: SizedBox(width: 30, child: Text('SR.'))),
                DataColumn(label: SizedBox(width: 200, child: Text('ITEM NAME'))),
                DataColumn(label: SizedBox(width: 60, child: Text('SPH'))),
                DataColumn(label: SizedBox(width: 60, child: Text('CYL'))),
                DataColumn(label: SizedBox(width: 60, child: Text('ADD'))),
                DataColumn(label: SizedBox(width: 40, child: Text('EYE'))),
                DataColumn(label: SizedBox(width: 60, child: Text('DIA'))),
                DataColumn(label: SizedBox(width: 80, child: Text('EXPIRY'))),
                DataColumn(label: SizedBox(width: 60, child: Text('QTY'))),
                DataColumn(label: SizedBox(width: 80, child: Text('SALE PRICE'))),
                DataColumn(label: SizedBox(width: 60, child: Text('DISC %'))),
                DataColumn(label: SizedBox(width: 80, child: Text('TOTAL'))),
                DataColumn(label: SizedBox(width: 80, child: Text('VENDOR'))),
                DataColumn(label: SizedBox(width: 40, child: Text('ACT'))),
              ],
              rows: widget.items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final hasError = rowErrors.containsKey(index);
                final errorText = rowErrors[index] ?? '';
                final stockValue = rowStocks[index] ?? '-';
                final bg = hasError ? Colors.red.withOpacity(0.05) : null;

                return DataRow(
                  cells: [
                    DataCell(Text('${index + 1}', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)))),
                    DataCell(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _ProductLookup(
                             value: item.itemName,
                             onSelected: (prod) => _handleProductSelected(index, prod),
                          ),
                          if (hasError) Text(errorText, style: const TextStyle(fontSize: 8, color: Colors.red, fontWeight: FontWeight.bold))
                          else if (item.itemName.isNotEmpty) Text('Stock: $stockValue', style: const TextStyle(fontSize: 9, color: Colors.green, fontWeight: FontWeight.bold)),
                        ]
                      )
                    ),
                    DataCell(_buildNumberField(item.sph.toString(), (v) => _updateItem(index, item.copyWith(sph: double.tryParse(v) ?? 0)), backgroundColor: bg)),
                    DataCell(_buildNumberField(item.cyl.toString(), (v) => _updateItem(index, item.copyWith(cyl: double.tryParse(v) ?? 0)), backgroundColor: bg)),
                    DataCell(_buildNumberField(item.add.toString(), (v) => _updateItem(index, item.copyWith(add: double.tryParse(v) ?? 0)), backgroundColor: bg)),
                    DataCell(_buildTextField(item.eye, (v) => _updateItem(index, item.copyWith(eye: v)), backgroundColor: bg)),
                    DataCell(_buildTextField(item.dia, (v) => _updateItem(index, item.copyWith(dia: v)))),
                    DataCell(_buildDateField(item.expiryDate ?? '', (v) => _updateItem(index, item.copyWith(expiryDate: v)))),
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
                    DataCell(Text(item.totalAmount.toStringAsFixed(2), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)))),
                    DataCell(_buildTextField(item.vendor, (v) => _updateItem(index, item.copyWith(vendor: v)))),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(LucideIcons.grid, size: 16, color: Colors.blueAccent),
                            tooltip: 'Open Matrix Entry',
                            onPressed: item.itemName.isEmpty ? null : () async {
                               final lenses = context.read<LensGroupProvider>().lenses;
                               final product = lenses.firstWhere((l) => (l['productName'] ?? '') == item.itemName, orElse: () => {});
                               if (product.isNotEmpty) {
                                  // Hack: We need to convert base item to standard SaleOrderItem logic for the modal
                                  final baseObj = item.toJson();
                                  showDialog(
                                    context: context,
                                    builder: (context) => BulkLensMatrixModal(
                                      product: product,
                                      baseItem: baseObj,
                                      onAddItems: (maps) {
                                          final items = maps.map((m) {
                                            return ContactLensOrderItem(
                                              itemName: m['itemName'] ?? '',
                                              qty: m['qty'] ?? 0,
                                              sph: (m['sph'] as num?)?.toDouble() ?? 0.0,
                                              cyl: (m['cyl'] as num?)?.toDouble() ?? 0.0,
                                              axis: (m['axis'] as num?)?.toDouble() ?? 0.0,
                                              add: (m['add'] as num?)?.toDouble() ?? 0.0,
                                              dia: m['dia']?.toString() ?? '',
                                              salePrice: (m['salePrice'] as num?)?.toDouble() ?? 0.0,
                                              discount: (m['discount'] as num?)?.toDouble() ?? 0.0,
                                              totalAmount: (m['totalAmount'] as num?)?.toDouble() ?? 0.0,
                                              combinationId: m['combinationId']?.toString() ?? '',
                                            );
                                          }).toList();
                                          widget.onAddItems(items);
                                      },
                                    ),
                                  );
                               }
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(LucideIcons.x, size: 16, color: Colors.red),
                            onPressed: () => _deleteItem(index),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ]
                      )
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

  Widget _buildTextField(String value, Function(String) onChanged, {Color? backgroundColor}) {
    return SizedBox(
      height: 32,
      child: TextField(
        controller: TextEditingController(text: value)..selection = TextSelection.fromPosition(TextPosition(offset: value.length)),
        onChanged: onChanged,
        style: const TextStyle(fontSize: 11),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          filled: true,
          fillColor: backgroundColor ?? const Color(0xFFF8FAFC),
        ),
      ),
    );
  }

  Widget _buildDateField(String value, Function(String) onChanged, {Color? backgroundColor}) {
    return SizedBox(
      height: 32,
      child: InkWell(
        onTap: () async {
          final initialDate = DateTime.tryParse(value) ?? DateTime.now();
          final picked = await showDatePicker(
            context: context, 
            initialDate: initialDate, 
            firstDate: DateTime(2000), 
            lastDate: DateTime(2100)
          );
          if (picked != null) {
             onChanged(picked.toIso8601String().split('T').first);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: backgroundColor ?? const Color(0xFFF8FAFC),
            border: Border.all(color: Colors.transparent),
          ),
          child: DefaultTextStyle(
            style: const TextStyle(fontSize: 11, color: Colors.black87),
            child: Text(value.isEmpty ? 'YYYY-MM-DD' : value)
          )
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

class _ProductLookup extends StatelessWidget {
  final String value;
  final ValueChanged<Map<String, dynamic>> onSelected;

  const _ProductLookup({required this.value, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Autocomplete<Map<String, dynamic>>(
      optionsBuilder: (textEditingValue) async {
        if (textEditingValue.text.isEmpty) return const Iterable<Map<String, dynamic>>.empty();
        final prov = context.read<LensGroupProvider>();
        if (prov.lenses.isEmpty) await prov.fetchAllLensPower();
        return prov.lenses.where((lens) {
           final prodName = lens['productName']?.toString().toLowerCase() ?? '';
           return prodName.contains(textEditingValue.text.toLowerCase());
        });
      },
      displayStringForOption: (option) => option['productName']?.toString() ?? '',
      onSelected: onSelected,
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        if (value.isNotEmpty && !focusNode.hasFocus) {
          controller.text = value;
        }
        return SizedBox(
          height: 32,
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              hintText: "Type Lens name...",
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              // Use prefix icon locally
            ),
          ),
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 250, maxWidth: 350),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: options.length,
                itemBuilder: (context, i) {
                  final opt = options.elementAt(i);
                  return InkWell(
                    onTap: () => onSelected(opt),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(opt['productName'] ?? '', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('MRP: ₹${opt['mrp'] ?? 0}', style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                              Text('SP: ₹${opt['salePrice']?['default'] ?? opt['salePrice'] ?? 0}', style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
