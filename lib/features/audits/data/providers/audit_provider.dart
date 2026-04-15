import 'package:flutter/material.dart';
import '../models/audit_models.dart';
import '../services/audit_service.dart';

class AuditProvider extends ChangeNotifier {
  final AuditService _service = AuditService();

  List<StockAuditItem> _stockAuditItems = [];
  List<StockAuditItem> get stockAuditItems => _stockAuditItems;

  List<BillingAuditItem> _billingAuditItems = [];
  List<BillingAuditItem> get billingAuditItems => _billingAuditItems;

  List<BankAuditItem> _bankAuditItems = [];
  List<BankAuditItem> get bankAuditItems => _bankAuditItems;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> fetchStockAudit(Map<String, dynamic> filters) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await _service.fetchStockAudit(filters);
      if (res['success'] == true) {
        _stockAuditItems = (res['data'] as List? ?? [])
            .map((e) => StockAuditItem.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        _error = res['message']?.toString();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updatePhysicalStock(int index, double physical) {
    final item = _stockAuditItems[index];
    final variance = physical - item.systemStock;
    _stockAuditItems[index] = item.copyWith(
      physicalStock: physical,
      variance: variance,
    );
    notifyListeners();
  }

  Future<Map<String, dynamic>> commitStockAdjustment() async {
    _isLoading = true;
    notifyListeners();
    try {
      final itemsToAdjust = _stockAuditItems
          .where((it) => it.variance != 0)
          .map((it) => it.toJson())
          .toList();
      if (itemsToAdjust.isEmpty) {
        return {'success': false, 'message': 'No variance to adjust'};
      }
      final res = await _service.commitStockAudit(itemsToAdjust);
      return res;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchBillingAudit(Map<String, dynamic> filters) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await _service.fetchBillingAudit(filters);
      if (res['success'] == true) {
        _billingAuditItems = (res['data'] as List? ?? [])
            .map((e) => BillingAuditItem.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        _error = res['message']?.toString();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchBankAudit(Map<String, dynamic> filters) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await _service.fetchBankAudit(filters);
      if (res['success'] == true) {
        _bankAuditItems = (res['data'] as List? ?? [])
            .map((e) => BankAuditItem.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        _error = res['message']?.toString();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateBankReconciliation(String id, bool status) async {
    try {
      final res = await _service.updateReconciliation(id, status);
      if (res['success'] == true) {
        final idx = _bankAuditItems.indexWhere((it) => it.id == id);
        if (idx != -1) {
          _bankAuditItems[idx] = _bankAuditItems[idx].copyWith(isReconciled: status);
          notifyListeners();
        }
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
