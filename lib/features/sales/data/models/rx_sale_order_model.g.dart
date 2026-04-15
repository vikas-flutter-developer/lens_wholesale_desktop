// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rx_sale_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RxOrderItemImpl _$$RxOrderItemImplFromJson(Map<String, dynamic> json) =>
    _$RxOrderItemImpl(
      id: json['_id'] as String?,
      barcode: json['barcode'] as String? ?? '',
      itemName: json['itemName'] as String? ?? '',
      billItemName: json['billItemName'] as String? ?? '',
      vendorItemName: json['vendorItemName'] as String? ?? '',
      unit: json['unit'] as String? ?? '',
      orderNo: json['orderNo'] as String? ?? '',
      dia: json['dia'] as String? ?? '',
      eye: json['eye'] as String? ?? '',
      sph: (json['sph'] as num?)?.toDouble() ?? 0.0,
      cyl: (json['cyl'] as num?)?.toDouble() ?? 0.0,
      axis: (json['axis'] as num?)?.toDouble() ?? 0.0,
      add: (json['add'] as num?)?.toDouble() ?? 0.0,
      qty: (json['qty'] as num?)?.toInt() ?? 0,
      salePrice: (json['salePrice'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      sellPrice: (json['sellPrice'] as num?)?.toDouble() ?? 0.0,
      purchasePrice: (json['purchasePrice'] as num?)?.toDouble() ?? 0.0,
      combinationId: json['combinationId'] as String? ?? '',
      customer: json['customer'] as String? ?? '',
      vendor: json['vendor'] as String? ?? '',
      itemStatus: json['itemStatus'] as String? ?? 'Pending',
      remark: json['remark'] as String?,
      mrp: (json['mrp'] as num?)?.toDouble() ?? 0.0,
      refId: json['refId'] as String?,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$$RxOrderItemImplToJson(_$RxOrderItemImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'barcode': instance.barcode,
      'itemName': instance.itemName,
      'billItemName': instance.billItemName,
      'vendorItemName': instance.vendorItemName,
      'unit': instance.unit,
      'orderNo': instance.orderNo,
      'dia': instance.dia,
      'eye': instance.eye,
      'sph': instance.sph,
      'cyl': instance.cyl,
      'axis': instance.axis,
      'add': instance.add,
      'qty': instance.qty,
      'salePrice': instance.salePrice,
      'discount': instance.discount,
      'totalAmount': instance.totalAmount,
      'sellPrice': instance.sellPrice,
      'purchasePrice': instance.purchasePrice,
      'combinationId': instance.combinationId,
      'customer': instance.customer,
      'vendor': instance.vendor,
      'itemStatus': instance.itemStatus,
      'remark': instance.remark,
      'mrp': instance.mrp,
      'refId': instance.refId,
      'createdAt': instance.createdAt,
    };

_$RxSaleOrderModelImpl _$$RxSaleOrderModelImplFromJson(
  Map<String, dynamic> json,
) => _$RxSaleOrderModelImpl(
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
  orderType: json['orderType'] as String? ?? 'RX',
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
);

Map<String, dynamic> _$$RxSaleOrderModelImplToJson(
  _$RxSaleOrderModelImpl instance,
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
  'orderType': instance.orderType,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};
