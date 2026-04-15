// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lens_sale_order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LensSaleOrderModel _$LensSaleOrderModelFromJson(Map<String, dynamic> json) {
  return _LensSaleOrderModel.fromJson(json);
}

/// @nodoc
mixin _$LensSaleOrderModel {
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;
  SaleOrderBillData get billData => throw _privateConstructorUsedError;
  SaleOrderPartyData get partyData => throw _privateConstructorUsedError;
  List<SaleOrderItem> get items => throw _privateConstructorUsedError;
  List<SaleOrderTax> get taxes => throw _privateConstructorUsedError;
  int get orderQty => throw _privateConstructorUsedError;
  int get usedQty => throw _privateConstructorUsedError;
  int get balQty => throw _privateConstructorUsedError;
  double get grossAmount => throw _privateConstructorUsedError;
  double get subtotal => throw _privateConstructorUsedError;
  double get taxesAmount => throw _privateConstructorUsedError;
  double get netAmount => throw _privateConstructorUsedError;
  double get paidAmount => throw _privateConstructorUsedError;
  double get dueAmount => throw _privateConstructorUsedError;
  String? get refNo => throw _privateConstructorUsedError;
  String? get deliveryDate => throw _privateConstructorUsedError;
  String? get time => throw _privateConstructorUsedError;
  String? get remark => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get parentStatus => throw _privateConstructorUsedError;
  String? get cancelReason => throw _privateConstructorUsedError;
  String? get settlementDate => throw _privateConstructorUsedError;
  bool get isOrderPlaced => throw _privateConstructorUsedError;
  String? get orderPlacedAt => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;
  String? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this LensSaleOrderModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LensSaleOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LensSaleOrderModelCopyWith<LensSaleOrderModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LensSaleOrderModelCopyWith<$Res> {
  factory $LensSaleOrderModelCopyWith(
    LensSaleOrderModel value,
    $Res Function(LensSaleOrderModel) then,
  ) = _$LensSaleOrderModelCopyWithImpl<$Res, LensSaleOrderModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    SaleOrderBillData billData,
    SaleOrderPartyData partyData,
    List<SaleOrderItem> items,
    List<SaleOrderTax> taxes,
    int orderQty,
    int usedQty,
    int balQty,
    double grossAmount,
    double subtotal,
    double taxesAmount,
    double netAmount,
    double paidAmount,
    double dueAmount,
    String? refNo,
    String? deliveryDate,
    String? time,
    String? remark,
    String status,
    String parentStatus,
    String? cancelReason,
    String? settlementDate,
    bool isOrderPlaced,
    String? orderPlacedAt,
    String? createdAt,
    String? updatedAt,
  });

  $SaleOrderBillDataCopyWith<$Res> get billData;
  $SaleOrderPartyDataCopyWith<$Res> get partyData;
}

/// @nodoc
class _$LensSaleOrderModelCopyWithImpl<$Res, $Val extends LensSaleOrderModel>
    implements $LensSaleOrderModelCopyWith<$Res> {
  _$LensSaleOrderModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LensSaleOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? billData = null,
    Object? partyData = null,
    Object? items = null,
    Object? taxes = null,
    Object? orderQty = null,
    Object? usedQty = null,
    Object? balQty = null,
    Object? grossAmount = null,
    Object? subtotal = null,
    Object? taxesAmount = null,
    Object? netAmount = null,
    Object? paidAmount = null,
    Object? dueAmount = null,
    Object? refNo = freezed,
    Object? deliveryDate = freezed,
    Object? time = freezed,
    Object? remark = freezed,
    Object? status = null,
    Object? parentStatus = null,
    Object? cancelReason = freezed,
    Object? settlementDate = freezed,
    Object? isOrderPlaced = null,
    Object? orderPlacedAt = freezed,
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
                      as List<SaleOrderItem>,
            taxes: null == taxes
                ? _value.taxes
                : taxes // ignore: cast_nullable_to_non_nullable
                      as List<SaleOrderTax>,
            orderQty: null == orderQty
                ? _value.orderQty
                : orderQty // ignore: cast_nullable_to_non_nullable
                      as int,
            usedQty: null == usedQty
                ? _value.usedQty
                : usedQty // ignore: cast_nullable_to_non_nullable
                      as int,
            balQty: null == balQty
                ? _value.balQty
                : balQty // ignore: cast_nullable_to_non_nullable
                      as int,
            grossAmount: null == grossAmount
                ? _value.grossAmount
                : grossAmount // ignore: cast_nullable_to_non_nullable
                      as double,
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
            refNo: freezed == refNo
                ? _value.refNo
                : refNo // ignore: cast_nullable_to_non_nullable
                      as String?,
            deliveryDate: freezed == deliveryDate
                ? _value.deliveryDate
                : deliveryDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            time: freezed == time
                ? _value.time
                : time // ignore: cast_nullable_to_non_nullable
                      as String?,
            remark: freezed == remark
                ? _value.remark
                : remark // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            parentStatus: null == parentStatus
                ? _value.parentStatus
                : parentStatus // ignore: cast_nullable_to_non_nullable
                      as String,
            cancelReason: freezed == cancelReason
                ? _value.cancelReason
                : cancelReason // ignore: cast_nullable_to_non_nullable
                      as String?,
            settlementDate: freezed == settlementDate
                ? _value.settlementDate
                : settlementDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            isOrderPlaced: null == isOrderPlaced
                ? _value.isOrderPlaced
                : isOrderPlaced // ignore: cast_nullable_to_non_nullable
                      as bool,
            orderPlacedAt: freezed == orderPlacedAt
                ? _value.orderPlacedAt
                : orderPlacedAt // ignore: cast_nullable_to_non_nullable
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

  /// Create a copy of LensSaleOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SaleOrderBillDataCopyWith<$Res> get billData {
    return $SaleOrderBillDataCopyWith<$Res>(_value.billData, (value) {
      return _then(_value.copyWith(billData: value) as $Val);
    });
  }

  /// Create a copy of LensSaleOrderModel
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
abstract class _$$LensSaleOrderModelImplCopyWith<$Res>
    implements $LensSaleOrderModelCopyWith<$Res> {
  factory _$$LensSaleOrderModelImplCopyWith(
    _$LensSaleOrderModelImpl value,
    $Res Function(_$LensSaleOrderModelImpl) then,
  ) = __$$LensSaleOrderModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    SaleOrderBillData billData,
    SaleOrderPartyData partyData,
    List<SaleOrderItem> items,
    List<SaleOrderTax> taxes,
    int orderQty,
    int usedQty,
    int balQty,
    double grossAmount,
    double subtotal,
    double taxesAmount,
    double netAmount,
    double paidAmount,
    double dueAmount,
    String? refNo,
    String? deliveryDate,
    String? time,
    String? remark,
    String status,
    String parentStatus,
    String? cancelReason,
    String? settlementDate,
    bool isOrderPlaced,
    String? orderPlacedAt,
    String? createdAt,
    String? updatedAt,
  });

  @override
  $SaleOrderBillDataCopyWith<$Res> get billData;
  @override
  $SaleOrderPartyDataCopyWith<$Res> get partyData;
}

