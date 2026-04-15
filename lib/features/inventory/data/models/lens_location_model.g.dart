// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lens_location_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LensLocationModelImpl _$$LensLocationModelImplFromJson(
  Map<String, dynamic> json,
) => _$LensLocationModelImpl(
  godown: json['godown'] == null ? '-' : _parseString(json['godown']),
  rack: json['rack'] == null ? '-' : _parseString(json['rack']),
  box: json['box'] == null ? '-' : _parseString(json['box']),
);

Map<String, dynamic> _$$LensLocationModelImplToJson(
  _$LensLocationModelImpl instance,
) => <String, dynamic>{
  'godown': instance.godown,
  'rack': instance.rack,
  'box': instance.box,
};
