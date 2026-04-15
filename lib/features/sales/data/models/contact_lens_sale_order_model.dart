// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'lens_sale_order_model.dart'; // Inherit Party, BillData, and Tax models

part 'contact_lens_sale_order_model.freezed.dart';
part 'contact_lens_sale_order_model.g.dart';

@freezed
class ContactLensOrderItem with _$ContactLensOrderItem {
  const factory ContactLensOrderItem({
    @JsonKey(name: '_id') String? id,
    @Default('') String barcode,
    @Default('') String itemName,
    @Default('') String billItemName,
    @Default('') String vendorItemName,
    @Default('') String orderNo,
    @Default('') String eye,
    @Default(0.0) double sph,
    @Default(0.0) double cyl,
    @Default(0.0) double axis,
    @Default(0.0) double add,
    @Default('') String dia,
    @Default('') String vendor,
    String? importDate,
    String? expiryDate,
    @Default('') String remark,
    @Default(0) int qty,
    @Default('') String unit,
    @Default(0.0) double mrp,
    @Default(0.0) double salePrice,
    @Default(0.0) double discount,
    @Default(0.0) double totalAmount,
    @Default('') String combinationId,
    @Default('') String bookedBy,
  }) = _ContactLensOrderItem;

  factory ContactLensOrderItem.fromJson(Map<String, dynamic> json) =>
      _$ContactLensOrderItemFromJson(json);
}

@freezed
class ContactLensSaleOrderModel with _$ContactLensSaleOrderModel {
  const factory ContactLensSaleOrderModel({
    @JsonKey(name: '_id') String? id,
    @Default(SaleOrderBillData()) SaleOrderBillData billData,
    @Default(SaleOrderPartyData()) SaleOrderPartyData partyData,
    @Default([]) List<ContactLensOrderItem> items,
    @Default([]) List<SaleOrderTax> taxes,
    @Default(0.0) double subtotal,
    @Default(0.0) double taxesAmount,
    @Default(0.0) double netAmount,
    @Default(0.0) double paidAmount,
    @Default(0.0) double dueAmount,
    String? remark,
    @Default('Pending') String status,
    String? companyId,
    @Default('CONTACT LENS') String orderType,
    String? createdAt,
  }) = _ContactLensSaleOrderModel;

  factory ContactLensSaleOrderModel.fromJson(Map<String, dynamic> json) =>
      _$ContactLensSaleOrderModelFromJson(json);
}