/// @nodoc
class __$$LensSaleOrderModelImplCopyWithImpl<$Res>
    extends _$LensSaleOrderModelCopyWithImpl<$Res, _$LensSaleOrderModelImpl>
    implements _$$LensSaleOrderModelImplCopyWith<$Res> {
  __$$LensSaleOrderModelImplCopyWithImpl(
    _$LensSaleOrderModelImpl _value,
    $Res Function(_$LensSaleOrderModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LensSaleOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? billData = null,
    Object? partyData = null,
    Object? items = null,
    Object? taxes = null,
    Object? orderQty = null,
    Object? usedQty = null,
    Object? balQty = null,
    Object? grossAmount = null,
    Object? subtotal = null,
    Object? taxesAmount = null,
    Object? netAmount = null,
    Object? paidAmount = null,
    Object? dueAmount = null,
    Object? refNo = freezed,
    Object? deliveryDate = freezed,
    Object? time = freezed,
    Object? remark = freezed,
    Object? status = null,
    Object? parentStatus = null,
    Object? cancelReason = freezed,
    Object? settlementDate = freezed,
    Object? isOrderPlaced = null,
    Object? orderPlacedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$LensSaleOrderModelImpl(
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
                  as List<SaleOrderItem>,
        taxes: null == taxes
            ? _value._taxes
            : taxes // ignore: cast_nullable_to_non_nullable
                  as List<SaleOrderTax>,
        orderQty: null == orderQty
            ? _value.orderQty
            : orderQty // ignore: cast_nullable_to_non_nullable
                  as int,
        usedQty: null == usedQty
            ? _value.usedQty
            : usedQty // ignore: cast_nullable_to_non_nullable
                  as int,
        balQty: null == balQty
            ? _value.balQty
            : balQty // ignore: cast_nullable_to_non_nullable
                  as int,
        grossAmount: null == grossAmount
            ? _value.grossAmount
            : grossAmount // ignore: cast_nullable_to_non_nullable
                  as double,
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
        refNo: freezed == refNo
            ? _value.refNo
            : refNo // ignore: cast_nullable_to_non_nullable
                  as String?,
        deliveryDate: freezed == deliveryDate
            ? _value.deliveryDate
            : deliveryDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        time: freezed == time
            ? _value.time
            : time // ignore: cast_nullable_to_non_nullable
                  as String?,
        remark: freezed == remark
            ? _value.remark
            : remark // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        parentStatus: null == parentStatus
            ? _value.parentStatus
            : parentStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        cancelReason: freezed == cancelReason
            ? _value.cancelReason
            : cancelReason // ignore: cast_nullable_to_non_nullable
                  as String?,
        settlementDate: freezed == settlementDate
            ? _value.settlementDate
            : settlementDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        isOrderPlaced: null == isOrderPlaced
            ? _value.isOrderPlaced
            : isOrderPlaced // ignore: cast_nullable_to_non_nullable
                  as bool,
        orderPlacedAt: freezed == orderPlacedAt
            ? _value.orderPlacedAt
            : orderPlacedAt // ignore: cast_nullable_to_non_nullable
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
class _$LensSaleOrderModelImpl implements _LensSaleOrderModel {
  const _$LensSaleOrderModelImpl({
    @JsonKey(name: '_id') this.id,
    this.billData = const SaleOrderBillData(),
    this.partyData = const SaleOrderPartyData(),
    final List<SaleOrderItem> items = const [],
    final List<SaleOrderTax> taxes = const [],
    this.orderQty = 0,
    this.usedQty = 0,
    this.balQty = 0,
    this.grossAmount = 0.0,
    this.subtotal = 0.0,
    this.taxesAmount = 0.0,
    this.netAmount = 0.0,
    this.paidAmount = 0.0,
    this.dueAmount = 0.0,
    this.refNo,
    this.deliveryDate,
    this.time,
    this.remark,
    this.status = 'Pending',
    this.parentStatus = 'Pending',
    this.cancelReason,
    this.settlementDate,
    this.isOrderPlaced = false,
    this.orderPlacedAt,
    this.createdAt,
    this.updatedAt,
  }) : _items = items,
       _taxes = taxes;

  factory _$LensSaleOrderModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LensSaleOrderModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String? id;
  @override
  @JsonKey()
  final SaleOrderBillData billData;
  @override
  @JsonKey()
  final SaleOrderPartyData partyData;
  final List<SaleOrderItem> _items;
  @override
  @JsonKey()
  List<SaleOrderItem> get items {
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
  final int orderQty;
  @override
  @JsonKey()
  final int usedQty;
  @override
  @JsonKey()
  final int balQty;
  @override
  @JsonKey()
  final double grossAmount;
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
  final String? refNo;
  @override
  final String? deliveryDate;
  @override
  final String? time;
  @override
  final String? remark;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final String parentStatus;
  @override
  final String? cancelReason;
  @override
  final String? settlementDate;
  @override
  @JsonKey()
  final bool isOrderPlaced;
  @override
  final String? orderPlacedAt;
  @override
  final String? createdAt;
  @override
  final String? updatedAt;

  @override
  String toString() {
    return 'LensSaleOrderModel(id: $id, billData: $billData, partyData: $partyData, items: $items, taxes: $taxes, orderQty: $orderQty, usedQty: $usedQty, balQty: $balQty, grossAmount: $grossAmount, subtotal: $subtotal, taxesAmount: $taxesAmount, netAmount: $netAmount, paidAmount: $paidAmount, dueAmount: $dueAmount, refNo: $refNo, deliveryDate: $deliveryDate, time: $time, remark: $remark, status: $status, parentStatus: $parentStatus, cancelReason: $cancelReason, settlementDate: $settlementDate, isOrderPlaced: $isOrderPlaced, orderPlacedAt: $orderPlacedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LensSaleOrderModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.billData, billData) ||
                other.billData == billData) &&
            (identical(other.partyData, partyData) ||
                other.partyData == partyData) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality().equals(other._taxes, _taxes) &&
            (identical(other.orderQty, orderQty) ||
                other.orderQty == orderQty) &&
            (identical(other.usedQty, usedQty) || other.usedQty == usedQty) &&
            (identical(other.balQty, balQty) || other.balQty == balQty) &&
            (identical(other.grossAmount, grossAmount) ||
                other.grossAmount == grossAmount) &&
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
            (identical(other.refNo, refNo) || other.refNo == refNo) &&
            (identical(other.deliveryDate, deliveryDate) ||
                other.deliveryDate == deliveryDate) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.remark, remark) || other.remark == remark) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.parentStatus, parentStatus) ||
                other.parentStatus == parentStatus) &&
            (identical(other.cancelReason, cancelReason) ||
                other.cancelReason == cancelReason) &&
            (identical(other.settlementDate, settlementDate) ||
                other.settlementDate == settlementDate) &&
            (identical(other.isOrderPlaced, isOrderPlaced) ||
                other.isOrderPlaced == isOrderPlaced) &&
            (identical(other.orderPlacedAt, orderPlacedAt) ||
                other.orderPlacedAt == orderPlacedAt) &&
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
    orderQty,
    usedQty,
    balQty,
    grossAmount,
    subtotal,
    taxesAmount,
    netAmount,
    paidAmount,
    dueAmount,
    refNo,
    deliveryDate,
    time,
    remark,
    status,
    parentStatus,
    cancelReason,
    settlementDate,
    isOrderPlaced,
    orderPlacedAt,
    createdAt,
    updatedAt,
  ]);

  /// Create a copy of LensSaleOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LensSaleOrderModelImplCopyWith<_$LensSaleOrderModelImpl> get copyWith =>
      __$$LensSaleOrderModelImplCopyWithImpl<_$LensSaleOrderModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LensSaleOrderModelImplToJson(this);
  }
}

