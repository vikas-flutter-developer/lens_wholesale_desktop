import 'package:flutter/material.dart';
import '../../../../core/network/api_client.dart';
import '../models/account_group_model.dart';
import 'package:dio/dio.dart';

class AccountGroupProvider with ChangeNotifier {
  List<AccountGroupModel> _accountGroups = [];
  bool _isLoading = false;
  String? _error;

  List<AccountGroupModel> get accountGroups => _accountGroups;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchAllAccountGroups() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await apiClient.dio.get('/account-groups/get-all-account-groups');
      final data = response.data;
      
      // Handle array or object results based on backend response pattern
      if (data is List) {
        _accountGroups = data.map((item) => AccountGroupModel.fromJson(item)).toList();
      } else if (data is Map<String, dynamic> && data['data'] != null) {
        _accountGroups = (data['data'] as List).map((item) => AccountGroupModel.fromJson(item)).toList();
      } else if (data is Map<String, dynamic> && data['groups'] != null) {
        _accountGroups = (data['groups'] as List).map((item) => AccountGroupModel.fromJson(item)).toList();
      }
      
      _error = null;
    } on DioException catch (e) {
      _error = e.response?.data?['message'] ?? e.message ?? 'Failed to load account groups';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addAccountGroup(AccountGroupModel group) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final response = await apiClient.dio.post('/account-groups/add-account-group', data: group.toJson());
      if (response.data?['success'] == true || response.statusCode == 200 || response.statusCode == 201) {
        await fetchAllAccountGroups();
        return true;
      }
      return false;
    } on DioException catch (e) {
      _error = e.response?.data?['message'] ?? e.message ?? 'Failed to add account group';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateAccountGroup(String id, AccountGroupModel group) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await apiClient.dio.put('/account-groups/update/$id', data: group.toJson());
      if (response.data?['success'] == true || response.statusCode == 200) {
        await fetchAllAccountGroups();
        return true;
      }
      return false;
    } on DioException catch (e) {
      _error = e.response?.data?['message'] ?? e.message ?? 'Failed to update account group';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteAccountGroup(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await apiClient.dio.delete('/account-groups/delete/$id');
      if (response.data?['success'] == true || response.statusCode == 200) {
        _accountGroups.removeWhere((g) => g.id == id);
        notifyListeners();
        return true;
      }
      return false;
    } on DioException catch (e) {
      _error = e.response?.data?['message'] ?? e.message ?? 'Failed to delete account group';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
