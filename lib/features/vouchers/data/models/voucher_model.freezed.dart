// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'voucher_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VoucherModel _$VoucherModelFromJson(Map<String, dynamic> json) {
  return _VoucherModel.fromJson(json);
}

/// @nodoc
mixin _$VoucherModel {
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;
  String get recordType => throw _privateConstructorUsedError;
  String get billSeries => throw _privateConstructorUsedError;
  dynamic get billNo =>
      throw _privateConstructorUsedError; // can be string or num
  String? get date => throw _privateConstructorUsedError;
  String get gstApplicable => throw _privateConstructorUsedError;
  String get inputTaxCredit => throw _privateConstructorUsedError;
  String get rcm => throw _privateConstructorUsedError;
  List<VoucherRowModel> get rows => throw _privateConstructorUsedError;
  double get totalDebit => throw _privateConstructorUsedError;
  double get totalCredit => throw _privateConstructorUsedError;
  String? get remarks => throw _privateConstructorUsedError;
  String? get reffSeries => throw _privateConstructorUsedError;
  String? get reffPurchaseNo => throw _privateConstructorUsedError;
  String? get odrSeries => throw _privateConstructorUsedError;
  String? get vouchNo => throw _privateConstructorUsedError;
  String? get reffPurchaseDate => throw _privateConstructorUsedError;
  String? get other => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;
  String? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this VoucherModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VoucherModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VoucherModelCopyWith<VoucherModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VoucherModelCopyWith<$Res> {
  factory $VoucherModelCopyWith(
    VoucherModel value,
    $Res Function(VoucherModel) then,
  ) = _$VoucherModelCopyWithImpl<$Res, VoucherModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    String recordType,
    String billSeries,
    dynamic billNo,
    String? date,
    String gstApplicable,
    String inputTaxCredit,
    String rcm,
    List<VoucherRowModel> rows,
    double totalDebit,
    double totalCredit,
    String? remarks,
    String? reffSeries,
    String? reffPurchaseNo,
    String? odrSeries,
    String? vouchNo,
    String? reffPurchaseDate,
    String? other,
    String? createdAt,
    String? updatedAt,
  });
}

/// @nodoc
class _$VoucherModelCopyWithImpl<$Res, $Val extends VoucherModel>
    implements $VoucherModelCopyWith<$Res> {
  _$VoucherModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VoucherModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? recordType = null,
    Object? billSeries = null,
    Object? billNo = freezed,
    Object? date = freezed,
    Object? gstApplicable = null,
    Object? inputTaxCredit = null,
    Object? rcm = null,
    Object? rows = null,
    Object? totalDebit = null,
    Object? totalCredit = null,
    Object? remarks = freezed,
    Object? reffSeries = freezed,
    Object? reffPurchaseNo = freezed,
    Object? odrSeries = freezed,
    Object? vouchNo = freezed,
    Object? reffPurchaseDate = freezed,
    Object? other = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            recordType: null == recordType
                ? _value.recordType
                : recordType // ignore: cast_nullable_to_non_nullable
                      as String,
            billSeries: null == billSeries
                ? _value.billSeries
                : billSeries // ignore: cast_nullable_to_non_nullable
                      as String,
            billNo: freezed == billNo
                ? _value.billNo
                : billNo // ignore: cast_nullable_to_non_nullable
                      as dynamic,
            date: freezed == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String?,
            gstApplicable: null == gstApplicable
                ? _value.gstApplicable
                : gstApplicable // ignore: cast_nullable_to_non_nullable
                      as String,
            inputTaxCredit: null == inputTaxCredit
                ? _value.inputTaxCredit
                : inputTaxCredit // ignore: cast_nullable_to_non_nullable
                      as String,
            rcm: null == rcm
                ? _value.rcm
                : rcm // ignore: cast_nullable_to_non_nullable
                      as String,
            rows: null == rows
                ? _value.rows
                : rows // ignore: cast_nullable_to_non_nullable
                      as List<VoucherRowModel>,
            totalDebit: null == totalDebit
                ? _value.totalDebit
                : totalDebit // ignore: cast_nullable_to_non_nullable
                      as double,
            totalCredit: null == totalCredit
                ? _value.totalCredit
                : totalCredit // ignore: cast_nullable_to_non_nullable
                      as double,
            remarks: freezed == remarks
                ? _value.remarks
                : remarks // ignore: cast_nullable_to_non_nullable
                      as String?,
            reffSeries: freezed == reffSeries
                ? _value.reffSeries
                : reffSeries // ignore: cast_nullable_to_non_nullable
                      as String?,
            reffPurchaseNo: freezed == reffPurchaseNo
                ? _value.reffPurchaseNo
                : reffPurchaseNo // ignore: cast_nullable_to_non_nullable
                      as String?,
            odrSeries: freezed == odrSeries
                ? _value.odrSeries
                : odrSeries // ignore: cast_nullable_to_non_nullable
                      as String?,
            vouchNo: freezed == vouchNo
                ? _value.vouchNo
                : vouchNo // ignore: cast_nullable_to_non_nullable
                      as String?,
            reffPurchaseDate: freezed == reffPurchaseDate
                ? _value.reffPurchaseDate
                : reffPurchaseDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            other: freezed == other
                ? _value.other
                : other // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VoucherModelImplCopyWith<$Res>
    implements $VoucherModelCopyWith<$Res> {
  factory _$$VoucherModelImplCopyWith(
    _$VoucherModelImpl value,
    $Res Function(_$VoucherModelImpl) then,
  ) = __$$VoucherModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    String recordType,
    String billSeries,
    dynamic billNo,
    String? date,
    String gstApplicable,
    String inputTaxCredit,
    String rcm,
    List<VoucherRowModel> rows,
    double totalDebit,
    double totalCredit,
    String? remarks,
    String? reffSeries,
    String? reffPurchaseNo,
    String? odrSeries,
    String? vouchNo,
    String? reffPurchaseDate,
    String? other,
    String? createdAt,
    String? updatedAt,
  });
}

