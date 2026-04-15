// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lens_sale_challan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LensSaleChallanModelImpl _$$LensSaleChallanModelImplFromJson(
  Map<String, dynamic> json,
) => _$LensSaleChallanModelImpl(
  id: json['_id'] as String?,
  billData: json['billData'] == null
      ? const SaleOrderBillData()
      : SaleOrderBillData.fromJson(json['billData'] as Map<String, dynamic>),
  partyData: json['partyData'] == null
      ? const SaleOrderPartyData()
      : SaleOrderPartyData.fromJson(json['partyData'] as Map<String, dynamic>),
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => SaleOrderItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  taxes:
      (json['taxes'] as List<dynamic>?)
          ?.map((e) => SaleOrderTax.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  orderQty: (json['orderQty'] as num?)?.toInt() ?? 0,
  usedQty: (json['usedQty'] as num?)?.toInt() ?? 0,
  balQty: (json['balQty'] as num?)?.toInt() ?? 0,
  grossAmount: (json['grossAmount'] as num?)?.toDouble() ?? 0.0,
  subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
  taxesAmount: (json['taxesAmount'] as num?)?.toDouble() ?? 0.0,
  netAmount: (json['netAmount'] as num?)?.toDouble() ?? 0.0,
  paidAmount: (json['paidAmount'] as num?)?.toDouble() ?? 0.0,
  dueAmount: (json['dueAmount'] as num?)?.toDouble() ?? 0.0,
  remark: json['remark'] as String?,
  status: json['status'] as String? ?? 'Pending',
  sourceSaleId: json['sourceSaleId'] as String?,
  companyId: json['companyId'] as String?,
);

Map<String, dynamic> _$$LensSaleChallanModelImplToJson(
  _$LensSaleChallanModelImpl instance,
) => <String, dynamic>{
  '_id': instance.id,
  'billData': instance.billData,
  'partyData': instance.partyData,
  'items': instance.items,
  'taxes': instance.taxes,
  'orderQty': instance.orderQty,
  'usedQty': instance.usedQty,
  'balQty': instance.balQty,
  'grossAmount': instance.grossAmount,
  'subtotal': instance.subtotal,
  'taxesAmount': instance.taxesAmount,
  'netAmount': instance.netAmount,
  'paidAmount': instance.paidAmount,
  'dueAmount': instance.dueAmount,
  'remark': instance.remark,
  'status': instance.status,
  'sourceSaleId': instance.sourceSaleId,
  'companyId': instance.companyId,
};
