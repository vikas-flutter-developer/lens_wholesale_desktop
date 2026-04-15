import 'package:flutter/material.dart';
import '../../../../core/network/api_client.dart';
import '../models/company_model.dart';
import 'package:dio/dio.dart';

class CompanyProvider with ChangeNotifier {
  List<CompanyModel> _companies = [];
  bool _isLoading = false;
  String? _error;

  List<CompanyModel> get companies => _companies;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchCompanies() async {
    _isLoading = true;
    _error = null;
    // Notify listeners so UI shows loading state
    notifyListeners();

    try {
      final response = await apiClient.dio.get('/superadmin/companies');
      
      final data = response.data;
      if (data is Map<String, dynamic> && data['data'] != null) {
         _companies = (data['data'] as List)
            .map((item) => CompanyModel.fromJson(item))
            .toList();
      } else if (data is List) {
         _companies = data
            .map((item) => CompanyModel.fromJson(item))
            .toList();
      }
      _error = null;
    } on DioException catch (e) {
      _error = e.response?.data?['message'] ?? e.message ?? 'Failed to load companies';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addCompany(CompanyModel company) async {
    try {
      final response = await apiClient.dio.post('/superadmin/companies', data: company.toJson());
      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchCompanies();
        return true;
      }
      return false;
    } on DioException catch (e) {
      _error = e.response?.data?['message'] ?? e.message ?? 'Failed to add company';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateCompany(CompanyModel company) async {
    try {
      final response = await apiClient.dio.put('/superadmin/companies/${company.id}', data: company.toJson());
      if (response.statusCode == 200) {
        await fetchCompanies();
        return true;
      }
      return false;
    } on DioException catch (e) {
      _error = e.response?.data?['message'] ?? e.message ?? 'Failed to update company';
      notifyListeners();
      return false;
    }
  }

  Future<bool> toggleCompanyStatus(String id, bool currentStatus) async {
    try {
      // Assuming a patch or standard put to toggle active status. 
      // Replace with actual toggle API if different.
      final response = await apiClient.dio.patch('/superadmin/companies/$id/toggle', data: {
        'isActive': !currentStatus
      });
      if (response.statusCode == 200) {
        final index = _companies.indexWhere((c) => c.id == id);
        if (index != -1) {
          _companies[index] = _companies[index].copyWith(isActive: !currentStatus);
          notifyListeners();
        }
        return true;
      }
      return false;
    } on DioException catch (e) {
      _error = e.response?.data?['message'] ?? e.message ?? 'Failed to toggle status';
      notifyListeners();
      return false;
    }
  }
}