abstract class _LensSaleOrderModel implements LensSaleOrderModel {
  const factory _LensSaleOrderModel({
    @JsonKey(name: '_id') final String? id,
    final SaleOrderBillData billData,
    final SaleOrderPartyData partyData,
    final List<SaleOrderItem> items,
    final List<SaleOrderTax> taxes,
    final int orderQty,
    final int usedQty,
    final int balQty,
    final double grossAmount,
    final double subtotal,
    final double taxesAmount,
    final double netAmount,
    final double paidAmount,
    final double dueAmount,
    final String? refNo,
    final String? deliveryDate,
    final String? time,
    final String? remark,
    final String status,
    final String parentStatus,
    final String? cancelReason,
    final String? settlementDate,
    final bool isOrderPlaced,
    final String? orderPlacedAt,
    final String? createdAt,
    final String? updatedAt,
  }) = _$LensSaleOrderModelImpl;

  factory _LensSaleOrderModel.fromJson(Map<String, dynamic> json) =
      _$LensSaleOrderModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String? get id;
  @override
  SaleOrderBillData get billData;
  @override
  SaleOrderPartyData get partyData;
  @override
  List<SaleOrderItem> get items;
  @override
  List<SaleOrderTax> get taxes;
  @override
  int get orderQty;
  @override
  int get usedQty;
  @override
  int get balQty;
  @override
  double get grossAmount;
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
  String? get refNo;
  @override
  String? get deliveryDate;
  @override
  String? get time;
  @override
  String? get remark;
  @override
  String get status;
  @override
  String get parentStatus;
  @override
  String? get cancelReason;
  @override
  String? get settlementDate;
  @override
  bool get isOrderPlaced;
  @override
  String? get orderPlacedAt;
  @override
  String? get createdAt;
  @override
  String? get updatedAt;

  /// Create a copy of LensSaleOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LensSaleOrderModelImplCopyWith<_$LensSaleOrderModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SaleOrderBillData _$SaleOrderBillDataFromJson(Map<String, dynamic> json) {
  return _SaleOrderBillData.fromJson(json);
}

/// @nodoc
mixin _$SaleOrderBillData {
  String get billSeries => throw _privateConstructorUsedError;
  String get billNo => throw _privateConstructorUsedError;
  String? get date => throw _privateConstructorUsedError;
  String get billType => throw _privateConstructorUsedError;
  String get bankAccount => throw _privateConstructorUsedError;
  String get godown => throw _privateConstructorUsedError;
  String get bookedBy => throw _privateConstructorUsedError;

  /// Serializes this SaleOrderBillData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SaleOrderBillData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SaleOrderBillDataCopyWith<SaleOrderBillData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SaleOrderBillDataCopyWith<$Res> {
  factory $SaleOrderBillDataCopyWith(
    SaleOrderBillData value,
    $Res Function(SaleOrderBillData) then,
  ) = _$SaleOrderBillDataCopyWithImpl<$Res, SaleOrderBillData>;
  @useResult
  $Res call({
    String billSeries,
    String billNo,
    String? date,
    String billType,
    String bankAccount,
    String godown,
    String bookedBy,
  });
}

/// @nodoc
class _$SaleOrderBillDataCopyWithImpl<$Res, $Val extends SaleOrderBillData>
    implements $SaleOrderBillDataCopyWith<$Res> {
  _$SaleOrderBillDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SaleOrderBillData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? billSeries = null,
    Object? billNo = null,
    Object? date = freezed,
    Object? billType = null,
    Object? bankAccount = null,
    Object? godown = null,
    Object? bookedBy = null,
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
            bankAccount: null == bankAccount
                ? _value.bankAccount
                : bankAccount // ignore: cast_nullable_to_non_nullable
                      as String,
            godown: null == godown
                ? _value.godown
                : godown // ignore: cast_nullable_to_non_nullable
                      as String,
            bookedBy: null == bookedBy
                ? _value.bookedBy
                : bookedBy // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SaleOrderBillDataImplCopyWith<$Res>
    implements $SaleOrderBillDataCopyWith<$Res> {
  factory _$$SaleOrderBillDataImplCopyWith(
    _$SaleOrderBillDataImpl value,
    $Res Function(_$SaleOrderBillDataImpl) then,
  ) = __$$SaleOrderBillDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String billSeries,
    String billNo,
    String? date,
    String billType,
    String bankAccount,
    String godown,
    String bookedBy,
  });
}

