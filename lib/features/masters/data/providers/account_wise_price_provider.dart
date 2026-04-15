import 'package:flutter/material.dart';
import '../../../../core/network/api_client.dart';

class AccountWisePriceProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<Map<String, dynamic>> upsertAccountWisePrice(Map<String, dynamic> data) async {
    try {
      final response = await apiClient.dio.post('/accountWisePrice/upsert', data: data);
      return response.data;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<List<dynamic>> getAccountWisePrices(String accountId, {String type = "Sale"}) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await apiClient.dio.get('/accountWisePrice/getByAccount', queryParameters: {
        'accountId': accountId,
        'type': type,
      });
      return response.data['data'] ?? [];
    } catch (e) {
      return [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> bulkUpsertAccountWisePrices(List<Map<String, dynamic>> prices) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await apiClient.dio.post('/accountWisePrice/bulkUpsert', data: {'prices': prices});
      return response.data;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
