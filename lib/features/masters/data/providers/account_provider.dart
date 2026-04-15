import 'package:flutter/foundation.dart';
import '../../../../core/network/api_client.dart';
import '../models/account_model.dart';

class AccountProvider with ChangeNotifier {
  List<AccountModel> _accounts = [];
  bool _isLoading = false;
  String? _error;

  List<AccountModel> get accounts => _accounts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final ApiClient _apiClient = ApiClient(); // Factory returns singleton
  
  Future<void> fetchAllAccounts({String? type}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await apiClient.dio.get('/accounts/getallaccounts', queryParameters: type != null ? {'type': type} : null);
      if (response.data is List) {
        _accounts = (response.data as List).map((json) => AccountModel.fromJson(json)).toList();
      } else {
        _accounts = [];
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<AccountModel?> fetchAccountById(String id) async {
    try {
      final response = await apiClient.dio.get('/accounts/get/$id');
      if (response.data['success'] == true) {
        return AccountModel.fromJson(response.data['account']);
      }
    } catch (e) {
      _error = e.toString();
    }
    return null;
  }

  Future<String?> fetchNextAccountId() async {
    try {
      final response = await apiClient.dio.get('/accounts/next-id');
      if (response.data['success'] == true) {
        return response.data['nextAccountId']?.toString();
      }
    } catch (e) {
      debugPrint("Error fetching next ID: $e");
    }
    return null;
  }

  Future<bool> addAccount(AccountModel account) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await apiClient.dio.post('/accounts/add-account', data: account.toJson());
      if (response.data['success'] == true) {
        await fetchAllAccounts();
        return true;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }

  Future<bool> updateAccount(String id, AccountModel account) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await apiClient.dio.put('/accounts/update/$id', data: account.toJson());
      if (response.data['success'] == true) {
        await fetchAllAccounts();
        return true;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }

  Future<bool> deleteAccount(String id) async {
    try {
      final response = await apiClient.dio.delete('/accounts/delete/$id');
      if (response.data['success'] == true) {
        _accounts.removeWhere((a) => a.id == id);
        notifyListeners();
        return true;
      }
    } catch (e) {
      _error = e.toString();
    }
    return false;
  }
}
