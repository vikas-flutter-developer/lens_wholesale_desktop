import '../../../../core/network/api_client.dart';
import '../models/inventory_report_models.dart';

class InventoryReportService {
  final ApiClient _apiClient = ApiClient();

  Future<LensMovementReportData> getLensMovementReport(Map<String, dynamic> filters) async {
    try {
      final response = await _apiClient.dio.post('/reports/lensmovement', data: filters);
      if (response.data['success'] == true) {
        return LensMovementReportData.fromJson(response.data);
      }
      throw Exception(response.data['message'] ?? 'Failed to fetch lens movement report');
    } catch (e) {
      rethrow;
    }
  }

  Future<PowerMovementReportData> getPowerMovementReport(Map<String, dynamic> filters) async {
    try {
      final response = await _apiClient.dio.post('/reports/powermovement', data: filters);
      if (response.data['success'] == true) {
        return PowerMovementReportData.fromJson(response.data);
      }
      throw Exception(response.data['message'] ?? 'Failed to fetch power movement report');
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PartyWiseItem>> getPartyWiseItemReport(Map<String, dynamic> filters) async {
    try {
      final response = await _apiClient.dio.post('/reports/partywiseitem', data: filters);
      if (response.data['success'] == true) {
        final List data = response.data['data'] ?? [];
        return data.map((json) => PartyWiseItem.fromJson(json)).toList();
      }
      throw Exception(response.data['message'] ?? 'Failed to fetch party wise item report');
    } catch (e) {
      rethrow;
    }
  }

  Future<List<StockReorderItem>> getReorderReport(Map<String, dynamic> filters) async {
    try {
      final response = await _apiClient.dio.post('/inventory/reorder-report', data: filters);
      if (response.data['success'] == true) {
        final List data = response.data['data'] ?? [];
        return data.map((json) => StockReorderItem.fromJson(json)).toList();
      }
      throw Exception(response.data['message'] ?? 'Failed to fetch reorder report');
    } catch (e) {
      rethrow;
    }
  }

  Future<List<SaleItemGroupWiseItem>> getSaleItemGroupWiseReport(Map<String, dynamic> filters) async {
    try {
      final response = await _apiClient.dio.post('/reports/saleitemgroupwise', data: filters);
      if (response.data['success'] == true) {
        final List data = response.data['data'] ?? [];
        return data.map((json) => SaleItemGroupWiseItem.fromJson(json)).toList();
      }
      throw Exception(response.data['message'] ?? 'Failed to fetch sale item group wise report');
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getAllLensSaleOrders() async {
    try {
      final response = await _apiClient.dio.get('/lensSaleOrder/getAllLensSaleOrder');
      if (response.data['success'] == true) return response.data['data'] ?? [];
      return [];
    } catch (e) {
      print('Failed to fetch Lens Sale Orders from /lensSaleOrder/getAllLensSaleOrder: $e');
      return [];
    }
  }

  Future<List<dynamic>> getAllRxSaleOrders() async {
    try {
      final response = await _apiClient.dio.get('/rxSaleOrder/getAllRxSaleOrder');
      if (response.data['success'] == true) return response.data['data'] ?? [];
      return [];
    } catch (e) {
      print('Failed to fetch Rx Sale Orders from /rxSaleOrder/getAllRxSaleOrder: $e');
      return [];
    }
  }

  Future<List<dynamic>> getAllContactLensSaleOrders() async {
    try {
      final response = await _apiClient.dio.get('/contactLensSaleOrder/getall');
      if (response.data['success'] == true) return response.data['data'] ?? [];
      return [];
    } catch (e) {
      print('Failed to fetch Contact Lens Sale Orders from /contactLensSaleOrder/getall: $e');
      return [];
    }
  }
}
