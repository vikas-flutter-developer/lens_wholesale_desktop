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
      await apiClient.dio.post(
        '/items/bulk-update',
        data: {'items': items.map((e) => e.toJson()).toList()},
      );
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
  double _parseDouble(dynamic val) {
    if (val == null) return 0.0;
    if (val is double) return val;
    if (val is int) return val.toDouble();
    if (val is String) return double.tryParse(val) ?? 0.0;
    return 0.0;
  }

  int _parseInt(dynamic val) {
    if (val == null) return 0;
    if (val is int) return val;
    if (val is double) return val.toInt();
    if (val is String)
      return int.tryParse(val) ?? double.tryParse(val)?.toInt() ?? 0;
    return 0;
  }

  void _sanitizeCombinations(Map<String, dynamic> rawData) {
    try {
      if (rawData['addGroups'] is List) {
        for (var group in rawData['addGroups']) {
          if (group is Map) {
            // Standardize addValue for the whole group if missing
            String? groupAddValue = group['addValue']?.toString();
            if (groupAddValue == null || groupAddValue.isEmpty) {
              // Try to extract from label: "ADD 1.25" -> "1.25"
              final label =
                  group['label']?.toString() ?? group['name']?.toString() ?? '';
              final match = RegExp(r"(\d+\.?\d*)").firstMatch(label);
              if (match != null) {
                groupAddValue = double.tryParse(
                  match.group(1)!,
                )?.toStringAsFixed(2);
              }
            } else {
              groupAddValue = double.tryParse(
                groupAddValue,
              )?.toStringAsFixed(2);
            }
            group['addValue'] = groupAddValue;

            if (group['combinations'] is List) {
              for (var comb in group['combinations']) {
                if (comb is Map) {
                  // Standardize barcode to string
                  comb['barcode'] = comb['barcode']?.toString() ?? '';

                  // Ensure sph and cyl have 2 decimal places for consistent key matching
                  for (var key in ['sph', 'cyl', 'add']) {
                    if (comb[key] != null) {
                      final val = double.tryParse(comb[key].toString()) ?? 0.0;
                      comb[key] = val.toStringAsFixed(2);
                    } else if (key == 'add' && groupAddValue != null) {
                      // Inherit ADD value from group if missing in combination
                      comb['add'] = groupAddValue;
                    }
                  }

                  // Standardize numeric fields
                  comb['alertQty'] = _parseInt(comb['alertQty']);
                  comb['initStock'] = _parseInt(comb['initStock']);
                  comb['pPrice'] = _parseDouble(comb['pPrice']);
                  comb['sPrice'] = _parseDouble(comb['sPrice']);

                  // Ensure axis and eye are strings
                  comb['axis'] = comb['axis']?.toString() ?? '0';
                  comb['eye'] = comb['eye']?.toString().toUpperCase() ?? 'RL';
                  if (comb['eye'] == 'BOTH' || comb['eye'] == 'R/L')
                    comb['eye'] = 'RL';
                }
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Sanitize error: $e');
    }
  }

  List<LensGroupModel> get lensGroups {
    return _lenses
        .map((l) {
          try {
            _sanitizeCombinations(l);
            return LensGroupModel.fromJson(l);
          } catch (e) {
            debugPrint('--- API Data Parsing Error ---');
            debugPrint('Error parsing lens record: $e');
            debugPrint('Problematic JSON: $l');
            debugPrint('------------------------------');
            return null; // Skip this record
          }
        })
        .whereType<LensGroupModel>()
        .toList();
  }

  Future<void> fetchAllLensPower() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await apiClient.dio.get('/lens/getAllLensPower');
      final dynamic rawData =
          response.data['data'] ?? response.data['lensPowers'] ?? response.data;

      if (rawData is List) {
        _lenses = List<Map<String, dynamic>>.from(rawData);
      } else if (rawData is Map && rawData['items'] is List) {
        _lenses = List<Map<String, dynamic>>.from(rawData['items']);
      } else if (rawData is Map && rawData['data'] is List) {
        _lenses = List<Map<String, dynamic>>.from(rawData['data']);
      } else {
        debugPrint(
          'fetchAllLensPower: Unexpected API structure: ${response.data}',
        );
      }
    } catch (e) {
      debugPrint('Error fetching lenses: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<LensGroupModel?> getLensPower({
    String? groupName,
    String? productName,
    String? id,
  }) async {
    try {
      final Map<String, dynamic> params = {};
      if (id != null && id.isNotEmpty) params['id'] = id;
      if (groupName != null && groupName.isNotEmpty)
        params['groupName'] = groupName;
      if (productName != null && productName.isNotEmpty)
        params['productName'] = productName;

      final response = await apiClient.dio.post(
        '/lens/getLensPower',
        data: params,
      );

      final dynamic rawData = response.data['data'] ?? response.data;
      if (rawData != null &&
          (rawData['_id'] != null || rawData['id'] != null)) {
        _sanitizeCombinations(rawData);
        return LensGroupModel.fromJson(rawData);
      }
      return null;
    } catch (e) {
      debugPrint('getLensPower error: $e');
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
      final response = await apiClient.dio.post(
        '/lens/resetAllPriceHighlights',
      );
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

  Future<void> editLensRate(Map<String, dynamic> data) async {
    try {
      await apiClient.dio.put('/lensRate/editLensRate', data: data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeLensPower(List<String> ids) async {
    try {
      // Logic from React: ApiClient.delete('/lens/deletelensPower', { data })
      await apiClient.dio.delete(
        '/lens/deletelensPower',
        data: {'id': ids.isNotEmpty ? ids.first : ''},
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> generateUniqueBarcode(Map<String, dynamic> data) async {
    try {
      final response = await apiClient.dio.post(
        '/lens/generateUniqueBarcode',
        data: data,
      );
      return response.data['barcode'];
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkBarcodeExists(String barcode) async {
    try {
      final response = await apiClient.dio.post(
        '/lens/checkBarcodeExists',
        data: {'barcode': barcode},
      );
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

  Future<Map<String, dynamic>> getCombinationStock(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await apiClient.dio.post(
        '/lens/getCombinationStock',
        data: data,
      );
      return response.data;
    } catch (e) {
      return {};
    }
  }

  Future<List<Map<String, dynamic>>> getPowerGroupsForProduct(
    String productName,
  ) async {
    try {
      final response = await apiClient.dio.get(
        '/lens/power-groups-for-product',
        queryParameters: {'productName': productName},
      );
      final dynamic rawData = response.data['data'] ?? response.data;
      if (rawData is List) {
        return List<Map<String, dynamic>>.from(rawData);
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching power groups for product: $e');
      return [];
    }
  }
}
