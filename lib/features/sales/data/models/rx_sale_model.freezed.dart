// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rx_sale_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RxSaleModel _$RxSaleModelFromJson(Map<String, dynamic> json) {
  return _RxSaleModel.fromJson(json);
}

/// @nodoc
mixin _$RxSaleModel {
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;
  SaleOrderBillData get billData => throw _privateConstructorUsedError;
  SaleOrderPartyData get partyData => throw _privateConstructorUsedError;
  List<RxOrderItem> get items => throw _privateConstructorUsedError;
  List<SaleOrderTax> get taxes => throw _privateConstructorUsedError;
  double get subtotal => throw _privateConstructorUsedError;
  double get taxesAmount => throw _privateConstructorUsedError;
  double get netAmount => throw _privateConstructorUsedError;
  double get paidAmount => throw _privateConstructorUsedError;
  double get dueAmount => throw _privateConstructorUsedError;
  String? get remark => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get saleType => throw _privateConstructorUsedError;
  String? get orderId =>
      throw _privateConstructorUsedError; // Reference to original RxOrder
  String? get orderNo => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;
  String? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this RxSaleModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RxSaleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RxSaleModelCopyWith<RxSaleModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RxSaleModelCopyWith<$Res> {
  factory $RxSaleModelCopyWith(
    RxSaleModel value,
    $Res Function(RxSaleModel) then,
  ) = _$RxSaleModelCopyWithImpl<$Res, RxSaleModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    SaleOrderBillData billData,
    SaleOrderPartyData partyData,
    List<RxOrderItem> items,
    List<SaleOrderTax> taxes,
    double subtotal,
    double taxesAmount,
    double netAmount,
    double paidAmount,
    double dueAmount,
    String? remark,
    String status,
    String saleType,
    String? orderId,
    String? orderNo,
    String? createdAt,
    String? updatedAt,
  });

  $SaleOrderBillDataCopyWith<$Res> get billData;
  $SaleOrderPartyDataCopyWith<$Res> get partyData;
}

