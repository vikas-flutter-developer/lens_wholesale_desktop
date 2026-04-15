import 'package:flutter/material.dart';
import '../../../../core/network/api_client.dart';
import '../models/rx_sale_model.dart';

class RxSaleProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<RxSaleModel> _sales = [];
  List<RxSaleModel> get sales => _sales;

  Future<String> getNextBillNumberForParty(String partyName) async {
    try {
      final response = await apiClient.dio.post('/rxSale/getNextBillNumberForRxSale', data: {
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

  Future<Map<String, dynamic>> createSale(Map<String, dynamic> saleData) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await apiClient.dio.post('/rxSale/addRxSale', data: saleData);
      return response.data;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> editSale(String id, Map<String, dynamic> saleData) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await apiClient.dio.put('/rxSale/editRxSale/$id', data: saleData);
      return response.data;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllSales() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await apiClient.dio.get('/rxSale/getAllRxSale');
      if (response.data['success'] == true) {
        final List data = response.data['data'];
        _sales = data.map((json) => RxSaleModel.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Error fetching sales: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<RxSaleModel?> fetchSaleById(String id) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await apiClient.dio.get('/rxSale/getRxSale/$id');
      if (response.data['success'] == true) {
        return RxSaleModel.fromJson(response.data['data']['data']);
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching sale: $e');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> deleteSale(String id) async {
    try {
      final response = await apiClient.dio.delete('/rxSale/deleteRxSale/$id');
      if (response.data['success'] == true) {
        _sales.removeWhere((s) => s.id == id);
        notifyListeners();
      }
      return response.data;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
