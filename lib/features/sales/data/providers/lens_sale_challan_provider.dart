import 'package:flutter/material.dart';
import '../../../../core/network/api_client.dart';
import '../models/lens_sale_challan_model.dart';
import '../models/lens_sale_order_model.dart';

class LensSaleChallanProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<LensSaleChallanModel> _challans = [];
  List<LensSaleChallanModel> get challans => _challans;

  Future<String> getNextBillNumberForParty(String partyName) async {
    try {
      final response = await apiClient.dio.post('/lensSaleChallan/getNextBillNumber', data: {
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

  Future<Map<String, dynamic>> createChallan(Map<String, dynamic> challanData) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await apiClient.dio.post('/lensSaleChallan/createLensSaleChallan', data: challanData);
      return response.data;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllChallans() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await apiClient.dio.get('/lensSaleChallan/getAllLensSaleChallan');
      if (response.data['success'] == true) {
        final List data = response.data['data'];
        _challans = data.map((json) => LensSaleChallanModel.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Error fetching challans: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> deleteChallan(String id) async {
    try {
      final response = await apiClient.dio.delete('/lensSaleChallan/deleteLensSaleChallan/$id');
      if (response.data['success'] == true) {
        _challans.removeWhere((c) => c.id == id);
        notifyListeners();
      }
      return response.data;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
