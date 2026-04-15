import 'package:flutter/foundation.dart';
import '../../data/services/voucher_service.dart';
import '../../data/models/voucher_model.dart';

class VoucherProvider extends ChangeNotifier {
  final VoucherService _service = VoucherService();

  bool _isLoading = false;
  String? _error;
  List<VoucherModel> _vouchers = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<VoucherModel> get vouchers => _vouchers;

  Future<void> fetchVouchers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final res = await _service.getAllVouchers();
      if (res['success'] == true) {
        final List data = res['data'] ?? [];
        _vouchers = data.map((e) => VoucherModel.fromJson(e)).toList();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> getVoucherById(String id) async {
    try {
      return await _service.getVoucherById(id);
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<String?> fetchNextBillNo(String recordType, String billSeries) async {
    try {
      final res = await _service.getNextBillNo(recordType, billSeries);
      if (res['success'] == true && res['nextBillNo'] != null) {
        return res['nextBillNo'].toString();
      }
    } catch (e) {
      debugPrint("Error fetching next bill no: $e");
    }
    return null;
  }

  Future<Map<String, dynamic>> saveVoucher(Map<String, dynamic> data) async {
    try {
      return await _service.createVoucher(data);
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateVoucher(String id, Map<String, dynamic> data) async {
    try {
      return await _service.updateVoucher(id, data);
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> deleteVoucher(String id) async {
    try {
      final res = await _service.deleteVoucher(id);
      if (res['success'] == true) {
        _vouchers.removeWhere((v) => v.id == id);
        notifyListeners();
      }
      return res;
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }
}
