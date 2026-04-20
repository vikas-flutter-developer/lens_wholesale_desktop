import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';

class UtilityService {
  final Dio _dio = apiClient.dio;

  Future<dynamic> fetchBackups({String type = 'All'}) async {
    try {
      final response = await _dio.get('/backups', queryParameters: {'type': type});
      return response.data;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<dynamic> triggerBackup(String type) async {
    try {
      final response = await _dio.post('/backups/trigger', data: {'type': type});
      return response.data;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<dynamic> restoreBackup(String id) async {
    try {
      final response = await _dio.post('/backups/restore/$id');
      return response.data;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<dynamic> deleteBackup(String id) async {
    try {
      final response = await _dio.delete('/backups/$id');
      return response.data;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> downloadBackup(String id) async {
    return await _dio.get(
      '/backups/download/$id',
      options: Options(responseType: ResponseType.bytes),
    );
  }

  Future<Map<String, dynamic>> performBulkUpdate(Map<String, dynamic> data) async {
    try {
      final response = await _dio.put('/inventory/products/bulk-update', data: data);
      return response.data;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> fetchOffers() async {
    try {
      final response = await _dio.get('/utilities/offers');
      return response.data;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> saveOffer(Map<String, dynamic> offerData) async {
    try {
      final response = await _dio.post('/utilities/offers/save', data: offerData);
      return response.data;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> deleteOffer(String id) async {
    try {
      final response = await _dio.delete('/utilities/offers/delete/$id');
      return response.data;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> fetchOffersByGroup(String groupName) async {
    try {
      final response = await _dio.get('/offers/getByGroup', queryParameters: {'groupName': groupName});
      return response.data;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> bulkUpsertOffers(String groupName, List<Map<String, dynamic>> offers) async {
    try {
      final response = await _dio.post('/offers/bulkUpsert', data: {
        'groupName': groupName,
        'offers': offers,
      });
      return response.data;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Shortcut Key APIs
  Future<dynamic> fetchShortcuts() async {
    try {
      final response = await _dio.get('/shortcuts');
      return response.data;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<dynamic> createShortcut(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/shortcuts', data: data);
      return response.data;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<dynamic> updateShortcut(String id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put('/shortcuts/$id', data: data);
      return response.data;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<dynamic> deleteShortcut(String id) async {
    try {
      final response = await _dio.delete('/shortcuts/$id');
      return response.data;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<dynamic> resetShortcuts() async {
    try {
      final response = await _dio.post('/shortcuts/reset');
      return response.data;
    } catch (e) {
      throw e.toString();
    }
  }
}
