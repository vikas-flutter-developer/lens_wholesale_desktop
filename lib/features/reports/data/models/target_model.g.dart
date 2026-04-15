// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'target_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TargetReportImpl _$$TargetReportImplFromJson(Map<String, dynamic> json) =>
    _$TargetReportImpl(
      success: json['success'] as bool,
      summary: json['summary'] == null
          ? null
          : TargetSummary.fromJson(json['summary'] as Map<String, dynamic>),
      data: (json['data'] as List<dynamic>)
          .map((e) => AgentPerformance.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$TargetReportImplToJson(_$TargetReportImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'summary': instance.summary,
      'data': instance.data,
    };

_$TargetSummaryImpl _$$TargetSummaryImplFromJson(Map<String, dynamic> json) =>
    _$TargetSummaryImpl(
      totalTarget: (json['totalTarget'] as num).toDouble(),
      totalAchieved: (json['totalAchieved'] as num).toDouble(),
      ratio: (json['ratio'] as num).toDouble(),
    );

Map<String, dynamic> _$$TargetSummaryImplToJson(_$TargetSummaryImpl instance) =>
    <String, dynamic>{
      'totalTarget': instance.totalTarget,
      'totalAchieved': instance.totalAchieved,
      'ratio': instance.ratio,
    };

_$AgentPerformanceImpl _$$AgentPerformanceImplFromJson(
  Map<String, dynamic> json,
) => _$AgentPerformanceImpl(
  partyName: json['partyName'] as String,
  targetAmount: (json['targetAmount'] as num).toDouble(),
  achieved: (json['achieved'] as num).toDouble(),
  difference: (json['difference'] as num).toDouble(),
  ratio: (json['ratio'] as num).toDouble(),
  status: json['status'] as String,
  targetId: json['targetId'] as String?,
  periodType: json['periodType'] as String,
  year: (json['year'] as num).toInt(),
  month: (json['month'] as num?)?.toInt(),
  quarter: (json['quarter'] as num?)?.toInt(),
);

Map<String, dynamic> _$$AgentPerformanceImplToJson(
  _$AgentPerformanceImpl instance,
) => <String, dynamic>{
  'partyName': instance.partyName,
  'targetAmount': instance.targetAmount,
  'achieved': instance.achieved,
  'difference': instance.difference,
  'ratio': instance.ratio,
  'status': instance.status,
  'targetId': instance.targetId,
  'periodType': instance.periodType,
  'year': instance.year,
  'month': instance.month,
  'quarter': instance.quarter,
};

_$TargetEntryImpl _$$TargetEntryImplFromJson(Map<String, dynamic> json) =>
    _$TargetEntryImpl(
      partyId: json['partyId'] as String,
      partyName: json['partyName'] as String,
      targetAmount: (json['targetAmount'] as num).toDouble(),
      periodType: json['periodType'] as String,
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num?)?.toInt(),
      quarter: (json['quarter'] as num?)?.toInt(),
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      targetType: json['targetType'] as String?,
    );

Map<String, dynamic> _$$TargetEntryImplToJson(_$TargetEntryImpl instance) =>
    <String, dynamic>{
      'partyId': instance.partyId,
      'partyName': instance.partyName,
      'targetAmount': instance.targetAmount,
      'periodType': instance.periodType,
      'year': instance.year,
      'month': instance.month,
      'quarter': instance.quarter,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'targetType': instance.targetType,
    };
