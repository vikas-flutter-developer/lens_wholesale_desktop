// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lens_sale_challan_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LensSaleChallanModel _$LensSaleChallanModelFromJson(Map<String, dynamic> json) {
  return _LensSaleChallanModel.fromJson(json);
}

/// @nodoc
mixin _$LensSaleChallanModel {
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
  String? get remark => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get sourceSaleId => throw _privateConstructorUsedError;
  String? get companyId => throw _privateConstructorUsedError;

  /// Serializes this LensSaleChallanModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LensSaleChallanModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LensSaleChallanModelCopyWith<LensSaleChallanModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LensSaleChallanModelCopyWith<$Res> {
  factory $LensSaleChallanModelCopyWith(
    LensSaleChallanModel value,
    $Res Function(LensSaleChallanModel) then,
  ) = _$LensSaleChallanModelCopyWithImpl<$Res, LensSaleChallanModel>;
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
    String? remark,
    String status,
    String? sourceSaleId,
    String? companyId,
  });

  $SaleOrderBillDataCopyWith<$Res> get billData;
  $SaleOrderPartyDataCopyWith<$Res> get partyData;
}

/// @nodoc
class _$LensSaleChallanModelCopyWithImpl<
  $Res,
  $Val extends LensSaleChallanModel
>
    implements $LensSaleChallanModelCopyWith<$Res> {
  _$LensSaleChallanModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LensSaleChallanModel
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
    Object? remark = freezed,
    Object? status = null,
    Object? sourceSaleId = freezed,
    Object? companyId = freezed,
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
            remark: freezed == remark
                ? _value.remark
                : remark // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            sourceSaleId: freezed == sourceSaleId
                ? _value.sourceSaleId
                : sourceSaleId // ignore: cast_nullable_to_non_nullable
                      as String?,
            companyId: freezed == companyId
                ? _value.companyId
                : companyId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of LensSaleChallanModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SaleOrderBillDataCopyWith<$Res> get billData {
    return $SaleOrderBillDataCopyWith<$Res>(_value.billData, (value) {
      return _then(_value.copyWith(billData: value) as $Val);
    });
  }

  /// Create a copy of LensSaleChallanModel
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
abstract class _$$LensSaleChallanModelImplCopyWith<$Res>
    implements $LensSaleChallanModelCopyWith<$Res> {
  factory _$$LensSaleChallanModelImplCopyWith(
    _$LensSaleChallanModelImpl value,
    $Res Function(_$LensSaleChallanModelImpl) then,
  ) = __$$LensSaleChallanModelImplCopyWithImpl<$Res>;
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
    String? remark,
    String status,
    String? sourceSaleId,
    String? companyId,
  });

  @override
  $SaleOrderBillDataCopyWith<$Res> get billData;
  @override
  $SaleOrderPartyDataCopyWith<$Res> get partyData;
}

/// @nodoc
class __$$LensSaleChallanModelImplCopyWithImpl<$Res>
    extends _$LensSaleChallanModelCopyWithImpl<$Res, _$LensSaleChallanModelImpl>
    implements _$$LensSaleChallanModelImplCopyWith<$Res> {
  __$$LensSaleChallanModelImplCopyWithImpl(
    _$LensSaleChallanModelImpl _value,
    $Res Function(_$LensSaleChallanModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LensSaleChallanModel
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
    Object? remark = freezed,
    Object? status = null,
    Object? sourceSaleId = freezed,
    Object? companyId = freezed,
  }) {
    return _then(
      _$LensSaleChallanModelImpl(
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
        remark: freezed == remark
            ? _value.remark
            : remark // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        sourceSaleId: freezed == sourceSaleId
            ? _value.sourceSaleId
            : sourceSaleId // ignore: cast_nullable_to_non_nullable
                  as String?,
        companyId: freezed == companyId
            ? _value.companyId
            : companyId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LensSaleChallanModelImpl implements _LensSaleChallanModel {
  const _$LensSaleChallanModelImpl({
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
    this.remark,
    this.status = 'Pending',
    this.sourceSaleId,
    this.companyId,
  }) : _items = items,
       _taxes = taxes;

  factory _$LensSaleChallanModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LensSaleChallanModelImplFromJson(json);

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
  final String? remark;
  @override
  @JsonKey()
  final String status;
  @override
  final String? sourceSaleId;
  @override
  final String? companyId;

  @override
  String toString() {
    return 'LensSaleChallanModel(id: $id, billData: $billData, partyData: $partyData, items: $items, taxes: $taxes, orderQty: $orderQty, usedQty: $usedQty, balQty: $balQty, grossAmount: $grossAmount, subtotal: $subtotal, taxesAmount: $taxesAmount, netAmount: $netAmount, paidAmount: $paidAmount, dueAmount: $dueAmount, remark: $remark, status: $status, sourceSaleId: $sourceSaleId, companyId: $companyId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LensSaleChallanModelImpl &&
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
            (identical(other.remark, remark) || other.remark == remark) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.sourceSaleId, sourceSaleId) ||
                other.sourceSaleId == sourceSaleId) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId));
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
    orderQty,
    usedQty,
    balQty,
    grossAmount,
    subtotal,
    taxesAmount,
    netAmount,
    paidAmount,
    dueAmount,
    remark,
    status,
    sourceSaleId,
    companyId,
  );

  /// Create a copy of LensSaleChallanModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LensSaleChallanModelImplCopyWith<_$LensSaleChallanModelImpl>
  get copyWith =>
      __$$LensSaleChallanModelImplCopyWithImpl<_$LensSaleChallanModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LensSaleChallanModelImplToJson(this);
  }
}

abstract class _LensSaleChallanModel implements LensSaleChallanModel {
  const factory _LensSaleChallanModel({
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
    final String? remark,
    final String status,
    final String? sourceSaleId,
    final String? companyId,
  }) = _$LensSaleChallanModelImpl;

  factory _LensSaleChallanModel.fromJson(Map<String, dynamic> json) =
      _$LensSaleChallanModelImpl.fromJson;

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
  String? get remark;
  @override
  String get status;
  @override
  String? get sourceSaleId;
  @override
  String? get companyId;

  /// Create a copy of LensSaleChallanModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LensSaleChallanModelImplCopyWith<_$LensSaleChallanModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
