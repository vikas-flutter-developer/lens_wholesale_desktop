import '../../../../core/network/api_client.dart';

class AnalyticsService {
  final ApiClient apiClient;

  AnalyticsService({ApiClient? apiClient}) : apiClient = apiClient ?? ApiClient();

  Future<Map<String, dynamic>> getAnalyticsSummary() async {
    try {
      final response = await apiClient.dio.get('/active/analytics');
      if (response.data['success']) {
        return response.data;
      } else {
        throw Exception(response.data['message'] ?? 'Failed to fetch analytics');
      }
    } catch (e) {
      rethrow;
    }
  }
}
