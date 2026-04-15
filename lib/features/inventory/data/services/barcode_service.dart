import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/barcode_model.dart';

class BarcodeService {
  final Dio _dio = apiClient.dio;

  Future<BarcodeModel?> getBarcodeData(String barcode) async {
    try {
      final response = await _dio.get('/barcodes/$barcode');
      if (response.data['success'] == true) {
        // The backend returns lensData as a nested object in some cases
        // but BarcodeModel matches the Scanner Repo schema. 
        // We'll normalize here if needed.
        final data = response.data;
        if (data['source'] == 'scanner_repo') {
          return BarcodeModel.fromJson(data);
        } else if (data['lensData'] != null) {
          // If source is inventory_lens_combination or standalone_item
          final lensData = data['lensData'];
          return BarcodeModel(
            barcode: data['barcode'] ?? barcode,
            productId: data['productId'] ?? '',
            sph: (lensData['sph'] ?? 0).toDouble(),
            cyl: (lensData['cyl'] ?? 0).toDouble(),
            axis: (lensData['axis'] ?? 0).toDouble(),
            add: (lensData['add'] ?? 0).toDouble(),
            metadata: lensData,
          );
        }
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }

  Future<void> saveBarcodeData(BarcodeModel model) async {
    await _dio.post('/barcodes', data: model.toJson());
  }

  Future<void> bulkSaveBarcodeData(List<Map<String, dynamic>> scans) async {
    await _dio.post('/barcodes/bulk', data: {'scans': scans});
  }

  /// Handles QR Delivery Confirmation logic if the barcode is a JSON string
  Future<Map<String, dynamic>?> checkDeliveryQR(String barcode) async {
    try {
      final response = await _dio.get('/barcodes/$barcode');
      if (response.data['success'] == true && response.data['source'] == 'delivery_confirmation') {
        return response.data;
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
