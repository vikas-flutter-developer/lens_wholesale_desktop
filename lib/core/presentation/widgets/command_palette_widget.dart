import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import '../../../features/masters/data/providers/account_provider.dart';
import '../../../features/masters/data/providers/inventory_providers.dart';
import '../../../features/sales/data/providers/lens_sale_order_provider.dart';

class CommandPalette extends StatefulWidget {
  const CommandPalette({super.key});

  @override
  State<CommandPalette> createState() => _CommandPaletteState();
}

class _CommandPaletteState extends State<CommandPalette> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  int _selectedIndex = 0;
  List<SearchResult> _results = [];

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  void _onSearch(String query) {
    if (query.isEmpty) {
      setState(() => _results = []);
      return;
    }

    final results = <SearchResult>[];
    final q = query.toLowerCase();

    // 1. Search Accounts
    final accounts = context.read<AccountProvider>().accounts;
    for (final acc in accounts) {
      if ((acc.name ?? '').toLowerCase().contains(q)) {
        results.add(SearchResult(
          title: acc.name ?? '',
          subtitle: 'Account • ${acc.mobileNumber ?? 'No Mobile'}',
          icon: LucideIcons.user,
          route: '/masters/accountmaster/accountmaster', // Navigate to list or specific edit? 
          type: 'Account',
        ));
      }
    }

    // 2. Search Items
    final items = context.read<ItemMasterProvider>().items;
    for (final item in items) {
      if (item.itemName.toLowerCase().contains(q)) {
        results.add(SearchResult(
          title: item.itemName,
          subtitle: 'Item • ${item.groupName.isEmpty ? "Inventory" : item.groupName}',
          icon: LucideIcons.box,
          route: '/masters/inventorymaster/creation',
          type: 'Item',
        ));
      }
    }

    // 3. Search Orders
    final orders = context.read<LensSaleOrderProvider>().orders;
    for (final order in orders) {
       final bill = '${order.billData.billSeries}-${order.billData.billNo}'.toLowerCase();
       if (bill.contains(q) || order.partyData.partyAccount.toLowerCase().contains(q)) {
         results.add(SearchResult(
          title: '${order.billData.billSeries}-${order.billData.billNo}',
          subtitle: 'Sale Order • ${order.partyData.partyAccount}',
          icon: LucideIcons.shoppingBag,
          route: '/sales/add-lens-sale-order?id=${order.id}',
          type: 'Order',
        ));
       }
    }

    setState(() {
      _results = results.take(8).toList();
      _selectedIndex = 0;
    });
  }

  void _onSelect() {
    if (_results.isNotEmpty) {
      final res = _results[_selectedIndex];
      context.go(res.route);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Center(
        child: Container(
          width: 600,
          margin: const EdgeInsets.only(top: 100),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 40, offset: const Offset(0, 20)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Search Input
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(LucideIcons.search, color: Color(0xFF64748B), size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _focusNode,
                        onChanged: _onSearch,
                        onSubmitted: (_) => _onSelect(),
                        decoration: const InputDecoration(
                          hintText: 'Search for accounts, items, or orders...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Color(0xFF94A3B8)),
                        ),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const Text('Esc', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Results List
              if (_results.isNotEmpty)
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 400),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      final res = _results[index];
                      final isSelected = index == _selectedIndex;
                      return InkWell(
                        onTap: () {
                           setState(() => _selectedIndex = index);
                           _onSelect();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          color: isSelected ? const Color(0xFFF1F5F9) : Colors.transparent,
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.white : const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(res.icon, size: 18, color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B)),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(res.title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: isSelected ? const Color(0xFF1E293B) : const Color(0xFF475569))),
                                    Text(res.subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                const Icon(LucideIcons.cornerDownLeft, size: 14, color: Color(0xFF94A3B8)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              if (_results.isEmpty && _searchController.text.isNotEmpty)
                const Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text('No results found.', style: TextStyle(color: Color(0xFF94A3B8))),
                ),
              // Footer
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    _buildShortcutHint('↑↓', 'Navigate'),
                    const SizedBox(width: 16),
                    _buildShortcutHint('Enter', 'Select'),
                    const Spacer(),
                    const Text('Global Search', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFCBD5E1))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShortcutHint(String key, String label) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(4)),
          child: Text(key, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
      ],
    );
  }
}

class SearchResult {
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;
  final String type;

  SearchResult({required this.title, required this.subtitle, required this.icon, required this.route, required this.type});
}
