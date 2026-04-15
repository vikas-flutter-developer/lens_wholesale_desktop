import 'package:flutter/material.dart';
import '../../../../core/network/api_client.dart';
import '../models/sale_return_model.dart';

class SaleReturnProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<SaleReturnModel> _returns = [];
  List<SaleReturnModel> get returns => _returns;

  Future<String> getNextBillNumberForParty(String partyName) async {
    try {
      final response = await apiClient.dio.post('/saleReturn/getNextBillNumber', data: {
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

  Future<Map<String, dynamic>> createReturn(Map<String, dynamic> returnData, {bool isRx = false}) async {
    _isLoading = true;
    notifyListeners();
    try {
      final endpoint = isRx ? '/rxSaleReturn/addRxSaleReturn' : '/saleReturn/addLensSaleReturn';
      final response = await apiClient.dio.post(endpoint, data: returnData);
      return response.data;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> editReturn(String id, Map<String, dynamic> returnData, {bool isRx = false}) async {
    _isLoading = true;
    notifyListeners();
    try {
      final endpoint = isRx ? '/rxSaleReturn/editRxSaleReturn/$id' : '/saleReturn/editLensSaleReturn/$id';
      final response = await apiClient.dio.put(endpoint, data: returnData);
      return response.data;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllReturns() async {
    _isLoading = true;
    notifyListeners();
    try {
      final responses = await Future.wait([
        apiClient.dio.get('/saleReturn/getAllLensSaleReturn'),
        apiClient.dio.get('/rxSaleReturn/getAllRxSaleReturn'),
      ]);

      List<SaleReturnModel> combinedData = [];

      if (responses[0].data['success'] == true) {
        final List data = responses[0].data['data'];
        combinedData.addAll(data.map((json) => SaleReturnModel.fromJson(json).copyWith(type: 'SALE RETURN')));
      }

      if (responses[1].data['success'] == true) {
        final List data = responses[1].data['data'];
        // Backend for RX might have a slightly different data wrap, usually data.data or data
        final List rxData = responses[1].data['data'] is List ? responses[1].data['data'] : (responses[1].data['data']['data'] ?? []);
        combinedData.addAll(rxData.map((json) => SaleReturnModel.fromJson(json).copyWith(type: 'RX SALE RETURN')));
      }

      // Sort by date descending
      combinedData.sort((a, b) {
        final dateA = DateTime.tryParse(a.billData.date ?? '') ?? DateTime(2000);
        final dateB = DateTime.tryParse(b.billData.date ?? '') ?? DateTime(2000);
        return dateB.compareTo(dateA);
      });

      _returns = combinedData;
    } catch (e) {
      debugPrint('Error fetching combined returns: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<SaleReturnModel?> fetchReturnById(String id, {bool isRx = false}) async {
    _isLoading = true;
    notifyListeners();
    try {
      final endpoint = isRx ? '/rxSaleReturn/getRxSaleReturn/$id' : '/saleReturn/getLensSaleReturn/$id';
      final response = await apiClient.dio.get(endpoint);
      if (response.data['success'] == true) {
        return SaleReturnModel.fromJson(response.data['data']['data']);
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching return: $e');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> deleteReturn(String id, {bool isRx = false}) async {
    try {
      final endpoint = isRx ? '/rxSaleReturn/deleteRxSaleReturn/$id' : '/saleReturn/deleteLensSaleReturn/$id';
      final response = await apiClient.dio.delete(endpoint);
      if (response.data['success'] == true) {
        _returns.removeWhere((r) => r.id == id);
        notifyListeners();
      }
      return response.data;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
