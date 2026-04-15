// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PurchaseModelImpl _$$PurchaseModelImplFromJson(Map<String, dynamic> json) =>
    _$PurchaseModelImpl(
      id: json['_id'] as String?,
      billData: json['billData'] == null
          ? const PurchaseBillData()
          : PurchaseBillData.fromJson(json['billData'] as Map<String, dynamic>),
      partyData: json['partyData'] == null
          ? const PurchasePartyData()
          : PurchasePartyData.fromJson(
              json['partyData'] as Map<String, dynamic>,
            ),
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => PurchaseItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      taxes:
          (json['taxes'] as List<dynamic>?)
              ?.map((e) => PurchaseTax.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      taxesAmount: (json['taxesAmount'] as num?)?.toDouble() ?? 0.0,
      netAmount: (json['netAmount'] as num?)?.toDouble() ?? 0.0,
      paidAmount: (json['paidAmount'] as num?)?.toDouble() ?? 0.0,
      dueAmount: (json['dueAmount'] as num?)?.toDouble() ?? 0.0,
      orderQty: (json['orderQty'] as num?)?.toInt() ?? 0,
      receivedQty: (json['receivedQty'] as num?)?.toInt() ?? 0,
      balQty: (json['balQty'] as num?)?.toInt() ?? 0,
      remark: json['remark'] as String?,
      status: json['status'] as String? ?? 'Pending',
      sourcePurchaseId: json['sourcePurchaseId'] as String?,
      orderType: json['orderType'] as String?,
      companyId: json['companyId'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$$PurchaseModelImplToJson(_$PurchaseModelImpl instance) =>
    <String, dynamic>{
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
      'orderQty': instance.orderQty,
      'receivedQty': instance.receivedQty,
      'balQty': instance.balQty,
      'remark': instance.remark,
      'status': instance.status,
      'sourcePurchaseId': instance.sourcePurchaseId,
      'orderType': instance.orderType,
      'companyId': instance.companyId,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

_$PurchaseBillDataImpl _$$PurchaseBillDataImplFromJson(
  Map<String, dynamic> json,
) => _$PurchaseBillDataImpl(
  billSeries: json['billSeries'] as String? ?? '',
  billNo: json['billNo'] as String? ?? '',
  date: json['date'] as String?,
  billType: json['billType'] as String? ?? '',
  godown: json['godown'] as String? ?? '',
  bookedBy: json['bookedBy'] as String? ?? '',
  bankAccount: json['bankAccount'] as String? ?? '',
);

Map<String, dynamic> _$$PurchaseBillDataImplToJson(
  _$PurchaseBillDataImpl instance,
) => <String, dynamic>{
  'billSeries': instance.billSeries,
  'billNo': instance.billNo,
  'date': instance.date,
  'billType': instance.billType,
  'godown': instance.godown,
  'bookedBy': instance.bookedBy,
  'bankAccount': instance.bankAccount,
};

_$PurchasePartyDataImpl _$$PurchasePartyDataImplFromJson(
  Map<String, dynamic> json,
) => _$PurchasePartyDataImpl(
  partyAccount: json['partyAccount'] as String? ?? '',
  contactNumber: json['contactNumber'] as String? ?? '',
  address: json['address'] as String? ?? '',
  stateCode: json['stateCode'] as String? ?? '',
  creditLimit: (json['creditLimit'] as num?)?.toDouble() ?? 0.0,
  currentBalance: json['currentBalance'] == null
      ? const CurrentBalance()
      : CurrentBalance.fromJson(json['currentBalance'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$PurchasePartyDataImplToJson(
  _$PurchasePartyDataImpl instance,
) => <String, dynamic>{
  'partyAccount': instance.partyAccount,
  'contactNumber': instance.contactNumber,
  'address': instance.address,
  'stateCode': instance.stateCode,
  'creditLimit': instance.creditLimit,
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

_$PurchaseItemImpl _$$PurchaseItemImplFromJson(Map<String, dynamic> json) =>
    _$PurchaseItemImpl(
      id: json['_id'] as String?,
      barcode: json['barcode'] as String? ?? '',
      itemName: json['itemName'] as String? ?? '',
      billItemName: json['billItemName'] as String? ?? '',
      vendorItemName: json['vendorItemName'] as String? ?? '',
      orderNo: json['orderNo'] as String? ?? '',
      eye: json['eye'] as String? ?? '',
      sph: json['sph'] as String? ?? '',
      cyl: json['cyl'] as String? ?? '',
      axis: json['axis'] as String? ?? '',
      add: json['add'] as String? ?? '',
      qty: (json['qty'] as num?)?.toInt() ?? 0,
      purchasePrice: (json['purchasePrice'] as num?)?.toDouble() ?? 0.0,
      salePrice: (json['salePrice'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      dia: json['dia'] as String? ?? '',
      mrp: (json['mrp'] as num?)?.toDouble() ?? 0.0,
      expiryDate: json['expiryDate'] as String?,
      importDate: json['importDate'] as String?,
      combinationId: json['combinationId'] as String? ?? '',
      vendor: json['vendor'] as String? ?? '',
      remark: json['remark'] as String?,
      saleOrderItemId: json['saleOrderItemId'] as String?,
    );

Map<String, dynamic> _$$PurchaseItemImplToJson(_$PurchaseItemImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'barcode': instance.barcode,
      'itemName': instance.itemName,
      'billItemName': instance.billItemName,
      'vendorItemName': instance.vendorItemName,
      'orderNo': instance.orderNo,
      'eye': instance.eye,
      'sph': instance.sph,
      'cyl': instance.cyl,
      'axis': instance.axis,
      'add': instance.add,
      'qty': instance.qty,
      'purchasePrice': instance.purchasePrice,
      'salePrice': instance.salePrice,
      'discount': instance.discount,
      'totalAmount': instance.totalAmount,
      'dia': instance.dia,
      'mrp': instance.mrp,
      'expiryDate': instance.expiryDate,
      'importDate': instance.importDate,
      'combinationId': instance.combinationId,
      'vendor': instance.vendor,
      'remark': instance.remark,
      'saleOrderItemId': instance.saleOrderItemId,
    };

_$PurchaseTaxImpl _$$PurchaseTaxImplFromJson(Map<String, dynamic> json) =>
    _$PurchaseTaxImpl(
      id: json['_id'] as String?,
      taxName: json['taxName'] as String? ?? '',
      type: json['type'] as String? ?? 'Additive',
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$PurchaseTaxImplToJson(_$PurchaseTaxImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'taxName': instance.taxName,
      'type': instance.type,
      'percentage': instance.percentage,
      'amount': instance.amount,
    };
