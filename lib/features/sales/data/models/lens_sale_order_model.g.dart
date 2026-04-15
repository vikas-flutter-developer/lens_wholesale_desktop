// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lens_sale_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LensSaleOrderModelImpl _$$LensSaleOrderModelImplFromJson(
  Map<String, dynamic> json,
) => _$LensSaleOrderModelImpl(
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
  refNo: json['refNo'] as String?,
  deliveryDate: json['deliveryDate'] as String?,
  time: json['time'] as String?,
  remark: json['remark'] as String?,
  status: json['status'] as String? ?? 'Pending',
  parentStatus: json['parentStatus'] as String? ?? 'Pending',
  cancelReason: json['cancelReason'] as String?,
  settlementDate: json['settlementDate'] as String?,
  isOrderPlaced: json['isOrderPlaced'] as bool? ?? false,
  orderPlacedAt: json['orderPlacedAt'] as String?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
);

Map<String, dynamic> _$$LensSaleOrderModelImplToJson(
  _$LensSaleOrderModelImpl instance,
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
  'refNo': instance.refNo,
  'deliveryDate': instance.deliveryDate,
  'time': instance.time,
  'remark': instance.remark,
  'status': instance.status,
  'parentStatus': instance.parentStatus,
  'cancelReason': instance.cancelReason,
  'settlementDate': instance.settlementDate,
  'isOrderPlaced': instance.isOrderPlaced,
  'orderPlacedAt': instance.orderPlacedAt,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};

_$SaleOrderBillDataImpl _$$SaleOrderBillDataImplFromJson(
  Map<String, dynamic> json,
) => _$SaleOrderBillDataImpl(
  billSeries: json['billSeries'] as String? ?? '',
  billNo: json['billNo'] as String? ?? '',
  date: json['date'] as String?,
  billType: json['billType'] as String? ?? '',
  bankAccount: json['bankAccount'] as String? ?? '',
  godown: json['godown'] as String? ?? '',
  bookedBy: json['bookedBy'] as String? ?? '',
);

Map<String, dynamic> _$$SaleOrderBillDataImplToJson(
  _$SaleOrderBillDataImpl instance,
) => <String, dynamic>{
  'billSeries': instance.billSeries,
  'billNo': instance.billNo,
  'date': instance.date,
  'billType': instance.billType,
  'bankAccount': instance.bankAccount,
  'godown': instance.godown,
  'bookedBy': instance.bookedBy,
};

_$SaleOrderPartyDataImpl _$$SaleOrderPartyDataImplFromJson(
  Map<String, dynamic> json,
) => _$SaleOrderPartyDataImpl(
  id: json['_id'] as String?,
  partyAccount: json['partyAccount'] as String? ?? '',
  address: json['address'] as String? ?? '',
  contactNumber: json['contactNumber'] as String? ?? '',
  stateCode: json['stateCode'] as String? ?? '',
  creditLimit: (json['creditLimit'] as num?)?.toDouble() ?? 0.0,
  creditDays: (json['creditDays'] as num?)?.toInt() ?? 0,
  accountCategory: json['accountCategory'] as String? ?? '',
  currentBalance: json['currentBalance'] == null
      ? const CurrentBalance()
      : CurrentBalance.fromJson(json['currentBalance'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$SaleOrderPartyDataImplToJson(
  _$SaleOrderPartyDataImpl instance,
) => <String, dynamic>{
  '_id': instance.id,
  'partyAccount': instance.partyAccount,
  'address': instance.address,
  'contactNumber': instance.contactNumber,
  'stateCode': instance.stateCode,
  'creditLimit': instance.creditLimit,
  'creditDays': instance.creditDays,
  'accountCategory': instance.accountCategory,
  'currentBalance': instance.currentBalance,
};

_$CurrentBalanceImpl _$$CurrentBalanceImplFromJson(Map<String, dynamic> json) =>
    _$CurrentBalanceImpl(
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      type: json['type'] as String? ?? 'Dr',
    );

Map<String, dynamic> _$$CurrentBalanceImplToJson(
  _$CurrentBalanceImpl instance,
) => <String, dynamic>{'amount': instance.amount, 'type': instance.type};

_$SaleOrderItemImpl _$$SaleOrderItemImplFromJson(Map<String, dynamic> json) =>
    _$SaleOrderItemImpl(
      id: json['_id'] as String?,
      barcode: json['barcode'] as String? ?? '',
      itemName: json['itemName'] as String? ?? '',
      billItemName: json['billItemName'] as String? ?? '',
      vendorItemName: json['vendorItemName'] as String? ?? '',
      unit: json['unit'] as String? ?? '',
      dia: json['dia'] as String? ?? '',
      eye: json['eye'] as String? ?? '',
      sph: (json['sph'] as num?)?.toDouble() ?? 0.0,
      cyl: (json['cyl'] as num?)?.toDouble() ?? 0.0,
      axis: (json['axis'] as num?)?.toDouble() ?? 0.0,
      add: (json['add'] as num?)?.toDouble() ?? 0.0,
      qty: (json['qty'] as num?)?.toInt() ?? 0,
      isInvoiced: json['isInvoiced'] as bool? ?? false,
      isChallaned: json['isChallaned'] as bool? ?? false,
      salePrice: (json['salePrice'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      sellPrice: (json['sellPrice'] as num?)?.toDouble() ?? 0.0,
      purchasePrice: (json['purchasePrice'] as num?)?.toDouble() ?? 0.0,
      combinationId: json['combinationId'] as String? ?? '',
      orderNo: json['orderNo'] as String? ?? '',
      itemStatus: json['itemStatus'] as String? ?? 'Pending',
      remark: json['remark'] as String?,
      vendor: json['vendor'] as String?,
      partyName: json['partyName'] as String?,
      cancelReason: json['cancelReason'] as String?,
    );

Map<String, dynamic> _$$SaleOrderItemImplToJson(_$SaleOrderItemImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'barcode': instance.barcode,
      'itemName': instance.itemName,
      'billItemName': instance.billItemName,
      'vendorItemName': instance.vendorItemName,
      'unit': instance.unit,
      'dia': instance.dia,
      'eye': instance.eye,
      'sph': instance.sph,
      'cyl': instance.cyl,
      'axis': instance.axis,
      'add': instance.add,
      'qty': instance.qty,
      'isInvoiced': instance.isInvoiced,
      'isChallaned': instance.isChallaned,
      'salePrice': instance.salePrice,
      'discount': instance.discount,
      'totalAmount': instance.totalAmount,
      'sellPrice': instance.sellPrice,
      'purchasePrice': instance.purchasePrice,
      'combinationId': instance.combinationId,
      'orderNo': instance.orderNo,
      'itemStatus': instance.itemStatus,
      'remark': instance.remark,
      'vendor': instance.vendor,
      'partyName': instance.partyName,
      'cancelReason': instance.cancelReason,
    };

_$SaleOrderTaxImpl _$$SaleOrderTaxImplFromJson(Map<String, dynamic> json) =>
    _$SaleOrderTaxImpl(
      taxName: json['taxName'] as String? ?? '',
      type: json['type'] as String? ?? 'Additive',
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      meta: json['meta'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$SaleOrderTaxImplToJson(_$SaleOrderTaxImpl instance) =>
    <String, dynamic>{
      'taxName': instance.taxName,
      'type': instance.type,
      'percentage': instance.percentage,
      'amount': instance.amount,
      'meta': instance.meta,
    };
