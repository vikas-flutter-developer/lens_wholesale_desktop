import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/settings_model.dart';

class SettingsProvider with ChangeNotifier {
  SystemSettingsModel? _settings;
  bool _isLoading = false;
  bool _isSaving = false;
  String? _error;
  String? _successMessage;

  SystemSettingsModel? get settings => _settings;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;
  String? get successMessage => _successMessage;

  Future<void> fetchSettings() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await apiClient.dio.get('/superadmin/settings');
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final raw = data['data'] ?? data;
        _settings = SystemSettingsModel.fromJson(raw as Map<String, dynamic>);
      }
      _error = null;
    } on DioException catch (e) {
      _error = e.response?.data?['message'] ?? e.message ?? 'Failed to load settings';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> saveSettings(SystemSettingsModel updated) async {
    _isSaving = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      final response = await apiClient.dio.put('/superadmin/settings', data: updated.toJson());
      if (response.statusCode == 200) {
        _settings = updated;
        _successMessage = 'Settings saved successfully!';
        notifyListeners();
        // Auto-clear success
        Future.delayed(const Duration(seconds: 3), () {
          _successMessage = null;
          notifyListeners();
        });
        return true;
      }
      return false;
    } on DioException catch (e) {
      _error = e.response?.data?['message'] ?? e.message ?? 'Failed to save settings';
      notifyListeners();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
