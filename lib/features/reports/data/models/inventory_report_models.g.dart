// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_report_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LensMovementReportDataImpl _$$LensMovementReportDataImplFromJson(
  Map<String, dynamic> json,
) => _$LensMovementReportDataImpl(
  success: json['success'] as bool,
  purchaseData: (json['purchaseData'] as List<dynamic>)
      .map((e) => LensMovementItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  saleData: (json['saleData'] as List<dynamic>)
      .map((e) => LensMovementItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  openingStock: (json['openingStock'] as num?)?.toDouble() ?? 0,
  closingStock: (json['closingStock'] as num?)?.toDouble() ?? 0,
  unmovedItems:
      (json['unmovedItems'] as List<dynamic>?)
          ?.map((e) => UnmovedItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$LensMovementReportDataImplToJson(
  _$LensMovementReportDataImpl instance,
) => <String, dynamic>{
  'success': instance.success,
  'purchaseData': instance.purchaseData,
  'saleData': instance.saleData,
  'openingStock': instance.openingStock,
  'closingStock': instance.closingStock,
  'unmovedItems': instance.unmovedItems,
};

_$LensMovementItemImpl _$$LensMovementItemImplFromJson(
  Map<String, dynamic> json,
) => _$LensMovementItemImpl(
  date: json['date'] as String?,
  transType: json['transType'] as String?,
  voucherNo: json['voucherNo'] as String?,
  partyName: json['partyName'] as String?,
  groupName: json['groupName'] as String?,
  group: json['group'] as String?,
  itemName: json['itemName'] as String,
  barcode: json['barcode'] as String?,
  barCode: json['barCode'] as String?,
  eye: json['eye'] as String?,
  sph: json['sph'],
  cyl: json['cyl'],
  axis: json['axis'],
  add: json['add'],
  quantity: (json['quantity'] as num?)?.toDouble() ?? 0,
  price: (json['price'] as num?)?.toDouble(),
  unit: json['unit'] as String?,
  docId: json['docId'] as String?,
  opening: (json['opening'] as num?)?.toDouble() ?? 0,
  inwardQty: (json['inwardQty'] as num?)?.toDouble() ?? 0,
  inwardValue: (json['inwardValue'] as num?)?.toDouble() ?? 0,
  outwardQty: (json['outwardQty'] as num?)?.toDouble() ?? 0,
  outwardValue: (json['outwardValue'] as num?)?.toDouble() ?? 0,
  closing: (json['closing'] as num?)?.toDouble() ?? 0,
  mType: json['mType'] as String?,
);

Map<String, dynamic> _$$LensMovementItemImplToJson(
  _$LensMovementItemImpl instance,
) => <String, dynamic>{
  'date': instance.date,
  'transType': instance.transType,
  'voucherNo': instance.voucherNo,
  'partyName': instance.partyName,
  'groupName': instance.groupName,
  'group': instance.group,
  'itemName': instance.itemName,
  'barcode': instance.barcode,
  'barCode': instance.barCode,
  'eye': instance.eye,
  'sph': instance.sph,
  'cyl': instance.cyl,
  'axis': instance.axis,
  'add': instance.add,
  'quantity': instance.quantity,
  'price': instance.price,
  'unit': instance.unit,
  'docId': instance.docId,
  'opening': instance.opening,
  'inwardQty': instance.inwardQty,
  'inwardValue': instance.inwardValue,
  'outwardQty': instance.outwardQty,
  'outwardValue': instance.outwardValue,
  'closing': instance.closing,
  'mType': instance.mType,
};

_$UnmovedItemImpl _$$UnmovedItemImplFromJson(Map<String, dynamic> json) =>
    _$UnmovedItemImpl(
      groupName: json['groupName'] as String?,
      group: json['group'] as String?,
      productName: json['productName'] as String?,
      itemName: json['itemName'] as String?,
      barcode: json['barcode'] as String?,
      eye: json['eye'] as String?,
      sph: json['sph'],
      cyl: json['cyl'],
      axis: json['axis'],
      add: json['add'],
      currentStock: (json['currentStock'] as num?)?.toDouble() ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0,
      unit: json['unit'] as String?,
    );

Map<String, dynamic> _$$UnmovedItemImplToJson(_$UnmovedItemImpl instance) =>
    <String, dynamic>{
      'groupName': instance.groupName,
      'group': instance.group,
      'productName': instance.productName,
      'itemName': instance.itemName,
      'barcode': instance.barcode,
      'eye': instance.eye,
      'sph': instance.sph,
      'cyl': instance.cyl,
      'axis': instance.axis,
      'add': instance.add,
      'currentStock': instance.currentStock,
      'price': instance.price,
      'unit': instance.unit,
    };

_$PowerMovementReportDataImpl _$$PowerMovementReportDataImplFromJson(
  Map<String, dynamic> json,
) => _$PowerMovementReportDataImpl(
  success: json['success'] as bool,
  data: (json['data'] as List<dynamic>)
      .map((e) => PowerMovementItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  analytics: PowerMovementAnalytics.fromJson(
    json['analytics'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$$PowerMovementReportDataImplToJson(
  _$PowerMovementReportDataImpl instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'analytics': instance.analytics,
};

_$PowerMovementItemImpl _$$PowerMovementItemImplFromJson(
  Map<String, dynamic> json,
) => _$PowerMovementItemImpl(
  eye: json['eye'] as String,
  sph: (json['sph'] as num).toDouble(),
  cyl: (json['cyl'] as num).toDouble(),
  axis: (json['axis'] as num).toInt(),
  add: (json['add'] as num).toDouble(),
  itemName: json['itemName'] as String,
  orderCount: (json['orderCount'] as num).toInt(),
  totalQty: (json['totalQty'] as num).toInt(),
  totalRevenue: (json['totalRevenue'] as num).toDouble(),
  avgPrice: (json['avgPrice'] as num).toDouble(),
  lastSoldDate: json['lastSoldDate'] as String?,
  movementStatus: json['movementStatus'] as String,
);

Map<String, dynamic> _$$PowerMovementItemImplToJson(
  _$PowerMovementItemImpl instance,
) => <String, dynamic>{
  'eye': instance.eye,
  'sph': instance.sph,
  'cyl': instance.cyl,
  'axis': instance.axis,
  'add': instance.add,
  'itemName': instance.itemName,
  'orderCount': instance.orderCount,
  'totalQty': instance.totalQty,
  'totalRevenue': instance.totalRevenue,
  'avgPrice': instance.avgPrice,
  'lastSoldDate': instance.lastSoldDate,
  'movementStatus': instance.movementStatus,
};

_$PowerMovementAnalyticsImpl _$$PowerMovementAnalyticsImplFromJson(
  Map<String, dynamic> json,
) => _$PowerMovementAnalyticsImpl(
  topFastMoving: (json['topFastMoving'] as List<dynamic>?)
      ?.map((e) => PowerMovementItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  highestRevenue: json['highestRevenue'] == null
      ? null
      : PowerMovementItem.fromJson(
          json['highestRevenue'] as Map<String, dynamic>,
        ),
  mostSoldItem: json['mostSoldItem'] as String?,
  totalSummary: json['totalSummary'] == null
      ? null
      : PowerSummary.fromJson(json['totalSummary'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$PowerMovementAnalyticsImplToJson(
  _$PowerMovementAnalyticsImpl instance,
) => <String, dynamic>{
  'topFastMoving': instance.topFastMoving,
  'highestRevenue': instance.highestRevenue,
  'mostSoldItem': instance.mostSoldItem,
  'totalSummary': instance.totalSummary,
};

_$PowerSummaryImpl _$$PowerSummaryImplFromJson(Map<String, dynamic> json) =>
    _$PowerSummaryImpl(
      totalQty: (json['totalQty'] as num).toInt(),
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
    );

Map<String, dynamic> _$$PowerSummaryImplToJson(_$PowerSummaryImpl instance) =>
    <String, dynamic>{
      'totalQty': instance.totalQty,
      'totalRevenue': instance.totalRevenue,
    };

_$PartyWiseItemImpl _$$PartyWiseItemImplFromJson(Map<String, dynamic> json) =>
    _$PartyWiseItemImpl(
      transType: json['transType'] as String?,
      vchSeries: json['vchSeries'] as String?,
      vchNo: json['vchNo'] as String?,
      vchDate: json['vchDate'] as String?,
      partyName: json['partyName'] as String?,
      mobNo: json['mobNo'] as String?,
      barcode: json['barcode'] as String?,
      productName: json['productName'] as String?,
      bookedBy: json['bookedBy'] as String?,
      dia: json['dia'] as String?,
      eye: json['eye'] as String?,
      sph: json['sph'],
      cyl: json['cyl'],
      axis: json['axis'],
      add: json['add'],
      qty: (json['qty'] as num?)?.toDouble() ?? 0,
      loc: json['loc'] as String?,
      pricePerUnit: (json['pricePerUnit'] as num?)?.toDouble() ?? 0,
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0,
      purchasePrice: (json['purchasePrice'] as num?)?.toDouble(),
      combinationId: json['combinationId'] as String?,
      docId: json['docId'] as String?,
      remark: json['remark'] as String?,
    );

Map<String, dynamic> _$$PartyWiseItemImplToJson(_$PartyWiseItemImpl instance) =>
    <String, dynamic>{
      'transType': instance.transType,
      'vchSeries': instance.vchSeries,
      'vchNo': instance.vchNo,
      'vchDate': instance.vchDate,
      'partyName': instance.partyName,
      'mobNo': instance.mobNo,
      'barcode': instance.barcode,
      'productName': instance.productName,
      'bookedBy': instance.bookedBy,
      'dia': instance.dia,
      'eye': instance.eye,
      'sph': instance.sph,
      'cyl': instance.cyl,
      'axis': instance.axis,
      'add': instance.add,
      'qty': instance.qty,
      'loc': instance.loc,
      'pricePerUnit': instance.pricePerUnit,
      'totalPrice': instance.totalPrice,
      'purchasePrice': instance.purchasePrice,
      'combinationId': instance.combinationId,
      'docId': instance.docId,
      'remark': instance.remark,
    };

_$StockReorderItemImpl _$$StockReorderItemImplFromJson(
  Map<String, dynamic> json,
) => _$StockReorderItemImpl(
  productName: json['productName'] as String?,
  groupName: json['groupName'] as String?,
  unit: json['unit'] as String?,
  alertQty: (json['alertQty'] as num?)?.toDouble() ?? 0,
  stock: (json['stock'] as num?)?.toDouble() ?? 0,
  minStock: (json['minStock'] as num?)?.toDouble(),
  maxStock: (json['maxStock'] as num?)?.toDouble(),
  minReorderQty: (json['minReorderQty'] as num?)?.toDouble(),
  type: json['type'] as String?,
  lensInfo: json['lensInfo'] == null
      ? null
      : StockReorderLensInfo.fromJson(json['lensInfo'] as Map<String, dynamic>),
  barcode: json['barcode'] as String?,
);

Map<String, dynamic> _$$StockReorderItemImplToJson(
  _$StockReorderItemImpl instance,
) => <String, dynamic>{
  'productName': instance.productName,
  'groupName': instance.groupName,
  'unit': instance.unit,
  'alertQty': instance.alertQty,
  'stock': instance.stock,
  'minStock': instance.minStock,
  'maxStock': instance.maxStock,
  'minReorderQty': instance.minReorderQty,
  'type': instance.type,
  'lensInfo': instance.lensInfo,
  'barcode': instance.barcode,
};

_$StockReorderLensInfoImpl _$$StockReorderLensInfoImplFromJson(
  Map<String, dynamic> json,
) => _$StockReorderLensInfoImpl(
  sph: json['sph'],
  cyl: json['cyl'],
  eye: json['eye'] as String?,
  axis: json['axis'],
  add: json['add'],
);

Map<String, dynamic> _$$StockReorderLensInfoImplToJson(
  _$StockReorderLensInfoImpl instance,
) => <String, dynamic>{
  'sph': instance.sph,
  'cyl': instance.cyl,
  'eye': instance.eye,
  'axis': instance.axis,
  'add': instance.add,
};

_$SaleItemGroupWiseItemImpl _$$SaleItemGroupWiseItemImplFromJson(
  Map<String, dynamic> json,
) => _$SaleItemGroupWiseItemImpl(
  billNo: json['billNo'] as String?,
  date: json['date'] as String?,
  party: json['party'] as String?,
  productGroup: json['productGroup'] as String?,
  productName: json['productName'] as String?,
  qty: (json['qty'] as num?)?.toDouble() ?? 0,
  prodPrice: (json['prodPrice'] as num?)?.toDouble() ?? 0,
  prodDisPct: (json['prodDisPct'] as num?)?.toDouble() ?? 0,
  prodDisRs: (json['prodDisRs'] as num?)?.toDouble() ?? 0,
  otherDisPct: (json['otherDisPct'] as num?)?.toDouble() ?? 0,
  otherDisRs: (json['otherDisRs'] as num?)?.toDouble() ?? 0,
  prodValue: (json['prodValue'] as num?)?.toDouble() ?? 0,
  prodTxbleAmt: (json['prodTxbleAmt'] as num?)?.toDouble() ?? 0,
  invoiceTotalAmt: (json['invoiceTotalAmt'] as num?)?.toDouble() ?? 0,
  cash: (json['cash'] as num?)?.toDouble() ?? 0,
  bank: (json['bank'] as num?)?.toDouble() ?? 0,
);

Map<String, dynamic> _$$SaleItemGroupWiseItemImplToJson(
  _$SaleItemGroupWiseItemImpl instance,
) => <String, dynamic>{
  'billNo': instance.billNo,
  'date': instance.date,
  'party': instance.party,
  'productGroup': instance.productGroup,
  'productName': instance.productName,
  'qty': instance.qty,
  'prodPrice': instance.prodPrice,
  'prodDisPct': instance.prodDisPct,
  'prodDisRs': instance.prodDisRs,
  'otherDisPct': instance.otherDisPct,
  'otherDisRs': instance.otherDisRs,
  'prodValue': instance.prodValue,
  'prodTxbleAmt': instance.prodTxbleAmt,
  'invoiceTotalAmt': instance.invoiceTotalAmt,
  'cash': instance.cash,
  'bank': instance.bank,
};

_$BookedByReportItemImpl _$$BookedByReportItemImplFromJson(
  Map<String, dynamic> json,
) => _$BookedByReportItemImpl(
  id: json['id'] as String?,
  orderDate: json['orderDate'] as String?,
  orderTime: json['orderTime'] as String?,
  billNo: json['billNo'] as String?,
  bookedBy: json['bookedBy'] as String?,
  itemName: json['itemName'] as String?,
  eye: json['eye'] as String?,
  sph: json['sph'],
  cyl: json['cyl'],
  axis: json['axis'],
  add: json['add'],
  qty: (json['qty'] as num?)?.toInt() ?? 0,
  netAmount: (json['netAmount'] as num?)?.toDouble() ?? 0.0,
  partyName: json['partyName'] as String?,
  remark: json['remark'] as String?,
  orderType: json['orderType'] as String?,
);

Map<String, dynamic> _$$BookedByReportItemImplToJson(
  _$BookedByReportItemImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'orderDate': instance.orderDate,
  'orderTime': instance.orderTime,
  'billNo': instance.billNo,
  'bookedBy': instance.bookedBy,
  'itemName': instance.itemName,
  'eye': instance.eye,
  'sph': instance.sph,
  'cyl': instance.cyl,
  'axis': instance.axis,
  'add': instance.add,
  'qty': instance.qty,
  'netAmount': instance.netAmount,
  'partyName': instance.partyName,
  'remark': instance.remark,
  'orderType': instance.orderType,
};
