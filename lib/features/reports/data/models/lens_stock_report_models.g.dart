// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lens_stock_report_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LensStockReportResponseImpl _$$LensStockReportResponseImplFromJson(
  Map<String, dynamic> json,
) => _$LensStockReportResponseImpl(
  success: json['success'] as bool,
  data: (json['data'] as List<dynamic>)
      .map((e) => LensStockRow.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num).toInt(),
  page: (json['page'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  totals: LensStockTotals.fromJson(json['totals'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$LensStockReportResponseImplToJson(
  _$LensStockReportResponseImpl instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'total': instance.total,
  'page': instance.page,
  'limit': instance.limit,
  'totals': instance.totals,
};

_$LensStockRowImpl _$$LensStockRowImplFromJson(Map<String, dynamic> json) =>
    _$LensStockRowImpl(
      lensGroupId: json['lensGroupId'] as String?,
      groupName: json['groupName'] as String?,
      productName: json['productName'] as String?,
      addValue: json['addValue'],
      sph: json['sph'],
      cyl: json['cyl'],
      axis: json['axis'],
      eye: json['eye'] as String?,
      barcode: json['barcode'] as String?,
      boxNo: json['boxNo'] as String?,
      alertQty: (json['alertQty'] as num?)?.toInt(),
      pPrice: (json['pPrice'] as num?)?.toDouble(),
      sPrice: (json['sPrice'] as num?)?.toDouble(),
      initStock: (json['initStock'] as num?)?.toInt(),
      totalSoldQty: (json['totalSoldQty'] as num?)?.toInt(),
      currentStock: (json['currentStock'] as num?)?.toInt(),
      isVerified: json['isVerified'] as bool?,
      lastVerifiedDate: json['lastVerifiedDate'] as String?,
      verifiedQty: (json['verifiedQty'] as num?)?.toInt(),
      excess_qty: (json['excess_qty'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$LensStockRowImplToJson(_$LensStockRowImpl instance) =>
    <String, dynamic>{
      'lensGroupId': instance.lensGroupId,
      'groupName': instance.groupName,
      'productName': instance.productName,
      'addValue': instance.addValue,
      'sph': instance.sph,
      'cyl': instance.cyl,
      'axis': instance.axis,
      'eye': instance.eye,
      'barcode': instance.barcode,
      'boxNo': instance.boxNo,
      'alertQty': instance.alertQty,
      'pPrice': instance.pPrice,
      'sPrice': instance.sPrice,
      'initStock': instance.initStock,
      'totalSoldQty': instance.totalSoldQty,
      'currentStock': instance.currentStock,
      'isVerified': instance.isVerified,
      'lastVerifiedDate': instance.lastVerifiedDate,
      'verifiedQty': instance.verifiedQty,
      'excess_qty': instance.excess_qty,
    };

_$LensStockTotalsImpl _$$LensStockTotalsImplFromJson(
  Map<String, dynamic> json,
) => _$LensStockTotalsImpl(
  stockTotal: (json['stockTotal'] as num?)?.toInt() ?? 0,
  purValueTotal: (json['purValueTotal'] as num?)?.toDouble() ?? 0.0,
  saleValueTotal: (json['saleValueTotal'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$$LensStockTotalsImplToJson(
  _$LensStockTotalsImpl instance,
) => <String, dynamic>{
  'stockTotal': instance.stockTotal,
  'purValueTotal': instance.purValueTotal,
  'saleValueTotal': instance.saleValueTotal,
};
