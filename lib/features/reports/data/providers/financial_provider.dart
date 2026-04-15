import 'package:flutter/material.dart';
import '../models/financial_models.dart';
import '../services/financial_service.dart';

class FinancialProvider with ChangeNotifier {
  final FinancialService _service = FinancialService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<String> _parentGroups = [];
  List<String> get parentGroups => _parentGroups;

  // Day Book
  DayBookReport? _dayBook;
  DayBookReport? get dayBook => _dayBook;
  
  Map<String, bool> dayBookVisibleColumns = {
    'sNo': true,
    'date': true,
    'transType': true,
    'vchNo': true,
    'account': true,
    'itemName': true,
    'orderNo': true,
    'eye': true,
    'sph': true,
    'cyl': true,
    'axis': true,
    'add': true,
    'remark': true,
    'debit': true,
    'credit': true,
    'view': true,
  };

  void toggleDayBookColumn(String id) {
    dayBookVisibleColumns[id] = !(dayBookVisibleColumns[id] ?? true);
    notifyListeners();
  }

  Future<void> fetchDayBook(Map<String, dynamic> filters) async {
    _isLoading = true;
    notifyListeners();
    try {
      _dayBook = await _service.getDayBookReport(filters);
    } catch (e) {
      debugPrint('Error fetching Day Book: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Cash Bank Book
  CashBankReport? _cashBank;
  CashBankReport? get cashBank => _cashBank;

  Future<void> fetchCashBankBook(Map<String, dynamic> filters) async {
    _isLoading = true;
    notifyListeners();
    try {
      _cashBank = await _service.getCashBankBookReport(filters);
    } catch (e) {
      debugPrint('Error fetching Cash/Bank Book: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Balance Sheet
  BalanceSheetReport? _balanceSheet;
  BalanceSheetReport? get balanceSheet => _balanceSheet;

  Future<void> fetchBalanceSheet(String dateFrom, String dateTo) async {
    _isLoading = true;
    notifyListeners();
    try {
      _balanceSheet = await _service.getBalanceSheetReport({'dateFrom': dateFrom, 'dateTo': dateTo});
    } catch (e) {
      debugPrint('Error fetching Balance Sheet: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Profit & Loss
  PLAccountReport? _plAccount;
  PLAccountReport? get plAccount => _plAccount;

  PLItemReport? _plItem;
  PLItemReport? get plItem => _plItem;

  Future<void> fetchPLAccount(Map<String, dynamic> filters) async {
    _isLoading = true;
    notifyListeners();
    try {
      _plAccount = await _service.getProfitAndLossAccountReport(filters);
    } catch (e) {
      debugPrint('Error fetching P&L Account: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPLItem(Map<String, dynamic> filters) async {
    _isLoading = true;
    notifyListeners();
    try {
      _plItem = await _service.getProfitAndLossItemReport(filters);
    } catch (e) {
      debugPrint('Error fetching P&L Item: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Collection Report
  CollectionReport? _collectionReport;
  CollectionReport? get collectionReport => _collectionReport;

  Future<void> fetchCollectionReport(Map<String, dynamic> filters) async {
    _isLoading = true;
    notifyListeners();
    try {
      _collectionReport = await _service.getCollectionReport(filters);
    } catch (e) {
      debugPrint('Error fetching Collection Report: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void resetAll() {
    _dayBook = null;
    _cashBank = null;
    _balanceSheet = null;
    _plAccount = null;
    _plItem = null;
    _collectionReport = null;
    _parentGroups = [];
    notifyListeners();
  }

  Future<void> fetchParentGroups() async {
    try {
      _parentGroups = await _service.getParentGroups();
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching Parent Groups: $e');
    }
  }
}