/// @nodoc
class __$$SaleOrderBillDataImplCopyWithImpl<$Res>
    extends _$SaleOrderBillDataCopyWithImpl<$Res, _$SaleOrderBillDataImpl>
    implements _$$SaleOrderBillDataImplCopyWith<$Res> {
  __$$SaleOrderBillDataImplCopyWithImpl(
    _$SaleOrderBillDataImpl _value,
    $Res Function(_$SaleOrderBillDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SaleOrderBillData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? billSeries = null,
    Object? billNo = null,
    Object? date = freezed,
    Object? billType = null,
    Object? bankAccount = null,
    Object? godown = null,
    Object? bookedBy = null,
  }) {
    return _then(
      _$SaleOrderBillDataImpl(
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
        bankAccount: null == bankAccount
            ? _value.bankAccount
            : bankAccount // ignore: cast_nullable_to_non_nullable
                  as String,
        godown: null == godown
            ? _value.godown
            : godown // ignore: cast_nullable_to_non_nullable
                  as String,
        bookedBy: null == bookedBy
            ? _value.bookedBy
            : bookedBy // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SaleOrderBillDataImpl implements _SaleOrderBillData {
  const _$SaleOrderBillDataImpl({
    this.billSeries = '',
    this.billNo = '',
    this.date,
    this.billType = '',
    this.bankAccount = '',
    this.godown = '',
    this.bookedBy = '',
  });

  factory _$SaleOrderBillDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$SaleOrderBillDataImplFromJson(json);

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
  final String bankAccount;
  @override
  @JsonKey()
  final String godown;
  @override
  @JsonKey()
  final String bookedBy;

  @override
  String toString() {
    return 'SaleOrderBillData(billSeries: $billSeries, billNo: $billNo, date: $date, billType: $billType, bankAccount: $bankAccount, godown: $godown, bookedBy: $bookedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SaleOrderBillDataImpl &&
            (identical(other.billSeries, billSeries) ||
                other.billSeries == billSeries) &&
            (identical(other.billNo, billNo) || other.billNo == billNo) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.billType, billType) ||
                other.billType == billType) &&
            (identical(other.bankAccount, bankAccount) ||
                other.bankAccount == bankAccount) &&
            (identical(other.godown, godown) || other.godown == godown) &&
            (identical(other.bookedBy, bookedBy) ||
                other.bookedBy == bookedBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    billSeries,
    billNo,
    date,
    billType,
    bankAccount,
    godown,
    bookedBy,
  );

  /// Create a copy of SaleOrderBillData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SaleOrderBillDataImplCopyWith<_$SaleOrderBillDataImpl> get copyWith =>
      __$$SaleOrderBillDataImplCopyWithImpl<_$SaleOrderBillDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SaleOrderBillDataImplToJson(this);
  }
}

abstract class _SaleOrderBillData implements SaleOrderBillData {
  const factory _SaleOrderBillData({
    final String billSeries,
    final String billNo,
    final String? date,
    final String billType,
    final String bankAccount,
    final String godown,
    final String bookedBy,
  }) = _$SaleOrderBillDataImpl;

  factory _SaleOrderBillData.fromJson(Map<String, dynamic> json) =
      _$SaleOrderBillDataImpl.fromJson;

  @override
  String get billSeries;
  @override
  String get billNo;
  @override
  String? get date;
  @override
  String get billType;
  @override
  String get bankAccount;
  @override
  String get godown;
  @override
  String get bookedBy;

  /// Create a copy of SaleOrderBillData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SaleOrderBillDataImplCopyWith<_$SaleOrderBillDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SaleOrderPartyData _$SaleOrderPartyDataFromJson(Map<String, dynamic> json) {
  return _SaleOrderPartyData.fromJson(json);
}

/// @nodoc
mixin _$SaleOrderPartyData {
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;
  String get partyAccount => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String get contactNumber => throw _privateConstructorUsedError;
  String get stateCode => throw _privateConstructorUsedError;
  double get creditLimit => throw _privateConstructorUsedError;
  int get creditDays => throw _privateConstructorUsedError;
  String get accountCategory =>
      throw _privateConstructorUsedError; // For pricing logic
  CurrentBalance get currentBalance => throw _privateConstructorUsedError;

  /// Serializes this SaleOrderPartyData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SaleOrderPartyData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SaleOrderPartyDataCopyWith<SaleOrderPartyData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SaleOrderPartyDataCopyWith<$Res> {
  factory $SaleOrderPartyDataCopyWith(
    SaleOrderPartyData value,
    $Res Function(SaleOrderPartyData) then,
  ) = _$SaleOrderPartyDataCopyWithImpl<$Res, SaleOrderPartyData>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    String partyAccount,
    String address,
    String contactNumber,
    String stateCode,
    double creditLimit,
    int creditDays,
    String accountCategory,
    CurrentBalance currentBalance,
  });

  $CurrentBalanceCopyWith<$Res> get currentBalance;
}

/// @nodoc
class _$SaleOrderPartyDataCopyWithImpl<$Res, $Val extends SaleOrderPartyData>
    implements $SaleOrderPartyDataCopyWith<$Res> {
  _$SaleOrderPartyDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SaleOrderPartyData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? partyAccount = null,
    Object? address = null,
    Object? contactNumber = null,
    Object? stateCode = null,
    Object? creditLimit = null,
    Object? creditDays = null,
    Object? accountCategory = null,
    Object? currentBalance = null,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            partyAccount: null == partyAccount
                ? _value.partyAccount
                : partyAccount // ignore: cast_nullable_to_non_nullable
                      as String,
            address: null == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String,
            contactNumber: null == contactNumber
                ? _value.contactNumber
                : contactNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            stateCode: null == stateCode
                ? _value.stateCode
                : stateCode // ignore: cast_nullable_to_non_nullable
                      as String,
            creditLimit: null == creditLimit
                ? _value.creditLimit
                : creditLimit // ignore: cast_nullable_to_non_nullable
                      as double,
            creditDays: null == creditDays
                ? _value.creditDays
                : creditDays // ignore: cast_nullable_to_non_nullable
                      as int,
            accountCategory: null == accountCategory
                ? _value.accountCategory
                : accountCategory // ignore: cast_nullable_to_non_nullable
                      as String,
            currentBalance: null == currentBalance
                ? _value.currentBalance
                : currentBalance // ignore: cast_nullable_to_non_nullable
                      as CurrentBalance,
          )
          as $Val,
    );
  }

  /// Create a copy of SaleOrderPartyData
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
abstract class _$$SaleOrderPartyDataImplCopyWith<$Res>
    implements $SaleOrderPartyDataCopyWith<$Res> {
  factory _$$SaleOrderPartyDataImplCopyWith(
    _$SaleOrderPartyDataImpl value,
    $Res Function(_$SaleOrderPartyDataImpl) then,
  ) = __$$SaleOrderPartyDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    String partyAccount,
    String address,
    String contactNumber,
    String stateCode,
    double creditLimit,
    int creditDays,
    String accountCategory,
    CurrentBalance currentBalance,
  });

  @override
  $CurrentBalanceCopyWith<$Res> get currentBalance;
}

