// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rx_sale_order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RxOrderItem _$RxOrderItemFromJson(Map<String, dynamic> json) {
  return _RxOrderItem.fromJson(json);
}

/// @nodoc
mixin _$RxOrderItem {
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;
  String get barcode => throw _privateConstructorUsedError;
  String get itemName => throw _privateConstructorUsedError;
  String get billItemName => throw _privateConstructorUsedError;
  String get vendorItemName => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  String get orderNo => throw _privateConstructorUsedError;
  String get dia => throw _privateConstructorUsedError;
  String get eye => throw _privateConstructorUsedError;
  double get sph => throw _privateConstructorUsedError;
  double get cyl => throw _privateConstructorUsedError;
  double get axis => throw _privateConstructorUsedError;
  double get add => throw _privateConstructorUsedError;
  int get qty => throw _privateConstructorUsedError;
  double get salePrice => throw _privateConstructorUsedError;
  double get discount => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  double get sellPrice => throw _privateConstructorUsedError;
  double get purchasePrice => throw _privateConstructorUsedError;
  String get combinationId => throw _privateConstructorUsedError;
  String get customer => throw _privateConstructorUsedError; // Patient Name
  String get vendor => throw _privateConstructorUsedError;
  String get itemStatus => throw _privateConstructorUsedError;
  String? get remark => throw _privateConstructorUsedError;
  double get mrp => throw _privateConstructorUsedError;
  String? get refId =>
      throw _privateConstructorUsedError; // For Sale tracking back to Order
  String? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this RxOrderItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RxOrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RxOrderItemCopyWith<RxOrderItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RxOrderItemCopyWith<$Res> {
  factory $RxOrderItemCopyWith(
    RxOrderItem value,
    $Res Function(RxOrderItem) then,
  ) = _$RxOrderItemCopyWithImpl<$Res, RxOrderItem>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    String barcode,
    String itemName,
    String billItemName,
    String vendorItemName,
    String unit,
    String orderNo,
    String dia,
    String eye,
    double sph,
    double cyl,
    double axis,
    double add,
    int qty,
    double salePrice,
    double discount,
    double totalAmount,
    double sellPrice,
    double purchasePrice,
    String combinationId,
    String customer,
    String vendor,
    String itemStatus,
    String? remark,
    double mrp,
    String? refId,
    String? createdAt,
  });
}

/// @nodoc
class _$RxOrderItemCopyWithImpl<$Res, $Val extends RxOrderItem>
    implements $RxOrderItemCopyWith<$Res> {
  _$RxOrderItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RxOrderItem
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
    Object? orderNo = null,
    Object? dia = null,
    Object? eye = null,
    Object? sph = null,
    Object? cyl = null,
    Object? axis = null,
    Object? add = null,
    Object? qty = null,
    Object? salePrice = null,
    Object? discount = null,
    Object? totalAmount = null,
    Object? sellPrice = null,
    Object? purchasePrice = null,
    Object? combinationId = null,
    Object? customer = null,
    Object? vendor = null,
    Object? itemStatus = null,
    Object? remark = freezed,
    Object? mrp = null,
    Object? refId = freezed,
    Object? createdAt = freezed,
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
            orderNo: null == orderNo
                ? _value.orderNo
                : orderNo // ignore: cast_nullable_to_non_nullable
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
            customer: null == customer
                ? _value.customer
                : customer // ignore: cast_nullable_to_non_nullable
                      as String,
            vendor: null == vendor
                ? _value.vendor
                : vendor // ignore: cast_nullable_to_non_nullable
                      as String,
            itemStatus: null == itemStatus
                ? _value.itemStatus
                : itemStatus // ignore: cast_nullable_to_non_nullable
                      as String,
            remark: freezed == remark
                ? _value.remark
                : remark // ignore: cast_nullable_to_non_nullable
                      as String?,
            mrp: null == mrp
                ? _value.mrp
                : mrp // ignore: cast_nullable_to_non_nullable
                      as double,
            refId: freezed == refId
                ? _value.refId
                : refId // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RxOrderItemImplCopyWith<$Res>
    implements $RxOrderItemCopyWith<$Res> {
  factory _$$RxOrderItemImplCopyWith(
    _$RxOrderItemImpl value,
    $Res Function(_$RxOrderItemImpl) then,
  ) = __$$RxOrderItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    String barcode,
    String itemName,
    String billItemName,
    String vendorItemName,
    String unit,
    String orderNo,
    String dia,
    String eye,
    double sph,
    double cyl,
    double axis,
    double add,
    int qty,
    double salePrice,
    double discount,
    double totalAmount,
    double sellPrice,
    double purchasePrice,
    String combinationId,
    String customer,
    String vendor,
    String itemStatus,
    String? remark,
    double mrp,
    String? refId,
    String? createdAt,
  });
}

