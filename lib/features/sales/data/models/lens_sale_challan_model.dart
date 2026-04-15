// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'lens_sale_order_model.dart'; // Import to reuse sub-models

part 'lens_sale_challan_model.freezed.dart';
part 'lens_sale_challan_model.g.dart';

@freezed
class LensSaleChallanModel with _$LensSaleChallanModel {
  const factory LensSaleChallanModel({
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
    String? remark,
    @Default('Pending') String status,
    String? sourceSaleId,
    String? companyId,
  }) = _LensSaleChallanModel;

  factory LensSaleChallanModel.fromJson(Map<String, dynamic> json) =>
      _$LensSaleChallanModelFromJson(json);
}
