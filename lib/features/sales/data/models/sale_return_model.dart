// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'lens_sale_order_model.dart';
import 'rx_sale_order_model.dart'; // Reuse RxOrderItem

part 'sale_return_model.freezed.dart';
part 'sale_return_model.g.dart';

@freezed
class SaleReturnModel with _$SaleReturnModel {
  const factory SaleReturnModel({
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
    @Default('SALE RETURN') String type, // Standard or RX
    String? createdAt,
    String? updatedAt,
  }) = _SaleReturnModel;

  factory SaleReturnModel.fromJson(Map<String, dynamic> json) =>
      _$SaleReturnModelFromJson(json);
}
