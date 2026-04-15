// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lens_sale_invoice_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LensSaleInvoiceModel _$LensSaleInvoiceModelFromJson(Map<String, dynamic> json) {
  return _LensSaleInvoiceModel.fromJson(json);
}

/// @nodoc
mixin _$LensSaleInvoiceModel {
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;
  SaleOrderBillData get billData => throw _privateConstructorUsedError;
  SaleOrderPartyData get partyData => throw _privateConstructorUsedError;
  List<SaleOrderItem> get items => throw _privateConstructorUsedError;
  List<SaleOrderTax> get taxes => throw _privateConstructorUsedError;
  int get invoiceQty => throw _privateConstructorUsedError;
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
  String? get deliveryPerson => throw _privateConstructorUsedError;
  String get orderType => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this LensSaleInvoiceModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LensSaleInvoiceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LensSaleInvoiceModelCopyWith<LensSaleInvoiceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LensSaleInvoiceModelCopyWith<$Res> {
  factory $LensSaleInvoiceModelCopyWith(
    LensSaleInvoiceModel value,
    $Res Function(LensSaleInvoiceModel) then,
  ) = _$LensSaleInvoiceModelCopyWithImpl<$Res, LensSaleInvoiceModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    SaleOrderBillData billData,
    SaleOrderPartyData partyData,
    List<SaleOrderItem> items,
    List<SaleOrderTax> taxes,
    int invoiceQty,
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
    String? deliveryPerson,
    String orderType,
    String? createdAt,
  });

  $SaleOrderBillDataCopyWith<$Res> get billData;
  $SaleOrderPartyDataCopyWith<$Res> get partyData;
}

/// @nodoc
class _$LensSaleInvoiceModelCopyWithImpl<
  $Res,
  $Val extends LensSaleInvoiceModel
>
    implements $LensSaleInvoiceModelCopyWith<$Res> {
  _$LensSaleInvoiceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LensSaleInvoiceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? billData = null,
    Object? partyData = null,
    Object? items = null,
    Object? taxes = null,
    Object? invoiceQty = null,
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
    Object? deliveryPerson = freezed,
    Object? orderType = null,
    Object? createdAt = freezed,
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
            invoiceQty: null == invoiceQty
                ? _value.invoiceQty
                : invoiceQty // ignore: cast_nullable_to_non_nullable
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
            deliveryPerson: freezed == deliveryPerson
                ? _value.deliveryPerson
                : deliveryPerson // ignore: cast_nullable_to_non_nullable
                      as String?,
            orderType: null == orderType
                ? _value.orderType
                : orderType // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of LensSaleInvoiceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SaleOrderBillDataCopyWith<$Res> get billData {
    return $SaleOrderBillDataCopyWith<$Res>(_value.billData, (value) {
      return _then(_value.copyWith(billData: value) as $Val);
    });
  }

  /// Create a copy of LensSaleInvoiceModel
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
abstract class _$$LensSaleInvoiceModelImplCopyWith<$Res>
    implements $LensSaleInvoiceModelCopyWith<$Res> {
  factory _$$LensSaleInvoiceModelImplCopyWith(
    _$LensSaleInvoiceModelImpl value,
    $Res Function(_$LensSaleInvoiceModelImpl) then,
  ) = __$$LensSaleInvoiceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    SaleOrderBillData billData,
    SaleOrderPartyData partyData,
    List<SaleOrderItem> items,
    List<SaleOrderTax> taxes,
    int invoiceQty,
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
    String? deliveryPerson,
    String orderType,
    String? createdAt,
  });

  @override
  $SaleOrderBillDataCopyWith<$Res> get billData;
  @override
  $SaleOrderPartyDataCopyWith<$Res> get partyData;
}

