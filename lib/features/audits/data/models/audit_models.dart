import 'package:freezed_annotation/freezed_annotation.dart';

part 'audit_models.freezed.dart';
part 'audit_models.g.dart';

@freezed
class StockAuditItem with _$StockAuditItem {
  const factory StockAuditItem({
    required String productName,
    required String groupName,
    required double systemStock,
    @Default(0.0) double physicalStock,
    @Default(0.0) double variance,
    String? barcode,
    StockAuditLensInfo? lensInfo,
    @Default(false) bool isVerified,
    String? location,
  }) = _StockAuditItem;

  factory StockAuditItem.fromJson(Map<String, dynamic> json) => _$StockAuditItemFromJson(json);
}

@freezed
class StockAuditLensInfo with _$StockAuditLensInfo {
  const factory StockAuditLensInfo({
    String? sph,
    String? cyl,
    String? eye,
    String? axis,
    String? add,
  }) = _StockAuditLensInfo;

  factory StockAuditLensInfo.fromJson(Map<String, dynamic> json) => _$StockAuditLensInfoFromJson(json);
}

@freezed
class BillingAuditItem with _$BillingAuditItem {
  const factory BillingAuditItem({
    required String invoiceNo,
    required String date,
    required String partyName,
    @Default(0.0) double systemAmount,
    @Default(0.0) double recalculatedAmount,
    @Default(0.0) double variance,
    @Default(0.0) double taxDiscrepancy,
    @Default([]) List<String> issues,
    @Default(false) bool isVerified,
  }) = _BillingAuditItem;

  factory BillingAuditItem.fromJson(Map<String, dynamic> json) => _$BillingAuditItemFromJson(json);
}

@freezed
class BankAuditItem with _$BankAuditItem {
  const factory BankAuditItem({
    @JsonKey(name: '_id') String? id,
    required String date,
    required String description,
    required double amount,
    required String type, // 'Dr' or 'Cr'
    String? systemVoucherNo,
    @Default(false) bool isReconciled,
    String? bankName,
    String? referenceNo,
  }) = _BankAuditItem;

  factory BankAuditItem.fromJson(Map<String, dynamic> json) => _$BankAuditItemFromJson(json);
}
