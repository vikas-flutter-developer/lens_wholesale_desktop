// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_exchange_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductExchangeModelImpl _$$ProductExchangeModelImplFromJson(
  Map<String, dynamic> json,
) => _$ProductExchangeModelImpl(
  id: json['_id'] as String?,
  billData: json['billData'] == null
      ? const ExchangeBillData()
      : ExchangeBillData.fromJson(json['billData'] as Map<String, dynamic>),
  partyData: json['partyData'] == null
      ? const ExchangePartyData()
      : ExchangePartyData.fromJson(json['partyData'] as Map<String, dynamic>),
  exchangeOutItems:
      (json['exchangeOutItems'] as List<dynamic>?)
          ?.map((e) => ExchangeItemModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  exchangeInItems:
      (json['exchangeInItems'] as List<dynamic>?)
          ?.map((e) => ExchangeItemModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  totals: json['totals'] == null
      ? const ExchangeTotals()
      : ExchangeTotals.fromJson(json['totals'] as Map<String, dynamic>),
  remarks: json['remarks'] as String? ?? '',
  status: json['status'] as String? ?? 'Completed',
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
);

Map<String, dynamic> _$$ProductExchangeModelImplToJson(
  _$ProductExchangeModelImpl instance,
) => <String, dynamic>{
  '_id': instance.id,
  'billData': instance.billData,
  'partyData': instance.partyData,
  'exchangeOutItems': instance.exchangeOutItems,
  'exchangeInItems': instance.exchangeInItems,
  'totals': instance.totals,
  'remarks': instance.remarks,
  'status': instance.status,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};

_$ExchangeBillDataImpl _$$ExchangeBillDataImplFromJson(
  Map<String, dynamic> json,
) => _$ExchangeBillDataImpl(
  billSeries: json['billSeries'] as String? ?? 'Exchange',
  billNo: json['billNo'] as String? ?? '',
  date: json['date'] as String?,
  type: json['type'] as String? ?? 'Lens',
  godown: json['godown'] as String? ?? 'MT-1',
  bookedBy: json['bookedBy'] as String? ?? '',
);

Map<String, dynamic> _$$ExchangeBillDataImplToJson(
  _$ExchangeBillDataImpl instance,
) => <String, dynamic>{
  'billSeries': instance.billSeries,
  'billNo': instance.billNo,
  'date': instance.date,
  'type': instance.type,
  'godown': instance.godown,
  'bookedBy': instance.bookedBy,
};

_$ExchangePartyDataImpl _$$ExchangePartyDataImplFromJson(
  Map<String, dynamic> json,
) => _$ExchangePartyDataImpl(
  partyAccount: json['partyAccount'] as String? ?? '',
  address: json['address'] as String? ?? '',
  contactNumber: json['contactNumber'] as String? ?? '',
);

Map<String, dynamic> _$$ExchangePartyDataImplToJson(
  _$ExchangePartyDataImpl instance,
) => <String, dynamic>{
  'partyAccount': instance.partyAccount,
  'address': instance.address,
  'contactNumber': instance.contactNumber,
};

_$ExchangeItemModelImpl _$$ExchangeItemModelImplFromJson(
  Map<String, dynamic> json,
) => _$ExchangeItemModelImpl(
  id: json['_id'] as String?,
  code: json['code'] as String? ?? '',
  itemName: json['itemName'] as String? ?? '',
  unit: json['unit'] as String? ?? '',
  dia: json['dia'] as String? ?? '',
  eye: json['eye'] as String? ?? '',
  sph: (json['sph'] as num?)?.toDouble() ?? 0.0,
  cyl: (json['cyl'] as num?)?.toDouble() ?? 0.0,
  axis: (json['axis'] as num?)?.toDouble() ?? 0.0,
  add: (json['add'] as num?)?.toDouble() ?? 0.0,
  remark: json['remark'] as String? ?? '',
  qty: (json['qty'] as num?)?.toInt() ?? 0,
  price: (json['price'] as num?)?.toDouble() ?? 0.0,
  totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$$ExchangeItemModelImplToJson(
  _$ExchangeItemModelImpl instance,
) => <String, dynamic>{
  '_id': instance.id,
  'code': instance.code,
  'itemName': instance.itemName,
  'unit': instance.unit,
  'dia': instance.dia,
  'eye': instance.eye,
  'sph': instance.sph,
  'cyl': instance.cyl,
  'axis': instance.axis,
  'add': instance.add,
  'remark': instance.remark,
  'qty': instance.qty,
  'price': instance.price,
  'totalAmount': instance.totalAmount,
};

_$ExchangeTotalsImpl _$$ExchangeTotalsImplFromJson(Map<String, dynamic> json) =>
    _$ExchangeTotalsImpl(
      totalExchInQty: (json['totalExchInQty'] as num?)?.toInt() ?? 0,
      totalExchInAmnt: (json['totalExchInAmnt'] as num?)?.toDouble() ?? 0.0,
      totalExchOutQty: (json['totalExchOutQty'] as num?)?.toInt() ?? 0,
      totalExchOutAmnt: (json['totalExchOutAmnt'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$ExchangeTotalsImplToJson(
  _$ExchangeTotalsImpl instance,
) => <String, dynamic>{
  'totalExchInQty': instance.totalExchInQty,
  'totalExchInAmnt': instance.totalExchInAmnt,
  'totalExchOutQty': instance.totalExchOutQty,
  'totalExchOutAmnt': instance.totalExchOutAmnt,
};
