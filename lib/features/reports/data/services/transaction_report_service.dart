import '../../../../core/network/api_client.dart';
import '../models/transaction_report_models.dart';

class TransactionReportService {
  Future<List<TransactionSummary>> getTransactionSummaryReport(Map<String, dynamic> filters) async {
    final response = await apiClient.dio.post('/reports/transactionsummary', data: filters);
    if (response.data['success'] == true) {
      final List data = response.data['data'] ?? [];
      return data.map((json) => TransactionSummary.fromJson(json)).toList();
    }
    return [];
  }

  Future<List<TransactionDetail>> getTransactionDetailReport(Map<String, dynamic> filters) async {
    final response = await apiClient.dio.post('/reports/transactiondetail', data: filters);
    if (response.data['success'] == true) {
      final List data = response.data['data'] ?? [];
      return data.map((json) => TransactionDetail.fromJson(json)).toList();
    }
    return [];
  }

  Future<List<SaleSummaryFormat>> getSaleSummaryFormatReport(Map<String, dynamic> filters) async {
    final response = await apiClient.dio.post('/reports/salesummaryformat', data: filters);
    if (response.data['success'] == true) {
      final List data = response.data['data'] ?? [];
      return data.map((json) => SaleSummaryFormat.fromJson(json)).toList();
    }
    return [];
  }
}

final transactionReportService = TransactionReportService();
