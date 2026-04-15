import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/ledger_model.dart';

class LedgerService {
  final ApiClient _apiClient = ApiClient();

  Future<LedgerReportResponse> getAccountLedger(Map<String, dynamic> params) async {
    try {
      final response = await _apiClient.dio.post('/ledger/account-ledger', data: params);
      return LedgerReportResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> reconcileTransactions(List<Map<String, dynamic>> transactions, String settlementDate) async {
    try {
      final response = await _apiClient.dio.post('/ledger/reconcile-transactions', data: {
        'transactions': transactions,
        'settlementDate': settlementDate,
      });
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
