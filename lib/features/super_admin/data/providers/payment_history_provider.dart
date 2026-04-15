import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/payment_history_model.dart';

class PaymentHistoryProvider with ChangeNotifier {
  List<PaymentHistoryModel> _payments = [];
  bool _isLoading = false;
  String? _error;

  List<PaymentHistoryModel> get payments => _payments;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Summary stats derived from payments
  double get totalRevenue => _payments
      .where((p) => p.status == 'paid')
      .fold(0, (sum, p) => sum + p.amount);

  int get paidCount => _payments.where((p) => p.status == 'paid').length;
  int get pendingCount => _payments.where((p) => p.status == 'pending').length;
  int get failedCount => _payments.where((p) => p.status == 'failed').length;

  Future<void> fetchPayments() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await apiClient.dio.get('/superadmin/payment-history');
      final data = response.data;
      if (data is Map<String, dynamic> && data['data'] != null) {
        _payments = (data['data'] as List)
            .map((item) => PaymentHistoryModel.fromJson(item))
            .toList();
      } else if (data is List) {
        _payments = data
            .map((item) => PaymentHistoryModel.fromJson(item))
            .toList();
      }
      _error = null;
    } on DioException catch (e) {
      _error = e.response?.data?['message'] ?? e.message ?? 'Failed to load payment history';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
