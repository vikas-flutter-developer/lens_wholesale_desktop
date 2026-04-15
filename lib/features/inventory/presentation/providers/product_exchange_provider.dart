import 'package:flutter/foundation.dart';
import '../../data/services/inventory_service.dart';

class ProductExchangeProvider extends ChangeNotifier {
  final InventoryService _service = InventoryService();

  bool _isLoading = false;
  String? _error;
  List<Map<String, dynamic>> _exchanges = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Map<String, dynamic>> get exchanges => _exchanges;

  Future<void> fetchExchanges() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final res = await _service.getAllProductExchanges();
      if (res['success'] == true) {
        _exchanges = List<Map<String, dynamic>>.from(res['data'] ?? []);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> getExchangeById(String id) async {
    try {
      return await _service.getProductExchangeById(id);
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> saveExchange(Map<String, dynamic> data) async {
    try {
      return await _service.addProductExchange(data);
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateExchange(String id, Map<String, dynamic> data) async {
    try {
      return await _service.updateProductExchange(id, data);
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> deleteExchange(String id) async {
    try {
      final res = await _service.deleteProductExchange(id);
      if (res['success'] == true) {
        await fetchExchanges(); // Refresh list after deletion
      }
      return res;
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // Logic to determine next bill number
  int getNextBillNo() {
    if (_exchanges.isEmpty) return 1;
    
    final nos = _exchanges.map((e) {
      final billData = e['billData'] ?? e['billdata'];
      if (billData == null) return 0;
      final billNo = billData['billNo'] ?? billData['billno'];
      return int.tryParse(billNo?.toString() ?? '0') ?? 0;
    }).toList();
    
    if (nos.isEmpty) return 1;
    final maxNo = nos.reduce((curr, next) => curr > next ? curr : next);
    return maxNo + 1;
  }
}
