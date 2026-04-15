// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'utility_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BackupLogImpl _$$BackupLogImplFromJson(Map<String, dynamic> json) =>
    _$BackupLogImpl(
      id: json['_id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      size: (json['size'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      status: json['status'] as String,
      storageLocation: json['storageLocation'] as String? ?? 'local',
      cloudPath: json['cloudPath'] as String?,
      localPath: json['localPath'] as String?,
      error: json['error'] as String?,
      fileSize: json['fileSize'] as String?,
      fileName: json['fileName'] as String?,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      version: json['version'] as String? ?? '1.0.0',
    );

Map<String, dynamic> _$$BackupLogImplToJson(_$BackupLogImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'size': instance.size,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'status': instance.status,
      'storageLocation': instance.storageLocation,
      'cloudPath': instance.cloudPath,
      'localPath': instance.localPath,
      'error': instance.error,
      'fileSize': instance.fileSize,
      'fileName': instance.fileName,
      'timestamp': instance.timestamp?.toIso8601String(),
      'version': instance.version,
    };

_$AppOfferImpl _$$AppOfferImplFromJson(Map<String, dynamic> json) =>
    _$AppOfferImpl(
      id: json['_id'] as String,
      title: json['Title'] as String,
      description: json['Description'] as String?,
      discountValue: (json['DiscountValue'] as num).toDouble(),
      discountType: json['DiscountType'] as String,
      validFrom: DateTime.parse(json['ValidFrom'] as String),
      validTo: DateTime.parse(json['ValidTo'] as String),
      isActive: json['IsActive'] as bool? ?? true,
      bannerUrl: json['BannerUrl'] as String?,
    );

Map<String, dynamic> _$$AppOfferImplToJson(_$AppOfferImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'Title': instance.title,
      'Description': instance.description,
      'DiscountValue': instance.discountValue,
      'DiscountType': instance.discountType,
      'ValidFrom': instance.validFrom.toIso8601String(),
      'ValidTo': instance.validTo.toIso8601String(),
      'IsActive': instance.isActive,
      'BannerUrl': instance.bannerUrl,
    };

_$KeyBindingImpl _$$KeyBindingImplFromJson(Map<String, dynamic> json) =>
    _$KeyBindingImpl(
      id: json['_id'] as String?,
      action: json['action'] as String,
      keyCombination: json['keyCombination'] as String,
      status: json['status'] as String? ?? 'Enabled',
      module: json['module'] as String?,
      description: json['description'] as String?,
      url: json['url'] as String?,
    );

Map<String, dynamic> _$$KeyBindingImplToJson(_$KeyBindingImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'action': instance.action,
      'keyCombination': instance.keyCombination,
      'status': instance.status,
      'module': instance.module,
      'description': instance.description,
      'url': instance.url,
    };