/// @nodoc
class __$$SaleOrderPartyDataImplCopyWithImpl<$Res>
    extends _$SaleOrderPartyDataCopyWithImpl<$Res, _$SaleOrderPartyDataImpl>
    implements _$$SaleOrderPartyDataImplCopyWith<$Res> {
  __$$SaleOrderPartyDataImplCopyWithImpl(
    _$SaleOrderPartyDataImpl _value,
    $Res Function(_$SaleOrderPartyDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SaleOrderPartyData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? partyAccount = null,
    Object? address = null,
    Object? contactNumber = null,
    Object? stateCode = null,
    Object? creditLimit = null,
    Object? creditDays = null,
    Object? accountCategory = null,
    Object? currentBalance = null,
  }) {
    return _then(
      _$SaleOrderPartyDataImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        partyAccount: null == partyAccount
            ? _value.partyAccount
            : partyAccount // ignore: cast_nullable_to_non_nullable
                  as String,
        address: null == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String,
        contactNumber: null == contactNumber
            ? _value.contactNumber
            : contactNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        stateCode: null == stateCode
            ? _value.stateCode
            : stateCode // ignore: cast_nullable_to_non_nullable
                  as String,
        creditLimit: null == creditLimit
            ? _value.creditLimit
            : creditLimit // ignore: cast_nullable_to_non_nullable
                  as double,
        creditDays: null == creditDays
            ? _value.creditDays
            : creditDays // ignore: cast_nullable_to_non_nullable
                  as int,
        accountCategory: null == accountCategory
            ? _value.accountCategory
            : accountCategory // ignore: cast_nullable_to_non_nullable
                  as String,
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
class _$SaleOrderPartyDataImpl implements _SaleOrderPartyData {
  const _$SaleOrderPartyDataImpl({
    @JsonKey(name: '_id') this.id,
    this.partyAccount = '',
    this.address = '',
    this.contactNumber = '',
    this.stateCode = '',
    this.creditLimit = 0.0,
    this.creditDays = 0,
    this.accountCategory = '',
    this.currentBalance = const CurrentBalance(),
  });

  factory _$SaleOrderPartyDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$SaleOrderPartyDataImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String? id;
  @override
  @JsonKey()
  final String partyAccount;
  @override
  @JsonKey()
  final String address;
  @override
  @JsonKey()
  final String contactNumber;
  @override
  @JsonKey()
  final String stateCode;
  @override
  @JsonKey()
  final double creditLimit;
  @override
  @JsonKey()
  final int creditDays;
  @override
  @JsonKey()
  final String accountCategory;
  // For pricing logic
  @override
  @JsonKey()
  final CurrentBalance currentBalance;

  @override
  String toString() {
    return 'SaleOrderPartyData(id: $id, partyAccount: $partyAccount, address: $address, contactNumber: $contactNumber, stateCode: $stateCode, creditLimit: $creditLimit, creditDays: $creditDays, accountCategory: $accountCategory, currentBalance: $currentBalance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SaleOrderPartyDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.partyAccount, partyAccount) ||
                other.partyAccount == partyAccount) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.contactNumber, contactNumber) ||
                other.contactNumber == contactNumber) &&
            (identical(other.stateCode, stateCode) ||
                other.stateCode == stateCode) &&
            (identical(other.creditLimit, creditLimit) ||
                other.creditLimit == creditLimit) &&
            (identical(other.creditDays, creditDays) ||
                other.creditDays == creditDays) &&
            (identical(other.accountCategory, accountCategory) ||
                other.accountCategory == accountCategory) &&
            (identical(other.currentBalance, currentBalance) ||
                other.currentBalance == currentBalance));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    partyAccount,
    address,
    contactNumber,
    stateCode,
    creditLimit,
    creditDays,
    accountCategory,
    currentBalance,
  );

  /// Create a copy of SaleOrderPartyData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SaleOrderPartyDataImplCopyWith<_$SaleOrderPartyDataImpl> get copyWith =>
      __$$SaleOrderPartyDataImplCopyWithImpl<_$SaleOrderPartyDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SaleOrderPartyDataImplToJson(this);
  }
}

abstract class _SaleOrderPartyData implements SaleOrderPartyData {
  const factory _SaleOrderPartyData({
    @JsonKey(name: '_id') final String? id,
    final String partyAccount,
    final String address,
    final String contactNumber,
    final String stateCode,
    final double creditLimit,
    final int creditDays,
    final String accountCategory,
    final CurrentBalance currentBalance,
  }) = _$SaleOrderPartyDataImpl;

  factory _SaleOrderPartyData.fromJson(Map<String, dynamic> json) =
      _$SaleOrderPartyDataImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String? get id;
  @override
  String get partyAccount;
  @override
  String get address;
  @override
  String get contactNumber;
  @override
  String get stateCode;
  @override
  double get creditLimit;
  @override
  int get creditDays;
  @override
  String get accountCategory; // For pricing logic
  @override
  CurrentBalance get currentBalance;

  /// Create a copy of SaleOrderPartyData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SaleOrderPartyDataImplCopyWith<_$SaleOrderPartyDataImpl> get copyWith =>
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

SaleOrderItem _$SaleOrderItemFromJson(Map<String, dynamic> json) {
  return _SaleOrderItem.fromJson(json);
}

/// @nodoc
mixin _$SaleOrderItem {
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;
  String get barcode => throw _privateConstructorUsedError;
  String get itemName => throw _privateConstructorUsedError;
  String get billItemName => throw _privateConstructorUsedError;
  String get vendorItemName => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  String get dia => throw _privateConstructorUsedError;
  String get eye => throw _privateConstructorUsedError;
  double get sph => throw _privateConstructorUsedError;
  double get cyl => throw _privateConstructorUsedError;
  double get axis => throw _privateConstructorUsedError;
  double get add => throw _privateConstructorUsedError;
  int get qty => throw _privateConstructorUsedError;
  bool get isInvoiced => throw _privateConstructorUsedError;
  bool get isChallaned => throw _privateConstructorUsedError;
  double get salePrice => throw _privateConstructorUsedError;
  double get discount => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  double get sellPrice => throw _privateConstructorUsedError;
  double get purchasePrice => throw _privateConstructorUsedError;
  String get combinationId => throw _privateConstructorUsedError;
  String get orderNo => throw _privateConstructorUsedError;
  String get itemStatus => throw _privateConstructorUsedError;
  String? get remark => throw _privateConstructorUsedError;
  String? get vendor => throw _privateConstructorUsedError;
  String? get partyName => throw _privateConstructorUsedError;
  String? get cancelReason => throw _privateConstructorUsedError;

  /// Serializes this SaleOrderItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SaleOrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SaleOrderItemCopyWith<SaleOrderItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SaleOrderItemCopyWith<$Res> {
  factory $SaleOrderItemCopyWith(
    SaleOrderItem value,
    $Res Function(SaleOrderItem) then,
  ) = _$SaleOrderItemCopyWithImpl<$Res, SaleOrderItem>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    String barcode,
    String itemName,
    String billItemName,
    String vendorItemName,
    String unit,
    String dia,
    String eye,
    double sph,
    double cyl,
    double axis,
    double add,
    int qty,
    bool isInvoiced,
    bool isChallaned,
    double salePrice,
    double discount,
    double totalAmount,
    double sellPrice,
    double purchasePrice,
    String combinationId,
    String orderNo,
    String itemStatus,
    String? remark,
    String? vendor,
    String? partyName,
    String? cancelReason,
  });
}

