// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'power_range_library_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PowerRangeLibraryModelImpl _$$PowerRangeLibraryModelImplFromJson(
  Map<String, dynamic> json,
) => _$PowerRangeLibraryModelImpl(
  id: json['_id'] as String?,
  sphMin: (json['sphMin'] as num?)?.toDouble() ?? 0.0,
  sphMax: (json['sphMax'] as num?)?.toDouble() ?? 0.0,
  sphStep: (json['sphStep'] as num?)?.toDouble() ?? 0.25,
  cylMin: (json['cylMin'] as num?)?.toDouble() ?? 0.0,
  cylMax: (json['cylMax'] as num?)?.toDouble() ?? 0.0,
  cylStep: (json['cylStep'] as num?)?.toDouble() ?? 0.25,
  addMin: (json['addMin'] as num?)?.toDouble() ?? 0.0,
  addMax: (json['addMax'] as num?)?.toDouble() ?? 0.0,
  addStep: (json['addStep'] as num?)?.toDouble() ?? 0.25,
  label: json['label'] as String? ?? '',
  groupNames:
      (json['groupNames'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
);

Map<String, dynamic> _$$PowerRangeLibraryModelImplToJson(
  _$PowerRangeLibraryModelImpl instance,
) => <String, dynamic>{
  '_id': instance.id,
  'sphMin': instance.sphMin,
  'sphMax': instance.sphMax,
  'sphStep': instance.sphStep,
  'cylMin': instance.cylMin,
  'cylMax': instance.cylMax,
  'cylStep': instance.cylStep,
  'addMin': instance.addMin,
  'addMax': instance.addMax,
  'addStep': instance.addStep,
  'label': instance.label,
  'groupNames': instance.groupNames,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};