/// @nodoc
class __$$RxOrderItemImplCopyWithImpl<$Res>
    extends _$RxOrderItemCopyWithImpl<$Res, _$RxOrderItemImpl>
    implements _$$RxOrderItemImplCopyWith<$Res> {
  __$$RxOrderItemImplCopyWithImpl(
    _$RxOrderItemImpl _value,
    $Res Function(_$RxOrderItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RxOrderItem
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
    Object? orderNo = null,
    Object? dia = null,
    Object? eye = null,
    Object? sph = null,
    Object? cyl = null,
    Object? axis = null,
    Object? add = null,
    Object? qty = null,
    Object? salePrice = null,
    Object? discount = null,
    Object? totalAmount = null,
    Object? sellPrice = null,
    Object? purchasePrice = null,
    Object? combinationId = null,
    Object? customer = null,
    Object? vendor = null,
    Object? itemStatus = null,
    Object? remark = freezed,
    Object? mrp = null,
    Object? refId = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$RxOrderItemImpl(
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
        orderNo: null == orderNo
            ? _value.orderNo
            : orderNo // ignore: cast_nullable_to_non_nullable
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
        customer: null == customer
            ? _value.customer
            : customer // ignore: cast_nullable_to_non_nullable
                  as String,
        vendor: null == vendor
            ? _value.vendor
            : vendor // ignore: cast_nullable_to_non_nullable
                  as String,
        itemStatus: null == itemStatus
            ? _value.itemStatus
            : itemStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        remark: freezed == remark
            ? _value.remark
            : remark // ignore: cast_nullable_to_non_nullable
                  as String?,
        mrp: null == mrp
            ? _value.mrp
            : mrp // ignore: cast_nullable_to_non_nullable
                  as double,
        refId: freezed == refId
            ? _value.refId
            : refId // ignore: cast_nullable_to_non_nullable
                  as String?,
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
class _$RxOrderItemImpl implements _RxOrderItem {
  const _$RxOrderItemImpl({
    @JsonKey(name: '_id') this.id,
    this.barcode = '',
    this.itemName = '',
    this.billItemName = '',
    this.vendorItemName = '',
    this.unit = '',
    this.orderNo = '',
    this.dia = '',
    this.eye = '',
    this.sph = 0.0,
    this.cyl = 0.0,
    this.axis = 0.0,
    this.add = 0.0,
    this.qty = 0,
    this.salePrice = 0.0,
    this.discount = 0.0,
    this.totalAmount = 0.0,
    this.sellPrice = 0.0,
    this.purchasePrice = 0.0,
    this.combinationId = '',
    this.customer = '',
    this.vendor = '',
    this.itemStatus = 'Pending',
    this.remark,
    this.mrp = 0.0,
    this.refId,
    this.createdAt,
  });

  factory _$RxOrderItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$RxOrderItemImplFromJson(json);

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
  final String orderNo;
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
  final String customer;
  // Patient Name
  @override
  @JsonKey()
  final String vendor;
  @override
  @JsonKey()
  final String itemStatus;
  @override
  final String? remark;
  @override
  @JsonKey()
  final double mrp;
  @override
  final String? refId;
  // For Sale tracking back to Order
  @override
  final String? createdAt;

  @override
  String toString() {
    return 'RxOrderItem(id: $id, barcode: $barcode, itemName: $itemName, billItemName: $billItemName, vendorItemName: $vendorItemName, unit: $unit, orderNo: $orderNo, dia: $dia, eye: $eye, sph: $sph, cyl: $cyl, axis: $axis, add: $add, qty: $qty, salePrice: $salePrice, discount: $discount, totalAmount: $totalAmount, sellPrice: $sellPrice, purchasePrice: $purchasePrice, combinationId: $combinationId, customer: $customer, vendor: $vendor, itemStatus: $itemStatus, remark: $remark, mrp: $mrp, refId: $refId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RxOrderItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.barcode, barcode) || other.barcode == barcode) &&
            (identical(other.itemName, itemName) ||
                other.itemName == itemName) &&
            (identical(other.billItemName, billItemName) ||
                other.billItemName == billItemName) &&
            (identical(other.vendorItemName, vendorItemName) ||
                other.vendorItemName == vendorItemName) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.orderNo, orderNo) || other.orderNo == orderNo) &&
            (identical(other.dia, dia) || other.dia == dia) &&
            (identical(other.eye, eye) || other.eye == eye) &&
            (identical(other.sph, sph) || other.sph == sph) &&
            (identical(other.cyl, cyl) || other.cyl == cyl) &&
            (identical(other.axis, axis) || other.axis == axis) &&
            (identical(other.add, add) || other.add == add) &&
            (identical(other.qty, qty) || other.qty == qty) &&
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
            (identical(other.customer, customer) ||
                other.customer == customer) &&
            (identical(other.vendor, vendor) || other.vendor == vendor) &&
            (identical(other.itemStatus, itemStatus) ||
                other.itemStatus == itemStatus) &&
            (identical(other.remark, remark) || other.remark == remark) &&
            (identical(other.mrp, mrp) || other.mrp == mrp) &&
            (identical(other.refId, refId) || other.refId == refId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
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
    orderNo,
    dia,
    eye,
    sph,
    cyl,
    axis,
    add,
    qty,
    salePrice,
    discount,
    totalAmount,
    sellPrice,
    purchasePrice,
    combinationId,
    customer,
    vendor,
    itemStatus,
    remark,
    mrp,
    refId,
    createdAt,
  ]);

  /// Create a copy of RxOrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RxOrderItemImplCopyWith<_$RxOrderItemImpl> get copyWith =>
      __$$RxOrderItemImplCopyWithImpl<_$RxOrderItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RxOrderItemImplToJson(this);
  }
}

abstract class _RxOrderItem implements RxOrderItem {
  const factory _RxOrderItem({
    @JsonKey(name: '_id') final String? id,
    final String barcode,
    final String itemName,
    final String billItemName,
    final String vendorItemName,
    final String unit,
    final String orderNo,
    final String dia,
    final String eye,
    final double sph,
    final double cyl,
    final double axis,
    final double add,
    final int qty,
    final double salePrice,
    final double discount,
    final double totalAmount,
    final double sellPrice,
    final double purchasePrice,
    final String combinationId,
    final String customer,
    final String vendor,
    final String itemStatus,
    final String? remark,
    final double mrp,
    final String? refId,
    final String? createdAt,
  }) = _$RxOrderItemImpl;

  factory _RxOrderItem.fromJson(Map<String, dynamic> json) =
      _$RxOrderItemImpl.fromJson;

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
  String get orderNo;
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
  String get customer; // Patient Name
  @override
  String get vendor;
  @override
  String get itemStatus;
  @override
  String? get remark;
  @override
  double get mrp;
  @override
  String? get refId; // For Sale tracking back to Order
  @override
  String? get createdAt;

  /// Create a copy of RxOrderItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RxOrderItemImplCopyWith<_$RxOrderItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RxSaleOrderModel _$RxSaleOrderModelFromJson(Map<String, dynamic> json) {
  return _RxSaleOrderModel.fromJson(json);
}

/// @nodoc
mixin _$RxSaleOrderModel {
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
  String get orderType => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;
  String? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this RxSaleOrderModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RxSaleOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RxSaleOrderModelCopyWith<RxSaleOrderModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RxSaleOrderModelCopyWith<$Res> {
  factory $RxSaleOrderModelCopyWith(
    RxSaleOrderModel value,
    $Res Function(RxSaleOrderModel) then,
  ) = _$RxSaleOrderModelCopyWithImpl<$Res, RxSaleOrderModel>;
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
    String orderType,
    String? createdAt,
    String? updatedAt,
  });

  $SaleOrderBillDataCopyWith<$Res> get billData;
  $SaleOrderPartyDataCopyWith<$Res> get partyData;
}

