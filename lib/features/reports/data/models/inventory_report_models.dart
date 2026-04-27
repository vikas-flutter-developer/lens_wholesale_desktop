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
    String? dcId,
    String? vendorName,
    @JsonKey(name: 'dc_id') String? dc_id,
    String? remark,
  }) = _PartyWiseItem;

  factory PartyWiseItem.fromJson(Map<String, dynamic> json) => _$PartyWiseItemFromJson(json);
}

// --- Stock Reorder Report Model ---

@freezed
class StockReorderItem with _$StockReorderItem {
  const factory StockReorderItem({
    String? productName,
    String? groupName,
    String? unit,
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
    dynamic sph,
    dynamic cyl,
    String? eye,
    dynamic axis,
    dynamic add,
  }) = _StockReorderLensInfo;

  factory StockReorderLensInfo.fromJson(Map<String, dynamic> json) => _$StockReorderLensInfoFromJson(json);
}

// --- Sale Item Group Wise Report Model ---

@freezed
class SaleItemGroupWiseItem with _$SaleItemGroupWiseItem {
  const factory SaleItemGroupWiseItem({
    String? billNo,
    String? date,
    String? party,
    String? productGroup,
    String? productName,
    @Default(0) double qty,
    @Default(0) double prodPrice,
    @Default(0) double prodDisPct,
    @Default(0) double prodDisRs,
    @Default(0) double otherDisPct,
    @Default(0) double otherDisRs,
    @Default(0) double prodValue,
    @Default(0) double prodTxbleAmt,
    @Default(0) double invoiceTotalAmt,
    @Default(0) double cash,
    @Default(0) double bank,
  }) = _SaleItemGroupWiseItem;

  factory SaleItemGroupWiseItem.fromJson(Map<String, dynamic> json) => _$SaleItemGroupWiseItemFromJson(json);
}

// --- Booked By Report Model ---

@freezed
class BookedByReportItem with _$BookedByReportItem {
  const factory BookedByReportItem({
    String? id,
    String? orderDate,
    String? orderTime,
    String? billNo,
    String? bookedBy,
    String? itemName,
    String? eye,
    dynamic sph,
    dynamic cyl,
    dynamic axis,
    dynamic add,
    @Default(0) int qty,
    @Default(0.0) double netAmount,
    String? partyName,
    String? remark,
    String? orderType,
  }) = _BookedByReportItem;

  factory BookedByReportItem.fromJson(Map<String, dynamic> json) => _$BookedByReportItemFromJson(json);
}
// --- Customer Item Sales Report Models ---

@freezed
class CustomerItemSalesResponse with _$CustomerItemSalesResponse {
  const factory CustomerItemSalesResponse({
    required bool success,
    required CustomerItemSalesSummary summary,
    required List<CustomerItemSalesItem> data,
  }) = _CustomerItemSalesResponse;

  factory CustomerItemSalesResponse.fromJson(Map<String, dynamic> json) => _$CustomerItemSalesResponseFromJson(json);
}

@freezed
class CustomerItemSalesSummary with _$CustomerItemSalesSummary {
  const factory CustomerItemSalesSummary({
    required int totalItems,
    required double totalQty,
    required double totalRevenue,
    int? totalOrders,
  }) = _CustomerItemSalesSummary;

  factory CustomerItemSalesSummary.fromJson(Map<String, dynamic> json) => _$CustomerItemSalesSummaryFromJson(json);
}

@freezed
class CustomerItemSalesItem with _$CustomerItemSalesItem {
  const factory CustomerItemSalesItem({
    required String itemName,
    String? eye,
    dynamic sph,
    dynamic cyl,
    dynamic axis,
    dynamic add,
    required double totalQty,
    required double totalRevenue,
    String? lastSoldDate,
    required int orderCount,
  }) = _CustomerItemSalesItem;

  factory CustomerItemSalesItem.fromJson(Map<String, dynamic> json) => _$CustomerItemSalesItemFromJson(json);
}
// --- Item Stock Summary Report Models ---

@freezed
class ItemStockSummaryResponse with _$ItemStockSummaryResponse {
  const factory ItemStockSummaryResponse({
    required bool success,
    required List<ItemStockSummaryItem> data,
  }) = _ItemStockSummaryResponse;

  factory ItemStockSummaryResponse.fromJson(Map<String, dynamic> json) => _$ItemStockSummaryResponseFromJson(json);
}

@freezed
class ItemStockSummaryItem with _$ItemStockSummaryItem {
  const factory ItemStockSummaryItem({
    required String productName,
    required String groupName,
    @Default(0) double totalStockQty,
    @Default(0) double avgPurchasePrice,
    @Default(0) double avgSellingPrice,
    @Default(0) double totalPurchaseValue,
    @Default(0) double totalSellingValue,
    @Default(0) double expectedProfit,
    @Default(0.0) double? liveProfit,
    @Default(0) double turnover,
    @Default(0) int combinationCount,
  }) = _ItemStockSummaryItem;

  factory ItemStockSummaryItem.fromJson(Map<String, dynamic> json) => _$ItemStockSummaryItemFromJson(json);
}
