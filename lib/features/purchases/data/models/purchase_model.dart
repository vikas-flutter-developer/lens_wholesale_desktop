// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchase_model.freezed.dart';
part 'purchase_model.g.dart';

@freezed
class PurchaseModel with _$PurchaseModel {
  const factory PurchaseModel({
    @JsonKey(name: '_id') String? id,
    @Default(PurchaseBillData()) PurchaseBillData billData,
    @Default(PurchasePartyData()) PurchasePartyData partyData,
    @Default([]) List<PurchaseItem> items,
    @Default([]) List<PurchaseTax> taxes,
    @Default(0.0) double subtotal,
    @Default(0.0) double taxesAmount,
    @Default(0.0) double netAmount,
    @Default(0.0) double paidAmount,
    @Default(0.0) double dueAmount,
    @Default(0) int orderQty,
    @Default(0) int receivedQty,
    @Default(0) int balQty,
    String? remark,
    @Default('Pending') String status,
    String? sourcePurchaseId, // To link PO to Challan/Invoice
    String? orderType, // 'LENS' or 'RX'
    String? companyId,
    String? createdAt,
    String? updatedAt,
  }) = _PurchaseModel;

  factory PurchaseModel.fromJson(Map<String, dynamic> json) =>
      _$PurchaseModelFromJson(json);
}

@freezed
class PurchaseBillData with _$PurchaseBillData {
  const factory PurchaseBillData({
    @Default('') String billSeries,
    @Default('') String billNo,
    String? date,
    @Default('') String billType,
    @Default('') String godown,
    @Default('') String bookedBy,
    @Default('') String bankAccount,
  }) = _PurchaseBillData;

  factory PurchaseBillData.fromJson(Map<String, dynamic> json) =>
      _$PurchaseBillDataFromJson(json);
}

@freezed
class PurchasePartyData with _$PurchasePartyData {
  const factory PurchasePartyData({
    @Default('') String partyAccount,
    @Default('') String contactNumber,
    @Default('') String address,
    @Default('') String stateCode,
    @Default(0.0) double creditLimit,
    @Default(CurrentBalance()) CurrentBalance currentBalance,
  }) = _PurchasePartyData;

  factory PurchasePartyData.fromJson(Map<String, dynamic> json) =>
      _$PurchasePartyDataFromJson(json);
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
class PurchaseItem with _$PurchaseItem {
  const factory PurchaseItem({
    @JsonKey(name: '_id') String? id,
    @Default('') String barcode,
    @Default('') String itemName,
    @Default('') String billItemName,
    @Default('') String vendorItemName,
    @Default('') String orderNo,
    @Default('') String eye,
    @Default('') String sph,
    @Default('') String cyl,
    @Default('') String axis,
    @Default('') String add,
    @Default(0) int qty,
    @Default(0.0) double purchasePrice,
    @Default(0.0) double salePrice,
    @Default(0.0) double discount,
    @Default(0.0) double totalAmount,
    @Default('') String dia,
    @Default(0.0) double mrp,
    String? expiryDate,
    String? importDate,
    @Default('') String combinationId,
    @Default('') String vendor,
    String? remark,
    String? saleOrderItemId, // For RX-driven purchases
  }) = _PurchaseItem;

  factory PurchaseItem.fromJson(Map<String, dynamic> json) =>
      _$PurchaseItemFromJson(json);
}

@freezed
class PurchaseTax with _$PurchaseTax {
  const factory PurchaseTax({
    @JsonKey(name: '_id') String? id,
    @Default('') String taxName,
    @Default('Additive') String type,
    @Default(0.0) double percentage,
    @Default(0.0) double amount,
  }) = _PurchaseTax;

  factory PurchaseTax.fromJson(Map<String, dynamic> json) =>
      _$PurchaseTaxFromJson(json);
}
