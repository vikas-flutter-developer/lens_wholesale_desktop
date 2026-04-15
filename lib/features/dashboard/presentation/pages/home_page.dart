import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../../core/network/api_client.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:lens_wholesale_desktop/features/utilities/data/providers/utility_provider.dart';

// ==================== Shortcut Model ====================
class QuickShortcutItem {
  final String id;
  final String label;
  final String route;
  final String icon;
  final Color color;

  const QuickShortcutItem({
    required this.id, required this.label, required this.route, required this.icon, required this.color,
  });

  Map<String, dynamic> toJson() => {
    'id': id, 'label': label, 'route': route, 'icon': icon,
    'color': color.toARGB32().toRadixString(16),
  };

  factory QuickShortcutItem.fromJson(Map<String, dynamic> j) => QuickShortcutItem(
    id: j['id'], label: j['label'], route: j['route'], icon: j['icon'],
    color: Color(int.parse(j['color'], radix: 16)),
  );
}

// ==================== Barcode Row Model ====================
class BarcodeRow {
  final String id;
  final TextEditingController controller;
  String value;
  BarcodeRow({required this.id, required this.controller, this.value = ""});
}

const _defaultShortcuts = [
  QuickShortcutItem(id:'1', label:'Sale Order',       route:'/sales/lens-sale-order',                   icon:'shoppingCart', color: Color(0xFF3B82F6)),
  QuickShortcutItem(id:'2', label:'Sale Challan',     route:'/sales/lens-sale-challan',                 icon:'fileText',     color: Color(0xFF6366F1)),
  QuickShortcutItem(id:'3', label:'Purchase Order',   route:'/purchases/purchase-order',                icon:'package',      color: Color(0xFF10B981)),
  QuickShortcutItem(id:'4', label:'Purchase Challan', route:'/purchases/purchase-challan',              icon:'fileText',     color: Color(0xFF14B8A6)),
  QuickShortcutItem(id:'5', label:'Add Voucher',      route:'/transaction/add-voucher',                 icon:'plusCircle',   color: Color(0xFFF59E0B)),
  QuickShortcutItem(id:'6', label:'Lens Stock',       route:'/lenstransaction/lensstockreport',         icon:'barChart2',    color: Color(0xFFF43F5E)),
  QuickShortcutItem(id:'7', label:'Lens Location',    route:'/inventory/lens-location',                 icon:'mapPin',       color: Color(0xFF10B981)),
  QuickShortcutItem(id:'8', label:'Party Wise Report',route:'/reports/inventory/party-wise-item',        icon:'barChart2', color: Color(0xFFA855F7)),
  QuickShortcutItem(id:'9', label:'Product Exchange', route:'/lenstransaction/add-product-exchange',      icon:'refreshCw',    color: Color(0xFFF97316)),
  QuickShortcutItem(id:'10', label:'Cash/Bank Book',  route:'/reports/books/cashbankbook',              icon:'wallet',       color: Color(0xFF2563EB)),
];

IconData _iconFor(String key) {
  const m = {
    'fileText':     LucideIcons.fileText,
    'shoppingCart': LucideIcons.shoppingCart,
    'plusCircle':   LucideIcons.plusCircle,
    'package':      LucideIcons.package,
    'refreshCw':    LucideIcons.refreshCw,
    'barChart2':    LucideIcons.barChart2,
    'search':       LucideIcons.search,
    'mapPin':       LucideIcons.mapPin,
    'wallet':       LucideIcons.wallet,
  };
  return m[key] ?? LucideIcons.zap;
}

const _colorOptions = [
  {'label': 'Blue',    'color': Color(0xFF3B82F6)},
  {'label': 'Indigo',  'color': Color(0xFF6366F1)},
  {'label': 'Emerald', 'color': Color(0xFF10B981)},
  {'label': 'Teal',    'color': Color(0xFF14B8A6)},
  {'label': 'Amber',   'color': Color(0xFFF59E0B)},
  {'label': 'Rose',    'color': Color(0xFFF43F5E)},
  {'label': 'Purple',  'color': Color(0xFFA855F7)},
  {'label': 'Orange',  'color': Color(0xFFF97316)},
  {'label': 'Slate',   'color': Color(0xFF64748B)},
  {'label': 'Cyan',    'color': Color(0xFF06B6D4)},
];