/// @nodoc
class _$RxSaleOrderModelCopyWithImpl<$Res, $Val extends RxSaleOrderModel>
    implements $RxSaleOrderModelCopyWith<$Res> {
  _$RxSaleOrderModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RxSaleOrderModel
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
    Object? orderType = null,
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
            orderType: null == orderType
                ? _value.orderType
                : orderType // ignore: cast_nullable_to_non_nullable
                      as String,
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

  /// Create a copy of RxSaleOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SaleOrderBillDataCopyWith<$Res> get billData {
    return $SaleOrderBillDataCopyWith<$Res>(_value.billData, (value) {
      return _then(_value.copyWith(billData: value) as $Val);
    });
  }

  /// Create a copy of RxSaleOrderModel
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
abstract class _$$RxSaleOrderModelImplCopyWith<$Res>
    implements $RxSaleOrderModelCopyWith<$Res> {
  factory _$$RxSaleOrderModelImplCopyWith(
    _$RxSaleOrderModelImpl value,
    $Res Function(_$RxSaleOrderModelImpl) then,
  ) = __$$RxSaleOrderModelImplCopyWithImpl<$Res>;
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
    String orderType,
    String? createdAt,
    String? updatedAt,
  });

  @override
  $SaleOrderBillDataCopyWith<$Res> get billData;
  @override
  $SaleOrderPartyDataCopyWith<$Res> get partyData;
}