/// @nodoc
class __$$VoucherModelImplCopyWithImpl<$Res>
    extends _$VoucherModelCopyWithImpl<$Res, _$VoucherModelImpl>
    implements _$$VoucherModelImplCopyWith<$Res> {
  __$$VoucherModelImplCopyWithImpl(
    _$VoucherModelImpl _value,
    $Res Function(_$VoucherModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VoucherModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? recordType = null,
    Object? billSeries = null,
    Object? billNo = freezed,
    Object? date = freezed,
    Object? gstApplicable = null,
    Object? inputTaxCredit = null,
    Object? rcm = null,
    Object? rows = null,
    Object? totalDebit = null,
    Object? totalCredit = null,
    Object? remarks = freezed,
    Object? reffSeries = freezed,
    Object? reffPurchaseNo = freezed,
    Object? odrSeries = freezed,
    Object? vouchNo = freezed,
    Object? reffPurchaseDate = freezed,
    Object? other = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$VoucherModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        recordType: null == recordType
            ? _value.recordType
            : recordType // ignore: cast_nullable_to_non_nullable
                  as String,
        billSeries: null == billSeries
            ? _value.billSeries
            : billSeries // ignore: cast_nullable_to_non_nullable
                  as String,
        billNo: freezed == billNo
            ? _value.billNo
            : billNo // ignore: cast_nullable_to_non_nullable
                  as dynamic,
        date: freezed == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String?,
        gstApplicable: null == gstApplicable
            ? _value.gstApplicable
            : gstApplicable // ignore: cast_nullable_to_non_nullable
                  as String,
        inputTaxCredit: null == inputTaxCredit
            ? _value.inputTaxCredit
            : inputTaxCredit // ignore: cast_nullable_to_non_nullable
                  as String,
        rcm: null == rcm
            ? _value.rcm
            : rcm // ignore: cast_nullable_to_non_nullable
                  as String,
        rows: null == rows
            ? _value._rows
            : rows // ignore: cast_nullable_to_non_nullable
                  as List<VoucherRowModel>,
        totalDebit: null == totalDebit
            ? _value.totalDebit
            : totalDebit // ignore: cast_nullable_to_non_nullable
                  as double,
        totalCredit: null == totalCredit
            ? _value.totalCredit
            : totalCredit // ignore: cast_nullable_to_non_nullable
                  as double,
        remarks: freezed == remarks
            ? _value.remarks
            : remarks // ignore: cast_nullable_to_non_nullable
                  as String?,
        reffSeries: freezed == reffSeries
            ? _value.reffSeries
            : reffSeries // ignore: cast_nullable_to_non_nullable
                  as String?,
        reffPurchaseNo: freezed == reffPurchaseNo
            ? _value.reffPurchaseNo
            : reffPurchaseNo // ignore: cast_nullable_to_non_nullable
                  as String?,
        odrSeries: freezed == odrSeries
            ? _value.odrSeries
            : odrSeries // ignore: cast_nullable_to_non_nullable
                  as String?,
        vouchNo: freezed == vouchNo
            ? _value.vouchNo
            : vouchNo // ignore: cast_nullable_to_non_nullable
                  as String?,
        reffPurchaseDate: freezed == reffPurchaseDate
            ? _value.reffPurchaseDate
            : reffPurchaseDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        other: freezed == other
            ? _value.other
            : other // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VoucherModelImpl implements _VoucherModel {
  const _$VoucherModelImpl({
    @JsonKey(name: '_id') this.id,
    this.recordType = 'Payment',
    this.billSeries = '',
    this.billNo = '',
    this.date,
    this.gstApplicable = 'Not Applicable',
    this.inputTaxCredit = 'Not Applicable',
    this.rcm = 'Not Applicable',
    final List<VoucherRowModel> rows = const [],
    this.totalDebit = 0.0,
    this.totalCredit = 0.0,
    this.remarks,
    this.reffSeries,
    this.reffPurchaseNo,
    this.odrSeries,
    this.vouchNo,
    this.reffPurchaseDate,
    this.other,
    this.createdAt,
    this.updatedAt,
  }) : _rows = rows;

  factory _$VoucherModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VoucherModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String? id;
  @override
  @JsonKey()
  final String recordType;
  @override
  @JsonKey()
  final String billSeries;
  @override
  @JsonKey()
  final dynamic billNo;
  // can be string or num
  @override
  final String? date;
  @override
  @JsonKey()
  final String gstApplicable;
  @override
  @JsonKey()
  final String inputTaxCredit;
  @override
  @JsonKey()
  final String rcm;
  final List<VoucherRowModel> _rows;
  @override
  @JsonKey()
  List<VoucherRowModel> get rows {
    if (_rows is EqualUnmodifiableListView) return _rows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rows);
  }

  @override
  @JsonKey()
  final double totalDebit;
  @override
  @JsonKey()
  final double totalCredit;
  @override
  final String? remarks;
  @override
  final String? reffSeries;
  @override
  final String? reffPurchaseNo;
  @override
  final String? odrSeries;
  @override
  final String? vouchNo;
  @override
  final String? reffPurchaseDate;
  @override
  final String? other;
  @override
  final String? createdAt;
  @override
  final String? updatedAt;

  @override
  String toString() {
    return 'VoucherModel(id: $id, recordType: $recordType, billSeries: $billSeries, billNo: $billNo, date: $date, gstApplicable: $gstApplicable, inputTaxCredit: $inputTaxCredit, rcm: $rcm, rows: $rows, totalDebit: $totalDebit, totalCredit: $totalCredit, remarks: $remarks, reffSeries: $reffSeries, reffPurchaseNo: $reffPurchaseNo, odrSeries: $odrSeries, vouchNo: $vouchNo, reffPurchaseDate: $reffPurchaseDate, other: $other, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VoucherModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.recordType, recordType) ||
                other.recordType == recordType) &&
            (identical(other.billSeries, billSeries) ||
                other.billSeries == billSeries) &&
            const DeepCollectionEquality().equals(other.billNo, billNo) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.gstApplicable, gstApplicable) ||
                other.gstApplicable == gstApplicable) &&
            (identical(other.inputTaxCredit, inputTaxCredit) ||
                other.inputTaxCredit == inputTaxCredit) &&
            (identical(other.rcm, rcm) || other.rcm == rcm) &&
            const DeepCollectionEquality().equals(other._rows, _rows) &&
            (identical(other.totalDebit, totalDebit) ||
                other.totalDebit == totalDebit) &&
            (identical(other.totalCredit, totalCredit) ||
                other.totalCredit == totalCredit) &&
            (identical(other.remarks, remarks) || other.remarks == remarks) &&
            (identical(other.reffSeries, reffSeries) ||
                other.reffSeries == reffSeries) &&
            (identical(other.reffPurchaseNo, reffPurchaseNo) ||
                other.reffPurchaseNo == reffPurchaseNo) &&
            (identical(other.odrSeries, odrSeries) ||
                other.odrSeries == odrSeries) &&
            (identical(other.vouchNo, vouchNo) || other.vouchNo == vouchNo) &&
            (identical(other.reffPurchaseDate, reffPurchaseDate) ||
                other.reffPurchaseDate == reffPurchaseDate) &&
            (identical(other.other, this.other) || other.other == this.other) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    recordType,
    billSeries,
    const DeepCollectionEquality().hash(billNo),
    date,
    gstApplicable,
    inputTaxCredit,
    rcm,
    const DeepCollectionEquality().hash(_rows),
    totalDebit,
    totalCredit,
    remarks,
    reffSeries,
    reffPurchaseNo,
    odrSeries,
    vouchNo,
    reffPurchaseDate,
    other,
    createdAt,
    updatedAt,
  ]);

  /// Create a copy of VoucherModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VoucherModelImplCopyWith<_$VoucherModelImpl> get copyWith =>
      __$$VoucherModelImplCopyWithImpl<_$VoucherModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VoucherModelImplToJson(this);
  }
}

