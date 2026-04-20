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

  List<Map<String, dynamic>> _groupProductOffers = [];
  List<Map<String, dynamic>> get groupProductOffers => _groupProductOffers;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isActionLoading = false;
  bool get isActionLoading => _isActionLoading;

  String? _error;
  String? get error => _error;

  UtilityProvider() {
    fetchShortcuts();
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

  Future<void> fetchOffersByGroup(String groupName) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await _service.fetchOffersByGroup(groupName);
      if (res['success'] == true) {
        _groupProductOffers = List<Map<String, dynamic>>.from(res['data'] ?? []);
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

  Future<bool> bulkUpsertGroupOffers(String groupName, List<Map<String, dynamic>> offers) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await _service.bulkUpsertOffers(groupName, offers);
      return res['success'] == true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Shortcut Key Logic
  Future<void> fetchShortcuts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await _service.fetchShortcuts();
      if (res is List) {
        _keyBindings = res.map((e) => KeyBinding.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addKeyBinding(KeyBinding binding) async {
    _isActionLoading = true;
    notifyListeners();
    try {
      final data = {
        'pageName': binding.pageName,
        'module': binding.module,
        'shortcutKey': binding.shortcutKey,
        'description': binding.description,
        'status': binding.status,
        'url': binding.url,
      };
      await _service.createShortcut(data);
      await fetchShortcuts();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateKeyBinding(String id, KeyBinding binding) async {
    _isActionLoading = true;
    notifyListeners();
    try {
      final data = {
        'pageName': binding.pageName,
        'module': binding.module,
        'shortcutKey': binding.shortcutKey,
        'description': binding.description,
        'status': binding.status,
        'url': binding.url,
      };
      await _service.updateShortcut(id, data);
      await fetchShortcuts();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteKeyBinding(String id) async {
    _isActionLoading = true;
    notifyListeners();
    try {
      await _service.deleteShortcut(id);
      await fetchShortcuts();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleKeyBindingStatus(String id, KeyBinding binding) async {
    final updatedBinding = binding.copyWith(
      status: binding.status == 'Enabled' ? 'Disabled' : 'Enabled'
    );
    await updateKeyBinding(id, updatedBinding);
  }

  Future<bool> resetShortcutToDefaults() async {
    _isActionLoading = true;
    notifyListeners();
    try {
      await _service.resetShortcuts();
      await fetchShortcuts();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }
}
