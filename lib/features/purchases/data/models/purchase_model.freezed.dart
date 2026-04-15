// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'purchase_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PurchaseModel _$PurchaseModelFromJson(Map<String, dynamic> json) {
  return _PurchaseModel.fromJson(json);
}

/// @nodoc
mixin _$PurchaseModel {
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;
  PurchaseBillData get billData => throw _privateConstructorUsedError;
  PurchasePartyData get partyData => throw _privateConstructorUsedError;
  List<PurchaseItem> get items => throw _privateConstructorUsedError;
  List<PurchaseTax> get taxes => throw _privateConstructorUsedError;
  double get subtotal => throw _privateConstructorUsedError;
  double get taxesAmount => throw _privateConstructorUsedError;
  double get netAmount => throw _privateConstructorUsedError;
  double get paidAmount => throw _privateConstructorUsedError;
  double get dueAmount => throw _privateConstructorUsedError;
  int get orderQty => throw _privateConstructorUsedError;
  int get receivedQty => throw _privateConstructorUsedError;
  int get balQty => throw _privateConstructorUsedError;
  String? get remark => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get sourcePurchaseId =>
      throw _privateConstructorUsedError; // To link PO to Challan/Invoice
  String? get orderType => throw _privateConstructorUsedError; // 'LENS' or 'RX'
  String? get companyId => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;
  String? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this PurchaseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PurchaseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PurchaseModelCopyWith<PurchaseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchaseModelCopyWith<$Res> {
  factory $PurchaseModelCopyWith(
    PurchaseModel value,
    $Res Function(PurchaseModel) then,
  ) = _$PurchaseModelCopyWithImpl<$Res, PurchaseModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    PurchaseBillData billData,
    PurchasePartyData partyData,
    List<PurchaseItem> items,
    List<PurchaseTax> taxes,
    double subtotal,
    double taxesAmount,
    double netAmount,
    double paidAmount,
    double dueAmount,
    int orderQty,
    int receivedQty,
    int balQty,
    String? remark,
    String status,
    String? sourcePurchaseId,
    String? orderType,
    String? companyId,
    String? createdAt,
    String? updatedAt,
  });

  $PurchaseBillDataCopyWith<$Res> get billData;
  $PurchasePartyDataCopyWith<$Res> get partyData;
}

