// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StockAuditItemImpl _$$StockAuditItemImplFromJson(Map<String, dynamic> json) =>
    _$StockAuditItemImpl(
      productName: json['productName'] as String,
      groupName: json['groupName'] as String,
      systemStock: (json['systemStock'] as num).toDouble(),
      physicalStock: (json['physicalStock'] as num?)?.toDouble() ?? 0.0,
      variance: (json['variance'] as num?)?.toDouble() ?? 0.0,
      barcode: json['barcode'] as String?,
      lensInfo: json['lensInfo'] == null
          ? null
          : StockAuditLensInfo.fromJson(
              json['lensInfo'] as Map<String, dynamic>,
            ),
      isVerified: json['isVerified'] as bool? ?? false,
      location: json['location'] as String?,
    );

Map<String, dynamic> _$$StockAuditItemImplToJson(
  _$StockAuditItemImpl instance,
) => <String, dynamic>{
  'productName': instance.productName,
  'groupName': instance.groupName,
  'systemStock': instance.systemStock,
  'physicalStock': instance.physicalStock,
  'variance': instance.variance,
  'barcode': instance.barcode,
  'lensInfo': instance.lensInfo,
  'isVerified': instance.isVerified,
  'location': instance.location,
};

_$StockAuditLensInfoImpl _$$StockAuditLensInfoImplFromJson(
  Map<String, dynamic> json,
) => _$StockAuditLensInfoImpl(
  sph: json['sph'] as String?,
  cyl: json['cyl'] as String?,
  eye: json['eye'] as String?,
  axis: json['axis'] as String?,
  add: json['add'] as String?,
);

Map<String, dynamic> _$$StockAuditLensInfoImplToJson(
  _$StockAuditLensInfoImpl instance,
) => <String, dynamic>{
  'sph': instance.sph,
  'cyl': instance.cyl,
  'eye': instance.eye,
  'axis': instance.axis,
  'add': instance.add,
};

_$BillingAuditItemImpl _$$BillingAuditItemImplFromJson(
  Map<String, dynamic> json,
) => _$BillingAuditItemImpl(
  invoiceNo: json['invoiceNo'] as String,
  date: json['date'] as String,
  partyName: json['partyName'] as String,
  systemAmount: (json['systemAmount'] as num?)?.toDouble() ?? 0.0,
  recalculatedAmount: (json['recalculatedAmount'] as num?)?.toDouble() ?? 0.0,
  variance: (json['variance'] as num?)?.toDouble() ?? 0.0,
  taxDiscrepancy: (json['taxDiscrepancy'] as num?)?.toDouble() ?? 0.0,
  issues:
      (json['issues'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  isVerified: json['isVerified'] as bool? ?? false,
);

Map<String, dynamic> _$$BillingAuditItemImplToJson(
  _$BillingAuditItemImpl instance,
) => <String, dynamic>{
  'invoiceNo': instance.invoiceNo,
  'date': instance.date,
  'partyName': instance.partyName,
  'systemAmount': instance.systemAmount,
  'recalculatedAmount': instance.recalculatedAmount,
  'variance': instance.variance,
  'taxDiscrepancy': instance.taxDiscrepancy,
  'issues': instance.issues,
  'isVerified': instance.isVerified,
};

_$BankAuditItemImpl _$$BankAuditItemImplFromJson(Map<String, dynamic> json) =>
    _$BankAuditItemImpl(
      id: json['_id'] as String?,
      date: json['date'] as String,
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] as String,
      systemVoucherNo: json['systemVoucherNo'] as String?,
      isReconciled: json['isReconciled'] as bool? ?? false,
      bankName: json['bankName'] as String?,
      referenceNo: json['referenceNo'] as String?,
    );

Map<String, dynamic> _$$BankAuditItemImplToJson(_$BankAuditItemImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'date': instance.date,
      'description': instance.description,
      'amount': instance.amount,
      'type': instance.type,
      'systemVoucherNo': instance.systemVoucherNo,
      'isReconciled': instance.isReconciled,
      'bankName': instance.bankName,
      'referenceNo': instance.referenceNo,
    };
