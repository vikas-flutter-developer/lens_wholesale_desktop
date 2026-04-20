import 'package:flutter/foundation.dart';
import '../../data/models/damage_entry_model.dart';
import '../../data/services/inventory_service.dart';
import '../../../../core/network/api_client.dart';

class InventoryProvider extends ChangeNotifier {
  final InventoryService _inventoryService = InventoryService();

  List<Map<String, dynamic>> _stockReport = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get stockReport => _stockReport;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchStockReport({
    String? lensGroup,
    String? companyId,
    String? godown,
    double? sph,
    double? cyl,
    double? axis,
    double? add,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _stockReport = await _inventoryService.getLensStockReport(
        lensGroup: lensGroup,
        companyId: companyId,
        godown: godown,
        sph: sph,
        cyl: cyl,
        axis: axis,
        add: add,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveLensLocationStock(List<Map<String, dynamic>> stocks) async {
    try {
      await _inventoryService.saveLensLocationStock(stocks);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<List<Map<String, dynamic>>> getLensLocationStock(Map<String, dynamic> data) async {
    try {
      return await _inventoryService.getLensLocationStock(data);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return [];
    }
  }

  Future<Map<String, dynamic>?> checkStockAvailability(List<Map<String, dynamic>> items) async {
    try {
      return await _inventoryService.checkStockAvailability(items);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  // --- Damage & Shrinkage ---

  List<DamageEntryModel> _damageEntries = [];
  List<DamageEntryModel> get damageEntries => _damageEntries;

  Future<void> fetchAllDamageEntries() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final res = await _inventoryService.getAllDamageEntries();
      if (res['success'] == true && res['data'] != null) {
        _damageEntries = (res['data'] as List)
            .map((e) => DamageEntryModel.fromJson(e))
            .toList();
      } else {
        _damageEntries = [];
        _error = res['error'] ?? 'Failed to fetch entries';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> deleteDamageEntry(String id) async {
    try {
      final res = await _inventoryService.deleteDamageEntry(id);
      if (res['success'] == true) {
        _damageEntries.removeWhere((e) => e.id == id);
        notifyListeners();
      }
      return res;
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<String> getNextDamageBillNo(String series) async {
    try {
      return await _inventoryService.getNextDamageBillNo(series);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return '';
    }
  }

  Future<Map<String, dynamic>> saveDamageEntry(Map<String, dynamic> data) async {
    try {
      return await _inventoryService.saveDamageEntry(data);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateDamageEntry(String id, Map<String, dynamic> data) async {
    try {
      return await _inventoryService.updateDamageEntry(id, data);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getDamageEntry(String id) async {
    try {
      return await _inventoryService.getDamageEntry(id);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return {'success': false, 'error': e.toString()};
    }
  }
}