abstract class _VoucherModel implements VoucherModel {
  const factory _VoucherModel({
    @JsonKey(name: '_id') final String? id,
    final String recordType,
    final String billSeries,
    final dynamic billNo,
    final String? date,
    final String gstApplicable,
    final String inputTaxCredit,
    final String rcm,
    final List<VoucherRowModel> rows,
    final double totalDebit,
    final double totalCredit,
    final String? remarks,
    final String? reffSeries,
    final String? reffPurchaseNo,
    final String? odrSeries,
    final String? vouchNo,
    final String? reffPurchaseDate,
    final String? other,
    final String? createdAt,
    final String? updatedAt,
  }) = _$VoucherModelImpl;

  factory _VoucherModel.fromJson(Map<String, dynamic> json) =
      _$VoucherModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String? get id;
  @override
  String get recordType;
  @override
  String get billSeries;
  @override
  dynamic get billNo; // can be string or num
  @override
  String? get date;
  @override
  String get gstApplicable;
  @override
  String get inputTaxCredit;
  @override
  String get rcm;
  @override
  List<VoucherRowModel> get rows;
  @override
  double get totalDebit;
  @override
  double get totalCredit;
  @override
  String? get remarks;
  @override
  String? get reffSeries;
  @override
  String? get reffPurchaseNo;
  @override
  String? get odrSeries;
  @override
  String? get vouchNo;
  @override
  String? get reffPurchaseDate;
  @override
  String? get other;
  @override
  String? get createdAt;
  @override
  String? get updatedAt;

