import 'package:freezed_annotation/freezed_annotation.dart';

part 'target_model.freezed.dart';
part 'target_model.g.dart';

@freezed
class TargetReport with _$TargetReport {
  const factory TargetReport({
    required bool success,
    TargetSummary? summary,
    required List<AgentPerformance> data,
  }) = _TargetReport;

  factory TargetReport.fromJson(Map<String, dynamic> json) => _$TargetReportFromJson(json);
}

@freezed
class TargetSummary with _$TargetSummary {
  const factory TargetSummary({
    required double totalTarget,
    required double totalAchieved,
    required double ratio,
  }) = _TargetSummary;

  factory TargetSummary.fromJson(Map<String, dynamic> json) => _$TargetSummaryFromJson(json);
}

@freezed
class AgentPerformance with _$AgentPerformance {
  const factory AgentPerformance({
    required String partyName,
    required double targetAmount,
    required double achieved,
    required double difference,
    required double ratio,
    required String status,
    String? targetId,
    required String periodType,
    required int year,
    int? month,
    int? quarter,
  }) = _AgentPerformance;

  factory AgentPerformance.fromJson(Map<String, dynamic> json) => _$AgentPerformanceFromJson(json);
}

@freezed
class TargetEntry with _$TargetEntry {
  const factory TargetEntry({
    required String partyId,
    required String partyName,
    required double targetAmount,
    required String periodType,
    required int year,
    int? month,
    int? quarter,
    required String startDate,
    required String endDate,
    String? targetType, // 'Customer' or 'Vendor' for Collection Targets
  }) = _TargetEntry;

  factory TargetEntry.fromJson(Map<String, dynamic> json) => _$TargetEntryFromJson(json);
}
