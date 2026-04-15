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
        title: const Text('Inventory & Lens Master', style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF2563EB),
          unselectedLabelColor: const Color(0xFF64748B),
          indicatorColor: const Color(0xFF2563EB),
          indicatorWeight: 3,
          tabs: const [
            Tab(icon: Icon(LucideIcons.layers), text: 'Item Groups'),
            Tab(icon: Icon(LucideIcons.package), text: 'Item Master'),
            Tab(icon: Icon(LucideIcons.grid), text: 'Lens Groups'),
          ],
        ),
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