  /// Create a copy of VoucherModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VoucherModelImplCopyWith<_$VoucherModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VoucherRowModel _$VoucherRowModelFromJson(Map<String, dynamic> json) {
  return _VoucherRowModel.fromJson(json);
}

/// @nodoc
mixin _$VoucherRowModel {
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;
  int get sn => throw _privateConstructorUsedError;
  String get dc => throw _privateConstructorUsedError; // 'C' or 'D'
  String get account => throw _privateConstructorUsedError;
  String get accountId => throw _privateConstructorUsedError;
  double get balance => throw _privateConstructorUsedError;
  double get debit => throw _privateConstructorUsedError;
  double get credit => throw _privateConstructorUsedError;
  String get modeOfPayment => throw _privateConstructorUsedError;
  String? get docType => throw _privateConstructorUsedError;
  String? get chqDocNo => throw _privateConstructorUsedError;
  String? get chqDocDate => throw _privateConstructorUsedError;
  String? get shortNarration => throw _privateConstructorUsedError;
  String? get remark => throw _privateConstructorUsedError;

  /// Serializes this VoucherRowModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VoucherRowModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VoucherRowModelCopyWith<VoucherRowModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VoucherRowModelCopyWith<$Res> {
  factory $VoucherRowModelCopyWith(
    VoucherRowModel value,
    $Res Function(VoucherRowModel) then,
  ) = _$VoucherRowModelCopyWithImpl<$Res, VoucherRowModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    int sn,
    String dc,
    String account,
    String accountId,
    double balance,
    double debit,
    double credit,
    String modeOfPayment,
    String? docType,
    String? chqDocNo,
    String? chqDocDate,
    String? shortNarration,
    String? remark,
  });
}

