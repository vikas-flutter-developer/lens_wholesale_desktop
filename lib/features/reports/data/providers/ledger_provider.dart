import 'package:flutter/material.dart';
import '../models/ledger_model.dart';
import '../services/ledger_service.dart';

class LedgerProvider extends ChangeNotifier {
  final LedgerService _service = LedgerService();

  // Filter states
  DateTime _fromDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime _toDate = DateTime.now();
  String _searchName = '';
  String _stationName = '';
  String _accountGroup = '';

  // Data states
  LedgerReportResponse? _report;
  bool _isLoading = false;
  bool _hasSearched = false;
  String? _error;

  // Reconciliation states
  List<int> _reconciledIndices = [];
  String _paymentDate = '';

  // Selection states
  List<int> _selectedRows = [];
  bool _isAllSelected = false;

  // Configuration
  Map<String, bool> visibleColumns = {
    'sn': true,
    'date': true,
    'transType': true,
    'voucherNo': true,
    'debit': true,
    'credit': true,
    'balance': true,
    'shortNarr': true,
    'remarks': true,
    'settlementDate': true,
    'view': true,
  };

  Map<String, bool> detailsVisibleColumns = {
    'sn': true,
    'date': true,
    'voucherType': true,
    'voucherDetail': true,
    'itemName': true,
    'orderNo': true,
    'eye': true,
    'sph': true,
    'cyl': true,
    'axis': true,
    'add': true,
    'qty': true,
    'price': true,
    'amount': true,
    'debit': true,
    'credit': true,
    'balance': true,
    'remarks': true,
  };

  // Getters
  DateTime get fromDate => _fromDate;
  DateTime get toDate => _toDate;
  String get searchName => _searchName;
  String get stationName => _stationName;
  String get accountGroup => _accountGroup;
  LedgerReportResponse? get report => _report;
  bool get isLoading => _isLoading;
  bool get hasSearched => _hasSearched;
  String? get error => _error;
  List<int> get reconciledIndices => _reconciledIndices;
  String get paymentDate => _paymentDate;
  List<int> get selectedRows => _selectedRows;
  bool get isAllSelected => _isAllSelected;

  // Setters
  void setFromDate(DateTime d) { _fromDate = d; notifyListeners(); }
  void setToDate(DateTime d) { _toDate = d; notifyListeners(); }
  void setSearchName(String v) { _searchName = v; notifyListeners(); }
  void setStationName(String v) { _stationName = v; notifyListeners(); }
  void setAccountGroup(String v) { _accountGroup = v; notifyListeners(); }
  void setPaymentDate(String v) { _paymentDate = v; notifyListeners(); }

  void toggleColumn(String id, {bool isDetails = false}) {
    if (isDetails) {
      detailsVisibleColumns[id] = !(detailsVisibleColumns[id] ?? false);
    } else {
      visibleColumns[id] = !(visibleColumns[id] ?? false);
    }
    notifyListeners();
  }

  void toggleRowSelection(int index) {
    if (_selectedRows.contains(index)) {
      _selectedRows.remove(index);
    } else {
      _selectedRows.add(index);
    }
    _isAllSelected = _report != null && _selectedRows.length == _report!.data.length;
    notifyListeners();
  }

  void toggleAllSelection(bool selected) {
    _isAllSelected = selected;
    if (selected && _report != null) {
      _selectedRows = List.generate(_report!.data.length, (i) => i);
    } else {
      _selectedRows = [];
    }
    notifyListeners();
  }

  void clearSelection() {
    _selectedRows = [];
    _isAllSelected = false;
    notifyListeners();
  }

  Future<void> fetchLedger({String? overrideAccount}) async {
    if (overrideAccount != null) _searchName = overrideAccount;
    if (_searchName.isEmpty) {
      _error = "Please select or enter an account name first.";
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    _reconciledIndices = [];
    notifyListeners();

    try {
      final params = {
        'partyAccount': _searchName,
        'fromDate': _fromDate.toIso8601String().split('T')[0],
        'toDate': _toDate.toIso8601String().split('T')[0],
      };
      
      final fullReport = await _service.getAccountLedger(params);
      
      // PARITY: Filter out Sale Orders from Ledger view as per React logic
      final filteredData = fullReport.data.where((r) => r.transType != 'Sale Order').toList();
      
      _report = LedgerReportResponse(
        success: fullReport.success,
        count: filteredData.length,
        data: filteredData,
        openingBalance: fullReport.openingBalance,
        totalDebit: fullReport.totalDebit,
        totalCredit: fullReport.totalCredit,
        closingBalance: fullReport.closingBalance,
      );
      
      _hasSearched = true;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _fromDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
    _toDate = DateTime.now();
    _searchName = '';
    _stationName = '';
    _accountGroup = '';
    _report = null;
    _hasSearched = false;
    _error = null;
    _reconciledIndices = [];
    _paymentDate = '';
    _selectedRows = [];
    _isAllSelected = false;
    notifyListeners();
  }

  // Reconciliation Logic
  void runReconciliationMagic(double amount) {
    _reconciledIndices = [];
    
    if (_report == null) return;

    for (var i = 0; i < _report!.data.length; i++) {
      final row = _report!.data[i];
      // Only target unpaid rows
      if (row.settlementDate != null && row.settlementDate!.isNotEmpty) continue;
      
      final rowBalance = row.balance.abs();
      // Requirement: Update all rows together where balance <= entered amount
      if (rowBalance <= (amount + 0.01)) {
        _reconciledIndices.add(i);
      }
    }
    notifyListeners();
  }

  Future<Map<String, dynamic>> saveSettlement() async {
    if (_reconciledIndices.isEmpty || _paymentDate.isEmpty) {
      return {'success': false, 'error': 'No rows selected or date missing'};
    }

    try {
      final transactions = _report!.data
          .asMap()
          .entries
          .where((e) => _reconciledIndices.contains(e.key))
          .where((e) => e.value.settlementDate == null || e.value.settlementDate!.isEmpty)
          .map((e) => {
                'sourceId': e.value.sourceId,
                'transType': e.value.transType,
              })
          .toList();

      if (transactions.isEmpty) return {'success': false, 'error': 'No unpaid transactions found'};

      final res = await _service.reconcileTransactions(transactions, _paymentDate);
      if (res['success'] == true) {
        _reconciledIndices = [];
        await fetchLedger(); // Refresh
      }
      return res;
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateSingleSettlement(LedgerRow row, String newDate) async {
    try {
      final res = await _service.reconcileTransactions([
        {'sourceId': row.sourceId, 'transType': row.transType}
      ], newDate);
      if (res['success'] == true) {
        await fetchLedger();
      }
      return res;
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }
}
