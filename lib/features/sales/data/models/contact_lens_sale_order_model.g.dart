// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_lens_sale_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContactLensOrderItemImpl _$$ContactLensOrderItemImplFromJson(
  Map<String, dynamic> json,
) => _$ContactLensOrderItemImpl(
  id: json['_id'] as String?,
  barcode: json['barcode'] as String? ?? '',
  itemName: json['itemName'] as String? ?? '',
  billItemName: json['billItemName'] as String? ?? '',
  vendorItemName: json['vendorItemName'] as String? ?? '',
  orderNo: json['orderNo'] as String? ?? '',
  eye: json['eye'] as String? ?? '',
  sph: (json['sph'] as num?)?.toDouble() ?? 0.0,
  cyl: (json['cyl'] as num?)?.toDouble() ?? 0.0,
  axis: (json['axis'] as num?)?.toDouble() ?? 0.0,
  add: (json['add'] as num?)?.toDouble() ?? 0.0,
  dia: json['dia'] as String? ?? '',
  vendor: json['vendor'] as String? ?? '',
  importDate: json['importDate'] as String?,
  expiryDate: json['expiryDate'] as String?,
  remark: json['remark'] as String? ?? '',
  qty: (json['qty'] as num?)?.toInt() ?? 0,
  unit: json['unit'] as String? ?? '',
  mrp: (json['mrp'] as num?)?.toDouble() ?? 0.0,
  salePrice: (json['salePrice'] as num?)?.toDouble() ?? 0.0,
  discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
  totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
  combinationId: json['combinationId'] as String? ?? '',
  bookedBy: json['bookedBy'] as String? ?? '',
);

Map<String, dynamic> _$$ContactLensOrderItemImplToJson(
  _$ContactLensOrderItemImpl instance,
) => <String, dynamic>{
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
  'dia': instance.dia,
  'vendor': instance.vendor,
  'importDate': instance.importDate,
  'expiryDate': instance.expiryDate,
  'remark': instance.remark,
  'qty': instance.qty,
  'unit': instance.unit,
  'mrp': instance.mrp,
  'salePrice': instance.salePrice,
  'discount': instance.discount,
  'totalAmount': instance.totalAmount,
  'combinationId': instance.combinationId,
  'bookedBy': instance.bookedBy,
};

_$ContactLensSaleOrderModelImpl _$$ContactLensSaleOrderModelImplFromJson(
  Map<String, dynamic> json,
) => _$ContactLensSaleOrderModelImpl(
  id: json['_id'] as String?,
  billData: json['billData'] == null
      ? const SaleOrderBillData()
      : SaleOrderBillData.fromJson(json['billData'] as Map<String, dynamic>),
  partyData: json['partyData'] == null
      ? const SaleOrderPartyData()
      : SaleOrderPartyData.fromJson(json['partyData'] as Map<String, dynamic>),
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => ContactLensOrderItem.fromJson(e as Map<String, dynamic>))
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
  companyId: json['companyId'] as String?,
  orderType: json['orderType'] as String? ?? 'CONTACT LENS',
  createdAt: json['createdAt'] as String?,
);

Map<String, dynamic> _$$ContactLensSaleOrderModelImplToJson(
  _$ContactLensSaleOrderModelImpl instance,
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
  'companyId': instance.companyId,
  'orderType': instance.orderType,
  'createdAt': instance.createdAt,
};