/// @nodoc
class _$SaleOrderItemCopyWithImpl<$Res, $Val extends SaleOrderItem>
    implements $SaleOrderItemCopyWith<$Res> {
  _$SaleOrderItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SaleOrderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? barcode = null,
    Object? itemName = null,
    Object? billItemName = null,
    Object? vendorItemName = null,
    Object? unit = null,
    Object? dia = null,
    Object? eye = null,
    Object? sph = null,
    Object? cyl = null,
    Object? axis = null,
    Object? add = null,
    Object? qty = null,
    Object? isInvoiced = null,
    Object? isChallaned = null,
    Object? salePrice = null,
    Object? discount = null,
    Object? totalAmount = null,
    Object? sellPrice = null,
    Object? purchasePrice = null,
    Object? combinationId = null,
    Object? orderNo = null,
    Object? itemStatus = null,
    Object? remark = freezed,
    Object? vendor = freezed,
    Object? partyName = freezed,
    Object? cancelReason = freezed,
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
            unit: null == unit
                ? _value.unit
                : unit // ignore: cast_nullable_to_non_nullable
                      as String,
            dia: null == dia
                ? _value.dia
                : dia // ignore: cast_nullable_to_non_nullable
                      as String,
            eye: null == eye
                ? _value.eye
                : eye // ignore: cast_nullable_to_non_nullable
                      as String,
            sph: null == sph
                ? _value.sph
                : sph // ignore: cast_nullable_to_non_nullable
                      as double,
            cyl: null == cyl
                ? _value.cyl
                : cyl // ignore: cast_nullable_to_non_nullable
                      as double,
            axis: null == axis
                ? _value.axis
                : axis // ignore: cast_nullable_to_non_nullable
                      as double,
            add: null == add
                ? _value.add
                : add // ignore: cast_nullable_to_non_nullable
                      as double,
            qty: null == qty
                ? _value.qty
                : qty // ignore: cast_nullable_to_non_nullable
                      as int,
            isInvoiced: null == isInvoiced
                ? _value.isInvoiced
                : isInvoiced // ignore: cast_nullable_to_non_nullable
                      as bool,
            isChallaned: null == isChallaned
                ? _value.isChallaned
                : isChallaned // ignore: cast_nullable_to_non_nullable
                      as bool,
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
            sellPrice: null == sellPrice
                ? _value.sellPrice
                : sellPrice // ignore: cast_nullable_to_non_nullable
                      as double,
            purchasePrice: null == purchasePrice
                ? _value.purchasePrice
                : purchasePrice // ignore: cast_nullable_to_non_nullable
                      as double,
            combinationId: null == combinationId
                ? _value.combinationId
                : combinationId // ignore: cast_nullable_to_non_nullable
                      as String,
            orderNo: null == orderNo
                ? _value.orderNo
                : orderNo // ignore: cast_nullable_to_non_nullable
                      as String,
            itemStatus: null == itemStatus
                ? _value.itemStatus
                : itemStatus // ignore: cast_nullable_to_non_nullable
                      as String,
            remark: freezed == remark
                ? _value.remark
                : remark // ignore: cast_nullable_to_non_nullable
                      as String?,
            vendor: freezed == vendor
                ? _value.vendor
                : vendor // ignore: cast_nullable_to_non_nullable
                      as String?,
            partyName: freezed == partyName
                ? _value.partyName
                : partyName // ignore: cast_nullable_to_non_nullable
                      as String?,
            cancelReason: freezed == cancelReason
                ? _value.cancelReason
                : cancelReason // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SaleOrderItemImplCopyWith<$Res>
    implements $SaleOrderItemCopyWith<$Res> {
  factory _$$SaleOrderItemImplCopyWith(
    _$SaleOrderItemImpl value,
    $Res Function(_$SaleOrderItemImpl) then,
  ) = __$$SaleOrderItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    String barcode,
    String itemName,
    String billItemName,
    String vendorItemName,
    String unit,
    String dia,
    String eye,
    double sph,
    double cyl,
    double axis,
    double add,
    int qty,
    bool isInvoiced,
    bool isChallaned,
    double salePrice,
    double discount,
    double totalAmount,
    double sellPrice,
    double purchasePrice,
    String combinationId,
    String orderNo,
    String itemStatus,
    String? remark,
    String? vendor,
    String? partyName,
    String? cancelReason,
  });
}

