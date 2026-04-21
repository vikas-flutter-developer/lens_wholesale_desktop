import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:io';
import 'package:excel/excel.dart' as xl;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';

import '../../data/providers/inventory_report_provider.dart';
import '../../data/models/inventory_report_models.dart';
import '../../../masters/data/providers/inventory_providers.dart';
import '../../../masters/data/providers/account_provider.dart';

// ─── Color constants matching React exactly ───────────────────────────────────
const _kBg = Color(0xFFF1F5F9); // slate-50
const _kCard = Colors.white;
const _kBorder = Color(0xFFF1F5F9); // slate-100
const _kSlate800 = Color(0xFF1E293B);
const _kSlate700 = Color(0xFF334155);
const _kSlate500 = Color(0xFF64748B);
const _kSlate400 = Color(0xFF94A3B8);
const _kSlate200 = Color(0xFFE2E8F0);
const _kSlate100 = Color(0xFFF1F5F9);
const _kSlate50 = Color(0xFFF8FAFC);
const _kBlue600 = Color(0xFF2563EB);
const _kBlue700 = Color(0xFF1D4ED8);
const _kBlue400 = Color(0xFF60A5FA);
const _kEmerald600 = Color(0xFF059669);
const _kEmerald400 = Color(0xFF34D399);
const _kFooter = Color(0xFF0F172A); // slate-900
const _kFooterMid = Color(0xFF1E293B); // slate-800

class PowerMovementReportPage extends StatefulWidget {
  const PowerMovementReportPage({super.key});

  @override
  State<PowerMovementReportPage> createState() =>
      _PowerMovementReportPageState();
}

class _PowerMovementReportPageState extends State<PowerMovementReportPage> {
  // ─── Scroll controllers ──────────────────────────────────────────────────────
  final ScrollController _tableHScroll = ScrollController();
  final ScrollController _tableVScroll = ScrollController();

  // ─── Default date range: start → end of current month ───────────────────────
  late DateTime _fromDate;
  late DateTime _toDate;

  // ─── Filter state ────────────────────────────────────────────────────────────
  List<String> _selectedItems = [];
  String _powerGroup = '';
  String _movementType = 'All';
  String _vendorName = '';
  String _groupName = '';

  // ─── Power Groups for selected item ─────────────────────────────────────────
  List<Map<String, dynamic>> _powerGroupsForItem = [];
  bool _loadingPowerGroups = false;

  // ─── Vendor dropdown ─────────────────────────────────────────────────────────
  bool _showVendorDropdown = false;
  String _vendorSearchText = '';
  final _vendorFocusNode = FocusNode();
  final _vendorController = TextEditingController();

  // ─── Item dropdown ───────────────────────────────────────────────────────────
  bool _showItemDropdown = false;
  String _itemSearchText = '';

  // ─── Layer Links for Overlay Positioning ─────────────────────────────────────
  final LayerLink _itemLink = LayerLink();
  final LayerLink _vendorLink = LayerLink();
  final LayerLink _columnLink = LayerLink();
  final LayerLink _groupLink = LayerLink();

  // ─── Group Name dropdown ─────────────────────────────────────────────────────
  bool _showGroupDropdown = false;
  final _groupFocusNode = FocusNode();
  final _groupController = TextEditingController();

  // ─── Table state ─────────────────────────────────────────────────────────────
  String _searchTerm = '';
  String _sortKey = 'totalQty';
  bool _sortAscending = false; // default: qty desc
  int _currentPage = 1;
  int _pageSize = 25;
  bool _showColumnPanel = false;
  final _columnBtnKey = GlobalKey();

  // ─── Column visibility (matches React columns state exactly) ─────────────────
  final Map<String, bool> _cols = {
    'sno': true,
    'eye': true,
    'sph': true,
    'cyl': true,
    'axis': true,
    'add': true,
    'lensPower': true, // group toggle for eye+sph+cyl+axis+add
    'itemName': true,
    'totalOrders': true,
    'totalQty': true,
    'totalRevenue': true,
    'avgPrice': true,
    'lastSoldDate': true,
    'movementStatus': true,
  };

