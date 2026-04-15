import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../models/utility_models.dart';
import '../services/utility_service.dart';

class UtilityProvider extends ChangeNotifier {
  final UtilityService _service = UtilityService();

  static const List<Map<String, String>> systemPages = [
    {'label': 'Dashboard', 'value': '/'},
    {'label': 'Sale Order List', 'value': '/sales/lens-sale-order'},
    {'label': 'Add Sale Order', 'value': '/sales/add-lens-sale-order'},
    {'label': 'Sale Challan List', 'value': '/sales/lens-sale-challan'},
    {'label': 'Add Sale Challan', 'value': '/sales/add-lens-sale-challan'},
    {'label': 'Sale Invoice List', 'value': '/sales/lens-sale-invoices'},
    {'label': 'Add Sale Invoice', 'value': '/sales/add-lens-sale-invoice'},
    {'label': 'Purchase Order List', 'value': '/purchases/purchase-order'},
    {'label': 'Add Purchase Order', 'value': '/purchases/add-purchase-order'},
    {'label': 'Purchase Challan List', 'value': '/purchases/purchase-challan'},
    {'label': 'Add Purchase Challan', 'value': '/purchases/add-purchase-challan'},
    {'label': 'Rx Sale List', 'value': '/sales/rx-sale-list'},
    {'label': 'Rx Purchase List', 'value': '/purchases/rx/dashboard'},
    {'label': 'Voucher List', 'value': '/transaction/vouchers'},
    {'label': 'Add Voucher', 'value': '/transaction/add-voucher'},
    {'label': 'Lens Stock Report', 'value': '/lenstransaction/lensstockreport'},
    {'label': 'Party Wise Report', 'value': '/reports/inventory/party-wise-item'},
    {'label': 'Lens Location', 'value': '/inventory/lens-location'},
    {'label': 'Product Exchange', 'value': '/lenstransaction/add-product-exchange'},
    {'label': 'Damage & Shrinkage', 'value': '/lenstransaction/add-damage-entry'},
    {'label': 'Barcode Management', 'value': '/inventory/barcode-management'},
    {'label': 'Offers', 'value': '/utilities/offers'},
    {'label': 'Bulk Update', 'value': '/utilities/bulk-update'},
    {'label': 'Backup & Restore', 'value': '/utilities/backup-restore'},
    {'label': 'Shortcut Settings', 'value': '/utilities/shortcutkeys'},
    {'label': 'Day Book', 'value': '/reports/financial/daybook'},
    {'label': 'Cash/Bank Book', 'value': '/reports/financial/cashbank'},
    {'label': 'Account Ledger', 'value': '/reports/ledger/accountledger'},
    {'label': 'Outstanding Report', 'value': '/reports/outstanding'},
    {'label': 'Balance Sheet', 'value': '/reports/financial/balancesheet'},
    {'label': 'Profit & Loss', 'value': '/reports/financial/profitloss'},
    {'label': 'Account Group Master', 'value': '/masters/accountmaster/accountgroupmaster'},
    {'label': 'Account Master', 'value': '/masters/accountmaster/accountmaster'},
    {'label': 'Inventory Creation', 'value': '/masters/inventorymaster/creation'},
    {'label': 'Lens Price Master', 'value': '/masters/inventorymaster/lensprice'},
    {'label': 'Tax Category', 'value': '/masters/billandothermaster/taxcategory'},
  ];

  List<BackupLog> _backups = [];
  List<BackupLog> get backups => _backups;

  String _currentFilter = 'All';
  String get currentFilter => _currentFilter;

  List<AppOffer> _offers = [];
  List<AppOffer> get offers => _offers;

  List<KeyBinding> _keyBindings = [];
  List<KeyBinding> get keyBindings => _keyBindings;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isActionLoading = false;
  bool get isActionLoading => _isActionLoading;

  String? _error;
  String? get error => _error;

  UtilityProvider() {
    _loadKeyBindings();
  }

  void setFilter(String filter) {
    _currentFilter = filter;
    fetchBackups();
  }

