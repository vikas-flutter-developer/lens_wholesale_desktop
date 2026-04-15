// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'lens_sale_order_model.dart';
import 'rx_sale_order_model.dart'; // Reuse RxOrderItem

part 'rx_sale_model.freezed.dart';
part 'rx_sale_model.g.dart';

@freezed
class RxSaleModel with _$RxSaleModel {
  const factory RxSaleModel({
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
    @Default('Done') String status,
    @Default('RX SALE') String saleType,
    String? orderId, // Reference to original RxOrder
    String? orderNo,
    String? createdAt,
    String? updatedAt,
  }) = _RxSaleModel;

  factory RxSaleModel.fromJson(Map<String, dynamic> json) =>
      _$RxSaleModelFromJson(json);
}
