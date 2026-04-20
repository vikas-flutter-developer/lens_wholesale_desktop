import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/providers/utility_provider.dart';
import '../../../masters/data/providers/inventory_providers.dart';
import '../../../masters/data/models/item_group_model.dart';

class OffersManagementPage extends StatefulWidget {
  const OffersManagementPage({super.key});

  @override
  State<OffersManagementPage> createState() => _OffersManagementPageState();
}

class _OffersManagementPageState extends State<OffersManagementPage> {
  ItemGroupModel? selectedGroup;
  List<Map<String, dynamic>> products = [];
  Map<String, RowState> rowStates = {};
  String groupSearch = "";
  String productSearch = "";
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ItemGroupProvider>().fetchGroups();
    });
  }

  void _onGroupSelected(ItemGroupModel group) async {
    setState(() {
      selectedGroup = group;
      products = [];
      rowStates = {};
    });
    
    await context.read<UtilityProvider>().fetchOffersByGroup(group.groupName);
    
    if (mounted) {
      final offers = context.read<UtilityProvider>().groupProductOffers;
      setState(() {
        products = offers;
        for (var p in offers) {
          final id = p['id'].toString();
          if (p['offer'] != null) {
            rowStates[id] = RowState(
              percentage: p['offer']['percentage']?.toString() ?? "",
              qty: p['offer']['qty']?.toString() ?? "",
              offerPrice: (p['offer']['offerPrice'] ?? p['defaultPrice']).toDouble(),
              status: p['offer']['status'] ?? "OFFER SET",
            );
          } else {
            rowStates[id] = RowState(
              percentage: "",
              qty: "",
              offerPrice: (p['defaultPrice'] ?? 0).toDouble(),
              status: "DEFAULT",
            );
          }
        }
      });
    }
  }

  void _handlePercentageChange(String productId, String value, double defaultPrice) {
    if (value.isNotEmpty) {
      double? p = double.tryParse(value);
      if (p == null || p < 0 || p > 100) return;
    }

    setState(() {
      final current = rowStates[productId] ?? RowState(
        percentage: "",
        qty: "",
        offerPrice: defaultPrice,
        status: "DEFAULT",
      );
      String percentage = value;
      double offerPrice = defaultPrice;
      String status = "DEFAULT";

      if (percentage.isNotEmpty) {
        double pValue = double.tryParse(percentage) ?? 0;
        if (pValue > 0) {
          offerPrice = double.parse((defaultPrice - (defaultPrice * pValue) / 100).toStringAsFixed(2));
          status = "OFFER SET";
        }
      }

      rowStates[productId] = current.copyWith(
        percentage: percentage,
        offerPrice: offerPrice,
        status: status,
      );
    });
  }

  void _handleQtyChange(String productId, String value) {
    if (value.isNotEmpty) {
      int? q = int.tryParse(value);
      if (q == null || q < 0) return;
    }

    setState(() {
      final current = rowStates[productId] ?? RowState(
        percentage: "",
        qty: "",
        offerPrice: 0,
        status: "DEFAULT",
      );
      rowStates[productId] = current.copyWith(qty: value);
    });
  }

  void _copyFirstRowToAll() {
    if (products.isEmpty) return;
    final firstProdId = products[0]['id'].toString();
    final firstRow = rowStates[firstProdId];
    if (firstRow == null) return;

    setState(() {
      for (var p in products) {
        final id = p['id'].toString();
        if (id == firstProdId) continue;

        double defaultPrice = (p['defaultPrice'] ?? 0).toDouble();
        double pValue = double.tryParse(firstRow.percentage) ?? 0;
        double offerPrice = defaultPrice;
        String status = "DEFAULT";

        if (pValue > 0) {
          offerPrice = double.parse((defaultPrice - (defaultPrice * pValue) / 100).toStringAsFixed(2));
          status = "OFFER SET";
        }

        rowStates[id] = RowState(
          percentage: firstRow.percentage,
          qty: firstRow.qty,
          offerPrice: offerPrice,
          status: status,
        );
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Values copied to all rows")),
    );
  }

  Future<void> _handleSave() async {
    if (selectedGroup == null) return;

    setState(() => isSaving = true);
    
    try {
      final offersToSave = products.map((p) {
        final id = p['id'].toString();
        final state = rowStates[id] ?? RowState(
          percentage: "",
          qty: "",
          offerPrice: 0,
          status: "DEFAULT",
        );
        return {
          'id': p['id'],
          'isLens': p['isLens'],
          'defaultPrice': p['defaultPrice'],
          'percentage': double.tryParse(state.percentage) ?? 0.0,
          'qty': int.tryParse(state.qty) ?? 0,
          'offerPrice': state.offerPrice,
          'status': state.status,
        };
      }).where((o) => (o['percentage'] as double) > 0 && (o['qty'] as int) > 0).toList();

      final success = await context.read<UtilityProvider>().bulkUpsertGroupOffers(
        selectedGroup!.groupName,
        offersToSave,
      );

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Offers saved successfully")),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.read<UtilityProvider>().error ?? "Failed to save offers")),
          );
        }
      }
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupProvider = context.watch<ItemGroupProvider>();
    final utilityProvider = context.watch<UtilityProvider>();

    final filteredGroups = groupProvider.groups.where((g) => 
      g.groupName.toLowerCase().contains(groupSearch.toLowerCase())
    ).toList();

    final filteredProducts = products.where((p) => 
      p['name'].toString().toLowerCase().contains(productSearch.toLowerCase())
    ).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Group Offers Management",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Set group-wise offers with minimum quantity conditions",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: (isSaving || selectedGroup == null) ? null : _handleSave,
                  icon: isSaving 
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(LucideIcons.save, size: 20),
                  label: const Text("Save Offers"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Main Content
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Group List Sidebar
                  Container(
                    width: 320,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF64748B).withValues(alpha: 0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextField(
                            onChanged: (v) => setState(() => groupSearch = v),
                            decoration: InputDecoration(
                              hintText: "Search Group...",
                              prefixIcon: const Icon(LucideIcons.search, size: 18, color: Color(0xFF94A3B8)),
                              filled: true,
                              fillColor: const Color(0xFFF8FAFC),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 0),
                            ),
                          ),
                        ),
                        const Divider(height: 1),
                        Expanded(
                          child: groupProvider.isLoading 
                            ? const Center(child: CircularProgressIndicator())
                            : ListView.separated(
                                padding: const EdgeInsets.all(8),
                                itemCount: filteredGroups.length,
                                separatorBuilder: (_, ___) => const SizedBox(height: 4),
                                itemBuilder: (context, index) {
                                  final g = filteredGroups[index];
                                  final isSelected = selectedGroup?.id == g.id;
                                  return InkWell(
                                    onTap: () => _onGroupSelected(g),
                                    borderRadius: BorderRadius.circular(12),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: isSelected ? const Color(0xFFEFF6FF) : Colors.transparent,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isSelected ? const Color(0xFFBFDBFE) : Colors.transparent,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: isSelected ? const Color(0xFFDBEAFE) : const Color(0xFFF1F5F9),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Icon(
                                              LucideIcons.layers, 
                                              size: 16, 
                                              color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              g.groupName,
                                              style: GoogleFonts.plusJakartaSans(
                                                fontSize: 14,
                                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                                color: isSelected ? const Color(0xFF1E40AF) : const Color(0xFF475569),
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          if (isSelected) 
                                            const Icon(LucideIcons.chevronRight, size: 16, color: Color(0xFF2563EB)),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 32),

                  // Product List Area
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF64748B).withValues(alpha: 0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Toolbar
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              children: [
                                Icon(LucideIcons.package, size: 24, color: Colors.blue.shade600),
                                const SizedBox(width: 12),
                                Text(
                                  selectedGroup != null ? "Offers for: ${selectedGroup!.groupName}" : "Products List",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF0F172A),
                                  ),
                                ),
                                const Spacer(),
                                if (selectedGroup != null && products.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 16.0),
                                    child: OutlinedButton.icon(
                                      onPressed: _copyFirstRowToAll,
                                      icon: const Icon(LucideIcons.copy, size: 14),
                                      label: const Text("Copy First Row to All"),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: const Color(0xFF2563EB),
                                        side: const BorderSide(color: Color(0xFFDBEAFE)),
                                        backgroundColor: const Color(0xFFEFF6FF),
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                SizedBox(
                                  width: 250,
                                  child: TextField(
                                    onChanged: (v) => setState(() => productSearch = v),
                                    decoration: InputDecoration(
                                      hintText: "Search Product...",
                                      prefixIcon: const Icon(LucideIcons.search, size: 18, color: Color(0xFF94A3B8)),
                                      filled: true,
                                      fillColor: const Color(0xFFF8FAFC),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 1),

                          // Table
                          Expanded(
                            child: selectedGroup == null 
                              ? _buildEmptyState()
                              : utilityProvider.isLoading 
                                ? const Center(child: CircularProgressIndicator())
                                : _buildProductTable(filteredProducts),
                          ),

                          // Footer
                          if (selectedGroup != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              decoration: const BoxDecoration(
                                color: Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total Products: ${filteredProducts.length}",
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        for (var key in rowStates.keys) {
                                          final p = products.firstWhere((prod) => prod['id'].toString() == key);
                                          rowStates[key] = RowState(
                                            percentage: "",
                                            qty: "",
                                            offerPrice: (p['defaultPrice'] ?? 0).toDouble(),
                                            status: "DEFAULT",
                                          );
                                        }
                                      });
                                    },
                                    child: const Text(
                                      "Clear All",
                                      style: TextStyle(color: Color(0xFFEF4444), fontSize: 12, fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              shape: BoxShape.circle,
            ),
            child: Icon(LucideIcons.layers, size: 48, color: const Color(0xFF64748B).withValues(alpha: 0.2)),
          ),
          const SizedBox(height: 16),
          Text(
            "Selection Required",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Please select a product group from the left to manage offers",
            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildProductTable(List<Map<String, dynamic>> filteredProducts) {
    return SingleChildScrollView(
      child: Table(
        columnWidths: const {
          0: FixedColumnWidth(60),
          1: FlexColumnWidth(4),
          2: FlexColumnWidth(2),
          3: FlexColumnWidth(1.5),
          4: FlexColumnWidth(1.5),
          5: FlexColumnWidth(2),
          6: FlexColumnWidth(1.5),
        },
        children: [
          // Header Row
          TableRow(
            decoration: const BoxDecoration(color: Color(0xFFF8FAFC)),
            children: [
              _headerCell("Sr."),
              _headerCell("Product Info"),
              _headerCell("Default Price", align: TextAlign.center),
              _headerCell("Percentage (%)", align: TextAlign.center),
              _headerCell("Qty ✅", align: TextAlign.center),
              _headerCell("Offer Price", align: TextAlign.center),
              _headerCell("Status", align: TextAlign.center),
            ],
          ),
          // Data Rows
          ...List.generate(filteredProducts.length, (index) {
            final p = filteredProducts[index];
            final id = p['id'].toString();
            final state = rowStates[id] ?? RowState(
              percentage: "",
              qty: "",
              offerPrice: (p['defaultPrice'] ?? 0).toDouble(),
              status: "DEFAULT",
            );
            final isOfferSet = state.status == "OFFER SET";

            return TableRow(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
              ),
              children: [
                _cell(Text("${index + 1}", style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13))),
                _cell(Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (p['isLens'] ?? false) ? const Color(0xFFFAF5FF) : const Color(0xFFFFF7ED),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        (p['isLens'] ?? false) ? LucideIcons.layers : LucideIcons.package,
                        size: 14,
                        color: (p['isLens'] ?? false) ? const Color(0xFF9333EA) : const Color(0xFFEA580C),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p['name'].toString(),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                          Text(
                            (p['isLens'] ?? false) ? 'Lens Group' : 'Product',
                            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
                _cell(Center(
                   child: Container(
                     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                     decoration: BoxDecoration(
                       color: const Color(0xFFF1F5F9),
                       borderRadius: BorderRadius.circular(6),
                     ),
                     child: Text("₹${p['defaultPrice']}", style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF475569))),
                   ),
                )),
                _cell(Center(
                  child: _inputField(
                    value: state.percentage,
                    onChanged: (v) => _handlePercentageChange(id, v, (p['defaultPrice'] ?? 0).toDouble()),
                    suffix: "%",
                    width: 70,
                  ),
                )),
                _cell(Center(
                  child: _inputField(
                    value: state.qty,
                    onChanged: (v) => _handleQtyChange(id, v),
                    hint: "Min Qty",
                    width: 90,
                  ),
                )),
                _cell(Center(
                  child: Container(
                    width: 110,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isOfferSet ? const Color(0xFFEFF6FF) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: isOfferSet ? const Color(0xFFBFDBFE) : const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("₹", style: TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.bold)),
                        Text(
                          state.offerPrice.toString(),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: isOfferSet ? FontWeight.w900 : FontWeight.w700,
                            color: isOfferSet ? const Color(0xFF1E40AF) : const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
                _cell(Center(
                  child: isOfferSet 
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD1FAE5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.circle, size: 6, color: Color(0xFF10B981)),
                            const SizedBox(width: 4),
                            Text("OFFER SET", style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w800, color: const Color(0xFF065F46))),
                          ],
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text("DEFAULT", style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFF94A3B8))),
                      ),
                )),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _headerCell(String label, {TextAlign align = TextAlign.left}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Text(
        label.toUpperCase(),
        textAlign: align,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF64748B),
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _cell(Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: child,
    );
  }

  Widget _inputField({
    required String value,
    required Function(String) onChanged,
    String? suffix,
    String? hint,
    double width = 80,
  }) {
    return SizedBox(
      width: width,
      height: 36,
      child: TextField(
        controller: TextEditingController(text: value)..selection = TextSelection.collapsed(offset: value.length),
        onChanged: onChanged,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.right,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF334155)),
        decoration: InputDecoration(
          hintText: hint ?? "0",
          hintStyle: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 13),
          suffixText: suffix,
          suffixStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10, fontWeight: FontWeight.bold),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
          ),
        ),
      ),
    );
  }
}

class RowState {
  final String percentage;
  final String qty;
  final double offerPrice;
  final String status;

  RowState({
    required this.percentage,
    required this.qty,
    required this.offerPrice,
    required this.status,
  });

  RowState copyWith({
    String? percentage,
    String? qty,
    double? offerPrice,
    String? status,
  }) {
    return RowState(
      percentage: percentage ?? this.percentage,
      qty: qty ?? this.qty,
      offerPrice: offerPrice ?? this.offerPrice,
      status: status ?? this.status,
    );
  }
}
