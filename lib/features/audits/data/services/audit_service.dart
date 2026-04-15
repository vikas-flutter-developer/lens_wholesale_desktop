import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';

class AuditService {
  final Dio _dio = apiClient.dio;

  Future<Map<String, dynamic>> fetchStockAudit(Map<String, dynamic> filters) async {
    final response = await _dio.post('/audits/stock-verification', data: filters);
    return response.data;
  }

  Future<Map<String, dynamic>> commitStockAudit(List<Map<String, dynamic>> items) async {
    final response = await _dio.post('/audits/stock-adjust', data: {'items': items});
    return response.data;
  }

  Future<Map<String, dynamic>> fetchBillingAudit(Map<String, dynamic> filters) async {
    final response = await _dio.post('/audits/billing-audit', data: filters);
    return response.data;
  }

  Future<Map<String, dynamic>> fetchBankAudit(Map<String, dynamic> filters) async {
    final response = await _dio.post('/audits/bank-reconciliation', data: filters);
    return response.data;
  }

  Future<Map<String, dynamic>> updateReconciliation(String id, bool status) async {
    final response = await _dio.put('/audits/reconcile-bank/$id', data: {'isReconciled': status});
    return response.data;
  }
}