/// @nodoc
class _$PurchaseModelCopyWithImpl<$Res, $Val extends PurchaseModel>
    implements $PurchaseModelCopyWith<$Res> {
  _$PurchaseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PurchaseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? billData = null,
    Object? partyData = null,
    Object? items = null,
    Object? taxes = null,
    Object? subtotal = null,
    Object? taxesAmount = null,
    Object? netAmount = null,
    Object? paidAmount = null,
    Object? dueAmount = null,
    Object? orderQty = null,
    Object? receivedQty = null,
    Object? balQty = null,
    Object? remark = freezed,
    Object? status = null,
    Object? sourcePurchaseId = freezed,
    Object? orderType = freezed,
    Object? companyId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            billData: null == billData
                ? _value.billData
                : billData // ignore: cast_nullable_to_non_nullable
                      as PurchaseBillData,
            partyData: null == partyData
                ? _value.partyData
                : partyData // ignore: cast_nullable_to_non_nullable
                      as PurchasePartyData,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<PurchaseItem>,
            taxes: null == taxes
                ? _value.taxes
                : taxes // ignore: cast_nullable_to_non_nullable
                      as List<PurchaseTax>,
            subtotal: null == subtotal
                ? _value.subtotal
                : subtotal // ignore: cast_nullable_to_non_nullable
                      as double,
            taxesAmount: null == taxesAmount
                ? _value.taxesAmount
                : taxesAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            netAmount: null == netAmount
                ? _value.netAmount
                : netAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            paidAmount: null == paidAmount
                ? _value.paidAmount
                : paidAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            dueAmount: null == dueAmount
                ? _value.dueAmount
                : dueAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            orderQty: null == orderQty
                ? _value.orderQty
                : orderQty // ignore: cast_nullable_to_non_nullable
                      as int,
            receivedQty: null == receivedQty
                ? _value.receivedQty
                : receivedQty // ignore: cast_nullable_to_non_nullable
                      as int,
            balQty: null == balQty
                ? _value.balQty
                : balQty // ignore: cast_nullable_to_non_nullable
                      as int,
            remark: freezed == remark
                ? _value.remark
                : remark // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            sourcePurchaseId: freezed == sourcePurchaseId
                ? _value.sourcePurchaseId
                : sourcePurchaseId // ignore: cast_nullable_to_non_nullable
                      as String?,
            orderType: freezed == orderType
                ? _value.orderType
                : orderType // ignore: cast_nullable_to_non_nullable
                      as String?,
            companyId: freezed == companyId
                ? _value.companyId
                : companyId // ignore: cast_nullable_to_non_nullable
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

  /// Create a copy of PurchaseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PurchaseBillDataCopyWith<$Res> get billData {
    return $PurchaseBillDataCopyWith<$Res>(_value.billData, (value) {
      return _then(_value.copyWith(billData: value) as $Val);
    });
  }

  /// Create a copy of PurchaseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PurchasePartyDataCopyWith<$Res> get partyData {
    return $PurchasePartyDataCopyWith<$Res>(_value.partyData, (value) {
      return _then(_value.copyWith(partyData: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PurchaseModelImplCopyWith<$Res>
    implements $PurchaseModelCopyWith<$Res> {
  factory _$$PurchaseModelImplCopyWith(
    _$PurchaseModelImpl value,
    $Res Function(_$PurchaseModelImpl) then,
  ) = __$$PurchaseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    PurchaseBillData billData,
    PurchasePartyData partyData,
    List<PurchaseItem> items,
    List<PurchaseTax> taxes,
    double subtotal,
    double taxesAmount,
    double netAmount,
    double paidAmount,
    double dueAmount,
    int orderQty,
    int receivedQty,
    int balQty,
    String? remark,
    String status,
    String? sourcePurchaseId,
    String? orderType,
    String? companyId,
    String? createdAt,
    String? updatedAt,
  });

  @override
  $PurchaseBillDataCopyWith<$Res> get billData;
  @override
  $PurchasePartyDataCopyWith<$Res> get partyData;
}

/// @nodoc
class __$$PurchaseModelImplCopyWithImpl<$Res>
    extends _$PurchaseModelCopyWithImpl<$Res, _$PurchaseModelImpl>
    implements _$$PurchaseModelImplCopyWith<$Res> {
  __$$PurchaseModelImplCopyWithImpl(
    _$PurchaseModelImpl _value,
    $Res Function(_$PurchaseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PurchaseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? billData = null,
    Object? partyData = null,
    Object? items = null,
    Object? taxes = null,
    Object? subtotal = null,
    Object? taxesAmount = null,
    Object? netAmount = null,
    Object? paidAmount = null,
    Object? dueAmount = null,
    Object? orderQty = null,
    Object? receivedQty = null,
    Object? balQty = null,
    Object? remark = freezed,
    Object? status = null,
    Object? sourcePurchaseId = freezed,
    Object? orderType = freezed,
    Object? companyId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$PurchaseModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        billData: null == billData
            ? _value.billData
            : billData // ignore: cast_nullable_to_non_nullable
                  as PurchaseBillData,
        partyData: null == partyData
            ? _value.partyData
            : partyData // ignore: cast_nullable_to_non_nullable
                  as PurchasePartyData,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<PurchaseItem>,
        taxes: null == taxes
            ? _value._taxes
            : taxes // ignore: cast_nullable_to_non_nullable
                  as List<PurchaseTax>,
        subtotal: null == subtotal
            ? _value.subtotal
            : subtotal // ignore: cast_nullable_to_non_nullable
                  as double,
        taxesAmount: null == taxesAmount
            ? _value.taxesAmount
            : taxesAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        netAmount: null == netAmount
            ? _value.netAmount
            : netAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        paidAmount: null == paidAmount
            ? _value.paidAmount
            : paidAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        dueAmount: null == dueAmount
            ? _value.dueAmount
            : dueAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        orderQty: null == orderQty
            ? _value.orderQty
            : orderQty // ignore: cast_nullable_to_non_nullable
                  as int,
        receivedQty: null == receivedQty
            ? _value.receivedQty
            : receivedQty // ignore: cast_nullable_to_non_nullable
                  as int,
        balQty: null == balQty
            ? _value.balQty
            : balQty // ignore: cast_nullable_to_non_nullable
                  as int,
        remark: freezed == remark
            ? _value.remark
            : remark // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        sourcePurchaseId: freezed == sourcePurchaseId
            ? _value.sourcePurchaseId
            : sourcePurchaseId // ignore: cast_nullable_to_non_nullable
                  as String?,
        orderType: freezed == orderType
            ? _value.orderType
            : orderType // ignore: cast_nullable_to_non_nullable
                  as String?,
        companyId: freezed == companyId
            ? _value.companyId
            : companyId // ignore: cast_nullable_to_non_nullable
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
class _$PurchaseModelImpl implements _PurchaseModel {
  const _$PurchaseModelImpl({
    @JsonKey(name: '_id') this.id,
    this.billData = const PurchaseBillData(),
    this.partyData = const PurchasePartyData(),
    final List<PurchaseItem> items = const [],
    final List<PurchaseTax> taxes = const [],
    this.subtotal = 0.0,
    this.taxesAmount = 0.0,
    this.netAmount = 0.0,
    this.paidAmount = 0.0,
    this.dueAmount = 0.0,
    this.orderQty = 0,
    this.receivedQty = 0,
    this.balQty = 0,
    this.remark,
    this.status = 'Pending',
    this.sourcePurchaseId,
    this.orderType,
    this.companyId,
    this.createdAt,
    this.updatedAt,
  }) : _items = items,
       _taxes = taxes;

  factory _$PurchaseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PurchaseModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String? id;
  @override
  @JsonKey()
  final PurchaseBillData billData;
  @override
  @JsonKey()
  final PurchasePartyData partyData;
  final List<PurchaseItem> _items;
  @override
  @JsonKey()
  List<PurchaseItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  final List<PurchaseTax> _taxes;
  @override
  @JsonKey()
  List<PurchaseTax> get taxes {
    if (_taxes is EqualUnmodifiableListView) return _taxes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_taxes);
  }

  @override
  @JsonKey()
  final double subtotal;
  @override
  @JsonKey()
  final double taxesAmount;
  @override
  @JsonKey()
  final double netAmount;
  @override
  @JsonKey()
  final double paidAmount;
  @override
  @JsonKey()
  final double dueAmount;
  @override
  @JsonKey()
  final int orderQty;
  @override
  @JsonKey()
  final int receivedQty;
  @override
  @JsonKey()
  final int balQty;
  @override
  final String? remark;
  @override
  @JsonKey()
  final String status;
  @override
  final String? sourcePurchaseId;
  // To link PO to Challan/Invoice
  @override
  final String? orderType;
  // 'LENS' or 'RX'
  @override
  final String? companyId;
  @override
  final String? createdAt;
  @override
  final String? updatedAt;

  @override
  String toString() {
    return 'PurchaseModel(id: $id, billData: $billData, partyData: $partyData, items: $items, taxes: $taxes, subtotal: $subtotal, taxesAmount: $taxesAmount, netAmount: $netAmount, paidAmount: $paidAmount, dueAmount: $dueAmount, orderQty: $orderQty, receivedQty: $receivedQty, balQty: $balQty, remark: $remark, status: $status, sourcePurchaseId: $sourcePurchaseId, orderType: $orderType, companyId: $companyId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchaseModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.billData, billData) ||
                other.billData == billData) &&
            (identical(other.partyData, partyData) ||
                other.partyData == partyData) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality().equals(other._taxes, _taxes) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.taxesAmount, taxesAmount) ||
                other.taxesAmount == taxesAmount) &&
            (identical(other.netAmount, netAmount) ||
                other.netAmount == netAmount) &&
            (identical(other.paidAmount, paidAmount) ||
                other.paidAmount == paidAmount) &&
            (identical(other.dueAmount, dueAmount) ||
                other.dueAmount == dueAmount) &&
            (identical(other.orderQty, orderQty) ||
                other.orderQty == orderQty) &&
            (identical(other.receivedQty, receivedQty) ||
                other.receivedQty == receivedQty) &&
            (identical(other.balQty, balQty) || other.balQty == balQty) &&
            (identical(other.remark, remark) || other.remark == remark) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.sourcePurchaseId, sourcePurchaseId) ||
                other.sourcePurchaseId == sourcePurchaseId) &&
            (identical(other.orderType, orderType) ||
                other.orderType == orderType) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
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
    billData,
    partyData,
    const DeepCollectionEquality().hash(_items),
    const DeepCollectionEquality().hash(_taxes),
    subtotal,
    taxesAmount,
    netAmount,
    paidAmount,
    dueAmount,
    orderQty,
    receivedQty,
    balQty,
    remark,
    status,
    sourcePurchaseId,
    orderType,
    companyId,
    createdAt,
    updatedAt,
  ]);

  /// Create a copy of PurchaseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PurchaseModelImplCopyWith<_$PurchaseModelImpl> get copyWith =>
      __$$PurchaseModelImplCopyWithImpl<_$PurchaseModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PurchaseModelImplToJson(this);
  }
}