  // ─── Matrix modal state ──────────────────────────────────────────────────────
  bool _showMatrix = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _fromDate = DateTime(now.year, now.month, 1);
    _toDate = DateTime(now.year, now.month + 1, 0);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountProvider>().fetchAllAccounts();
      context.read<ItemGroupProvider>().fetchGroups();
      context.read<ItemMasterProvider>().fetchItems();
      _handleSearch(); // auto-fetch on mount like React
    });
  }

  @override
  void dispose() {
    _vendorFocusNode.dispose();
    _vendorController.dispose();
    _tableHScroll.dispose();
    _tableVScroll.dispose();
    super.dispose();
  }

  void _handleSearch() {
    _currentPage = 1;
    final filters = {
      'dateFrom': DateFormat('yyyy-MM-dd').format(_fromDate),
      'dateTo': DateFormat('yyyy-MM-dd').format(_toDate),
      'itemName': _selectedItems,
      'powerGroup': _powerGroup,
      'movementType': _movementType,
      'vendorPartyName': _vendorName,
      'groupName': _groupName,
    };
    context.read<InventoryReportProvider>().fetchPowerMovementReport(filters);
  }

  void _handleReset() {
    final now = DateTime.now();
    setState(() {
      _fromDate = DateTime(now.year, now.month, 1);
      _toDate = DateTime(now.year, now.month + 1, 0);
      _selectedItems = [];
      _powerGroup = '';
      _movementType = 'All';
      _vendorName = '';
      _vendorSearchText = '';
      _vendorController.clear();
      _groupName = '';
      _powerGroupsForItem = [];
      _searchTerm = '';
      _currentPage = 1;
    });
  }

  Future<void> _handleItemSelect(String itemName, bool isChecked) async {
    setState(() {
      if (isChecked) {
        if (!_selectedItems.contains(itemName)) _selectedItems.add(itemName);
      } else {
        _selectedItems.remove(itemName);
      }
      _powerGroup = '';
    });
    if (_selectedItems.length == 1) {
      setState(() => _loadingPowerGroups = true);
      try {
        final groups = await context
            .read<LensGroupProvider>()
            .getPowerGroupsForProduct(_selectedItems[0]);
        setState(() => _powerGroupsForItem = groups);
      } catch (_) {
        setState(() => _powerGroupsForItem = []);
      } finally {
        setState(() => _loadingPowerGroups = false);
      }
    } else {
      setState(() => _powerGroupsForItem = []);
    }
  }

  List<PowerMovementItem> _applyFiltersAndSort(List<PowerMovementItem> data) {
    var result = [...data];

    // Power Group filter (client-side)
    if (_powerGroup.isNotEmpty && _powerGroupsForItem.isNotEmpty) {
      final pg = _powerGroupsForItem.firstWhere(
        (g) => (g['label'] ?? '') == _powerGroup,
        orElse: () => {},
      );
      if (pg.isNotEmpty) {
        final sphMin = double.tryParse(pg['sphMin'].toString()) ?? 0;
        final sphMax = double.tryParse(pg['sphMax'].toString()) ?? 0;
        final cylMin = double.tryParse(pg['cylMin'].toString()) ?? 0;
        final cylMax = double.tryParse(pg['cylMax'].toString()) ?? 0;
        result = result.where((item) {
          return item.sph >= sphMin &&
              item.sph <= sphMax &&
              item.cyl >= cylMin &&
              item.cyl <= cylMax;
        }).toList();
      }
    }

    // Quick search
    if (_searchTerm.isNotEmpty) {
      final q = _searchTerm.toLowerCase();
      result = result.where((item) {
        return item.itemName.toLowerCase().contains(q) ||
            item.eye.toLowerCase().contains(q) ||
            item.sph.toString().contains(q) ||
            item.cyl.toString().contains(q) ||
            item.movementStatus.toLowerCase().contains(q);
      }).toList();
    }

    // Sort
    result.sort((a, b) {
      dynamic va, vb;
      switch (_sortKey) {
        case 'sph':
          va = a.sph;
          vb = b.sph;
          break;
        case 'cyl':
          va = a.cyl;
          vb = b.cyl;
          break;
        case 'totalRevenue':
          va = a.totalRevenue;
          vb = b.totalRevenue;
          break;
        default:
          va = a.totalQty;
          vb = b.totalQty;
      }
      final cmp = Comparable.compare(va as Comparable, vb as Comparable);
      return _sortAscending ? cmp : -cmp;
    });

    return result;
  }

  void _toggleSort(String key) {
    setState(() {
      if (_sortKey == key) {
        _sortAscending = !_sortAscending;
      } else {
        _sortKey = key;
        _sortAscending = false;
      }
      _currentPage = 1;
    });
  }

  Future<void> _exportToExcel(List<PowerMovementItem> data) async {
    if (data.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No data to export')));
      return;
    }

    try {
      var excel = xl.Excel.createExcel();
      xl.Sheet sheetObject = excel['PowerMovementReport'];
      
      // Header
      List<xl.CellValue> headers = [];
      if (_cols['sno']!) headers.add(xl.TextCellValue('SR. NO.'));
      if (_cols['eye']!) headers.add(xl.TextCellValue('EYE'));
      if (_cols['sph']!) headers.add(xl.TextCellValue('SPH'));
      if (_cols['cyl']!) headers.add(xl.TextCellValue('CYL'));
      if (_cols['axis']!) headers.add(xl.TextCellValue('AXIS'));
      if (_cols['add']!) headers.add(xl.TextCellValue('ADD'));
      if (_cols['itemName']!) headers.add(xl.TextCellValue('ITEM NAME'));
      if (_cols['totalOrders']!) headers.add(xl.TextCellValue('ORDERS'));
      if (_cols['totalQty']!) headers.add(xl.TextCellValue('QUANTITY'));
      if (_cols['totalRevenue']!) headers.add(xl.TextCellValue('REVENUE'));
      if (_cols['avgPrice']!) headers.add(xl.TextCellValue('AVG PRICE'));
      if (_cols['lastSoldDate']!) headers.add(xl.TextCellValue('LAST SOLD'));
      if (_cols['movementStatus']!) headers.add(xl.TextCellValue('STATUS'));
      
      sheetObject.appendRow(headers);

      // Data
      for (int i = 0; i < data.length; i++) {
        final item = data[i];
        List<xl.CellValue> row = [];
        if (_cols['sno']!) row.add(xl.IntCellValue(i + 1));
        if (_cols['eye']!) row.add(xl.TextCellValue(item.eye));
        if (_cols['sph']!) row.add(xl.DoubleCellValue(item.sph));
        if (_cols['cyl']!) row.add(xl.DoubleCellValue(item.cyl));
        if (_cols['axis']!) row.add(xl.IntCellValue(item.axis));
        if (_cols['add']!) row.add(xl.DoubleCellValue(item.add));
        if (_cols['itemName']!) row.add(xl.TextCellValue(item.itemName));
        if (_cols['totalOrders']!) row.add(xl.IntCellValue(item.orderCount));
        if (_cols['totalQty']!) row.add(xl.IntCellValue(item.totalQty));
        if (_cols['totalRevenue']!) row.add(xl.DoubleCellValue(item.totalRevenue));
        if (_cols['avgPrice']!) row.add(xl.DoubleCellValue(item.avgPrice));
        if (_cols['lastSoldDate']!) row.add(xl.TextCellValue(item.lastSoldDate ?? '-'));
        if (_cols['movementStatus']!) row.add(xl.TextCellValue(item.movementStatus));
        sheetObject.appendRow(row);
      }

      String? outputFile = await FilePicker.saveFile(
        dialogTitle: 'Save Excel File',
        fileName: 'PowerMovementReport.xlsx',
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );

      if (outputFile != null) {
        final bytes = excel.encode();
        if (bytes != null) {
          File(outputFile).writeAsBytesSync(bytes);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Excel exported successfully!')));
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error exporting excel: $e')));
      }
    }
  }

  Future<void> _printReport(List<PowerMovementItem> data) async {
    if (data.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No data to print')));
      return;
    }

    final pdf = pw.Document();
    
    List<String> headers = [];
    if (_cols['sno']!) headers.add('SR. NO.');
    if (_cols['eye']!) headers.add('EYE');
    if (_cols['sph']!) headers.add('SPH');
    if (_cols['cyl']!) headers.add('CYL');
    if (_cols['axis']!) headers.add('AXIS');
    if (_cols['add']!) headers.add('ADD');
    if (_cols['itemName']!) headers.add('ITEM NAME');
    if (_cols['totalOrders']!) headers.add('ORDERS');
    if (_cols['totalQty']!) headers.add('QTY');
    if (_cols['totalRevenue']!) headers.add('REVENUE');
    if (_cols['avgPrice']!) headers.add('AVG PRICE');
    if (_cols['lastSoldDate']!) headers.add('LAST SOLD');
    if (_cols['movementStatus']!) headers.add('STATUS');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Power Movement Report', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                  pw.Text(DateFormat('dd-MMM-yyyy').format(DateTime.now()), style: const pw.TextStyle(fontSize: 10)),
                ],
              ),
            ),
            pw.SizedBox(height: 10),
            pw.TableHelper.fromTextArray(
              headers: headers,
              data: data.asMap().entries.map((entry) {
                final i = entry.key;
                final item = entry.value;
                List<String> row = [];
                if (_cols['sno']!) row.add('${i + 1}');
                if (_cols['eye']!) row.add(item.eye);
                if (_cols['sph']!) row.add(item.sph.toStringAsFixed(2));
                if (_cols['cyl']!) row.add(item.cyl.toStringAsFixed(2));
                if (_cols['axis']!) row.add('${item.axis}');
                if (_cols['add']!) row.add(item.add.toStringAsFixed(2));
                if (_cols['itemName']!) row.add(item.itemName);
                if (_cols['totalOrders']!) row.add('${item.orderCount}');
                if (_cols['totalQty']!) row.add('${item.totalQty}');
                if (_cols['totalRevenue']!) row.add(item.totalRevenue.toStringAsFixed(2));
                if (_cols['avgPrice']!) row.add(item.avgPrice.toStringAsFixed(2));
                if (_cols['lastSoldDate']!) row.add(item.lastSoldDate ?? '-');
                if (_cols['movementStatus']!) row.add(item.movementStatus);
                return row;
              }).toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
              cellStyle: const pw.TextStyle(fontSize: 7),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  // ─── Build ────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: Consumer<InventoryReportProvider>(
        builder: (context, provider, _) {
          final allData = provider.powerMovementData?.data ?? [];
          final analytics = provider.powerMovementData?.analytics;
          final filtered = _applyFiltersAndSort(allData);
          final totalPages = (filtered.length / _pageSize).ceil();
          final start = (_currentPage - 1) * _pageSize;
          final paginated = filtered.skip(start).take(_pageSize).toList();

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _buildHeader(provider.isLoading, analytics, filtered),
                    const SizedBox(height: 24),
                    _buildAnalyticsCards(analytics),
                    const SizedBox(height: 24),
                    _buildFiltersCard(provider),
                    const SizedBox(height: 24),
                    _buildTableCard(
                      provider,
                      paginated,
                      filtered,
                      totalPages,
                      analytics,
                    ),
                  ],
                ),
              ),
              // Glass pane to close menus on outside click + prevent dual open panels
              if (_showItemDropdown ||
                  _showVendorDropdown ||
                  _showGroupDropdown ||
                  _showColumnPanel)
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapDown: (_) {
                      setState(() {
                        _showItemDropdown = false;
                        _showVendorDropdown = false;
                        _showGroupDropdown = false;
                        _showColumnPanel = false;
                      });
                    },
                    child: Container(color: Colors.transparent),
                  ),
                ),
              if (_showItemDropdown)
                CompositedTransformFollower(
                  link: _itemLink,
                  showWhenUnlinked: false,
                  offset: const Offset(0, 46),
                  child: _buildItemDropdownPanel(),
                ),
              if (_showVendorDropdown)
                CompositedTransformFollower(
                  link: _vendorLink,
                  showWhenUnlinked: false,
                  offset: const Offset(0, 46),
                  child: SizedBox(
                    width:
                        MediaQuery.of(context).size.width *
                        0.25, // Appx flexible width
                    child: _buildVendorDropdownPanel(),
                  ),
                ),
              if (_showGroupDropdown)
                CompositedTransformFollower(
                  link: _groupLink,
                  showWhenUnlinked: false,
                  offset: const Offset(0, 46),
                  child: SizedBox(
                    width:
                        MediaQuery.of(context).size.width *
                        0.22, // Appx flexible width
                    child: _buildGroupDropdownPanel(),
                  ),
                ),
              if (_showColumnPanel)
                CompositedTransformFollower(
                  link: _columnLink,
                  showWhenUnlinked: false,
                  offset: const Offset(-160, 42), // Align right roughly
                  child: _buildColumnPanel(),
                ),
              if (_showMatrix)
                _PowerMatrixModal(
                  initialFilters: {
                    'dateFrom': DateFormat('yyyy-MM-dd').format(_fromDate),
                    'dateTo': DateFormat('yyyy-MM-dd').format(_toDate),
                    'itemName': _selectedItems,
                    'groupName': _groupName,
                  },
                  onClose: () => setState(() => _showMatrix = false),
                ),
            ],
          );
        },
      ),
    );
  }

  // ─── Header ───────────────────────────────────────────────────────────────────
  Widget _buildHeader(bool loading, PowerMovementAnalytics? analytics, List<PowerMovementItem> filteredData) {
    return Container(
      color: _kBg,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(LucideIcons.zap, color: Color(0xFFD97706), size: 28),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Power Movement Report',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: _kSlate800,
                ),
              ),
              const Text(
                'Analyze power-wise delivery and sales performance',
                style: TextStyle(fontSize: 13, color: _kSlate500),
              ),
            ],
          ),
          const Spacer(),
          // Print button
          _headerBtn(
            label: 'Print',
            icon: LucideIcons.printer,
            bg: Colors.white,
            fg: _kSlate700,
            border: _kSlate200,
            onTap: () => _printReport(filteredData),
          ),
          const SizedBox(width: 8),
          // Export Excel button
          _headerBtn(
            label: 'Export Excel',
            icon: LucideIcons.fileSpreadsheet,
            bg: _kEmerald600,
            fg: Colors.white,
            onTap: () => _exportToExcel(filteredData),
          ),
          const SizedBox(width: 8),
          // Power Matrix button
          _headerBtn(
            label: 'Power Matrix',
            icon: LucideIcons.layoutGrid,
            bg: _kBlue600,
            fg: Colors.white,
            onTap: () => setState(() => _showMatrix = true),
          ),
        ],
      ),
    );
  }

  Widget _headerBtn({
    required String label,
    required IconData icon,
    required Color bg,
    required Color fg,
    Color? border,
    required VoidCallback onTap,
  }) {
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(8),
      elevation: border == null ? 2 : 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: border != null ? Border.all(color: border) : null,
          ),
          child: Row(
            children: [
              Icon(icon, size: 15, color: fg),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: fg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Analytics Cards ──────────────────────────────────────────────────────────
  Widget _buildAnalyticsCards(PowerMovementAnalytics? analytics) {
    final topFast = analytics?.topFastMoving?.isNotEmpty == true
        ? analytics!.topFastMoving!.first
        : null;
    final highRev = analytics?.highestRevenue;
    final mostSold = analytics?.mostSoldItem ?? 'N/A';
    final totalQty = analytics?.totalSummary?.totalQty ?? 0;
    final totalRev = analytics?.totalSummary?.totalRevenue ?? 0;

    return Row(
      children: [
        Expanded(
          child: _analyticsCard(
            title: 'TOP FAST MOVING POWER',
            value: topFast != null
                ? '${topFast.sph.toStringAsFixed(2)} / ${topFast.cyl.toStringAsFixed(2)}'
                : 'N/A',
            subText: topFast != null ? '${topFast.totalQty} Qty Sold' : '',
            icon: LucideIcons.zap,
            iconBg: const Color(0xFFFEF3C7),
            iconFg: const Color(0xFFD97706),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _analyticsCard(
            title: 'HIGHEST REVENUE POWER',
            value: highRev != null
                ? '₹${highRev.totalRevenue.toStringAsFixed(1)}'
                : 'N/A',
            subText: highRev != null
                ? '${highRev.sph.toStringAsFixed(2)}/${highRev.cyl.toStringAsFixed(2)}'
                : '',
            icon: LucideIcons.dollarSign,
            iconBg: const Color(0xFFDBEAFE),
            iconFg: _kBlue600,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _analyticsCard(
            title: 'MOST SOLD ITEM',
            value: mostSold,
            subText: '',
            icon: LucideIcons.package,
            iconBg: const Color(0xFFEDE9FE),
            iconFg: const Color(0xFF7C3AED),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _analyticsCard(
            title: 'TOTAL SUMMARY',
            value: '₹${totalRev.toStringAsFixed(1)}',
            subText: '$totalQty Total Units',
            icon: LucideIcons.layoutGrid,
            iconBg: _kSlate100,
            iconFg: _kSlate500,
          ),
        ),
      ],
    );
  }

  Widget _analyticsCard({
    required String title,
    required String value,
    required String subText,
    required IconData icon,
    required Color iconBg,
    required Color iconFg,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _kBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: _kSlate500,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: _kSlate800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subText.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    subText,
                    style: const TextStyle(fontSize: 10, color: _kSlate400),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: iconFg),
          ),
        ],
      ),
    );
  }

  // ─── Filters Card ─────────────────────────────────────────────────────────────
  Widget _buildFiltersCard(InventoryReportProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kBorder),
        boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: const [
              Icon(LucideIcons.filter, size: 15, color: _kBlue600),
              SizedBox(width: 6),
              Text(
                'FILTERS & PARAMETERS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: _kSlate700,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const Divider(height: 16, color: _kSlate200),
          // Row 1
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Date Range
              Expanded(
                flex: 3,
                child: _filterLabel(
                  'DATE RANGE',
                  Row(
                    children: [
                      Expanded(
                        child: _datePicker(
                          _fromDate,
                          (d) => setState(() => _fromDate = d),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        child: Text(
                          'to',
                          style: TextStyle(
                            color: _kSlate400,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: _datePicker(
                          _toDate,
                          (d) => setState(() => _toDate = d),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Item Name multi-select
              Expanded(
                flex: 2,
                child: _filterLabel('ITEM NAME', _buildItemDropdown()),
              ),
              const SizedBox(width: 12),
              // Power Group
              Expanded(
                flex: 3,
                child: _filterLabel(
                  _loadingPowerGroups
                      ? 'POWER GROUP  Loading...'
                      : 'POWER GROUP',
                  _buildPowerGroupDropdown(),
                ),
              ),
              const SizedBox(width: 12),
              // Vendor / Party
              Expanded(
                flex: 4,
                child: _filterLabel('VENDOR / PARTY', _buildVendorField()),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Row 2
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Movement Status
              Expanded(
                flex: 2,
                child: _filterLabel(
                  'MOVEMENT STATUS',
                  _buildMovementDropdown(),
                ),
              ),
              const SizedBox(width: 12),
              // Group Name
              Expanded(
                flex: 3,
                child: _filterLabel('GROUP NAME', _buildGroupField()),
              ),
              const SizedBox(width: 12),
              // Buttons
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 42,
                        child: ElevatedButton.icon(
                          onPressed: provider.isLoading ? null : _handleSearch,
                          icon: const Icon(LucideIcons.search, size: 15),
                          label: Text(
                            provider.isLoading ? 'Processing...' : 'Search',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _kBlue600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Reset button
                    SizedBox(
                      width: 42,
                      height: 42,
                      child: Material(
                        color: _kSlate100,
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: _handleReset,
                          child: const Center(
                            child: Icon(
                              LucideIcons.rotateCcw,
                              size: 15,
                              color: _kSlate500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Remaining empty space to match React's 12-column grid structure
              const Expanded(flex: 5, child: SizedBox()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _filterLabel(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w900,
            color: _kSlate400,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 5),
        child,
      ],
    );
  }

  Widget _datePicker(DateTime date, Function(DateTime) onPicked) {
    return GestureDetector(
      onTap: () async {
        final d = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (d != null) onPicked(d);
      },
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: _kSlate50,
          border: Border.all(color: _kSlate200),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                DateFormat('dd-MM-yyyy').format(date),
                style: const TextStyle(fontSize: 12, color: _kSlate800),
              ),
            ),
            const Icon(LucideIcons.calendar, size: 13, color: _kSlate400),
          ],
        ),
      ),
    );
  }

  Widget _buildItemDropdown() {
    final label = _selectedItems.isEmpty
        ? 'Select items...'
        : _selectedItems.length > 2
        ? '${_selectedItems.length} items selected'
        : _selectedItems.join(', ');

    return CompositedTransformTarget(
      link: _itemLink,
      child: GestureDetector(
        onTap: () => setState(() => _showItemDropdown = !_showItemDropdown),
        child: Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: _kSlate50,
            border: Border.all(
              color: _showItemDropdown ? _kBlue600 : _kSlate200,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: _kSlate800),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(LucideIcons.chevronDown, size: 14, color: _kSlate400),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemDropdownPanel() {
    return Consumer<ItemMasterProvider>(
      builder: (context, itemProvider, _) {
        final allItems = itemProvider.items;
        final filteredItems = allItems
            .where(
              (it) => it.itemName.toLowerCase().contains(
                _itemSearchText.toLowerCase(),
              ),
            )
            .toList();

        return Material(
          elevation: 20,
          borderRadius: BorderRadius.circular(12),
          color: Colors.transparent, // Important so shadow looks right
          child: Container(
            width: 240,
            constraints: const BoxConstraints(maxHeight: 260),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _kSlate200),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1F000000),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
                  child: TextField(
                    style: const TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      hintText: 'Search here...',
                      hintStyle: const TextStyle(
                        fontSize: 12,
                        color: _kSlate400,
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: _kSlate200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: _kSlate200),
                      ),
                      filled: true,
                      fillColor: _kSlate50,
                    ),
                    onChanged: (v) => setState(() => _itemSearchText = v),
                  ),
                ),
                const Divider(height: 1, color: _kSlate200),
                Flexible(
                  child: filteredItems.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            'No items found',
                            style: TextStyle(
                              fontSize: 12,
                              color: _kSlate400,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: filteredItems.length,
                          itemBuilder: (ctx, i) {
                            final it = filteredItems[i];
                            final selected = _selectedItems.contains(
                              it.itemName,
                            );
                            return InkWell(
                              onTap: () =>
                                  _handleItemSelect(it.itemName, !selected),
                              child: Container(
                                color: selected
                                    ? _kSlate50
                                    : Colors.transparent,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: Checkbox(
                                        value: selected,
                                        onChanged: (v) => _handleItemSelect(
                                          it.itemName,
                                          v ?? false,
                                        ),
                                        activeColor: _kBlue600,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        it.itemName,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: _kSlate700,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
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
        );
      },
    );
  }

  Widget _buildPowerGroupDropdown() {
    final disabled = _powerGroupsForItem.isEmpty;
    final hint = _selectedItems.isNotEmpty
        ? (disabled ? 'No groups found' : 'All Power Groups')
        : 'Select item first';

    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: disabled ? const Color(0xFFF8FAFC) : _kSlate50,
        border: Border.all(color: _kSlate200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _powerGroup.isEmpty ? null : _powerGroup,
          hint: Text(
            hint,
            style: TextStyle(
              fontSize: 12,
              color: disabled ? _kSlate400 : _kSlate800,
            ),
          ),
          isExpanded: true,
          isDense: true,
          icon: const Icon(
            LucideIcons.chevronDown,
            size: 14,
            color: _kSlate400,
          ),
          onChanged: disabled
              ? null
              : (v) => setState(() => _powerGroup = v ?? ''),
          items: [
            DropdownMenuItem(
              value: '',
              child: Text(hint, style: const TextStyle(fontSize: 12)),
            ),
            ..._powerGroupsForItem.map((pg) {
              final lbl = (pg['label'] ?? '').toString();
              return DropdownMenuItem(
                value: lbl,
                child: Text(lbl, style: const TextStyle(fontSize: 12)),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildVendorField() {
    return CompositedTransformTarget(
      link: _vendorLink,
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: _kSlate50,
          border: Border.all(color: _kSlate200),
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextField(
          controller: _vendorController,
          focusNode: _vendorFocusNode,
          style: const TextStyle(fontSize: 12),
          decoration: InputDecoration(
            hintText: 'Search vendor or party...',
            hintStyle: const TextStyle(fontSize: 12, color: _kSlate400),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 12,
            ),
            suffixIcon: _vendorName.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        _vendorName = '';
                        _vendorSearchText = '';
                        _vendorController.clear();
                        _showVendorDropdown = false;
                      });
                    },
                    child: const Icon(
                      LucideIcons.x,
                      size: 14,
                      color: _kSlate400,
                    ),
                  )
                : null,
          ),
          onTap: () => setState(() {
            _vendorSearchText = _vendorName;
            _showVendorDropdown = true;
          }),
          onChanged: (v) => setState(() {
            _vendorSearchText = v;
            _showVendorDropdown = true;
            if (v.isEmpty) _vendorName = '';
          }),
        ),
      ),
    );
  }

  Widget _buildVendorDropdownPanel() {
    return Consumer<AccountProvider>(
      builder: (context, acctProvider, _) {
        final parties = acctProvider.accounts;
        final filtered = parties
            .where(
              (p) => p.name.toLowerCase().contains(
                _vendorSearchText.toLowerCase(),
              ),
            )
            .take(80)
            .toList();

        if (filtered.isEmpty) return const SizedBox.shrink();

        return Material(
          elevation: 20,
          borderRadius: BorderRadius.circular(12),
          color: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxHeight: 220),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _kSlate200),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1F000000),
                  blurRadius: 16,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: filtered.length,
              itemBuilder: (ctx, i) {
                final p = filtered[i];
                return InkWell(
                  onTap: () {
                    setState(() {
                      _vendorName = p.name;
                      _vendorController.text = p.name;
                      _vendorSearchText = p.name;
                      _showVendorDropdown = false;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFF8FAFC)),
                      ),
                    ),
                    child: Text(
                      p.name ?? '',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _kSlate700,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildMovementDropdown() {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: _kSlate50,
        border: Border.all(color: _kSlate200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _movementType,
          isExpanded: true,
          isDense: true,
          icon: const Icon(
            LucideIcons.chevronDown,
            size: 14,
            color: _kSlate400,
          ),
          onChanged: (v) => setState(() => _movementType = v ?? 'All'),
          items: const [
            DropdownMenuItem(
              value: 'All',
              child: Text('All Movements', style: TextStyle(fontSize: 12)),
            ),
            DropdownMenuItem(
              value: 'Fast Moving',
              child: Text('Fast Moving', style: TextStyle(fontSize: 12)),
            ),
            DropdownMenuItem(
              value: 'Medium Moving',
              child: Text('Medium Moving', style: TextStyle(fontSize: 12)),
            ),
            DropdownMenuItem(
              value: 'Slow Moving',
              child: Text('Slow Moving', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupField() {
    return CompositedTransformTarget(
      link: _groupLink,
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: _kSlate50,
          border: Border.all(color: _kSlate200),
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextField(
          controller: _groupController,
          focusNode: _groupFocusNode,
          style: const TextStyle(fontSize: 12),
          decoration: InputDecoration(
            hintText: 'Search group...',
            hintStyle: const TextStyle(fontSize: 12, color: _kSlate400),
            border: InputBorder.none,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            suffixIcon: _groupName.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        _groupName = '';
                        _groupController.clear();
                        _showGroupDropdown = false;
                      });
                    },
                    child: const Icon(
                      LucideIcons.x,
                      size: 14,
                      color: _kSlate400,
                    ),
                  )
                : const Icon(
                    LucideIcons.chevronDown,
                    size: 14,
                    color: _kSlate400,
                  ),
          ),
          onTap: () => setState(() => _showGroupDropdown = true),
          onChanged: (v) => setState(() {
            _groupName = v;
            _showGroupDropdown = true;
          }),
        ),
      ),
    );
  }

  Widget _buildGroupDropdownPanel() {
    return Consumer<ItemGroupProvider>(
      builder: (context, grpProvider, _) {
        final groups = grpProvider.groups;
        final filtered = groups
            .where(
              (g) => (g.groupName ?? '').toLowerCase().contains(
                _groupName.toLowerCase(),
              ),
            )
            .toList();

        if (filtered.isEmpty) return const SizedBox.shrink();

        return Material(
          elevation: 20,
          borderRadius: BorderRadius.circular(12),
          color: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxHeight: 220),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _kSlate200),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1F000000),
                  blurRadius: 16,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: filtered.length,
              itemBuilder: (ctx, i) {
                final g = filtered[i];
                final name = g.groupName ?? '';
                return InkWell(
                  onTap: () {
                    setState(() {
                      _groupName = name;
                      _groupController.text = name;
                      _showGroupDropdown = false;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFF8FAFC)),
                      ),
                    ),
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _kSlate700,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  // ─── Table Card ───────────────────────────────────────────────────────────────
  Widget _buildTableCard(
    InventoryReportProvider provider,
    List<PowerMovementItem> paginated,
    List<PowerMovementItem> filtered,
    int totalPages,
    PowerMovementAnalytics? analytics,
  ) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kBorder),
        boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 6)],
      ),
      child: Column(
        children: [
          // Controls bar
          _buildTableControls(),
          const Divider(height: 1, color: _kSlate100),
          // Table
          provider.isLoading
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(color: _kBlue600),
                  ),
                )
              : paginated.isEmpty
              ? _buildEmptyState()
              : _buildTable(paginated),
          // Footer
          _buildFooterBar(analytics, filtered.length, totalPages),
        ],
      ),
    );
  }

  Widget _buildTableControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Quick search
          Container(
            width: 300,
            height: 36,
            decoration: BoxDecoration(
              color: _kSlate50,
              border: Border.all(color: _kSlate200),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              style: const TextStyle(fontSize: 12),
              decoration: const InputDecoration(
                hintText: 'Quick search power, status or item...',
                hintStyle: TextStyle(fontSize: 12, color: _kSlate400),
                prefixIcon: Icon(
                  LucideIcons.search,
                  size: 15,
                  color: _kSlate400,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 9),
              ),
              onChanged: (v) => setState(() {
                _searchTerm = v;
                _currentPage = 1;
              }),
            ),
          ),
          const Spacer(),
          // Columns button
          _buildColumnToggleBtn(),
        ],
      ),
    );
  }

  Widget _buildColumnToggleBtn() {
    return CompositedTransformTarget(
      link: _columnLink,
      child: Material(
        key: _columnBtnKey,
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => setState(() => _showColumnPanel = !_showColumnPanel),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: _kSlate200),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(LucideIcons.layoutGrid, size: 14, color: _kSlate700),
                SizedBox(width: 6),
                Text(
                  'Columns',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _kSlate700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColumnPanel() {
    // Show only grouped columns (not eye/sph/cyl/axis/add individually — they're under "lensPower")
    final panelCols = _cols.keys
        .where((k) => !['eye', 'sph', 'cyl', 'axis', 'add'].contains(k))
        .toList();

    final labels = {
      'sno': 'Sr No',
      'lensPower': 'Lens Power (Eye/SPH/CYL/AXIS/ADD)',
      'itemName': 'Item Name',
      'totalOrders': 'Orders',
      'totalQty': 'Quantity',
      'totalRevenue': 'Revenue',
      'avgPrice': 'Avg Price',
      'lastSoldDate': 'Last Sold',
      'movementStatus': 'Status',
    };

    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 260,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _kSlate200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Text(
                  'VISIBLE COLUMNS',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: _kSlate400,
                    letterSpacing: 0.8,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => setState(() => _showColumnPanel = false),
                  child: const Icon(LucideIcons.x, size: 14, color: _kSlate400),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...panelCols.map((col) {
              final checked = col == 'lensPower'
                  ? (_cols['eye'] ?? true)
                  : (_cols[col] ?? true);
              return InkWell(
                onTap: () {
                  setState(() {
                    if (col == 'lensPower') {
                      final next = !checked;
                      _cols['eye'] = next;
                      _cols['sph'] = next;
                      _cols['cyl'] = next;
                      _cols['axis'] = next;
                      _cols['add'] = next;
                      _cols['lensPower'] = next;
                    } else {
                      _cols[col] = !(_cols[col] ?? true);
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: Checkbox(
                          value: checked,
                          onChanged: (v) {
                            setState(() {
                              if (col == 'lensPower') {
                                final next = v ?? true;
                                _cols['eye'] = next;
                                _cols['sph'] = next;
                                _cols['cyl'] = next;
                                _cols['axis'] = next;
                                _cols['add'] = next;
                                _cols['lensPower'] = next;
                              } else {
                                _cols[col] = v ?? true;
                              }
                            });
                          },
                          activeColor: _kBlue600,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          labels[col] ?? col,
                          style: const TextStyle(
                            fontSize: 12,
                            color: _kSlate700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
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
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: _kSlate50,
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.search, size: 40, color: _kSlate200),
          ),
          const SizedBox(height: 12),
          const Text(
            'No power combinations matching your criteria',
            style: TextStyle(
              color: _kSlate400,
              fontStyle: FontStyle.italic,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(List<PowerMovementItem> rows) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scrollbar(
          controller: _tableHScroll,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _tableHScroll,
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: DataTable(
                columnSpacing: 0,
                headingRowHeight: 44,
                dataRowMinHeight: 40,
                dataRowMaxHeight: 48,
                headingRowColor: WidgetStateProperty.all(_kSlate50),
                border: const TableBorder(
                  horizontalInside: BorderSide(color: _kSlate100, width: 1),
                  verticalInside: BorderSide(color: _kSlate200, width: 0.5),
                  bottom: BorderSide(color: _kSlate200),
                ),
                columns: [
                  if (_cols['sno']!) _col('SR. NO.'),
                  if (_cols['eye']!) _col('EYE'),
                  if (_cols['sph']!) _sortableCol('SPH', 'sph'),
                  if (_cols['cyl']!) _sortableCol('CYL', 'cyl'),
                  if (_cols['axis']!) _col('AXIS'),
                  if (_cols['add']!) _col('ADD'),
                  if (_cols['itemName']!)
                    _col('ITEM NAME', minWidth: 200, left: true),
                  if (_cols['totalOrders']!) _col('ORDERS'),
                  if (_cols['totalQty']!)
                    _sortableCol('QUANTITY', 'totalQty', highlight: true),
                  if (_cols['totalRevenue']!)
                    _sortableCol('REVENUE', 'totalRevenue'),
                  if (_cols['avgPrice']!) _col('AVG PRICE'),
                  if (_cols['lastSoldDate']!) _col('LAST SOLD'),
                  if (_cols['movementStatus']!) _col('STATUS'),
                ],
                rows: List.generate(rows.length, (i) {
                  final item = rows[i];
                  final isFast = item.movementStatus == 'Fast Moving';
                  return DataRow(
                    color: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.hovered))
                        return const Color(0xFFF8FAFC);
                      if (isFast) return const Color(0x05F59E0B); // amber-50/10
                      return Colors.transparent;
                    }),
                    cells: [
                      if (_cols['sno']!)
                        DataCell(
                          _cellText(
                            '${(_currentPage - 1) * _pageSize + i + 1}',
                            color: _kSlate400,
                          ),
                        ),
                      if (_cols['eye']!)
                        DataCell(
                          _cellText(item.eye, color: _kBlue600, bold: true),
                        ),
                      if (_cols['sph']!)
                        DataCell(_cellText(item.sph.toStringAsFixed(2))),
                      if (_cols['cyl']!)
                        DataCell(_cellText(item.cyl.toStringAsFixed(2))),
                      if (_cols['axis']!)
                        DataCell(_cellText(item.axis.toString())),
                      if (_cols['add']!)
                        DataCell(_cellText(item.add.toStringAsFixed(2))),
                      if (_cols['itemName']!)
                        DataCell(
                          SizedBox(
                            width: 200,
                            child: Text(
                              item.itemName,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: _kSlate800,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      if (_cols['totalOrders']!)
                        DataCell(
                          Center(child: _cellText(item.orderCount.toString())),
                        ),
                      if (_cols['totalQty']!)
                        DataCell(
                          Container(
                            width: double.infinity,
                            color: const Color(0x0A2563EB),
                            alignment: Alignment.center,
                            child: Text(
                              item.totalQty.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: _kBlue700,
                              ),
                            ),
                          ),
                        ),
                      if (_cols['totalRevenue']!)
                        DataCell(
                          Center(
                            child: _cellText(
                              '₹${item.totalRevenue.toStringAsFixed(2)}',
                            ),
                          ),
                        ),
                      if (_cols['avgPrice']!)
                        DataCell(
                          Center(
                            child: _cellText(
                              '₹${item.avgPrice.toStringAsFixed(2)}',
                              color: _kSlate500,
                            ),
                          ),
                        ),
                      if (_cols['lastSoldDate']!)
                        DataCell(
                          Center(
                            child: _cellText(
                              item.lastSoldDate != null
                                  ? DateFormat('d/M/yyyy').format(
                                      DateTime.tryParse(item.lastSoldDate!) ??
                                          DateTime.now(),
                                    )
                                  : '-',
                              color: _kSlate400,
                            ),
                          ),
                        ),
                      if (_cols['movementStatus']!)
                        DataCell(
                          Center(child: _statusBadge(item.movementStatus)),
                        ),
                    ],
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }

  DataColumn _col(String label, {double minWidth = 80, bool left = false}) {
    return DataColumn(
      label: Container(
        width: minWidth == 80 ? null : minWidth,
        alignment: left ? Alignment.centerLeft : Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: _kSlate500,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  DataColumn _sortableCol(String label, String key, {bool highlight = false}) {
    final isActive = _sortKey == key;
    final color = highlight ? _kBlue700 : (isActive ? _kBlue600 : _kSlate500);
    return DataColumn(
      label: InkWell(
        onTap: () => _toggleSort(key),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          color: highlight ? const Color(0x0B2563EB) : Colors.transparent,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: color,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 4),
              Icon(LucideIcons.arrowUpDown, size: 11, color: color),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cellText(String text, {Color? color, bool bold = false}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: bold ? FontWeight.w900 : FontWeight.w600,
        color: color ?? _kSlate700,
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color bg, fg, border;
    switch (status) {
      case 'Fast Moving':
        bg = const Color(0xFFD1FAE5);
        fg = const Color(0xFF065F46);
        border = const Color(0xFFA7F3D0);
        break;
      case 'Medium Moving':
        bg = const Color(0xFFDBEAFE);
        fg = _kBlue700;
        border = const Color(0xFFBFDBFE);
        break;
      default:
        bg = _kSlate100;
        fg = _kSlate500;
        border = _kSlate200;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w900,
          color: fg,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  // ─── Dark Footer Bar ──────────────────────────────────────────────────────────
  Widget _buildFooterBar(
    PowerMovementAnalytics? analytics,
    int totalItems,
    int totalPages,
  ) {
    final totalQty = analytics?.totalSummary?.totalQty ?? 0;
    final totalRev = analytics?.totalSummary?.totalRevenue ?? 0;
    final revenueStr = '₹${totalRev.toStringAsFixed(2)}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: const BoxDecoration(
        color: _kFooter,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          // Total Quantity
          Container(
            padding: const EdgeInsets.only(right: 24),
            decoration: const BoxDecoration(
              border: Border(right: BorderSide(color: Color(0xFF334155))),
            ),
            child: Row(
              children: [
                const Text(
                  'TOTAL QUANTITY',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: _kSlate400,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  totalQty.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: _kBlue400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          // Total Net Revenue
          Row(
            children: [
              const Text(
                'TOTAL NET REVENUE',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  color: _kSlate400,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                revenueStr,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: _kEmerald400,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Show per page
          const Text(
            'SHOW PER PAGE',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w900,
              color: _kSlate400,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: _kFooterMid,
              borderRadius: BorderRadius.circular(6),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: _pageSize,
                dropdownColor: _kFooterMid,
                iconEnabledColor: _kSlate400,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                onChanged: (v) => setState(() {
                  _pageSize = v ?? 25;
                  _currentPage = 1;
                }),
                items: const [
                  DropdownMenuItem(value: 10, child: Text('10')),
                  DropdownMenuItem(value: 25, child: Text('25')),
                  DropdownMenuItem(value: 50, child: Text('50')),
                  DropdownMenuItem(value: 100, child: Text('100')),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Prev
          _pageBtn('«', _currentPage > 1, () => setState(() => _currentPage--)),
          const SizedBox(width: 6),
          Text(
            'Page $_currentPage of ${totalPages == 0 ? 1 : totalPages}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 6),
          // Next
          _pageBtn(
            '»',
            _currentPage < totalPages,
            () => setState(() => _currentPage++),
          ),
        ],
      ),
    );
  }

  Widget _pageBtn(String label, bool enabled, VoidCallback onTap) {
    return Material(
      color: const Color(0xFF1E293B),
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: enabled ? onTap : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: enabled ? Colors.white : const Color(0xFF475569),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Power Matrix Modal ───────────────────────────────────────────────────────

class _PowerMatrixModal extends StatefulWidget {
  final Map<String, dynamic> initialFilters;
  final VoidCallback onClose;

  const _PowerMatrixModal({
    required this.initialFilters,
    required this.onClose,
  });

  @override
  State<_PowerMatrixModal> createState() => _PowerMatrixModalState();
}

class _PowerMatrixModalState extends State<_PowerMatrixModal> {
  late Map<String, dynamic> _filters;
  bool _loading = false;
  List<PowerMovementItem> _data = [];

  // matrix computed
  List<String> _powerRows = [];
  List<String> _addCols = [];
  Map<String, Map<String, dynamic>> _cellData = {};

  @override
  void initState() {
    super.initState();
    _filters = Map.from(widget.initialFilters);
    _filters['eye'] = 'R/L';
    _filters['axis'] = '';
    _filters['add'] = '';
    _fetchMatrix();
  }

  Future<void> _fetchMatrix() async {
    setState(() => _loading = true);
    try {
      final provider = context.read<InventoryReportProvider>();
      await provider.fetchPowerMovementReport(_filters);
      _data = provider.powerMovementData?.data ?? [];
      _buildMatrix();
    } catch (_) {
    } finally {
      setState(() => _loading = false);
    }
  }

  void _buildMatrix() {
    var filtered = [..._data];
    final eye = (_filters['eye'] ?? 'R/L').toString();
    final axis = (_filters['axis'] ?? '').toString();
    final add = (_filters['add'] ?? '').toString();

    if (eye != 'Both') filtered = filtered.where((i) => i.eye == eye).toList();
    if (axis.isNotEmpty)
      filtered = filtered.where((i) => i.axis.toString() == axis).toList();
    if (add.isNotEmpty) {
      filtered = filtered
          .where(
            (i) =>
                i.add.toStringAsFixed(2) ==
                double.tryParse(add)?.toStringAsFixed(2),
          )
          .toList();
    }

    final combos = <String>{};
    final adds = <String>{};
    final map = <String, Map<String, dynamic>>{};

    for (final item in filtered) {
      final s = item.sph.toStringAsFixed(2);
      final c = item.cyl.toStringAsFixed(2);
      final ax = item.axis;
      final ad = item.add.toStringAsFixed(2);
      final comboKey = '$s / $c / $ax';
      combos.add(comboKey);
      adds.add(ad);
      final cellKey = '${comboKey}_$ad';
      if (!map.containsKey(cellKey)) {
        map[cellKey] = {'qty': 0, 'status': item.movementStatus};
      }
      map[cellKey]!['qty'] = (map[cellKey]!['qty'] as int) + item.totalQty;
      if (item.movementStatus == 'Fast Moving')
        map[cellKey]!['status'] = 'Fast Moving';
    }

    final sortedCombos = combos.toList()
      ..sort((a, b) {
        final ap = a.split(' / ').map(double.parse).toList();
        final bp = b.split(' / ').map(double.parse).toList();
        if (bp[0] != ap[0]) return bp[0].compareTo(ap[0]);
        if (bp[1] != ap[1]) return bp[1].compareTo(ap[1]);
        return ap[2].compareTo(bp[2]);
      });
    final sortedAdds = adds.toList()
      ..sort((a, b) => double.parse(a).compareTo(double.parse(b)));

    setState(() {
      _powerRows = sortedCombos;
      _addCols = sortedAdds;
      _cellData = map;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0x99000000),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.92,
          height: MediaQuery.of(context).size.height * 0.90,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              // Modal header
              _buildModalHeader(),
              const Divider(height: 1, color: _kSlate200),
              // Modal filters
              _buildModalFilters(),
              const Divider(height: 1, color: _kSlate200),
              // Matrix content
              Expanded(child: _buildMatrixContent()),
              // Modal footer
              _buildModalFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModalHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _kBlue600.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(LucideIcons.layoutGrid, color: _kBlue600, size: 20),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Power Movement Matrix',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: _kSlate800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'MOVEMENT ANALYSIS: SPH/CYL/AXIS vs ADD',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: _kSlate400,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Legend
          _legendDot('Fast', const Color(0xFF10B981)),
          const SizedBox(width: 20),
          _legendDot('Medium', _kBlue600),
          const SizedBox(width: 20),
          _legendDot('Slow', _kSlate400),
          const SizedBox(width: 32),
          IconButton(
            onPressed: widget.onClose,
            hoverColor: _kSlate100,
            icon: const Icon(LucideIcons.x, color: _kSlate400, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _legendDot(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w900,
            color: _kSlate400,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }

  Widget _buildModalFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: Colors.white,
      child: Row(
        children: [
          _mfLabel('DATE FROM', _mfDatePicker('dateFrom')),
          const SizedBox(width: 12),
          _mfLabel('DATE TO', _mfDatePicker('dateTo')),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: _mfLabel('ITEM NAME', _mfItemDropdown()),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 1,
            child: _mfLabel('GROUP', _mfGroupDropdown()),
          ),
          const SizedBox(width: 12),
          SizedBox(width: 130, child: _mfLabel('EYE', _mfEyeDropdown())),
          const SizedBox(width: 16),
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: SizedBox(
              height: 38,
              child: ElevatedButton(
                onPressed: _loading ? null : _fetchMatrix,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kBlue600,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  _loading ? '...' : 'REFRESH',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mfItemDropdown() {
    return Consumer<ItemMasterProvider>(
      builder: (context, provider, _) => Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: _kSlate50,
          border: Border.all(color: _kSlate200),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: (_filters['itemName'] is List && (_filters['itemName'] as List).isNotEmpty)
                ? (_filters['itemName'] as List).first.toString()
                : 'All Items',
            isExpanded: true,
            isDense: true,
            icon: const Icon(LucideIcons.chevronDown, size: 14, color: _kSlate400),
            items: [
              const DropdownMenuItem(value: 'All Items', child: Text('All Items', style: TextStyle(fontSize: 12))),
              ...provider.items.map((it) => DropdownMenuItem(value: it.itemName, child: Text(it.itemName, style: const TextStyle(fontSize: 12)))),
            ],
            onChanged: (v) => setState(() => _filters['itemName'] = v == 'All Items' ? [] : [v!]),
          ),
        ),
      ),
    );
  }

  Widget _mfGroupDropdown() {
    return Consumer<ItemGroupProvider>(
      builder: (context, provider, _) => Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: _kSlate50,
          border: Border.all(color: _kSlate200),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _filters['groupName']?.toString().isEmpty ?? true ? 'All Groups' : _filters['groupName'].toString(),
            isExpanded: true,
            isDense: true,
            items: [
              const DropdownMenuItem(value: 'All Groups', child: Text('All Groups', style: TextStyle(fontSize: 12))),
              ...provider.groups.map((g) => DropdownMenuItem(value: g.groupName, child: Text(g.groupName, style: const TextStyle(fontSize: 12)))),
            ],
            onChanged: (v) => setState(() => _filters['groupName'] = v == 'All Groups' ? '' : v),
          ),
        ),
      ),
    );
  }

  Widget _mfLabel(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w900,
            color: _kSlate400,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 4),
        child,
      ],
    );
  }

  Widget _mfDatePicker(String key) {
    final date =
        DateTime.tryParse(_filters[key]?.toString() ?? '') ?? DateTime.now();
    return GestureDetector(
      onTap: () async {
        final d = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (d != null)
          setState(() => _filters[key] = DateFormat('yyyy-MM-dd').format(d));
      },
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: _kSlate50,
          border: Border.all(color: _kSlate200),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(
              DateFormat('dd-MM-yyyy').format(date),
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(width: 6),
            const Icon(LucideIcons.calendar, size: 12, color: _kSlate400),
          ],
        ),
      ),
    );
  }

  Widget _mfTextField(String key, String hint) {
    final val = _filters[key];
    final text = val is List ? val.join(', ') : (val?.toString() ?? '');
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: _kSlate50,
        border: Border.all(color: _kSlate200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: TextEditingController(text: text),
        style: const TextStyle(fontSize: 12),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 12, color: _kSlate400),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
        onChanged: (v) => setState(() => _filters[key] = v),
      ),
    );
  }

  Widget _mfEyeDropdown() {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: _kSlate50,
        border: Border.all(color: _kSlate200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: (_filters['eye'] ?? 'R/L').toString(),
          isExpanded: true,
          isDense: true,
          items: const [
            DropdownMenuItem(
              value: 'Both',
              child: Text('Both', style: TextStyle(fontSize: 12)),
            ),
            DropdownMenuItem(
              value: 'R/L',
              child: Text('R/L', style: TextStyle(fontSize: 12)),
            ),
            DropdownMenuItem(
              value: 'R',
              child: Text('R', style: TextStyle(fontSize: 12)),
            ),
            DropdownMenuItem(
              value: 'L',
              child: Text('L', style: TextStyle(fontSize: 12)),
            ),
          ],
          onChanged: (v) => setState(() => _filters['eye'] = v ?? 'R/L'),
        ),
      ),
    );
  }

  Widget _buildMatrixContent() {
    if (_loading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: _kBlue600),
            SizedBox(height: 12),
            Text(
              'Building Matrix...',
              style: TextStyle(color: _kSlate400, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }
    if (_powerRows.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.layoutGrid, size: 60, color: _kSlate200),
            SizedBox(height: 12),
            Text(
              'No data found for the selected matrix filters.',
              style: TextStyle(
                color: _kSlate400,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Table(
              border: TableBorder.all(color: _kSlate200, width: 0.5),
              defaultColumnWidth: const FixedColumnWidth(100),
              columnWidths: {0: const FixedColumnWidth(180)},
              children: [
                // Header row
                TableRow(
                  decoration: const BoxDecoration(color: _kSlate50),
                  children: [
                    _matrixCell('SPH / CYL / AXIS', isHeader: true),
                    ..._addCols.map((add) {
                      final v = double.tryParse(add) ?? 0;
                      final label = v > 0 ? 'ADD: +$add' : 'ADD: $add';
                      return _matrixCell(label, isHeader: true);
                    }),
                  ],
                ),
                // Data rows
                ..._powerRows.map((combo) {
                  return TableRow(
                    children: [
                      _matrixCell(combo, isRowHeader: true),
                      ..._addCols.map((add) {
                        final key = '${combo}_$add';
                        final cell = _cellData[key];
                        final qty = cell?['qty'] as int? ?? 0;
                        final status = cell?['status']?.toString() ?? '';
                        return _matrixDataCell(qty, status);
                      }),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _matrixCell(
    String text, {
    bool isHeader = false,
    bool isRowHeader = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      color: (isHeader || isRowHeader) ? const Color(0xFFF8FAFC) : Colors.white,
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: isHeader ? 11 : 12,
          fontWeight: FontWeight.w900,
          color: (isHeader || isRowHeader) ? _kBlue700 : _kSlate700,
          letterSpacing: isHeader ? 0.5 : 0,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _matrixDataCell(int qty, String status) {
    if (qty == 0) {
      return Container(
        padding: const EdgeInsets.all(14),
        alignment: Alignment.center,
        child: const Text(
          '-',
          style: TextStyle(
            fontSize: 12,
            color: _kSlate200,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    Color color;
    Color bg;
    switch (status) {
      case 'Fast Moving':
        color = const Color(0xFF059669);
        bg = const Color(0xFFECFDF5);
        break;
      case 'Medium Moving':
        color = _kBlue600;
        bg = const Color(0xFFEFF6FF);
        break;
      default:
        color = _kSlate500;
        bg = _kSlate50;
    }
    return Container(
      padding: const EdgeInsets.all(14),
      color: bg,
      alignment: Alignment.center,
      child: Text(
        qty.toString(),
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w900,
          color: color,
        ),
      ),
    );
  }

  Widget _buildModalFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      decoration: const BoxDecoration(
        color: _kSlate50,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        border: Border(top: BorderSide(color: _kSlate200)),
      ),
      child: Row(
        children: [
          Text(
            'COMBINATIONS: ${_powerRows.length}  |  UNIQUE ADDS: ${_addCols.length}  |  ITEMS FOUND: ${_data.length}'.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: _kSlate400,
              letterSpacing: 1,
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: widget.onClose,
            style: ElevatedButton.styleFrom(
              backgroundColor: _kSlate800,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
            ),
            child: const Text(
              'Close View',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}
