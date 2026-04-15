import 'package:flutter/material.dart';
import '../../../../core/network/api_client.dart';
import '../models/lens_sale_order_model.dart';

class LensSaleOrderProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<LensSaleOrderModel> _orders = [];
  List<LensSaleOrderModel> get orders => _orders;

  // Next bill number state
  String _nextBillNo = '';
  String get nextBillNo => _nextBillNo;

  Future<String> getNextBillNumberForParty(String partyName) async {
    try {
      final response = await apiClient.dio.post('/lensSaleOrder/getNextBillNumber', data: {
        'partyName': partyName,
      });
      if (response.data['success'] == true) {
        return response.data['nextBillNumber'].toString();
      }
      return '1';
    } catch (e) {
      debugPrint('Error fetching next bill no: $e');
      return '1';
    }
  }

  Future<List<dynamic>> fetchSuggestions(String type) async {
    try {
      final response = await apiClient.dio.get('/suggestion/get-suggestions', queryParameters: {
        'type': type,
      });
      if (response.data['success'] == true) {
        return response.data['data'] ?? [];
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching suggestions: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> deleteSuggestion(String val, String type) async {
    try {
      final response = await apiClient.dio.post('/suggestion/delete-suggestion', data: {
        'val': val,
        'type': type,
      });
      return response.data;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> checkStockAvailability(Map<String, dynamic> item) async {
    try {
      final response = await apiClient.dio.post('/lens-location/check-stock', data: item);
      return response.data;
    } catch (e) {
      return {'success': false, 'message': e.toString(), 'available': 0};
    }
  }

  Future<Map<String, dynamic>> getOfferForProduct(String productId) async {
    try {
      final response = await apiClient.dio.get('/offer/getOfferForProduct', queryParameters: {
        'productId': productId,
      });
      return response.data;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> orderData) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await apiClient.dio.post('/lensSaleOrder/createLensSaleOrder', data: orderData);
      return response.data;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllOrders() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await apiClient.dio.get('/lensSaleOrder/getAllLensSaleOrder');
      if (response.data['success'] == true) {
        final List data = response.data['data'];
        _orders = data.map((json) => LensSaleOrderModel.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Error fetching orders: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> deleteOrder(String id) async {
    try {
      final response = await apiClient.dio.delete('/lensSaleOrder/deleteLensSaleOrder/$id');
      if (response.data['success'] == true) {
        _orders.removeWhere((o) => o.id == id);
        notifyListeners();
      }
      return response.data;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
