// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'voucher_model.freezed.dart';
part 'voucher_model.g.dart';

@freezed
class VoucherModel with _$VoucherModel {
  const factory VoucherModel({
    @JsonKey(name: '_id') String? id,
    @Default('Payment') String recordType,
    @Default('') String billSeries,
    @Default('') dynamic billNo, // can be string or num
    String? date,
    @Default('Not Applicable') String gstApplicable,
    @Default('Not Applicable') String inputTaxCredit,
    @Default('Not Applicable') String rcm,
    @Default([]) List<VoucherRowModel> rows,
    @Default(0.0) double totalDebit,
    @Default(0.0) double totalCredit,
    String? remarks,
    String? reffSeries,
    String? reffPurchaseNo,
    String? odrSeries,
    String? vouchNo,
    String? reffPurchaseDate,
    String? other,
    String? createdAt,
    String? updatedAt,
  }) = _VoucherModel;

  factory VoucherModel.fromJson(Map<String, dynamic> json) =>
      _$VoucherModelFromJson(json);
}

@freezed
class VoucherRowModel with _$VoucherRowModel {
  const factory VoucherRowModel({
    @JsonKey(name: '_id') String? id,
    @Default(0) int sn,
    @Default('D') String dc, // 'C' or 'D'
    @Default('') String account,
    @Default('') String accountId,
    @Default(0.0) double balance,
    @Default(0.0) double debit,
    @Default(0.0) double credit,
    @Default('Cash') String modeOfPayment,
    String? docType,
    String? chqDocNo,
    String? chqDocDate,
    String? shortNarration,
    String? remark,
  }) = _VoucherRowModel;

  factory VoucherRowModel.fromJson(Map<String, dynamic> json) =>
      _$VoucherRowModelFromJson(json);
}