abstract class _PurchaseModel implements PurchaseModel {
  const factory _PurchaseModel({
    @JsonKey(name: '_id') final String? id,
    final PurchaseBillData billData,
    final PurchasePartyData partyData,
    final List<PurchaseItem> items,
    final List<PurchaseTax> taxes,
    final double subtotal,
    final double taxesAmount,
    final double netAmount,
    final double paidAmount,
    final double dueAmount,
    final int orderQty,
    final int receivedQty,
    final int balQty,
    final String? remark,
    final String status,
    final String? sourcePurchaseId,
    final String? orderType,
    final String? companyId,
    final String? createdAt,
    final String? updatedAt,
  }) = _$PurchaseModelImpl;

  factory _PurchaseModel.fromJson(Map<String, dynamic> json) =
      _$PurchaseModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String? get id;
  @override
  PurchaseBillData get billData;
  @override
  PurchasePartyData get partyData;
  @override
  List<PurchaseItem> get items;
  @override
  List<PurchaseTax> get taxes;
  @override
  double get subtotal;
  @override
  double get taxesAmount;
  @override
  double get netAmount;
  @override
  double get paidAmount;
  @override
  double get dueAmount;
  @override
  int get orderQty;
  @override
  int get receivedQty;
  @override
  int get balQty;
  @override
  String? get remark;
  @override
  String get status;
  @override
  String? get sourcePurchaseId; // To link PO to Challan/Invoice
  @override
  String? get orderType; // 'LENS' or 'RX'
  @override
  String? get companyId;
  @override
  String? get createdAt;
  @override
  String? get updatedAt;

  /// Create a copy of PurchaseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PurchaseModelImplCopyWith<_$PurchaseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PurchaseBillData _$PurchaseBillDataFromJson(Map<String, dynamic> json) {
  return _PurchaseBillData.fromJson(json);
}

/// @nodoc
mixin _$PurchaseBillData {
  String get billSeries => throw _privateConstructorUsedError;
  String get billNo => throw _privateConstructorUsedError;
  String? get date => throw _privateConstructorUsedError;
  String get billType => throw _privateConstructorUsedError;
  String get godown => throw _privateConstructorUsedError;
  String get bookedBy => throw _privateConstructorUsedError;
  String get bankAccount => throw _privateConstructorUsedError;

  /// Serializes this PurchaseBillData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PurchaseBillData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PurchaseBillDataCopyWith<PurchaseBillData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchaseBillDataCopyWith<$Res> {
  factory $PurchaseBillDataCopyWith(
    PurchaseBillData value,
    $Res Function(PurchaseBillData) then,
  ) = _$PurchaseBillDataCopyWithImpl<$Res, PurchaseBillData>;
  @useResult
  $Res call({
    String billSeries,
    String billNo,
    String? date,
    String billType,
    String godown,
    String bookedBy,
    String bankAccount,
  });
}