/// @nodoc
class __$$RxSaleOrderModelImplCopyWithImpl<$Res>
    extends _$RxSaleOrderModelCopyWithImpl<$Res, _$RxSaleOrderModelImpl>
    implements _$$RxSaleOrderModelImplCopyWith<$Res> {
  __$$RxSaleOrderModelImplCopyWithImpl(
    _$RxSaleOrderModelImpl _value,
    $Res Function(_$RxSaleOrderModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RxSaleOrderModel
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
    Object? orderType = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$RxSaleOrderModelImpl(
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
        orderType: null == orderType
            ? _value.orderType
            : orderType // ignore: cast_nullable_to_non_nullable
                  as String,
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
class _$RxSaleOrderModelImpl implements _RxSaleOrderModel {
  const _$RxSaleOrderModelImpl({
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
    this.status = 'Pending',
    this.orderType = 'RX',
    this.createdAt,
    this.updatedAt,
  }) : _items = items,
       _taxes = taxes;

  factory _$RxSaleOrderModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RxSaleOrderModelImplFromJson(json);

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
  final String orderType;
  @override
  final String? createdAt;
  @override
  final String? updatedAt;

  @override
  String toString() {
    return 'RxSaleOrderModel(id: $id, billData: $billData, partyData: $partyData, items: $items, taxes: $taxes, subtotal: $subtotal, taxesAmount: $taxesAmount, netAmount: $netAmount, paidAmount: $paidAmount, dueAmount: $dueAmount, remark: $remark, status: $status, orderType: $orderType, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RxSaleOrderModelImpl &&
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
            (identical(other.orderType, orderType) ||
                other.orderType == orderType) &&
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
    orderType,
    createdAt,
    updatedAt,
  );

  /// Create a copy of RxSaleOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RxSaleOrderModelImplCopyWith<_$RxSaleOrderModelImpl> get copyWith =>
      __$$RxSaleOrderModelImplCopyWithImpl<_$RxSaleOrderModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RxSaleOrderModelImplToJson(this);
  }
}

abstract class _RxSaleOrderModel implements RxSaleOrderModel {
  const factory _RxSaleOrderModel({
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
    final String orderType,
    final String? createdAt,
    final String? updatedAt,
  }) = _$RxSaleOrderModelImpl;

  factory _RxSaleOrderModel.fromJson(Map<String, dynamic> json) =
      _$RxSaleOrderModelImpl.fromJson;

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
  String get orderType;
  @override
  String? get createdAt;
  @override
  String? get updatedAt;

  /// Create a copy of RxSaleOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RxSaleOrderModelImplCopyWith<_$RxSaleOrderModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
