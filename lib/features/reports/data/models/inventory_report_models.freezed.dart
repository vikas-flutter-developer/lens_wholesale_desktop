// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_report_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LensMovementReportData _$LensMovementReportDataFromJson(
  Map<String, dynamic> json,
) {
  return _LensMovementReportData.fromJson(json);
}

/// @nodoc
mixin _$LensMovementReportData {
  bool get success => throw _privateConstructorUsedError;
  List<LensMovementItem> get purchaseData => throw _privateConstructorUsedError;
  List<LensMovementItem> get saleData => throw _privateConstructorUsedError;
  double get openingStock => throw _privateConstructorUsedError;
  double get closingStock => throw _privateConstructorUsedError;
  List<UnmovedItem> get unmovedItems => throw _privateConstructorUsedError;

  /// Serializes this LensMovementReportData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LensMovementReportData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LensMovementReportDataCopyWith<LensMovementReportData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LensMovementReportDataCopyWith<$Res> {
  factory $LensMovementReportDataCopyWith(
    LensMovementReportData value,
    $Res Function(LensMovementReportData) then,
  ) = _$LensMovementReportDataCopyWithImpl<$Res, LensMovementReportData>;
  @useResult
  $Res call({
    bool success,
    List<LensMovementItem> purchaseData,
    List<LensMovementItem> saleData,
    double openingStock,
    double closingStock,
    List<UnmovedItem> unmovedItems,
  });
}

/// @nodoc
class _$LensMovementReportDataCopyWithImpl<
  $Res,
  $Val extends LensMovementReportData
>
    implements $LensMovementReportDataCopyWith<$Res> {
  _$LensMovementReportDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LensMovementReportData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? purchaseData = null,
    Object? saleData = null,
    Object? openingStock = null,
    Object? closingStock = null,
    Object? unmovedItems = null,
  }) {
    return _then(
      _value.copyWith(
            success: null == success
                ? _value.success
                : success // ignore: cast_nullable_to_non_nullable
                      as bool,
            purchaseData: null == purchaseData
                ? _value.purchaseData
                : purchaseData // ignore: cast_nullable_to_non_nullable
                      as List<LensMovementItem>,
            saleData: null == saleData
                ? _value.saleData
                : saleData // ignore: cast_nullable_to_non_nullable
                      as List<LensMovementItem>,
            openingStock: null == openingStock
                ? _value.openingStock
                : openingStock // ignore: cast_nullable_to_non_nullable
                      as double,
            closingStock: null == closingStock
                ? _value.closingStock
                : closingStock // ignore: cast_nullable_to_non_nullable
                      as double,
            unmovedItems: null == unmovedItems
                ? _value.unmovedItems
                : unmovedItems // ignore: cast_nullable_to_non_nullable
                      as List<UnmovedItem>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LensMovementReportDataImplCopyWith<$Res>
    implements $LensMovementReportDataCopyWith<$Res> {
  factory _$$LensMovementReportDataImplCopyWith(
    _$LensMovementReportDataImpl value,
    $Res Function(_$LensMovementReportDataImpl) then,
  ) = __$$LensMovementReportDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool success,
    List<LensMovementItem> purchaseData,
    List<LensMovementItem> saleData,
    double openingStock,
    double closingStock,
    List<UnmovedItem> unmovedItems,
  });
}

/// @nodoc
class __$$LensMovementReportDataImplCopyWithImpl<$Res>
    extends
        _$LensMovementReportDataCopyWithImpl<$Res, _$LensMovementReportDataImpl>
    implements _$$LensMovementReportDataImplCopyWith<$Res> {
  __$$LensMovementReportDataImplCopyWithImpl(
    _$LensMovementReportDataImpl _value,
    $Res Function(_$LensMovementReportDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LensMovementReportData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? purchaseData = null,
    Object? saleData = null,
    Object? openingStock = null,
    Object? closingStock = null,
    Object? unmovedItems = null,
  }) {
    return _then(
      _$LensMovementReportDataImpl(
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        purchaseData: null == purchaseData
            ? _value._purchaseData
            : purchaseData // ignore: cast_nullable_to_non_nullable
                  as List<LensMovementItem>,
        saleData: null == saleData
            ? _value._saleData
            : saleData // ignore: cast_nullable_to_non_nullable
                  as List<LensMovementItem>,
        openingStock: null == openingStock
            ? _value.openingStock
            : openingStock // ignore: cast_nullable_to_non_nullable
                  as double,
        closingStock: null == closingStock
            ? _value.closingStock
            : closingStock // ignore: cast_nullable_to_non_nullable
                  as double,
        unmovedItems: null == unmovedItems
            ? _value._unmovedItems
            : unmovedItems // ignore: cast_nullable_to_non_nullable
                  as List<UnmovedItem>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LensMovementReportDataImpl implements _LensMovementReportData {
  const _$LensMovementReportDataImpl({
    required this.success,
    required final List<LensMovementItem> purchaseData,
    required final List<LensMovementItem> saleData,
    this.openingStock = 0,
    this.closingStock = 0,
    final List<UnmovedItem> unmovedItems = const [],
  }) : _purchaseData = purchaseData,
       _saleData = saleData,
       _unmovedItems = unmovedItems;

  factory _$LensMovementReportDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$LensMovementReportDataImplFromJson(json);

  @override
  final bool success;
  final List<LensMovementItem> _purchaseData;
  @override
  List<LensMovementItem> get purchaseData {
    if (_purchaseData is EqualUnmodifiableListView) return _purchaseData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_purchaseData);
  }

  final List<LensMovementItem> _saleData;
  @override
  List<LensMovementItem> get saleData {
    if (_saleData is EqualUnmodifiableListView) return _saleData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_saleData);
  }

  @override
  @JsonKey()
  final double openingStock;
  @override
  @JsonKey()
  final double closingStock;
  final List<UnmovedItem> _unmovedItems;
  @override
  @JsonKey()
  List<UnmovedItem> get unmovedItems {
    if (_unmovedItems is EqualUnmodifiableListView) return _unmovedItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_unmovedItems);
  }

  @override
  String toString() {
    return 'LensMovementReportData(success: $success, purchaseData: $purchaseData, saleData: $saleData, openingStock: $openingStock, closingStock: $closingStock, unmovedItems: $unmovedItems)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LensMovementReportDataImpl &&
            (identical(other.success, success) || other.success == success) &&
            const DeepCollectionEquality().equals(
              other._purchaseData,
              _purchaseData,
            ) &&
            const DeepCollectionEquality().equals(other._saleData, _saleData) &&
            (identical(other.openingStock, openingStock) ||
                other.openingStock == openingStock) &&
            (identical(other.closingStock, closingStock) ||
                other.closingStock == closingStock) &&
            const DeepCollectionEquality().equals(
              other._unmovedItems,
              _unmovedItems,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    success,
    const DeepCollectionEquality().hash(_purchaseData),
    const DeepCollectionEquality().hash(_saleData),
    openingStock,
    closingStock,
    const DeepCollectionEquality().hash(_unmovedItems),
  );

  /// Create a copy of LensMovementReportData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LensMovementReportDataImplCopyWith<_$LensMovementReportDataImpl>
  get copyWith =>
      __$$LensMovementReportDataImplCopyWithImpl<_$LensMovementReportDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LensMovementReportDataImplToJson(this);
  }
}

abstract class _LensMovementReportData implements LensMovementReportData {
  const factory _LensMovementReportData({
    required final bool success,
    required final List<LensMovementItem> purchaseData,
    required final List<LensMovementItem> saleData,
    final double openingStock,
    final double closingStock,
    final List<UnmovedItem> unmovedItems,
  }) = _$LensMovementReportDataImpl;

  factory _LensMovementReportData.fromJson(Map<String, dynamic> json) =
      _$LensMovementReportDataImpl.fromJson;

  @override
  bool get success;
  @override
  List<LensMovementItem> get purchaseData;
  @override
  List<LensMovementItem> get saleData;
  @override
  double get openingStock;
  @override
  double get closingStock;
  @override
  List<UnmovedItem> get unmovedItems;

  /// Create a copy of LensMovementReportData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LensMovementReportDataImplCopyWith<_$LensMovementReportDataImpl>
  get copyWith => throw _privateConstructorUsedError;
}

LensMovementItem _$LensMovementItemFromJson(Map<String, dynamic> json) {
  return _LensMovementItem.fromJson(json);
}

/// @nodoc
mixin _$LensMovementItem {
  String? get date => throw _privateConstructorUsedError;
  String? get transType => throw _privateConstructorUsedError;
  String? get voucherNo => throw _privateConstructorUsedError;
  String? get partyName => throw _privateConstructorUsedError;
  String? get groupName => throw _privateConstructorUsedError;
  String? get group => throw _privateConstructorUsedError;
  String get itemName => throw _privateConstructorUsedError;
  String? get barcode => throw _privateConstructorUsedError;
  String? get barCode => throw _privateConstructorUsedError;
  String? get eye => throw _privateConstructorUsedError;
  dynamic get sph => throw _privateConstructorUsedError;
  dynamic get cyl => throw _privateConstructorUsedError;
  dynamic get axis => throw _privateConstructorUsedError;
  dynamic get add => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;
  double? get price => throw _privateConstructorUsedError;
  String? get unit => throw _privateConstructorUsedError;
  String? get docId =>
      throw _privateConstructorUsedError; // Calculated fields for processed data
  double get opening => throw _privateConstructorUsedError;
  double get inwardQty => throw _privateConstructorUsedError;
  double get inwardValue => throw _privateConstructorUsedError;
  double get outwardQty => throw _privateConstructorUsedError;
  double get outwardValue => throw _privateConstructorUsedError;
  double get closing => throw _privateConstructorUsedError;
  String? get mType => throw _privateConstructorUsedError;

  /// Serializes this LensMovementItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LensMovementItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LensMovementItemCopyWith<LensMovementItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LensMovementItemCopyWith<$Res> {
  factory $LensMovementItemCopyWith(
    LensMovementItem value,
    $Res Function(LensMovementItem) then,
  ) = _$LensMovementItemCopyWithImpl<$Res, LensMovementItem>;
  @useResult
  $Res call({
    String? date,
    String? transType,
    String? voucherNo,
    String? partyName,
    String? groupName,
    String? group,
    String itemName,
    String? barcode,
    String? barCode,
    String? eye,
    dynamic sph,
    dynamic cyl,
    dynamic axis,
    dynamic add,
    double quantity,
    double? price,
    String? unit,
    String? docId,
    double opening,
    double inwardQty,
    double inwardValue,
    double outwardQty,
    double outwardValue,
    double closing,
    String? mType,
  });
}

/// @nodoc
class _$LensMovementItemCopyWithImpl<$Res, $Val extends LensMovementItem>
    implements $LensMovementItemCopyWith<$Res> {
  _$LensMovementItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LensMovementItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = freezed,
    Object? transType = freezed,
    Object? voucherNo = freezed,
    Object? partyName = freezed,
    Object? groupName = freezed,
    Object? group = freezed,
    Object? itemName = null,
    Object? barcode = freezed,
    Object? barCode = freezed,
    Object? eye = freezed,
    Object? sph = freezed,
    Object? cyl = freezed,
    Object? axis = freezed,
    Object? add = freezed,
    Object? quantity = null,
    Object? price = freezed,
    Object? unit = freezed,
    Object? docId = freezed,
    Object? opening = null,
    Object? inwardQty = null,
    Object? inwardValue = null,
    Object? outwardQty = null,
    Object? outwardValue = null,
    Object? closing = null,
    Object? mType = freezed,
  }) {
    return _then(
      _value.copyWith(
            date: freezed == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String?,
            transType: freezed == transType
                ? _value.transType
                : transType // ignore: cast_nullable_to_non_nullable
                      as String?,
            voucherNo: freezed == voucherNo
                ? _value.voucherNo
                : voucherNo // ignore: cast_nullable_to_non_nullable
                      as String?,
            partyName: freezed == partyName
                ? _value.partyName
                : partyName // ignore: cast_nullable_to_non_nullable
                      as String?,
            groupName: freezed == groupName
                ? _value.groupName
                : groupName // ignore: cast_nullable_to_non_nullable
                      as String?,
            group: freezed == group
                ? _value.group
                : group // ignore: cast_nullable_to_non_nullable
                      as String?,
            itemName: null == itemName
                ? _value.itemName
                : itemName // ignore: cast_nullable_to_non_nullable
                      as String,
            barcode: freezed == barcode
                ? _value.barcode
                : barcode // ignore: cast_nullable_to_non_nullable
                      as String?,
            barCode: freezed == barCode
                ? _value.barCode
                : barCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            eye: freezed == eye
                ? _value.eye
                : eye // ignore: cast_nullable_to_non_nullable
                      as String?,
            sph: freezed == sph
                ? _value.sph
                : sph // ignore: cast_nullable_to_non_nullable
                      as dynamic,
            cyl: freezed == cyl
                ? _value.cyl
                : cyl // ignore: cast_nullable_to_non_nullable
                      as dynamic,
            axis: freezed == axis
                ? _value.axis
                : axis // ignore: cast_nullable_to_non_nullable
                      as dynamic,
            add: freezed == add
                ? _value.add
                : add // ignore: cast_nullable_to_non_nullable
                      as dynamic,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as double,
            price: freezed == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double?,
            unit: freezed == unit
                ? _value.unit
                : unit // ignore: cast_nullable_to_non_nullable
                      as String?,
            docId: freezed == docId
                ? _value.docId
                : docId // ignore: cast_nullable_to_non_nullable
                      as String?,
            opening: null == opening
                ? _value.opening
                : opening // ignore: cast_nullable_to_non_nullable
                      as double,
            inwardQty: null == inwardQty
                ? _value.inwardQty
                : inwardQty // ignore: cast_nullable_to_non_nullable
                      as double,
            inwardValue: null == inwardValue
                ? _value.inwardValue
                : inwardValue // ignore: cast_nullable_to_non_nullable
                      as double,
            outwardQty: null == outwardQty
                ? _value.outwardQty
                : outwardQty // ignore: cast_nullable_to_non_nullable
                      as double,
            outwardValue: null == outwardValue
                ? _value.outwardValue
                : outwardValue // ignore: cast_nullable_to_non_nullable
                      as double,
            closing: null == closing
                ? _value.closing
                : closing // ignore: cast_nullable_to_non_nullable
                      as double,
            mType: freezed == mType
                ? _value.mType
                : mType // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LensMovementItemImplCopyWith<$Res>
    implements $LensMovementItemCopyWith<$Res> {
  factory _$$LensMovementItemImplCopyWith(
    _$LensMovementItemImpl value,
    $Res Function(_$LensMovementItemImpl) then,
  ) = __$$LensMovementItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? date,
    String? transType,
    String? voucherNo,
    String? partyName,
    String? groupName,
    String? group,
    String itemName,
    String? barcode,
    String? barCode,
    String? eye,
    dynamic sph,
    dynamic cyl,
    dynamic axis,
    dynamic add,
    double quantity,
    double? price,
    String? unit,
    String? docId,
    double opening,
    double inwardQty,
    double inwardValue,
    double outwardQty,
    double outwardValue,
    double closing,
    String? mType,
  });
}

/// @nodoc
class __$$LensMovementItemImplCopyWithImpl<$Res>
    extends _$LensMovementItemCopyWithImpl<$Res, _$LensMovementItemImpl>
    implements _$$LensMovementItemImplCopyWith<$Res> {
  __$$LensMovementItemImplCopyWithImpl(
    _$LensMovementItemImpl _value,
    $Res Function(_$LensMovementItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LensMovementItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = freezed,
    Object? transType = freezed,
    Object? voucherNo = freezed,
    Object? partyName = freezed,
    Object? groupName = freezed,
    Object? group = freezed,
    Object? itemName = null,
    Object? barcode = freezed,
    Object? barCode = freezed,
    Object? eye = freezed,
    Object? sph = freezed,
    Object? cyl = freezed,
    Object? axis = freezed,
    Object? add = freezed,
    Object? quantity = null,
    Object? price = freezed,
    Object? unit = freezed,
    Object? docId = freezed,
    Object? opening = null,
    Object? inwardQty = null,
    Object? inwardValue = null,
    Object? outwardQty = null,
    Object? outwardValue = null,
    Object? closing = null,
    Object? mType = freezed,
  }) {
    return _then(
      _$LensMovementItemImpl(
        date: freezed == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String?,
        transType: freezed == transType
            ? _value.transType
            : transType // ignore: cast_nullable_to_non_nullable
                  as String?,
        voucherNo: freezed == voucherNo
            ? _value.voucherNo
            : voucherNo // ignore: cast_nullable_to_non_nullable
                  as String?,
        partyName: freezed == partyName
            ? _value.partyName
            : partyName // ignore: cast_nullable_to_non_nullable
                  as String?,
        groupName: freezed == groupName
            ? _value.groupName
            : groupName // ignore: cast_nullable_to_non_nullable
                  as String?,
        group: freezed == group
            ? _value.group
            : group // ignore: cast_nullable_to_non_nullable
                  as String?,
        itemName: null == itemName
            ? _value.itemName
            : itemName // ignore: cast_nullable_to_non_nullable
                  as String,
        barcode: freezed == barcode
            ? _value.barcode
            : barcode // ignore: cast_nullable_to_non_nullable
                  as String?,
        barCode: freezed == barCode
            ? _value.barCode
            : barCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        eye: freezed == eye
            ? _value.eye
            : eye // ignore: cast_nullable_to_non_nullable
                  as String?,
        sph: freezed == sph
            ? _value.sph
            : sph // ignore: cast_nullable_to_non_nullable
                  as dynamic,
        cyl: freezed == cyl
            ? _value.cyl
            : cyl // ignore: cast_nullable_to_non_nullable
                  as dynamic,
        axis: freezed == axis
            ? _value.axis
            : axis // ignore: cast_nullable_to_non_nullable
                  as dynamic,
        add: freezed == add
            ? _value.add
            : add // ignore: cast_nullable_to_non_nullable
                  as dynamic,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as double,
        price: freezed == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double?,
        unit: freezed == unit
            ? _value.unit
            : unit // ignore: cast_nullable_to_non_nullable
                  as String?,
        docId: freezed == docId
            ? _value.docId
            : docId // ignore: cast_nullable_to_non_nullable
                  as String?,
        opening: null == opening
            ? _value.opening
            : opening // ignore: cast_nullable_to_non_nullable
                  as double,
        inwardQty: null == inwardQty
            ? _value.inwardQty
            : inwardQty // ignore: cast_nullable_to_non_nullable
                  as double,
        inwardValue: null == inwardValue
            ? _value.inwardValue
            : inwardValue // ignore: cast_nullable_to_non_nullable
                  as double,
        outwardQty: null == outwardQty
            ? _value.outwardQty
            : outwardQty // ignore: cast_nullable_to_non_nullable
                  as double,
        outwardValue: null == outwardValue
            ? _value.outwardValue
            : outwardValue // ignore: cast_nullable_to_non_nullable
                  as double,
        closing: null == closing
            ? _value.closing
            : closing // ignore: cast_nullable_to_non_nullable
                  as double,
        mType: freezed == mType
            ? _value.mType
            : mType // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LensMovementItemImpl implements _LensMovementItem {
  const _$LensMovementItemImpl({
    this.date,
    this.transType,
    this.voucherNo,
    this.partyName,
    this.groupName,
    this.group,
    required this.itemName,
    this.barcode,
    this.barCode,
    this.eye,
    this.sph,
    this.cyl,
    this.axis,
    this.add,
    this.quantity = 0,
    this.price,
    this.unit,
    this.docId,
    this.opening = 0,
    this.inwardQty = 0,
    this.inwardValue = 0,
    this.outwardQty = 0,
    this.outwardValue = 0,
    this.closing = 0,
    this.mType,
  });

  factory _$LensMovementItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$LensMovementItemImplFromJson(json);

  @override
  final String? date;
  @override
  final String? transType;
  @override
  final String? voucherNo;
  @override
  final String? partyName;
  @override
  final String? groupName;
  @override
  final String? group;
  @override
  final String itemName;
  @override
  final String? barcode;
  @override
  final String? barCode;
  @override
  final String? eye;
  @override
  final dynamic sph;
  @override
  final dynamic cyl;
  @override
  final dynamic axis;
  @override
  final dynamic add;
  @override
  @JsonKey()
  final double quantity;
  @override
  final double? price;
  @override
  final String? unit;
  @override
  final String? docId;
  // Calculated fields for processed data
  @override
  @JsonKey()
  final double opening;
  @override
  @JsonKey()
  final double inwardQty;
  @override
  @JsonKey()
  final double inwardValue;
  @override
  @JsonKey()
  final double outwardQty;
  @override
  @JsonKey()
  final double outwardValue;
  @override
  @JsonKey()
  final double closing;
  @override
  final String? mType;

  @override
  String toString() {
    return 'LensMovementItem(date: $date, transType: $transType, voucherNo: $voucherNo, partyName: $partyName, groupName: $groupName, group: $group, itemName: $itemName, barcode: $barcode, barCode: $barCode, eye: $eye, sph: $sph, cyl: $cyl, axis: $axis, add: $add, quantity: $quantity, price: $price, unit: $unit, docId: $docId, opening: $opening, inwardQty: $inwardQty, inwardValue: $inwardValue, outwardQty: $outwardQty, outwardValue: $outwardValue, closing: $closing, mType: $mType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LensMovementItemImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.transType, transType) ||
                other.transType == transType) &&
            (identical(other.voucherNo, voucherNo) ||
                other.voucherNo == voucherNo) &&
            (identical(other.partyName, partyName) ||
                other.partyName == partyName) &&
            (identical(other.groupName, groupName) ||
                other.groupName == groupName) &&
            (identical(other.group, group) || other.group == group) &&
            (identical(other.itemName, itemName) ||
                other.itemName == itemName) &&
            (identical(other.barcode, barcode) || other.barcode == barcode) &&
            (identical(other.barCode, barCode) || other.barCode == barCode) &&
            (identical(other.eye, eye) || other.eye == eye) &&
            const DeepCollectionEquality().equals(other.sph, sph) &&
            const DeepCollectionEquality().equals(other.cyl, cyl) &&
            const DeepCollectionEquality().equals(other.axis, axis) &&
            const DeepCollectionEquality().equals(other.add, add) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.docId, docId) || other.docId == docId) &&
            (identical(other.opening, opening) || other.opening == opening) &&
            (identical(other.inwardQty, inwardQty) ||
                other.inwardQty == inwardQty) &&
            (identical(other.inwardValue, inwardValue) ||
                other.inwardValue == inwardValue) &&
            (identical(other.outwardQty, outwardQty) ||
                other.outwardQty == outwardQty) &&
            (identical(other.outwardValue, outwardValue) ||
                other.outwardValue == outwardValue) &&
            (identical(other.closing, closing) || other.closing == closing) &&
            (identical(other.mType, mType) || other.mType == mType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    date,
    transType,
    voucherNo,
    partyName,
    groupName,
    group,
    itemName,
    barcode,
    barCode,
    eye,
    const DeepCollectionEquality().hash(sph),
    const DeepCollectionEquality().hash(cyl),
    const DeepCollectionEquality().hash(axis),
    const DeepCollectionEquality().hash(add),
    quantity,
    price,
    unit,
    docId,
    opening,
    inwardQty,
    inwardValue,
    outwardQty,
    outwardValue,
    closing,
    mType,
  ]);

  /// Create a copy of LensMovementItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LensMovementItemImplCopyWith<_$LensMovementItemImpl> get copyWith =>
      __$$LensMovementItemImplCopyWithImpl<_$LensMovementItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LensMovementItemImplToJson(this);
  }
}

abstract class _LensMovementItem implements LensMovementItem {
  const factory _LensMovementItem({
    final String? date,
    final String? transType,
    final String? voucherNo,
    final String? partyName,
    final String? groupName,
    final String? group,
    required final String itemName,
    final String? barcode,
    final String? barCode,
    final String? eye,
    final dynamic sph,
    final dynamic cyl,
    final dynamic axis,
    final dynamic add,
    final double quantity,
    final double? price,
    final String? unit,
    final String? docId,
    final double opening,
    final double inwardQty,
    final double inwardValue,
    final double outwardQty,
    final double outwardValue,
    final double closing,
    final String? mType,
  }) = _$LensMovementItemImpl;

  factory _LensMovementItem.fromJson(Map<String, dynamic> json) =
      _$LensMovementItemImpl.fromJson;

  @override
  String? get date;
  @override
  String? get transType;
  @override
  String? get voucherNo;
  @override
  String? get partyName;
  @override
  String? get groupName;
  @override
  String? get group;
  @override
  String get itemName;
  @override
  String? get barcode;
  @override
  String? get barCode;
  @override
  String? get eye;
  @override
  dynamic get sph;
  @override
  dynamic get cyl;
  @override
  dynamic get axis;
  @override
  dynamic get add;
  @override
  double get quantity;
  @override
  double? get price;
  @override
  String? get unit;
  @override
  String? get docId; // Calculated fields for processed data
  @override
  double get opening;
  @override
  double get inwardQty;
  @override
  double get inwardValue;
  @override
  double get outwardQty;
  @override
  double get outwardValue;
  @override
  double get closing;
  @override
  String? get mType;

  /// Create a copy of LensMovementItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LensMovementItemImplCopyWith<_$LensMovementItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UnmovedItem _$UnmovedItemFromJson(Map<String, dynamic> json) {
  return _UnmovedItem.fromJson(json);
}

/// @nodoc
mixin _$UnmovedItem {
  String? get groupName => throw _privateConstructorUsedError;
  String? get group => throw _privateConstructorUsedError;
  String? get productName => throw _privateConstructorUsedError;
  String? get itemName => throw _privateConstructorUsedError;
  String? get barcode => throw _privateConstructorUsedError;
  String? get eye => throw _privateConstructorUsedError;
  dynamic get sph => throw _privateConstructorUsedError;
  dynamic get cyl => throw _privateConstructorUsedError;
  dynamic get axis => throw _privateConstructorUsedError;
  dynamic get add => throw _privateConstructorUsedError;
  double get currentStock => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  String? get unit => throw _privateConstructorUsedError;

  /// Serializes this UnmovedItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UnmovedItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UnmovedItemCopyWith<UnmovedItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UnmovedItemCopyWith<$Res> {
  factory $UnmovedItemCopyWith(
    UnmovedItem value,
    $Res Function(UnmovedItem) then,
  ) = _$UnmovedItemCopyWithImpl<$Res, UnmovedItem>;
  @useResult
  $Res call({
    String? groupName,
    String? group,
    String? productName,
    String? itemName,
    String? barcode,
    String? eye,
    dynamic sph,
    dynamic cyl,
    dynamic axis,
    dynamic add,
    double currentStock,
    double price,
    String? unit,
  });
}

/// @nodoc
class _$UnmovedItemCopyWithImpl<$Res, $Val extends UnmovedItem>
    implements $UnmovedItemCopyWith<$Res> {
  _$UnmovedItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UnmovedItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupName = freezed,
    Object? group = freezed,
    Object? productName = freezed,
    Object? itemName = freezed,
    Object? barcode = freezed,
    Object? eye = freezed,
    Object? sph = freezed,
    Object? cyl = freezed,
    Object? axis = freezed,
    Object? add = freezed,
    Object? currentStock = null,
    Object? price = null,
    Object? unit = freezed,
  }) {
    return _then(
      _value.copyWith(
            groupName: freezed == groupName
                ? _value.groupName
                : groupName // ignore: cast_nullable_to_non_nullable
                      as String?,
            group: freezed == group
                ? _value.group
                : group // ignore: cast_nullable_to_non_nullable
                      as String?,
            productName: freezed == productName
                ? _value.productName
                : productName // ignore: cast_nullable_to_non_nullable
                      as String?,
            itemName: freezed == itemName
                ? _value.itemName
                : itemName // ignore: cast_nullable_to_non_nullable
                      as String?,
            barcode: freezed == barcode
                ? _value.barcode
                : barcode // ignore: cast_nullable_to_non_nullable
                      as String?,
            eye: freezed == eye
                ? _value.eye
                : eye // ignore: cast_nullable_to_non_nullable
                      as String?,
            sph: freezed == sph
                ? _value.sph
                : sph // ignore: cast_nullable_to_non_nullable
                      as dynamic,
            cyl: freezed == cyl
                ? _value.cyl
                : cyl // ignore: cast_nullable_to_non_nullable
                      as dynamic,
            axis: freezed == axis
                ? _value.axis
                : axis // ignore: cast_nullable_to_non_nullable
                      as dynamic,
            add: freezed == add
                ? _value.add
                : add // ignore: cast_nullable_to_non_nullable
                      as dynamic,
            currentStock: null == currentStock
                ? _value.currentStock
                : currentStock // ignore: cast_nullable_to_non_nullable
                      as double,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            unit: freezed == unit
                ? _value.unit
                : unit // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UnmovedItemImplCopyWith<$Res>
    implements $UnmovedItemCopyWith<$Res> {
  factory _$$UnmovedItemImplCopyWith(
    _$UnmovedItemImpl value,
    $Res Function(_$UnmovedItemImpl) then,
  ) = __$$UnmovedItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? groupName,
    String? group,
    String? productName,
    String? itemName,
    String? barcode,
    String? eye,
    dynamic sph,
    dynamic cyl,
    dynamic axis,
    dynamic add,
    double currentStock,
    double price,
    String? unit,
  });
}

/// @nodoc
class __$$UnmovedItemImplCopyWithImpl<$Res>
    extends _$UnmovedItemCopyWithImpl<$Res, _$UnmovedItemImpl>
    implements _$$UnmovedItemImplCopyWith<$Res> {
  __$$UnmovedItemImplCopyWithImpl(
    _$UnmovedItemImpl _value,
    $Res Function(_$UnmovedItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UnmovedItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupName = freezed,
    Object? group = freezed,
    Object? productName = freezed,
    Object? itemName = freezed,
    Object? barcode = freezed,
    Object? eye = freezed,
    Object? sph = freezed,
    Object? cyl = freezed,
    Object? axis = freezed,
    Object? add = freezed,
    Object? currentStock = null,
    Object? price = null,
    Object? unit = freezed,
  }) {
    return _then(
      _$UnmovedItemImpl(
        groupName: freezed == groupName
            ? _value.groupName
            : groupName // ignore: cast_nullable_to_non_nullable
                  as String?,
        group: freezed == group
            ? _value.group
            : group // ignore: cast_nullable_to_non_nullable
                  as String?,
        productName: freezed == productName
            ? _value.productName
            : productName // ignore: cast_nullable_to_non_nullable
                  as String?,
        itemName: freezed == itemName
            ? _value.itemName
            : itemName // ignore: cast_nullable_to_non_nullable
                  as String?,
        barcode: freezed == barcode
            ? _value.barcode
            : barcode // ignore: cast_nullable_to_non_nullable
                  as String?,
        eye: freezed == eye
            ? _value.eye
            : eye // ignore: cast_nullable_to_non_nullable
                  as String?,
        sph: freezed == sph
            ? _value.sph
            : sph // ignore: cast_nullable_to_non_nullable
                  as dynamic,
        cyl: freezed == cyl
            ? _value.cyl
            : cyl // ignore: cast_nullable_to_non_nullable
                  as dynamic,
        axis: freezed == axis
            ? _value.axis
            : axis // ignore: cast_nullable_to_non_nullable
                  as dynamic,
        add: freezed == add
            ? _value.add
            : add // ignore: cast_nullable_to_non_nullable
                  as dynamic,
        currentStock: null == currentStock
            ? _value.currentStock
            : currentStock // ignore: cast_nullable_to_non_nullable
                  as double,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        unit: freezed == unit
            ? _value.unit
            : unit // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UnmovedItemImpl implements _UnmovedItem {
  const _$UnmovedItemImpl({
    this.groupName,
    this.group,
    this.productName,
    this.itemName,
    this.barcode,
    this.eye,
    this.sph,
    this.cyl,
    this.axis,
    this.add,
    this.currentStock = 0,
    this.price = 0,
    this.unit,
  });

  factory _$UnmovedItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$UnmovedItemImplFromJson(json);

  @override
  final String? groupName;
  @override
  final String? group;
  @override
  final String? productName;
  @override
  final String? itemName;
  @override
  final String? barcode;
  @override
  final String? eye;
  @override
  final dynamic sph;
  @override
  final dynamic cyl;
  @override
  final dynamic axis;
  @override
  final dynamic add;
  @override
  @JsonKey()
  final double currentStock;
  @override
  @JsonKey()
  final double price;
  @override
  final String? unit;

  @override
  String toString() {
    return 'UnmovedItem(groupName: $groupName, group: $group, productName: $productName, itemName: $itemName, barcode: $barcode, eye: $eye, sph: $sph, cyl: $cyl, axis: $axis, add: $add, currentStock: $currentStock, price: $price, unit: $unit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnmovedItemImpl &&
            (identical(other.groupName, groupName) ||
                other.groupName == groupName) &&
            (identical(other.group, group) || other.group == group) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.itemName, itemName) ||
                other.itemName == itemName) &&
            (identical(other.barcode, barcode) || other.barcode == barcode) &&
            (identical(other.eye, eye) || other.eye == eye) &&
            const DeepCollectionEquality().equals(other.sph, sph) &&
            const DeepCollectionEquality().equals(other.cyl, cyl) &&
            const DeepCollectionEquality().equals(other.axis, axis) &&
            const DeepCollectionEquality().equals(other.add, add) &&
            (identical(other.currentStock, currentStock) ||
                other.currentStock == currentStock) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.unit, unit) || other.unit == unit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    groupName,
    group,
    productName,
    itemName,
    barcode,
    eye,
    const DeepCollectionEquality().hash(sph),
    const DeepCollectionEquality().hash(cyl),
    const DeepCollectionEquality().hash(axis),
    const DeepCollectionEquality().hash(add),
    currentStock,
    price,
    unit,
  );

  /// Create a copy of UnmovedItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnmovedItemImplCopyWith<_$UnmovedItemImpl> get copyWith =>
      __$$UnmovedItemImplCopyWithImpl<_$UnmovedItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UnmovedItemImplToJson(this);
  }
}