/// @nodoc
class __$$SaleOrderItemImplCopyWithImpl<$Res>
    extends _$SaleOrderItemCopyWithImpl<$Res, _$SaleOrderItemImpl>
    implements _$$SaleOrderItemImplCopyWith<$Res> {
  __$$SaleOrderItemImplCopyWithImpl(
    _$SaleOrderItemImpl _value,
    $Res Function(_$SaleOrderItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SaleOrderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? barcode = null,
    Object? itemName = null,
    Object? billItemName = null,
    Object? vendorItemName = null,
    Object? unit = null,
    Object? dia = null,
    Object? eye = null,
    Object? sph = null,
    Object? cyl = null,
    Object? axis = null,
    Object? add = null,
    Object? qty = null,
    Object? isInvoiced = null,
    Object? isChallaned = null,
    Object? salePrice = null,
    Object? discount = null,
    Object? totalAmount = null,
    Object? sellPrice = null,
    Object? purchasePrice = null,
    Object? combinationId = null,
    Object? orderNo = null,
    Object? itemStatus = null,
    Object? remark = freezed,
    Object? vendor = freezed,
    Object? partyName = freezed,
    Object? cancelReason = freezed,
  }) {
    return _then(
      _$SaleOrderItemImpl(
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
        unit: null == unit
            ? _value.unit
            : unit // ignore: cast_nullable_to_non_nullable
                  as String,
        dia: null == dia
            ? _value.dia
            : dia // ignore: cast_nullable_to_non_nullable
                  as String,
        eye: null == eye
            ? _value.eye
            : eye // ignore: cast_nullable_to_non_nullable
                  as String,
        sph: null == sph
            ? _value.sph
            : sph // ignore: cast_nullable_to_non_nullable
                  as double,
        cyl: null == cyl
            ? _value.cyl
            : cyl // ignore: cast_nullable_to_non_nullable
                  as double,
        axis: null == axis
            ? _value.axis
            : axis // ignore: cast_nullable_to_non_nullable
                  as double,
        add: null == add
            ? _value.add
            : add // ignore: cast_nullable_to_non_nullable
                  as double,
        qty: null == qty
            ? _value.qty
            : qty // ignore: cast_nullable_to_non_nullable
                  as int,
        isInvoiced: null == isInvoiced
            ? _value.isInvoiced
            : isInvoiced // ignore: cast_nullable_to_non_nullable
                  as bool,
        isChallaned: null == isChallaned
            ? _value.isChallaned
            : isChallaned // ignore: cast_nullable_to_non_nullable
                  as bool,
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
        sellPrice: null == sellPrice
            ? _value.sellPrice
            : sellPrice // ignore: cast_nullable_to_non_nullable
                  as double,
        purchasePrice: null == purchasePrice
            ? _value.purchasePrice
            : purchasePrice // ignore: cast_nullable_to_non_nullable
                  as double,
        combinationId: null == combinationId
            ? _value.combinationId
            : combinationId // ignore: cast_nullable_to_non_nullable
                  as String,
        orderNo: null == orderNo
            ? _value.orderNo
            : orderNo // ignore: cast_nullable_to_non_nullable
                  as String,
        itemStatus: null == itemStatus
            ? _value.itemStatus
            : itemStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        remark: freezed == remark
            ? _value.remark
            : remark // ignore: cast_nullable_to_non_nullable
                  as String?,
        vendor: freezed == vendor
            ? _value.vendor
            : vendor // ignore: cast_nullable_to_non_nullable
                  as String?,
        partyName: freezed == partyName
            ? _value.partyName
            : partyName // ignore: cast_nullable_to_non_nullable
                  as String?,
        cancelReason: freezed == cancelReason
            ? _value.cancelReason
            : cancelReason // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SaleOrderItemImpl implements _SaleOrderItem {
  const _$SaleOrderItemImpl({
    @JsonKey(name: '_id') this.id,
    this.barcode = '',
    this.itemName = '',
    this.billItemName = '',
    this.vendorItemName = '',
    this.unit = '',
    this.dia = '',
    this.eye = '',
    this.sph = 0.0,
    this.cyl = 0.0,
    this.axis = 0.0,
    this.add = 0.0,
    this.qty = 0,
    this.isInvoiced = false,
    this.isChallaned = false,
    this.salePrice = 0.0,
    this.discount = 0.0,
    this.totalAmount = 0.0,
    this.sellPrice = 0.0,
    this.purchasePrice = 0.0,
    this.combinationId = '',
    this.orderNo = '',
    this.itemStatus = 'Pending',
    this.remark,
    this.vendor,
    this.partyName,
    this.cancelReason,
  });

  factory _$SaleOrderItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$SaleOrderItemImplFromJson(json);

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
  final String unit;
  @override
  @JsonKey()
  final String dia;
  @override
  @JsonKey()
  final String eye;
  @override
  @JsonKey()
  final double sph;
  @override
  @JsonKey()
  final double cyl;
  @override
  @JsonKey()
  final double axis;
  @override
  @JsonKey()
  final double add;
  @override
  @JsonKey()
  final int qty;
  @override
  @JsonKey()
  final bool isInvoiced;
  @override
  @JsonKey()
  final bool isChallaned;
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
  final double sellPrice;
  @override
  @JsonKey()
  final double purchasePrice;
  @override
  @JsonKey()
  final String combinationId;
  @override
  @JsonKey()
  final String orderNo;
  @override
  @JsonKey()
  final String itemStatus;
  @override
  final String? remark;
  @override
  final String? vendor;
  @override
  final String? partyName;
  @override
  final String? cancelReason;

  @override
  String toString() {
    return 'SaleOrderItem(id: $id, barcode: $barcode, itemName: $itemName, billItemName: $billItemName, vendorItemName: $vendorItemName, unit: $unit, dia: $dia, eye: $eye, sph: $sph, cyl: $cyl, axis: $axis, add: $add, qty: $qty, isInvoiced: $isInvoiced, isChallaned: $isChallaned, salePrice: $salePrice, discount: $discount, totalAmount: $totalAmount, sellPrice: $sellPrice, purchasePrice: $purchasePrice, combinationId: $combinationId, orderNo: $orderNo, itemStatus: $itemStatus, remark: $remark, vendor: $vendor, partyName: $partyName, cancelReason: $cancelReason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SaleOrderItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.barcode, barcode) || other.barcode == barcode) &&
            (identical(other.itemName, itemName) ||
                other.itemName == itemName) &&
            (identical(other.billItemName, billItemName) ||
                other.billItemName == billItemName) &&
            (identical(other.vendorItemName, vendorItemName) ||
                other.vendorItemName == vendorItemName) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.dia, dia) || other.dia == dia) &&
            (identical(other.eye, eye) || other.eye == eye) &&
            (identical(other.sph, sph) || other.sph == sph) &&
            (identical(other.cyl, cyl) || other.cyl == cyl) &&
            (identical(other.axis, axis) || other.axis == axis) &&
            (identical(other.add, add) || other.add == add) &&
            (identical(other.qty, qty) || other.qty == qty) &&
            (identical(other.isInvoiced, isInvoiced) ||
                other.isInvoiced == isInvoiced) &&
            (identical(other.isChallaned, isChallaned) ||
                other.isChallaned == isChallaned) &&
            (identical(other.salePrice, salePrice) ||
                other.salePrice == salePrice) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.sellPrice, sellPrice) ||
                other.sellPrice == sellPrice) &&
            (identical(other.purchasePrice, purchasePrice) ||
                other.purchasePrice == purchasePrice) &&
            (identical(other.combinationId, combinationId) ||
                other.combinationId == combinationId) &&
            (identical(other.orderNo, orderNo) || other.orderNo == orderNo) &&
            (identical(other.itemStatus, itemStatus) ||
                other.itemStatus == itemStatus) &&
            (identical(other.remark, remark) || other.remark == remark) &&
            (identical(other.vendor, vendor) || other.vendor == vendor) &&
            (identical(other.partyName, partyName) ||
                other.partyName == partyName) &&
            (identical(other.cancelReason, cancelReason) ||
                other.cancelReason == cancelReason));
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
    unit,
    dia,
    eye,
    sph,
    cyl,
    axis,
    add,
    qty,
    isInvoiced,
    isChallaned,
    salePrice,
    discount,
    totalAmount,
    sellPrice,
    purchasePrice,
    combinationId,
    orderNo,
    itemStatus,
    remark,
    vendor,
    partyName,
    cancelReason,
  ]);

  /// Create a copy of SaleOrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SaleOrderItemImplCopyWith<_$SaleOrderItemImpl> get copyWith =>
      __$$SaleOrderItemImplCopyWithImpl<_$SaleOrderItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SaleOrderItemImplToJson(this);
  }
}

