// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'damage_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DamageEntryModelImpl _$$DamageEntryModelImplFromJson(
  Map<String, dynamic> json,
) => _$DamageEntryModelImpl(
  id: json['_id'] as String?,
  billSeries: json['billSeries'] as String? ?? 'DMG',
  billNo: json['billNo'] as String? ?? '',
  date: json['date'] as String?,
  type: json['type'] as String? ?? 'Damage',
  godown: json['godown'] as String? ?? 'HO',
  remark: json['remark'] as String? ?? '',
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => DamageItemModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  totalQty: (json['totalQty'] as num?)?.toInt() ?? 0,
  totalAmt: (json['totalAmt'] as num?)?.toDouble() ?? 0.0,
  companyId: json['companyId'] as String?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
);

Map<String, dynamic> _$$DamageEntryModelImplToJson(
  _$DamageEntryModelImpl instance,
) => <String, dynamic>{
  '_id': instance.id,
  'billSeries': instance.billSeries,
  'billNo': instance.billNo,
  'date': instance.date,
  'type': instance.type,
  'godown': instance.godown,
  'remark': instance.remark,
  'items': instance.items,
  'totalQty': instance.totalQty,
  'totalAmt': instance.totalAmt,
  'companyId': instance.companyId,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};

_$DamageItemModelImpl _$$DamageItemModelImplFromJson(
  Map<String, dynamic> json,
) => _$DamageItemModelImpl(
  id: json['_id'] as String?,
  code: json['code'] as String? ?? '',
  itemName: json['itemName'] as String? ?? '',
  partyName: json['partyName'] as String? ?? '',
  orderNo: json['orderNo'] as String? ?? '',
  eye: json['eye'] as String? ?? '',
  sph: (json['sph'] as num?)?.toDouble() ?? 0.0,
  cyl: (json['cyl'] as num?)?.toDouble() ?? 0.0,
  axis: (json['axis'] as num?)?.toDouble() ?? 0.0,
  add: (json['add'] as num?)?.toDouble() ?? 0.0,
  qty: (json['qty'] as num?)?.toInt() ?? 0,
  price: (json['price'] as num?)?.toDouble() ?? 0.0,
  totalAmt: (json['totalAmt'] as num?)?.toDouble() ?? 0.0,
  combinationId: json['combinationId'] as String? ?? '',
);

Map<String, dynamic> _$$DamageItemModelImplToJson(
  _$DamageItemModelImpl instance,
) => <String, dynamic>{
  '_id': instance.id,
  'code': instance.code,
  'itemName': instance.itemName,
  'partyName': instance.partyName,
  'orderNo': instance.orderNo,
  'eye': instance.eye,
  'sph': instance.sph,
  'cyl': instance.cyl,
  'axis': instance.axis,
  'add': instance.add,
  'qty': instance.qty,
  'price': instance.price,
  'totalAmt': instance.totalAmt,
  'combinationId': instance.combinationId,
};
