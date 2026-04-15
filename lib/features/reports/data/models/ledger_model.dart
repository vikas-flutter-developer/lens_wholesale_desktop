import 'package:json_annotation/json_annotation.dart';

part 'ledger_model.g.dart';

String? _anyToString(dynamic value) => value?.toString();
String _anyToStringRequired(dynamic value) => value?.toString() ?? '';

@JsonSerializable()
class LedgerItemDetail {
  @JsonKey(fromJson: _anyToString)
  final String? itemName;
  final double? qty;
  final double? price;
  final double? amount;
  @JsonKey(fromJson: _anyToString)
  final String? sph;
  @JsonKey(fromJson: _anyToString)
  final String? cyl;
  @JsonKey(fromJson: _anyToString)
  final String? axis;
  @JsonKey(fromJson: _anyToString)
  final String? add;
  @JsonKey(fromJson: _anyToString)
  final String? eye;
  @JsonKey(fromJson: _anyToString)
  final String? orderNo;

  LedgerItemDetail({
    this.itemName,
    this.qty,
    this.price,
    this.amount,
    this.sph,
    this.cyl,
    this.axis,
    this.add,
    this.eye,
    this.orderNo,
  });

  factory LedgerItemDetail.fromJson(Map<String, dynamic> json) => _$LedgerItemDetailFromJson(json);
  Map<String, dynamic> toJson() => _$LedgerItemDetailToJson(this);
}

@JsonSerializable()
class LedgerRow {
  final int? sn;
  @JsonKey(fromJson: _anyToStringRequired)
  final String date;
  @JsonKey(fromJson: _anyToStringRequired)
  final String transType;
  @JsonKey(fromJson: _anyToString)
  final String? voucherNo;
  final double debit;
  final double credit;
  final double balance;
  @JsonKey(fromJson: _anyToString)
  final String? shortNarr;
  @JsonKey(fromJson: _anyToString)
  final String? remarks;
  @JsonKey(fromJson: _anyToString)
  final String? settlementDate;
  @JsonKey(fromJson: _anyToString)
  final String? sourceId;
  final List<LedgerItemDetail>? items;

  LedgerRow({
    this.sn,
    required this.date,
    required this.transType,
    this.voucherNo,
    required this.debit,
    required this.credit,
    required this.balance,
    this.shortNarr,
    this.remarks,
    this.settlementDate,
    this.sourceId,
    this.items,
  });

  factory LedgerRow.fromJson(Map<String, dynamic> json) => _$LedgerRowFromJson(json);
  Map<String, dynamic> toJson() => _$LedgerRowToJson(this);
}

@JsonSerializable()
class LedgerReportResponse {
  final bool success;
  final int count;
  final List<LedgerRow> data;
  final double openingBalance;
  final double totalDebit;
  final double totalCredit;
  final double closingBalance;

  LedgerReportResponse({
    required this.success,
    required this.count,
    required this.data,
    required this.openingBalance,
    required this.totalDebit,
    required this.totalCredit,
    required this.closingBalance,
  });

  factory LedgerReportResponse.fromJson(Map<String, dynamic> json) => _$LedgerReportResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LedgerReportResponseToJson(this);
}