  Future<void> fetchBackups() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await _service.fetchBackups(type: _currentFilter);
      if (res is List) {
        _backups = res.map((e) => BackupLog.fromJson(e as Map<String, dynamic>)).toList();
      } else {
        _error = "Unexpected response format from server";
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createBackup([String type = 'manual']) async {
    _isActionLoading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await _service.triggerBackup(type);
      if (res != null) {
        await fetchBackups();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteBackup(String id) async {
    _isActionLoading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await _service.deleteBackup(id);
      if (res != null) {
        await fetchBackups();
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  Future<bool> restoreBackup(String id) async {
    _isActionLoading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await _service.restoreBackup(id);
      return res != null;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  Future<void> downloadBackup(String id, String fileName) async {
    _isActionLoading = true;
    notifyListeners();
    try {
      final Response response = await _service.downloadBackup(id);
      final bytes = response.data as List<int>;

      Directory? downloadsDir;
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        downloadsDir = await getDownloadsDirectory();
      } else {
        downloadsDir = await getApplicationDocumentsDirectory();
      }

      if (downloadsDir != null) {
        final filePath = path.join(downloadsDir.path, fileName.endsWith('.zip') ? fileName : '$fileName.zip');
        final file = File(filePath);
        await file.writeAsBytes(bytes);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchOffers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await _service.fetchOffers();
      if (res['success'] == true) {
        _offers = (res['data'] as List? ?? [])
            .map((e) => AppOffer.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        _error = res['message']?.toString();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> bulkUpdateProducts(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      final res = await _service.performBulkUpdate(data);
      return res;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Shortcut Key Logic
  Future<void> _loadKeyBindings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedJson = prefs.getString('keyboard_shortcuts');
      
      if (savedJson != null) {
        final List<dynamic> decoded = json.decode(savedJson);
        _keyBindings = decoded.map((e) => KeyBinding.fromJson(e as Map<String, dynamic>)).toList();
      } else {
        _keyBindings = _getDefaultKeyBindings();
        await _saveKeyBindings();
      }
    } catch (e) {
      _keyBindings = _getDefaultKeyBindings();
    }
    notifyListeners();
  }

  List<KeyBinding> _getDefaultKeyBindings() {
    return [
      const KeyBinding(action: 'Sale Order', keyCombination: 'F1', module: 'Sale', url: '/sales/lens-sale-order'),
      const KeyBinding(action: 'Add Sale Order', keyCombination: 'F2', module: 'Sale', url: '/sales/add-lens-sale-order'),
      const KeyBinding(action: 'Purchase Order', keyCombination: 'F3', module: 'Purchase', url: '/purchases/purchase-order'),
      const KeyBinding(action: 'Lens Stock Report', keyCombination: 'F4', module: 'Reports', url: '/lenstransaction/lensstockreport'),
      const KeyBinding(action: 'Add Voucher', keyCombination: 'F5', module: 'Transaction', url: '/transaction/add-voucher'),
      const KeyBinding(action: 'Lens Location', keyCombination: 'F6', module: 'Reports', url: '/inventory/lens-location'),
      const KeyBinding(action: 'Day Book', keyCombination: 'F7', module: 'Reports', url: '/reports/financial/daybook'),
      const KeyBinding(action: 'Party Wise Item', keyCombination: 'F8', module: 'Reports', url: '/reports/inventory/party-wise-item'),
      const KeyBinding(action: 'Barcode Management', keyCombination: 'F9', module: 'Utilities', url: '/inventory/barcode-management'),
      const KeyBinding(action: 'Dashboard', keyCombination: 'Alt+D', module: 'Global', url: '/'),
      const KeyBinding(action: 'Offers', keyCombination: 'Alt+O', module: 'Utilities', url: '/utilities/offers'),
      const KeyBinding(action: 'Backup & Restore', keyCombination: 'Alt+B', module: 'Utilities', url: '/utilities/backup-restore'),
    ];
  }

  Future<void> _saveKeyBindings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = json.encode(_keyBindings.map((e) => e.toJson()).toList());
      await prefs.setString('keyboard_shortcuts', encoded);
    } catch (e) {
      debugPrint("Error saving shortcuts: $e");
    }
  }

  void addKeyBinding(KeyBinding binding) {
    _keyBindings.add(binding);
    _saveKeyBindings();
    notifyListeners();
  }

  void updateKeyBinding(int index, KeyBinding binding) {
    if (index >= 0 && index < _keyBindings.length) {
      _keyBindings[index] = binding;
      _saveKeyBindings();
      notifyListeners();
    }
  }

  void deleteKeyBinding(int index) {
    if (index >= 0 && index < _keyBindings.length) {
      _keyBindings.removeAt(index);
      _saveKeyBindings();
      notifyListeners();
    }
  }

  void toggleKeyBindingStatus(int index) {
    if (index >= 0 && index < _keyBindings.length) {
      final current = _keyBindings[index];
      _keyBindings[index] = current.copyWith(
        status: current.status == 'Enabled' ? 'Disabled' : 'Enabled'
      );
      _saveKeyBindings();
      notifyListeners();
    }
  }

  Future<void> resetToDefaults() async {
    _keyBindings = _getDefaultKeyBindings();
    await _saveKeyBindings();
    notifyListeners();
  }
}
