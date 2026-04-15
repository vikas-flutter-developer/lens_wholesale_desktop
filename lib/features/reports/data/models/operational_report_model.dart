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
    required String orderNo,
    required String orderDate,
    required String orderCreatedAt,
    String? challanNo,
    String? challanDate,
    String? challanCreatedAt,
    required String partyName,
    required double timeDifference,
    required String status,
  }) = _OrderToChallanDetail;

  factory OrderToChallanDetail.fromJson(Map<String, dynamic> json) => _$OrderToChallanDetailFromJson(json);
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
    required bool cancelledOrders,
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