abstract class _UnmovedItem implements UnmovedItem {
  const factory _UnmovedItem({
    final String? groupName,
    final String? group,
    final String? productName,
    final String? itemName,
    final String? barcode,
    final String? eye,
    final dynamic sph,
    final dynamic cyl,
    final dynamic axis,
    final dynamic add,
    final double currentStock,
    final double price,
    final String? unit,
  }) = _$UnmovedItemImpl;

  factory _UnmovedItem.fromJson(Map<String, dynamic> json) =
      _$UnmovedItemImpl.fromJson;

  @override
  String? get groupName;
  @override
  String? get group;
  @override
  String? get productName;
  @override
  String? get itemName;
  @override
  String? get barcode;
  @override
  String? get eye;
  @override
  dynamic get sph;
  @override
  dynamic get cyl;
  @override
  dynamic get axis;
  @override
  dynamic get add;
  @override
  double get currentStock;
  @override
  double get price;
  @override
  String? get unit;

  /// Create a copy of UnmovedItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnmovedItemImplCopyWith<_$UnmovedItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PowerMovementReportData _$PowerMovementReportDataFromJson(
  Map<String, dynamic> json,
) {
  return _PowerMovementReportData.fromJson(json);
}

/// @nodoc
mixin _$PowerMovementReportData {
  bool get success => throw _privateConstructorUsedError;
  List<PowerMovementItem> get data => throw _privateConstructorUsedError;
  PowerMovementAnalytics get analytics => throw _privateConstructorUsedError;

  /// Serializes this PowerMovementReportData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PowerMovementReportData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PowerMovementReportDataCopyWith<PowerMovementReportData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PowerMovementReportDataCopyWith<$Res> {
  factory $PowerMovementReportDataCopyWith(
    PowerMovementReportData value,
    $Res Function(PowerMovementReportData) then,
  ) = _$PowerMovementReportDataCopyWithImpl<$Res, PowerMovementReportData>;
  @useResult
  $Res call({
    bool success,
    List<PowerMovementItem> data,
    PowerMovementAnalytics analytics,
  });

  $PowerMovementAnalyticsCopyWith<$Res> get analytics;
}

/// @nodoc
class _$PowerMovementReportDataCopyWithImpl<
  $Res,
  $Val extends PowerMovementReportData
