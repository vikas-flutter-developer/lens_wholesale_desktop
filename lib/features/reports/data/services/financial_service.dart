import 'package:flutter/foundation.dart';
import '../../../../core/network/api_client.dart';
import '../models/financial_models.dart';

class FinancialService {
  final ApiClient _apiClient = ApiClient();

  Future<DayBookReport> getDayBookReport(Map<String, dynamic> filters) async {
    try {
      final response = await _apiClient.dio.post('/reports/daybook', data: filters);
      debugPrint('DAY BOOK API RESPONSE: ${response.data}');
      final data = response.data.containsKey('data') ? response.data['data'] : response.data;
      return DayBookReport.fromJson(data);
    } catch (e) {
      debugPrint('DAY BOOK API ERROR: $e');
      rethrow;
    }
  }

  Future<CashBankReport> getCashBankBookReport(Map<String, dynamic> filters) async {
    try {
      final response = await _apiClient.dio.post('/reports/cashbankbook', data: filters);
      debugPrint('CASH BANK API RESPONSE: ${response.data}');
      final data = response.data.containsKey('data') ? response.data['data'] : response.data;
      return CashBankReport.fromJson(data);
    } catch (e) {
      debugPrint('CASH BANK API ERROR: $e');
      rethrow;
    }
  }

  Future<BalanceSheetReport> getBalanceSheetReport(Map<String, dynamic> filters) async {
    try {
      final response = await _apiClient.dio.post('/reports/balancesheet', data: filters);
      debugPrint('BALANCE SHEET API RESPONSE: ${response.data}');
      final data = response.data.containsKey('data') ? response.data['data'] : response.data;
      return BalanceSheetReport.fromJson(data);
    } catch (e) {
      debugPrint('BALANCE SHEET API ERROR: $e');
      rethrow;
    }
  }

  Future<PLAccountReport> getProfitAndLossAccountReport(Map<String, dynamic> filters) async {
    try {
      final response = await _apiClient.dio.post('/reports/profitlossaccount', data: filters);
      debugPrint('P&L ACCOUNT API RESPONSE: ${response.data}');
      final data = response.data.containsKey('data') ? response.data['data'] : response.data;
      return PLAccountReport.fromJson(data);
    } catch (e) {
      debugPrint('P&L ACCOUNT API ERROR: $e');
      rethrow;
    }
  }

  Future<PLItemReport> getProfitAndLossItemReport(Map<String, dynamic> filters) async {
    try {
      final response = await _apiClient.dio.post('/reports/profitloss', data: filters);
      debugPrint('P&L ITEM API RESPONSE: ${response.data}');
      final data = response.data.containsKey('data') ? response.data['data'] : response.data;
      return PLItemReport.fromJson(data);
    } catch (e) {
      debugPrint('P&L ITEM API ERROR: $e');
      rethrow;
    }
  }

  Future<List<String>> getParentGroups() async {
    try {
      final response = await _apiClient.dio.get('/reports/parentgroups');
      final data = response.data.containsKey('data') ? response.data['data'] : response.data;
      if (data is List) {
        return data.map((e) => e.toString()).toList();
      }
      return [];
    } catch (e) {
      debugPrint('PARENT GROUPS API ERROR: $e');
      rethrow;
    }
  }

  Future<CollectionReport> getCollectionReport(Map<String, dynamic> filters) async {
    try {
      final response = await _apiClient.dio.post('/reports/collection', data: filters);
      debugPrint('COLLECTION API RESPONSE: ${response.data}');
      final data = response.data.containsKey('data') ? response.data['data'] : response.data;
      return CollectionReport.fromJson(data);
    } catch (e) {
      debugPrint('COLLECTION API ERROR: $e');
      rethrow;
    }
  }
}
