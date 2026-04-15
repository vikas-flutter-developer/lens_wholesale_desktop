// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voucher_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VoucherModelImpl _$$VoucherModelImplFromJson(Map<String, dynamic> json) =>
    _$VoucherModelImpl(
      id: json['_id'] as String?,
      recordType: json['recordType'] as String? ?? 'Payment',
      billSeries: json['billSeries'] as String? ?? '',
      billNo: json['billNo'] ?? '',
      date: json['date'] as String?,
      gstApplicable: json['gstApplicable'] as String? ?? 'Not Applicable',
      inputTaxCredit: json['inputTaxCredit'] as String? ?? 'Not Applicable',
      rcm: json['rcm'] as String? ?? 'Not Applicable',
      rows:
          (json['rows'] as List<dynamic>?)
              ?.map((e) => VoucherRowModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      totalDebit: (json['totalDebit'] as num?)?.toDouble() ?? 0.0,
      totalCredit: (json['totalCredit'] as num?)?.toDouble() ?? 0.0,
      remarks: json['remarks'] as String?,
      reffSeries: json['reffSeries'] as String?,
      reffPurchaseNo: json['reffPurchaseNo'] as String?,
      odrSeries: json['odrSeries'] as String?,
      vouchNo: json['vouchNo'] as String?,
      reffPurchaseDate: json['reffPurchaseDate'] as String?,
      other: json['other'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$$VoucherModelImplToJson(_$VoucherModelImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'recordType': instance.recordType,
      'billSeries': instance.billSeries,
      'billNo': instance.billNo,
      'date': instance.date,
      'gstApplicable': instance.gstApplicable,
      'inputTaxCredit': instance.inputTaxCredit,
      'rcm': instance.rcm,
      'rows': instance.rows,
      'totalDebit': instance.totalDebit,
      'totalCredit': instance.totalCredit,
      'remarks': instance.remarks,
      'reffSeries': instance.reffSeries,
      'reffPurchaseNo': instance.reffPurchaseNo,
      'odrSeries': instance.odrSeries,
      'vouchNo': instance.vouchNo,
      'reffPurchaseDate': instance.reffPurchaseDate,
      'other': instance.other,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

_$VoucherRowModelImpl _$$VoucherRowModelImplFromJson(
  Map<String, dynamic> json,
) => _$VoucherRowModelImpl(
  id: json['_id'] as String?,
  sn: (json['sn'] as num?)?.toInt() ?? 0,
  dc: json['dc'] as String? ?? 'D',
  account: json['account'] as String? ?? '',
  accountId: json['accountId'] as String? ?? '',
  balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
  debit: (json['debit'] as num?)?.toDouble() ?? 0.0,
  credit: (json['credit'] as num?)?.toDouble() ?? 0.0,
  modeOfPayment: json['modeOfPayment'] as String? ?? 'Cash',
  docType: json['docType'] as String?,
  chqDocNo: json['chqDocNo'] as String?,
  chqDocDate: json['chqDocDate'] as String?,
  shortNarration: json['shortNarration'] as String?,
  remark: json['remark'] as String?,
);

Map<String, dynamic> _$$VoucherRowModelImplToJson(
  _$VoucherRowModelImpl instance,
) => <String, dynamic>{
  '_id': instance.id,
  'sn': instance.sn,
  'dc': instance.dc,
  'account': instance.account,
  'accountId': instance.accountId,
  'balance': instance.balance,
  'debit': instance.debit,
  'credit': instance.credit,
  'modeOfPayment': instance.modeOfPayment,
  'docType': instance.docType,
  'chqDocNo': instance.chqDocNo,
  'chqDocDate': instance.chqDocDate,
  'shortNarration': instance.shortNarration,
  'remark': instance.remark,
};
