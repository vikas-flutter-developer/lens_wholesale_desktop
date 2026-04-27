import 'package:freezed_annotation/freezed_annotation.dart';

part 'operational_report_model.freezed.dart';
part 'operational_report_model.g.dart';

// Order to Challan Time Report Models
@freezed
class OrderToChallanReport with _$OrderToChallanReport {
  const factory OrderToChallanReport({
    required bool success,
    required OrderToChallanSummary summary,
    required List<OrderToChallanDetail> details,
    @Default([]) List<OrderToChallanTrend> trend,
  }) = _OrderToChallanReport;

  factory OrderToChallanReport.fromJson(Map<String, dynamic> json) => _$OrderToChallanReportFromJson(json);
}

@freezed
class OrderToChallanSummary with _$OrderToChallanSummary {
  const factory OrderToChallanSummary({
    required int totalOrders,
    required int completedOrders,
    required int pendingOrders,
    required double avgTime,
  }) = _OrderToChallanSummary;

  factory OrderToChallanSummary.fromJson(Map<String, dynamic> json) => _$OrderToChallanSummaryFromJson(json);
}

@freezed
class OrderToChallanDetail with _$OrderToChallanDetail {
  const factory OrderToChallanDetail({
    @Default('') String orderNo,
    @Default('') String orderDate,
    @Default('') String orderCreatedAt,
    String? challanNo,
    String? challanDate,
    String? challanCreatedAt,
    @Default('') String partyName,
    double? timeDifference,
    @Default('') String status,
  }) = _OrderToChallanDetail;

  factory OrderToChallanDetail.fromJson(Map<String, dynamic> json) => _$OrderToChallanDetailFromJson(json);
}

@freezed
class OrderToChallanTrend with _$OrderToChallanTrend {
  const factory OrderToChallanTrend({
    required String period,
    required double avgTime,
  }) = _OrderToChallanTrend;

  factory OrderToChallanTrend.fromJson(Map<String, dynamic> json) => _$OrderToChallanTrendFromJson(json);
}

// Cancelled Order Ratio Report Models
@freezed
class CancelledOrderRatioReport with _$CancelledOrderRatioReport {
  const factory CancelledOrderRatioReport({
    required bool success,
    required CancelledOrderRatioSummary summary,
    required List<CancelledOrderRatioDetail> details,
    required List<PartyWiseRatio> partyWise,
    required List<RatioTrend> trend,
  }) = _CancelledOrderRatioReport;

  factory CancelledOrderRatioReport.fromJson(Map<String, dynamic> json) => _$CancelledOrderRatioReportFromJson(json);
}

@freezed
class CancelledOrderRatioSummary with _$CancelledOrderRatioSummary {
  const factory CancelledOrderRatioSummary({
    int? totalOrders,
    int? cancelledOrders,
    int? activeOrders,
    double? ratio,
    Map<String, dynamic>? sale,
    Map<String, dynamic>? purchase,
  }) = _CancelledOrderRatioSummary;

  factory CancelledOrderRatioSummary.fromJson(Map<String, dynamic> json) => _$CancelledOrderRatioSummaryFromJson(json);
}

@freezed
class CancelledOrderRatioDetail with _$CancelledOrderRatioDetail {
  const factory CancelledOrderRatioDetail({
    required String date,
    required String transactionType,
    required String label,
    required String partyName,
    required String status,
    required double netAmount,
    required int cancelledOrders,
  }) = _CancelledOrderRatioDetail;

  factory CancelledOrderRatioDetail.fromJson(Map<String, dynamic> json) => _$CancelledOrderRatioDetailFromJson(json);
}

@freezed
class PartyWiseRatio with _$PartyWiseRatio {
  const factory PartyWiseRatio({
    required String partyName,
    required int totalOrders,
    required int cancelledOrders,
    required double ratio,
  }) = _PartyWiseRatio;

  factory PartyWiseRatio.fromJson(Map<String, dynamic> json) => _$PartyWiseRatioFromJson(json);
}

@freezed
class RatioTrend with _$RatioTrend {
  const factory RatioTrend({
    required String period,
    required double ratio,
  }) = _RatioTrend;

  factory RatioTrend.fromJson(Map<String, dynamic> json) => _$RatioTrendFromJson(json);
}

// Sale Return Ratio Report Models
@freezed
class SaleReturnRatioReport with _$SaleReturnRatioReport {
  const factory SaleReturnRatioReport({
    required bool success,
    required SaleReturnRatioSummary summary,
    required List<PartyWiseReturnRatio> partyWise,
    required List<RatioTrend> trend,
  }) = _SaleReturnRatioReport;

  factory SaleReturnRatioReport.fromJson(Map<String, dynamic> json) => _$SaleReturnRatioReportFromJson(json);
}

@freezed
class SaleReturnRatioSummary with _$SaleReturnRatioSummary {
  const factory SaleReturnRatioSummary({
    @Default(0.0) double totalSale,
    @Default(0.0) double totalReturn,
    @Default(0.0) double netSale,
    @Default(0.0) double ratio,
  }) = _SaleReturnRatioSummary;

  factory SaleReturnRatioSummary.fromJson(Map<String, dynamic> json) => _$SaleReturnRatioSummaryFromJson(json);
}

@freezed
class PartyWiseReturnRatio with _$PartyWiseReturnRatio {
  const factory PartyWiseReturnRatio({
    required String partyName,
    @Default(0.0) double totalSale,
    @Default(0.0) double totalReturn,
    @Default(0.0) double netSale,
    @Default(0.0) double ratio,
  }) = _PartyWiseReturnRatio;

  factory PartyWiseReturnRatio.fromJson(Map<String, dynamic> json) => _$PartyWiseReturnRatioFromJson(json);
}

// Sales Growth Comparison Report Models
@freezed
class SalesGrowthReport with _$SalesGrowthReport {
  const factory SalesGrowthReport({
    required bool success,
    required SalesGrowthSummary summary,
    required List<SalesGrowthDetail> data,
  }) = _SalesGrowthReport;

  factory SalesGrowthReport.fromJson(Map<String, dynamic> json) => _$SalesGrowthReportFromJson(json);
}

@freezed
class SalesGrowthSummary with _$SalesGrowthSummary {
  const factory SalesGrowthSummary({
    required String currLabel,
    required String prevLabel,
    required String lyLabel,
    required double currTotal,
    required double prevTotal,
    required double lyTotal,
    required double momGrowthPct,
    required double yoyGrowthPct,
    required int growingParties,
    required int degrowingParties,
  }) = _SalesGrowthSummary;

  factory SalesGrowthSummary.fromJson(Map<String, dynamic> json) => _$SalesGrowthSummaryFromJson(json);
}

@freezed
class SalesGrowthDetail with _$SalesGrowthDetail {
  const factory SalesGrowthDetail({
    required String partyName,
    required double currSales,
    required double prevSales,
    required double lySales,
    double? momGrowth,
    double? yoyGrowth,
    required String momStatus,
    required String yoyStatus,
    required int currInvoices,
  }) = _SalesGrowthDetail;

  factory SalesGrowthDetail.fromJson(Map<String, dynamic> json) => _$SalesGrowthDetailFromJson(json);
}
