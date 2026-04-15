// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_return_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SaleReturnModelImpl _$$SaleReturnModelImplFromJson(
  Map<String, dynamic> json,
) => _$SaleReturnModelImpl(
  id: json['_id'] as String?,
  billData: json['billData'] == null
      ? const SaleOrderBillData()
      : SaleOrderBillData.fromJson(json['billData'] as Map<String, dynamic>),
  partyData: json['partyData'] == null
      ? const SaleOrderPartyData()
      : SaleOrderPartyData.fromJson(json['partyData'] as Map<String, dynamic>),
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => RxOrderItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  taxes:
      (json['taxes'] as List<dynamic>?)
          ?.map((e) => SaleOrderTax.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
  taxesAmount: (json['taxesAmount'] as num?)?.toDouble() ?? 0.0,
  netAmount: (json['netAmount'] as num?)?.toDouble() ?? 0.0,
  paidAmount: (json['paidAmount'] as num?)?.toDouble() ?? 0.0,
  dueAmount: (json['dueAmount'] as num?)?.toDouble() ?? 0.0,
  remark: json['remark'] as String?,
  status: json['status'] as String? ?? 'Pending',
  type: json['type'] as String? ?? 'SALE RETURN',
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
);

Map<String, dynamic> _$$SaleReturnModelImplToJson(
  _$SaleReturnModelImpl instance,
) => <String, dynamic>{
  '_id': instance.id,
  'billData': instance.billData,
  'partyData': instance.partyData,
  'items': instance.items,
  'taxes': instance.taxes,
  'subtotal': instance.subtotal,
  'taxesAmount': instance.taxesAmount,
  'netAmount': instance.netAmount,
  'paidAmount': instance.paidAmount,
  'dueAmount': instance.dueAmount,
  'remark': instance.remark,
  'status': instance.status,
  'type': instance.type,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};