/// @nodoc
class _$RxSaleModelCopyWithImpl<$Res, $Val extends RxSaleModel>
    implements $RxSaleModelCopyWith<$Res> {
  _$RxSaleModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RxSaleModel
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
    Object? remark = freezed,
    Object? status = null,
    Object? saleType = null,
    Object? orderId = freezed,
    Object? orderNo = freezed,
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
                      as SaleOrderBillData,
            partyData: null == partyData
                ? _value.partyData
                : partyData // ignore: cast_nullable_to_non_nullable
                      as SaleOrderPartyData,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<RxOrderItem>,
            taxes: null == taxes
                ? _value.taxes
                : taxes // ignore: cast_nullable_to_non_nullable
                      as List<SaleOrderTax>,
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
            remark: freezed == remark
                ? _value.remark
                : remark // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            saleType: null == saleType
                ? _value.saleType
                : saleType // ignore: cast_nullable_to_non_nullable
                      as String,
            orderId: freezed == orderId
                ? _value.orderId
                : orderId // ignore: cast_nullable_to_non_nullable
                      as String?,
            orderNo: freezed == orderNo
                ? _value.orderNo
                : orderNo // ignore: cast_nullable_to_non_nullable
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

  /// Create a copy of RxSaleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SaleOrderBillDataCopyWith<$Res> get billData {
    return $SaleOrderBillDataCopyWith<$Res>(_value.billData, (value) {
      return _then(_value.copyWith(billData: value) as $Val);
    });
  }

  /// Create a copy of RxSaleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SaleOrderPartyDataCopyWith<$Res> get partyData {
    return $SaleOrderPartyDataCopyWith<$Res>(_value.partyData, (value) {
      return _then(_value.copyWith(partyData: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RxSaleModelImplCopyWith<$Res>
    implements $RxSaleModelCopyWith<$Res> {
  factory _$$RxSaleModelImplCopyWith(
    _$RxSaleModelImpl value,
    $Res Function(_$RxSaleModelImpl) then,
  ) = __$$RxSaleModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    SaleOrderBillData billData,
    SaleOrderPartyData partyData,
    List<RxOrderItem> items,
    List<SaleOrderTax> taxes,
    double subtotal,
    double taxesAmount,
    double netAmount,
    double paidAmount,
    double dueAmount,
    String? remark,
    String status,
    String saleType,
    String? orderId,
    String? orderNo,
    String? createdAt,
    String? updatedAt,
  });

  @override
  $SaleOrderBillDataCopyWith<$Res> get billData;
  @override
  $SaleOrderPartyDataCopyWith<$Res> get partyData;
}

/// @nodoc
class __$$RxSaleModelImplCopyWithImpl<$Res>
    extends _$RxSaleModelCopyWithImpl<$Res, _$RxSaleModelImpl>
    implements _$$RxSaleModelImplCopyWith<$Res> {
  __$$RxSaleModelImplCopyWithImpl(
    _$RxSaleModelImpl _value,
    $Res Function(_$RxSaleModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RxSaleModel
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
    Object? remark = freezed,
    Object? status = null,
    Object? saleType = null,
    Object? orderId = freezed,
    Object? orderNo = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$RxSaleModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        billData: null == billData
            ? _value.billData
            : billData // ignore: cast_nullable_to_non_nullable
                  as SaleOrderBillData,
        partyData: null == partyData
            ? _value.partyData
            : partyData // ignore: cast_nullable_to_non_nullable
                  as SaleOrderPartyData,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<RxOrderItem>,
        taxes: null == taxes
            ? _value._taxes
            : taxes // ignore: cast_nullable_to_non_nullable
                  as List<SaleOrderTax>,
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
        remark: freezed == remark
            ? _value.remark
            : remark // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        saleType: null == saleType
            ? _value.saleType
            : saleType // ignore: cast_nullable_to_non_nullable
                  as String,
        orderId: freezed == orderId
            ? _value.orderId
            : orderId // ignore: cast_nullable_to_non_nullable
                  as String?,
        orderNo: freezed == orderNo
            ? _value.orderNo
            : orderNo // ignore: cast_nullable_to_non_nullable
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
class _$RxSaleModelImpl implements _RxSaleModel {
  const _$RxSaleModelImpl({
    @JsonKey(name: '_id') this.id,
    this.billData = const SaleOrderBillData(),
    this.partyData = const SaleOrderPartyData(),
    final List<RxOrderItem> items = const [],
    final List<SaleOrderTax> taxes = const [],
    this.subtotal = 0.0,
    this.taxesAmount = 0.0,
    this.netAmount = 0.0,
    this.paidAmount = 0.0,
    this.dueAmount = 0.0,
    this.remark,
    this.status = 'Done',
    this.saleType = 'RX SALE',
    this.orderId,
    this.orderNo,
    this.createdAt,
    this.updatedAt,
  }) : _items = items,
       _taxes = taxes;

  factory _$RxSaleModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RxSaleModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String? id;
  @override
  @JsonKey()
  final SaleOrderBillData billData;
  @override
  @JsonKey()
  final SaleOrderPartyData partyData;
  final List<RxOrderItem> _items;
  @override
  @JsonKey()
  List<RxOrderItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  final List<SaleOrderTax> _taxes;
  @override
  @JsonKey()
  List<SaleOrderTax> get taxes {
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
  final String? remark;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final String saleType;
  @override
  final String? orderId;
  // Reference to original RxOrder
  @override
  final String? orderNo;
  @override
  final String? createdAt;
  @override
  final String? updatedAt;

  @override
  String toString() {
    return 'RxSaleModel(id: $id, billData: $billData, partyData: $partyData, items: $items, taxes: $taxes, subtotal: $subtotal, taxesAmount: $taxesAmount, netAmount: $netAmount, paidAmount: $paidAmount, dueAmount: $dueAmount, remark: $remark, status: $status, saleType: $saleType, orderId: $orderId, orderNo: $orderNo, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RxSaleModelImpl &&
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
            (identical(other.remark, remark) || other.remark == remark) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.saleType, saleType) ||
                other.saleType == saleType) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.orderNo, orderNo) || other.orderNo == orderNo) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
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
    remark,
    status,
    saleType,
    orderId,
    orderNo,
    createdAt,
    updatedAt,
  );

  /// Create a copy of RxSaleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RxSaleModelImplCopyWith<_$RxSaleModelImpl> get copyWith =>
      __$$RxSaleModelImplCopyWithImpl<_$RxSaleModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RxSaleModelImplToJson(this);
  }
}

abstract class _RxSaleModel implements RxSaleModel {
  const factory _RxSaleModel({
    @JsonKey(name: '_id') final String? id,
    final SaleOrderBillData billData,
    final SaleOrderPartyData partyData,
    final List<RxOrderItem> items,
    final List<SaleOrderTax> taxes,
    final double subtotal,
    final double taxesAmount,
    final double netAmount,
    final double paidAmount,
    final double dueAmount,
    final String? remark,
    final String status,
    final String saleType,
    final String? orderId,
    final String? orderNo,
    final String? createdAt,
    final String? updatedAt,
  }) = _$RxSaleModelImpl;

  factory _RxSaleModel.fromJson(Map<String, dynamic> json) =
      _$RxSaleModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String? get id;
  @override
  SaleOrderBillData get billData;
  @override
  SaleOrderPartyData get partyData;
  @override
  List<RxOrderItem> get items;
  @override
  List<SaleOrderTax> get taxes;
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
  String? get remark;
  @override
  String get status;
  @override
  String get saleType;
  @override
  String? get orderId; // Reference to original RxOrder
  @override
  String? get orderNo;
  @override
  String? get createdAt;
  @override
  String? get updatedAt;

  /// Create a copy of RxSaleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RxSaleModelImplCopyWith<_$RxSaleModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
