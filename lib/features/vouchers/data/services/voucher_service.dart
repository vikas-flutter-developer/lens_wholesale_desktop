import '../../../../core/network/api_client.dart';
import 'package:dio/dio.dart';

class VoucherService {
  final Dio _dio = apiClient.dio;

  Future<Map<String, dynamic>> getAllVouchers() async {
    final response = await _dio.get('/vouchers');
    return response.data;
  }

  Future<Map<String, dynamic>> getVoucherById(String id) async {
    final response = await _dio.get('/vouchers/$id');
    return response.data;
  }

  Future<Map<String, dynamic>> createVoucher(Map<String, dynamic> data) async {
    final response = await _dio.post('/vouchers', data: data);
    return response.data;
  }

  Future<Map<String, dynamic>> updateVoucher(String id, Map<String, dynamic> data) async {
    final response = await _dio.put('/vouchers/$id', data: data);
    return response.data;
  }

  Future<Map<String, dynamic>> deleteVoucher(String id) async {
    final response = await _dio.delete('/vouchers/$id');
    return response.data;
  }

  Future<Map<String, dynamic>> getNextBillNo(String recordType, String billSeries) async {
    final response = await _dio.get('/vouchers/nextBillNo', queryParameters: {
      'recordType': recordType,
      'billSeries': billSeries,
    });
    return response.data;
  }
}
