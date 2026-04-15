import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/api_client.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _token;
  Map<String, dynamic>? _user;

  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;
  Map<String, dynamic>? get user => _user;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('token');
    final savedUser = prefs.getString('user');

    if (savedToken != null && savedToken.isNotEmpty && savedUser != null) {
      _token = savedToken;
      try {
        _user = jsonDecode(savedUser);
        _isAuthenticated = true;
      } catch (e) {
        // Corrupted JSON parse
        await logout();
      }
    }
    notifyListeners();
  }

  Future<void> login(String role, String email, String password) async {
    try {
      final response = await apiClient.dio.post('/auth/login', data: {
        'role': role,
        'email': email,
        'password': password,
      });

      final String fetchedToken = response.data['token'];
      final Map<String, dynamic> fetchedUser = response.data['user'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', fetchedToken);
      await prefs.setString('user', jsonEncode(fetchedUser));

      _token = fetchedToken;
      _user = fetchedUser;
      _isAuthenticated = true;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> impersonate(String token, Map<String, dynamic> impersonatedUser) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Store original admin session if not already impersonating
    if (_user?['isImpersonated'] != true) {
      await prefs.setString('original_token', prefs.getString('token') ?? '');
      await prefs.setString('original_user', prefs.getString('user') ?? '');
    }

    final impUser = Map<String, dynamic>.from(impersonatedUser);
    impUser['isImpersonated'] = true;

    await prefs.setString('token', token);
    await prefs.setString('user', jsonEncode(impUser));

    _token = token;
    _user = impUser;
    notifyListeners();
  }

  Future<void> stopImpersonating() async {
    final prefs = await SharedPreferences.getInstance();
    final originalToken = prefs.getString('original_token');
    final originalUserStr = prefs.getString('original_user');

    if (originalToken != null && originalToken.isNotEmpty && 
        originalUserStr != null && originalUserStr.isNotEmpty) {
      
      await prefs.setString('token', originalToken);
      await prefs.setString('user', originalUserStr);
      await prefs.remove('original_token');
      await prefs.remove('original_user');

      _token = originalToken;
      _user = jsonDecode(originalUserStr);
      notifyListeners();
    } else {
      await logout();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
    await prefs.remove('original_token');
    await prefs.remove('original_user');

    _token = null;
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