/// @nodoc
class _$PurchaseBillDataCopyWithImpl<$Res, $Val extends PurchaseBillData>
    implements $PurchaseBillDataCopyWith<$Res> {
  _$PurchaseBillDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PurchaseBillData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? billSeries = null,
    Object? billNo = null,
    Object? date = freezed,
    Object? billType = null,
    Object? godown = null,
    Object? bookedBy = null,
    Object? bankAccount = null,
  }) {
    return _then(
      _value.copyWith(
            billSeries: null == billSeries
                ? _value.billSeries
                : billSeries // ignore: cast_nullable_to_non_nullable
                      as String,
            billNo: null == billNo
                ? _value.billNo
                : billNo // ignore: cast_nullable_to_non_nullable
                      as String,
            date: freezed == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String?,
            billType: null == billType
                ? _value.billType
                : billType // ignore: cast_nullable_to_non_nullable
                      as String,
            godown: null == godown
                ? _value.godown
                : godown // ignore: cast_nullable_to_non_nullable
                      as String,
            bookedBy: null == bookedBy
                ? _value.bookedBy
                : bookedBy // ignore: cast_nullable_to_non_nullable
                      as String,
            bankAccount: null == bankAccount
                ? _value.bankAccount
                : bankAccount // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PurchaseBillDataImplCopyWith<$Res>
    implements $PurchaseBillDataCopyWith<$Res> {
  factory _$$PurchaseBillDataImplCopyWith(
    _$PurchaseBillDataImpl value,
    $Res Function(_$PurchaseBillDataImpl) then,
  ) = __$$PurchaseBillDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String billSeries,
    String billNo,
    String? date,
    String billType,
    String godown,
    String bookedBy,
    String bankAccount,
  });
}

/// @nodoc
class __$$PurchaseBillDataImplCopyWithImpl<$Res>
    extends _$PurchaseBillDataCopyWithImpl<$Res, _$PurchaseBillDataImpl>
    implements _$$PurchaseBillDataImplCopyWith<$Res> {
  __$$PurchaseBillDataImplCopyWithImpl(
    _$PurchaseBillDataImpl _value,
    $Res Function(_$PurchaseBillDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PurchaseBillData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? billSeries = null,
    Object? billNo = null,
    Object? date = freezed,
    Object? billType = null,
    Object? godown = null,
    Object? bookedBy = null,
    Object? bankAccount = null,
  }) {
    return _then(
      _$PurchaseBillDataImpl(
        billSeries: null == billSeries
            ? _value.billSeries
            : billSeries // ignore: cast_nullable_to_non_nullable
                  as String,
        billNo: null == billNo
            ? _value.billNo
            : billNo // ignore: cast_nullable_to_non_nullable
                  as String,
        date: freezed == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String?,
        billType: null == billType
            ? _value.billType
            : billType // ignore: cast_nullable_to_non_nullable
                  as String,
        godown: null == godown
            ? _value.godown
            : godown // ignore: cast_nullable_to_non_nullable
                  as String,
        bookedBy: null == bookedBy
            ? _value.bookedBy
            : bookedBy // ignore: cast_nullable_to_non_nullable
                  as String,
        bankAccount: null == bankAccount
            ? _value.bankAccount
            : bankAccount // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PurchaseBillDataImpl implements _PurchaseBillData {
  const _$PurchaseBillDataImpl({
    this.billSeries = '',
    this.billNo = '',
    this.date,
    this.billType = '',
    this.godown = '',
    this.bookedBy = '',
    this.bankAccount = '',
  });

  factory _$PurchaseBillDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$PurchaseBillDataImplFromJson(json);

  @override
  @JsonKey()
  final String billSeries;
  @override
  @JsonKey()
  final String billNo;
  @override
  final String? date;
  @override
  @JsonKey()
  final String billType;
  @override
  @JsonKey()
  final String godown;
  @override
  @JsonKey()
  final String bookedBy;
  @override
  @JsonKey()
  final String bankAccount;

  @override
  String toString() {
    return 'PurchaseBillData(billSeries: $billSeries, billNo: $billNo, date: $date, billType: $billType, godown: $godown, bookedBy: $bookedBy, bankAccount: $bankAccount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchaseBillDataImpl &&
            (identical(other.billSeries, billSeries) ||
                other.billSeries == billSeries) &&
            (identical(other.billNo, billNo) || other.billNo == billNo) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.billType, billType) ||
                other.billType == billType) &&
            (identical(other.godown, godown) || other.godown == godown) &&
            (identical(other.bookedBy, bookedBy) ||
                other.bookedBy == bookedBy) &&
            (identical(other.bankAccount, bankAccount) ||
                other.bankAccount == bankAccount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    billSeries,
    billNo,
    date,
    billType,
    godown,
    bookedBy,
    bankAccount,
  );

  /// Create a copy of PurchaseBillData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PurchaseBillDataImplCopyWith<_$PurchaseBillDataImpl> get copyWith =>
      __$$PurchaseBillDataImplCopyWithImpl<_$PurchaseBillDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PurchaseBillDataImplToJson(this);
  }
}

abstract class _PurchaseBillData implements PurchaseBillData {
  const factory _PurchaseBillData({
    final String billSeries,
    final String billNo,
    final String? date,
    final String billType,
    final String godown,
    final String bookedBy,
    final String bankAccount,
  }) = _$PurchaseBillDataImpl;

  factory _PurchaseBillData.fromJson(Map<String, dynamic> json) =
      _$PurchaseBillDataImpl.fromJson;

  @override
  String get billSeries;
  @override
  String get billNo;
  @override
  String? get date;
  @override
  String get billType;
  @override
  String get godown;
  @override
  String get bookedBy;
  @override
  String get bankAccount;

  /// Create a copy of PurchaseBillData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PurchaseBillDataImplCopyWith<_$PurchaseBillDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PurchasePartyData _$PurchasePartyDataFromJson(Map<String, dynamic> json) {
  return _PurchasePartyData.fromJson(json);
}

/// @nodoc
mixin _$PurchasePartyData {
  String get partyAccount => throw _privateConstructorUsedError;
  String get contactNumber => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String get stateCode => throw _privateConstructorUsedError;
  double get creditLimit => throw _privateConstructorUsedError;
  CurrentBalance get currentBalance => throw _privateConstructorUsedError;

  /// Serializes this PurchasePartyData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PurchasePartyData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PurchasePartyDataCopyWith<PurchasePartyData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchasePartyDataCopyWith<$Res> {
  factory $PurchasePartyDataCopyWith(
    PurchasePartyData value,
    $Res Function(PurchasePartyData) then,
  ) = _$PurchasePartyDataCopyWithImpl<$Res, PurchasePartyData>;
  @useResult
  $Res call({
    String partyAccount,
    String contactNumber,
    String address,
    String stateCode,
    double creditLimit,
    CurrentBalance currentBalance,
  });

  $CurrentBalanceCopyWith<$Res> get currentBalance;
}

/// @nodoc
class _$PurchasePartyDataCopyWithImpl<$Res, $Val extends PurchasePartyData>
    implements $PurchasePartyDataCopyWith<$Res> {
  _$PurchasePartyDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PurchasePartyData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? partyAccount = null,
    Object? contactNumber = null,
    Object? address = null,
    Object? stateCode = null,
    Object? creditLimit = null,
    Object? currentBalance = null,
  }) {
    return _then(
      _value.copyWith(
            partyAccount: null == partyAccount
                ? _value.partyAccount
                : partyAccount // ignore: cast_nullable_to_non_nullable
                      as String,
            contactNumber: null == contactNumber
                ? _value.contactNumber
                : contactNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            address: null == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String,
            stateCode: null == stateCode
                ? _value.stateCode
                : stateCode // ignore: cast_nullable_to_non_nullable
                      as String,
            creditLimit: null == creditLimit
                ? _value.creditLimit
                : creditLimit // ignore: cast_nullable_to_non_nullable
                      as double,
            currentBalance: null == currentBalance
                ? _value.currentBalance
                : currentBalance // ignore: cast_nullable_to_non_nullable
                      as CurrentBalance,
          )
          as $Val,
    );
  }

  /// Create a copy of PurchasePartyData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CurrentBalanceCopyWith<$Res> get currentBalance {
    return $CurrentBalanceCopyWith<$Res>(_value.currentBalance, (value) {
      return _then(_value.copyWith(currentBalance: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PurchasePartyDataImplCopyWith<$Res>
    implements $PurchasePartyDataCopyWith<$Res> {
  factory _$$PurchasePartyDataImplCopyWith(
    _$PurchasePartyDataImpl value,
    $Res Function(_$PurchasePartyDataImpl) then,
  ) = __$$PurchasePartyDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String partyAccount,
    String contactNumber,
    String address,
    String stateCode,
    double creditLimit,
    CurrentBalance currentBalance,
  });

  @override
  $CurrentBalanceCopyWith<$Res> get currentBalance;
}

/// @nodoc
class __$$PurchasePartyDataImplCopyWithImpl<$Res>
    extends _$PurchasePartyDataCopyWithImpl<$Res, _$PurchasePartyDataImpl>
    implements _$$PurchasePartyDataImplCopyWith<$Res> {
  __$$PurchasePartyDataImplCopyWithImpl(
    _$PurchasePartyDataImpl _value,
    $Res Function(_$PurchasePartyDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PurchasePartyData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? partyAccount = null,
    Object? contactNumber = null,
    Object? address = null,
    Object? stateCode = null,
    Object? creditLimit = null,
    Object? currentBalance = null,
  }) {
    return _then(
      _$PurchasePartyDataImpl(
        partyAccount: null == partyAccount
            ? _value.partyAccount
            : partyAccount // ignore: cast_nullable_to_non_nullable
                  as String,
        contactNumber: null == contactNumber
            ? _value.contactNumber
            : contactNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        address: null == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String,
        stateCode: null == stateCode
            ? _value.stateCode
            : stateCode // ignore: cast_nullable_to_non_nullable
                  as String,
        creditLimit: null == creditLimit
            ? _value.creditLimit
            : creditLimit // ignore: cast_nullable_to_non_nullable
                  as double,
        currentBalance: null == currentBalance
            ? _value.currentBalance
            : currentBalance // ignore: cast_nullable_to_non_nullable
                  as CurrentBalance,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PurchasePartyDataImpl implements _PurchasePartyData {
  const _$PurchasePartyDataImpl({
    this.partyAccount = '',
    this.contactNumber = '',
    this.address = '',
    this.stateCode = '',
    this.creditLimit = 0.0,
    this.currentBalance = const CurrentBalance(),
  });

  factory _$PurchasePartyDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$PurchasePartyDataImplFromJson(json);

  @override
  @JsonKey()
  final String partyAccount;
  @override
  @JsonKey()
  final String contactNumber;
  @override
  @JsonKey()
  final String address;
  @override
  @JsonKey()
  final String stateCode;
  @override
  @JsonKey()
  final double creditLimit;
  @override
  @JsonKey()
  final CurrentBalance currentBalance;

  @override
  String toString() {
    return 'PurchasePartyData(partyAccount: $partyAccount, contactNumber: $contactNumber, address: $address, stateCode: $stateCode, creditLimit: $creditLimit, currentBalance: $currentBalance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchasePartyDataImpl &&
            (identical(other.partyAccount, partyAccount) ||
                other.partyAccount == partyAccount) &&
            (identical(other.contactNumber, contactNumber) ||
                other.contactNumber == contactNumber) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.stateCode, stateCode) ||
                other.stateCode == stateCode) &&
            (identical(other.creditLimit, creditLimit) ||
                other.creditLimit == creditLimit) &&
            (identical(other.currentBalance, currentBalance) ||
                other.currentBalance == currentBalance));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    partyAccount,
    contactNumber,
    address,
    stateCode,
    creditLimit,
    currentBalance,
  );

  /// Create a copy of PurchasePartyData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PurchasePartyDataImplCopyWith<_$PurchasePartyDataImpl> get copyWith =>
      __$$PurchasePartyDataImplCopyWithImpl<_$PurchasePartyDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PurchasePartyDataImplToJson(this);
  }
}

abstract class _PurchasePartyData implements PurchasePartyData {
  const factory _PurchasePartyData({
    final String partyAccount,
    final String contactNumber,
    final String address,
    final String stateCode,
    final double creditLimit,
    final CurrentBalance currentBalance,
  }) = _$PurchasePartyDataImpl;

  factory _PurchasePartyData.fromJson(Map<String, dynamic> json) =
      _$PurchasePartyDataImpl.fromJson;

  @override
  String get partyAccount;
  @override
  String get contactNumber;
  @override
  String get address;
  @override
  String get stateCode;
  @override
  double get creditLimit;
  @override
  CurrentBalance get currentBalance;

  /// Create a copy of PurchasePartyData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PurchasePartyDataImplCopyWith<_$PurchasePartyDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CurrentBalance _$CurrentBalanceFromJson(Map<String, dynamic> json) {
  return _CurrentBalance.fromJson(json);
}

/// @nodoc
mixin _$CurrentBalance {
  double get amount => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;

  /// Serializes this CurrentBalance to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CurrentBalance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CurrentBalanceCopyWith<CurrentBalance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CurrentBalanceCopyWith<$Res> {
  factory $CurrentBalanceCopyWith(
    CurrentBalance value,
    $Res Function(CurrentBalance) then,
  ) = _$CurrentBalanceCopyWithImpl<$Res, CurrentBalance>;
  @useResult
  $Res call({double amount, String type});
}

/// @nodoc
class _$CurrentBalanceCopyWithImpl<$Res, $Val extends CurrentBalance>
    implements $CurrentBalanceCopyWith<$Res> {
  _$CurrentBalanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CurrentBalance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? amount = null, Object? type = null}) {
    return _then(
      _value.copyWith(
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CurrentBalanceImplCopyWith<$Res>
    implements $CurrentBalanceCopyWith<$Res> {
  factory _$$CurrentBalanceImplCopyWith(
    _$CurrentBalanceImpl value,
    $Res Function(_$CurrentBalanceImpl) then,
  ) = __$$CurrentBalanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double amount, String type});
}

/// @nodoc
class __$$CurrentBalanceImplCopyWithImpl<$Res>
    extends _$CurrentBalanceCopyWithImpl<$Res, _$CurrentBalanceImpl>
    implements _$$CurrentBalanceImplCopyWith<$Res> {
  __$$CurrentBalanceImplCopyWithImpl(
    _$CurrentBalanceImpl _value,
    $Res Function(_$CurrentBalanceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CurrentBalance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? amount = null, Object? type = null}) {
    return _then(
      _$CurrentBalanceImpl(
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CurrentBalanceImpl implements _CurrentBalance {
  const _$CurrentBalanceImpl({this.amount = 0.0, this.type = 'Dr'});

  factory _$CurrentBalanceImpl.fromJson(Map<String, dynamic> json) =>
      _$$CurrentBalanceImplFromJson(json);

  @override
  @JsonKey()
  final double amount;
  @override
  @JsonKey()
  final String type;

  @override
  String toString() {
    return 'CurrentBalance(amount: $amount, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CurrentBalanceImpl &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, amount, type);

  /// Create a copy of CurrentBalance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CurrentBalanceImplCopyWith<_$CurrentBalanceImpl> get copyWith =>
      __$$CurrentBalanceImplCopyWithImpl<_$CurrentBalanceImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CurrentBalanceImplToJson(this);
  }
}

abstract class _CurrentBalance implements CurrentBalance {
  const factory _CurrentBalance({final double amount, final String type}) =
      _$CurrentBalanceImpl;

  factory _CurrentBalance.fromJson(Map<String, dynamic> json) =
      _$CurrentBalanceImpl.fromJson;

  @override
  double get amount;
  @override
  String get type;

  /// Create a copy of CurrentBalance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CurrentBalanceImplCopyWith<_$CurrentBalanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PurchaseItem _$PurchaseItemFromJson(Map<String, dynamic> json) {
  return _PurchaseItem.fromJson(json);
}

/// @nodoc
mixin _$PurchaseItem {
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;
  String get barcode => throw _privateConstructorUsedError;
  String get itemName => throw _privateConstructorUsedError;
  String get billItemName => throw _privateConstructorUsedError;
  String get vendorItemName => throw _privateConstructorUsedError;
  String get orderNo => throw _privateConstructorUsedError;
  String get eye => throw _privateConstructorUsedError;
  String get sph => throw _privateConstructorUsedError;
  String get cyl => throw _privateConstructorUsedError;
  String get axis => throw _privateConstructorUsedError;
  String get add => throw _privateConstructorUsedError;
  int get qty => throw _privateConstructorUsedError;
  double get purchasePrice => throw _privateConstructorUsedError;
  double get salePrice => throw _privateConstructorUsedError;
  double get discount => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  String get dia => throw _privateConstructorUsedError;
  double get mrp => throw _privateConstructorUsedError;
  String? get expiryDate => throw _privateConstructorUsedError;
  String? get importDate => throw _privateConstructorUsedError;
  String get combinationId => throw _privateConstructorUsedError;
  String get vendor => throw _privateConstructorUsedError;
  String? get remark => throw _privateConstructorUsedError;
  String? get saleOrderItemId => throw _privateConstructorUsedError;

  /// Serializes this PurchaseItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PurchaseItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PurchaseItemCopyWith<PurchaseItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchaseItemCopyWith<$Res> {
  factory $PurchaseItemCopyWith(
    PurchaseItem value,
    $Res Function(PurchaseItem) then,
  ) = _$PurchaseItemCopyWithImpl<$Res, PurchaseItem>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    String barcode,
    String itemName,
    String billItemName,
    String vendorItemName,
    String orderNo,
    String eye,
    String sph,
    String cyl,
    String axis,
    String add,
    int qty,
    double purchasePrice,
    double salePrice,
    double discount,
    double totalAmount,
    String dia,
    double mrp,
    String? expiryDate,
    String? importDate,
    String combinationId,
    String vendor,
    String? remark,
    String? saleOrderItemId,
  });
}

/// @nodoc
class _$PurchaseItemCopyWithImpl<$Res, $Val extends PurchaseItem>
    implements $PurchaseItemCopyWith<$Res> {
  _$PurchaseItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PurchaseItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? barcode = null,
    Object? itemName = null,
    Object? billItemName = null,
    Object? vendorItemName = null,
    Object? orderNo = null,
    Object? eye = null,
    Object? sph = null,
    Object? cyl = null,
    Object? axis = null,
    Object? add = null,
    Object? qty = null,
    Object? purchasePrice = null,
    Object? salePrice = null,
    Object? discount = null,
    Object? totalAmount = null,
    Object? dia = null,
    Object? mrp = null,
    Object? expiryDate = freezed,
    Object? importDate = freezed,
    Object? combinationId = null,
    Object? vendor = null,
    Object? remark = freezed,
    Object? saleOrderItemId = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            barcode: null == barcode
                ? _value.barcode
                : barcode // ignore: cast_nullable_to_non_nullable
                      as String,
            itemName: null == itemName
                ? _value.itemName
                : itemName // ignore: cast_nullable_to_non_nullable
                      as String,
            billItemName: null == billItemName
                ? _value.billItemName
                : billItemName // ignore: cast_nullable_to_non_nullable
                      as String,
            vendorItemName: null == vendorItemName
                ? _value.vendorItemName
                : vendorItemName // ignore: cast_nullable_to_non_nullable
                      as String,
            orderNo: null == orderNo
                ? _value.orderNo
                : orderNo // ignore: cast_nullable_to_non_nullable
                      as String,
            eye: null == eye
                ? _value.eye
                : eye // ignore: cast_nullable_to_non_nullable
                      as String,
            sph: null == sph
                ? _value.sph
                : sph // ignore: cast_nullable_to_non_nullable
                      as String,
            cyl: null == cyl
                ? _value.cyl
                : cyl // ignore: cast_nullable_to_non_nullable
                      as String,
            axis: null == axis
                ? _value.axis
                : axis // ignore: cast_nullable_to_non_nullable
                      as String,
            add: null == add
                ? _value.add
                : add // ignore: cast_nullable_to_non_nullable
                      as String,
            qty: null == qty
                ? _value.qty
                : qty // ignore: cast_nullable_to_non_nullable
                      as int,
            purchasePrice: null == purchasePrice
                ? _value.purchasePrice
                : purchasePrice // ignore: cast_nullable_to_non_nullable
                      as double,
            salePrice: null == salePrice
                ? _value.salePrice
                : salePrice // ignore: cast_nullable_to_non_nullable
                      as double,
            discount: null == discount
                ? _value.discount
                : discount // ignore: cast_nullable_to_non_nullable
                      as double,
            totalAmount: null == totalAmount
                ? _value.totalAmount
                : totalAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            dia: null == dia
                ? _value.dia
                : dia // ignore: cast_nullable_to_non_nullable
                      as String,
            mrp: null == mrp
                ? _value.mrp
                : mrp // ignore: cast_nullable_to_non_nullable
                      as double,
            expiryDate: freezed == expiryDate
                ? _value.expiryDate
                : expiryDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            importDate: freezed == importDate
                ? _value.importDate
                : importDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            combinationId: null == combinationId
                ? _value.combinationId
                : combinationId // ignore: cast_nullable_to_non_nullable
                      as String,
            vendor: null == vendor
                ? _value.vendor
                : vendor // ignore: cast_nullable_to_non_nullable
                      as String,
            remark: freezed == remark
                ? _value.remark
                : remark // ignore: cast_nullable_to_non_nullable
                      as String?,
            saleOrderItemId: freezed == saleOrderItemId
                ? _value.saleOrderItemId
                : saleOrderItemId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PurchaseItemImplCopyWith<$Res>
    implements $PurchaseItemCopyWith<$Res> {
  factory _$$PurchaseItemImplCopyWith(
    _$PurchaseItemImpl value,
    $Res Function(_$PurchaseItemImpl) then,
  ) = __$$PurchaseItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    String barcode,
    String itemName,
    String billItemName,
    String vendorItemName,
    String orderNo,
    String eye,
    String sph,
    String cyl,
    String axis,
    String add,
    int qty,
    double purchasePrice,
    double salePrice,
    double discount,
    double totalAmount,
    String dia,
    double mrp,
    String? expiryDate,
    String? importDate,
    String combinationId,
    String vendor,
    String? remark,
    String? saleOrderItemId,
  });
}

/// @nodoc
class __$$PurchaseItemImplCopyWithImpl<$Res>
    extends _$PurchaseItemCopyWithImpl<$Res, _$PurchaseItemImpl>
    implements _$$PurchaseItemImplCopyWith<$Res> {
  __$$PurchaseItemImplCopyWithImpl(
    _$PurchaseItemImpl _value,
    $Res Function(_$PurchaseItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PurchaseItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? barcode = null,
    Object? itemName = null,
    Object? billItemName = null,
    Object? vendorItemName = null,
    Object? orderNo = null,
    Object? eye = null,
    Object? sph = null,
    Object? cyl = null,
    Object? axis = null,
    Object? add = null,
    Object? qty = null,
    Object? purchasePrice = null,
    Object? salePrice = null,
    Object? discount = null,
    Object? totalAmount = null,
    Object? dia = null,
    Object? mrp = null,
    Object? expiryDate = freezed,
    Object? importDate = freezed,
    Object? combinationId = null,
    Object? vendor = null,
    Object? remark = freezed,
    Object? saleOrderItemId = freezed,
  }) {
    return _then(
      _$PurchaseItemImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        barcode: null == barcode
            ? _value.barcode
            : barcode // ignore: cast_nullable_to_non_nullable
                  as String,
        itemName: null == itemName
            ? _value.itemName
            : itemName // ignore: cast_nullable_to_non_nullable
                  as String,
        billItemName: null == billItemName
            ? _value.billItemName
            : billItemName // ignore: cast_nullable_to_non_nullable
                  as String,
        vendorItemName: null == vendorItemName
            ? _value.vendorItemName
            : vendorItemName // ignore: cast_nullable_to_non_nullable
                  as String,
        orderNo: null == orderNo
            ? _value.orderNo
            : orderNo // ignore: cast_nullable_to_non_nullable
                  as String,
        eye: null == eye
            ? _value.eye
            : eye // ignore: cast_nullable_to_non_nullable
                  as String,
        sph: null == sph
            ? _value.sph
            : sph // ignore: cast_nullable_to_non_nullable
                  as String,
        cyl: null == cyl
            ? _value.cyl
            : cyl // ignore: cast_nullable_to_non_nullable
                  as String,
        axis: null == axis
            ? _value.axis
            : axis // ignore: cast_nullable_to_non_nullable
                  as String,
        add: null == add
            ? _value.add
            : add // ignore: cast_nullable_to_non_nullable
                  as String,
        qty: null == qty
            ? _value.qty
            : qty // ignore: cast_nullable_to_non_nullable
                  as int,
        purchasePrice: null == purchasePrice
            ? _value.purchasePrice
            : purchasePrice // ignore: cast_nullable_to_non_nullable
                  as double,
        salePrice: null == salePrice
            ? _value.salePrice
            : salePrice // ignore: cast_nullable_to_non_nullable
                  as double,
        discount: null == discount
            ? _value.discount
            : discount // ignore: cast_nullable_to_non_nullable
                  as double,
        totalAmount: null == totalAmount
            ? _value.totalAmount
            : totalAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        dia: null == dia
            ? _value.dia
            : dia // ignore: cast_nullable_to_non_nullable
                  as String,
        mrp: null == mrp
            ? _value.mrp
            : mrp // ignore: cast_nullable_to_non_nullable
                  as double,
        expiryDate: freezed == expiryDate
            ? _value.expiryDate
            : expiryDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        importDate: freezed == importDate
            ? _value.importDate
            : importDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        combinationId: null == combinationId
            ? _value.combinationId
            : combinationId // ignore: cast_nullable_to_non_nullable
                  as String,
        vendor: null == vendor
            ? _value.vendor
            : vendor // ignore: cast_nullable_to_non_nullable
                  as String,
        remark: freezed == remark
            ? _value.remark
            : remark // ignore: cast_nullable_to_non_nullable
                  as String?,
        saleOrderItemId: freezed == saleOrderItemId
            ? _value.saleOrderItemId
            : saleOrderItemId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PurchaseItemImpl implements _PurchaseItem {
  const _$PurchaseItemImpl({
    @JsonKey(name: '_id') this.id,
    this.barcode = '',
    this.itemName = '',
    this.billItemName = '',
    this.vendorItemName = '',
    this.orderNo = '',
    this.eye = '',
    this.sph = '',
    this.cyl = '',
    this.axis = '',
    this.add = '',
    this.qty = 0,
    this.purchasePrice = 0.0,
    this.salePrice = 0.0,
    this.discount = 0.0,
    this.totalAmount = 0.0,
    this.dia = '',
    this.mrp = 0.0,
    this.expiryDate,
    this.importDate,
    this.combinationId = '',
    this.vendor = '',
    this.remark,
    this.saleOrderItemId,
  });

  factory _$PurchaseItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$PurchaseItemImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String? id;
  @override
  @JsonKey()
  final String barcode;
  @override
  @JsonKey()
  final String itemName;
  @override
  @JsonKey()
  final String billItemName;
  @override
  @JsonKey()
  final String vendorItemName;
  @override
  @JsonKey()
  final String orderNo;
  @override
  @JsonKey()
  final String eye;
  @override
  @JsonKey()
  final String sph;
  @override
  @JsonKey()
  final String cyl;
  @override
  @JsonKey()
  final String axis;
  @override
  @JsonKey()
  final String add;
  @override
  @JsonKey()
  final int qty;
  @override
  @JsonKey()
  final double purchasePrice;
  @override
  @JsonKey()
  final double salePrice;
  @override
  @JsonKey()
  final double discount;
  @override
  @JsonKey()
  final double totalAmount;
  @override
  @JsonKey()
  final String dia;
  @override
  @JsonKey()
  final double mrp;
  @override
  final String? expiryDate;
  @override
  final String? importDate;
  @override
  @JsonKey()
  final String combinationId;
  @override
  @JsonKey()
  final String vendor;
  @override
  final String? remark;
  @override
  final String? saleOrderItemId;

  @override
  String toString() {
    return 'PurchaseItem(id: $id, barcode: $barcode, itemName: $itemName, billItemName: $billItemName, vendorItemName: $vendorItemName, orderNo: $orderNo, eye: $eye, sph: $sph, cyl: $cyl, axis: $axis, add: $add, qty: $qty, purchasePrice: $purchasePrice, salePrice: $salePrice, discount: $discount, totalAmount: $totalAmount, dia: $dia, mrp: $mrp, expiryDate: $expiryDate, importDate: $importDate, combinationId: $combinationId, vendor: $vendor, remark: $remark, saleOrderItemId: $saleOrderItemId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchaseItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.barcode, barcode) || other.barcode == barcode) &&
            (identical(other.itemName, itemName) ||
                other.itemName == itemName) &&
            (identical(other.billItemName, billItemName) ||
                other.billItemName == billItemName) &&
            (identical(other.vendorItemName, vendorItemName) ||
                other.vendorItemName == vendorItemName) &&
            (identical(other.orderNo, orderNo) || other.orderNo == orderNo) &&
            (identical(other.eye, eye) || other.eye == eye) &&
            (identical(other.sph, sph) || other.sph == sph) &&
            (identical(other.cyl, cyl) || other.cyl == cyl) &&
            (identical(other.axis, axis) || other.axis == axis) &&
            (identical(other.add, add) || other.add == add) &&
            (identical(other.qty, qty) || other.qty == qty) &&
            (identical(other.purchasePrice, purchasePrice) ||
                other.purchasePrice == purchasePrice) &&
            (identical(other.salePrice, salePrice) ||
                other.salePrice == salePrice) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.dia, dia) || other.dia == dia) &&
            (identical(other.mrp, mrp) || other.mrp == mrp) &&
            (identical(other.expiryDate, expiryDate) ||
                other.expiryDate == expiryDate) &&
            (identical(other.importDate, importDate) ||
                other.importDate == importDate) &&
            (identical(other.combinationId, combinationId) ||
                other.combinationId == combinationId) &&
            (identical(other.vendor, vendor) || other.vendor == vendor) &&
            (identical(other.remark, remark) || other.remark == remark) &&
            (identical(other.saleOrderItemId, saleOrderItemId) ||
                other.saleOrderItemId == saleOrderItemId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    barcode,
    itemName,
    billItemName,
    vendorItemName,
    orderNo,
    eye,
    sph,
    cyl,
    axis,
    add,
    qty,
    purchasePrice,
    salePrice,
    discount,
    totalAmount,
    dia,
    mrp,
    expiryDate,
    importDate,
    combinationId,
    vendor,
    remark,
    saleOrderItemId,
  ]);

  /// Create a copy of PurchaseItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PurchaseItemImplCopyWith<_$PurchaseItemImpl> get copyWith =>
      __$$PurchaseItemImplCopyWithImpl<_$PurchaseItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PurchaseItemImplToJson(this);
  }
}

abstract class _PurchaseItem implements PurchaseItem {
  const factory _PurchaseItem({
    @JsonKey(name: '_id') final String? id,
    final String barcode,
    final String itemName,
    final String billItemName,
    final String vendorItemName,
    final String orderNo,
    final String eye,
    final String sph,
    final String cyl,
    final String axis,
    final String add,
    final int qty,
    final double purchasePrice,
    final double salePrice,
    final double discount,
    final double totalAmount,
    final String dia,
    final double mrp,
    final String? expiryDate,
    final String? importDate,
    final String combinationId,
    final String vendor,
    final String? remark,
    final String? saleOrderItemId,
  }) = _$PurchaseItemImpl;

  factory _PurchaseItem.fromJson(Map<String, dynamic> json) =
      _$PurchaseItemImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String? get id;
  @override
  String get barcode;
  @override
  String get itemName;
  @override
  String get billItemName;
  @override
  String get vendorItemName;
  @override
  String get orderNo;
  @override
  String get eye;
  @override
  String get sph;
  @override
  String get cyl;
  @override
  String get axis;
  @override
  String get add;
  @override
  int get qty;
  @override
  double get purchasePrice;
  @override
  double get salePrice;
  @override
  double get discount;
  @override
  double get totalAmount;
  @override
  String get dia;
  @override
  double get mrp;
  @override
  String? get expiryDate;
  @override
  String? get importDate;
  @override
  String get combinationId;
  @override
  String get vendor;
  @override
  String? get remark;
  @override
  String? get saleOrderItemId;

  /// Create a copy of PurchaseItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PurchaseItemImplCopyWith<_$PurchaseItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PurchaseTax _$PurchaseTaxFromJson(Map<String, dynamic> json) {
  return _PurchaseTax.fromJson(json);
}

/// @nodoc
mixin _$PurchaseTax {
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;
  String get taxName => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  double get percentage => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;

  /// Serializes this PurchaseTax to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PurchaseTax
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PurchaseTaxCopyWith<PurchaseTax> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchaseTaxCopyWith<$Res> {
  factory $PurchaseTaxCopyWith(
    PurchaseTax value,
    $Res Function(PurchaseTax) then,
  ) = _$PurchaseTaxCopyWithImpl<$Res, PurchaseTax>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    String taxName,
    String type,
    double percentage,
    double amount,
  });
}

/// @nodoc
class _$PurchaseTaxCopyWithImpl<$Res, $Val extends PurchaseTax>
    implements $PurchaseTaxCopyWith<$Res> {
  _$PurchaseTaxCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PurchaseTax
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? taxName = null,
    Object? type = null,
    Object? percentage = null,
    Object? amount = null,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            taxName: null == taxName
                ? _value.taxName
                : taxName // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            percentage: null == percentage
                ? _value.percentage
                : percentage // ignore: cast_nullable_to_non_nullable
                      as double,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PurchaseTaxImplCopyWith<$Res>
    implements $PurchaseTaxCopyWith<$Res> {
  factory _$$PurchaseTaxImplCopyWith(
    _$PurchaseTaxImpl value,
    $Res Function(_$PurchaseTaxImpl) then,
  ) = __$$PurchaseTaxImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    String taxName,
    String type,
    double percentage,
    double amount,
  });
}

/// @nodoc
class __$$PurchaseTaxImplCopyWithImpl<$Res>
    extends _$PurchaseTaxCopyWithImpl<$Res, _$PurchaseTaxImpl>
    implements _$$PurchaseTaxImplCopyWith<$Res> {
  __$$PurchaseTaxImplCopyWithImpl(
    _$PurchaseTaxImpl _value,
    $Res Function(_$PurchaseTaxImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PurchaseTax
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? taxName = null,
    Object? type = null,
    Object? percentage = null,
    Object? amount = null,
  }) {
    return _then(
      _$PurchaseTaxImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        taxName: null == taxName
            ? _value.taxName
            : taxName // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        percentage: null == percentage
            ? _value.percentage
            : percentage // ignore: cast_nullable_to_non_nullable
                  as double,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PurchaseTaxImpl implements _PurchaseTax {
  const _$PurchaseTaxImpl({
    @JsonKey(name: '_id') this.id,
    this.taxName = '',
    this.type = 'Additive',
    this.percentage = 0.0,
    this.amount = 0.0,
  });

  factory _$PurchaseTaxImpl.fromJson(Map<String, dynamic> json) =>
      _$$PurchaseTaxImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String? id;
  @override
  @JsonKey()
  final String taxName;
  @override
  @JsonKey()
  final String type;
  @override
  @JsonKey()
  final double percentage;
  @override
  @JsonKey()
  final double amount;

  @override
  String toString() {
    return 'PurchaseTax(id: $id, taxName: $taxName, type: $type, percentage: $percentage, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchaseTaxImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.taxName, taxName) || other.taxName == taxName) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, taxName, type, percentage, amount);

  /// Create a copy of PurchaseTax
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PurchaseTaxImplCopyWith<_$PurchaseTaxImpl> get copyWith =>
      __$$PurchaseTaxImplCopyWithImpl<_$PurchaseTaxImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PurchaseTaxImplToJson(this);
  }
}

abstract class _PurchaseTax implements PurchaseTax {
  const factory _PurchaseTax({
    @JsonKey(name: '_id') final String? id,
    final String taxName,
    final String type,
    final double percentage,
    final double amount,
  }) = _$PurchaseTaxImpl;

  factory _PurchaseTax.fromJson(Map<String, dynamic> json) =
      _$PurchaseTaxImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String? get id;
  @override
  String get taxName;
  @override
  String get type;
  @override
  double get percentage;
  @override
  double get amount;

  /// Create a copy of PurchaseTax
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PurchaseTaxImplCopyWith<_$PurchaseTaxImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
