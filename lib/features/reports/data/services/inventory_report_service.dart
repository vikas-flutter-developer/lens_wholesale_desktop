import '../../../../core/network/api_client.dart';
import '../models/inventory_report_models.dart';
import '../models/lens_stock_report_models.dart';

class InventoryReportService {
  final ApiClient _apiClient = ApiClient();

  Future<LensMovementReportData> getLensMovementReport(Map<String, dynamic> filters) async {
    try {
      final response = await _apiClient.dio.post('/reports/lensmovement', data: filters);
      if (response.data['success'] == true) {
        // Extract the nested data object
        final Map<String, dynamic> data = Map<String, dynamic>.from(response.data['data']);
        data['success'] = true; // Required by LensMovementReportData model
        
        // Sanitize numeric fields
        data['openingStock'] = (data['openingStock'] as num?)?.toDouble() ?? 0.0;
        data['closingStock'] = (data['closingStock'] as num?)?.toDouble() ?? 0.0;
        
        data['purchaseData'] ??= [];
        data['saleData'] ??= [];
        data['unmovedItems'] ??= [];

        void sanitize(List list) {
          for (var item in list) {
            if (item['quantity'] != null) item['quantity'] = (item['quantity'] as num).toDouble();
            if (item['price'] != null) item['price'] = (item['price'] as num).toDouble();
          }
        }
        sanitize(data['purchaseData']);
        sanitize(data['saleData']);

        return LensMovementReportData.fromJson(data);
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

  // --- Lens Stock Report ---

  Future<LensStockReportResponse> getLensStockReport(Map<String, dynamic> filters) async {
    try {
      final response = await _apiClient.dio.post('/reports/lensstock', data: filters);
      if (response.data['success'] == true) {
        return LensStockReportResponse.fromJson(response.data);
      }
      throw Exception(response.data['message'] ?? 'Failed to fetch lens stock report');
    } catch (e) {
      rethrow;
    }
  }

  Future<CustomerItemSalesResponse> getCustomerItemSalesReport(Map<String, dynamic> filters) async {
    try {
      final response = await _apiClient.dio.post('/reports/customer-item-sales', data: filters);
      if (response.data['success'] == true) {
        return CustomerItemSalesResponse.fromJson(response.data);
      }
      throw Exception(response.data['message'] ?? 'Failed to fetch customer item sales report');
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getPowerRangeLibrary(String groupName) async {
    try {
      final response = await _apiClient.dio.get('/lens/power-range-library', queryParameters: {'groupName': groupName});
      if (response.data['success'] == true) {
        return response.data['data'] ?? [];
      }
      return [];
    } catch (e) {
      print('Failed to fetch Power Range Library for $groupName: $e');
      return [];
    }
  }

  Future<ItemStockSummaryResponse> getItemStockSummaryReport(Map<String, dynamic> filters) async {
    try {
      final response = await _apiClient.dio.post('/reports/itemstocksummary', data: filters);
      if (response.data['success'] == true) {
        return ItemStockSummaryResponse.fromJson(response.data);
      }
      throw Exception(response.data['message'] ?? 'Failed to fetch item stock summary report');
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getBankVerificationTransactions(Map<String, dynamic> filters) async {
    try {
      final response = await _apiClient.dio.post('/reports/bank-verification', data: filters);
      if (response.data['success'] == true) {
        return response.data['data'] ?? [];
      }
      return [];
    } catch (e) {
      print('Failed to fetch bank verification transactions: $e');
      return [];
    }
  }
}
