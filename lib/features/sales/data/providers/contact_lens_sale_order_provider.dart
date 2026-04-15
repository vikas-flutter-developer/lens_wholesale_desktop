import 'package:flutter/material.dart';
import '../../../../core/network/api_client.dart';
import '../models/contact_lens_sale_order_model.dart';
import '../models/lens_sale_order_model.dart'; // Needed for shared types

class ContactLensSaleOrderProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<ContactLensSaleOrderModel> _orders = [];
  List<ContactLensSaleOrderModel> get orders => _orders;

  Future<String> getNextBillNumberForParty(String partyName) async {
    try {
      final response = await apiClient.dio.post('/contactSaleOrder/getNextBillNumber', data: {
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
      final response = await apiClient.dio.post('/contactSaleOrder/addContactLensSaleOrder', data: orderData);
      return response.data;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<ContactLensSaleOrderModel?> fetchOrderById(String id) async {
    try {
      final response = await apiClient.dio.get('/contactSaleOrder/getContactLensSaleOrder/$id');
      if (response.data['success'] == true) {
         return ContactLensSaleOrderModel.fromJson(response.data['data']);
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching contact lens order: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> editOrder(String id, Map<String, dynamic> orderData) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await apiClient.dio.put('/contactSaleOrder/editContactLensSaleOrder/$id', data: orderData);
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
      final response = await apiClient.dio.get('/contactSaleOrder/getAllContactLensSaleOrder');
      if (response.data['success'] == true) {
        final List data = response.data['data'] ?? [];
        _orders = data.map((json) => ContactLensSaleOrderModel.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Error fetching contact lens orders: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> updateStatus(String orderId, String status) async {
    try {
      final response = await apiClient.dio.put('/contactSaleOrder/updateContactLensSaleOrderStatus', data: {
        'orderId': orderId,
        'status': status,
      });
      if (response.data['success'] == true) {
        final index = _orders.indexWhere((o) => o.id == orderId);
        if (index != -1) {
          _orders[index] = _orders[index].copyWith(status: status);
          notifyListeners();
        }
      }
      return response.data;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> deleteOrder(String id) async {
    try {
      final response = await apiClient.dio.delete('/contactSaleOrder/removeContactLensSaleOrder/$id');
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
