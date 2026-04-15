// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'lens_sale_order_model.dart'; // Import to reuse sub-models

part 'lens_sale_invoice_model.freezed.dart';
part 'lens_sale_invoice_model.g.dart';

@freezed
class LensSaleInvoiceModel with _$LensSaleInvoiceModel {
  const factory LensSaleInvoiceModel({
    @JsonKey(name: '_id') String? id,
    @Default(SaleOrderBillData()) SaleOrderBillData billData,
    @Default(SaleOrderPartyData()) SaleOrderPartyData partyData,
    @Default([]) List<SaleOrderItem> items,
    @Default([]) List<SaleOrderTax> taxes,
    @Default(0) int invoiceQty,
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
    String? deliveryPerson,
    @Default('LENS') String orderType,
    String? createdAt,
  }) = _LensSaleInvoiceModel;

  factory LensSaleInvoiceModel.fromJson(Map<String, dynamic> json) =>
      _$LensSaleInvoiceModelFromJson(json);
}