/// @nodoc
class _$VoucherRowModelCopyWithImpl<$Res, $Val extends VoucherRowModel>
    implements $VoucherRowModelCopyWith<$Res> {
  _$VoucherRowModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VoucherRowModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? sn = null,
    Object? dc = null,
    Object? account = null,
    Object? accountId = null,
    Object? balance = null,
    Object? debit = null,
    Object? credit = null,
    Object? modeOfPayment = null,
    Object? docType = freezed,
    Object? chqDocNo = freezed,
    Object? chqDocDate = freezed,
    Object? shortNarration = freezed,
    Object? remark = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            sn: null == sn
                ? _value.sn
                : sn // ignore: cast_nullable_to_non_nullable
                      as int,
            dc: null == dc
                ? _value.dc
                : dc // ignore: cast_nullable_to_non_nullable
                      as String,
            account: null == account
                ? _value.account
                : account // ignore: cast_nullable_to_non_nullable
                      as String,
            accountId: null == accountId
                ? _value.accountId
                : accountId // ignore: cast_nullable_to_non_nullable
                      as String,
            balance: null == balance
                ? _value.balance
                : balance // ignore: cast_nullable_to_non_nullable
                      as double,
            debit: null == debit
                ? _value.debit
                : debit // ignore: cast_nullable_to_non_nullable
                      as double,
            credit: null == credit
                ? _value.credit
                : credit // ignore: cast_nullable_to_non_nullable
                      as double,
            modeOfPayment: null == modeOfPayment
                ? _value.modeOfPayment
                : modeOfPayment // ignore: cast_nullable_to_non_nullable
                      as String,
            docType: freezed == docType
                ? _value.docType
                : docType // ignore: cast_nullable_to_non_nullable
                      as String?,
            chqDocNo: freezed == chqDocNo
                ? _value.chqDocNo
                : chqDocNo // ignore: cast_nullable_to_non_nullable
                      as String?,
            chqDocDate: freezed == chqDocDate
                ? _value.chqDocDate
                : chqDocDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            shortNarration: freezed == shortNarration
                ? _value.shortNarration
                : shortNarration // ignore: cast_nullable_to_non_nullable
                      as String?,
            remark: freezed == remark
                ? _value.remark
                : remark // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VoucherRowModelImplCopyWith<$Res>
    implements $VoucherRowModelCopyWith<$Res> {
  factory _$$VoucherRowModelImplCopyWith(
    _$VoucherRowModelImpl value,
    $Res Function(_$VoucherRowModelImpl) then,
  ) = __$$VoucherRowModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    int sn,
    String dc,
    String account,
    String accountId,
    double balance,
    double debit,
    double credit,
    String modeOfPayment,
    String? docType,
    String? chqDocNo,
    String? chqDocDate,
    String? shortNarration,
    String? remark,
  });
}

