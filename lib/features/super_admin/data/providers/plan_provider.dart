import 'package:flutter/material.dart';
import '../../../../core/network/api_client.dart';
import '../models/plan_model.dart';
import 'package:dio/dio.dart';

class PlanProvider with ChangeNotifier {
  List<PlanModel> _plans = [];
  bool _isLoading = false;
  String? _error;

  List<PlanModel> get plans => _plans;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchPlans() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await apiClient.dio.get('/superadmin/plans');
      
      final data = response.data;
      if (data is Map<String, dynamic> && data['data'] != null) {
         _plans = (data['data'] as List)
            .map((item) => PlanModel.fromJson(item))
            .toList();
      } else if (data is List) {
         _plans = data
            .map((item) => PlanModel.fromJson(item))
            .toList();
      }
      _error = null;
    } on DioException catch (e) {
      _error = e.response?.data?['message'] ?? e.message ?? 'Failed to load plans';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addPlan(PlanModel plan) async {
    try {
      final response = await apiClient.dio.post('/superadmin/plans', data: plan.toJson());
      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchPlans();
        return true;
      }
      return false;
    } on DioException catch (e) {
      _error = e.response?.data?['message'] ?? e.message ?? 'Failed to add plan';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updatePlan(PlanModel plan) async {
    try {
      final response = await apiClient.dio.put('/superadmin/plans/${plan.id}', data: plan.toJson());
      if (response.statusCode == 200) {
        await fetchPlans();
        return true;
      }
      return false;
    } on DioException catch (e) {
      _error = e.response?.data?['message'] ?? e.message ?? 'Failed to update plan';
      notifyListeners();
      return false;
    }
  }

  Future<bool> togglePlanStatus(String id, bool currentStatus) async {
    try {
      final response = await apiClient.dio.patch('/superadmin/plans/$id/toggle', data: {
        'isActive': !currentStatus
      });
      if (response.statusCode == 200) {
        final index = _plans.indexWhere((p) => p.id == id);
        if (index != -1) {
          _plans[index] = _plans[index].copyWith(isActive: !currentStatus);
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
