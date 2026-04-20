import 'package:flutter/material.dart';
import 'add_item_group_page.dart';
import 'add_item_page.dart';
import 'add_lens_group_page.dart';
import 'package:lucide_icons/lucide_icons.dart';

class InventoryMasterPage extends StatefulWidget {
  const InventoryMasterPage({super.key});

  @override
  State<InventoryMasterPage> createState() => _InventoryMasterPageState();
}

class _InventoryMasterPageState extends State<InventoryMasterPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 110,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                const Icon(LucideIcons.plusCircle, color: Color(0xFF2563EB), size: 32),
                const SizedBox(width: 12),
                const Text(
                  'Inventory Master Creation',
                  style: TextStyle(
                    color: Color(0xFF1E293B),
                    fontWeight: FontWeight.w900,
                    fontSize: 26,
                    letterSpacing: -0.8,
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 44.0, top: 2),
              child: Text(
                'Consolidated management for Groups, Items and Lens Specifications',
                style: TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 32.0),
            child: Container(
              height: 44,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: const Color(0xFF2563EB),
                unselectedLabelColor: const Color(0xFF64748B),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2)),
                  ],
                ),
                labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                tabs: const [
                  Tab(child: Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(LucideIcons.boxes, size: 14), SizedBox(width: 8), Text('Item Group')]))),
                  Tab(child: Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(LucideIcons.package, size: 14), SizedBox(width: 8), Text('Item Master')]))),
                  Tab(child: Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(LucideIcons.eye, size: 14), SizedBox(width: 8), Text('Lens Group')]))),
                ],
              ),
            ),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          AddItemGroupPage(hideHeader: true),
          AddItemPage(hideHeader: true),
          AddLensGroupPage(hideHeader: true),
        ],
      ),
    );
  }
}
