import 'package:freezed_annotation/freezed_annotation.dart';

part 'lens_stock_report_models.freezed.dart';
part 'lens_stock_report_models.g.dart';

@freezed
class LensStockReportResponse with _$LensStockReportResponse {
  const factory LensStockReportResponse({
    required bool success,
    required List<LensStockRow> data,
    required int total,
    required int page,
    required int limit,
    required LensStockTotals totals,
  }) = _LensStockReportResponse;

  factory LensStockReportResponse.fromJson(Map<String, dynamic> json) => _$LensStockReportResponseFromJson(json);
}

@freezed
class LensStockRow with _$LensStockRow {
  const factory LensStockRow({
    String? lensGroupId,
    String? groupName,
    String? productName,
    dynamic addValue,
    dynamic sph,
    dynamic cyl,
    dynamic axis,
    String? eye,
    String? barcode,
    String? boxNo,
    int? alertQty,
    double? pPrice,
    double? sPrice,
    int? initStock,
    int? totalSoldQty,
    int? currentStock,
    bool? isVerified,
    String? lastVerifiedDate,
    int? verifiedQty,
    int? excess_qty,
  }) = _LensStockRow;

  factory LensStockRow.fromJson(Map<String, dynamic> json) => _$LensStockRowFromJson(json);
}

@freezed
class LensStockTotals with _$LensStockTotals {
  const factory LensStockTotals({
    @Default(0) int stockTotal,
    @Default(0.0) double purValueTotal,
    @Default(0.0) double saleValueTotal,
  }) = _LensStockTotals;

  factory LensStockTotals.fromJson(Map<String, dynamic> json) => _$LensStockTotalsFromJson(json);
}
