import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart' as excel_pkg;
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:math' as math;
import '../../data/providers/audit_provider.dart';
import '../../../reports/data/providers/inventory_report_provider.dart';
import '../../../reports/data/models/inventory_report_models.dart';
import '../../../masters/data/providers/inventory_providers.dart';
import '../../../masters/data/providers/account_provider.dart';

class VerifyBillingPage extends StatefulWidget {
  final int initialTab;
  const VerifyBillingPage({super.key, this.initialTab = 0});

  @override
  State<VerifyBillingPage> createState() => _VerifyBillingPageState();
}

class _VerifyBillingPageState extends State<VerifyBillingPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Filters State
  DateTime _fromDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime _toDate = DateTime.now();
  List<String> _selectedTransTypes = ['Sale'];
  String _groupSearch = '';
  String _customerSearch = '';
  String _searchText = '';
  
  // Suggestion States
  bool _showGroupSuggestions = false;
  bool _showCustSuggestions = false;
  bool _showTransTypeSelector = false;
  
  // Verification States
  String? _uploadedFileName;
  List<Map<String, dynamic>> _fileData = [];
  List<Map<String, dynamic>> _comparisonResults = [];
  int _mismatchCount = 0;
  bool _isVerifying = false;
  
  String? _uploadedBankFileName;
  List<Map<String, dynamic>> _uploadedBankData = [];
  List<Map<String, dynamic>> _bankVerificationResults = [];

  final ScrollController _horizontalScroll = ScrollController();
  final ScrollController _verticalScroll = ScrollController();

  final List<String> _transactionTypes = [
    'All',
    'Sale',
    'Sale Order',
    'Sale Challan',
    'Sale Return',
    'Purchase',
    'Purchase Order',
    'Purchase Challan',
    'Purchase Return',
    'Rx Sale Order',
    'Rx Purchase Order',
    'Contact Lens & Sol Sale Order',
    'Contact Lens & Sol Purchase Order',
  ];

  final List<String> _allColumns = [
    '#',
    'TRANS TYPE',
    'PARTY NAME',
    'PRODUCT NAME',
    'EYE',
    'SPH',
    'CYL',
    'AXIS',
    'ADD',
    'QTY',
    'TOTAL PRICE',
    'STATUS',
  ];
  late List<String> _selectedColumns;

  final Map<String, double> _colWidths = {
    '#': 60,
    'TRANS TYPE': 150,
    'PARTY NAME': 250,
    'PRODUCT NAME': 250,
    'EYE': 60,
    'SPH': 80,
    'CYL': 80,
    'AXIS': 80,
    'ADD': 80,
    'QTY': 60,
    'TOTAL PRICE': 120,
    'STATUS': 120,
  };

  final Map<String, String> _typeLabelMap = {
    'Sale': 'Sale Invoice',
    'Sale Order': 'Sale Order',
    'Sale Challan': 'Sale Challan',
    'Sale Return': 'Sale Return',
    'Purchase': 'Purchase Invoice',
    'Purchase Order': 'Purchase Order',
    'Purchase Challan': 'Purchase Challan',
    'Purchase Return': 'Purchase Return',
    'Rx Sale Order': 'Rx Sale Order',
    'Rx Purchase Order': 'Rx Purchase Order',
    'Contact Lens & Sol Sale Order': 'Contact Lens & Sol Sale Order',
    'Contact Lens & Sol Purchase Order': 'Contact Lens & Sol Purchase Order'
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: widget.initialTab);
    _selectedColumns = List.from(_allColumns);
    _tabController.addListener(() {
      setState(() {}); // Refresh for tab button styling
    });
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ItemGroupProvider>().fetchGroups();
      context.read<AccountProvider>().fetchAllAccounts();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _horizontalScroll.dispose();
    _verticalScroll.dispose();
    super.dispose();
  }

  void _handleSearch() {
    final Map<String, dynamic> filters = {
      'dateFrom': DateFormat('yyyy-MM-dd').format(_fromDate),
      'dateTo': DateFormat('yyyy-MM-dd').format(_toDate),
      'transType': _selectedTransTypes,
      'groupName': _groupSearch,
      'customerName': _customerSearch,
      'searchText': _searchText,
    };
    context.read<InventoryReportProvider>().fetchPartyWiseItemReport(filters);
    
    // If file is already uploaded, re-run verification after search
    if (_fileData.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 500), () {
        final items = context.read<InventoryReportProvider>().partyWiseItems ?? [];
        _runVerification(items, _fileData);
      });
    }
  }

  void _handleReset() {
    setState(() {
      _fromDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
      _toDate = DateTime.now();
      _selectedTransTypes = ['Sale'];
      _groupSearch = '';
      _customerSearch = '';
      _searchText = '';
      _uploadedFileName = null;
      _fileData = [];
      _comparisonResults = [];
      _mismatchCount = 0;
    });
    context.read<InventoryReportProvider>().resetAll();
  }

  // --- Normalization Helpers (matching React) ---
  String _normalizeEye(String? eye) {
    if (eye == null || eye.isEmpty) return 'RL';
    final e = eye.toUpperCase().trim();
    if (['R', 'RE', 'RIGHT'].contains(e)) return 'R';
    if (['L', 'LE', 'LEFT'].contains(e)) return 'L';
    if (['RL', 'BE', 'BOTH', 'PAIR', 'R/L', 'RE/LE'].contains(e)) return 'RL';
    return e;
  }

  double _cleanNumeric(dynamic val) {
    if (val == null) return 0.0;
    if (val is num) return val.toDouble();
    final str = val.toString().replaceAll(',', '').replaceAll(RegExp(r'[^0-9.-]'), '');
    return double.tryParse(str) ?? 0.0;
  }

  String _normalizePower(dynamic val) {
    return _cleanNumeric(val).toStringAsFixed(2);
  }

  int _normalizeAxis(dynamic val) {
    return _cleanNumeric(val).round();
  }

  void _runVerification(List<PartyWiseItem> sysData, List<Map<String, dynamic>> fData) {
    if (fData.isEmpty || sysData.isEmpty) {
      setState(() {
        _comparisonResults = [];
        _mismatchCount = 0;
      });
      return;
    }

    int mismatches = 0;
    Set<int> usedFileIndices = {};

    List<Map<String, dynamic>> results = [];

    // Filter sysData based on transaction types if "All" is not selected
    final List<PartyWiseItem> filteredSysData = _selectedTransTypes.contains('All')
        ? sysData
        : sysData.where((row) {
            final label = _typeLabelMap[row.transType] ?? row.transType;
            return _selectedTransTypes.any((t) => (_typeLabelMap[t] ?? t) == label);
          }).toList();

    for (int i = 0; i < filteredSysData.length; i++) {
      final sysRow = filteredSysData[i];
      final sysEye = _normalizeEye(sysRow.eye);
      final sysSph = _normalizePower(sysRow.sph);
      final sysCyl = _normalizePower(sysRow.cyl);
      final sysAdd = _normalizePower(sysRow.add);
      final sysAxis = _normalizeAxis(sysRow.axis);

      int matchIdx = -1;
      for (int fIdx = 0; fIdx < fData.length; fIdx++) {
        if (usedFileIndices.contains(fIdx)) continue;
        
        final fRow = fData[fIdx];
        if (_normalizeEye(fRow['eye']) == sysEye &&
            _normalizePower(fRow['sph']) == sysSph &&
            _normalizePower(fRow['cyl']) == sysCyl &&
            _normalizePower(fRow['add']) == sysAdd &&
            _normalizeAxis(fRow['axis']) == sysAxis) {
          matchIdx = fIdx;
          break;
        }
      }

      if (matchIdx == -1) {
        mismatches++;
        results.add({
          'rowIdx': i,
          'isMissingInFile': true,
          'fields': {
            'eye': {'sys': sysRow.eye, 'file': 'Not Found', 'match': false},
            'sph': {'sys': sysSph, 'file': 'N/A', 'match': false},
            'cyl': {'sys': sysCyl, 'file': 'N/A', 'match': false},
            'axis': {'sys': sysAxis, 'file': 'N/A', 'match': false},
            'add': {'sys': sysAdd, 'file': 'N/A', 'match': false},
            'qty': {'sys': sysRow.qty, 'file': 'N/A', 'match': false},
            'totalPrice': {'sys': sysRow.totalPrice, 'file': 'N/A', 'match': false},
          }
        });
      } else {
        usedFileIndices.add(matchIdx);
        final fMatch = fData[matchIdx];
        
        final sysQty = sysRow.qty;
        final sysPrice = sysRow.totalPrice;
        
        final fileQty = _cleanNumeric(fMatch['qty']);
        final filePrice = _cleanNumeric(fMatch['totalPrice']);
        
        final qtyMatch = (fileQty - sysQty).abs() < 0.001;
        final priceMatch = (filePrice - sysPrice).abs() < 0.01;
        
        if (!qtyMatch || !priceMatch) mismatches++;
        
        results.add({
          'rowIdx': i,
          'isMissingInFile': false,
          'fields': {
            'eye': {'sys': sysRow.eye, 'file': fMatch['eye'], 'match': true},
            'sph': {'sys': sysSph, 'file': _normalizePower(fMatch['sph']), 'match': true},
            'cyl': {'sys': sysCyl, 'file': _normalizePower(fMatch['cyl']), 'match': true},
            'axis': {'sys': sysAxis, 'file': _normalizeAxis(fMatch['axis']), 'match': true},
            'add': {'sys': sysAdd, 'file': _normalizePower(fMatch['add']), 'match': true},
            'qty': {'sys': sysQty, 'file': fileQty, 'match': qtyMatch},
            'totalPrice': {'sys': sysPrice, 'file': filePrice, 'match': priceMatch},
          }
        });
      }
    }

    setState(() {
      _comparisonResults = results;
      _mismatchCount = mismatches;
    });

    if (mismatches == 0 && filteredSysData.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Billing verified successfully! 100% Match."), backgroundColor: Colors.green),
      );
    } else if (mismatches > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Found $mismatches mismatches in billing data"), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _handleFileUpload() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    setState(() => _uploadedFileName = file.name);

    try {
      final bytes = file.bytes ?? await File(file.path!).readAsBytes();
      final excel = excel_pkg.Excel.decodeBytes(bytes);
      final sheet = excel.tables.values.first;
      
      final headers = sheet.rows.first.map((e) => e?.value?.toString().toLowerCase() ?? "").toList();
      
      List<Map<String, dynamic>> mappedData = [];
      
      for (var i = 1; i < sheet.rows.length; i++) {
        final row = sheet.rows[i];
        if (row.isEmpty) continue;
        
        final rowData = <String, dynamic>{};
        for (var j = 0; j < headers.length; j++) {
          if (j < row.length) {
            rowData[headers[j]] = row[j]?.value;
          }
        }
        
        // Pattern matching for column names (like React)
        String getVal(List<String> patterns) {
          for (var p in patterns) {
            final key = rowData.keys.firstWhere((k) => k.contains(p.toLowerCase()), orElse: () => "");
            if (key.isNotEmpty) return rowData[key]?.toString() ?? "";
          }
          return "";
        }

        final mappedRow = {
          'eye': getVal(['eye']),
          'sph': getVal(['sph']),
          'cyl': getVal(['cyl']),
          'axis': getVal(['axis']),
          'add': getVal(['add']),
          'qty': getVal(['qty', 'quantity']),
          'totalPrice': getVal(['total price', 'total amount', 'net amount', 'total', 'amount', 'price']),
        };

        if (_cleanNumeric(mappedRow['qty']) > 0 || _cleanNumeric(mappedRow['totalPrice']) > 0) {
          mappedData.add(mappedRow);
        }
      }

      setState(() => _fileData = mappedData);
      
      final sysItems = context.read<InventoryReportProvider>().partyWiseItems ?? [];
      if (sysItems.isNotEmpty) {
        _runVerification(sysItems, mappedData);
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Processed ${mappedData.length} records from file")),
      );
    } catch (e) {
      debugPrint("Excel parsing error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to parse Excel file"), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _handleBankFileUpload() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls', 'csv'],
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    setState(() => _uploadedBankFileName = file.name);

    try {
      final bytes = file.bytes ?? await File(file.path!).readAsBytes();
      final excel = excel_pkg.Excel.decodeBytes(bytes);
      final sheet = excel.tables.values.first;
      
      final headers = sheet.rows.first.map((e) => e?.value?.toString().toLowerCase().trim() ?? "").toList();
      
      List<Map<String, dynamic>> mappedData = [];
      
      for (var i = 1; i < sheet.rows.length; i++) {
        final row = sheet.rows[i];
        if (row.isEmpty) continue;
        
        final rowData = <String, dynamic>{};
        for (var j = 0; j < headers.length; j++) {
          if (j < row.length) {
            rowData[headers[j]] = row[j]?.value;
          }
        }
        
        String getVal(List<String> patterns) {
          for (var p in patterns) {
            final key = rowData.keys.firstWhere((k) => k.contains(p.toLowerCase()), orElse: () => "");
            if (key.isNotEmpty) return rowData[key]?.toString() ?? "";
          }
          return "";
        }

        final mappedRow = {
          'date': getVal(['date', 'txn date', 'value date']),
          'description': getVal(['description', 'particulars', 'narration', 'remarks']),
          'credit': getVal(['credit', 'deposit', 'cr']),
          'debit': getVal(['debit', 'withdrawal', 'dr']),
          'balance': getVal(['balance']),
        };

        if (_cleanNumeric(mappedRow['credit']) > 0 || _cleanNumeric(mappedRow['debit']) > 0) {
          mappedData.add(mappedRow);
        }
      }

      setState(() => _uploadedBankData = mappedData);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Processed ${mappedData.length} records from bank statement: ${file.name}"), backgroundColor: Colors.green),
      );
    } catch (e) {
      debugPrint("Bank Excel parsing error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to parse Bank Statement file"), backgroundColor: Colors.red),
      );
    }
  }

  void _runBankVerification() {
    if (_uploadedBankData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please upload a bank statement first")));
      return;
    }

    final sysData = context.read<InventoryReportProvider>().bankTransactions;
    if (sysData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please search for system data first")));
      return;
    }

    setState(() {
      _isVerifying = true;
      _bankVerificationResults = [];
    });

    List<Map<String, dynamic>> results = [];
    
    // Convert system data to mutable list of maps to track matches
    List<Map<String, dynamic>> sysList = List<Map<String, dynamic>>.from(sysData.map((e) => Map<String, dynamic>.from(e)));
    
    // Track which uploaded rows have been matched
    List<bool> uploadedMatched = List.filled(_uploadedBankData.length, false);

    for (int i = 0; i < sysList.length; i++) {
      final sysRow = sysList[i];
      final sysCredit = _cleanNumeric(sysRow['credit']?.toString() ?? "0");
      final sysDebit = _cleanNumeric(sysRow['debit']?.toString() ?? "0");
      
      bool matched = false;
      Map<String, dynamic>? matchedUpload;
      
      for (int j = 0; j < _uploadedBankData.length; j++) {
        if (uploadedMatched[j]) continue;
        
        final upRow = _uploadedBankData[j];
        final upCredit = _cleanNumeric(upRow['credit']?.toString() ?? "0");
        final upDebit = _cleanNumeric(upRow['debit']?.toString() ?? "0");
        
        // Basic match logic: Exact Amount Match
        if (sysCredit > 0 && sysCredit == upCredit) {
           matched = true;
           matchedUpload = upRow;
           uploadedMatched[j] = true;
           break;
        } else if (sysDebit > 0 && sysDebit == upDebit) {
           matched = true;
           matchedUpload = upRow;
           uploadedMatched[j] = true;
           break;
        }
      }
      
      if (matched && matchedUpload != null) {
        results.add({
          ...sysRow,
          'status': 'MATCHED',
          'uploadedAmount': (sysCredit > 0) ? matchedUpload['credit'] : matchedUpload['debit'],
          'errorDescription': 'N/A',
        });
      } else {
        results.add({
          ...sysRow,
          'status': 'MISSING',
          'uploadedAmount': null,
          'errorDescription': 'Not found in bank file',
        });
      }
    }
    
    // Add remaining uploaded rows as MISMATCH (in bank but not in system)
    for (int j = 0; j < _uploadedBankData.length; j++) {
      if (!uploadedMatched[j]) {
        final upRow = _uploadedBankData[j];
        final upCredit = _cleanNumeric(upRow['credit']?.toString() ?? "0");
        final upDebit = _cleanNumeric(upRow['debit']?.toString() ?? "0");
        
        results.add({
          'date': upRow['date'],
          'source': 'Bank Upload',
          'credit': upCredit,
          'debit': upDebit,
          'systemAmount': 0,
          'status': 'MISMATCHED',
          'uploadedAmount': upCredit > 0 ? upCredit : upDebit,
          'errorDescription': upRow['description'] ?? 'System entry missing',
        });
      }
    }
    
    setState(() {
      _bankVerificationResults = results;
      _isVerifying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTabToggle(),
              const SizedBox(height: 24),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildVerifyBillingTab(),
                    _buildVerifyBankStatementTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)), // slate-200
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _tabButton("Verify Billing", 0),
          _tabButton("Verify Bank Statement", 1),
        ],
      ),
    );
  }

  Widget _tabButton(String label, int index) {
    final isActive = _tabController.index == index;
    return InkWell(
      onTap: () => _tabController.animateTo(index),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF2563EB) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isActive ? [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 4, offset: const Offset(0, 2))] : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.white : const Color(0xFF64748B), // slate-500
          ),
        ),
      ),
    );
  }

  Widget _buildVerifyBillingTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader("Verify Billing"),
        const SizedBox(height: 16),
        _buildBillingFilters(),
        const SizedBox(height: 24),
        Expanded(child: _buildBillingDataTable()),
      ],
    );
  }

  Widget _buildHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Color(0xFFF9FAFB),
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.fileText, size: 24, color: Colors.black),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ],
          ),
          Row(
            children: [
              _actionButton("Excel", const Color(0xFF10B981), LucideIcons.fileSpreadsheet, _exportBillingExcel),
              const SizedBox(width: 8),
              _actionButton("Print", const Color(0xFF475569), LucideIcons.printer, _printBillingPdf),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton(String label, Color color, IconData icon, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        elevation: 1,
      ),
    );
  }

  Widget _buildBillingFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          _filterInput("DATE FROM", _datePicker(_fromDate, (d) => setState(() => _fromDate = d))),
          _filterInput("TO", _datePicker(_toDate, (d) => setState(() => _toDate = d))),
          _filterInput("TRANS TYPE", _transTypeSelector()),
          _filterInput("GROUP", _groupSelector()),
          _filterInput("CUSTMR NAME", _customerSelector()),
          _filterInput("SEARCH TEXT", _textInput(_searchText, "Search...", (v) => setState(() => _searchText = v))),
          _filterInput("COLUMNS", _columnsSelector()),
          
          _filterButton("Upload", const Color(0xFF7C3AED), LucideIcons.upload, _handleFileUpload),
          _filterButton("Search", const Color(0xFF10B981), LucideIcons.search, _handleSearch),
          _iconButton(LucideIcons.rotateCcw, _handleReset),
          _iconButton(LucideIcons.refreshCw, _handleSearch),
        ],
      ),
    );
  }

  Widget _filterInput(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: 0.5)),
        const SizedBox(height: 4),
        child,
      ],
    );
  }

  Widget _datePicker(DateTime date, Function(DateTime) onChanged) {
    return InkWell(
      onTap: () async {
        final d = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (d != null) onChanged(d);
      },
      child: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.5)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(DateFormat('dd-MM-yyyy').format(date), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
            const Icon(LucideIcons.calendar, size: 14, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  Widget _transTypeSelector() {
    return PopupMenuButton<String>(
      tooltip: "Select Transaction Types",
      offset: const Offset(0, 40),
      child: Container(
        width: 176,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.5)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                _selectedTransTypes.isEmpty ? "None" : (_selectedTransTypes.contains("All") ? "All Types" : _selectedTransTypes.join(", ")),
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(LucideIcons.chevronDown, size: 14, color: Colors.black54),
          ],
        ),
      ),
      itemBuilder: (context) {
        return [
          PopupMenuItem<String>(
            enabled: false,
            padding: EdgeInsets.zero,
            child: StatefulBuilder(
              builder: (context, setPopupState) {
                final popupScrollController = ScrollController();
                return Container(
                  width: 320,
                  height: 300,
                  child: Column(
                    children: [
                      Expanded(
                        child: Scrollbar(
                          controller: popupScrollController,
                          thumbVisibility: true,
                          child: ListView.builder(
                            controller: popupScrollController,
                            padding: EdgeInsets.zero,
                            itemCount: _transactionTypes.length,
                            itemBuilder: (context, i) {
                              final type = _transactionTypes[i];
                              final isChecked = _selectedTransTypes.contains(type);
                              
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    if (type == 'All') {
                                      if (isChecked) {
                                        _selectedTransTypes = [];
                                      } else {
                                        _selectedTransTypes = List.from(_transactionTypes);
                                      }
                                    } else {
                                      if (isChecked) {
                                        _selectedTransTypes.remove(type);
                                        _selectedTransTypes.remove('All');
                                      } else {
                                        _selectedTransTypes.add(type);
                                        // If all except 'All' are selected, add 'All'
                                        if (_selectedTransTypes.length == _transactionTypes.length - 1 && !_selectedTransTypes.contains('All')) {
                                          _selectedTransTypes.add('All');
                                        }
                                      }
                                    }
                                  });
                                  setPopupState(() {});
                                },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: Checkbox(
                                            value: isChecked,
                                            activeColor: const Color(0xFF2563EB),
                                            onChanged: (val) {
                                              setState(() {
                                                if (type == 'All') {
                                                  if (val!) {
                                                    _selectedTransTypes = List.from(_transactionTypes);
                                                  } else {
                                                    _selectedTransTypes = [];
                                                  }
                                                } else {
                                                  if (val!) {
                                                    _selectedTransTypes.add(type);
                                                    if (_selectedTransTypes.length == _transactionTypes.length - 1 && !_selectedTransTypes.contains('All')) {
                                                      _selectedTransTypes.add('All');
                                                    }
                                                  } else {
                                                    _selectedTransTypes.remove(type);
                                                    _selectedTransTypes.remove('All');
                                                  }
                                                }
                                              });
                                              setPopupState(() {});
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            type,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: isChecked ? FontWeight.w600 : FontWeight.normal,
                                              color: isChecked ? const Color(0xFF1E293B) : const Color(0xFF64748B),
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
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ];
      },
    );
  }
  Widget _customerSelector({String hint = "Customer...", String searchHint = "Search customer...", String emptyText = "No customers found"}) {
    return PopupMenuButton<String>(
      tooltip: "Select Account",
      offset: const Offset(0, 40),
      child: Container(
        width: 160,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.5)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                _customerSearch.isEmpty ? hint : _customerSearch,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: _customerSearch.isEmpty ? FontWeight.normal : FontWeight.w600,
                  color: _customerSearch.isEmpty ? Colors.black54 : Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(LucideIcons.chevronDown, size: 14, color: Colors.black54),
          ],
        ),
      ),
      itemBuilder: (context) {
        return [
          PopupMenuItem<String>(
            enabled: false,
            padding: EdgeInsets.zero,
            child: StatefulBuilder(
              builder: (context, setPopupState) {
                final accounts = context.watch<AccountProvider>().accounts;
                final filtered = accounts.where((a) => 
                  a.name.toLowerCase().contains(_customerSearch.toLowerCase()) ||
                  (a.mobileNumber != null && a.mobileNumber!.contains(_customerSearch))
                ).toList();

                return Container(
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Search Input
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          autofocus: true,
                          style: const TextStyle(fontSize: 13),
                          decoration: InputDecoration(
                            hintText: searchHint,
                            prefixIcon: const Icon(LucideIcons.search, size: 14),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                          onChanged: (v) {
                            setState(() => _customerSearch = v);
                            setPopupState(() {});
                          },
                        ),
                      ),
                      const Divider(height: 1),
                      // List
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 300),
                        child: filtered.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(emptyText, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: filtered.length,
                                itemBuilder: (context, index) {
                                  final account = filtered[index];
                                  final isSelected = _customerSearch == account.name;

                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        _customerSearch = account.name;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: isSelected ? const Color(0xFFEFF6FF) : Colors.transparent,
                                        border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.1))),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            account.name,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                              color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF1E293B),
                                            ),
                                          ),
                                          if (account.mobileNumber != null && account.mobileNumber!.isNotEmpty)
                                            Text(
                                              account.mobileNumber!,
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: isSelected ? const Color(0xFF3B82F6).withOpacity(0.8) : const Color(0xFF64748B),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                      if (_customerSearch.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              setState(() => _customerSearch = '');
                              Navigator.pop(context);
                            },
                            child: const Text("Clear Selection", style: TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.bold)),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ];
      },
    );
  }

  Widget _groupSelector() {
    return PopupMenuButton<String>(
      tooltip: "Select Group",
      offset: const Offset(0, 40),
      child: Container(
        width: 160,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.5)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                _groupSearch.isEmpty ? "Group..." : _groupSearch,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: _groupSearch.isEmpty ? FontWeight.normal : FontWeight.w600,
                  color: _groupSearch.isEmpty ? Colors.black54 : Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(LucideIcons.chevronDown, size: 14, color: Colors.black54),
          ],
        ),
      ),
      itemBuilder: (context) {
        return [
          PopupMenuItem<String>(
            enabled: false,
            padding: EdgeInsets.zero,
            child: StatefulBuilder(
              builder: (context, setPopupState) {
                final groups = context.watch<ItemGroupProvider>().groups;
                final filtered = groups.where((g) => 
                  g.groupName.toLowerCase().contains(_groupSearch.toLowerCase())
                ).toList();

                return Container(
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Search Input
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          autofocus: true,
                          style: const TextStyle(fontSize: 13),
                          decoration: InputDecoration(
                            hintText: "Search group...",
                            prefixIcon: const Icon(LucideIcons.search, size: 14),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                          onChanged: (v) {
                            setState(() => _groupSearch = v);
                            setPopupState(() {});
                          },
                        ),
                      ),
                      const Divider(height: 1),
                      // List
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 300),
                        child: filtered.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text("No groups found", style: TextStyle(fontSize: 12, color: Colors.black54)),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: filtered.length,
                                itemBuilder: (context, index) {
                                  final group = filtered[index];
                                  final isSelected = _groupSearch == group.groupName;

                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        _groupSearch = group.groupName;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: isSelected ? const Color(0xFFEFF6FF) : Colors.transparent,
                                        border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.1))),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            group.groupName,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                              color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF1E293B),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                      if (_groupSearch.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              setState(() => _groupSearch = '');
                              Navigator.pop(context);
                            },
                            child: const Text("Clear Selection", style: TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.bold)),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ];
      },
    );
  }

  Widget _textInput(String val, String hint, Function(String) onChanged) {
    return SizedBox(
      width: 128,
      child: TextField(
        controller: TextEditingController(text: val)..selection = TextSelection.fromPosition(TextPosition(offset: val.length)),
        onChanged: onChanged,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          hintText: hint,
          fillColor: Colors.white,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: const Color(0xFF3B82F6).withOpacity(0.5)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: const Color(0xFF3B82F6).withOpacity(0.5)),
          ),
        ),
      ),
    );
  }

  Widget _columnsSelector() {
    return PopupMenuButton<String>(
      tooltip: "Select Columns",
      offset: const Offset(0, 40),
      child: Container(
        width: 140,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.5)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  const Icon(LucideIcons.columns, size: 14, color: Colors.black54),
                  const SizedBox(width: 8),
                  Text(
                    "${_selectedColumns.length} selected",
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(LucideIcons.chevronDown, size: 14, color: Colors.black54),
          ],
        ),
      ),
      itemBuilder: (context) {
        return [
          PopupMenuItem<String>(
            enabled: false,
            padding: EdgeInsets.zero,
            child: StatefulBuilder(
              builder: (context, setPopupState) {
                return Container(
                  width: 220,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header Actions
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (_selectedColumns.length == _allColumns.length) {
                                    _selectedColumns = ['#']; // Keep at least the index
                                  } else {
                                    _selectedColumns = List.from(_allColumns);
                                  }
                                });
                                setPopupState(() {});
                              },
                              child: Text(
                                _selectedColumns.length == _allColumns.length ? "Deselect All" : "Select All",
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedColumns = List.from(_allColumns);
                                });
                                setPopupState(() {});
                              },
                              child: const Text(
                                "Reset",
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      // Column List
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 300),
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: _allColumns.length,
                          itemBuilder: (context, index) {
                            final col = _allColumns[index];
                            final isSelected = _selectedColumns.contains(col);
                            if (col == '#') return const SizedBox.shrink(); // Always show # or manage it separately

                            return InkWell(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    if (_selectedColumns.length > 1) {
                                      _selectedColumns.remove(col);
                                    }
                                  } else {
                                    _selectedColumns.add(col);
                                  }
                                });
                                setPopupState(() {});
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: Checkbox(
                                        value: isSelected,
                                        activeColor: const Color(0xFF2563EB),
                                        onChanged: (val) {
                                          setState(() {
                                            if (val!) {
                                              _selectedColumns.add(col);
                                            } else {
                                              if (_selectedColumns.length > 1) {
                                                _selectedColumns.remove(col);
                                              }
                                            }
                                          });
                                          setPopupState(() {});
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      col,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                        color: isSelected ? const Color(0xFF1E293B) : const Color(0xFF64748B),
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
                );
              },
            ),
          ),
        ];
      },
    );
  }

  Widget _filterButton(String label, Color color, IconData icon, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        elevation: 0,
      ),
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xFFCBD5E1)), // slate-300
        ),
        child: Icon(icon, size: 18, color: const Color(0xFF475569)), // slate-600
      ),
    );
  }

  Widget _buildBillingDataTable() {
    return Consumer<InventoryReportProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) return const Center(child: CircularProgressIndicator());
        final items = provider.partyWiseItems ?? [];
        
        if (items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(LucideIcons.fileSearch, size: 64, color: const Color(0xFFCBD5E1)), // slate-300
                const SizedBox(height: 16),
                Text("No records found", style: GoogleFonts.inter(fontSize: 18, color: const Color(0xFF64748B), fontWeight: FontWeight.w500)), // slate-500
                const SizedBox(height: 8),
                Text("Try adjusting your filters or search criteria", style: TextStyle(color: const Color(0xFF94A3B8))), // slate-400
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE2E8F0)), // slate-200
                ),
                child: Scrollbar(
                  controller: _horizontalScroll,
                  thumbVisibility: true,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double tableWidth = _selectedColumns.fold(0.0, (sum, col) => sum + (_colWidths[col] ?? 0));
                      final double fixedWidth = tableWidth > constraints.maxWidth ? tableWidth : constraints.maxWidth;
                      return SingleChildScrollView(
                        controller: _horizontalScroll,
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: fixedWidth,
                            maxWidth: fixedWidth,
                            minHeight: constraints.maxHeight,
                          ),
                          child: Column(
                            children: [
                              _buildTableHead(),
                              Expanded(
                                child: ListView.builder(
                                  controller: _verticalScroll,
                                  itemCount: items.length,
                                  itemBuilder: (context, i) => _buildTableRow(i, items[i]),
                                ),
                              ),
                              _buildTableTotals(items),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildPageFooter(items.length),
          ],
        );
      },
    );
  }

  Widget _buildTableTotals(List<PartyWiseItem> items) {
    double totalQty = items.fold(0, (sum, item) => sum + item.qty);
    double totalAmount = items.fold(0, (sum, item) => sum + item.totalPrice);

    // Calculate dynamic spacing and find where to put the "TOTAL" label
    double spacerWidth = 0;
    String? lastColBeforeQty;
    for (var col in _allColumns) {
      if (col == 'QTY') break;
      if (_selectedColumns.contains(col)) {
        spacerWidth += _colWidths[col] ?? 0;
        lastColBeforeQty = col;
      }
    }
    
    // If we have a spacer, we'll subtract the last column's width to place "TOTAL" there
    double actualSpacerWidth = spacerWidth;
    if (lastColBeforeQty != null) {
      actualSpacerWidth -= _colWidths[lastColBeforeQty]!;
    }

    return Container(
      height: 48,
      decoration: const BoxDecoration(
        color: Color(0xFF334155), // Slate-700 (React style)
      ),
      child: Row(
        children: [
          SizedBox(width: actualSpacerWidth),
          if (lastColBeforeQty != null)
            Container(
              width: _colWidths[lastColBeforeQty]!,
              alignment: Alignment.center,
              child: Text(
                "TOTAL",
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 0.5),
              ),
            ),
          if (_selectedColumns.contains('QTY'))
            _cell(totalQty.toInt().toString(), width: _colWidths['QTY']!, align: TextAlign.center, color: const Color(0xFFFACC15), fontWeight: FontWeight.w900), // Yellow-400
          if (_selectedColumns.contains('TOTAL PRICE'))
            _cell("₹${totalAmount.toStringAsFixed(0)}", width: _colWidths['TOTAL PRICE']!, align: TextAlign.right, color: const Color(0xFF10B981), fontWeight: FontWeight.w900), // Emerald-500
          if (_selectedColumns.contains('STATUS'))
            SizedBox(width: _colWidths['STATUS']!),
        ],
      ),
    );
  }

  Widget _buildPageFooter(int totalRecords) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text("Total Records:", style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B))),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(4)), // blue-100
                child: Text(totalRecords.toString(), style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: const Color(0xFF2563EB))),
              ),
            ],
          ),
          Expanded(
            child: Text(
              "Date Range: ${DateFormat('yyyy-MM-dd').format(_fromDate)} to ${DateFormat('yyyy-MM-dd').format(_toDate)} | Transaction Type: ${_selectedTransTypes.join(', ')}",
              style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8)),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHead() {
    return Container(
      color: const Color(0xFF2563EB),
      child: Row(
        children: _allColumns.where((col) => _selectedColumns.contains(col)).map((col) {
          return _cell(col, width: _colWidths[col]!, isHeader: true, align: (col == 'TOTAL PRICE') ? TextAlign.right : (['#', 'EYE', 'QTY', 'STATUS'].contains(col) ? TextAlign.center : TextAlign.left));
        }).toList(),
      ),
    );
  }

  Future<void> _exportBillingExcel() async {
    final provider = context.read<InventoryReportProvider>();
    final items = provider.partyWiseItems ?? [];
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No data to export')));
      return;
    }

    var excel = excel_pkg.Excel.createExcel();
    var sheet = excel['Verify Billing Report'];
    excel.setDefaultSheet('Verify Billing Report');

    List<String> exportCols = _allColumns.where((c) => _selectedColumns.contains(c)).toList();
    sheet.appendRow(exportCols.map((c) => excel_pkg.TextCellValue(c)).toList());

    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      
      String status = "-";
      Map<String, dynamic>? verification;
      for (var r in _comparisonResults) {
        if (r['rowIdx'] == i) {
          verification = r;
          break;
        }
      }

      if (verification != null) {
        if (verification['isMissingInFile'] == true) {
          status = "Missing";
        } else {
          bool isMatch = (verification['fields']['qty']['match'] == true && verification['fields']['totalPrice']['match'] == true);
          status = isMatch ? "Verified" : "Mismatch";
        }
      }

      List<excel_pkg.CellValue> rowData = [];
      for (var col in exportCols) {
        switch (col) {
          case '#': rowData.add(excel_pkg.IntCellValue(i + 1)); break;
          case 'TRANS TYPE': rowData.add(excel_pkg.TextCellValue(item.transType ?? "-")); break;
          case 'PARTY NAME': rowData.add(excel_pkg.TextCellValue(item.partyName ?? "-")); break;
          case 'PRODUCT NAME': rowData.add(excel_pkg.TextCellValue(item.productName ?? "-")); break;
          case 'EYE': rowData.add(excel_pkg.TextCellValue(item.eye ?? "-")); break;
          case 'SPH': rowData.add(excel_pkg.TextCellValue(item.sph?.toString() ?? "-")); break;
          case 'CYL': rowData.add(excel_pkg.TextCellValue(item.cyl?.toString() ?? "-")); break;
          case 'AXIS': rowData.add(excel_pkg.TextCellValue(item.axis?.toString() ?? "-")); break;
          case 'ADD': rowData.add(excel_pkg.TextCellValue(item.add?.toString() ?? "-")); break;
          case 'QTY': rowData.add(excel_pkg.IntCellValue(item.qty.toInt())); break;
          case 'TOTAL PRICE': rowData.add(excel_pkg.DoubleCellValue(item.totalPrice)); break;
          case 'STATUS': rowData.add(excel_pkg.TextCellValue(status)); break;
          default: rowData.add(excel_pkg.TextCellValue("-"));
        }
      }
      sheet.appendRow(rowData);
    }

    double totalQty = items.fold(0, (sum, item) => sum + item.qty);
    double totalAmount = items.fold(0, (sum, item) => sum + item.totalPrice);
    
    List<excel_pkg.CellValue> totalsRow = [];
    for (var col in exportCols) {
      if (col == 'QTY') totalsRow.add(excel_pkg.IntCellValue(totalQty.toInt()));
      else if (col == 'TOTAL PRICE') totalsRow.add(excel_pkg.DoubleCellValue(totalAmount));
      else if (col == exportCols.first) totalsRow.add(excel_pkg.TextCellValue("TOTAL"));
      else totalsRow.add(excel_pkg.TextCellValue(""));
    }
    sheet.appendRow(totalsRow);

    String? outputFile = await FilePicker.saveFile(
      dialogTitle: 'Save Verify Billing Report',
      fileName: 'verify_billing_report.xlsx',
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (outputFile != null) {
      if (!outputFile.endsWith('.xlsx')) outputFile += '.xlsx';
      final fileBytes = excel.save();
      if (fileBytes != null) {
        File(outputFile)
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Exported to Excel successfully!'), backgroundColor: Colors.green));
      }
    }
  }

  Future<void> _printBillingPdf() async {
    final provider = context.read<InventoryReportProvider>();
    final items = provider.partyWiseItems ?? [];
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No data to print')));
      return;
    }

    final doc = pw.Document();
    List<String> exportCols = _allColumns.where((c) => _selectedColumns.contains(c)).toList();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (context) {
          return [
            pw.Header(level: 0, child: pw.Text("Verify Billing Report", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold))),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              headers: exportCols,
              data: List<List<dynamic>>.generate(items.length, (i) {
                final item = items[i];
                
                String status = "-";
                Map<String, dynamic>? verification;
                for (var r in _comparisonResults) {
                  if (r['rowIdx'] == i) {
                    verification = r;
                    break;
                  }
                }

                if (verification != null) {
                  if (verification['isMissingInFile'] == true) {
                    status = "Missing";
                  } else {
                    bool isMatch = (verification['fields']['qty']['match'] == true && verification['fields']['totalPrice']['match'] == true);
                    status = isMatch ? "Verified" : "Mismatch";
                  }
                }

                return exportCols.map((col) {
                  switch (col) {
                    case '#': return (i + 1).toString();
                    case 'TRANS TYPE': return item.transType ?? "-";
                    case 'PARTY NAME': return item.partyName ?? "-";
                    case 'PRODUCT NAME': return item.productName ?? "-";
                    case 'EYE': return item.eye ?? "-";
                    case 'SPH': return item.sph?.toString() ?? "-";
                    case 'CYL': return item.cyl?.toString() ?? "-";
                    case 'AXIS': return item.axis?.toString() ?? "-";
                    case 'ADD': return item.add?.toString() ?? "-";
                    case 'QTY': return item.qty.toInt().toString();
                    case 'TOTAL PRICE': return "Rs." + item.totalPrice.toStringAsFixed(2);
                    case 'STATUS': return status;
                    default: return "-";
                  }
                }).toList();
              }),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => doc.save());
  }

  Widget _buildTableRow(int i, PartyWiseItem item) {
    // Check if this row has comparison results
    bool isMatch = true;
    String status = "-";
    Color statusColor = const Color(0xFF94A3B8); // slate-400

    Map<String, dynamic>? verification;
    for (var r in _comparisonResults) {
      if (r['rowIdx'] == i) {
        verification = r;
        break;
      }
    }

    if (verification != null) {
      if (verification['isMissingInFile'] == true) {
        isMatch = false;
        status = "Missing";
        statusColor = Colors.red;
      } else {
        isMatch = (verification['fields']['qty']['match'] == true && verification['fields']['totalPrice']['match'] == true);
        status = isMatch ? "Verified" : "Mismatch";
        statusColor = isMatch ? Colors.green : Colors.orange;
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: i % 2 == 0 ? Colors.white : const Color(0xFFF8FAFC),
        border: Border(bottom: BorderSide(color: const Color(0xFFF1F5F9))), // slate-100
      ),
      child: Row(
        children: [
          if (_selectedColumns.contains('#')) _cell((i + 1).toString(), width: _colWidths['#']!),
          if (_selectedColumns.contains('TRANS TYPE')) _cell(item.transType ?? "-", width: _colWidths['TRANS TYPE']!),
          if (_selectedColumns.contains('PARTY NAME')) _cell(item.partyName ?? "-", width: _colWidths['PARTY NAME']!, fontWeight: FontWeight.w600),
          if (_selectedColumns.contains('PRODUCT NAME')) _cell(item.productName ?? "-", width: _colWidths['PRODUCT NAME']!),
          if (_selectedColumns.contains('EYE')) _cell(item.eye ?? "-", width: _colWidths['EYE']!, align: TextAlign.center),
          if (_selectedColumns.contains('SPH')) _cell(item.sph?.toString() ?? "-", width: _colWidths['SPH']!, align: TextAlign.right),
          if (_selectedColumns.contains('CYL')) _cell(item.cyl?.toString() ?? "-", width: _colWidths['CYL']!, align: TextAlign.right),
          if (_selectedColumns.contains('AXIS')) _cell(item.axis?.toString() ?? "-", width: _colWidths['AXIS']!, align: TextAlign.right),
          if (_selectedColumns.contains('ADD')) _cell(item.add?.toString() ?? "-", width: _colWidths['ADD']!, align: TextAlign.right),
          if (_selectedColumns.contains('QTY')) _cell(item.qty.toInt().toString(), width: _colWidths['QTY']!, align: TextAlign.center, color: verification != null && verification['fields']['qty']['match'] == false ? Colors.red : null),
          if (_selectedColumns.contains('TOTAL PRICE')) _cell("₹${item.totalPrice.toStringAsFixed(2)}", width: _colWidths['TOTAL PRICE']!, align: TextAlign.right, fontWeight: FontWeight.bold, color: verification != null && verification['fields']['totalPrice']['match'] == false ? Colors.red : null),
          if (_selectedColumns.contains('STATUS')) _cell(status, width: _colWidths['STATUS']!, align: TextAlign.center, fontWeight: FontWeight.bold, color: statusColor),
        ],
      ),
    );
  }

  static Widget _cell(String text, {required double width, bool isHeader = false, TextAlign align = TextAlign.left, Color? color, FontWeight? fontWeight}) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Text(
        text,
        textAlign: align,
        style: GoogleFonts.inter(
          fontSize: isHeader ? 11 : 13,
          fontWeight: isHeader ? FontWeight.bold : (fontWeight ?? FontWeight.normal),
          color: isHeader ? Colors.white : (color ?? const Color(0xFF334155)),
          letterSpacing: isHeader ? 0.5 : 0,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildVerifyBankStatementTab() {
    return Consumer<InventoryReportProvider>(
      builder: (context, provider, _) {
        final txns = provider.bankTransactions;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBankDashboard(txns),
            const SizedBox(height: 24),
            _buildBankFilters(),
            const SizedBox(height: 24),
            Expanded(child: _buildBankDataTable(txns)),
          ],
        );
      },
    );
  }

  Widget _buildBankDashboard(List<dynamic> txns) {
    final displayTxns = _bankVerificationResults.isNotEmpty ? _bankVerificationResults : txns;
    
    double totalCredit = displayTxns.fold(0.0, (sum, t) {
      double c = (t['credit'] is String) ? (double.tryParse(t['credit']) ?? 0.0) : ((t['credit'] as num?)?.toDouble() ?? 0.0);
      return sum + c;
    });
    double totalDebit = displayTxns.fold(0.0, (sum, t) {
      double d = (t['debit'] is String) ? (double.tryParse(t['debit']) ?? 0.0) : ((t['debit'] as num?)?.toDouble() ?? 0.0);
      return sum + d;
    });
    
    int matched = displayTxns.where((t) => t['status'] == 'MATCHED').length;
    int mismatched = displayTxns.where((t) => t['status'] == 'MISMATCHED').length;
    int missing = displayTxns.where((t) => t['status'] == 'MISSING').length;

    return GridView.count(
      crossAxisCount: 6,
      shrinkWrap: true,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.6,
      children: [
        _kpiCard("TOTAL TXNS", displayTxns.length.toString(), LucideIcons.activity, Colors.blue),
        _kpiCard("MATCHED", matched.toString(), LucideIcons.checkCircle2, const Color(0xFF10B981)), // emerald-500
        _kpiCard("MISMATCHED", mismatched.toString(), LucideIcons.alertCircle, Colors.amber),
        _kpiCard("MISSING", missing.toString(), LucideIcons.helpCircle, Colors.red),
        _kpiCard("TOTAL CREDIT", "₹${totalCredit.toStringAsFixed(0)}", LucideIcons.arrowUpRight, Colors.green, sub: "INWARD CASHFLOW"),
        _kpiCard("TOTAL DEBIT", "₹${totalDebit.toStringAsFixed(0)}", LucideIcons.arrowDownLeft, Colors.red, sub: "OUTWARD CASHFLOW"),
      ],
    );
  }

  Widget _kpiCard(String label, String val, IconData icon, Color color, {String? sub}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)), // slate-200
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF94A3B8))), // slate-400
              Icon(icon, size: 20, color: color),
            ],
          ),
          Text(val, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w900, color: const Color(0xFF1E293B))), // slate-800
          if (sub != null)
            Text(sub, style: GoogleFonts.inter(fontSize: 8, fontWeight: FontWeight.bold, color: color))
          else
            Container(height: 4, width: double.infinity, decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(2)), child: FractionallySizedBox(alignment: Alignment.centerLeft, widthFactor: 1.0, child: Container(decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))))),
        ],
      ),
    );
  }

  Widget _buildBankFilters() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)), // slate-200
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _filterInput("DATE FROM", _datePicker(_fromDate, (d) => setState(() => _fromDate = d))),
          const SizedBox(width: 16),
          _filterInput("DATE TO", _datePicker(_toDate, (d) => setState(() => _toDate = d))),
          const SizedBox(width: 16),
          _filterInput("ACCOUNT / BANK", _customerSelector(hint: "Select Bank Account...", searchHint: "Search bank...", emptyText: "No banks found")),
          const SizedBox(width: 16),
          Expanded(child: _filterInput("QUICK SEARCH", _textInput(_searchText, "Search by Amount, Voucher No...", (v) => setState(() => _searchText = v)))),
          const SizedBox(width: 16),
          _filterButton("Upload Bank Statement", const Color(0xFF4F46E5), LucideIcons.upload, _handleBankFileUpload),
          const SizedBox(width: 8),
          _filterButton("Search", const Color(0xFF2563EB), LucideIcons.search, () {
             final filters = {
               'dateFrom': DateFormat('yyyy-MM-dd').format(_fromDate),
               'dateTo': DateFormat('yyyy-MM-dd').format(_toDate),
               'searchText': _searchText,
             };
             context.read<InventoryReportProvider>().fetchBankTransactions(filters);
          }),
          const SizedBox(width: 8),
          _filterButton("Verify", const Color(0xFF059669), LucideIcons.checkCircle2, _runBankVerification),
          const SizedBox(width: 8),
          _iconButton(LucideIcons.rotateCcw, () {}),
        ],
      ),
    );
  }

  Future<void> _exportBankExcel() async {
    final sysData = context.read<InventoryReportProvider>().bankTransactions;
    final displayTxns = _bankVerificationResults.isNotEmpty ? _bankVerificationResults : sysData;
    if (displayTxns.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No data to export')));
      return;
    }

    var excel = excel_pkg.Excel.createExcel();
    var sheet = excel['Bank Statement Report'];
    excel.setDefaultSheet('Bank Statement Report');

    List<String> headers = ['#', 'DATE', 'SOURCE', 'CREDIT', 'DEBIT', 'UPLOADED AMOUNT', 'SYSTEM AMOUNT', 'STATUS', 'ERROR / DESCRIPTION'];
    sheet.appendRow(headers.map((c) => excel_pkg.TextCellValue(c)).toList());

    for (int i = 0; i < displayTxns.length; i++) {
      final t = displayTxns[i];
      final status = t['status'] ?? "SYSTEM DATA";
      final creditVal = (t['credit'] is String) ? (double.tryParse(t['credit']) ?? 0.0) : ((t['credit'] as num?)?.toDouble() ?? 0.0);
      final debitVal = (t['debit'] is String) ? (double.tryParse(t['debit']) ?? 0.0) : ((t['debit'] as num?)?.toDouble() ?? 0.0);
      final sysAmt = (t['systemAmount'] is String) ? (double.tryParse(t['systemAmount']) ?? 0.0) : ((t['systemAmount'] as num?)?.toDouble() ?? 0.0);

      sheet.appendRow([
        excel_pkg.IntCellValue(i + 1),
        excel_pkg.TextCellValue(t['date']?.toString().split('T')[0] ?? "-"),
        excel_pkg.TextCellValue(t['source']?.toString() ?? "System Data"),
        excel_pkg.DoubleCellValue(creditVal),
        excel_pkg.DoubleCellValue(debitVal),
        excel_pkg.TextCellValue(t['uploadedAmount'] != null ? t['uploadedAmount'].toString() : "-"),
        excel_pkg.DoubleCellValue(sysAmt),
        excel_pkg.TextCellValue(status),
        excel_pkg.TextCellValue(t['errorDescription']?.toString() ?? "N/A"),
      ]);
    }

    String? outputFile = await FilePicker.saveFile(
      dialogTitle: 'Save Bank Statement Report',
      fileName: 'bank_statement_report.xlsx',
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (outputFile != null) {
      if (!outputFile.endsWith('.xlsx')) outputFile += '.xlsx';
      final fileBytes = excel.save();
      if (fileBytes != null) {
        File(outputFile)
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Exported to Excel successfully!'), backgroundColor: Colors.green));
      }
    }
  }

  Future<void> _printBankPdf() async {
    final sysData = context.read<InventoryReportProvider>().bankTransactions;
    final displayTxns = _bankVerificationResults.isNotEmpty ? _bankVerificationResults : sysData;
    if (displayTxns.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No data to print')));
      return;
    }

    final doc = pw.Document();
    
    List<List<String>> tableData = [];
    tableData.add(['#', 'DATE', 'SOURCE', 'CREDIT', 'DEBIT', 'UPLOADED', 'SYSTEM', 'STATUS']);

    for (int i = 0; i < displayTxns.length; i++) {
      final t = displayTxns[i];
      final status = t['status'] ?? "SYSTEM DATA";
      final creditVal = (t['credit'] is String) ? (double.tryParse(t['credit']) ?? 0.0) : ((t['credit'] as num?)?.toDouble() ?? 0.0);
      final debitVal = (t['debit'] is String) ? (double.tryParse(t['debit']) ?? 0.0) : ((t['debit'] as num?)?.toDouble() ?? 0.0);
      final sysAmt = (t['systemAmount'] is String) ? (double.tryParse(t['systemAmount']) ?? 0.0) : ((t['systemAmount'] as num?)?.toDouble() ?? 0.0);

      tableData.add([
        (i + 1).toString(),
        t['date']?.toString().split('T')[0] ?? "-",
        t['source']?.toString() ?? "System Data",
        creditVal > 0 ? "Rs.$creditVal" : "-",
        debitVal > 0 ? "Rs.$debitVal" : "-",
        t['uploadedAmount'] != null ? "Rs.${t['uploadedAmount']}" : "-",
        "Rs.$sysAmt",
        status,
      ]);
    }

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (context) => [
          pw.Header(level: 0, child: pw.Text("Bank Statement Verification Report", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold))),
          pw.SizedBox(height: 10),
          pw.TableHelper.fromTextArray(
            context: context,
            data: tableData,
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
            cellStyle: const pw.TextStyle(fontSize: 8),
            cellAlignment: pw.Alignment.center,
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
      name: 'Bank_Statement_Report',
    );
  }

  Widget _buildBankDataTable(List<dynamic> txns) {
    final displayTxns = _bankVerificationResults.isNotEmpty ? _bankVerificationResults : txns;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)), // slate-200
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Verification Results", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    IconButton(onPressed: _exportBankExcel, icon: const Icon(LucideIcons.fileSpreadsheet, color: Color(0xFF10B981), size: 20)),
                    IconButton(onPressed: _printBankPdf, icon: const Icon(LucideIcons.printer, color: Color(0xFF64748B), size: 20)),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: constraints.maxWidth),
                      child: DataTable(
                headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                headingTextStyle: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF94A3B8), letterSpacing: 1),
                columns: const [
                  DataColumn(label: Text("#")),
                  DataColumn(label: Text("DATE")),
                  DataColumn(label: Text("SOURCE")),
                  DataColumn(label: Text("CREDIT", textAlign: TextAlign.right)),
                  DataColumn(label: Text("DEBIT", textAlign: TextAlign.right)),
                  DataColumn(label: Text("UPLOADED AMOUNT (FILE)", textAlign: TextAlign.right)),
                  DataColumn(label: Text("SYSTEM AMOUNT", textAlign: TextAlign.right)),
                  DataColumn(label: Text("STATUS", textAlign: TextAlign.center)),
                  DataColumn(label: Text("ERROR / DESCRIPTION")),
                ],
                rows: List.generate(displayTxns.length, (i) {
                  final t = displayTxns[i];
                  final status = t['status'] ?? "SYSTEM DATA";
                  
                  Color statusColor = const Color(0xFF64748B);
                  if (status == 'MATCHED') statusColor = const Color(0xFF10B981);
                  if (status == 'MISMATCHED') statusColor = Colors.amber;
                  if (status == 'MISSING') statusColor = Colors.red;

                  final creditVal = (t['credit'] is String) ? (double.tryParse(t['credit']) ?? 0.0) : ((t['credit'] as num?)?.toDouble() ?? 0.0);
                  final debitVal = (t['debit'] is String) ? (double.tryParse(t['debit']) ?? 0.0) : ((t['debit'] as num?)?.toDouble() ?? 0.0);

                  return DataRow(cells: [
                    DataCell(Text((i + 1).toString())),
                    DataCell(Text(t['date']?.toString().split('T')[0] ?? "-")),
                    DataCell(Text(t['source'] ?? "System Data")),
                    DataCell(Text(creditVal > 0 ? "₹$creditVal" : "-", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
                    DataCell(Text(debitVal > 0 ? "₹$debitVal" : "-", style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
                    DataCell(Text(t['uploadedAmount'] != null ? "₹${t['uploadedAmount']}" : "-", style: const TextStyle(color: Colors.black54))),
                    DataCell(Text("₹${t['systemAmount'] ?? 0}")),
                    DataCell(Center(child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: statusColor.withOpacity(0.2))), child: Text(status, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold))))),
                    DataCell(Text(t['errorDescription'] ?? "N/A", style: const TextStyle(color: Colors.black54, fontStyle: FontStyle.italic))),
                  ]);
                }),
              ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