abstract class _SaleOrderItem implements SaleOrderItem {
  const factory _SaleOrderItem({
    @JsonKey(name: '_id') final String? id,
    final String barcode,
    final String itemName,
    final String billItemName,
    final String vendorItemName,
    final String unit,
    final String dia,
    final String eye,
    final double sph,
    final double cyl,
    final double axis,
    final double add,
    final int qty,
    final bool isInvoiced,
    final bool isChallaned,
    final double salePrice,
    final double discount,
    final double totalAmount,
    final double sellPrice,
    final double purchasePrice,
    final String combinationId,
    final String orderNo,
    final String itemStatus,
    final String? remark,
    final String? vendor,
    final String? partyName,
    final String? cancelReason,
  }) = _$SaleOrderItemImpl;

  factory _SaleOrderItem.fromJson(Map<String, dynamic> json) =
      _$SaleOrderItemImpl.fromJson;

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
  String get unit;
  @override
  String get dia;
  @override
  String get eye;
  @override
  double get sph;
  @override
  double get cyl;
  @override
  double get axis;
  @override
  double get add;
  @override
  int get qty;
  @override
  bool get isInvoiced;
  @override
  bool get isChallaned;
  @override
  double get salePrice;
  @override
  double get discount;
  @override
  double get totalAmount;
  @override
  double get sellPrice;
  @override
  double get purchasePrice;
  @override
  String get combinationId;
  @override
  String get orderNo;
  @override
  String get itemStatus;
  @override
  String? get remark;
  @override
  String? get vendor;
  @override
  String? get partyName;
  @override
  String? get cancelReason;

  /// Create a copy of SaleOrderItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SaleOrderItemImplCopyWith<_$SaleOrderItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SaleOrderTax _$SaleOrderTaxFromJson(Map<String, dynamic> json) {
  return _SaleOrderTax.fromJson(json);
}

/// @nodoc
mixin _$SaleOrderTax {
  String get taxName => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  double get percentage => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  Map<String, dynamic> get meta => throw _privateConstructorUsedError;

  /// Serializes this SaleOrderTax to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SaleOrderTax
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SaleOrderTaxCopyWith<SaleOrderTax> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SaleOrderTaxCopyWith<$Res> {
  factory $SaleOrderTaxCopyWith(
    SaleOrderTax value,
    $Res Function(SaleOrderTax) then,
  ) = _$SaleOrderTaxCopyWithImpl<$Res, SaleOrderTax>;
  @useResult
  $Res call({
    String taxName,
    String type,
    double percentage,
    double amount,
    Map<String, dynamic> meta,
  });
}

/// @nodoc
class _$SaleOrderTaxCopyWithImpl<$Res, $Val extends SaleOrderTax>
    implements $SaleOrderTaxCopyWith<$Res> {
  _$SaleOrderTaxCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SaleOrderTax
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? taxName = null,
    Object? type = null,
    Object? percentage = null,
    Object? amount = null,
    Object? meta = null,
  }) {
    return _then(
      _value.copyWith(
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
            meta: null == meta
                ? _value.meta
                : meta // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SaleOrderTaxImplCopyWith<$Res>
    implements $SaleOrderTaxCopyWith<$Res> {
  factory _$$SaleOrderTaxImplCopyWith(
    _$SaleOrderTaxImpl value,
    $Res Function(_$SaleOrderTaxImpl) then,
  ) = __$$SaleOrderTaxImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String taxName,
    String type,
    double percentage,
    double amount,
    Map<String, dynamic> meta,
  });
}

/// @nodoc
class __$$SaleOrderTaxImplCopyWithImpl<$Res>
    extends _$SaleOrderTaxCopyWithImpl<$Res, _$SaleOrderTaxImpl>
    implements _$$SaleOrderTaxImplCopyWith<$Res> {
  __$$SaleOrderTaxImplCopyWithImpl(
    _$SaleOrderTaxImpl _value,
    $Res Function(_$SaleOrderTaxImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SaleOrderTax
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? taxName = null,
    Object? type = null,
    Object? percentage = null,
    Object? amount = null,
    Object? meta = null,
  }) {
    return _then(
      _$SaleOrderTaxImpl(
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
        meta: null == meta
            ? _value._meta
            : meta // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SaleOrderTaxImpl implements _SaleOrderTax {
  const _$SaleOrderTaxImpl({
    this.taxName = '',
    this.type = 'Additive',
    this.percentage = 0.0,
    this.amount = 0.0,
    final Map<String, dynamic> meta = const {},
  }) : _meta = meta;

  factory _$SaleOrderTaxImpl.fromJson(Map<String, dynamic> json) =>
      _$$SaleOrderTaxImplFromJson(json);

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
  final Map<String, dynamic> _meta;
  @override
  @JsonKey()
  Map<String, dynamic> get meta {
    if (_meta is EqualUnmodifiableMapView) return _meta;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_meta);
  }

  @override
  String toString() {
    return 'SaleOrderTax(taxName: $taxName, type: $type, percentage: $percentage, amount: $amount, meta: $meta)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SaleOrderTaxImpl &&
            (identical(other.taxName, taxName) || other.taxName == taxName) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            const DeepCollectionEquality().equals(other._meta, _meta));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    taxName,
    type,
    percentage,
    amount,
    const DeepCollectionEquality().hash(_meta),
  );

  /// Create a copy of SaleOrderTax
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SaleOrderTaxImplCopyWith<_$SaleOrderTaxImpl> get copyWith =>
      __$$SaleOrderTaxImplCopyWithImpl<_$SaleOrderTaxImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SaleOrderTaxImplToJson(this);
  }
}

abstract class _SaleOrderTax implements SaleOrderTax {
  const factory _SaleOrderTax({
    final String taxName,
    final String type,
    final double percentage,
    final double amount,
    final Map<String, dynamic> meta,
  }) = _$SaleOrderTaxImpl;

  factory _SaleOrderTax.fromJson(Map<String, dynamic> json) =
      _$SaleOrderTaxImpl.fromJson;

  @override
  String get taxName;
  @override
  String get type;
  @override
  double get percentage;
  @override
  double get amount;
  @override
  Map<String, dynamic> get meta;

  /// Create a copy of SaleOrderTax
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SaleOrderTaxImplCopyWith<_$SaleOrderTaxImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
