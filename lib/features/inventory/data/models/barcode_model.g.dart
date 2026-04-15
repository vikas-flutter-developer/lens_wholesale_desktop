// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barcode_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BarcodeModelImpl _$$BarcodeModelImplFromJson(Map<String, dynamic> json) =>
    _$BarcodeModelImpl(
      id: json['_id'] as String?,
      companyId: json['companyId'] as String?,
      barcode: json['barcode'] as String,
      productId: json['productId'] as String,
      sph: (json['sph'] as num?)?.toDouble() ?? 0,
      cyl: (json['cyl'] as num?)?.toDouble() ?? 0,
      axis: (json['axis'] as num?)?.toDouble() ?? 0,
      add: (json['add'] as num?)?.toDouble() ?? 0,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$$BarcodeModelImplToJson(_$BarcodeModelImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'companyId': instance.companyId,
      'barcode': instance.barcode,
      'productId': instance.productId,
      'sph': instance.sph,
      'cyl': instance.cyl,
      'axis': instance.axis,
      'add': instance.add,
      'metadata': instance.metadata,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
