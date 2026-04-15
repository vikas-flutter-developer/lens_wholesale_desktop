import 'package:flutter/material.dart';
import '../../../../core/network/api_client.dart';
import '../models/item_group_model.dart';
import '../models/item_master_model.dart';
import '../models/lens_group_model.dart';

class ItemGroupProvider with ChangeNotifier {
  List<ItemGroupModel> _groups = [];
  bool _isLoading = false;

  List<ItemGroupModel> get groups => _groups;
  bool get isLoading => _isLoading;

  Future<void> fetchGroups() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await apiClient.dio.get('/groups');
      final List<dynamic> data = response.data['groups'] ?? [];
      _groups = data.map((json) => ItemGroupModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addGroup(ItemGroupModel group) async {
    try {
      await apiClient.dio.post('/groups/add-group', data: group.toJson());
      await fetchGroups();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateGroup(String id, ItemGroupModel group) async {
    try {
      await apiClient.dio.post('/groups/update/$id', data: group.toJson());
      await fetchGroups();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteGroup(String id) async {
    try {
      await apiClient.dio.delete('/groups/delete/$id');
      await fetchGroups();
    } catch (e) {
      rethrow;
    }
  }
}

class ItemMasterProvider with ChangeNotifier {
  List<ItemMasterModel> _items = [];
  bool _isLoading = false;

  List<ItemMasterModel> get items => _items;
  bool get isLoading => _isLoading;

  Future<void> fetchItems() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await apiClient.dio.get('/items');
      final List<dynamic> data = response.data['items'] ?? [];
      _items = data.map((json) => ItemMasterModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> fetchNextAlias() async {
    try {
      final response = await apiClient.dio.get('/items/next-alias');
      return response.data['nextAlias'].toString();
    } catch (e) {
      return null;
    }
  }

  Future<void> addItem(ItemMasterModel item) async {
    try {
      await apiClient.dio.post('/items/add-item', data: item.toJson());
      await fetchItems();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateItem(String id, ItemMasterModel item) async {
    try {
      await apiClient.dio.post('/items/update/$id', data: item.toJson());
      await fetchItems();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteItem(String id) async {
    try {
      await apiClient.dio.delete('/items/delete/$id');
      await fetchItems();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> bulkUpdateItems(List<ItemMasterModel> items) async {
    try {
      await apiClient.dio.post('/items/bulk-update', data: {
        'items': items.map((e) => e.toJson()).toList(),
      });
      await fetchItems();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> syncAllLenses() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await apiClient.dio.post('/lensRate/syncAll');
      return response.data['success'] == true;
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

class LensGroupProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Map<String, dynamic>> _lenses = [];
  List<Map<String, dynamic>> get lenses => _lenses;
  List<LensGroupModel> get lensGroups {
    return _lenses.map((l) {
      try {
        return LensGroupModel.fromJson(l);
      } catch (e) {
        debugPrint('--- API Data Parsing Error ---');
        debugPrint('Error parsing lens record: $e');
        debugPrint('Problematic JSON: $l');
        debugPrint('------------------------------');
        return null; // Skip this record
      }
    }).whereType<LensGroupModel>().toList();
  }

  Future<void> fetchAllLensPower() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await apiClient.dio.get('/lens/getAllLensPower');
      final dynamic rawData = response.data['data'] ?? response.data['lensPowers'] ?? response.data;
      
      if (rawData is List) {
        _lenses = List<Map<String, dynamic>>.from(rawData);
      } else if (rawData is Map && rawData['items'] is List) {
        _lenses = List<Map<String, dynamic>>.from(rawData['items']);
      } else if (rawData is Map && rawData['data'] is List) {
        _lenses = List<Map<String, dynamic>>.from(rawData['data']);
      } else {
        debugPrint('fetchAllLensPower: Unexpected API structure: ${response.data}');
      }
    } catch (e) {
      debugPrint('Error fetching lenses: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<LensGroupModel?> getLensPower({String? groupName, String? productName}) async {
    try {
      final data = groupName != null ? {'groupName': groupName} : {'productName': productName};
      final response = await apiClient.dio.post('/lens/getLensPower', data: data);
      
      final dynamic rawData = response.data['data'] ?? response.data;
      if (rawData != null && rawData['_id'] != null) {
        return LensGroupModel.fromJson(rawData);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getAllLensPower() async {
    try {
      final response = await apiClient.dio.get('/lens/getAllLensPower');
      final dynamic rawData = response.data['data'] ?? response.data;
      if (rawData is List) {
        return List<Map<String, dynamic>>.from(rawData);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> resetAllLensPriceHighlights() async {
    try {
      final response = await apiClient.dio.post('/lens/resetAllPriceHighlights');
      return response.data['success'] == true;
    } catch (e) {
      return false;
    }
  }

  Future<void> addLensPower(Map<String, dynamic> data) async {
    try {
      await apiClient.dio.post('/lens/createLensPower', data: data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> editLensPower(Map<String, dynamic> data) async {
    try {
      await apiClient.dio.put('/lens/editLensPower', data: data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeLensPower(List<String> ids) async {
    try {
      // Logic from React: ApiClient.delete('/lens/deletelensPower', { data })
      await apiClient.dio.delete('/lens/deletelensPower', data: {'ids': ids});
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> generateUniqueBarcode(Map<String, dynamic> data) async {
    try {
      final response = await apiClient.dio.post('/lens/generateUniqueBarcode', data: data);
      return response.data['barcode'];
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkBarcodeExists(String barcode) async {
    try {
      final response = await apiClient.dio.post('/lens/checkBarcodeExists', data: {'barcode': barcode});
      return response.data['exists'] == true;
    } catch (e) {
      return false;
    }
  }

  Future<List<dynamic>> getPowerRangeLibrary(String? groupName) async {
    try {
      final url = groupName != null 
        ? '/lens/power-range-library?groupName=${Uri.encodeComponent(groupName)}'
        : '/lens/power-range-library';
      final response = await apiClient.dio.get(url);
      return response.data['data'] ?? response.data ?? [];
    } catch (e) {
      return [];
    }
  }

  Future<void> updateLocations(Map<String, dynamic> data) async {
    try {
      await apiClient.dio.post('/lens/update-locations', data: data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getCombinationStock(Map<String, dynamic> data) async {
    try {
      final response = await apiClient.dio.post('/lens/getCombinationStock', data: data);
      return response.data;
    } catch (e) {
      return {};
    }
  }
}
