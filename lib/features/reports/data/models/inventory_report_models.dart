import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_report_models.freezed.dart';
part 'inventory_report_models.g.dart';

// --- Lens Movement Report Models ---

@freezed
class LensMovementReportData with _$LensMovementReportData {
  const factory LensMovementReportData({
    required bool success,
    required List<LensMovementItem> purchaseData,
    required List<LensMovementItem> saleData,
    @Default(0) double openingStock,
    @Default(0) double closingStock,
    @Default([]) List<UnmovedItem> unmovedItems,
  }) = _LensMovementReportData;

  factory LensMovementReportData.fromJson(Map<String, dynamic> json) => _$LensMovementReportDataFromJson(json);
}

@freezed
class LensMovementItem with _$LensMovementItem {
  const factory LensMovementItem({
    String? date,
    String? transType,
    String? voucherNo,
    String? partyName,
    String? groupName,
    String? group,
    required String itemName,
    String? barcode,
    String? barCode,
    String? eye,
    dynamic sph,
    dynamic cyl,
    dynamic axis,
    dynamic add,
    @Default(0) double quantity,
    double? price,
    String? unit,
    String? docId,
    // Calculated fields for processed data
    @Default(0) double opening,
    @Default(0) double inwardQty,
    @Default(0) double inwardValue,
    @Default(0) double outwardQty,
    @Default(0) double outwardValue,
    @Default(0) double closing,
    String? mType, // 'inward' or 'outward'
  }) = _LensMovementItem;

  factory LensMovementItem.fromJson(Map<String, dynamic> json) => _$LensMovementItemFromJson(json);
}

@freezed
class UnmovedItem with _$UnmovedItem {
  const factory UnmovedItem({
    String? groupName,
    String? group,
    String? productName,
    String? itemName,
    String? barcode,
    String? eye,
    dynamic sph,
    dynamic cyl,
    dynamic axis,
    dynamic add,
    @Default(0) double currentStock,
    @Default(0) double price,
    String? unit,
  }) = _UnmovedItem;

  factory UnmovedItem.fromJson(Map<String, dynamic> json) => _$UnmovedItemFromJson(json);
}

// --- Power Movement Report Models ---

@freezed
class PowerMovementReportData with _$PowerMovementReportData {
  const factory PowerMovementReportData({
    required bool success,
    required List<PowerMovementItem> data,
    required PowerMovementAnalytics analytics,
  }) = _PowerMovementReportData;

  factory PowerMovementReportData.fromJson(Map<String, dynamic> json) => _$PowerMovementReportDataFromJson(json);
}

@freezed
class PowerMovementItem with _$PowerMovementItem {
  const factory PowerMovementItem({
    required String eye,
    required double sph,
    required double cyl,
    required int axis,
    required double add,
    required String itemName,
    required int orderCount,
    required int totalQty,
    required double totalRevenue,
    required double avgPrice,
    String? lastSoldDate,
    required String movementStatus,
  }) = _PowerMovementItem;

  factory PowerMovementItem.fromJson(Map<String, dynamic> json) => _$PowerMovementItemFromJson(json);
}

@freezed
class PowerMovementAnalytics with _$PowerMovementAnalytics {
  const factory PowerMovementAnalytics({
    List<PowerMovementItem>? topFastMoving,
    PowerMovementItem? highestRevenue,
    String? mostSoldItem,
    PowerSummary? totalSummary,
  }) = _PowerMovementAnalytics;

  factory PowerMovementAnalytics.fromJson(Map<String, dynamic> json) => _$PowerMovementAnalyticsFromJson(json);
}

@freezed
class PowerSummary with _$PowerSummary {
  const factory PowerSummary({
    required int totalQty,
    required double totalRevenue,
  }) = _PowerSummary;

  factory PowerSummary.fromJson(Map<String, dynamic> json) => _$PowerSummaryFromJson(json);
}

// --- Party Wise Item Report Model ---

@freezed
class PartyWiseItem with _$PartyWiseItem {
  const factory PartyWiseItem({
    String? transType,
    String? vchSeries,
    String? vchNo,
    String? vchDate,
    String? partyName,
    String? mobNo,
    String? barcode,
    String? productName,
    String? bookedBy,
    String? dia,
    String? eye,
    dynamic sph,
    dynamic cyl,
    dynamic axis,
    dynamic add,
    @Default(0) double qty,
    String? loc,
    @Default(0) double pricePerUnit,
    @Default(0) double totalPrice,
    double? purchasePrice,
    String? combinationId,
    String? docId,
    String? remark,
  }) = _PartyWiseItem;

  factory PartyWiseItem.fromJson(Map<String, dynamic> json) => _$PartyWiseItemFromJson(json);
}

// --- Stock Reorder Report Model ---

@freezed
class StockReorderItem with _$StockReorderItem {
  const factory StockReorderItem({
    required String productName,
    required String groupName,
    required String unit,
    @Default(0) double alertQty,
    @Default(0) double stock,
    double? minStock,
    double? maxStock,
    double? minReorderQty,
    String? type,
    StockReorderLensInfo? lensInfo,
    String? barcode,
  }) = _StockReorderItem;

  factory StockReorderItem.fromJson(Map<String, dynamic> json) => _$StockReorderItemFromJson(json);
}

@freezed
class StockReorderLensInfo with _$StockReorderLensInfo {
  const factory StockReorderLensInfo({
    String? sph,
    String? cyl,
    String? eye,
    String? axis,
    String? add,
  }) = _StockReorderLensInfo;

  factory StockReorderLensInfo.fromJson(Map<String, dynamic> json) => _$StockReorderLensInfoFromJson(json);
}