/// @nodoc
class __$$LensSaleInvoiceModelImplCopyWithImpl<$Res>
    extends _$LensSaleInvoiceModelCopyWithImpl<$Res, _$LensSaleInvoiceModelImpl>
    implements _$$LensSaleInvoiceModelImplCopyWith<$Res> {
  __$$LensSaleInvoiceModelImplCopyWithImpl(
    _$LensSaleInvoiceModelImpl _value,
    $Res Function(_$LensSaleInvoiceModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LensSaleInvoiceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? billData = null,
    Object? partyData = null,
    Object? items = null,
    Object? taxes = null,
    Object? invoiceQty = null,
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
    Object? deliveryPerson = freezed,
    Object? orderType = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$LensSaleInvoiceModelImpl(
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
        invoiceQty: null == invoiceQty
            ? _value.invoiceQty
            : invoiceQty // ignore: cast_nullable_to_non_nullable
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
        deliveryPerson: freezed == deliveryPerson
            ? _value.deliveryPerson
            : deliveryPerson // ignore: cast_nullable_to_non_nullable
                  as String?,
        orderType: null == orderType
            ? _value.orderType
            : orderType // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LensSaleInvoiceModelImpl implements _LensSaleInvoiceModel {
  const _$LensSaleInvoiceModelImpl({
    @JsonKey(name: '_id') this.id,
    this.billData = const SaleOrderBillData(),
    this.partyData = const SaleOrderPartyData(),
    final List<SaleOrderItem> items = const [],
    final List<SaleOrderTax> taxes = const [],
    this.invoiceQty = 0,
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
    this.deliveryPerson,
    this.orderType = 'LENS',
    this.createdAt,
  }) : _items = items,
       _taxes = taxes;

  factory _$LensSaleInvoiceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LensSaleInvoiceModelImplFromJson(json);

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
  final int invoiceQty;
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
  final String? deliveryPerson;
  @override
  @JsonKey()
  final String orderType;
  @override
  final String? createdAt;

  @override
  String toString() {
    return 'LensSaleInvoiceModel(id: $id, billData: $billData, partyData: $partyData, items: $items, taxes: $taxes, invoiceQty: $invoiceQty, grossAmount: $grossAmount, subtotal: $subtotal, taxesAmount: $taxesAmount, netAmount: $netAmount, paidAmount: $paidAmount, dueAmount: $dueAmount, remark: $remark, status: $status, sourceSaleId: $sourceSaleId, companyId: $companyId, deliveryPerson: $deliveryPerson, orderType: $orderType, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LensSaleInvoiceModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.billData, billData) ||
                other.billData == billData) &&
            (identical(other.partyData, partyData) ||
                other.partyData == partyData) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality().equals(other._taxes, _taxes) &&
            (identical(other.invoiceQty, invoiceQty) ||
                other.invoiceQty == invoiceQty) &&
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
                other.companyId == companyId) &&
            (identical(other.deliveryPerson, deliveryPerson) ||
                other.deliveryPerson == deliveryPerson) &&
            (identical(other.orderType, orderType) ||
                other.orderType == orderType) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
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
    invoiceQty,
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
    deliveryPerson,
    orderType,
    createdAt,
  ]);

  /// Create a copy of LensSaleInvoiceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LensSaleInvoiceModelImplCopyWith<_$LensSaleInvoiceModelImpl>
  get copyWith =>
      __$$LensSaleInvoiceModelImplCopyWithImpl<_$LensSaleInvoiceModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LensSaleInvoiceModelImplToJson(this);
  }
}

abstract class _LensSaleInvoiceModel implements LensSaleInvoiceModel {
  const factory _LensSaleInvoiceModel({
    @JsonKey(name: '_id') final String? id,
    final SaleOrderBillData billData,
    final SaleOrderPartyData partyData,
    final List<SaleOrderItem> items,
    final List<SaleOrderTax> taxes,
    final int invoiceQty,
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
    final String? deliveryPerson,
    final String orderType,
    final String? createdAt,
  }) = _$LensSaleInvoiceModelImpl;

  factory _LensSaleInvoiceModel.fromJson(Map<String, dynamic> json) =
      _$LensSaleInvoiceModelImpl.fromJson;

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
  int get invoiceQty;
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
  @override
  String? get deliveryPerson;
  @override
  String get orderType;
  @override
  String? get createdAt;

  /// Create a copy of LensSaleInvoiceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LensSaleInvoiceModelImplCopyWith<_$LensSaleInvoiceModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
