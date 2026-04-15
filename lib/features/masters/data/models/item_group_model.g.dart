// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ItemGroupModelImpl _$$ItemGroupModelImplFromJson(Map<String, dynamic> json) =>
    _$ItemGroupModelImpl(
      id: json['_id'] as String?,
      groupName: json['groupName'] as String? ?? '',
      date: json['date'] as String?,
      saleDiscount: (json['saleDiscount'] as num?)?.toDouble(),
      saleDiscountApplyAll: json['saleDiscountApplyAll'] as bool? ?? false,
      purchaseDiscount: (json['purchaseDiscount'] as num?)?.toDouble(),
      hsnCode: _parseString(json['hsnCode']),
      hsnApplyAll: json['hsnApplyAll'] as bool? ?? false,
      loyaltyPoint: (json['loyaltyPoint'] as num?)?.toInt(),
      loyaltyApplyAll: json['loyaltyApplyAll'] as bool? ?? false,
      textCategory1: _parseString(json['textCategory1']),
      textCategory1ApplyAll: json['textCategory1ApplyAll'] as bool? ?? false,
      codeg1Limit: _parseString(json['codeg1Limit']),
      taxCategory2: _parseString(json['taxCategory2']),
      alertNegativeQty: json['alertNegativeQty'] as bool? ?? false,
      restrictNegativeQty: json['restrictNegativeQty'] as bool? ?? false,
      canDelete: json['canDelete'] as bool? ?? true,
      createdAt: _parseString(json['createdAt']),
      updatedAt: _parseString(json['updatedAt']),
    );

Map<String, dynamic> _$$ItemGroupModelImplToJson(
  _$ItemGroupModelImpl instance,
) => <String, dynamic>{
  '_id': instance.id,
  'groupName': instance.groupName,
  'date': instance.date,
  'saleDiscount': instance.saleDiscount,
  'saleDiscountApplyAll': instance.saleDiscountApplyAll,
  'purchaseDiscount': instance.purchaseDiscount,
  'hsnCode': instance.hsnCode,
  'hsnApplyAll': instance.hsnApplyAll,
  'loyaltyPoint': instance.loyaltyPoint,
  'loyaltyApplyAll': instance.loyaltyApplyAll,
  'textCategory1': instance.textCategory1,
  'textCategory1ApplyAll': instance.textCategory1ApplyAll,
  'codeg1Limit': instance.codeg1Limit,
  'taxCategory2': instance.taxCategory2,
  'alertNegativeQty': instance.alertNegativeQty,
  'restrictNegativeQty': instance.restrictNegativeQty,
  'canDelete': instance.canDelete,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};
