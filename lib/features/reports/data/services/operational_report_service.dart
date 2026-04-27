import '../../../../core/network/api_client.dart';
import '../models/operational_report_model.dart';

class OperationalReportService {
  Future<OrderToChallanReport> getOrderToChallanReport(Map<String, dynamic> filters) async {
    final response = await apiClient.dio.post('/reports/order-to-challan-time', data: filters);
    return OrderToChallanReport.fromJson(response.data);
  }

  Future<OrderToChallanReport> getPurchaseOrderToChallanReport(Map<String, dynamic> filters) async {
    final response = await apiClient.dio.post('/reports/purchase-order-to-challan-time', data: filters);
    return OrderToChallanReport.fromJson(response.data);
  }

  Future<CancelledOrderRatioReport> getCancelledOrderRatioReport(Map<String, dynamic> filters) async {
    final response = await apiClient.dio.post('/reports/cancelled-order-ratio', data: filters);
    return CancelledOrderRatioReport.fromJson(response.data);
  }

  Future<SaleReturnRatioReport> getSaleReturnRatioReport(Map<String, dynamic> filters) async {
    final response = await apiClient.dio.post('/reports/sale-return-ratio', data: filters);
    return SaleReturnRatioReport.fromJson(response.data);
  }

  Future<SalesGrowthReport> getSalesGrowthComparisonReport(Map<String, dynamic> filters) async {
    final response = await apiClient.dio.post('/reports/salesgrowth', data: filters);
    return SalesGrowthReport.fromJson(response.data);
  }
}

final operationalReportService = OperationalReportService();
