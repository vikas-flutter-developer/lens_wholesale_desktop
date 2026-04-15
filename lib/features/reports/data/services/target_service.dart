import '../../../../core/network/api_client.dart';
import '../models/target_model.dart';

class TargetService {
  Future<TargetReport> getSaleTargetReport(Map<String, dynamic> filters) async {
    final response = await apiClient.dio.post('/reports/sale-target/report', data: filters);
    return TargetReport.fromJson(response.data);
  }

  Future<TargetReport> getCollectionTargetReport(Map<String, dynamic> filters) async {
    final response = await apiClient.dio.post('/reports/collection-target/report', data: filters);
    return TargetReport.fromJson(response.data);
  }

  Future<bool> saveSaleTarget(TargetEntry entry) async {
    final response = await apiClient.dio.post('/reports/sale-target/save', data: entry.toJson());
    return response.data['success'] == true;
  }

  Future<bool> saveCollectionTarget(TargetEntry entry) async {
    final response = await apiClient.dio.post('/reports/collection-target/save', data: entry.toJson());
    return response.data['success'] == true;
  }

  Future<List<AgentPerformance>> getPartyTargetHistory(String partyName) async {
    final response = await apiClient.dio.get('/reports/sale-target/history/$partyName');
    if (response.data['success'] == true) {
      return (response.data['data'] as List)
          .map((e) => AgentPerformance.fromJson(e))
          .toList();
    }
    return [];
  }

  Future<List<AgentPerformance>> getCollectionTargetHistory(String partyName, String targetType) async {
    final response = await apiClient.dio.get('/reports/collection-target/history/$partyName/$targetType');
    if (response.data['success'] == true) {
      return (response.data['data'] as List)
          .map((e) => AgentPerformance.fromJson(e))
          .toList();
    }
    return [];
  }
}

final targetService = TargetService();
