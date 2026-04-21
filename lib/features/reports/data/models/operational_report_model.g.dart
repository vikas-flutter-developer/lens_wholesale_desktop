// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operational_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderToChallanReportImpl _$$OrderToChallanReportImplFromJson(
  Map<String, dynamic> json,
) => _$OrderToChallanReportImpl(
  success: json['success'] as bool,
  summary: OrderToChallanSummary.fromJson(
    json['summary'] as Map<String, dynamic>,
  ),
  details: (json['details'] as List<dynamic>)
      .map((e) => OrderToChallanDetail.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$OrderToChallanReportImplToJson(
  _$OrderToChallanReportImpl instance,
) => <String, dynamic>{
  'success': instance.success,
  'summary': instance.summary,
  'details': instance.details,
};

_$OrderToChallanSummaryImpl _$$OrderToChallanSummaryImplFromJson(
  Map<String, dynamic> json,
) => _$OrderToChallanSummaryImpl(
  totalOrders: (json['totalOrders'] as num).toInt(),
  completedOrders: (json['completedOrders'] as num).toInt(),
  pendingOrders: (json['pendingOrders'] as num).toInt(),
  avgTime: (json['avgTime'] as num).toDouble(),
);

Map<String, dynamic> _$$OrderToChallanSummaryImplToJson(
  _$OrderToChallanSummaryImpl instance,
) => <String, dynamic>{
  'totalOrders': instance.totalOrders,
  'completedOrders': instance.completedOrders,
  'pendingOrders': instance.pendingOrders,
  'avgTime': instance.avgTime,
};

_$OrderToChallanDetailImpl _$$OrderToChallanDetailImplFromJson(
  Map<String, dynamic> json,
) => _$OrderToChallanDetailImpl(
  orderNo: json['orderNo'] as String,
  orderDate: json['orderDate'] as String,
  orderCreatedAt: json['orderCreatedAt'] as String,
  challanNo: json['challanNo'] as String?,
  challanDate: json['challanDate'] as String?,
  challanCreatedAt: json['challanCreatedAt'] as String?,
  partyName: json['partyName'] as String,
  timeDifference: (json['timeDifference'] as num).toDouble(),
  status: json['status'] as String,
);

Map<String, dynamic> _$$OrderToChallanDetailImplToJson(
  _$OrderToChallanDetailImpl instance,
) => <String, dynamic>{
  'orderNo': instance.orderNo,
  'orderDate': instance.orderDate,
  'orderCreatedAt': instance.orderCreatedAt,
  'challanNo': instance.challanNo,
  'challanDate': instance.challanDate,
  'challanCreatedAt': instance.challanCreatedAt,
  'partyName': instance.partyName,
  'timeDifference': instance.timeDifference,
  'status': instance.status,
};

_$CancelledOrderRatioReportImpl _$$CancelledOrderRatioReportImplFromJson(
  Map<String, dynamic> json,
) => _$CancelledOrderRatioReportImpl(
  success: json['success'] as bool,
  summary: CancelledOrderRatioSummary.fromJson(
    json['summary'] as Map<String, dynamic>,
  ),
  details: (json['details'] as List<dynamic>)
      .map((e) => CancelledOrderRatioDetail.fromJson(e as Map<String, dynamic>))
      .toList(),
  partyWise: (json['partyWise'] as List<dynamic>)
      .map((e) => PartyWiseRatio.fromJson(e as Map<String, dynamic>))
      .toList(),
  trend: (json['trend'] as List<dynamic>)
      .map((e) => RatioTrend.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$CancelledOrderRatioReportImplToJson(
  _$CancelledOrderRatioReportImpl instance,
) => <String, dynamic>{
  'success': instance.success,
  'summary': instance.summary,
  'details': instance.details,
  'partyWise': instance.partyWise,
  'trend': instance.trend,
};

_$CancelledOrderRatioSummaryImpl _$$CancelledOrderRatioSummaryImplFromJson(
  Map<String, dynamic> json,
) => _$CancelledOrderRatioSummaryImpl(
  totalOrders: (json['totalOrders'] as num?)?.toInt(),
  cancelledOrders: (json['cancelledOrders'] as num?)?.toInt(),
  activeOrders: (json['activeOrders'] as num?)?.toInt(),
  ratio: (json['ratio'] as num?)?.toDouble(),
  sale: json['sale'] as Map<String, dynamic>?,
  purchase: json['purchase'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$$CancelledOrderRatioSummaryImplToJson(
  _$CancelledOrderRatioSummaryImpl instance,
) => <String, dynamic>{
  'totalOrders': instance.totalOrders,
  'cancelledOrders': instance.cancelledOrders,
  'activeOrders': instance.activeOrders,
  'ratio': instance.ratio,
  'sale': instance.sale,
  'purchase': instance.purchase,
};

_$CancelledOrderRatioDetailImpl _$$CancelledOrderRatioDetailImplFromJson(
  Map<String, dynamic> json,
) => _$CancelledOrderRatioDetailImpl(
  date: json['date'] as String,
  transactionType: json['transactionType'] as String,
  label: json['label'] as String,
  partyName: json['partyName'] as String,
  status: json['status'] as String,
  netAmount: (json['netAmount'] as num).toDouble(),
  cancelledOrders: json['cancelledOrders'] as bool,
);

Map<String, dynamic> _$$CancelledOrderRatioDetailImplToJson(
  _$CancelledOrderRatioDetailImpl instance,
) => <String, dynamic>{
  'date': instance.date,
  'transactionType': instance.transactionType,
  'label': instance.label,
  'partyName': instance.partyName,
  'status': instance.status,
  'netAmount': instance.netAmount,
  'cancelledOrders': instance.cancelledOrders,
};

_$PartyWiseRatioImpl _$$PartyWiseRatioImplFromJson(Map<String, dynamic> json) =>
    _$PartyWiseRatioImpl(
      partyName: json['partyName'] as String,
      totalOrders: (json['totalOrders'] as num).toInt(),
      cancelledOrders: (json['cancelledOrders'] as num).toInt(),
      ratio: (json['ratio'] as num).toDouble(),
    );

Map<String, dynamic> _$$PartyWiseRatioImplToJson(
  _$PartyWiseRatioImpl instance,
) => <String, dynamic>{
  'partyName': instance.partyName,
  'totalOrders': instance.totalOrders,
  'cancelledOrders': instance.cancelledOrders,
  'ratio': instance.ratio,
};

_$RatioTrendImpl _$$RatioTrendImplFromJson(Map<String, dynamic> json) =>
    _$RatioTrendImpl(
      period: json['period'] as String,
      ratio: (json['ratio'] as num).toDouble(),
    );

Map<String, dynamic> _$$RatioTrendImplToJson(_$RatioTrendImpl instance) =>
    <String, dynamic>{'period': instance.period, 'ratio': instance.ratio};

_$SaleReturnRatioReportImpl _$$SaleReturnRatioReportImplFromJson(
  Map<String, dynamic> json,
) => _$SaleReturnRatioReportImpl(
  success: json['success'] as bool,
  summary: SaleReturnRatioSummary.fromJson(
    json['summary'] as Map<String, dynamic>,
  ),
  partyWise: (json['partyWise'] as List<dynamic>)
      .map((e) => PartyWiseReturnRatio.fromJson(e as Map<String, dynamic>))
      .toList(),
  trend: (json['trend'] as List<dynamic>)
      .map((e) => RatioTrend.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$SaleReturnRatioReportImplToJson(
  _$SaleReturnRatioReportImpl instance,
) => <String, dynamic>{
  'success': instance.success,
  'summary': instance.summary,
  'partyWise': instance.partyWise,
  'trend': instance.trend,
};

_$SaleReturnRatioSummaryImpl _$$SaleReturnRatioSummaryImplFromJson(
  Map<String, dynamic> json,
) => _$SaleReturnRatioSummaryImpl(
  totalSale: (json['totalSale'] as num?)?.toDouble() ?? 0.0,
  totalReturn: (json['totalReturn'] as num?)?.toDouble() ?? 0.0,
  netSale: (json['netSale'] as num?)?.toDouble() ?? 0.0,
  ratio: (json['ratio'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$$SaleReturnRatioSummaryImplToJson(
  _$SaleReturnRatioSummaryImpl instance,
) => <String, dynamic>{
  'totalSale': instance.totalSale,
  'totalReturn': instance.totalReturn,
  'netSale': instance.netSale,
  'ratio': instance.ratio,
};

_$PartyWiseReturnRatioImpl _$$PartyWiseReturnRatioImplFromJson(
  Map<String, dynamic> json,
) => _$PartyWiseReturnRatioImpl(
  partyName: json['partyName'] as String,
  totalSale: (json['totalSale'] as num?)?.toDouble() ?? 0.0,
  totalReturn: (json['totalReturn'] as num?)?.toDouble() ?? 0.0,
  netSale: (json['netSale'] as num?)?.toDouble() ?? 0.0,
  ratio: (json['ratio'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$$PartyWiseReturnRatioImplToJson(
  _$PartyWiseReturnRatioImpl instance,
) => <String, dynamic>{
  'partyName': instance.partyName,
  'totalSale': instance.totalSale,
  'totalReturn': instance.totalReturn,
  'netSale': instance.netSale,
  'ratio': instance.ratio,
};
