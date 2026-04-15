// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ledger_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LedgerItemDetail _$LedgerItemDetailFromJson(Map<String, dynamic> json) =>
    LedgerItemDetail(
      itemName: _anyToString(json['itemName']),
      qty: (json['qty'] as num?)?.toDouble(),
      price: (json['price'] as num?)?.toDouble(),
      amount: (json['amount'] as num?)?.toDouble(),
      sph: _anyToString(json['sph']),
      cyl: _anyToString(json['cyl']),
      axis: _anyToString(json['axis']),
      add: _anyToString(json['add']),
      eye: _anyToString(json['eye']),
      orderNo: _anyToString(json['orderNo']),
    );

Map<String, dynamic> _$LedgerItemDetailToJson(LedgerItemDetail instance) =>
    <String, dynamic>{
      'itemName': instance.itemName,
      'qty': instance.qty,
      'price': instance.price,
      'amount': instance.amount,
      'sph': instance.sph,
      'cyl': instance.cyl,
      'axis': instance.axis,
      'add': instance.add,
      'eye': instance.eye,
      'orderNo': instance.orderNo,
    };

LedgerRow _$LedgerRowFromJson(Map<String, dynamic> json) => LedgerRow(
  sn: (json['sn'] as num?)?.toInt(),
  date: _anyToStringRequired(json['date']),
  transType: _anyToStringRequired(json['transType']),
  voucherNo: _anyToString(json['voucherNo']),
  debit: (json['debit'] as num).toDouble(),
  credit: (json['credit'] as num).toDouble(),
  balance: (json['balance'] as num).toDouble(),
  shortNarr: _anyToString(json['shortNarr']),
  remarks: _anyToString(json['remarks']),
  settlementDate: _anyToString(json['settlementDate']),
  sourceId: _anyToString(json['sourceId']),
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => LedgerItemDetail.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$LedgerRowToJson(LedgerRow instance) => <String, dynamic>{
  'sn': instance.sn,
  'date': instance.date,
  'transType': instance.transType,
  'voucherNo': instance.voucherNo,
  'debit': instance.debit,
  'credit': instance.credit,
  'balance': instance.balance,
  'shortNarr': instance.shortNarr,
  'remarks': instance.remarks,
  'settlementDate': instance.settlementDate,
  'sourceId': instance.sourceId,
  'items': instance.items,
};

LedgerReportResponse _$LedgerReportResponseFromJson(
  Map<String, dynamic> json,
) => LedgerReportResponse(
  success: json['success'] as bool,
  count: (json['count'] as num).toInt(),
  data: (json['data'] as List<dynamic>)
      .map((e) => LedgerRow.fromJson(e as Map<String, dynamic>))
      .toList(),
  openingBalance: (json['openingBalance'] as num).toDouble(),
  totalDebit: (json['totalDebit'] as num).toDouble(),
  totalCredit: (json['totalCredit'] as num).toDouble(),
  closingBalance: (json['closingBalance'] as num).toDouble(),
);

Map<String, dynamic> _$LedgerReportResponseToJson(
  LedgerReportResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'count': instance.count,
  'data': instance.data,
  'openingBalance': instance.openingBalance,
  'totalDebit': instance.totalDebit,
  'totalCredit': instance.totalCredit,
  'closingBalance': instance.closingBalance,
};
