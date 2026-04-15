import 'package:flutter/material.dart';
import '../../../../core/network/api_client.dart';
import '../models/tax_category_model.dart';
import 'package:dio/dio.dart';

class TaxCategoryProvider with ChangeNotifier {
  List<TaxCategoryModel> _taxCategories = [];
  bool _isLoading = false;
  String? _error;

  List<TaxCategoryModel> get taxCategories => _taxCategories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchAllTaxCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await apiClient.dio.get('/tax/getAllTaxCategories');
      final data = response.data;
      
      if (data is List) {
        _taxCategories = data.map((item) => TaxCategoryModel.fromJson(item)).toList();
      } else if (data is Map<String, dynamic>) {
        // Handle variations in backend response
        final list = data['categories'] ?? data['taxCategories'] ?? data['data'] ?? [];
        if (list is List) {
          _taxCategories = list.map((item) => TaxCategoryModel.fromJson(item)).toList();
        }
      }
      _error = null;
    } on DioException catch (e) {
      _error = e.response?.data?['message'] ?? e.message ?? 'Failed to load tax categories';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addTaxCategory(TaxCategoryModel category) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await apiClient.dio.post('/tax/add-taxCategory', data: category.toJson());
      if (response.data?['success'] == true || response.statusCode == 200 || response.statusCode == 201) {
        await fetchAllTaxCategories();
        return true;
      }
      return false;
    } on DioException catch (e) {
      _error = e.response?.data?['message'] ?? e.message ?? 'Failed to add tax category';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateTaxCategory(String id, TaxCategoryModel category) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Backend expects { id, payload }
      final response = await apiClient.dio.put('/tax/edit-taxCategory', data: {
        'id': id,
        'payload': category.toJson(),
      });
      if (response.data?['success'] == true || response.statusCode == 200) {
        await fetchAllTaxCategories();
        return true;
      }
      return false;
    } on DioException catch (e) {
      _error = e.response?.data?['message'] ?? e.message ?? 'Failed to update tax category';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteTaxCategory(String id) async {
    try {
      // Backend expects { id } in data for DELETE
      final response = await apiClient.dio.delete('/tax/deleteTaxCategory', data: { 'id': id });
      if (response.data?['success'] == true || response.statusCode == 200) {
        _taxCategories.removeWhere((c) => c.id == id);
        notifyListeners();
        return true;
      }
      return false;
    } on DioException catch (e) {
      _error = e.response?.data?['message'] ?? e.message ?? 'Failed to delete tax category';
      return false;
    }
  }
}
