import 'package:flutter/material.dart';
import '../../../../core/network/api_client.dart';
import '../models/purchase_model.dart';

class PurchaseProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<PurchaseModel> _purchaseOrders = [];
  List<PurchaseModel> get purchaseOrders => _purchaseOrders;

  List<PurchaseModel> _purchaseChallans = [];
  List<PurchaseModel> get purchaseChallans => _purchaseChallans;

  List<PurchaseModel> _purchaseEntries = [];
  List<PurchaseModel> get purchaseEntries => _purchaseEntries;

  List<PurchaseModel> _rxOrders = [];
  List<PurchaseModel> get rxOrders => _rxOrders;

  List<PurchaseModel> _rxInvoices = [];
  List<PurchaseModel> get rxInvoices => _rxInvoices;

  List<PurchaseModel> _rxReturns = [];
  List<PurchaseModel> get rxReturns => _rxReturns;

  List<PurchaseModel> _clOrders = [];
  List<PurchaseModel> get clOrders => _clOrders;

  // --- Purchase Orders ---
  Future<void> fetchPurchaseOrders() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await apiClient.dio.get('/lensPurchaseOrder/getAllLensPurchaseOrder');
      if (response.data['success'] == true) {
        final List data = response.data['data'];
        _purchaseOrders = data.map((json) => PurchaseModel.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Error fetching POs: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> createPurchaseOrder(Map<String, dynamic> data) async {
    try {
      final response = await apiClient.dio.post('/lensPurchaseOrder/addLensPurchaseOrder', data: data);
      return response.data;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<String> getNextPONumber(String partyName) async {
    try {
      final response = await apiClient.dio.post('/lensPurchaseOrder/getNextBillNumber', data: {'partyName': partyName});
      if (response.data['success'] == true) return response.data['nextBillNumber'].toString();
      return '1';
    } catch (e) { return '1'; }
  }

  // --- Purchase Challans ---
  Future<void> fetchPurchaseChallans() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await apiClient.dio.get('/lensPurchaseChallan/getAllLensPurchaseChallan');
      if (response.data['success'] == true) {
        final List data = response.data['data'];
        _purchaseChallans = data.map((json) => PurchaseModel.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Error fetching Challans: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> createPurchaseChallan(Map<String, dynamic> data) async {
    try {
      final response = await apiClient.dio.post('/lensPurchaseChallan/addLensPurchaseChallan', data: data);
      return response.data;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<String> getNextChallanNumber(String partyName) async {
    try {
      final response = await apiClient.dio.post('/lensPurchaseChallan/getNextBillNumber', data: {'partyName': partyName});
      if (response.data['success'] == true) return response.data['nextBillNumber'].toString();
      return '1';
    } catch (e) { return '1'; }
  }

  // --- Purchase Entries (Invoices) ---
  Future<void> fetchPurchaseEntries() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await apiClient.dio.get('/purchase/getAllLensPurchase');
      if (response.data['success'] == true) {
        final List data = response.data['data'];
        _purchaseEntries = data.map((json) => PurchaseModel.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Error fetching Invoices: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> createPurchaseInvoice(Map<String, dynamic> data) async {
    try {
      final response = await apiClient.dio.post('/purchase/addLensPurchase', data: data);
      return response.data;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<String> getNextInvoiceNumber(String partyName) async {
    try {
      final response = await apiClient.dio.post('/purchase/getNextBillNumber', data: {'partyName': partyName});
      if (response.data['success'] == true) return response.data['nextBillNumber'].toString();
      return '1';
    } catch (e) { return '1'; }
  }

  // --- Single ID Fetching ---
  Future<PurchaseModel?> fetchPOById(String id) async {
    try {
      final response = await apiClient.dio.get('/lensPurchaseOrder/getLensPurchaseOrder/$id');
      if (response.data['success'] == true) return PurchaseModel.fromJson(response.data['data']['data'] ?? response.data['data']);
      return null;
    } catch (e) { return null; }
  }

  Future<PurchaseModel?> fetchChallanById(String id) async {
    try {
      final response = await apiClient.dio.get('/lensPurchaseChallan/getLensPurchaseChallan/$id');
      if (response.data['success'] == true) return PurchaseModel.fromJson(response.data['data']['data'] ?? response.data['data']);
      return null;
    } catch (e) { return null; }
  }

  Future<PurchaseModel?> fetchInvoiceById(String id) async {
    try {
      final response = await apiClient.dio.get('/purchase/getLensPurchase/$id');
      if (response.data['success'] == true) return PurchaseModel.fromJson(response.data['data']['data'] ?? response.data['data']);
      return null;
    } catch (e) { return null; }
  }

  // --- RX Procurement ---
  Future<void> fetchRxOrders() async {
    _isLoading = true; notifyListeners();
    try {
      final response = await apiClient.dio.get('/rxPurchaseOrder/getAllRxPurchaseOrder');
      if (response.data['success'] == true) {
        final List data = response.data['data'];
        _rxOrders = data.map((json) => PurchaseModel.fromJson(json)).toList();
      }
    } catch (e) { debugPrint('Error fetching Rx POs: $e'); } finally { _isLoading = false; notifyListeners(); }
  }

  Future<Map<String, dynamic>> createRxOrder(Map<String, dynamic> data) async {
    try {
      final response = await apiClient.dio.post('/rxPurchaseOrder/addRxPurchaseOrder', data: data);
      return response.data;
    } catch (e) { return {'success': false, 'message': e.toString()}; }
  }

  Future<String> getNextRxPONumber(String partyName) async {
    try {
      final response = await apiClient.dio.post('/rxPurchaseOrder/getNextBillNumber', data: {'partyName': partyName});
      if (response.data['success'] == true) return response.data['nextBillNumber'].toString();
      return '1';
    } catch (e) { return '1'; }
  }

  Future<void> fetchRxInvoices() async {
    _isLoading = true; notifyListeners();
    try {
      final response = await apiClient.dio.get('/rxPurchaseInvoice/getAllRxPurchaseInvoice');
      if (response.data['success'] == true) {
        final List data = response.data['data'];
        _rxInvoices = data.map((json) => PurchaseModel.fromJson(json)).toList();
      }
    } catch (e) { debugPrint('Error fetching Rx PIs: $e'); } finally { _isLoading = false; notifyListeners(); }
  }

  Future<Map<String, dynamic>> createRxInvoice(Map<String, dynamic> data) async {
    try {
      final response = await apiClient.dio.post('/rxPurchaseInvoice/addRxPurchaseInvoice', data: data);
      return response.data;
    } catch (e) { return {'success': false, 'message': e.toString()}; }
  }

  Future<void> fetchRxReturns() async {
    _isLoading = true; notifyListeners();
    try {
      final response = await apiClient.dio.get('/rxPurchaseReturn/getAllRxPurchaseReturn');
      if (response.data['success'] == true) {
        final List data = response.data['data'];
        _rxReturns = data.map((json) => PurchaseModel.fromJson(json)).toList();
      }
    } catch (e) { debugPrint('Error fetching Rx Returns: $e'); } finally { _isLoading = false; notifyListeners(); }
  }

  Future<Map<String, dynamic>> createRxReturn(Map<String, dynamic> data) async {
    try {
      final response = await apiClient.dio.post('/rxPurchaseReturn/addRxPurchaseReturn', data: data);
      return response.data;
    } catch (e) { return {'success': false, 'message': e.toString()}; }
  }

  // --- Contact Lens Procurement ---
  Future<void> fetchCLOrders() async {
    _isLoading = true; notifyListeners();
    try {
      final response = await apiClient.dio.get('/contactLensPurchaseOrder/getAllContactLensPurchaseOrder');
      if (response.data['success'] == true) {
        final List data = response.data['data'];
        _clOrders = data.map((json) => PurchaseModel.fromJson(json)).toList();
      }
    } catch (e) { debugPrint('Error fetching CL POs: $e'); } finally { _isLoading = false; notifyListeners(); }
  }

  Future<Map<String, dynamic>> createCLOrder(Map<String, dynamic> data) async {
    try {
      final response = await apiClient.dio.post('/contactLensPurchaseOrder/addContactLensPurchaseOrder', data: data);
      return response.data;
    } catch (e) { return {'success': false, 'message': e.toString()}; }
  }

  Future<String> getNextCLPONumber(String partyName) async {
    try {
      final response = await apiClient.dio.post('/contactLensPurchaseOrder/getNextBillNumber', data: {'partyName': partyName});
      if (response.data['success'] == true) return response.data['nextBillNumber'].toString();
      return '1';
    } catch (e) { return '1'; }
  }

  // --- Single ID Fetching ---
  Future<PurchaseModel?> fetchRxPOById(String id) async {
    try {
      final response = await apiClient.dio.get('/rxPurchaseOrder/getRxPurchaseOrder/$id');
      if (response.data['success'] == true) return PurchaseModel.fromJson(response.data['data']['data'] ?? response.data['data']);
      return null;
    } catch (e) { return null; }
  }

  Future<PurchaseModel?> fetchRxPIById(String id) async {
    try {
      final response = await apiClient.dio.get('/rxPurchaseInvoice/getRxPurchaseInvoice/$id');
      if (response.data['success'] == true) return PurchaseModel.fromJson(response.data['data']['data'] ?? response.data['data']);
      return null;
    } catch (e) { return null; }
  }

  Future<PurchaseModel?> fetchCLPOById(String id) async {
    try {
      final response = await apiClient.dio.get('/contactLensPurchaseOrder/getContactLensPurchaseOrder/$id');
      if (response.data['success'] == true) return PurchaseModel.fromJson(response.data['data']['data'] ?? response.data['data']);
      return null;
    } catch (e) { return null; }
  }

  // --- Deletion ---
  Future<Map<String, dynamic>> deletePurchase(String id, String module) async {
    String endpoint = '';
    switch (module) {
      case 'PO': endpoint = '/lensPurchaseOrder/deleteLensPurchaseOrder/$id'; break;
      case 'PC': endpoint = '/lensPurchaseChallan/deleteLensPurchaseChallan/$id'; break;
      case 'PI': endpoint = '/purchase/deleteLensPurchase/$id'; break;
      case 'RXPO': endpoint = '/rxPurchaseOrder/deleteRxPurchaseOrder/$id'; break;
      case 'RXPI': endpoint = '/rxPurchaseInvoice/deleteRxPurchaseInvoice/$id'; break;
      case 'RXPR': endpoint = '/rxPurchaseReturn/deleteRxPurchaseReturn/$id'; break;
      case 'CLPO': endpoint = '/contactLensPurchaseOrder/deleteContactLensPurchaseOrder/$id'; break;
    }
    try {
      final response = await apiClient.dio.delete(endpoint);
      if (response.data['success'] == true) {
        if (module == 'PO') _purchaseOrders.removeWhere((o) => o.id == id);
        if (module == 'PC') _purchaseChallans.removeWhere((o) => o.id == id);
        if (module == 'PI') _purchaseEntries.removeWhere((o) => o.id == id);
        if (module == 'RXPO') _rxOrders.removeWhere((o) => o.id == id);
        if (module == 'RXPI') _rxInvoices.removeWhere((o) => o.id == id);
        if (module == 'RXPR') _rxReturns.removeWhere((o) => o.id == id);
        if (module == 'CLPO') _clOrders.removeWhere((o) => o.id == id);
        notifyListeners();
      }
      return response.data;
    } catch (e) { return {'success': false, 'message': e.toString()}; }
  }
}