const _iconOptions = ['fileText', 'shoppingCart', 'plusCircle', 'package', 'refreshCw', 'barChart2', 'search'];

// ==================== Home Page ====================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Party state
  List<Map<String, dynamic>> _accounts = [];
  Map<String, dynamic>? _selectedParty;
  final _partySearchCtrl = TextEditingController();
  bool _showPartyDropdown = false;

  // Barcode state 100% logic parity with home.jsx
  List<Map<String, dynamic>> _items = [];
  late List<BarcodeRow> _barcodeRows;
  final _barcodeSearchCtrl = TextEditingController();
  String? _activeBarcodeRowId;
  bool _showBarcodeDropdown = false;

  // Quick shortcuts
  List<QuickShortcutItem> _shortcuts = [];
  bool _isManageMode = false;

  // Overlay-based party search
  final _partyFieldKey = GlobalKey();
  final LayerLink _partyLayerLink = LayerLink();
  OverlayEntry? _partyOverlayEntry;

  final List<Map<String, String>> _presetRoutes = UtilityProvider.systemPages;

  @override
  void initState() {
    super.initState();
    _barcodeRows = [BarcodeRow(id: DateTime.now().toString(), controller: TextEditingController())];
    _loadAccounts();
    _loadItems();
    _loadShortcuts();
  }

  @override
  void dispose() {
    _closePartyOverlay();
    _partySearchCtrl.dispose();
    _barcodeSearchCtrl.dispose();
    for (var r in _barcodeRows) {
      r.controller.dispose();
    }
    super.dispose();
  }

  Future<void> _loadAccounts() async {
    try {
      final res = await apiClient.dio.get('/accounts/getallaccounts');
      final data = res.data;
      final list = data is List ? data : (data['accounts'] ?? data['data'] ?? []);
      if (mounted) setState(() => _accounts = List<Map<String, dynamic>>.from(list));
    } catch (e) {
      debugPrint('Failed to load accounts: $e');
    }
  }

  Future<void> _loadItems() async {
    try {
      final res = await apiClient.dio.get('/items');
      final data = res.data is List ? res.data : (res.data['items'] ?? res.data['data'] ?? []);
      if (mounted) setState(() => _items = List<Map<String, dynamic>>.from(data));
    } catch (e) {
      debugPrint('Failed to load items: $e');
    }
  }

  Future<void> _loadShortcuts() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('dashboard_shortcuts');
    if (saved != null) {
      try {
        final list = jsonDecode(saved) as List;
        setState(() => _shortcuts = list.map((e) => QuickShortcutItem.fromJson(e)).toList());
      } catch (_) { setState(() => _shortcuts = _defaultShortcuts); }
    } else {
      setState(() => _shortcuts = _defaultShortcuts);
    }
  }

  Future<void> _saveShortcuts(List<QuickShortcutItem> updated) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('dashboard_shortcuts', jsonEncode(updated.map((e) => e.toJson()).toList()));
    if (mounted) setState(() => _shortcuts = updated);
  }

  void _openPartyOverlay() {
    _closePartyOverlay();
    final box = _partyFieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final size = box.size;

    _partyOverlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Dismiss tap target
          Positioned.fill(
            child: GestureDetector(
              onTap: _closePartyOverlay,
              behavior: HitTestBehavior.translucent,
              child: const SizedBox.expand(),
            ),
          ),
          // Dropdown panel
          Positioned(
            width: size.width,
            child: CompositedTransformFollower(
              link: _partyLayerLink,
              showWhenUnlinked: false,
              offset: Offset(0, size.height + 6),
              child: Material(
                elevation: 0,
                color: Colors.transparent,
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 220),
                  tween: Tween(begin: 0.0, end: 1.0),
                  curve: Curves.easeOutCubic,
                  builder: (ctx, v, child) => Opacity(
                    opacity: v,
                    child: Transform.translate(
                      offset: Offset(0, -10 * (1 - v)),
                      child: child,
                    ),
                  ),
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 320),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 40,
                          spreadRadius: -8,
                          offset: const Offset(0, 16),
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: StatefulBuilder(
                        builder: (ctx, setOverlayState) {
                          final filtered = _filteredAccounts;
                          if (filtered.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(LucideIcons.searchX, color: Color(0xFF94A3B8), size: 28),
                                  SizedBox(height: 8),
                                  Text('No matching results found',
                                    style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 13, fontWeight: FontWeight.w500)),
                                ],
                              ),
                            );
                          }
                          return Scrollbar(
                            thumbVisibility: true,
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: filtered.length,
                              itemBuilder: (ctx, i) {
                                final acc = filtered[i];
                                final isLast = i == filtered.length - 1;
                                return _DropdownItem(
                                  title: acc['Name'] ?? '',
                                  subtitle: (acc['PrintName'] ?? '').toString(),
                                  isLast: isLast,
                                  onTap: () {
                                    setState(() {
                                      _selectedParty = acc;
                                      _partySearchCtrl.text = acc['Name'] ?? '';
                                    });
                                    _closePartyOverlay();
                                  },
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(_partyOverlayEntry!);
    _partySearchCtrl.addListener(_refreshPartyOverlay);
  }

  void _refreshPartyOverlay() {
    _partyOverlayEntry?.markNeedsBuild();
  }

  void _closePartyOverlay() {
    _partySearchCtrl.removeListener(_refreshPartyOverlay);
    _partyOverlayEntry?.remove();
    _partyOverlayEntry = null;
  }

  String _getContactValue(Map<String, dynamic>? party) {
    if (party == null) return '--';
    return (party['MobileNumber'] ??
            party['mobileNumber'] ??
            party['MobileNo'] ??
            party['mobileNo'] ??
            party['Contact'] ??
            party['contact'] ??
            party['Phone'] ??
            party['phone'] ??
            party['ContactPerson'] ??
            party['contactPerson'] ??
            party['Email'] ??
            party['email'] ??
            '--')
        .toString();
  }

  Future<void> _handlePrintCustomerSection() async {
    if (_selectedParty == null) return;
    final pdf = pw.Document();
    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(20),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.only(bottom: 8),
                decoration: const pw.BoxDecoration(
                  border: pw.Border(bottom: pw.BorderSide(color: PdfColors.black, width: 2)),
                ),
                child: pw.Text("Customer / Party Information", 
                  style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(height: 20),
              _pwField("Party Account:", _selectedParty?['Name'] ?? '--'),
              _pwField("Contact:", _getContactValue(_selectedParty)),
              _pwField("State:", _selectedParty?['State'] ?? '--'),
              _pwField("Address:", _selectedParty?['Address'] ?? '--'),
            ],
          ),
        );
      },
    ));
    _showPrintPreview(pdf, "customer_info.pdf");
  }

  void _showPrintPreview(pw.Document pdf, String fileName) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(LucideIcons.printer, size: 20, color: Color(0xFF3B82F6)),
                      const SizedBox(width: 12),
                      const Text("Print Preview", 
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context), 
                    icon: const Icon(LucideIcons.x, size: 20, color: Color(0xFF64748B)),
                    hoverColor: Colors.red.shade50,
                  ),
                ],
              ),
            ),
            Expanded(
              child: PdfPreview(
                build: (format) => pdf.save(),
                pdfFileName: fileName,
                allowSharing: false,
                allowPrinting: true,
                canChangePageFormat: true,
                canChangeOrientation: true,
                canDebug: false,
                previewPageMargin: const EdgeInsets.all(20),
                pdfPreviewPageDecoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 5))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  pw.Widget _pwField(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 12),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 140, 
            child: pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
          ),
          pw.Expanded(
            child: pw.Container(
              padding: const pw.EdgeInsets.only(bottom: 4),
              decoration: const pw.BoxDecoration(
                border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5)),
              ),
              child: pw.Text(value, style: const pw.TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handlePrintBarcodes() async {
    final activeRows = _barcodeRows.where((r) => r.value.isNotEmpty).toList();
    if (activeRows.isEmpty) return;

    final pdf = pw.Document();
    pdf.addPage(pw.MultiPage(
      build: (pw.Context context) {
        return [
          pw.Wrap(
            spacing: 20,
            runSpacing: 20,
            children: activeRows.map((row) {
              return pw.Container(
                width: 200, padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Column(
                  children: [
                    pw.Text("Barcode", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 10),
                    pw.Text(row.value, style: const pw.TextStyle(fontSize: 20)),
                  ],
                ),
              );
            }).toList(),
          ),
        ];
      },
    ));
    _showPrintPreview(pdf, "barcodes.pdf");
  }

  List<Map<String, dynamic>> get _filteredAccounts {
    final q = _partySearchCtrl.text.toLowerCase();
    if (q.isEmpty) return _accounts.take(20).toList();
    return _accounts.where((acc) {
      final name = (acc['Name'] ?? acc['name'] ?? '').toString().toLowerCase();
      final printName = (acc['PrintName'] ?? acc['printName'] ?? '').toString().toLowerCase();
      final alias = (acc['Alias'] ?? acc['alias'] ?? '').toString().toLowerCase();
      return name.contains(q) || printName.contains(q) || alias.contains(q);
    }).take(20).toList();
  }

  List<Map<String, dynamic>> get _filteredItems {
    final q = _barcodeSearchCtrl.text.toLowerCase();
    if (q.isEmpty) return _items.take(20).toList();
    return _items.where((item) {
      final barcode = (item['Barcode'] ?? item['barcode'] ?? '').toString().toLowerCase();
      final name = (item['ItemName'] ?? item['itemName'] ?? '').toString().toLowerCase();
      return barcode.contains(q) || name.contains(q);
    }).take(20).toList();
  }

  void _addBarcodeRow() {
    setState(() {
      _barcodeRows.add(BarcodeRow(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        controller: TextEditingController(),
      ));
    });
  }

  void _removeBarcodeRow(String id) {
    if (_barcodeRows.length > 1) {
      final row = _barcodeRows.firstWhere((r) => r.id == id);
      row.controller.dispose();
      setState(() => _barcodeRows.removeWhere((r) => r.id == id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr = '${_weekday(now.weekday)}, ${_month(now.month)} ${now.day}, ${now.year}';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: AnimationLimiter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 375),
            childAnimationBuilder: (widget) => SlideAnimation(verticalOffset: 50.0, child: FadeInAnimation(child: widget)),
            children: [
              // Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                   Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Dashboard", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: Color(0xFF111827), letterSpacing: -1.5)),
                      SizedBox(height: 4),
                      Text("Business Overview & Quick Tools", style: TextStyle(fontSize: 16, color: Color(0xFF6B7280), fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFF1F5F9)),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0,2))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text("CURRENT SESSION", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF9CA3AF), letterSpacing: 1.5)),
                        Text(dateStr, style: const TextStyle(fontSize: 13, color: Color(0xFF4B5563), fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Main Row: Party + Barcode
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Party Section (60% width parity)
                  Expanded(
                    flex: 6,
                    child: _buildCard(
                      title: "Customer / Party",
                      icon: LucideIcons.user,
                      iconBg: const Color(0xFFEFF6FF),
                      iconColor: const Color(0xFF2563EB),
                      buttonLabel: "Print",
                      buttonIcon: LucideIcons.printer,
                      onButtonPressed: _handlePrintCustomerSection,
                      child: _buildPartyContent(),
                    ),
                  ),
                  const SizedBox(width: 24),
                  // Barcode Section (40% width parity)
                  Expanded(
                    flex: 4,
                    child: _buildCard(
                      title: "Barcode Print",
                      icon: LucideIcons.search,
                      iconBg: const Color(0xFFECFDF5),
                      iconColor: const Color(0xFF10B981),
                      buttonLabel: "Print",
                      buttonIcon: LucideIcons.printer,
                      onButtonPressed: _handlePrintBarcodes,
                      child: _buildBarcodeContent(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Quick Actions
              _buildQuickShortcutsContainer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required IconData icon, required Color iconBg, required Color iconColor, String? buttonLabel, IconData? buttonIcon, VoidCallback? onButtonPressed, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 15, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
                    child: Icon(icon, size: 22, color: iconColor),
                  ),
                  const SizedBox(width: 14),
                  Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1F2937))),
                ],
              ),
              if (buttonLabel != null)
                ElevatedButton.icon(
                  onPressed: onButtonPressed,
                  icon: Icon(buttonIcon, size: 16),
                  label: Text(buttonLabel),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: iconColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    elevation: 4,
                    shadowColor: iconColor.withValues(alpha: 0.3),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }

  Widget _buildPartyContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Party Account"),
        CompositedTransformTarget(
          link: _partyLayerLink,
          child: TextField(
            key: _partyFieldKey,
            controller: _partySearchCtrl,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              hintText: 'Search Party Name...',
              hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontWeight: FontWeight.normal),
              prefixIcon: const Icon(LucideIcons.search, size: 18, color: Color(0xFF9CA3AF)),
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFF3F4F6)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
              ),
            ),
            onTap: _openPartyOverlay,
            onChanged: (_) {
              if (_partyOverlayEntry == null) {
                _openPartyOverlay();
              } else {
                _partyOverlayEntry?.markNeedsBuild();
              }
            },
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _buildReadOnlyField("Contact", _getContactValue(_selectedParty))),
            const SizedBox(width: 20),
            Expanded(child: _buildReadOnlyField("State", _selectedParty?['State'] ?? '--')),
          ],
        ),
        const SizedBox(height: 20),
        _buildReadOnlyField("Address", _selectedParty?['Address'] ?? _selectedParty?['address'] ?? '--', maxLines: 2),
      ],
    );
  }

  Widget _buildBarcodeContent() {
    return Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 220),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _barcodeRows.length,
            itemBuilder: (context, i) {
              final row = _barcodeRows[i];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildSearchField(
                        controller: row.controller,
                        hint: "Enter or scan barcode...",
                        onTap: () {
                          setState(() {
                            _activeBarcodeRowId = row.id;
                            _barcodeSearchCtrl.text = row.value;
                            _showBarcodeDropdown = true;
                          });
                        },
                        onChanged: (val) {
                          setState(() {
                            row.value = val;
                            _barcodeSearchCtrl.text = val;
                          });
                        },
                        showDropdown: _showBarcodeDropdown && _activeBarcodeRowId == row.id && _filteredItems.isNotEmpty,
                        dropdown: _buildBarcodeDropdown(row),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(LucideIcons.trash2, color: Color(0xFFCBD5E1), size: 20),
                      onPressed: () => _removeBarcodeRow(row.id),
                      hoverColor: Colors.red.shade50,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: _addBarcodeRow,
            icon: const Icon(LucideIcons.plus, size: 20),
            label: const Text("Add Barcode Row", style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.5)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F172A),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 8,
              shadowColor: Colors.black45,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(text.toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF94A3B8), letterSpacing: 1.5)),
    );
  }

  Widget _buildReadOnlyField(String label, String value, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF1F5F9)),
            boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 1), blurStyle: BlurStyle.inner)],
          ),
          child: Text(value, maxLines: maxLines, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
        ),
      ],
    );
  }

  Widget _buildSearchField({required String hint, TextEditingController? controller, VoidCallback? onTap, Function(String)? onChanged, bool showDropdown = false, Widget? dropdown, String? initialValue}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        TextField(
          controller: controller ?? (initialValue != null ? TextEditingController(text: initialValue) : null),
          onTap: onTap,
          onChanged: onChanged,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontWeight: FontWeight.normal),
            prefixIcon: const Icon(LucideIcons.search, size: 18, color: Color(0xFF9CA3AF)),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFF3F4F6))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2)),
          ),
        ),
        if (showDropdown)
          Positioned(
            top: 64, left: 0, right: 0,
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 250),
              tween: Tween<double>(begin: 0, end: 1),
              curve: Curves.easeOutQuart,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, -12 * (1 - value)), // Start from top, slide down
                    child: child,
                  ),
                );
              },
              child: Material(
                elevation: 30,
                shadowColor: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(24),
                color: Colors.white,
                type: MaterialType.canvas, // Ensures solid color
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFF1F5F9)),
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 320),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: dropdown!,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPartyDropdown() {
    if (_filteredAccounts.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          children: const [
            Icon(LucideIcons.searchX, color: Color(0xFF94A3B8), size: 32),
            SizedBox(height: 12),
            Text("No matching results found", style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 13, fontWeight: FontWeight.w500)),
          ],
        ),
      );
    }
    return Scrollbar(
      thumbVisibility: true,
      child: ListView.separated(
        padding: const EdgeInsets.all(8),
        shrinkWrap: true,
        itemCount: _filteredAccounts.length,
        separatorBuilder: (ctx, i) => const SizedBox(height: 4),
        itemBuilder: (ctx, i) {
          final acc = _filteredAccounts[i];
          return _DropdownItem(
            title: acc['Name'] ?? '',
            subtitle: (acc['PrintName'] ?? 'N/A').toString(),
            onTap: () {
              setState(() {
                _selectedParty = acc;
                _partySearchCtrl.text = acc['Name'] ?? '';
                _showPartyDropdown = false;
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildBarcodeDropdown(BarcodeRow row) {
    if (_filteredItems.isEmpty) return const SizedBox.shrink();
    return Scrollbar(
      thumbVisibility: true,
      child: ListView.separated(
        padding: const EdgeInsets.all(8),
        shrinkWrap: true,
        itemCount: _filteredItems.length,
        separatorBuilder: (ctx, i) => const SizedBox(height: 4),
        itemBuilder: (ctx, i) {
          final item = _filteredItems[i];
          return _DropdownItem(
            title: item['Barcode'] ?? '',
            subtitle: item['ItemName'] ?? '',
            onTap: () {
              setState(() {
                row.value = item['Barcode'] ?? '';
                row.controller.text = item['Barcode'] ?? '';
                _showBarcodeDropdown = false;
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildQuickShortcutsContainer() {
    return _buildCard(
      title: "Quick Actions",
      icon: LucideIcons.zap,
      iconBg: const Color(0xFFFFF7ED),
      iconColor: const Color(0xFFF97316),
      buttonLabel: _isManageMode ? "Done" : "Manage Shortcuts",
      buttonIcon: _isManageMode ? LucideIcons.check : LucideIcons.settings,
      onButtonPressed: () => setState(() => _isManageMode = !_isManageMode),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Access your most frequent tasks instantly", style: TextStyle(fontSize: 14, color: Color(0xFF6B7280), fontWeight: FontWeight.w500)),
          const SizedBox(height: 24),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              ..._shortcuts.map((sc) => _buildShortcutCardItem(sc)),
              if (_isManageMode) _buildAddShortcutPlaceholder(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShortcutCardItem(QuickShortcutItem sc) {
    return GestureDetector(
      onTap: _isManageMode ? null : () => context.go(sc.route),
      child: Container(
        width: 220,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: sc.color, borderRadius: BorderRadius.circular(14)),
              child: Icon(_iconFor(sc.icon), color: Colors.white, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(sc.label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Color(0xFF1E293B)), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const Text("Navigate to Page", style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            if (_isManageMode)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(LucideIcons.edit2, color: Color(0xFF3B82F6), size: 18),
                    onPressed: () => _showAddEditShortcutDialog(sc),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(LucideIcons.trash2, color: Color(0xFFEF4444), size: 18),
                    onPressed: () {
                      final updated = _shortcuts.where((s) => s.id != sc.id).toList();
                      _saveShortcuts(updated);
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddShortcutPlaceholder() {
    return GestureDetector(
      onTap: () => _showAddEditShortcutDialog(),
      child: Container(
        width: 220, height: 84,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFCBD5E1), width: 2, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.plus, color: Color(0xFF94A3B8), size: 24),
            Text("ADD SHORTCUT", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 1.5)),
          ],
        ),
      ),
    );
  }

  void _showAddEditShortcutDialog([QuickShortcutItem? existing]) {
    String label = existing?.label ?? '';
    String route = existing?.route ?? '';
    String icon = existing?.icon ?? 'fileText';
    Color color = existing?.color ?? _colorOptions[0]['color'] as Color;
    String routeSearch = route;
    bool showResults = false;

    final labelController = TextEditingController(text: label);
    final routeSearchController = TextEditingController(text: routeSearch);
    final LayerLink layerLink = LayerLink();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final filtered = routeSearch.isEmpty 
            ? _presetRoutes.take(5).toList()
            : _presetRoutes.where((r) => 
                r['label']!.toLowerCase().contains(routeSearch.toLowerCase()) || 
                r['value']!.toLowerCase().contains(routeSearch.toLowerCase())
              ).take(5).toList();

          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Container(
              width: 480,
              padding: const EdgeInsets.all(24),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(existing == null ? "Add New Shortcut" : "Edit Shortcut", 
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                          IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(LucideIcons.x, color: Color(0xFF64748B))),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Display Label
                      const Text("Display Label", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                      const SizedBox(height: 8),
                      TextField(
                        onChanged: (v) => setDialogState(() => label = v),
                        controller: labelController,
                        decoration: InputDecoration(
                          hintText: "e.g. Sales Report",
                          filled: true,
                          fillColor: const Color(0xFFF9FAFB),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Redirect Route
                      const Text("Redirect Route", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                      const SizedBox(height: 8),
                      CompositedTransformTarget(
                        link: layerLink,
                        child: TextField(
                          controller: routeSearchController,
                          onChanged: (v) => setDialogState(() {
                            routeSearch = v;
                            route = v;
                            showResults = true;
                          }),
                          onTap: () => setDialogState(() => showResults = true),
                          decoration: InputDecoration(
                            hintText: "Search for a page...",
                            prefixIcon: const Icon(LucideIcons.search, size: 18),
                            filled: true,
                            fillColor: const Color(0xFFF9FAFB),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Icon Selection
                      const Text("Icon", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                      const SizedBox(height: 8),
                      // ... rest of Column ...
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _iconOptions.map((i) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: InkWell(
                          onTap: () => setDialogState(() => icon = i),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: icon == i ? const Color(0xFFEFF6FF) : const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: icon == i ? const Color(0xFF3B82F6) : Colors.transparent, width: 2),
                            ),
                            child: Icon(_iconFor(i), color: icon == i ? const Color(0xFF3B82F6) : const Color(0xFF64748B), size: 20),
                          ),
                        ),
                      )).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Color Selection
                  const Text("Color", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8, runSpacing: 8,
                    children: _colorOptions.map((c) {
                      final cItem = c['color'] as Color;
                      return InkWell(
                        onTap: () => setDialogState(() => color = cItem),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 32, height: 32,
                          decoration: BoxDecoration(color: cItem, shape: BoxShape.circle),
                          child: color == cItem ? const Icon(LucideIcons.check, color: Colors.white, size: 16) : null,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                  
                  // Action Buttons - Matches React 1:2 flex-ratio
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            side: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          child: const Text("Cancel", style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            if (label.isEmpty || route.isEmpty) return;
                            final updated = [..._shortcuts];
                            if (existing == null) {
                              updated.add(QuickShortcutItem(
                                id: DateTime.now().millisecondsSinceEpoch.toString(),
                                label: label,
                                route: route,
                                icon: icon,
                                color: color,
                              ));
                            } else {
                              final idx = updated.indexWhere((s) => s.id == existing.id);
                              if (idx != -1) {
                                updated[idx] = QuickShortcutItem(
                                  id: existing.id,
                                  label: label,
                                  route: route,
                                  icon: icon,
                                  color: color,
                                );
                              }
                            }
                            _saveShortcuts(updated);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 8,
                            shadowColor: const Color(0xFF3B82F6).withValues(alpha: 0.3),
                          ),
                          child: Text(existing == null ? "Create Shortcut" : "Update Shortcut", 
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

                  // Floating Search Results - Matches React "absolute top-full"
                  if (showResults)
                    Positioned(
                      width: 416, // Matches inner width (480 - 64 padding)
                      child: CompositedTransformFollower(
                        link: layerLink,
                        showWhenUnlinked: false,
                        offset: const Offset(0, 52), // Below input field
                        child: Material(
                          elevation: 32,
                          shadowColor: Colors.black.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFF1F5F9)),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ...filtered.map((r) => InkWell(
                                  onTap: () => setDialogState(() {
                                    route = r['value']!;
                                    routeSearch = r['label']!;
                                    routeSearchController.text = r['label']!;
                                    if (labelController.text.isEmpty) {
                                      labelController.text = r['label']!;
                                      label = r['label']!;
                                    }
                                    showResults = false;
                                  }),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9)))),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(r['label']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B))),
                                        const SizedBox(height: 2),
                                        Text(r['value']!, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                                      ],
                                    ),
                                  ),
                                )),
                                if (filtered.isEmpty)
                                  const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Text("Custom Route mode", style: TextStyle(fontSize: 12, color: Color(0xFF3B82F6), fontWeight: FontWeight.bold)),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _weekday(int d) => ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'][d - 1];
  String _month(int m) => ['January','February','March','April','May','June','July','August','September','October','November','December'][m - 1];
}

// ==================== React-Style Dropdown Item ====================
// Matches React: px-5 py-3 hover:bg-blue-50 border-b border-gray-50 last:border-b-0
class _DropdownItem extends StatefulWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isLast;
  const _DropdownItem({
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isLast = false,
  });

  @override
  State<_DropdownItem> createState() => _DropdownItemState();
}

class _DropdownItemState extends State<_DropdownItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      onHover: (v) => setState(() => _isHovered = v),
      hoverColor: const Color(0xFFEFF6FF),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        // React: px-5 py-3 = horizontal 20px, vertical 12px
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: _isHovered ? const Color(0xFFEFF6FF) : Colors.white,
          // React: border-b border-gray-50 last:border-b-0
          border: widget.isLast
              ? null
              : const Border(bottom: BorderSide(color: Color(0xFFF9FAFB))),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // React: font-bold text-gray-800 text-sm
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: _isHovered ? const Color(0xFF2563EB) : const Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 2),
                  // React: text-[10px] text-gray-400 font-bold uppercase tracking-thinner
                  Text(
                    widget.subtitle.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      color: _isHovered
                          ? const Color(0xFF3B82F6).withValues(alpha: 0.7)
                          : const Color(0xFF9CA3AF),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            // Extra polish: chevron on hover (not in React, but nice UX)
            AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
              opacity: _isHovered ? 1 : 0,
              child: const Icon(LucideIcons.chevronRight, size: 14, color: Color(0xFF3B82F6)),
            ),
          ],
        ),
      ),
    );
  }
}
