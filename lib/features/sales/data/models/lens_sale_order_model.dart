// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'lens_sale_order_model.freezed.dart';
part 'lens_sale_order_model.g.dart';

@freezed
class LensSaleOrderModel with _$LensSaleOrderModel {
  const factory LensSaleOrderModel({
    @JsonKey(name: '_id') String? id,
    @Default(SaleOrderBillData()) SaleOrderBillData billData,
    @Default(SaleOrderPartyData()) SaleOrderPartyData partyData,
    @Default([]) List<SaleOrderItem> items,
    @Default([]) List<SaleOrderTax> taxes,
    @Default(0) int orderQty,
    @Default(0) int usedQty,
    @Default(0) int balQty,
    @Default(0.0) double grossAmount,
    @Default(0.0) double subtotal,
    @Default(0.0) double taxesAmount,
    @Default(0.0) double netAmount,
    @Default(0.0) double paidAmount,
    @Default(0.0) double dueAmount,
    String? refNo,
    String? deliveryDate,
    String? time,
    String? remark,
    @Default('Pending') String status,
    @Default('Pending') String parentStatus,
    String? cancelReason,
    String? settlementDate,
    @Default(false) bool isOrderPlaced,
    String? orderPlacedAt,
    String? createdAt,
    String? updatedAt,
  }) = _LensSaleOrderModel;

  factory LensSaleOrderModel.fromJson(Map<String, dynamic> json) =>
      _$LensSaleOrderModelFromJson(json);
}

@freezed
class SaleOrderBillData with _$SaleOrderBillData {
  const factory SaleOrderBillData({
    @Default('') String billSeries,
    @Default('') String billNo,
    String? date,
    @Default('') String billType,
    @Default('') String bankAccount,
    @Default('') String godown,
    @Default('') String bookedBy,
  }) = _SaleOrderBillData;

  factory SaleOrderBillData.fromJson(Map<String, dynamic> json) =>
      _$SaleOrderBillDataFromJson(json);
}

@freezed
class SaleOrderPartyData with _$SaleOrderPartyData {
  const factory SaleOrderPartyData({
    @JsonKey(name: '_id') String? id,
    @Default('') String partyAccount,
    @Default('') String address,
    @Default('') String contactNumber,
    @Default('') String stateCode,
    @Default(0.0) double creditLimit,
    @Default(0) int creditDays,
    @Default('') String accountCategory, // For pricing logic
    @Default(CurrentBalance()) CurrentBalance currentBalance,
  }) = _SaleOrderPartyData;

  factory SaleOrderPartyData.fromJson(Map<String, dynamic> json) =>
      _$SaleOrderPartyDataFromJson(json);
}

@freezed
class CurrentBalance with _$CurrentBalance {
  const factory CurrentBalance({
    @Default(0.0) double amount,
    @Default('Dr') String type,
  }) = _CurrentBalance;

  factory CurrentBalance.fromJson(Map<String, dynamic> json) =>
      _$CurrentBalanceFromJson(json);
}

@freezed
class SaleOrderItem with _$SaleOrderItem {
  const factory SaleOrderItem({
    @JsonKey(name: '_id') String? id,
    @Default('') String barcode,
    @Default('') String itemName,
    @Default('') String billItemName,
    @Default('') String vendorItemName,
    @Default('') String unit,
    @Default('') String dia,
    @Default('') String eye,
    @Default(0.0) double sph,
    @Default(0.0) double cyl,
    @Default(0.0) double axis,
    @Default(0.0) double add,
    @Default(0) int qty,
    @Default(false) bool isInvoiced,
    @Default(false) bool isChallaned,
    @Default(0.0) double salePrice,
    @Default(0.0) double discount,
    @Default(0.0) double totalAmount,
    @Default(0.0) double sellPrice,
    @Default(0.0) double purchasePrice,
    @Default('') String combinationId,
    @Default('') String orderNo,
    @Default('Pending') String itemStatus,
    String? remark,
    String? vendor,
    String? partyName,
    String? cancelReason,
  }) = _SaleOrderItem;

  factory SaleOrderItem.fromJson(Map<String, dynamic> json) =>
      _$SaleOrderItemFromJson(json);
}

@freezed
class SaleOrderTax with _$SaleOrderTax {
  const factory SaleOrderTax({
    @Default('') String taxName,
    @Default('Additive') String type,
    @Default(0.0) double percentage,
    @Default(0.0) double amount,
    @Default({}) Map<String, dynamic> meta,
  }) = _SaleOrderTax;

  factory SaleOrderTax.fromJson(Map<String, dynamic> json) =>
      _$SaleOrderTaxFromJson(json);
}