/// @nodoc
class __$$VoucherRowModelImplCopyWithImpl<$Res>
    extends _$VoucherRowModelCopyWithImpl<$Res, _$VoucherRowModelImpl>
    implements _$$VoucherRowModelImplCopyWith<$Res> {
  __$$VoucherRowModelImplCopyWithImpl(
    _$VoucherRowModelImpl _value,
    $Res Function(_$VoucherRowModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VoucherRowModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? sn = null,
    Object? dc = null,
    Object? account = null,
    Object? accountId = null,
    Object? balance = null,
    Object? debit = null,
    Object? credit = null,
    Object? modeOfPayment = null,
    Object? docType = freezed,
    Object? chqDocNo = freezed,
    Object? chqDocDate = freezed,
    Object? shortNarration = freezed,
    Object? remark = freezed,
  }) {
    return _then(
      _$VoucherRowModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        sn: null == sn
            ? _value.sn
            : sn // ignore: cast_nullable_to_non_nullable
                  as int,
        dc: null == dc
            ? _value.dc
            : dc // ignore: cast_nullable_to_non_nullable
                  as String,
        account: null == account
            ? _value.account
            : account // ignore: cast_nullable_to_non_nullable
                  as String,
        accountId: null == accountId
            ? _value.accountId
            : accountId // ignore: cast_nullable_to_non_nullable
                  as String,
        balance: null == balance
            ? _value.balance
            : balance // ignore: cast_nullable_to_non_nullable
                  as double,
        debit: null == debit
            ? _value.debit
            : debit // ignore: cast_nullable_to_non_nullable
                  as double,
        credit: null == credit
            ? _value.credit
            : credit // ignore: cast_nullable_to_non_nullable
                  as double,
        modeOfPayment: null == modeOfPayment
            ? _value.modeOfPayment
            : modeOfPayment // ignore: cast_nullable_to_non_nullable
                  as String,
        docType: freezed == docType
            ? _value.docType
            : docType // ignore: cast_nullable_to_non_nullable
                  as String?,
        chqDocNo: freezed == chqDocNo
            ? _value.chqDocNo
            : chqDocNo // ignore: cast_nullable_to_non_nullable
                  as String?,
        chqDocDate: freezed == chqDocDate
            ? _value.chqDocDate
            : chqDocDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        shortNarration: freezed == shortNarration
            ? _value.shortNarration
            : shortNarration // ignore: cast_nullable_to_non_nullable
                  as String?,
        remark: freezed == remark
            ? _value.remark
            : remark // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VoucherRowModelImpl implements _VoucherRowModel {
  const _$VoucherRowModelImpl({
    @JsonKey(name: '_id') this.id,
    this.sn = 0,
    this.dc = 'D',
    this.account = '',
    this.accountId = '',
    this.balance = 0.0,
    this.debit = 0.0,
    this.credit = 0.0,
    this.modeOfPayment = 'Cash',
    this.docType,
    this.chqDocNo,
    this.chqDocDate,
    this.shortNarration,
    this.remark,
  });

  factory _$VoucherRowModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VoucherRowModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String? id;
  @override
  @JsonKey()
  final int sn;
  @override
  @JsonKey()
  final String dc;
  // 'C' or 'D'
  @override
  @JsonKey()
  final String account;
  @override
  @JsonKey()
  final String accountId;
  @override
  @JsonKey()
  final double balance;
  @override
  @JsonKey()
  final double debit;
  @override
  @JsonKey()
  final double credit;
  @override
  @JsonKey()
  final String modeOfPayment;
  @override
  final String? docType;
  @override
  final String? chqDocNo;
  @override
  final String? chqDocDate;
  @override
  final String? shortNarration;
  @override
  final String? remark;

  @override
  String toString() {
    return 'VoucherRowModel(id: $id, sn: $sn, dc: $dc, account: $account, accountId: $accountId, balance: $balance, debit: $debit, credit: $credit, modeOfPayment: $modeOfPayment, docType: $docType, chqDocNo: $chqDocNo, chqDocDate: $chqDocDate, shortNarration: $shortNarration, remark: $remark)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VoucherRowModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sn, sn) || other.sn == sn) &&
            (identical(other.dc, dc) || other.dc == dc) &&
            (identical(other.account, account) || other.account == account) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.debit, debit) || other.debit == debit) &&
            (identical(other.credit, credit) || other.credit == credit) &&
            (identical(other.modeOfPayment, modeOfPayment) ||
                other.modeOfPayment == modeOfPayment) &&
            (identical(other.docType, docType) || other.docType == docType) &&
            (identical(other.chqDocNo, chqDocNo) ||
                other.chqDocNo == chqDocNo) &&
            (identical(other.chqDocDate, chqDocDate) ||
                other.chqDocDate == chqDocDate) &&
            (identical(other.shortNarration, shortNarration) ||
                other.shortNarration == shortNarration) &&
            (identical(other.remark, remark) || other.remark == remark));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    sn,
    dc,
    account,
    accountId,
    balance,
    debit,
    credit,
    modeOfPayment,
    docType,
    chqDocNo,
    chqDocDate,
    shortNarration,
    remark,
  );

  /// Create a copy of VoucherRowModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VoucherRowModelImplCopyWith<_$VoucherRowModelImpl> get copyWith =>
      __$$VoucherRowModelImplCopyWithImpl<_$VoucherRowModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$VoucherRowModelImplToJson(this);
  }
}

abstract class _VoucherRowModel implements VoucherRowModel {
  const factory _VoucherRowModel({
    @JsonKey(name: '_id') final String? id,
    final int sn,
    final String dc,
    final String account,
    final String accountId,
    final double balance,
    final double debit,
    final double credit,
    final String modeOfPayment,
    final String? docType,
    final String? chqDocNo,
    final String? chqDocDate,
    final String? shortNarration,
    final String? remark,
  }) = _$VoucherRowModelImpl;

  factory _VoucherRowModel.fromJson(Map<String, dynamic> json) =
      _$VoucherRowModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String? get id;
  @override
  int get sn;
  @override
  String get dc; // 'C' or 'D'
  @override
  String get account;
  @override
  String get accountId;
  @override
  double get balance;
  @override
  double get debit;
  @override
  double get credit;
  @override
  String get modeOfPayment;
  @override
  String? get docType;
  @override
  String? get chqDocNo;
  @override
  String? get chqDocDate;
  @override
  String? get shortNarration;
  @override
  String? get remark;

  /// Create a copy of VoucherRowModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VoucherRowModelImplCopyWith<_$VoucherRowModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
