import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../data/models/lens_sale_challan_model.dart';
import 'package:intl/intl.dart';

class LoadSaleChallansModal extends StatefulWidget {
  final List<LensSaleChallanModel> challans;
  final String partyName;

  const LoadSaleChallansModal({super.key, required this.challans, required this.partyName});

  @override
  State<LoadSaleChallansModal> createState() => _LoadSaleChallansModalState();
}

class _LoadSaleChallansModalState extends State<LoadSaleChallansModal> {
  // Key format: "${challanId}-${itemIndex}"
  final Map<String, bool> _selectedItems = {};

  @override
  void initState() {
    super.initState();
    // Initialize all as unchecked
    for (var challan in widget.challans) {
      for (int i = 0; i < challan.items.length; i++) {
        _selectedItems['${challan.id}-$i'] = false;
      }
    }
  }

  void _toggleItem(String challanId, int index, bool? value) {
    setState(() {
      _selectedItems['$challanId-$index'] = value ?? false;
    });
  }

  void _toggleChallan(LensSaleChallanModel challan, bool? value) {
    setState(() {
      for (int i = 0; i < challan.items.length; i++) {
        _selectedItems['${challan.id}-$i'] = value ?? false;
      }
    });
  }

  void _toggleAll(bool? value) {
    setState(() {
      for (var challan in widget.challans) {
        for (int i = 0; i < challan.items.length; i++) {
          _selectedItems['${challan.id}-$i'] = value ?? false;
        }
      }
    });
  }

  bool _isAllSelected() {
    if (_selectedItems.isEmpty) return false;
    return _selectedItems.values.every((v) => v == true);
  }

  bool _isChallanSelected(LensSaleChallanModel challan) {
    if (challan.items.isEmpty) return false;
    bool allChecked = true;
    for (int i = 0; i < challan.items.length; i++) {
      if (_selectedItems['${challan.id}-$i'] != true) {
        allChecked = false;
        break;
      }
    }
    return allChecked;
  }

  @override
  Widget build(BuildContext context) {
    bool hasSelection = _selectedItems.values.any((v) => v == true);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: const Border(top: BorderSide(color: Color(0xFF10B981), width: 6)),
        ),
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: widget.challans.isEmpty
                  ? const Center(child: Text('No pending challans found', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: widget.challans.length,
                      itemBuilder: (context, index) {
                        return _buildChallanCard(widget.challans[index]);
                      },
                    ),
            ),
            _buildFooter(hasSelection),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: _isAllSelected(),
                    onChanged: _toggleAll,
                    activeColor: const Color(0xFF10B981),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  const Text('ALL', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.grey)),
                ],
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ACTIVE CHALLAN BACKLOG', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                  Row(
                    children: [
                      const Text('Pending items for: ', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                      Text(widget.partyName, style: const TextStyle(fontSize: 10, color: Color(0xFF10B981), fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(LucideIcons.x, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildChallanCard(LensSaleChallanModel challan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
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
                Row(
                  children: [
                    Checkbox(
                      value: _isChallanSelected(challan),
                      onChanged: (v) => _toggleChallan(challan, v),
                      activeColor: const Color(0xFF10B981),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('CHALLAN #${challan.billData.billNo}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        Text('DATED: ${challan.billData.date ?? '-'}', style: const TextStyle(fontSize: 9, color: Colors.grey, letterSpacing: 1, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                Text('₹ ${challan.netAmount.toStringAsFixed(2)}', style: const TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          ),
          // Items Table
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowHeight: 40,
              dataRowMinHeight: 40,
              dataRowMaxHeight: 40,
              headingTextStyle: const TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold),
              dataTextStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black87),
              horizontalMargin: 16,
              columnSpacing: 24,
              columns: const [
                DataColumn(label: Text('')),
                DataColumn(label: Text('ITEM NAME')),
                DataColumn(label: Text('ORDER NO')),
                DataColumn(label: Text('EYE')),
                DataColumn(label: Text('SPH')),
                DataColumn(label: Text('CYL')),
                DataColumn(label: Text('AXIS')),
                DataColumn(label: Text('ADD')),
                DataColumn(label: Text('QTY')),
                DataColumn(label: Text('PRICE')),
              ],
              rows: challan.items.asMap().entries.map((entry) {
                int index = entry.key;
                var item = entry.value;
                return DataRow(
                  cells: [
                    DataCell(
                      Checkbox(
                        value: _selectedItems['${challan.id}-$index'],
                        onChanged: (v) => _toggleItem(challan.id ?? '', index, v),
                        activeColor: const Color(0xFF10B981),
                      ),
                    ),
                    DataCell(Text(item.itemName.toUpperCase())),
                    DataCell(Text(item.orderNo)),
                    DataCell(Text(item.eye, style: const TextStyle(color: Color(0xFF2563EB)))),
                    DataCell(Text(item.sph.toString())),
                    DataCell(Text(item.cyl.toString())),
                    DataCell(Text(item.axis.toString())),
                    DataCell(Text(item.add.toString())),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: const Color(0xFFD1FAE5), borderRadius: BorderRadius.circular(4)),
                        child: Text('${item.qty} ${item.unit}', style: const TextStyle(color: Color(0xFF047857))),
                      ),
                    ),
                    DataCell(Text('₹ ${item.salePrice.toStringAsFixed(2)}', style: const TextStyle(color: Color(0xFF1D4ED8)))),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(bool hasSelection) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: Color(0xFFE2E8F0))),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, -2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('DISCARD', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: hasSelection ? () {
              List<Map<String, dynamic>> finalSelection = [];
              for (var challan in widget.challans) {
                for (int i = 0; i < challan.items.length; i++) {
                   if (_selectedItems['${challan.id}-$i'] == true) {
                      final map = challan.items[i].toJson();
                      map['sourceOrderId'] = challan.id; // Map challan ID as source
                      finalSelection.add(map);
                   }
                }
              }
              Navigator.pop(context, finalSelection);
            } : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF059669),
              foregroundColor: Colors.white,
              disabledBackgroundColor: const Color(0xFF6EE7B7),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('PULL SELECTED CHALLANS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
          ),
        ],
      ),
    );
  }
}
