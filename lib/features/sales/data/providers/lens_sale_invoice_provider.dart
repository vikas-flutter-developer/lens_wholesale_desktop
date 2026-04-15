import 'package:flutter/material.dart';
import '../../../../core/network/api_client.dart';
import '../models/lens_sale_invoice_model.dart';
import '../models/lens_sale_order_model.dart'; // Needed for shared types

class LensSaleInvoiceProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<LensSaleInvoiceModel> _invoices = [];
  List<LensSaleInvoiceModel> get invoices => _invoices;

  Future<String> getNextBillNumberForParty(String partyName) async {
    try {
      final response = await apiClient.dio.post('/lensSale/getNextBillNumber', data: {
        'partyName': partyName,
      });
      if (response.data['success'] == true) {
        return response.data['nextBillNumber'].toString();
      }
      return '1';
    } catch (e) {
      debugPrint('Error fetching next bill no: $e');
      return '1';
    }
  }

  Future<Map<String, dynamic>> createInvoice(Map<String, dynamic> invoiceData) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await apiClient.dio.post('/lensSale/addLensSale', data: invoiceData);
      return response.data;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllInvoices() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await apiClient.dio.get('/lensSale/getAllLensSale');
      if (response.data['success'] == true) {
        final List data = response.data['data'] ?? [];
        _invoices = data.map((json) => LensSaleInvoiceModel.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Error fetching invoices: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> updateStatus(String invoiceId, String status) async {
    try {
      final response = await apiClient.dio.put('/lensSale/updateSaleInvoiceStatus', data: {
        'invoiceId': invoiceId,
        'status': status,
      });
      if (response.data['success'] == true) {
        final index = _invoices.indexWhere((i) => i.id == invoiceId);
        if (index != -1) {
          _invoices[index] = _invoices[index].copyWith(status: status);
          notifyListeners();
        }
      }
      return response.data;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateDeliveryPerson(String invoiceId, String deliveryPerson) async {
     try {
       final response = await apiClient.dio.put('/lensSale/updateDeliveryPerson/$invoiceId', data: {
         'deliveryPerson': deliveryPerson
       });
       if (response.data['success'] == true) {
          final index = _invoices.indexWhere((i) => i.id == invoiceId);
          if (index != -1) {
            _invoices[index] = _invoices[index].copyWith(deliveryPerson: deliveryPerson);
            notifyListeners();
          }
       }
       return response.data;
     } catch (e) {
       return {'success': false, 'message': e.toString()};
     }
  }

  Future<Map<String, dynamic>> deleteInvoice(String id) async {
    try {
      final response = await apiClient.dio.delete('/lensSale/removeLensSale/$id');
      if (response.data['success'] == true) {
        _invoices.removeWhere((i) => i.id == id);
        notifyListeners();
      }
      return response.data;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
