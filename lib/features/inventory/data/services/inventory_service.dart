import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';

class InventoryService {
  final Dio _dio = apiClient.dio;

  Future<List<Map<String, dynamic>>> getLensStockReport({
    String? lensGroup,
    String? companyId,
    String? godown,
    double? sph,
    double? cyl,
    double? axis,
    double? add,
  }) async {
    final Map<String, dynamic> data = {
      'lensGroup': lensGroup,
      'companyId': companyId,
      'godown': godown,
      'sph': sph,
      'cyl': cyl,
      'axis': axis,
      'add': add,
    }..removeWhere((key, value) => value == null);

    final response = await _dio.post('/reports/lensstock', data: data);
    if (response.data['success'] == true) {
      return List<Map<String, dynamic>>.from(response.data['data'] ?? []);
    }
    return [];
  }

  Future<void> saveLensLocationStock(List<Map<String, dynamic>> stocks) async {
    await _dio.post('/lensLocation/save', data: {'stocks': stocks});
  }

  Future<List<Map<String, dynamic>>> getLensLocationStock(Map<String, dynamic> data) async {
    final response = await _dio.post('/lensLocation/fetch', data: data);
    if (response.data['success'] == true) {
      return List<Map<String, dynamic>>.from(response.data['data'] ?? []);
    }
    return [];
  }

  Future<Map<String, dynamic>> checkStockAvailability(List<Map<String, dynamic>> items) async {
    final response = await _dio.post('/lensLocation/checkStock', data: {'items': items});
    return response.data;
  }

  // --- Damage & Shrinkage ---

  Future<String> getNextDamageBillNo(String series) async {
    final response = await _dio.get('/damageEntry/nextBillNo', queryParameters: {'series': series});
    if (response.data['success'] == true) {
      return response.data['nextBillNo'].toString();
    }
    return '';
  }

  Future<Map<String, dynamic>> saveDamageEntry(Map<String, dynamic> data) async {
    final response = await _dio.post('/damageEntry/create', data: data);
    return response.data;
  }

  Future<Map<String, dynamic>> updateDamageEntry(String id, Map<String, dynamic> data) async {
    final response = await _dio.put('/damageEntry/$id', data: data);
    return response.data;
  }

  Future<Map<String, dynamic>> getDamageEntry(String id) async {
    final response = await _dio.get('/damageEntry/$id');
    return response.data;
  }

  Future<Map<String, dynamic>> getAllDamageEntries() async {
    final response = await _dio.get('/damageEntry/all');
    return response.data;
  }

  Future<Map<String, dynamic>> deleteDamageEntry(String id) async {
    final response = await _dio.delete('/damageEntry/$id');
    return response.data;
  }

  // --- Product Exchange ---

  Future<Map<String, dynamic>> getAllProductExchanges() async {
    final response = await _dio.get('/productExchange/getall');
    return response.data;
  }

  Future<Map<String, dynamic>> getProductExchangeById(String id) async {
    final response = await _dio.get('/productExchange/get/$id');
    return response.data;
  }

  Future<Map<String, dynamic>> addProductExchange(Map<String, dynamic> data) async {
    final response = await _dio.post('/productExchange/add', data: data);
    return response.data;
  }

  Future<Map<String, dynamic>> updateProductExchange(String id, Map<String, dynamic> data) async {
    final response = await _dio.put('/productExchange/update/$id', data: data);
    return response.data;
  }

  Future<Map<String, dynamic>> deleteProductExchange(String id) async {
    final response = await _dio.delete('/productExchange/delete/$id');
    return response.data;
  }
}
