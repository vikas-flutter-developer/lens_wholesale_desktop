import 'package:flutter/material.dart';
import '../../../../core/network/api_client.dart';

class PowerGroupPricingProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<Map<String, dynamic>> upsertPowerGroupPricing(List<Map<String, dynamic>> pricing) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await apiClient.dio.post('/productPowerGroupPricing/upsert', data: {'pricing': pricing});
      return response.data;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<dynamic>> getPowerGroupPricing(String partyId, {String priceType = "Sale"}) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await apiClient.dio.get('/productPowerGroupPricing/get', queryParameters: {
        'partyId': partyId,
        'priceType': priceType,
      });
      return response.data['data'] ?? [];
    } catch (e) {
      return [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