>
    implements $PowerMovementReportDataCopyWith<$Res> {
  _$PowerMovementReportDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PowerMovementReportData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = null,
    Object? analytics = null,
  }) {
    return _then(
      _value.copyWith(
            success: null == success
                ? _value.success
                : success // ignore: cast_nullable_to_non_nullable
                      as bool,
            data: null == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as List<PowerMovementItem>,
            analytics: null == analytics
                ? _value.analytics
                : analytics // ignore: cast_nullable_to_non_nullable
                      as PowerMovementAnalytics,
          )
          as $Val,
    );
  }

  /// Create a copy of PowerMovementReportData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PowerMovementAnalyticsCopyWith<$Res> get analytics {
    return $PowerMovementAnalyticsCopyWith<$Res>(_value.analytics, (value) {
      return _then(_value.copyWith(analytics: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PowerMovementReportDataImplCopyWith<$Res>
    implements $PowerMovementReportDataCopyWith<$Res> {
  factory _$$PowerMovementReportDataImplCopyWith(
    _$PowerMovementReportDataImpl value,
    $Res Function(_$PowerMovementReportDataImpl) then,
  ) = __$$PowerMovementReportDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool success,
    List<PowerMovementItem> data,
    PowerMovementAnalytics analytics,
  });

  @override
  $PowerMovementAnalyticsCopyWith<$Res> get analytics;
}

/// @nodoc
class __$$PowerMovementReportDataImplCopyWithImpl<$Res>
    extends
        _$PowerMovementReportDataCopyWithImpl<
          $Res,
          _$PowerMovementReportDataImpl
        >
    implements _$$PowerMovementReportDataImplCopyWith<$Res> {
  __$$PowerMovementReportDataImplCopyWithImpl(
    _$PowerMovementReportDataImpl _value,
    $Res Function(_$PowerMovementReportDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PowerMovementReportData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = null,
    Object? analytics = null,
  }) {
    return _then(
      _$PowerMovementReportDataImpl(
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        data: null == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as List<PowerMovementItem>,
        analytics: null == analytics
            ? _value.analytics
            : analytics // ignore: cast_nullable_to_non_nullable
                  as PowerMovementAnalytics,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PowerMovementReportDataImpl implements _PowerMovementReportData {
  const _$PowerMovementReportDataImpl({
    required this.success,
    required final List<PowerMovementItem> data,
    required this.analytics,
  }) : _data = data;

  factory _$PowerMovementReportDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$PowerMovementReportDataImplFromJson(json);

  @override
  final bool success;
  final List<PowerMovementItem> _data;
  @override
  List<PowerMovementItem> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final PowerMovementAnalytics analytics;

  @override
  String toString() {
    return 'PowerMovementReportData(success: $success, data: $data, analytics: $analytics)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PowerMovementReportDataImpl &&
            (identical(other.success, success) || other.success == success) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.analytics, analytics) ||
                other.analytics == analytics));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    success,
    const DeepCollectionEquality().hash(_data),
    analytics,
  );

  /// Create a copy of PowerMovementReportData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PowerMovementReportDataImplCopyWith<_$PowerMovementReportDataImpl>
  get copyWith =>
      __$$PowerMovementReportDataImplCopyWithImpl<
        _$PowerMovementReportDataImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PowerMovementReportDataImplToJson(this);
  }
}

abstract class _PowerMovementReportData implements PowerMovementReportData {
  const factory _PowerMovementReportData({
    required final bool success,
    required final List<PowerMovementItem> data,
    required final PowerMovementAnalytics analytics,
  }) = _$PowerMovementReportDataImpl;

  factory _PowerMovementReportData.fromJson(Map<String, dynamic> json) =
      _$PowerMovementReportDataImpl.fromJson;

  @override
  bool get success;
  @override
  List<PowerMovementItem> get data;
  @override
  PowerMovementAnalytics get analytics;

  /// Create a copy of PowerMovementReportData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PowerMovementReportDataImplCopyWith<_$PowerMovementReportDataImpl>
  get copyWith => throw _privateConstructorUsedError;
}

PowerMovementItem _$PowerMovementItemFromJson(Map<String, dynamic> json) {
  return _PowerMovementItem.fromJson(json);
}

/// @nodoc
mixin _$PowerMovementItem {
  String get eye => throw _privateConstructorUsedError;
  double get sph => throw _privateConstructorUsedError;
  double get cyl => throw _privateConstructorUsedError;
  int get axis => throw _privateConstructorUsedError;
  double get add => throw _privateConstructorUsedError;
  String get itemName => throw _privateConstructorUsedError;
  int get orderCount => throw _privateConstructorUsedError;
  int get totalQty => throw _privateConstructorUsedError;
  double get totalRevenue => throw _privateConstructorUsedError;
  double get avgPrice => throw _privateConstructorUsedError;
  String? get lastSoldDate => throw _privateConstructorUsedError;
  String get movementStatus => throw _privateConstructorUsedError;

  /// Serializes this PowerMovementItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PowerMovementItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PowerMovementItemCopyWith<PowerMovementItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PowerMovementItemCopyWith<$Res> {
  factory $PowerMovementItemCopyWith(
    PowerMovementItem value,
    $Res Function(PowerMovementItem) then,
  ) = _$PowerMovementItemCopyWithImpl<$Res, PowerMovementItem>;
  @useResult
  $Res call({
    String eye,
    double sph,
    double cyl,
    int axis,
    double add,
    String itemName,
    int orderCount,
    int totalQty,
    double totalRevenue,
    double avgPrice,
    String? lastSoldDate,
    String movementStatus,
  });
}

/// @nodoc
class _$PowerMovementItemCopyWithImpl<$Res, $Val extends PowerMovementItem>
    implements $PowerMovementItemCopyWith<$Res> {
  _$PowerMovementItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PowerMovementItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eye = null,
    Object? sph = null,
    Object? cyl = null,
    Object? axis = null,
    Object? add = null,
    Object? itemName = null,
    Object? orderCount = null,
    Object? totalQty = null,
    Object? totalRevenue = null,
    Object? avgPrice = null,
    Object? lastSoldDate = freezed,
    Object? movementStatus = null,
  }) {
    return _then(
      _value.copyWith(
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
                      as int,
            add: null == add
                ? _value.add
                : add // ignore: cast_nullable_to_non_nullable
                      as double,
            itemName: null == itemName
                ? _value.itemName
                : itemName // ignore: cast_nullable_to_non_nullable
                      as String,
            orderCount: null == orderCount
                ? _value.orderCount
                : orderCount // ignore: cast_nullable_to_non_nullable
                      as int,
            totalQty: null == totalQty
                ? _value.totalQty
                : totalQty // ignore: cast_nullable_to_non_nullable
                      as int,
            totalRevenue: null == totalRevenue
                ? _value.totalRevenue
                : totalRevenue // ignore: cast_nullable_to_non_nullable
                      as double,
            avgPrice: null == avgPrice
                ? _value.avgPrice
                : avgPrice // ignore: cast_nullable_to_non_nullable
                      as double,
            lastSoldDate: freezed == lastSoldDate
                ? _value.lastSoldDate
                : lastSoldDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            movementStatus: null == movementStatus
                ? _value.movementStatus
                : movementStatus // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PowerMovementItemImplCopyWith<$Res>
    implements $PowerMovementItemCopyWith<$Res> {
  factory _$$PowerMovementItemImplCopyWith(
    _$PowerMovementItemImpl value,
    $Res Function(_$PowerMovementItemImpl) then,
  ) = __$$PowerMovementItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String eye,
    double sph,
    double cyl,
    int axis,
    double add,
    String itemName,
    int orderCount,
    int totalQty,
    double totalRevenue,
    double avgPrice,
    String? lastSoldDate,
    String movementStatus,
  });
}

/// @nodoc
class __$$PowerMovementItemImplCopyWithImpl<$Res>
    extends _$PowerMovementItemCopyWithImpl<$Res, _$PowerMovementItemImpl>
    implements _$$PowerMovementItemImplCopyWith<$Res> {
  __$$PowerMovementItemImplCopyWithImpl(
    _$PowerMovementItemImpl _value,
    $Res Function(_$PowerMovementItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PowerMovementItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eye = null,
    Object? sph = null,
    Object? cyl = null,
    Object? axis = null,
    Object? add = null,
    Object? itemName = null,
    Object? orderCount = null,
    Object? totalQty = null,
    Object? totalRevenue = null,
    Object? avgPrice = null,
    Object? lastSoldDate = freezed,
    Object? movementStatus = null,
  }) {
    return _then(
      _$PowerMovementItemImpl(
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
                  as int,
        add: null == add
            ? _value.add
            : add // ignore: cast_nullable_to_non_nullable
                  as double,
        itemName: null == itemName
            ? _value.itemName
            : itemName // ignore: cast_nullable_to_non_nullable
                  as String,
        orderCount: null == orderCount
            ? _value.orderCount
            : orderCount // ignore: cast_nullable_to_non_nullable
                  as int,
        totalQty: null == totalQty
            ? _value.totalQty
            : totalQty // ignore: cast_nullable_to_non_nullable
                  as int,
        totalRevenue: null == totalRevenue
            ? _value.totalRevenue
            : totalRevenue // ignore: cast_nullable_to_non_nullable
                  as double,
        avgPrice: null == avgPrice
            ? _value.avgPrice
            : avgPrice // ignore: cast_nullable_to_non_nullable
                  as double,
        lastSoldDate: freezed == lastSoldDate
            ? _value.lastSoldDate
            : lastSoldDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        movementStatus: null == movementStatus
            ? _value.movementStatus
            : movementStatus // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PowerMovementItemImpl implements _PowerMovementItem {
  const _$PowerMovementItemImpl({
    required this.eye,
    required this.sph,
    required this.cyl,
    required this.axis,
    required this.add,
    required this.itemName,
    required this.orderCount,
    required this.totalQty,
    required this.totalRevenue,
    required this.avgPrice,
    this.lastSoldDate,
    required this.movementStatus,
  });

  factory _$PowerMovementItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$PowerMovementItemImplFromJson(json);

  @override
  final String eye;
  @override
  final double sph;
  @override
  final double cyl;
  @override
  final int axis;
  @override
  final double add;
  @override
  final String itemName;
  @override
  final int orderCount;
  @override
  final int totalQty;
  @override
  final double totalRevenue;
  @override
  final double avgPrice;
  @override
  final String? lastSoldDate;
  @override
  final String movementStatus;

  @override
  String toString() {
    return 'PowerMovementItem(eye: $eye, sph: $sph, cyl: $cyl, axis: $axis, add: $add, itemName: $itemName, orderCount: $orderCount, totalQty: $totalQty, totalRevenue: $totalRevenue, avgPrice: $avgPrice, lastSoldDate: $lastSoldDate, movementStatus: $movementStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PowerMovementItemImpl &&
            (identical(other.eye, eye) || other.eye == eye) &&
            (identical(other.sph, sph) || other.sph == sph) &&
            (identical(other.cyl, cyl) || other.cyl == cyl) &&
            (identical(other.axis, axis) || other.axis == axis) &&
            (identical(other.add, add) || other.add == add) &&
            (identical(other.itemName, itemName) ||
                other.itemName == itemName) &&
            (identical(other.orderCount, orderCount) ||
                other.orderCount == orderCount) &&
            (identical(other.totalQty, totalQty) ||
                other.totalQty == totalQty) &&
            (identical(other.totalRevenue, totalRevenue) ||
                other.totalRevenue == totalRevenue) &&
            (identical(other.avgPrice, avgPrice) ||
                other.avgPrice == avgPrice) &&
            (identical(other.lastSoldDate, lastSoldDate) ||
                other.lastSoldDate == lastSoldDate) &&
            (identical(other.movementStatus, movementStatus) ||
                other.movementStatus == movementStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    eye,
    sph,
    cyl,
    axis,
    add,
    itemName,
    orderCount,
    totalQty,
    totalRevenue,
    avgPrice,
    lastSoldDate,
    movementStatus,
  );

  /// Create a copy of PowerMovementItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PowerMovementItemImplCopyWith<_$PowerMovementItemImpl> get copyWith =>
      __$$PowerMovementItemImplCopyWithImpl<_$PowerMovementItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PowerMovementItemImplToJson(this);
  }
}

abstract class _PowerMovementItem implements PowerMovementItem {
  const factory _PowerMovementItem({
    required final String eye,
    required final double sph,
    required final double cyl,
    required final int axis,
    required final double add,
    required final String itemName,
    required final int orderCount,
    required final int totalQty,
    required final double totalRevenue,
    required final double avgPrice,
    final String? lastSoldDate,
    required final String movementStatus,
  }) = _$PowerMovementItemImpl;

  factory _PowerMovementItem.fromJson(Map<String, dynamic> json) =
      _$PowerMovementItemImpl.fromJson;

  @override
  String get eye;
  @override
  double get sph;
  @override
  double get cyl;
  @override
  int get axis;
  @override
  double get add;
  @override
  String get itemName;
  @override
  int get orderCount;
  @override
  int get totalQty;
  @override
  double get totalRevenue;
  @override
  double get avgPrice;
  @override
  String? get lastSoldDate;
  @override
  String get movementStatus;

  /// Create a copy of PowerMovementItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PowerMovementItemImplCopyWith<_$PowerMovementItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PowerMovementAnalytics _$PowerMovementAnalyticsFromJson(
  Map<String, dynamic> json,
) {
  return _PowerMovementAnalytics.fromJson(json);
}

/// @nodoc
mixin _$PowerMovementAnalytics {
  List<PowerMovementItem>? get topFastMoving =>
      throw _privateConstructorUsedError;
  PowerMovementItem? get highestRevenue => throw _privateConstructorUsedError;
  String? get mostSoldItem => throw _privateConstructorUsedError;
  PowerSummary? get totalSummary => throw _privateConstructorUsedError;

  /// Serializes this PowerMovementAnalytics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PowerMovementAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PowerMovementAnalyticsCopyWith<PowerMovementAnalytics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PowerMovementAnalyticsCopyWith<$Res> {
  factory $PowerMovementAnalyticsCopyWith(
    PowerMovementAnalytics value,
    $Res Function(PowerMovementAnalytics) then,
  ) = _$PowerMovementAnalyticsCopyWithImpl<$Res, PowerMovementAnalytics>;
  @useResult
  $Res call({
    List<PowerMovementItem>? topFastMoving,
    PowerMovementItem? highestRevenue,
    String? mostSoldItem,
    PowerSummary? totalSummary,
  });

  $PowerMovementItemCopyWith<$Res>? get highestRevenue;
  $PowerSummaryCopyWith<$Res>? get totalSummary;
}

/// @nodoc
class _$PowerMovementAnalyticsCopyWithImpl<
  $Res,
  $Val extends PowerMovementAnalytics
>
    implements $PowerMovementAnalyticsCopyWith<$Res> {
  _$PowerMovementAnalyticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PowerMovementAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? topFastMoving = freezed,
    Object? highestRevenue = freezed,
    Object? mostSoldItem = freezed,
    Object? totalSummary = freezed,
  }) {
    return _then(
      _value.copyWith(
            topFastMoving: freezed == topFastMoving
                ? _value.topFastMoving
                : topFastMoving // ignore: cast_nullable_to_non_nullable
                      as List<PowerMovementItem>?,
            highestRevenue: freezed == highestRevenue
                ? _value.highestRevenue
                : highestRevenue // ignore: cast_nullable_to_non_nullable
                      as PowerMovementItem?,
            mostSoldItem: freezed == mostSoldItem
                ? _value.mostSoldItem
                : mostSoldItem // ignore: cast_nullable_to_non_nullable
                      as String?,
            totalSummary: freezed == totalSummary
                ? _value.totalSummary
                : totalSummary // ignore: cast_nullable_to_non_nullable
                      as PowerSummary?,
          )
          as $Val,
    );
  }

  /// Create a copy of PowerMovementAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PowerMovementItemCopyWith<$Res>? get highestRevenue {
    if (_value.highestRevenue == null) {
      return null;
    }

    return $PowerMovementItemCopyWith<$Res>(_value.highestRevenue!, (value) {
      return _then(_value.copyWith(highestRevenue: value) as $Val);
    });
  }

  /// Create a copy of PowerMovementAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PowerSummaryCopyWith<$Res>? get totalSummary {
    if (_value.totalSummary == null) {
      return null;
    }

    return $PowerSummaryCopyWith<$Res>(_value.totalSummary!, (value) {
      return _then(_value.copyWith(totalSummary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PowerMovementAnalyticsImplCopyWith<$Res>
    implements $PowerMovementAnalyticsCopyWith<$Res> {
  factory _$$PowerMovementAnalyticsImplCopyWith(
    _$PowerMovementAnalyticsImpl value,
    $Res Function(_$PowerMovementAnalyticsImpl) then,
  ) = __$$PowerMovementAnalyticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<PowerMovementItem>? topFastMoving,
    PowerMovementItem? highestRevenue,
    String? mostSoldItem,
    PowerSummary? totalSummary,
  });

  @override
  $PowerMovementItemCopyWith<$Res>? get highestRevenue;
  @override
  $PowerSummaryCopyWith<$Res>? get totalSummary;
}

/// @nodoc
class __$$PowerMovementAnalyticsImplCopyWithImpl<$Res>
    extends
        _$PowerMovementAnalyticsCopyWithImpl<$Res, _$PowerMovementAnalyticsImpl>
    implements _$$PowerMovementAnalyticsImplCopyWith<$Res> {
  __$$PowerMovementAnalyticsImplCopyWithImpl(
    _$PowerMovementAnalyticsImpl _value,
    $Res Function(_$PowerMovementAnalyticsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PowerMovementAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? topFastMoving = freezed,
    Object? highestRevenue = freezed,
    Object? mostSoldItem = freezed,
    Object? totalSummary = freezed,
  }) {
    return _then(
      _$PowerMovementAnalyticsImpl(
        topFastMoving: freezed == topFastMoving
            ? _value._topFastMoving
            : topFastMoving // ignore: cast_nullable_to_non_nullable
                  as List<PowerMovementItem>?,
        highestRevenue: freezed == highestRevenue
            ? _value.highestRevenue
            : highestRevenue // ignore: cast_nullable_to_non_nullable
                  as PowerMovementItem?,
        mostSoldItem: freezed == mostSoldItem
            ? _value.mostSoldItem
            : mostSoldItem // ignore: cast_nullable_to_non_nullable
                  as String?,
        totalSummary: freezed == totalSummary
            ? _value.totalSummary
            : totalSummary // ignore: cast_nullable_to_non_nullable
                  as PowerSummary?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PowerMovementAnalyticsImpl implements _PowerMovementAnalytics {
  const _$PowerMovementAnalyticsImpl({
    final List<PowerMovementItem>? topFastMoving,
    this.highestRevenue,
    this.mostSoldItem,
    this.totalSummary,
  }) : _topFastMoving = topFastMoving;

  factory _$PowerMovementAnalyticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PowerMovementAnalyticsImplFromJson(json);

  final List<PowerMovementItem>? _topFastMoving;
  @override
  List<PowerMovementItem>? get topFastMoving {
    final value = _topFastMoving;
    if (value == null) return null;
    if (_topFastMoving is EqualUnmodifiableListView) return _topFastMoving;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final PowerMovementItem? highestRevenue;
  @override
  final String? mostSoldItem;
  @override
  final PowerSummary? totalSummary;

  @override
  String toString() {
    return 'PowerMovementAnalytics(topFastMoving: $topFastMoving, highestRevenue: $highestRevenue, mostSoldItem: $mostSoldItem, totalSummary: $totalSummary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PowerMovementAnalyticsImpl &&
            const DeepCollectionEquality().equals(
              other._topFastMoving,
              _topFastMoving,
            ) &&
            (identical(other.highestRevenue, highestRevenue) ||
                other.highestRevenue == highestRevenue) &&
            (identical(other.mostSoldItem, mostSoldItem) ||
                other.mostSoldItem == mostSoldItem) &&
            (identical(other.totalSummary, totalSummary) ||
                other.totalSummary == totalSummary));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_topFastMoving),
    highestRevenue,
    mostSoldItem,
    totalSummary,
  );

  /// Create a copy of PowerMovementAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PowerMovementAnalyticsImplCopyWith<_$PowerMovementAnalyticsImpl>
  get copyWith =>
      __$$PowerMovementAnalyticsImplCopyWithImpl<_$PowerMovementAnalyticsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PowerMovementAnalyticsImplToJson(this);
  }
}

abstract class _PowerMovementAnalytics implements PowerMovementAnalytics {
  const factory _PowerMovementAnalytics({
    final List<PowerMovementItem>? topFastMoving,
    final PowerMovementItem? highestRevenue,
    final String? mostSoldItem,
    final PowerSummary? totalSummary,
  }) = _$PowerMovementAnalyticsImpl;

  factory _PowerMovementAnalytics.fromJson(Map<String, dynamic> json) =
      _$PowerMovementAnalyticsImpl.fromJson;

  @override
  List<PowerMovementItem>? get topFastMoving;
  @override
  PowerMovementItem? get highestRevenue;
  @override
  String? get mostSoldItem;
  @override
  PowerSummary? get totalSummary;

  /// Create a copy of PowerMovementAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PowerMovementAnalyticsImplCopyWith<_$PowerMovementAnalyticsImpl>
  get copyWith => throw _privateConstructorUsedError;
}

PowerSummary _$PowerSummaryFromJson(Map<String, dynamic> json) {
  return _PowerSummary.fromJson(json);
}

/// @nodoc
mixin _$PowerSummary {
  int get totalQty => throw _privateConstructorUsedError;
  double get totalRevenue => throw _privateConstructorUsedError;

  /// Serializes this PowerSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PowerSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PowerSummaryCopyWith<PowerSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PowerSummaryCopyWith<$Res> {
  factory $PowerSummaryCopyWith(
    PowerSummary value,
    $Res Function(PowerSummary) then,
  ) = _$PowerSummaryCopyWithImpl<$Res, PowerSummary>;
  @useResult
  $Res call({int totalQty, double totalRevenue});
}

/// @nodoc
class _$PowerSummaryCopyWithImpl<$Res, $Val extends PowerSummary>
    implements $PowerSummaryCopyWith<$Res> {
  _$PowerSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PowerSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? totalQty = null, Object? totalRevenue = null}) {
    return _then(
      _value.copyWith(
            totalQty: null == totalQty
                ? _value.totalQty
                : totalQty // ignore: cast_nullable_to_non_nullable
                      as int,
            totalRevenue: null == totalRevenue
                ? _value.totalRevenue
                : totalRevenue // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PowerSummaryImplCopyWith<$Res>
    implements $PowerSummaryCopyWith<$Res> {
  factory _$$PowerSummaryImplCopyWith(
    _$PowerSummaryImpl value,
    $Res Function(_$PowerSummaryImpl) then,
  ) = __$$PowerSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int totalQty, double totalRevenue});
}

/// @nodoc
class __$$PowerSummaryImplCopyWithImpl<$Res>
    extends _$PowerSummaryCopyWithImpl<$Res, _$PowerSummaryImpl>
    implements _$$PowerSummaryImplCopyWith<$Res> {
  __$$PowerSummaryImplCopyWithImpl(
    _$PowerSummaryImpl _value,
    $Res Function(_$PowerSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PowerSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? totalQty = null, Object? totalRevenue = null}) {
    return _then(
      _$PowerSummaryImpl(
        totalQty: null == totalQty
            ? _value.totalQty
            : totalQty // ignore: cast_nullable_to_non_nullable
                  as int,
        totalRevenue: null == totalRevenue
            ? _value.totalRevenue
            : totalRevenue // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PowerSummaryImpl implements _PowerSummary {
  const _$PowerSummaryImpl({
    required this.totalQty,
    required this.totalRevenue,
  });

  factory _$PowerSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$PowerSummaryImplFromJson(json);

  @override
  final int totalQty;
  @override
  final double totalRevenue;

  @override
  String toString() {
    return 'PowerSummary(totalQty: $totalQty, totalRevenue: $totalRevenue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PowerSummaryImpl &&
            (identical(other.totalQty, totalQty) ||
                other.totalQty == totalQty) &&
            (identical(other.totalRevenue, totalRevenue) ||
                other.totalRevenue == totalRevenue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, totalQty, totalRevenue);

  /// Create a copy of PowerSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PowerSummaryImplCopyWith<_$PowerSummaryImpl> get copyWith =>
      __$$PowerSummaryImplCopyWithImpl<_$PowerSummaryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PowerSummaryImplToJson(this);
  }
}

abstract class _PowerSummary implements PowerSummary {
  const factory _PowerSummary({
    required final int totalQty,
    required final double totalRevenue,
  }) = _$PowerSummaryImpl;

  factory _PowerSummary.fromJson(Map<String, dynamic> json) =
      _$PowerSummaryImpl.fromJson;

  @override
  int get totalQty;
  @override
  double get totalRevenue;

  /// Create a copy of PowerSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PowerSummaryImplCopyWith<_$PowerSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PartyWiseItem _$PartyWiseItemFromJson(Map<String, dynamic> json) {
  return _PartyWiseItem.fromJson(json);
}

/// @nodoc
mixin _$PartyWiseItem {
  String? get transType => throw _privateConstructorUsedError;
  String? get vchSeries => throw _privateConstructorUsedError;
  String? get vchNo => throw _privateConstructorUsedError;
  String? get vchDate => throw _privateConstructorUsedError;
  String? get partyName => throw _privateConstructorUsedError;
  String? get mobNo => throw _privateConstructorUsedError;
  String? get barcode => throw _privateConstructorUsedError;
  String? get productName => throw _privateConstructorUsedError;
  String? get bookedBy => throw _privateConstructorUsedError;
  String? get dia => throw _privateConstructorUsedError;
  String? get eye => throw _privateConstructorUsedError;
  dynamic get sph => throw _privateConstructorUsedError;
  dynamic get cyl => throw _privateConstructorUsedError;
  dynamic get axis => throw _privateConstructorUsedError;
  dynamic get add => throw _privateConstructorUsedError;
  double get qty => throw _privateConstructorUsedError;
  String? get loc => throw _privateConstructorUsedError;
  double get pricePerUnit => throw _privateConstructorUsedError;
  double get totalPrice => throw _privateConstructorUsedError;
  double? get purchasePrice => throw _privateConstructorUsedError;
  String? get combinationId => throw _privateConstructorUsedError;
  String? get dcId => throw _privateConstructorUsedError;
  String? get vendorName => throw _privateConstructorUsedError;
  @JsonKey(name: 'dc_id')
  String? get dc_id => throw _privateConstructorUsedError;
  String? get remark => throw _privateConstructorUsedError;

  /// Serializes this PartyWiseItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PartyWiseItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PartyWiseItemCopyWith<PartyWiseItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PartyWiseItemCopyWith<$Res> {
  factory $PartyWiseItemCopyWith(
    PartyWiseItem value,
    $Res Function(PartyWiseItem) then,
  ) = _$PartyWiseItemCopyWithImpl<$Res, PartyWiseItem>;
  @useResult
  $Res call({
    String? transType,
    String? vchSeries,
    String? vchNo,
    String? vchDate,
    String? partyName,
    String? mobNo,
    String? barcode,
    String? productName,
    String? bookedBy,
    String? dia,
    String? eye,
    dynamic sph,
    dynamic cyl,
    dynamic axis,
    dynamic add,
    double qty,
    String? loc,
    double pricePerUnit,
    double totalPrice,
    double? purchasePrice,
    String? combinationId,
    String? dcId,
    String? vendorName,
    @JsonKey(name: 'dc_id') String? dc_id,
    String? remark,
  });
}

/// @nodoc
class _$PartyWiseItemCopyWithImpl<$Res, $Val extends PartyWiseItem>
    implements $PartyWiseItemCopyWith<$Res> {
  _$PartyWiseItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PartyWiseItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transType = freezed,
    Object? vchSeries = freezed,
    Object? vchNo = freezed,
    Object? vchDate = freezed,
    Object? partyName = freezed,
    Object? mobNo = freezed,
    Object? barcode = freezed,
    Object? productName = freezed,
    Object? bookedBy = freezed,
    Object? dia = freezed,
    Object? eye = freezed,
    Object? sph = freezed,
    Object? cyl = freezed,
    Object? axis = freezed,
    Object? add = freezed,
    Object? qty = null,
    Object? loc = freezed,
    Object? pricePerUnit = null,
    Object? totalPrice = null,
    Object? purchasePrice = freezed,
    Object? combinationId = freezed,
    Object? dcId = freezed,
    Object? vendorName = freezed,
    Object? dc_id = freezed,
    Object? remark = freezed,
  }) {
    return _then(
      _value.copyWith(
            transType: freezed == transType
                ? _value.transType
                : transType // ignore: cast_nullable_to_non_nullable
                      as String?,
            vchSeries: freezed == vchSeries
                ? _value.vchSeries
                : vchSeries // ignore: cast_nullable_to_non_nullable
                      as String?,
            vchNo: freezed == vchNo
                ? _value.vchNo
                : vchNo // ignore: cast_nullable_to_non_nullable
                      as String?,
            vchDate: freezed == vchDate
                ? _value.vchDate
                : vchDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            partyName: freezed == partyName
                ? _value.partyName
                : partyName // ignore: cast_nullable_to_non_nullable
                      as String?,
            mobNo: freezed == mobNo
                ? _value.mobNo
                : mobNo // ignore: cast_nullable_to_non_nullable
                      as String?,
            barcode: freezed == barcode
                ? _value.barcode
                : barcode // ignore: cast_nullable_to_non_nullable
                      as String?,
            productName: freezed == productName
                ? _value.productName
                : productName // ignore: cast_nullable_to_non_nullable
                      as String?,
            bookedBy: freezed == bookedBy
                ? _value.bookedBy
                : bookedBy // ignore: cast_nullable_to_non_nullable
                      as String?,
            dia: freezed == dia
                ? _value.dia
                : dia // ignore: cast_nullable_to_non_nullable
                      as String?,
            eye: freezed == eye
                ? _value.eye
                : eye // ignore: cast_nullable_to_non_nullable
                      as String?,
            sph: freezed == sph
                ? _value.sph
                : sph // ignore: cast_nullable_to_non_nullable
                      as dynamic,
            cyl: freezed == cyl
                ? _value.cyl
                : cyl // ignore: cast_nullable_to_non_nullable
                      as dynamic,
            axis: freezed == axis
                ? _value.axis
                : axis // ignore: cast_nullable_to_non_nullable
                      as dynamic,
            add: freezed == add
                ? _value.add
                : add // ignore: cast_nullable_to_non_nullable
                      as dynamic,
            qty: null == qty
                ? _value.qty
                : qty // ignore: cast_nullable_to_non_nullable
                      as double,
            loc: freezed == loc
                ? _value.loc
                : loc // ignore: cast_nullable_to_non_nullable
                      as String?,
            pricePerUnit: null == pricePerUnit
                ? _value.pricePerUnit
                : pricePerUnit // ignore: cast_nullable_to_non_nullable
                      as double,
            totalPrice: null == totalPrice
                ? _value.totalPrice
                : totalPrice // ignore: cast_nullable_to_non_nullable
                      as double,
            purchasePrice: freezed == purchasePrice
                ? _value.purchasePrice
                : purchasePrice // ignore: cast_nullable_to_non_nullable
                      as double?,
            combinationId: freezed == combinationId
                ? _value.combinationId
                : combinationId // ignore: cast_nullable_to_non_nullable
                      as String?,
            dcId: freezed == dcId
                ? _value.dcId
                : dcId // ignore: cast_nullable_to_non_nullable
                      as String?,
            vendorName: freezed == vendorName
                ? _value.vendorName
                : vendorName // ignore: cast_nullable_to_non_nullable
                      as String?,
            dc_id: freezed == dc_id
                ? _value.dc_id
                : dc_id // ignore: cast_nullable_to_non_nullable
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
abstract class _$$PartyWiseItemImplCopyWith<$Res>
    implements $PartyWiseItemCopyWith<$Res> {
  factory _$$PartyWiseItemImplCopyWith(
    _$PartyWiseItemImpl value,
    $Res Function(_$PartyWiseItemImpl) then,
  ) = __$$PartyWiseItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? transType,
    String? vchSeries,
    String? vchNo,
    String? vchDate,
    String? partyName,
    String? mobNo,
    String? barcode,
    String? productName,
    String? bookedBy,
    String? dia,
    String? eye,
    dynamic sph,
    dynamic cyl,
    dynamic axis,
    dynamic add,
    double qty,
    String? loc,
    double pricePerUnit,
    double totalPrice,
    double? purchasePrice,
    String? combinationId,
    String? dcId,
    String? vendorName,
    @JsonKey(name: 'dc_id') String? dc_id,
    String? remark,
  });
}

/// @nodoc
class __$$PartyWiseItemImplCopyWithImpl<$Res>
    extends _$PartyWiseItemCopyWithImpl<$Res, _$PartyWiseItemImpl>
    implements _$$PartyWiseItemImplCopyWith<$Res> {
  __$$PartyWiseItemImplCopyWithImpl(
    _$PartyWiseItemImpl _value,
    $Res Function(_$PartyWiseItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PartyWiseItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transType = freezed,
    Object? vchSeries = freezed,
    Object? vchNo = freezed,
    Object? vchDate = freezed,
    Object? partyName = freezed,
    Object? mobNo = freezed,
    Object? barcode = freezed,
    Object? productName = freezed,
    Object? bookedBy = freezed,
    Object? dia = freezed,
    Object? eye = freezed,
    Object? sph = freezed,
    Object? cyl = freezed,
    Object? axis = freezed,
    Object? add = freezed,
    Object? qty = null,
    Object? loc = freezed,
    Object? pricePerUnit = null,
    Object? totalPrice = null,
    Object? purchasePrice = freezed,
    Object? combinationId = freezed,
    Object? dcId = freezed,
    Object? vendorName = freezed,
    Object? dc_id = freezed,
    Object? remark = freezed,
  }) {
    return _then(
      _$PartyWiseItemImpl(
        transType: freezed == transType
            ? _value.transType
            : transType // ignore: cast_nullable_to_non_nullable
                  as String?,
        vchSeries: freezed == vchSeries
            ? _value.vchSeries
            : vchSeries // ignore: cast_nullable_to_non_nullable
                  as String?,
        vchNo: freezed == vchNo
            ? _value.vchNo
            : vchNo // ignore: cast_nullable_to_non_nullable
                  as String?,
        vchDate: freezed == vchDate
            ? _value.vchDate
            : vchDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        partyName: freezed == partyName
            ? _value.partyName
            : partyName // ignore: cast_nullable_to_non_nullable
                  as String?,
        mobNo: freezed == mobNo
            ? _value.mobNo
            : mobNo // ignore: cast_nullable_to_non_nullable
                  as String?,
        barcode: freezed == barcode
            ? _value.barcode
            : barcode // ignore: cast_nullable_to_non_nullable
                  as String?,
        productName: freezed == productName
            ? _value.productName
            : productName // ignore: cast_nullable_to_non_nullable
                  as String?,
        bookedBy: freezed == bookedBy
            ? _value.bookedBy
            : bookedBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        dia: freezed == dia
            ? _value.dia
            : dia // ignore: cast_nullable_to_non_nullable
                  as String?,
        eye: freezed == eye
            ? _value.eye
            : eye // ignore: cast_nullable_to_non_nullable
                  as String?,
        sph: freezed == sph
            ? _value.sph
            : sph // ignore: cast_nullable_to_non_nullable
                  as dynamic,
        cyl: freezed == cyl
            ? _value.cyl
            : cyl // ignore: cast_nullable_to_non_nullable
                  as dynamic,
        axis: freezed == axis
            ? _value.axis
            : axis // ignore: cast_nullable_to_non_nullable
                  as dynamic,
        add: freezed == add
            ? _value.add
            : add // ignore: cast_nullable_to_non_nullable
                  as dynamic,
        qty: null == qty
            ? _value.qty
            : qty // ignore: cast_nullable_to_non_nullable
                  as double,
        loc: freezed == loc
            ? _value.loc
            : loc // ignore: cast_nullable_to_non_nullable
                  as String?,
        pricePerUnit: null == pricePerUnit
            ? _value.pricePerUnit
            : pricePerUnit // ignore: cast_nullable_to_non_nullable
                  as double,
        totalPrice: null == totalPrice
            ? _value.totalPrice
            : totalPrice // ignore: cast_nullable_to_non_nullable
                  as double,
        purchasePrice: freezed == purchasePrice
            ? _value.purchasePrice
            : purchasePrice // ignore: cast_nullable_to_non_nullable
                  as double?,
        combinationId: freezed == combinationId
            ? _value.combinationId
            : combinationId // ignore: cast_nullable_to_non_nullable
                  as String?,
        dcId: freezed == dcId
            ? _value.dcId
            : dcId // ignore: cast_nullable_to_non_nullable
                  as String?,
        vendorName: freezed == vendorName
            ? _value.vendorName
            : vendorName // ignore: cast_nullable_to_non_nullable
                  as String?,
        dc_id: freezed == dc_id
            ? _value.dc_id
            : dc_id // ignore: cast_nullable_to_non_nullable
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
class _$PartyWiseItemImpl implements _PartyWiseItem {
  const _$PartyWiseItemImpl({
    this.transType,
    this.vchSeries,
    this.vchNo,
    this.vchDate,
    this.partyName,
    this.mobNo,
    this.barcode,
    this.productName,
    this.bookedBy,
    this.dia,
    this.eye,
    this.sph,
    this.cyl,
    this.axis,
    this.add,
    this.qty = 0,
    this.loc,
    this.pricePerUnit = 0,
    this.totalPrice = 0,
    this.purchasePrice,
    this.combinationId,
    this.dcId,
    this.vendorName,
    @JsonKey(name: 'dc_id') this.dc_id,
    this.remark,
  });

  factory _$PartyWiseItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$PartyWiseItemImplFromJson(json);

  @override
  final String? transType;
  @override
  final String? vchSeries;
  @override
  final String? vchNo;
  @override
  final String? vchDate;
  @override
  final String? partyName;
  @override
  final String? mobNo;
  @override
  final String? barcode;
  @override
  final String? productName;
  @override
  final String? bookedBy;
  @override
  final String? dia;
  @override
  final String? eye;
  @override
  final dynamic sph;
  @override
  final dynamic cyl;
  @override
  final dynamic axis;
  @override
  final dynamic add;
  @override
  @JsonKey()
  final double qty;
  @override
  final String? loc;
  @override
  @JsonKey()
  final double pricePerUnit;
  @override
  @JsonKey()
  final double totalPrice;
  @override
  final double? purchasePrice;
  @override
  final String? combinationId;
  @override
  final String? dcId;
  @override
  final String? vendorName;
  @override
  @JsonKey(name: 'dc_id')
  final String? dc_id;
  @override
  final String? remark;

  @override
  String toString() {
    return 'PartyWiseItem(transType: $transType, vchSeries: $vchSeries, vchNo: $vchNo, vchDate: $vchDate, partyName: $partyName, mobNo: $mobNo, barcode: $barcode, productName: $productName, bookedBy: $bookedBy, dia: $dia, eye: $eye, sph: $sph, cyl: $cyl, axis: $axis, add: $add, qty: $qty, loc: $loc, pricePerUnit: $pricePerUnit, totalPrice: $totalPrice, purchasePrice: $purchasePrice, combinationId: $combinationId, dcId: $dcId, vendorName: $vendorName, dc_id: $dc_id, remark: $remark)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PartyWiseItemImpl &&
            (identical(other.transType, transType) ||
                other.transType == transType) &&
            (identical(other.vchSeries, vchSeries) ||
                other.vchSeries == vchSeries) &&
            (identical(other.vchNo, vchNo) || other.vchNo == vchNo) &&
            (identical(other.vchDate, vchDate) || other.vchDate == vchDate) &&
            (identical(other.partyName, partyName) ||
                other.partyName == partyName) &&
            (identical(other.mobNo, mobNo) || other.mobNo == mobNo) &&
            (identical(other.barcode, barcode) || other.barcode == barcode) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.bookedBy, bookedBy) ||
                other.bookedBy == bookedBy) &&
            (identical(other.dia, dia) || other.dia == dia) &&
            (identical(other.eye, eye) || other.eye == eye) &&
            const DeepCollectionEquality().equals(other.sph, sph) &&
            const DeepCollectionEquality().equals(other.cyl, cyl) &&
            const DeepCollectionEquality().equals(other.axis, axis) &&
            const DeepCollectionEquality().equals(other.add, add) &&
            (identical(other.qty, qty) || other.qty == qty) &&
            (identical(other.loc, loc) || other.loc == loc) &&
            (identical(other.pricePerUnit, pricePerUnit) ||
                other.pricePerUnit == pricePerUnit) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.purchasePrice, purchasePrice) ||
                other.purchasePrice == purchasePrice) &&
            (identical(other.combinationId, combinationId) ||
                other.combinationId == combinationId) &&
            (identical(other.dcId, dcId) || other.dcId == dcId) &&
            (identical(other.vendorName, vendorName) ||
                other.vendorName == vendorName) &&
            (identical(other.dc_id, dc_id) || other.dc_id == dc_id) &&
            (identical(other.remark, remark) || other.remark == remark));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    transType,
    vchSeries,
    vchNo,
    vchDate,
    partyName,
    mobNo,
    barcode,
    productName,
    bookedBy,
    dia,
    eye,
    const DeepCollectionEquality().hash(sph),
    const DeepCollectionEquality().hash(cyl),
    const DeepCollectionEquality().hash(axis),
    const DeepCollectionEquality().hash(add),
    qty,
    loc,
    pricePerUnit,
    totalPrice,
    purchasePrice,
    combinationId,
    dcId,
    vendorName,
    dc_id,
    remark,
  ]);

  /// Create a copy of PartyWiseItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PartyWiseItemImplCopyWith<_$PartyWiseItemImpl> get copyWith =>
      __$$PartyWiseItemImplCopyWithImpl<_$PartyWiseItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PartyWiseItemImplToJson(this);
  }
}

abstract class _PartyWiseItem implements PartyWiseItem {
  const factory _PartyWiseItem({
    final String? transType,
    final String? vchSeries,
    final String? vchNo,
    final String? vchDate,
    final String? partyName,
    final String? mobNo,
    final String? barcode,
    final String? productName,
    final String? bookedBy,
    final String? dia,
    final String? eye,
    final dynamic sph,
    final dynamic cyl,
    final dynamic axis,
    final dynamic add,
    final double qty,
    final String? loc,
    final double pricePerUnit,
    final double totalPrice,
    final double? purchasePrice,
    final String? combinationId,
    final String? dcId,
    final String? vendorName,
    @JsonKey(name: 'dc_id') final String? dc_id,
    final String? remark,
  }) = _$PartyWiseItemImpl;

  factory _PartyWiseItem.fromJson(Map<String, dynamic> json) =
      _$PartyWiseItemImpl.fromJson;

  @override
  String? get transType;
  @override
  String? get vchSeries;
  @override
  String? get vchNo;
  @override
  String? get vchDate;
  @override
  String? get partyName;
  @override
  String? get mobNo;
  @override
  String? get barcode;
  @override
  String? get productName;
  @override
  String? get bookedBy;
  @override
  String? get dia;
  @override
  String? get eye;
  @override
  dynamic get sph;
  @override
  dynamic get cyl;
  @override
  dynamic get axis;
  @override
  dynamic get add;
  @override
  double get qty;
  @override
  String? get loc;
  @override
  double get pricePerUnit;
  @override
  double get totalPrice;
  @override
  double? get purchasePrice;
  @override
  String? get combinationId;
  @override
  String? get dcId;
  @override
  String? get vendorName;
  @override
  @JsonKey(name: 'dc_id')
  String? get dc_id;
  @override
  String? get remark;

  /// Create a copy of PartyWiseItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PartyWiseItemImplCopyWith<_$PartyWiseItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StockReorderItem _$StockReorderItemFromJson(Map<String, dynamic> json) {
  return _StockReorderItem.fromJson(json);
}

/// @nodoc
mixin _$StockReorderItem {
  String? get productName => throw _privateConstructorUsedError;
  String? get groupName => throw _privateConstructorUsedError;
  String? get unit => throw _privateConstructorUsedError;
  double get alertQty => throw _privateConstructorUsedError;
  double get stock => throw _privateConstructorUsedError;
  double? get minStock => throw _privateConstructorUsedError;
  double? get maxStock => throw _privateConstructorUsedError;
  double? get minReorderQty => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  StockReorderLensInfo? get lensInfo => throw _privateConstructorUsedError;
  String? get barcode => throw _privateConstructorUsedError;

  /// Serializes this StockReorderItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StockReorderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StockReorderItemCopyWith<StockReorderItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockReorderItemCopyWith<$Res> {
  factory $StockReorderItemCopyWith(
    StockReorderItem value,
    $Res Function(StockReorderItem) then,
  ) = _$StockReorderItemCopyWithImpl<$Res, StockReorderItem>;
  @useResult
  $Res call({
    String? productName,
    String? groupName,
    String? unit,
    double alertQty,
    double stock,
    double? minStock,
    double? maxStock,
    double? minReorderQty,
    String? type,
    StockReorderLensInfo? lensInfo,
    String? barcode,
  });

  $StockReorderLensInfoCopyWith<$Res>? get lensInfo;
}

/// @nodoc
class _$StockReorderItemCopyWithImpl<$Res, $Val extends StockReorderItem>
    implements $StockReorderItemCopyWith<$Res> {
  _$StockReorderItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StockReorderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productName = freezed,
    Object? groupName = freezed,
    Object? unit = freezed,
    Object? alertQty = null,
    Object? stock = null,
    Object? minStock = freezed,
    Object? maxStock = freezed,
    Object? minReorderQty = freezed,
    Object? type = freezed,
    Object? lensInfo = freezed,
    Object? barcode = freezed,
  }) {
    return _then(
      _value.copyWith(
            productName: freezed == productName
                ? _value.productName
                : productName // ignore: cast_nullable_to_non_nullable
                      as String?,
            groupName: freezed == groupName
                ? _value.groupName
                : groupName // ignore: cast_nullable_to_non_nullable
                      as String?,
            unit: freezed == unit
                ? _value.unit
                : unit // ignore: cast_nullable_to_non_nullable
                      as String?,
            alertQty: null == alertQty
                ? _value.alertQty
                : alertQty // ignore: cast_nullable_to_non_nullable
                      as double,
            stock: null == stock
                ? _value.stock
                : stock // ignore: cast_nullable_to_non_nullable
                      as double,
            minStock: freezed == minStock
                ? _value.minStock
                : minStock // ignore: cast_nullable_to_non_nullable
                      as double?,
            maxStock: freezed == maxStock
                ? _value.maxStock
                : maxStock // ignore: cast_nullable_to_non_nullable
                      as double?,
            minReorderQty: freezed == minReorderQty
                ? _value.minReorderQty
                : minReorderQty // ignore: cast_nullable_to_non_nullable
                      as double?,
            type: freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String?,
            lensInfo: freezed == lensInfo
                ? _value.lensInfo
                : lensInfo // ignore: cast_nullable_to_non_nullable
                      as StockReorderLensInfo?,
            barcode: freezed == barcode
                ? _value.barcode
                : barcode // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of StockReorderItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StockReorderLensInfoCopyWith<$Res>? get lensInfo {
    if (_value.lensInfo == null) {
      return null;
    }

    return $StockReorderLensInfoCopyWith<$Res>(_value.lensInfo!, (value) {
      return _then(_value.copyWith(lensInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StockReorderItemImplCopyWith<$Res>
    implements $StockReorderItemCopyWith<$Res> {
  factory _$$StockReorderItemImplCopyWith(
    _$StockReorderItemImpl value,
    $Res Function(_$StockReorderItemImpl) then,
  ) = __$$StockReorderItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? productName,
    String? groupName,
    String? unit,
    double alertQty,
    double stock,
    double? minStock,
    double? maxStock,
    double? minReorderQty,
    String? type,
    StockReorderLensInfo? lensInfo,
    String? barcode,
  });

  @override
  $StockReorderLensInfoCopyWith<$Res>? get lensInfo;
}

/// @nodoc
class __$$StockReorderItemImplCopyWithImpl<$Res>
    extends _$StockReorderItemCopyWithImpl<$Res, _$StockReorderItemImpl>
    implements _$$StockReorderItemImplCopyWith<$Res> {
  __$$StockReorderItemImplCopyWithImpl(
    _$StockReorderItemImpl _value,
    $Res Function(_$StockReorderItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StockReorderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productName = freezed,
    Object? groupName = freezed,
    Object? unit = freezed,
    Object? alertQty = null,
    Object? stock = null,
    Object? minStock = freezed,
    Object? maxStock = freezed,
    Object? minReorderQty = freezed,
    Object? type = freezed,
    Object? lensInfo = freezed,
    Object? barcode = freezed,
  }) {
    return _then(
      _$StockReorderItemImpl(
        productName: freezed == productName
            ? _value.productName
            : productName // ignore: cast_nullable_to_non_nullable
                  as String?,
        groupName: freezed == groupName
            ? _value.groupName
            : groupName // ignore: cast_nullable_to_non_nullable
                  as String?,
        unit: freezed == unit
            ? _value.unit
            : unit // ignore: cast_nullable_to_non_nullable
                  as String?,
        alertQty: null == alertQty
            ? _value.alertQty
            : alertQty // ignore: cast_nullable_to_non_nullable
                  as double,
        stock: null == stock
            ? _value.stock
            : stock // ignore: cast_nullable_to_non_nullable
                  as double,
        minStock: freezed == minStock
            ? _value.minStock
            : minStock // ignore: cast_nullable_to_non_nullable
                  as double?,
        maxStock: freezed == maxStock
            ? _value.maxStock
            : maxStock // ignore: cast_nullable_to_non_nullable
                  as double?,
        minReorderQty: freezed == minReorderQty
            ? _value.minReorderQty
            : minReorderQty // ignore: cast_nullable_to_non_nullable
                  as double?,
        type: freezed == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String?,
        lensInfo: freezed == lensInfo
            ? _value.lensInfo
            : lensInfo // ignore: cast_nullable_to_non_nullable
                  as StockReorderLensInfo?,
        barcode: freezed == barcode
            ? _value.barcode
            : barcode // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StockReorderItemImpl implements _StockReorderItem {
  const _$StockReorderItemImpl({
    this.productName,
    this.groupName,
    this.unit,
    this.alertQty = 0,
    this.stock = 0,
    this.minStock,
    this.maxStock,
    this.minReorderQty,
    this.type,
    this.lensInfo,
    this.barcode,
  });

  factory _$StockReorderItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$StockReorderItemImplFromJson(json);

  @override
  final String? productName;
  @override
  final String? groupName;
  @override
  final String? unit;
  @override
  @JsonKey()
  final double alertQty;
  @override
  @JsonKey()
  final double stock;
  @override
  final double? minStock;
  @override
  final double? maxStock;
  @override
  final double? minReorderQty;
  @override
  final String? type;
  @override
  final StockReorderLensInfo? lensInfo;
  @override
  final String? barcode;

  @override
  String toString() {
    return 'StockReorderItem(productName: $productName, groupName: $groupName, unit: $unit, alertQty: $alertQty, stock: $stock, minStock: $minStock, maxStock: $maxStock, minReorderQty: $minReorderQty, type: $type, lensInfo: $lensInfo, barcode: $barcode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockReorderItemImpl &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.groupName, groupName) ||
                other.groupName == groupName) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.alertQty, alertQty) ||
                other.alertQty == alertQty) &&
            (identical(other.stock, stock) || other.stock == stock) &&
            (identical(other.minStock, minStock) ||
                other.minStock == minStock) &&
            (identical(other.maxStock, maxStock) ||
                other.maxStock == maxStock) &&
            (identical(other.minReorderQty, minReorderQty) ||
                other.minReorderQty == minReorderQty) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.lensInfo, lensInfo) ||
                other.lensInfo == lensInfo) &&
            (identical(other.barcode, barcode) || other.barcode == barcode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    productName,
    groupName,
    unit,
    alertQty,
    stock,
    minStock,
    maxStock,
    minReorderQty,
    type,
    lensInfo,
    barcode,
  );

  /// Create a copy of StockReorderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StockReorderItemImplCopyWith<_$StockReorderItemImpl> get copyWith =>
      __$$StockReorderItemImplCopyWithImpl<_$StockReorderItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$StockReorderItemImplToJson(this);
  }
}

abstract class _StockReorderItem implements StockReorderItem {
  const factory _StockReorderItem({
    final String? productName,
    final String? groupName,
    final String? unit,
    final double alertQty,
    final double stock,
    final double? minStock,
    final double? maxStock,
    final double? minReorderQty,
    final String? type,
    final StockReorderLensInfo? lensInfo,
    final String? barcode,
  }) = _$StockReorderItemImpl;

  factory _StockReorderItem.fromJson(Map<String, dynamic> json) =
      _$StockReorderItemImpl.fromJson;

  @override
  String? get productName;
  @override
  String? get groupName;
  @override
  String? get unit;
  @override
  double get alertQty;
  @override
  double get stock;
  @override
  double? get minStock;
  @override
  double? get maxStock;
  @override
  double? get minReorderQty;
  @override
  String? get type;
  @override
  StockReorderLensInfo? get lensInfo;
  @override
  String? get barcode;

  /// Create a copy of StockReorderItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StockReorderItemImplCopyWith<_$StockReorderItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StockReorderLensInfo _$StockReorderLensInfoFromJson(Map<String, dynamic> json) {
  return _StockReorderLensInfo.fromJson(json);
}

/// @nodoc
mixin _$StockReorderLensInfo {
  dynamic get sph => throw _privateConstructorUsedError;
  dynamic get cyl => throw _privateConstructorUsedError;
  String? get eye => throw _privateConstructorUsedError;
  dynamic get axis => throw _privateConstructorUsedError;
  dynamic get add => throw _privateConstructorUsedError;

  /// Serializes this StockReorderLensInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StockReorderLensInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StockReorderLensInfoCopyWith<StockReorderLensInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockReorderLensInfoCopyWith<$Res> {
  factory $StockReorderLensInfoCopyWith(
    StockReorderLensInfo value,
    $Res Function(StockReorderLensInfo) then,
  ) = _$StockReorderLensInfoCopyWithImpl<$Res, StockReorderLensInfo>;
  @useResult
  $Res call({dynamic sph, dynamic cyl, String? eye, dynamic axis, dynamic add});
}

/// @nodoc
class _$StockReorderLensInfoCopyWithImpl<
  $Res,
  $Val extends StockReorderLensInfo
>
    implements $StockReorderLensInfoCopyWith<$Res> {
  _$StockReorderLensInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StockReorderLensInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sph = freezed,
    Object? cyl = freezed,
    Object? eye = freezed,
    Object? axis = freezed,
    Object? add = freezed,
  }) {
    return _then(
      _value.copyWith(
            sph: freezed == sph
                ? _value.sph
                : sph // ignore: cast_nullable_to_non_nullable
                      as dynamic,
            cyl: freezed == cyl
                ? _value.cyl
                : cyl // ignore: cast_nullable_to_non_nullable
                      as dynamic,
            eye: freezed == eye
                ? _value.eye
                : eye // ignore: cast_nullable_to_non_nullable
                      as String?,
            axis: freezed == axis
                ? _value.axis
                : axis // ignore: cast_nullable_to_non_nullable
                      as dynamic,
            add: freezed == add
                ? _value.add
                : add // ignore: cast_nullable_to_non_nullable
                      as dynamic,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StockReorderLensInfoImplCopyWith<$Res>
    implements $StockReorderLensInfoCopyWith<$Res> {
  factory _$$StockReorderLensInfoImplCopyWith(
    _$StockReorderLensInfoImpl value,
    $Res Function(_$StockReorderLensInfoImpl) then,
  ) = __$$StockReorderLensInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({dynamic sph, dynamic cyl, String? eye, dynamic axis, dynamic add});
}

/// @nodoc
class __$$StockReorderLensInfoImplCopyWithImpl<$Res>
    extends _$StockReorderLensInfoCopyWithImpl<$Res, _$StockReorderLensInfoImpl>
    implements _$$StockReorderLensInfoImplCopyWith<$Res> {
  __$$StockReorderLensInfoImplCopyWithImpl(
    _$StockReorderLensInfoImpl _value,
    $Res Function(_$StockReorderLensInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StockReorderLensInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sph = freezed,
    Object? cyl = freezed,
    Object? eye = freezed,
    Object? axis = freezed,
    Object? add = freezed,
  }) {
    return _then(
      _$StockReorderLensInfoImpl(
        sph: freezed == sph
            ? _value.sph
            : sph // ignore: cast_nullable_to_non_nullable
                  as dynamic,
        cyl: freezed == cyl
            ? _value.cyl
            : cyl // ignore: cast_nullable_to_non_nullable
                  as dynamic,
        eye: freezed == eye
            ? _value.eye
            : eye // ignore: cast_nullable_to_non_nullable
                  as String?,
        axis: freezed == axis
            ? _value.axis
            : axis // ignore: cast_nullable_to_non_nullable
                  as dynamic,
        add: freezed == add
            ? _value.add
            : add // ignore: cast_nullable_to_non_nullable
                  as dynamic,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StockReorderLensInfoImpl implements _StockReorderLensInfo {
  const _$StockReorderLensInfoImpl({
    this.sph,
    this.cyl,
    this.eye,
    this.axis,
    this.add,
  });

  factory _$StockReorderLensInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$StockReorderLensInfoImplFromJson(json);

  @override
  final dynamic sph;
  @override
  final dynamic cyl;
  @override
  final String? eye;
  @override
  final dynamic axis;
  @override
  final dynamic add;

  @override
  String toString() {
    return 'StockReorderLensInfo(sph: $sph, cyl: $cyl, eye: $eye, axis: $axis, add: $add)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockReorderLensInfoImpl &&
            const DeepCollectionEquality().equals(other.sph, sph) &&
            const DeepCollectionEquality().equals(other.cyl, cyl) &&
            (identical(other.eye, eye) || other.eye == eye) &&
            const DeepCollectionEquality().equals(other.axis, axis) &&
            const DeepCollectionEquality().equals(other.add, add));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(sph),
    const DeepCollectionEquality().hash(cyl),
    eye,
    const DeepCollectionEquality().hash(axis),
    const DeepCollectionEquality().hash(add),
  );

  /// Create a copy of StockReorderLensInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StockReorderLensInfoImplCopyWith<_$StockReorderLensInfoImpl>
  get copyWith =>
      __$$StockReorderLensInfoImplCopyWithImpl<_$StockReorderLensInfoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$StockReorderLensInfoImplToJson(this);
  }
}

abstract class _StockReorderLensInfo implements StockReorderLensInfo {
  const factory _StockReorderLensInfo({
    final dynamic sph,
    final dynamic cyl,
    final String? eye,
    final dynamic axis,
    final dynamic add,
  }) = _$StockReorderLensInfoImpl;

  factory _StockReorderLensInfo.fromJson(Map<String, dynamic> json) =
      _$StockReorderLensInfoImpl.fromJson;

  @override
  dynamic get sph;
  @override
  dynamic get cyl;
  @override
  String? get eye;
  @override
  dynamic get axis;
  @override
  dynamic get add;

  /// Create a copy of StockReorderLensInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StockReorderLensInfoImplCopyWith<_$StockReorderLensInfoImpl>
  get copyWith => throw _privateConstructorUsedError;
}

SaleItemGroupWiseItem _$SaleItemGroupWiseItemFromJson(
  Map<String, dynamic> json,
) {
  return _SaleItemGroupWiseItem.fromJson(json);
}

/// @nodoc
mixin _$SaleItemGroupWiseItem {
  String? get billNo => throw _privateConstructorUsedError;
  String? get date => throw _privateConstructorUsedError;
  String? get party => throw _privateConstructorUsedError;
  String? get productGroup => throw _privateConstructorUsedError;
  String? get productName => throw _privateConstructorUsedError;
  double get qty => throw _privateConstructorUsedError;
  double get prodPrice => throw _privateConstructorUsedError;
  double get prodDisPct => throw _privateConstructorUsedError;
  double get prodDisRs => throw _privateConstructorUsedError;
  double get otherDisPct => throw _privateConstructorUsedError;
  double get otherDisRs => throw _privateConstructorUsedError;
  double get prodValue => throw _privateConstructorUsedError;
  double get prodTxbleAmt => throw _privateConstructorUsedError;
  double get invoiceTotalAmt => throw _privateConstructorUsedError;
  double get cash => throw _privateConstructorUsedError;
  double get bank => throw _privateConstructorUsedError;

  /// Serializes this SaleItemGroupWiseItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SaleItemGroupWiseItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SaleItemGroupWiseItemCopyWith<SaleItemGroupWiseItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SaleItemGroupWiseItemCopyWith<$Res> {
  factory $SaleItemGroupWiseItemCopyWith(
    SaleItemGroupWiseItem value,
    $Res Function(SaleItemGroupWiseItem) then,
  ) = _$SaleItemGroupWiseItemCopyWithImpl<$Res, SaleItemGroupWiseItem>;
  @useResult
  $Res call({
    String? billNo,
    String? date,
    String? party,
    String? productGroup,
    String? productName,
    double qty,
    double prodPrice,
    double prodDisPct,
    double prodDisRs,
    double otherDisPct,
    double otherDisRs,
    double prodValue,
    double prodTxbleAmt,
    double invoiceTotalAmt,
    double cash,
    double bank,
  });
}

/// @nodoc
class _$SaleItemGroupWiseItemCopyWithImpl<
  $Res,
  $Val extends SaleItemGroupWiseItem
>
    implements $SaleItemGroupWiseItemCopyWith<$Res> {
  _$SaleItemGroupWiseItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SaleItemGroupWiseItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? billNo = freezed,
    Object? date = freezed,
    Object? party = freezed,
    Object? productGroup = freezed,
    Object? productName = freezed,
    Object? qty = null,
    Object? prodPrice = null,
    Object? prodDisPct = null,
    Object? prodDisRs = null,
    Object? otherDisPct = null,
    Object? otherDisRs = null,
    Object? prodValue = null,
    Object? prodTxbleAmt = null,
    Object? invoiceTotalAmt = null,
    Object? cash = null,
    Object? bank = null,
  }) {
    return _then(
      _value.copyWith(
            billNo: freezed == billNo
                ? _value.billNo
                : billNo // ignore: cast_nullable_to_non_nullable
                      as String?,
            date: freezed == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String?,
            party: freezed == party
                ? _value.party
                : party // ignore: cast_nullable_to_non_nullable
                      as String?,
            productGroup: freezed == productGroup
                ? _value.productGroup
                : productGroup // ignore: cast_nullable_to_non_nullable
                      as String?,
            productName: freezed == productName
                ? _value.productName
                : productName // ignore: cast_nullable_to_non_nullable
                      as String?,
            qty: null == qty
                ? _value.qty
                : qty // ignore: cast_nullable_to_non_nullable
                      as double,
            prodPrice: null == prodPrice
                ? _value.prodPrice
                : prodPrice // ignore: cast_nullable_to_non_nullable
                      as double,
            prodDisPct: null == prodDisPct
                ? _value.prodDisPct
                : prodDisPct // ignore: cast_nullable_to_non_nullable
                      as double,
            prodDisRs: null == prodDisRs
                ? _value.prodDisRs
                : prodDisRs // ignore: cast_nullable_to_non_nullable
                      as double,
            otherDisPct: null == otherDisPct
                ? _value.otherDisPct
                : otherDisPct // ignore: cast_nullable_to_non_nullable
                      as double,
            otherDisRs: null == otherDisRs
                ? _value.otherDisRs
                : otherDisRs // ignore: cast_nullable_to_non_nullable
                      as double,
            prodValue: null == prodValue
                ? _value.prodValue
                : prodValue // ignore: cast_nullable_to_non_nullable
                      as double,
            prodTxbleAmt: null == prodTxbleAmt
                ? _value.prodTxbleAmt
                : prodTxbleAmt // ignore: cast_nullable_to_non_nullable
                      as double,
            invoiceTotalAmt: null == invoiceTotalAmt
                ? _value.invoiceTotalAmt
                : invoiceTotalAmt // ignore: cast_nullable_to_non_nullable
                      as double,
            cash: null == cash
                ? _value.cash
                : cash // ignore: cast_nullable_to_non_nullable
                      as double,
            bank: null == bank
                ? _value.bank
                : bank // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SaleItemGroupWiseItemImplCopyWith<$Res>
    implements $SaleItemGroupWiseItemCopyWith<$Res> {
  factory _$$SaleItemGroupWiseItemImplCopyWith(
    _$SaleItemGroupWiseItemImpl value,
    $Res Function(_$SaleItemGroupWiseItemImpl) then,
  ) = __$$SaleItemGroupWiseItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? billNo,
    String? date,
    String? party,
    String? productGroup,
    String? productName,
    double qty,
    double prodPrice,
    double prodDisPct,
    double prodDisRs,
    double otherDisPct,
    double otherDisRs,
    double prodValue,
    double prodTxbleAmt,
    double invoiceTotalAmt,
    double cash,
    double bank,
  });
}

/// @nodoc
class __$$SaleItemGroupWiseItemImplCopyWithImpl<$Res>
    extends
        _$SaleItemGroupWiseItemCopyWithImpl<$Res, _$SaleItemGroupWiseItemImpl>
    implements _$$SaleItemGroupWiseItemImplCopyWith<$Res> {
  __$$SaleItemGroupWiseItemImplCopyWithImpl(
    _$SaleItemGroupWiseItemImpl _value,
    $Res Function(_$SaleItemGroupWiseItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SaleItemGroupWiseItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? billNo = freezed,
    Object? date = freezed,
    Object? party = freezed,
    Object? productGroup = freezed,
    Object? productName = freezed,
    Object? qty = null,
    Object? prodPrice = null,
    Object? prodDisPct = null,
    Object? prodDisRs = null,
    Object? otherDisPct = null,
    Object? otherDisRs = null,
    Object? prodValue = null,
    Object? prodTxbleAmt = null,
    Object? invoiceTotalAmt = null,
    Object? cash = null,
    Object? bank = null,
  }) {
    return _then(
      _$SaleItemGroupWiseItemImpl(
        billNo: freezed == billNo
            ? _value.billNo
            : billNo // ignore: cast_nullable_to_non_nullable
                  as String?,
        date: freezed == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String?,
        party: freezed == party
            ? _value.party
            : party // ignore: cast_nullable_to_non_nullable
                  as String?,
        productGroup: freezed == productGroup
            ? _value.productGroup
            : productGroup // ignore: cast_nullable_to_non_nullable
                  as String?,
        productName: freezed == productName
            ? _value.productName
            : productName // ignore: cast_nullable_to_non_nullable
                  as String?,
        qty: null == qty
            ? _value.qty
            : qty // ignore: cast_nullable_to_non_nullable
                  as double,
        prodPrice: null == prodPrice
            ? _value.prodPrice
            : prodPrice // ignore: cast_nullable_to_non_nullable
                  as double,
        prodDisPct: null == prodDisPct
            ? _value.prodDisPct
            : prodDisPct // ignore: cast_nullable_to_non_nullable
                  as double,
        prodDisRs: null == prodDisRs
            ? _value.prodDisRs
            : prodDisRs // ignore: cast_nullable_to_non_nullable
                  as double,
        otherDisPct: null == otherDisPct
            ? _value.otherDisPct
            : otherDisPct // ignore: cast_nullable_to_non_nullable
                  as double,
        otherDisRs: null == otherDisRs
            ? _value.otherDisRs
            : otherDisRs // ignore: cast_nullable_to_non_nullable
                  as double,
        prodValue: null == prodValue
            ? _value.prodValue
            : prodValue // ignore: cast_nullable_to_non_nullable
                  as double,
        prodTxbleAmt: null == prodTxbleAmt
            ? _value.prodTxbleAmt
            : prodTxbleAmt // ignore: cast_nullable_to_non_nullable
                  as double,
        invoiceTotalAmt: null == invoiceTotalAmt
            ? _value.invoiceTotalAmt
            : invoiceTotalAmt // ignore: cast_nullable_to_non_nullable
                  as double,
        cash: null == cash
            ? _value.cash
            : cash // ignore: cast_nullable_to_non_nullable
                  as double,
        bank: null == bank
            ? _value.bank
            : bank // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SaleItemGroupWiseItemImpl implements _SaleItemGroupWiseItem {
  const _$SaleItemGroupWiseItemImpl({
    this.billNo,
    this.date,
    this.party,
    this.productGroup,
    this.productName,
    this.qty = 0,
    this.prodPrice = 0,
    this.prodDisPct = 0,
    this.prodDisRs = 0,
    this.otherDisPct = 0,
    this.otherDisRs = 0,
    this.prodValue = 0,
    this.prodTxbleAmt = 0,
    this.invoiceTotalAmt = 0,
    this.cash = 0,
    this.bank = 0,
  });

  factory _$SaleItemGroupWiseItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$SaleItemGroupWiseItemImplFromJson(json);

  @override
  final String? billNo;
  @override
  final String? date;
  @override
  final String? party;
  @override
  final String? productGroup;
  @override
  final String? productName;
  @override
  @JsonKey()
  final double qty;
  @override
  @JsonKey()
  final double prodPrice;
  @override
  @JsonKey()
  final double prodDisPct;
  @override
  @JsonKey()
  final double prodDisRs;
  @override
  @JsonKey()
  final double otherDisPct;
  @override
  @JsonKey()
  final double otherDisRs;
  @override
  @JsonKey()
  final double prodValue;
  @override
  @JsonKey()
  final double prodTxbleAmt;
  @override
  @JsonKey()
  final double invoiceTotalAmt;
  @override
  @JsonKey()
  final double cash;
  @override
  @JsonKey()
  final double bank;

  @override
  String toString() {
    return 'SaleItemGroupWiseItem(billNo: $billNo, date: $date, party: $party, productGroup: $productGroup, productName: $productName, qty: $qty, prodPrice: $prodPrice, prodDisPct: $prodDisPct, prodDisRs: $prodDisRs, otherDisPct: $otherDisPct, otherDisRs: $otherDisRs, prodValue: $prodValue, prodTxbleAmt: $prodTxbleAmt, invoiceTotalAmt: $invoiceTotalAmt, cash: $cash, bank: $bank)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SaleItemGroupWiseItemImpl &&
            (identical(other.billNo, billNo) || other.billNo == billNo) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.party, party) || other.party == party) &&
            (identical(other.productGroup, productGroup) ||
                other.productGroup == productGroup) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.qty, qty) || other.qty == qty) &&
            (identical(other.prodPrice, prodPrice) ||
                other.prodPrice == prodPrice) &&
            (identical(other.prodDisPct, prodDisPct) ||
                other.prodDisPct == prodDisPct) &&
            (identical(other.prodDisRs, prodDisRs) ||
                other.prodDisRs == prodDisRs) &&
            (identical(other.otherDisPct, otherDisPct) ||
                other.otherDisPct == otherDisPct) &&
            (identical(other.otherDisRs, otherDisRs) ||
                other.otherDisRs == otherDisRs) &&
            (identical(other.prodValue, prodValue) ||
                other.prodValue == prodValue) &&
            (identical(other.prodTxbleAmt, prodTxbleAmt) ||
                other.prodTxbleAmt == prodTxbleAmt) &&
            (identical(other.invoiceTotalAmt, invoiceTotalAmt) ||
                other.invoiceTotalAmt == invoiceTotalAmt) &&
            (identical(other.cash, cash) || other.cash == cash) &&
            (identical(other.bank, bank) || other.bank == bank));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    billNo,
    date,
    party,
    productGroup,
    productName,
    qty,
    prodPrice,
    prodDisPct,
    prodDisRs,
    otherDisPct,
    otherDisRs,
    prodValue,
    prodTxbleAmt,
    invoiceTotalAmt,
    cash,
    bank,
  );

  /// Create a copy of SaleItemGroupWiseItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SaleItemGroupWiseItemImplCopyWith<_$SaleItemGroupWiseItemImpl>
  get copyWith =>
      __$$SaleItemGroupWiseItemImplCopyWithImpl<_$SaleItemGroupWiseItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SaleItemGroupWiseItemImplToJson(this);
  }
}

abstract class _SaleItemGroupWiseItem implements SaleItemGroupWiseItem {
  const factory _SaleItemGroupWiseItem({
    final String? billNo,
    final String? date,
    final String? party,
    final String? productGroup,
    final String? productName,
    final double qty,
    final double prodPrice,
    final double prodDisPct,
    final double prodDisRs,
    final double otherDisPct,
    final double otherDisRs,
    final double prodValue,
    final double prodTxbleAmt,
    final double invoiceTotalAmt,
    final double cash,
    final double bank,
  }) = _$SaleItemGroupWiseItemImpl;

  factory _SaleItemGroupWiseItem.fromJson(Map<String, dynamic> json) =
      _$SaleItemGroupWiseItemImpl.fromJson;

  @override
  String? get billNo;
  @override
  String? get date;
  @override
  String? get party;
  @override
  String? get productGroup;
  @override
  String? get productName;
  @override
  double get qty;
  @override
  double get prodPrice;
  @override
  double get prodDisPct;
  @override
  double get prodDisRs;
  @override
  double get otherDisPct;
  @override
  double get otherDisRs;
  @override
  double get prodValue;
  @override
  double get prodTxbleAmt;
  @override
  double get invoiceTotalAmt;
  @override
  double get cash;
  @override
  double get bank;

  /// Create a copy of SaleItemGroupWiseItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SaleItemGroupWiseItemImplCopyWith<_$SaleItemGroupWiseItemImpl>
  get copyWith => throw _privateConstructorUsedError;
}

BookedByReportItem _$BookedByReportItemFromJson(Map<String, dynamic> json) {
  return _BookedByReportItem.fromJson(json);
}

/// @nodoc
mixin _$BookedByReportItem {
  String? get id => throw _privateConstructorUsedError;
  String? get orderDate => throw _privateConstructorUsedError;
  String? get orderTime => throw _privateConstructorUsedError;
  String? get billNo => throw _privateConstructorUsedError;
  String? get bookedBy => throw _privateConstructorUsedError;
  String? get itemName => throw _privateConstructorUsedError;
  String? get eye => throw _privateConstructorUsedError;
  dynamic get sph => throw _privateConstructorUsedError;
  dynamic get cyl => throw _privateConstructorUsedError;
  dynamic get axis => throw _privateConstructorUsedError;
  dynamic get add => throw _privateConstructorUsedError;
  int get qty => throw _privateConstructorUsedError;
  double get netAmount => throw _privateConstructorUsedError;
  String? get partyName => throw _privateConstructorUsedError;
  String? get remark => throw _privateConstructorUsedError;
  String? get orderType => throw _privateConstructorUsedError;

  /// Serializes this BookedByReportItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookedByReportItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookedByReportItemCopyWith<BookedByReportItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookedByReportItemCopyWith<$Res> {
  factory $BookedByReportItemCopyWith(
    BookedByReportItem value,
    $Res Function(BookedByReportItem) then,
  ) = _$BookedByReportItemCopyWithImpl<$Res, BookedByReportItem>;
  @useResult
  $Res call({
    String? id,
    String? orderDate,
    String? orderTime,
    String? billNo,
    String? bookedBy,
    String? itemName,
    String? eye,
    dynamic sph,
    dynamic cyl,
    dynamic axis,
    dynamic add,
    int qty,
    double netAmount,
    String? partyName,
    String? remark,
    String? orderType,
  });
}

/// @nodoc
class _$BookedByReportItemCopyWithImpl<$Res, $Val extends BookedByReportItem>
    implements $BookedByReportItemCopyWith<$Res> {
  _$BookedByReportItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookedByReportItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? orderDate = freezed,
    Object? orderTime = freezed,
    Object? billNo = freezed,
    Object? bookedBy = freezed,
    Object? itemName = freezed,
    Object? eye = freezed,
    Object? sph = freezed,
    Object? cyl = freezed,
    Object? axis = freezed,
    Object? add = freezed,
    Object? qty = null,
    Object? netAmount = null,
    Object? partyName = freezed,
    Object? remark = freezed,
    Object? orderType = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            orderDate: freezed == orderDate
                ? _value.orderDate
                : orderDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            orderTime: freezed == orderTime
                ? _value.orderTime
                : orderTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            billNo: freezed == billNo
                ? _value.billNo
                : billNo // ignore: cast_nullable_to_non_nullable
                      as String?,
            bookedBy: freezed == bookedBy
                ? _value.bookedBy
                : bookedBy // ignore: cast_nullable_to_non_nullable
                      as String?,
            itemName: freezed == itemName
                ? _value.itemName
                : itemName // ignore: cast_nullable_to_non_nullable
                      as String?,
            eye: freezed == eye
                ? _value.eye
                : eye // ignore: cast_nullable_to_non_nullable
                      as String?,
            sph: freezed == sph
                ? _value.sph
                : sph // ignore: cast_nullable_to_non_nullable
                      as dynamic,
            cyl: freezed == cyl
                ? _value.cyl
                : cyl // ignore: cast_nullable_to_non_nullable
                      as dynamic,
            axis: freezed == axis
                ? _value.axis
                : axis // ignore: cast_nullable_to_non_nullable
                      as dynamic,
            add: freezed == add
                ? _value.add
                : add // ignore: cast_nullable_to_non_nullable
                      as dynamic,
            qty: null == qty
                ? _value.qty
                : qty // ignore: cast_nullable_to_non_nullable
                      as int,
            netAmount: null == netAmount
                ? _value.netAmount
                : netAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            partyName: freezed == partyName
                ? _value.partyName
                : partyName // ignore: cast_nullable_to_non_nullable
                      as String?,
            remark: freezed == remark
                ? _value.remark
                : remark // ignore: cast_nullable_to_non_nullable
                      as String?,
            orderType: freezed == orderType
                ? _value.orderType
                : orderType // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BookedByReportItemImplCopyWith<$Res>
    implements $BookedByReportItemCopyWith<$Res> {
  factory _$$BookedByReportItemImplCopyWith(
    _$BookedByReportItemImpl value,
    $Res Function(_$BookedByReportItemImpl) then,
  ) = __$$BookedByReportItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? id,
    String? orderDate,
    String? orderTime,
    String? billNo,
    String? bookedBy,
    String? itemName,
    String? eye,
    dynamic sph,
    dynamic cyl,
    dynamic axis,
    dynamic add,
    int qty,
    double netAmount,
    String? partyName,
    String? remark,
    String? orderType,
  });
}

/// @nodoc
class __$$BookedByReportItemImplCopyWithImpl<$Res>
    extends _$BookedByReportItemCopyWithImpl<$Res, _$BookedByReportItemImpl>
    implements _$$BookedByReportItemImplCopyWith<$Res> {
  __$$BookedByReportItemImplCopyWithImpl(
    _$BookedByReportItemImpl _value,
    $Res Function(_$BookedByReportItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookedByReportItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? orderDate = freezed,
    Object? orderTime = freezed,
    Object? billNo = freezed,
    Object? bookedBy = freezed,
    Object? itemName = freezed,
    Object? eye = freezed,
    Object? sph = freezed,
    Object? cyl = freezed,
    Object? axis = freezed,
    Object? add = freezed,
    Object? qty = null,
    Object? netAmount = null,
    Object? partyName = freezed,
    Object? remark = freezed,
    Object? orderType = freezed,
  }) {
    return _then(
      _$BookedByReportItemImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        orderDate: freezed == orderDate
            ? _value.orderDate
            : orderDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        orderTime: freezed == orderTime
            ? _value.orderTime
            : orderTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        billNo: freezed == billNo
            ? _value.billNo
            : billNo // ignore: cast_nullable_to_non_nullable
                  as String?,
        bookedBy: freezed == bookedBy
            ? _value.bookedBy
            : bookedBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        itemName: freezed == itemName
            ? _value.itemName
            : itemName // ignore: cast_nullable_to_non_nullable
                  as String?,
        eye: freezed == eye
            ? _value.eye
            : eye // ignore: cast_nullable_to_non_nullable
                  as String?,
        sph: freezed == sph
            ? _value.sph
            : sph // ignore: cast_nullable_to_non_nullable
                  as dynamic,
        cyl: freezed == cyl
            ? _value.cyl
            : cyl // ignore: cast_nullable_to_non_nullable
                  as dynamic,
        axis: freezed == axis
            ? _value.axis
            : axis // ignore: cast_nullable_to_non_nullable
                  as dynamic,
        add: freezed == add
            ? _value.add
            : add // ignore: cast_nullable_to_non_nullable
                  as dynamic,
        qty: null == qty
            ? _value.qty
            : qty // ignore: cast_nullable_to_non_nullable
                  as int,
        netAmount: null == netAmount
            ? _value.netAmount
            : netAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        partyName: freezed == partyName
            ? _value.partyName
            : partyName // ignore: cast_nullable_to_non_nullable
                  as String?,
        remark: freezed == remark
            ? _value.remark
            : remark // ignore: cast_nullable_to_non_nullable
                  as String?,
        orderType: freezed == orderType
            ? _value.orderType
            : orderType // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BookedByReportItemImpl implements _BookedByReportItem {
  const _$BookedByReportItemImpl({
    this.id,
    this.orderDate,
    this.orderTime,
    this.billNo,
    this.bookedBy,
    this.itemName,
    this.eye,
    this.sph,
    this.cyl,
    this.axis,
    this.add,
    this.qty = 0,
    this.netAmount = 0.0,
    this.partyName,
    this.remark,
    this.orderType,
  });

  factory _$BookedByReportItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookedByReportItemImplFromJson(json);

  @override
  final String? id;
  @override
  final String? orderDate;
  @override
  final String? orderTime;
  @override
  final String? billNo;
  @override
  final String? bookedBy;
  @override
  final String? itemName;
  @override
  final String? eye;
  @override
  final dynamic sph;
  @override
  final dynamic cyl;
  @override
  final dynamic axis;
  @override
  final dynamic add;
  @override
  @JsonKey()
  final int qty;
  @override
  @JsonKey()
  final double netAmount;
  @override
  final String? partyName;
  @override
  final String? remark;
  @override
  final String? orderType;

  @override
  String toString() {
    return 'BookedByReportItem(id: $id, orderDate: $orderDate, orderTime: $orderTime, billNo: $billNo, bookedBy: $bookedBy, itemName: $itemName, eye: $eye, sph: $sph, cyl: $cyl, axis: $axis, add: $add, qty: $qty, netAmount: $netAmount, partyName: $partyName, remark: $remark, orderType: $orderType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookedByReportItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderDate, orderDate) ||
                other.orderDate == orderDate) &&
            (identical(other.orderTime, orderTime) ||
                other.orderTime == orderTime) &&
            (identical(other.billNo, billNo) || other.billNo == billNo) &&
            (identical(other.bookedBy, bookedBy) ||
                other.bookedBy == bookedBy) &&
            (identical(other.itemName, itemName) ||
                other.itemName == itemName) &&
            (identical(other.eye, eye) || other.eye == eye) &&
            const DeepCollectionEquality().equals(other.sph, sph) &&
            const DeepCollectionEquality().equals(other.cyl, cyl) &&
            const DeepCollectionEquality().equals(other.axis, axis) &&
            const DeepCollectionEquality().equals(other.add, add) &&
            (identical(other.qty, qty) || other.qty == qty) &&
            (identical(other.netAmount, netAmount) ||
                other.netAmount == netAmount) &&
            (identical(other.partyName, partyName) ||
                other.partyName == partyName) &&
            (identical(other.remark, remark) || other.remark == remark) &&
            (identical(other.orderType, orderType) ||
                other.orderType == orderType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    orderDate,
    orderTime,
    billNo,
    bookedBy,
    itemName,
    eye,
    const DeepCollectionEquality().hash(sph),
    const DeepCollectionEquality().hash(cyl),
    const DeepCollectionEquality().hash(axis),
    const DeepCollectionEquality().hash(add),
    qty,
    netAmount,
    partyName,
    remark,
    orderType,
  );

  /// Create a copy of BookedByReportItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookedByReportItemImplCopyWith<_$BookedByReportItemImpl> get copyWith =>
      __$$BookedByReportItemImplCopyWithImpl<_$BookedByReportItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BookedByReportItemImplToJson(this);
  }
}

abstract class _BookedByReportItem implements BookedByReportItem {
  const factory _BookedByReportItem({
    final String? id,
    final String? orderDate,
    final String? orderTime,
    final String? billNo,
    final String? bookedBy,
    final String? itemName,
    final String? eye,
    final dynamic sph,
    final dynamic cyl,
    final dynamic axis,
    final dynamic add,
    final int qty,
    final double netAmount,
    final String? partyName,
    final String? remark,
    final String? orderType,
  }) = _$BookedByReportItemImpl;

  factory _BookedByReportItem.fromJson(Map<String, dynamic> json) =
      _$BookedByReportItemImpl.fromJson;

  @override
  String? get id;
  @override
  String? get orderDate;
  @override
  String? get orderTime;
  @override
  String? get billNo;
  @override
  String? get bookedBy;
  @override
  String? get itemName;
  @override
  String? get eye;
  @override
  dynamic get sph;
  @override
  dynamic get cyl;
  @override
  dynamic get axis;
  @override
  dynamic get add;
  @override
  int get qty;
  @override
  double get netAmount;
  @override
  String? get partyName;
  @override
  String? get remark;
  @override
  String? get orderType;

  /// Create a copy of BookedByReportItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookedByReportItemImplCopyWith<_$BookedByReportItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CustomerItemSalesResponse _$CustomerItemSalesResponseFromJson(
  Map<String, dynamic> json,
) {
  return _CustomerItemSalesResponse.fromJson(json);
}

/// @nodoc
mixin _$CustomerItemSalesResponse {
  bool get success => throw _privateConstructorUsedError;
  CustomerItemSalesSummary get summary => throw _privateConstructorUsedError;
  List<CustomerItemSalesItem> get data => throw _privateConstructorUsedError;

  /// Serializes this CustomerItemSalesResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomerItemSalesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerItemSalesResponseCopyWith<CustomerItemSalesResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerItemSalesResponseCopyWith<$Res> {
  factory $CustomerItemSalesResponseCopyWith(
    CustomerItemSalesResponse value,
    $Res Function(CustomerItemSalesResponse) then,
  ) = _$CustomerItemSalesResponseCopyWithImpl<$Res, CustomerItemSalesResponse>;
  @useResult
  $Res call({
    bool success,
    CustomerItemSalesSummary summary,
    List<CustomerItemSalesItem> data,
  });

  $CustomerItemSalesSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class _$CustomerItemSalesResponseCopyWithImpl<
  $Res,
  $Val extends CustomerItemSalesResponse
>
    implements $CustomerItemSalesResponseCopyWith<$Res> {
  _$CustomerItemSalesResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerItemSalesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? summary = null,
    Object? data = null,
  }) {
    return _then(
      _value.copyWith(
            success: null == success
                ? _value.success
                : success // ignore: cast_nullable_to_non_nullable
                      as bool,
            summary: null == summary
                ? _value.summary
                : summary // ignore: cast_nullable_to_non_nullable
                      as CustomerItemSalesSummary,
            data: null == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as List<CustomerItemSalesItem>,
          )
          as $Val,
    );
  }

  /// Create a copy of CustomerItemSalesResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CustomerItemSalesSummaryCopyWith<$Res> get summary {
    return $CustomerItemSalesSummaryCopyWith<$Res>(_value.summary, (value) {
      return _then(_value.copyWith(summary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CustomerItemSalesResponseImplCopyWith<$Res>
    implements $CustomerItemSalesResponseCopyWith<$Res> {
  factory _$$CustomerItemSalesResponseImplCopyWith(
    _$CustomerItemSalesResponseImpl value,
    $Res Function(_$CustomerItemSalesResponseImpl) then,
  ) = __$$CustomerItemSalesResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool success,
    CustomerItemSalesSummary summary,
    List<CustomerItemSalesItem> data,
  });

  @override
  $CustomerItemSalesSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class __$$CustomerItemSalesResponseImplCopyWithImpl<$Res>
    extends
        _$CustomerItemSalesResponseCopyWithImpl<
          $Res,
          _$CustomerItemSalesResponseImpl
        >
    implements _$$CustomerItemSalesResponseImplCopyWith<$Res> {
  __$$CustomerItemSalesResponseImplCopyWithImpl(
    _$CustomerItemSalesResponseImpl _value,
    $Res Function(_$CustomerItemSalesResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerItemSalesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? summary = null,
    Object? data = null,
  }) {
    return _then(
      _$CustomerItemSalesResponseImpl(
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        summary: null == summary
            ? _value.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as CustomerItemSalesSummary,
        data: null == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as List<CustomerItemSalesItem>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomerItemSalesResponseImpl implements _CustomerItemSalesResponse {
  const _$CustomerItemSalesResponseImpl({
    required this.success,
    required this.summary,
    required final List<CustomerItemSalesItem> data,
  }) : _data = data;

  factory _$CustomerItemSalesResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerItemSalesResponseImplFromJson(json);

  @override
  final bool success;
  @override
  final CustomerItemSalesSummary summary;
  final List<CustomerItemSalesItem> _data;
  @override
  List<CustomerItemSalesItem> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  String toString() {
    return 'CustomerItemSalesResponse(success: $success, summary: $summary, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerItemSalesResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    success,
    summary,
    const DeepCollectionEquality().hash(_data),
  );

  /// Create a copy of CustomerItemSalesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerItemSalesResponseImplCopyWith<_$CustomerItemSalesResponseImpl>
  get copyWith =>
      __$$CustomerItemSalesResponseImplCopyWithImpl<
        _$CustomerItemSalesResponseImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerItemSalesResponseImplToJson(this);
  }
}

abstract class _CustomerItemSalesResponse implements CustomerItemSalesResponse {
  const factory _CustomerItemSalesResponse({
    required final bool success,
    required final CustomerItemSalesSummary summary,
    required final List<CustomerItemSalesItem> data,
  }) = _$CustomerItemSalesResponseImpl;

  factory _CustomerItemSalesResponse.fromJson(Map<String, dynamic> json) =
      _$CustomerItemSalesResponseImpl.fromJson;

  @override
  bool get success;
  @override
  CustomerItemSalesSummary get summary;
  @override
  List<CustomerItemSalesItem> get data;

  /// Create a copy of CustomerItemSalesResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerItemSalesResponseImplCopyWith<_$CustomerItemSalesResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}

CustomerItemSalesSummary _$CustomerItemSalesSummaryFromJson(
  Map<String, dynamic> json,
) {
  return _CustomerItemSalesSummary.fromJson(json);
}

/// @nodoc
mixin _$CustomerItemSalesSummary {
  int get totalItems => throw _privateConstructorUsedError;
  double get totalQty => throw _privateConstructorUsedError;
  double get totalRevenue => throw _privateConstructorUsedError;
  int? get totalOrders => throw _privateConstructorUsedError;

  /// Serializes this CustomerItemSalesSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomerItemSalesSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerItemSalesSummaryCopyWith<CustomerItemSalesSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerItemSalesSummaryCopyWith<$Res> {
  factory $CustomerItemSalesSummaryCopyWith(
    CustomerItemSalesSummary value,
    $Res Function(CustomerItemSalesSummary) then,
  ) = _$CustomerItemSalesSummaryCopyWithImpl<$Res, CustomerItemSalesSummary>;
  @useResult
  $Res call({
    int totalItems,
    double totalQty,
    double totalRevenue,
    int? totalOrders,
  });
}

/// @nodoc
class _$CustomerItemSalesSummaryCopyWithImpl<
  $Res,
  $Val extends CustomerItemSalesSummary
>
    implements $CustomerItemSalesSummaryCopyWith<$Res> {
  _$CustomerItemSalesSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerItemSalesSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalItems = null,
    Object? totalQty = null,
    Object? totalRevenue = null,
    Object? totalOrders = freezed,
  }) {
    return _then(
      _value.copyWith(
            totalItems: null == totalItems
                ? _value.totalItems
                : totalItems // ignore: cast_nullable_to_non_nullable
                      as int,
            totalQty: null == totalQty
                ? _value.totalQty
                : totalQty // ignore: cast_nullable_to_non_nullable
                      as double,
            totalRevenue: null == totalRevenue
                ? _value.totalRevenue
                : totalRevenue // ignore: cast_nullable_to_non_nullable
                      as double,
            totalOrders: freezed == totalOrders
                ? _value.totalOrders
                : totalOrders // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CustomerItemSalesSummaryImplCopyWith<$Res>
    implements $CustomerItemSalesSummaryCopyWith<$Res> {
  factory _$$CustomerItemSalesSummaryImplCopyWith(
    _$CustomerItemSalesSummaryImpl value,
    $Res Function(_$CustomerItemSalesSummaryImpl) then,
  ) = __$$CustomerItemSalesSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalItems,
    double totalQty,
    double totalRevenue,
    int? totalOrders,
  });
}

/// @nodoc
class __$$CustomerItemSalesSummaryImplCopyWithImpl<$Res>
    extends
        _$CustomerItemSalesSummaryCopyWithImpl<
          $Res,
          _$CustomerItemSalesSummaryImpl
        >
    implements _$$CustomerItemSalesSummaryImplCopyWith<$Res> {
  __$$CustomerItemSalesSummaryImplCopyWithImpl(
    _$CustomerItemSalesSummaryImpl _value,
    $Res Function(_$CustomerItemSalesSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerItemSalesSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalItems = null,
    Object? totalQty = null,
    Object? totalRevenue = null,
    Object? totalOrders = freezed,
  }) {
    return _then(
      _$CustomerItemSalesSummaryImpl(
        totalItems: null == totalItems
            ? _value.totalItems
            : totalItems // ignore: cast_nullable_to_non_nullable
                  as int,
        totalQty: null == totalQty
            ? _value.totalQty
            : totalQty // ignore: cast_nullable_to_non_nullable
                  as double,
        totalRevenue: null == totalRevenue
            ? _value.totalRevenue
            : totalRevenue // ignore: cast_nullable_to_non_nullable
                  as double,
        totalOrders: freezed == totalOrders
            ? _value.totalOrders
            : totalOrders // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomerItemSalesSummaryImpl implements _CustomerItemSalesSummary {
  const _$CustomerItemSalesSummaryImpl({
    required this.totalItems,
    required this.totalQty,
    required this.totalRevenue,
    this.totalOrders,
  });

  factory _$CustomerItemSalesSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerItemSalesSummaryImplFromJson(json);

  @override
  final int totalItems;
  @override
  final double totalQty;
  @override
  final double totalRevenue;
  @override
  final int? totalOrders;

  @override
  String toString() {
    return 'CustomerItemSalesSummary(totalItems: $totalItems, totalQty: $totalQty, totalRevenue: $totalRevenue, totalOrders: $totalOrders)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerItemSalesSummaryImpl &&
            (identical(other.totalItems, totalItems) ||
                other.totalItems == totalItems) &&
            (identical(other.totalQty, totalQty) ||
                other.totalQty == totalQty) &&
            (identical(other.totalRevenue, totalRevenue) ||
                other.totalRevenue == totalRevenue) &&
            (identical(other.totalOrders, totalOrders) ||
                other.totalOrders == totalOrders));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, totalItems, totalQty, totalRevenue, totalOrders);

  /// Create a copy of CustomerItemSalesSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerItemSalesSummaryImplCopyWith<_$CustomerItemSalesSummaryImpl>
  get copyWith =>
      __$$CustomerItemSalesSummaryImplCopyWithImpl<
        _$CustomerItemSalesSummaryImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerItemSalesSummaryImplToJson(this);
  }
}

abstract class _CustomerItemSalesSummary implements CustomerItemSalesSummary {
  const factory _CustomerItemSalesSummary({
    required final int totalItems,
    required final double totalQty,
    required final double totalRevenue,
    final int? totalOrders,
  }) = _$CustomerItemSalesSummaryImpl;

  factory _CustomerItemSalesSummary.fromJson(Map<String, dynamic> json) =
      _$CustomerItemSalesSummaryImpl.fromJson;

  @override
  int get totalItems;
  @override
  double get totalQty;
  @override
  double get totalRevenue;
  @override
  int? get totalOrders;

  /// Create a copy of CustomerItemSalesSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerItemSalesSummaryImplCopyWith<_$CustomerItemSalesSummaryImpl>
  get copyWith => throw _privateConstructorUsedError;
}

CustomerItemSalesItem _$CustomerItemSalesItemFromJson(
  Map<String, dynamic> json,
) {
  return _CustomerItemSalesItem.fromJson(json);
}

/// @nodoc
mixin _$CustomerItemSalesItem {
  String get itemName => throw _privateConstructorUsedError;
  String? get eye => throw _privateConstructorUsedError;
  dynamic get sph => throw _privateConstructorUsedError;
  dynamic get cyl => throw _privateConstructorUsedError;
  dynamic get axis => throw _privateConstructorUsedError;
  dynamic get add => throw _privateConstructorUsedError;
  double get totalQty => throw _privateConstructorUsedError;
  double get totalRevenue => throw _privateConstructorUsedError;
  String? get lastSoldDate => throw _privateConstructorUsedError;
  int get orderCount => throw _privateConstructorUsedError;

  /// Serializes this CustomerItemSalesItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomerItemSalesItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerItemSalesItemCopyWith<CustomerItemSalesItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerItemSalesItemCopyWith<$Res> {
  factory $CustomerItemSalesItemCopyWith(
    CustomerItemSalesItem value,
    $Res Function(CustomerItemSalesItem) then,
  ) = _$CustomerItemSalesItemCopyWithImpl<$Res, CustomerItemSalesItem>;
  @useResult
  $Res call({
    String itemName,
    String? eye,
    dynamic sph,
    dynamic cyl,
    dynamic axis,
    dynamic add,
    double totalQty,
    double totalRevenue,
    String? lastSoldDate,
    int orderCount,
  });
}

/// @nodoc
class _$CustomerItemSalesItemCopyWithImpl<
  $Res,
  $Val extends CustomerItemSalesItem
>
    implements $CustomerItemSalesItemCopyWith<$Res> {
  _$CustomerItemSalesItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerItemSalesItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemName = null,
    Object? eye = freezed,
    Object? sph = freezed,
    Object? cyl = freezed,
    Object? axis = freezed,
    Object? add = freezed,
    Object? totalQty = null,
    Object? totalRevenue = null,
    Object? lastSoldDate = freezed,
    Object? orderCount = null,
  }) {
    return _then(
      _value.copyWith(
            itemName: null == itemName
                ? _value.itemName
                : itemName // ignore: cast_nullable_to_non_nullable
                      as String,
            eye: freezed == eye
                ? _value.eye
                : eye // ignore: cast_nullable_to_non_nullable
                      as String?,
            sph: freezed == sph
                ? _value.sph
                : sph // ignore: cast_nullable_to_non_nullable
                      as dynamic,
            cyl: freezed == cyl
                ? _value.cyl
                : cyl // ignore: cast_nullable_to_non_nullable
                      as dynamic,
            axis: freezed == axis
                ? _value.axis
                : axis // ignore: cast_nullable_to_non_nullable
                      as dynamic,
            add: freezed == add
                ? _value.add
                : add // ignore: cast_nullable_to_non_nullable
                      as dynamic,
            totalQty: null == totalQty
                ? _value.totalQty
                : totalQty // ignore: cast_nullable_to_non_nullable
                      as double,
            totalRevenue: null == totalRevenue
                ? _value.totalRevenue
                : totalRevenue // ignore: cast_nullable_to_non_nullable
                      as double,
            lastSoldDate: freezed == lastSoldDate
                ? _value.lastSoldDate
                : lastSoldDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            orderCount: null == orderCount
                ? _value.orderCount
                : orderCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CustomerItemSalesItemImplCopyWith<$Res>
    implements $CustomerItemSalesItemCopyWith<$Res> {
  factory _$$CustomerItemSalesItemImplCopyWith(
    _$CustomerItemSalesItemImpl value,
    $Res Function(_$CustomerItemSalesItemImpl) then,
  ) = __$$CustomerItemSalesItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String itemName,
    String? eye,
    dynamic sph,
    dynamic cyl,
    dynamic axis,
    dynamic add,
    double totalQty,
    double totalRevenue,
    String? lastSoldDate,
    int orderCount,
  });
}

/// @nodoc
class __$$CustomerItemSalesItemImplCopyWithImpl<$Res>
    extends
        _$CustomerItemSalesItemCopyWithImpl<$Res, _$CustomerItemSalesItemImpl>
    implements _$$CustomerItemSalesItemImplCopyWith<$Res> {
  __$$CustomerItemSalesItemImplCopyWithImpl(
    _$CustomerItemSalesItemImpl _value,
    $Res Function(_$CustomerItemSalesItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerItemSalesItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemName = null,
    Object? eye = freezed,
    Object? sph = freezed,
    Object? cyl = freezed,
    Object? axis = freezed,
    Object? add = freezed,
    Object? totalQty = null,
    Object? totalRevenue = null,
    Object? lastSoldDate = freezed,
    Object? orderCount = null,
  }) {
    return _then(
      _$CustomerItemSalesItemImpl(
        itemName: null == itemName
            ? _value.itemName
            : itemName // ignore: cast_nullable_to_non_nullable
                  as String,
        eye: freezed == eye
            ? _value.eye
            : eye // ignore: cast_nullable_to_non_nullable
                  as String?,
        sph: freezed == sph
            ? _value.sph
            : sph // ignore: cast_nullable_to_non_nullable
                  as dynamic,
        cyl: freezed == cyl
            ? _value.cyl
            : cyl // ignore: cast_nullable_to_non_nullable
                  as dynamic,
        axis: freezed == axis
            ? _value.axis
            : axis // ignore: cast_nullable_to_non_nullable
                  as dynamic,
        add: freezed == add
            ? _value.add
            : add // ignore: cast_nullable_to_non_nullable
                  as dynamic,
        totalQty: null == totalQty
            ? _value.totalQty
            : totalQty // ignore: cast_nullable_to_non_nullable
                  as double,
        totalRevenue: null == totalRevenue
            ? _value.totalRevenue
            : totalRevenue // ignore: cast_nullable_to_non_nullable
                  as double,
        lastSoldDate: freezed == lastSoldDate
            ? _value.lastSoldDate
            : lastSoldDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        orderCount: null == orderCount
            ? _value.orderCount
            : orderCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomerItemSalesItemImpl implements _CustomerItemSalesItem {
  const _$CustomerItemSalesItemImpl({
    required this.itemName,
    this.eye,
    this.sph,
    this.cyl,
    this.axis,
    this.add,
    required this.totalQty,
    required this.totalRevenue,
    this.lastSoldDate,
    required this.orderCount,
  });

  factory _$CustomerItemSalesItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerItemSalesItemImplFromJson(json);

  @override
  final String itemName;
  @override
  final String? eye;
  @override
  final dynamic sph;
  @override
  final dynamic cyl;
  @override
  final dynamic axis;
  @override
  final dynamic add;
  @override
  final double totalQty;
  @override
  final double totalRevenue;
  @override
  final String? lastSoldDate;
  @override
  final int orderCount;

  @override
  String toString() {
    return 'CustomerItemSalesItem(itemName: $itemName, eye: $eye, sph: $sph, cyl: $cyl, axis: $axis, add: $add, totalQty: $totalQty, totalRevenue: $totalRevenue, lastSoldDate: $lastSoldDate, orderCount: $orderCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerItemSalesItemImpl &&
            (identical(other.itemName, itemName) ||
                other.itemName == itemName) &&
            (identical(other.eye, eye) || other.eye == eye) &&
            const DeepCollectionEquality().equals(other.sph, sph) &&
            const DeepCollectionEquality().equals(other.cyl, cyl) &&
            const DeepCollectionEquality().equals(other.axis, axis) &&
            const DeepCollectionEquality().equals(other.add, add) &&
            (identical(other.totalQty, totalQty) ||
                other.totalQty == totalQty) &&
            (identical(other.totalRevenue, totalRevenue) ||
                other.totalRevenue == totalRevenue) &&
            (identical(other.lastSoldDate, lastSoldDate) ||
                other.lastSoldDate == lastSoldDate) &&
            (identical(other.orderCount, orderCount) ||
                other.orderCount == orderCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    itemName,
    eye,
    const DeepCollectionEquality().hash(sph),
    const DeepCollectionEquality().hash(cyl),
    const DeepCollectionEquality().hash(axis),
    const DeepCollectionEquality().hash(add),
    totalQty,
    totalRevenue,
    lastSoldDate,
    orderCount,
  );

  /// Create a copy of CustomerItemSalesItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerItemSalesItemImplCopyWith<_$CustomerItemSalesItemImpl>
  get copyWith =>
      __$$CustomerItemSalesItemImplCopyWithImpl<_$CustomerItemSalesItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerItemSalesItemImplToJson(this);
  }
}

abstract class _CustomerItemSalesItem implements CustomerItemSalesItem {
  const factory _CustomerItemSalesItem({
    required final String itemName,
    final String? eye,
    final dynamic sph,
    final dynamic cyl,
    final dynamic axis,
    final dynamic add,
    required final double totalQty,
    required final double totalRevenue,
    final String? lastSoldDate,
    required final int orderCount,
  }) = _$CustomerItemSalesItemImpl;

  factory _CustomerItemSalesItem.fromJson(Map<String, dynamic> json) =
      _$CustomerItemSalesItemImpl.fromJson;

  @override
  String get itemName;
  @override
  String? get eye;
  @override
  dynamic get sph;
  @override
  dynamic get cyl;
  @override
  dynamic get axis;
  @override
  dynamic get add;
  @override
  double get totalQty;
  @override
  double get totalRevenue;
  @override
  String? get lastSoldDate;
  @override
  int get orderCount;

  /// Create a copy of CustomerItemSalesItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerItemSalesItemImplCopyWith<_$CustomerItemSalesItemImpl>
  get copyWith => throw _privateConstructorUsedError;
}

ItemStockSummaryResponse _$ItemStockSummaryResponseFromJson(
  Map<String, dynamic> json,
) {
  return _ItemStockSummaryResponse.fromJson(json);
}

/// @nodoc
mixin _$ItemStockSummaryResponse {
  bool get success => throw _privateConstructorUsedError;
  List<ItemStockSummaryItem> get data => throw _privateConstructorUsedError;

  /// Serializes this ItemStockSummaryResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ItemStockSummaryResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ItemStockSummaryResponseCopyWith<ItemStockSummaryResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItemStockSummaryResponseCopyWith<$Res> {
  factory $ItemStockSummaryResponseCopyWith(
    ItemStockSummaryResponse value,
    $Res Function(ItemStockSummaryResponse) then,
  ) = _$ItemStockSummaryResponseCopyWithImpl<$Res, ItemStockSummaryResponse>;
  @useResult
  $Res call({bool success, List<ItemStockSummaryItem> data});
}

/// @nodoc
class _$ItemStockSummaryResponseCopyWithImpl<
  $Res,
  $Val extends ItemStockSummaryResponse
>
    implements $ItemStockSummaryResponseCopyWith<$Res> {
  _$ItemStockSummaryResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ItemStockSummaryResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? success = null, Object? data = null}) {
    return _then(
      _value.copyWith(
            success: null == success
                ? _value.success
                : success // ignore: cast_nullable_to_non_nullable
                      as bool,
            data: null == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as List<ItemStockSummaryItem>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ItemStockSummaryResponseImplCopyWith<$Res>
    implements $ItemStockSummaryResponseCopyWith<$Res> {
  factory _$$ItemStockSummaryResponseImplCopyWith(
    _$ItemStockSummaryResponseImpl value,
    $Res Function(_$ItemStockSummaryResponseImpl) then,
  ) = __$$ItemStockSummaryResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, List<ItemStockSummaryItem> data});
}

/// @nodoc
class __$$ItemStockSummaryResponseImplCopyWithImpl<$Res>
    extends
        _$ItemStockSummaryResponseCopyWithImpl<
          $Res,
          _$ItemStockSummaryResponseImpl
        >
    implements _$$ItemStockSummaryResponseImplCopyWith<$Res> {
  __$$ItemStockSummaryResponseImplCopyWithImpl(
    _$ItemStockSummaryResponseImpl _value,
    $Res Function(_$ItemStockSummaryResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ItemStockSummaryResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? success = null, Object? data = null}) {
    return _then(
      _$ItemStockSummaryResponseImpl(
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        data: null == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as List<ItemStockSummaryItem>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ItemStockSummaryResponseImpl implements _ItemStockSummaryResponse {
  const _$ItemStockSummaryResponseImpl({
    required this.success,
    required final List<ItemStockSummaryItem> data,
  }) : _data = data;

  factory _$ItemStockSummaryResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ItemStockSummaryResponseImplFromJson(json);

  @override
  final bool success;
  final List<ItemStockSummaryItem> _data;
  @override
  List<ItemStockSummaryItem> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  String toString() {
    return 'ItemStockSummaryResponse(success: $success, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ItemStockSummaryResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    success,
    const DeepCollectionEquality().hash(_data),
  );

  /// Create a copy of ItemStockSummaryResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ItemStockSummaryResponseImplCopyWith<_$ItemStockSummaryResponseImpl>
  get copyWith =>
      __$$ItemStockSummaryResponseImplCopyWithImpl<
        _$ItemStockSummaryResponseImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ItemStockSummaryResponseImplToJson(this);
  }
}

abstract class _ItemStockSummaryResponse implements ItemStockSummaryResponse {
  const factory _ItemStockSummaryResponse({
    required final bool success,
    required final List<ItemStockSummaryItem> data,
  }) = _$ItemStockSummaryResponseImpl;

  factory _ItemStockSummaryResponse.fromJson(Map<String, dynamic> json) =
      _$ItemStockSummaryResponseImpl.fromJson;

  @override
  bool get success;
  @override
  List<ItemStockSummaryItem> get data;

  /// Create a copy of ItemStockSummaryResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ItemStockSummaryResponseImplCopyWith<_$ItemStockSummaryResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}

ItemStockSummaryItem _$ItemStockSummaryItemFromJson(Map<String, dynamic> json) {
  return _ItemStockSummaryItem.fromJson(json);
}

/// @nodoc
mixin _$ItemStockSummaryItem {
  String get productName => throw _privateConstructorUsedError;
  String get groupName => throw _privateConstructorUsedError;
  double get totalStockQty => throw _privateConstructorUsedError;
  double get avgPurchasePrice => throw _privateConstructorUsedError;
  double get avgSellingPrice => throw _privateConstructorUsedError;
  double get totalPurchaseValue => throw _privateConstructorUsedError;
  double get totalSellingValue => throw _privateConstructorUsedError;
  double get expectedProfit => throw _privateConstructorUsedError;
  double? get liveProfit => throw _privateConstructorUsedError;
  double get turnover => throw _privateConstructorUsedError;
  int get combinationCount => throw _privateConstructorUsedError;

  /// Serializes this ItemStockSummaryItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ItemStockSummaryItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ItemStockSummaryItemCopyWith<ItemStockSummaryItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItemStockSummaryItemCopyWith<$Res> {
  factory $ItemStockSummaryItemCopyWith(
    ItemStockSummaryItem value,
    $Res Function(ItemStockSummaryItem) then,
  ) = _$ItemStockSummaryItemCopyWithImpl<$Res, ItemStockSummaryItem>;
  @useResult
  $Res call({
    String productName,
    String groupName,
    double totalStockQty,
    double avgPurchasePrice,
    double avgSellingPrice,
    double totalPurchaseValue,
    double totalSellingValue,
    double expectedProfit,
    double? liveProfit,
    double turnover,
    int combinationCount,
  });
}

/// @nodoc
class _$ItemStockSummaryItemCopyWithImpl<
  $Res,
  $Val extends ItemStockSummaryItem
>
    implements $ItemStockSummaryItemCopyWith<$Res> {
  _$ItemStockSummaryItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ItemStockSummaryItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productName = null,
    Object? groupName = null,
    Object? totalStockQty = null,
    Object? avgPurchasePrice = null,
    Object? avgSellingPrice = null,
    Object? totalPurchaseValue = null,
    Object? totalSellingValue = null,
    Object? expectedProfit = null,
    Object? liveProfit = freezed,
    Object? turnover = null,
    Object? combinationCount = null,
  }) {
    return _then(
      _value.copyWith(
            productName: null == productName
                ? _value.productName
                : productName // ignore: cast_nullable_to_non_nullable
                      as String,
            groupName: null == groupName
                ? _value.groupName
                : groupName // ignore: cast_nullable_to_non_nullable
                      as String,
            totalStockQty: null == totalStockQty
                ? _value.totalStockQty
                : totalStockQty // ignore: cast_nullable_to_non_nullable
                      as double,
            avgPurchasePrice: null == avgPurchasePrice
                ? _value.avgPurchasePrice
                : avgPurchasePrice // ignore: cast_nullable_to_non_nullable
                      as double,
            avgSellingPrice: null == avgSellingPrice
                ? _value.avgSellingPrice
                : avgSellingPrice // ignore: cast_nullable_to_non_nullable
                      as double,
            totalPurchaseValue: null == totalPurchaseValue
                ? _value.totalPurchaseValue
                : totalPurchaseValue // ignore: cast_nullable_to_non_nullable
                      as double,
            totalSellingValue: null == totalSellingValue
                ? _value.totalSellingValue
                : totalSellingValue // ignore: cast_nullable_to_non_nullable
                      as double,
            expectedProfit: null == expectedProfit
                ? _value.expectedProfit
                : expectedProfit // ignore: cast_nullable_to_non_nullable
                      as double,
            liveProfit: freezed == liveProfit
                ? _value.liveProfit
                : liveProfit // ignore: cast_nullable_to_non_nullable
                      as double?,
            turnover: null == turnover
                ? _value.turnover
                : turnover // ignore: cast_nullable_to_non_nullable
                      as double,
            combinationCount: null == combinationCount
                ? _value.combinationCount
                : combinationCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ItemStockSummaryItemImplCopyWith<$Res>
    implements $ItemStockSummaryItemCopyWith<$Res> {
  factory _$$ItemStockSummaryItemImplCopyWith(
    _$ItemStockSummaryItemImpl value,
    $Res Function(_$ItemStockSummaryItemImpl) then,
  ) = __$$ItemStockSummaryItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String productName,
    String groupName,
    double totalStockQty,
    double avgPurchasePrice,
    double avgSellingPrice,
    double totalPurchaseValue,
    double totalSellingValue,
    double expectedProfit,
    double? liveProfit,
    double turnover,
    int combinationCount,
  });
}

/// @nodoc
class __$$ItemStockSummaryItemImplCopyWithImpl<$Res>
    extends _$ItemStockSummaryItemCopyWithImpl<$Res, _$ItemStockSummaryItemImpl>
    implements _$$ItemStockSummaryItemImplCopyWith<$Res> {
  __$$ItemStockSummaryItemImplCopyWithImpl(
    _$ItemStockSummaryItemImpl _value,
    $Res Function(_$ItemStockSummaryItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ItemStockSummaryItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productName = null,
    Object? groupName = null,
    Object? totalStockQty = null,
    Object? avgPurchasePrice = null,
    Object? avgSellingPrice = null,
    Object? totalPurchaseValue = null,
    Object? totalSellingValue = null,
    Object? expectedProfit = null,
    Object? liveProfit = freezed,
    Object? turnover = null,
    Object? combinationCount = null,
  }) {
    return _then(
      _$ItemStockSummaryItemImpl(
        productName: null == productName
            ? _value.productName
            : productName // ignore: cast_nullable_to_non_nullable
                  as String,
        groupName: null == groupName
            ? _value.groupName
            : groupName // ignore: cast_nullable_to_non_nullable
                  as String,
        totalStockQty: null == totalStockQty
            ? _value.totalStockQty
            : totalStockQty // ignore: cast_nullable_to_non_nullable
                  as double,
        avgPurchasePrice: null == avgPurchasePrice
            ? _value.avgPurchasePrice
            : avgPurchasePrice // ignore: cast_nullable_to_non_nullable
                  as double,
        avgSellingPrice: null == avgSellingPrice
            ? _value.avgSellingPrice
            : avgSellingPrice // ignore: cast_nullable_to_non_nullable
                  as double,
        totalPurchaseValue: null == totalPurchaseValue
            ? _value.totalPurchaseValue
            : totalPurchaseValue // ignore: cast_nullable_to_non_nullable
                  as double,
        totalSellingValue: null == totalSellingValue
            ? _value.totalSellingValue
            : totalSellingValue // ignore: cast_nullable_to_non_nullable
                  as double,
        expectedProfit: null == expectedProfit
            ? _value.expectedProfit
            : expectedProfit // ignore: cast_nullable_to_non_nullable
                  as double,
        liveProfit: freezed == liveProfit
            ? _value.liveProfit
            : liveProfit // ignore: cast_nullable_to_non_nullable
                  as double?,
        turnover: null == turnover
            ? _value.turnover
            : turnover // ignore: cast_nullable_to_non_nullable
                  as double,
        combinationCount: null == combinationCount
            ? _value.combinationCount
            : combinationCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ItemStockSummaryItemImpl implements _ItemStockSummaryItem {
  const _$ItemStockSummaryItemImpl({
    required this.productName,
    required this.groupName,
    this.totalStockQty = 0,
    this.avgPurchasePrice = 0,
    this.avgSellingPrice = 0,
    this.totalPurchaseValue = 0,
    this.totalSellingValue = 0,
    this.expectedProfit = 0,
    this.liveProfit = 0.0,
    this.turnover = 0,
    this.combinationCount = 0,
  });

  factory _$ItemStockSummaryItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ItemStockSummaryItemImplFromJson(json);

  @override
  final String productName;
  @override
  final String groupName;
  @override
  @JsonKey()
  final double totalStockQty;
  @override
  @JsonKey()
  final double avgPurchasePrice;
  @override
  @JsonKey()
  final double avgSellingPrice;
  @override
  @JsonKey()
  final double totalPurchaseValue;
  @override
  @JsonKey()
  final double totalSellingValue;
  @override
  @JsonKey()
  final double expectedProfit;
  @override
  @JsonKey()
  final double? liveProfit;
  @override
  @JsonKey()
  final double turnover;
  @override
  @JsonKey()
  final int combinationCount;

  @override
  String toString() {
    return 'ItemStockSummaryItem(productName: $productName, groupName: $groupName, totalStockQty: $totalStockQty, avgPurchasePrice: $avgPurchasePrice, avgSellingPrice: $avgSellingPrice, totalPurchaseValue: $totalPurchaseValue, totalSellingValue: $totalSellingValue, expectedProfit: $expectedProfit, liveProfit: $liveProfit, turnover: $turnover, combinationCount: $combinationCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ItemStockSummaryItemImpl &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.groupName, groupName) ||
                other.groupName == groupName) &&
            (identical(other.totalStockQty, totalStockQty) ||
                other.totalStockQty == totalStockQty) &&
            (identical(other.avgPurchasePrice, avgPurchasePrice) ||
                other.avgPurchasePrice == avgPurchasePrice) &&
            (identical(other.avgSellingPrice, avgSellingPrice) ||
                other.avgSellingPrice == avgSellingPrice) &&
            (identical(other.totalPurchaseValue, totalPurchaseValue) ||
                other.totalPurchaseValue == totalPurchaseValue) &&
            (identical(other.totalSellingValue, totalSellingValue) ||
                other.totalSellingValue == totalSellingValue) &&
            (identical(other.expectedProfit, expectedProfit) ||
                other.expectedProfit == expectedProfit) &&
            (identical(other.liveProfit, liveProfit) ||
                other.liveProfit == liveProfit) &&
            (identical(other.turnover, turnover) ||
                other.turnover == turnover) &&
            (identical(other.combinationCount, combinationCount) ||
                other.combinationCount == combinationCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    productName,
    groupName,
    totalStockQty,
    avgPurchasePrice,
    avgSellingPrice,
    totalPurchaseValue,
    totalSellingValue,
    expectedProfit,
    liveProfit,
    turnover,
    combinationCount,
  );

  /// Create a copy of ItemStockSummaryItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ItemStockSummaryItemImplCopyWith<_$ItemStockSummaryItemImpl>
  get copyWith =>
      __$$ItemStockSummaryItemImplCopyWithImpl<_$ItemStockSummaryItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ItemStockSummaryItemImplToJson(this);
  }
}

abstract class _ItemStockSummaryItem implements ItemStockSummaryItem {
  const factory _ItemStockSummaryItem({
    required final String productName,
    required final String groupName,
    final double totalStockQty,
    final double avgPurchasePrice,
    final double avgSellingPrice,
    final double totalPurchaseValue,
    final double totalSellingValue,
    final double expectedProfit,
    final double? liveProfit,
    final double turnover,
    final int combinationCount,
  }) = _$ItemStockSummaryItemImpl;

  factory _ItemStockSummaryItem.fromJson(Map<String, dynamic> json) =
      _$ItemStockSummaryItemImpl.fromJson;

  @override
  String get productName;
  @override
  String get groupName;
  @override
  double get totalStockQty;
  @override
  double get avgPurchasePrice;
  @override
  double get avgSellingPrice;
  @override
  double get totalPurchaseValue;
  @override
  double get totalSellingValue;
  @override
  double get expectedProfit;
  @override
  double? get liveProfit;
  @override
  double get turnover;
  @override
  int get combinationCount;

  /// Create a copy of ItemStockSummaryItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ItemStockSummaryItemImplCopyWith<_$ItemStockSummaryItemImpl>
  get copyWith => throw _privateConstructorUsedError;
}
