// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'lens_sale_order_model.dart';

part 'rx_sale_order_model.freezed.dart';
part 'rx_sale_order_model.g.dart';

@freezed
class RxOrderItem with _$RxOrderItem {
  const factory RxOrderItem({
    @JsonKey(name: '_id') String? id,
    @Default('') String barcode,
    @Default('') String itemName,
    @Default('') String billItemName,
    @Default('') String vendorItemName,
    @Default('') String unit,
    @Default('') String orderNo,
    @Default('') String dia,
    @Default('') String eye,
    @Default(0.0) double sph,
    @Default(0.0) double cyl,
    @Default(0.0) double axis,
    @Default(0.0) double add,
    @Default(0) int qty,
    @Default(0.0) double salePrice,
    @Default(0.0) double discount,
    @Default(0.0) double totalAmount,
    @Default(0.0) double sellPrice,
    @Default(0.0) double purchasePrice,
    @Default('') String combinationId,
    @Default('') String customer, // Patient Name
    @Default('') String vendor,
    @Default('Pending') String itemStatus,
    String? remark,
    @Default(0.0) double mrp,
    String? refId, // For Sale tracking back to Order
    String? createdAt,
  }) = _RxOrderItem;

  factory RxOrderItem.fromJson(Map<String, dynamic> json) =>
      _$RxOrderItemFromJson(json);
}

@freezed
class RxSaleOrderModel with _$RxSaleOrderModel {
  const factory RxSaleOrderModel({
    @JsonKey(name: '_id') String? id,
    @Default(SaleOrderBillData()) SaleOrderBillData billData,
    @Default(SaleOrderPartyData()) SaleOrderPartyData partyData,
    @Default([]) List<RxOrderItem> items,
    @Default([]) List<SaleOrderTax> taxes,
    @Default(0.0) double subtotal,
    @Default(0.0) double taxesAmount,
    @Default(0.0) double netAmount,
    @Default(0.0) double paidAmount,
    @Default(0.0) double dueAmount,
    String? remark,
    @Default('Pending') String status,
    @Default('RX') String orderType,
    String? createdAt,
    String? updatedAt,
  }) = _RxSaleOrderModel;

  factory RxSaleOrderModel.fromJson(Map<String, dynamic> json) =>
      _$RxSaleOrderModelFromJson(json);
}
