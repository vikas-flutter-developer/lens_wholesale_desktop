import 'package:flutter/material.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';
import 'package:dio/dio.dart';

class UserProvider with ChangeNotifier {
  List<UserModel> _users = [];
  bool _isLoading = false;
  String? _error;

  List<UserModel> get users => _users;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchUsers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await apiClient.dio.get('/superadmin/users');
      
      final data = response.data;
      if (data is Map<String, dynamic> && data['data'] != null) {
         _users = (data['data'] as List)
            .map((item) => UserModel.fromJson(item))
            .toList();
      } else if (data is List) {
         _users = data
            .map((item) => UserModel.fromJson(item))
            .toList();
      }
      _error = null;
    } on DioException catch (e) {
      _error = e.response?.data?['message'] ?? e.message ?? 'Failed to load users';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addUser(UserModel user) async {
    try {
      final response = await apiClient.dio.post('/superadmin/users', data: user.toJson());
      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchUsers();
        return true;
      }
      return false;
    } on DioException catch (e) {
      _error = e.response?.data?['message'] ?? e.message ?? 'Failed to add user';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateUser(UserModel user) async {
    try {
      final response = await apiClient.dio.put('/superadmin/users/${user.id}', data: user.toJson());
      if (response.statusCode == 200) {
        await fetchUsers();
        return true;
      }
      return false;
    } on DioException catch (e) {
      _error = e.response?.data?['message'] ?? e.message ?? 'Failed to update user';
      notifyListeners();
      return false;
    }
  }

  Future<bool> toggleUserStatus(String id, bool currentStatus) async {
    try {
      final response = await apiClient.dio.patch('/superadmin/users/$id/toggle', data: {
        'isActive': !currentStatus
      });
      if (response.statusCode == 200) {
        final index = _users.indexWhere((u) => u.id == id);
        if (index != -1) {
          _users[index] = _users[index].copyWith(isActive: !currentStatus);
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
