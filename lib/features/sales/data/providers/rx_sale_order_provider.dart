import 'package:flutter/material.dart';
import '../../../../core/network/api_client.dart';
import '../models/rx_sale_order_model.dart';

class RxSaleOrderProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<RxSaleOrderModel> _orders = [];
  List<RxSaleOrderModel> get orders => _orders;

  Future<String> getNextBillNumberForParty(String partyName) async {
    try {
      final response = await apiClient.dio.post('/rxSaleOrder/getNextBillNumber', data: {
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

  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> orderData) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await apiClient.dio.post('/rxSaleOrder/createRxSaleOrder', data: orderData);
      return response.data;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> editOrder(String id, Map<String, dynamic> orderData) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await apiClient.dio.put('/rxSaleOrder/editRxSaleOrder/$id', data: orderData);
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
      final response = await apiClient.dio.get('/rxSaleOrder/getAllRxSaleOrder');
      if (response.data['success'] == true) {
        final List data = response.data['data'];
        _orders = data.map((json) => RxSaleOrderModel.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Error fetching orders: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<RxSaleOrderModel?> fetchOrderById(String id) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await apiClient.dio.get('/rxSaleOrder/getRxSaleOrder/$id');
      if (response.data['success'] == true) {
        return RxSaleOrderModel.fromJson(response.data['data']['data']);
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching order: $e');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> deleteOrder(String id) async {
    try {
      final response = await apiClient.dio.delete('/rxSaleOrder/deleteRxSaleOrder/$id');
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
