import '../../../../core/network/api_client.dart';
import 'package:dio/dio.dart';

class OutstandingService {
  final Dio _dio = apiClient.dio;

  Future<Map<String, dynamic>> getOutstandingReport(Map<String, dynamic> params) async {
    final response = await _dio.post('/outstanding/report', data: params);
    return response.data;
  }

  Future<List<String>> getStations() async {
    final response = await _dio.get('/outstanding/stations');
    if (response.data != null && response.data['data'] != null) {
      return List<String>.from(response.data['data']);
    }
    return [];
  }

  Future<List<String>> getGroups() async {
    final response = await _dio.get('/outstanding/groups');
    if (response.data != null && response.data['data'] != null) {
      return List<String>.from(response.data['data']);
    }
    return [];
  }
}
