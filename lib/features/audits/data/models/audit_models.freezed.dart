// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audit_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

StockAuditItem _$StockAuditItemFromJson(Map<String, dynamic> json) {
  return _StockAuditItem.fromJson(json);
}

/// @nodoc
mixin _$StockAuditItem {
  String get productName => throw _privateConstructorUsedError;
  String get groupName => throw _privateConstructorUsedError;
  double get systemStock => throw _privateConstructorUsedError;
  double get physicalStock => throw _privateConstructorUsedError;
  double get variance => throw _privateConstructorUsedError;
  String? get barcode => throw _privateConstructorUsedError;
  StockAuditLensInfo? get lensInfo => throw _privateConstructorUsedError;
  bool get isVerified => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;

  /// Serializes this StockAuditItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StockAuditItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StockAuditItemCopyWith<StockAuditItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockAuditItemCopyWith<$Res> {
  factory $StockAuditItemCopyWith(
    StockAuditItem value,
    $Res Function(StockAuditItem) then,
  ) = _$StockAuditItemCopyWithImpl<$Res, StockAuditItem>;
  @useResult
  $Res call({
    String productName,
    String groupName,
    double systemStock,
    double physicalStock,
    double variance,
    String? barcode,
    StockAuditLensInfo? lensInfo,
    bool isVerified,
    String? location,
  });

  $StockAuditLensInfoCopyWith<$Res>? get lensInfo;
}

/// @nodoc
class _$StockAuditItemCopyWithImpl<$Res, $Val extends StockAuditItem>
    implements $StockAuditItemCopyWith<$Res> {
  _$StockAuditItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StockAuditItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productName = null,
    Object? groupName = null,
    Object? systemStock = null,
    Object? physicalStock = null,
    Object? variance = null,
    Object? barcode = freezed,
    Object? lensInfo = freezed,
    Object? isVerified = null,
    Object? location = freezed,
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
            systemStock: null == systemStock
                ? _value.systemStock
                : systemStock // ignore: cast_nullable_to_non_nullable
                      as double,
            physicalStock: null == physicalStock
                ? _value.physicalStock
                : physicalStock // ignore: cast_nullable_to_non_nullable
                      as double,
            variance: null == variance
                ? _value.variance
                : variance // ignore: cast_nullable_to_non_nullable
                      as double,
            barcode: freezed == barcode
                ? _value.barcode
                : barcode // ignore: cast_nullable_to_non_nullable
                      as String?,
            lensInfo: freezed == lensInfo
                ? _value.lensInfo
                : lensInfo // ignore: cast_nullable_to_non_nullable
                      as StockAuditLensInfo?,
            isVerified: null == isVerified
                ? _value.isVerified
                : isVerified // ignore: cast_nullable_to_non_nullable
                      as bool,
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of StockAuditItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StockAuditLensInfoCopyWith<$Res>? get lensInfo {
    if (_value.lensInfo == null) {
      return null;
    }

    return $StockAuditLensInfoCopyWith<$Res>(_value.lensInfo!, (value) {
      return _then(_value.copyWith(lensInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StockAuditItemImplCopyWith<$Res>
    implements $StockAuditItemCopyWith<$Res> {
  factory _$$StockAuditItemImplCopyWith(
    _$StockAuditItemImpl value,
    $Res Function(_$StockAuditItemImpl) then,
  ) = __$$StockAuditItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String productName,
    String groupName,
    double systemStock,
    double physicalStock,
    double variance,
    String? barcode,
    StockAuditLensInfo? lensInfo,
    bool isVerified,
    String? location,
  });

  @override
  $StockAuditLensInfoCopyWith<$Res>? get lensInfo;
}

/// @nodoc
class __$$StockAuditItemImplCopyWithImpl<$Res>
    extends _$StockAuditItemCopyWithImpl<$Res, _$StockAuditItemImpl>
    implements _$$StockAuditItemImplCopyWith<$Res> {
  __$$StockAuditItemImplCopyWithImpl(
    _$StockAuditItemImpl _value,
    $Res Function(_$StockAuditItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StockAuditItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productName = null,
    Object? groupName = null,
    Object? systemStock = null,
    Object? physicalStock = null,
    Object? variance = null,
    Object? barcode = freezed,
    Object? lensInfo = freezed,
    Object? isVerified = null,
    Object? location = freezed,
  }) {
    return _then(
      _$StockAuditItemImpl(
        productName: null == productName
            ? _value.productName
            : productName // ignore: cast_nullable_to_non_nullable
                  as String,
        groupName: null == groupName
            ? _value.groupName
            : groupName // ignore: cast_nullable_to_non_nullable
                  as String,
        systemStock: null == systemStock
            ? _value.systemStock
            : systemStock // ignore: cast_nullable_to_non_nullable
                  as double,
        physicalStock: null == physicalStock
            ? _value.physicalStock
            : physicalStock // ignore: cast_nullable_to_non_nullable
                  as double,
        variance: null == variance
            ? _value.variance
            : variance // ignore: cast_nullable_to_non_nullable
                  as double,
        barcode: freezed == barcode
            ? _value.barcode
            : barcode // ignore: cast_nullable_to_non_nullable
                  as String?,
        lensInfo: freezed == lensInfo
            ? _value.lensInfo
            : lensInfo // ignore: cast_nullable_to_non_nullable
                  as StockAuditLensInfo?,
        isVerified: null == isVerified
            ? _value.isVerified
            : isVerified // ignore: cast_nullable_to_non_nullable
                  as bool,
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StockAuditItemImpl implements _StockAuditItem {
  const _$StockAuditItemImpl({
    required this.productName,
    required this.groupName,
    required this.systemStock,
    this.physicalStock = 0.0,
    this.variance = 0.0,
    this.barcode,
    this.lensInfo,
    this.isVerified = false,
    this.location,
  });

  factory _$StockAuditItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$StockAuditItemImplFromJson(json);

  @override
  final String productName;
  @override
  final String groupName;
  @override
  final double systemStock;
  @override
  @JsonKey()
  final double physicalStock;
  @override
  @JsonKey()
  final double variance;
  @override
  final String? barcode;
  @override
  final StockAuditLensInfo? lensInfo;
  @override
  @JsonKey()
  final bool isVerified;
  @override
  final String? location;

  @override
  String toString() {
    return 'StockAuditItem(productName: $productName, groupName: $groupName, systemStock: $systemStock, physicalStock: $physicalStock, variance: $variance, barcode: $barcode, lensInfo: $lensInfo, isVerified: $isVerified, location: $location)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockAuditItemImpl &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.groupName, groupName) ||
                other.groupName == groupName) &&
            (identical(other.systemStock, systemStock) ||
                other.systemStock == systemStock) &&
            (identical(other.physicalStock, physicalStock) ||
                other.physicalStock == physicalStock) &&
            (identical(other.variance, variance) ||
                other.variance == variance) &&
            (identical(other.barcode, barcode) || other.barcode == barcode) &&
            (identical(other.lensInfo, lensInfo) ||
                other.lensInfo == lensInfo) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.location, location) ||
                other.location == location));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    productName,
    groupName,
    systemStock,
    physicalStock,
    variance,
    barcode,
    lensInfo,
    isVerified,
    location,
  );

  /// Create a copy of StockAuditItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StockAuditItemImplCopyWith<_$StockAuditItemImpl> get copyWith =>
      __$$StockAuditItemImplCopyWithImpl<_$StockAuditItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$StockAuditItemImplToJson(this);
  }
}

abstract class _StockAuditItem implements StockAuditItem {
  const factory _StockAuditItem({
    required final String productName,
    required final String groupName,
    required final double systemStock,
    final double physicalStock,
    final double variance,
    final String? barcode,
    final StockAuditLensInfo? lensInfo,
    final bool isVerified,
    final String? location,
  }) = _$StockAuditItemImpl;

  factory _StockAuditItem.fromJson(Map<String, dynamic> json) =
      _$StockAuditItemImpl.fromJson;

  @override
  String get productName;
  @override
  String get groupName;
  @override
  double get systemStock;
  @override
  double get physicalStock;
  @override
  double get variance;
  @override
  String? get barcode;
  @override
  StockAuditLensInfo? get lensInfo;
  @override
  bool get isVerified;
  @override
  String? get location;

  /// Create a copy of StockAuditItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StockAuditItemImplCopyWith<_$StockAuditItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StockAuditLensInfo _$StockAuditLensInfoFromJson(Map<String, dynamic> json) {
  return _StockAuditLensInfo.fromJson(json);
}

/// @nodoc
mixin _$StockAuditLensInfo {
  String? get sph => throw _privateConstructorUsedError;
  String? get cyl => throw _privateConstructorUsedError;
  String? get eye => throw _privateConstructorUsedError;
  String? get axis => throw _privateConstructorUsedError;
  String? get add => throw _privateConstructorUsedError;

  /// Serializes this StockAuditLensInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StockAuditLensInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StockAuditLensInfoCopyWith<StockAuditLensInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockAuditLensInfoCopyWith<$Res> {
  factory $StockAuditLensInfoCopyWith(
    StockAuditLensInfo value,
    $Res Function(StockAuditLensInfo) then,
  ) = _$StockAuditLensInfoCopyWithImpl<$Res, StockAuditLensInfo>;
  @useResult
  $Res call({String? sph, String? cyl, String? eye, String? axis, String? add});
}

/// @nodoc
class _$StockAuditLensInfoCopyWithImpl<$Res, $Val extends StockAuditLensInfo>
    implements $StockAuditLensInfoCopyWith<$Res> {
  _$StockAuditLensInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StockAuditLensInfo
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
                      as String?,
            cyl: freezed == cyl
                ? _value.cyl
                : cyl // ignore: cast_nullable_to_non_nullable
                      as String?,
            eye: freezed == eye
                ? _value.eye
                : eye // ignore: cast_nullable_to_non_nullable
                      as String?,
            axis: freezed == axis
                ? _value.axis
                : axis // ignore: cast_nullable_to_non_nullable
                      as String?,
            add: freezed == add
                ? _value.add
                : add // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StockAuditLensInfoImplCopyWith<$Res>
    implements $StockAuditLensInfoCopyWith<$Res> {
  factory _$$StockAuditLensInfoImplCopyWith(
    _$StockAuditLensInfoImpl value,
    $Res Function(_$StockAuditLensInfoImpl) then,
  ) = __$$StockAuditLensInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? sph, String? cyl, String? eye, String? axis, String? add});
}

/// @nodoc
class __$$StockAuditLensInfoImplCopyWithImpl<$Res>
    extends _$StockAuditLensInfoCopyWithImpl<$Res, _$StockAuditLensInfoImpl>
    implements _$$StockAuditLensInfoImplCopyWith<$Res> {
  __$$StockAuditLensInfoImplCopyWithImpl(
    _$StockAuditLensInfoImpl _value,
    $Res Function(_$StockAuditLensInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StockAuditLensInfo
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
      _$StockAuditLensInfoImpl(
        sph: freezed == sph
            ? _value.sph
            : sph // ignore: cast_nullable_to_non_nullable
                  as String?,
        cyl: freezed == cyl
            ? _value.cyl
            : cyl // ignore: cast_nullable_to_non_nullable
                  as String?,
        eye: freezed == eye
            ? _value.eye
            : eye // ignore: cast_nullable_to_non_nullable
                  as String?,
        axis: freezed == axis
            ? _value.axis
            : axis // ignore: cast_nullable_to_non_nullable
                  as String?,
        add: freezed == add
            ? _value.add
            : add // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StockAuditLensInfoImpl implements _StockAuditLensInfo {
  const _$StockAuditLensInfoImpl({
    this.sph,
    this.cyl,
    this.eye,
    this.axis,
    this.add,
  });

  factory _$StockAuditLensInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$StockAuditLensInfoImplFromJson(json);

  @override
  final String? sph;
  @override
  final String? cyl;
  @override
  final String? eye;
  @override
  final String? axis;
  @override
  final String? add;

  @override
  String toString() {
    return 'StockAuditLensInfo(sph: $sph, cyl: $cyl, eye: $eye, axis: $axis, add: $add)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockAuditLensInfoImpl &&
            (identical(other.sph, sph) || other.sph == sph) &&
            (identical(other.cyl, cyl) || other.cyl == cyl) &&
            (identical(other.eye, eye) || other.eye == eye) &&
            (identical(other.axis, axis) || other.axis == axis) &&
            (identical(other.add, add) || other.add == add));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, sph, cyl, eye, axis, add);

  /// Create a copy of StockAuditLensInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StockAuditLensInfoImplCopyWith<_$StockAuditLensInfoImpl> get copyWith =>
      __$$StockAuditLensInfoImplCopyWithImpl<_$StockAuditLensInfoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$StockAuditLensInfoImplToJson(this);
  }
}

abstract class _StockAuditLensInfo implements StockAuditLensInfo {
  const factory _StockAuditLensInfo({
    final String? sph,
    final String? cyl,
    final String? eye,
    final String? axis,
    final String? add,
  }) = _$StockAuditLensInfoImpl;

  factory _StockAuditLensInfo.fromJson(Map<String, dynamic> json) =
      _$StockAuditLensInfoImpl.fromJson;

  @override
  String? get sph;
  @override
  String? get cyl;
  @override
  String? get eye;
  @override
  String? get axis;
  @override
  String? get add;

  /// Create a copy of StockAuditLensInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StockAuditLensInfoImplCopyWith<_$StockAuditLensInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BillingAuditItem _$BillingAuditItemFromJson(Map<String, dynamic> json) {
  return _BillingAuditItem.fromJson(json);
}

/// @nodoc
mixin _$BillingAuditItem {
  String get invoiceNo => throw _privateConstructorUsedError;
  String get date => throw _privateConstructorUsedError;
  String get partyName => throw _privateConstructorUsedError;
  double get systemAmount => throw _privateConstructorUsedError;
  double get recalculatedAmount => throw _privateConstructorUsedError;
  double get variance => throw _privateConstructorUsedError;
  double get taxDiscrepancy => throw _privateConstructorUsedError;
  List<String> get issues => throw _privateConstructorUsedError;
  bool get isVerified => throw _privateConstructorUsedError;

  /// Serializes this BillingAuditItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BillingAuditItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BillingAuditItemCopyWith<BillingAuditItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BillingAuditItemCopyWith<$Res> {
  factory $BillingAuditItemCopyWith(
    BillingAuditItem value,
    $Res Function(BillingAuditItem) then,
  ) = _$BillingAuditItemCopyWithImpl<$Res, BillingAuditItem>;
  @useResult
  $Res call({
    String invoiceNo,
    String date,
    String partyName,
    double systemAmount,
    double recalculatedAmount,
    double variance,
    double taxDiscrepancy,
    List<String> issues,
    bool isVerified,
  });
}

/// @nodoc
class _$BillingAuditItemCopyWithImpl<$Res, $Val extends BillingAuditItem>
    implements $BillingAuditItemCopyWith<$Res> {
  _$BillingAuditItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BillingAuditItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? invoiceNo = null,
    Object? date = null,
    Object? partyName = null,
    Object? systemAmount = null,
    Object? recalculatedAmount = null,
    Object? variance = null,
    Object? taxDiscrepancy = null,
    Object? issues = null,
    Object? isVerified = null,
  }) {
    return _then(
      _value.copyWith(
            invoiceNo: null == invoiceNo
                ? _value.invoiceNo
                : invoiceNo // ignore: cast_nullable_to_non_nullable
                      as String,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String,
            partyName: null == partyName
                ? _value.partyName
                : partyName // ignore: cast_nullable_to_non_nullable
                      as String,
            systemAmount: null == systemAmount
                ? _value.systemAmount
                : systemAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            recalculatedAmount: null == recalculatedAmount
                ? _value.recalculatedAmount
                : recalculatedAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            variance: null == variance
                ? _value.variance
                : variance // ignore: cast_nullable_to_non_nullable
                      as double,
            taxDiscrepancy: null == taxDiscrepancy
                ? _value.taxDiscrepancy
                : taxDiscrepancy // ignore: cast_nullable_to_non_nullable
                      as double,
            issues: null == issues
                ? _value.issues
                : issues // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            isVerified: null == isVerified
                ? _value.isVerified
                : isVerified // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BillingAuditItemImplCopyWith<$Res>
    implements $BillingAuditItemCopyWith<$Res> {
  factory _$$BillingAuditItemImplCopyWith(
    _$BillingAuditItemImpl value,
    $Res Function(_$BillingAuditItemImpl) then,
  ) = __$$BillingAuditItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String invoiceNo,
    String date,
    String partyName,
    double systemAmount,
    double recalculatedAmount,
    double variance,
    double taxDiscrepancy,
    List<String> issues,
    bool isVerified,
  });
}

/// @nodoc
class __$$BillingAuditItemImplCopyWithImpl<$Res>
    extends _$BillingAuditItemCopyWithImpl<$Res, _$BillingAuditItemImpl>
    implements _$$BillingAuditItemImplCopyWith<$Res> {
  __$$BillingAuditItemImplCopyWithImpl(
    _$BillingAuditItemImpl _value,
    $Res Function(_$BillingAuditItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BillingAuditItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? invoiceNo = null,
    Object? date = null,
    Object? partyName = null,
    Object? systemAmount = null,
    Object? recalculatedAmount = null,
    Object? variance = null,
    Object? taxDiscrepancy = null,
    Object? issues = null,
    Object? isVerified = null,
  }) {
    return _then(
      _$BillingAuditItemImpl(
        invoiceNo: null == invoiceNo
            ? _value.invoiceNo
            : invoiceNo // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String,
        partyName: null == partyName
            ? _value.partyName
            : partyName // ignore: cast_nullable_to_non_nullable
                  as String,
        systemAmount: null == systemAmount
            ? _value.systemAmount
            : systemAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        recalculatedAmount: null == recalculatedAmount
            ? _value.recalculatedAmount
            : recalculatedAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        variance: null == variance
            ? _value.variance
            : variance // ignore: cast_nullable_to_non_nullable
                  as double,
        taxDiscrepancy: null == taxDiscrepancy
            ? _value.taxDiscrepancy
            : taxDiscrepancy // ignore: cast_nullable_to_non_nullable
                  as double,
        issues: null == issues
            ? _value._issues
            : issues // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        isVerified: null == isVerified
            ? _value.isVerified
            : isVerified // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BillingAuditItemImpl implements _BillingAuditItem {
  const _$BillingAuditItemImpl({
    required this.invoiceNo,
    required this.date,
    required this.partyName,
    this.systemAmount = 0.0,
    this.recalculatedAmount = 0.0,
    this.variance = 0.0,
    this.taxDiscrepancy = 0.0,
    final List<String> issues = const [],
    this.isVerified = false,
  }) : _issues = issues;

  factory _$BillingAuditItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$BillingAuditItemImplFromJson(json);

  @override
  final String invoiceNo;
  @override
  final String date;
  @override
  final String partyName;
  @override
  @JsonKey()
  final double systemAmount;
  @override
  @JsonKey()
  final double recalculatedAmount;
  @override
  @JsonKey()
  final double variance;
  @override
  @JsonKey()
  final double taxDiscrepancy;
  final List<String> _issues;
  @override
  @JsonKey()
  List<String> get issues {
    if (_issues is EqualUnmodifiableListView) return _issues;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_issues);
  }

  @override
  @JsonKey()
  final bool isVerified;

  @override
  String toString() {
    return 'BillingAuditItem(invoiceNo: $invoiceNo, date: $date, partyName: $partyName, systemAmount: $systemAmount, recalculatedAmount: $recalculatedAmount, variance: $variance, taxDiscrepancy: $taxDiscrepancy, issues: $issues, isVerified: $isVerified)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BillingAuditItemImpl &&
            (identical(other.invoiceNo, invoiceNo) ||
                other.invoiceNo == invoiceNo) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.partyName, partyName) ||
                other.partyName == partyName) &&
            (identical(other.systemAmount, systemAmount) ||
                other.systemAmount == systemAmount) &&
            (identical(other.recalculatedAmount, recalculatedAmount) ||
                other.recalculatedAmount == recalculatedAmount) &&
            (identical(other.variance, variance) ||
                other.variance == variance) &&
            (identical(other.taxDiscrepancy, taxDiscrepancy) ||
                other.taxDiscrepancy == taxDiscrepancy) &&
            const DeepCollectionEquality().equals(other._issues, _issues) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    invoiceNo,
    date,
    partyName,
    systemAmount,
    recalculatedAmount,
    variance,
    taxDiscrepancy,
    const DeepCollectionEquality().hash(_issues),
    isVerified,
  );

  /// Create a copy of BillingAuditItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BillingAuditItemImplCopyWith<_$BillingAuditItemImpl> get copyWith =>
      __$$BillingAuditItemImplCopyWithImpl<_$BillingAuditItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BillingAuditItemImplToJson(this);
  }
}

abstract class _BillingAuditItem implements BillingAuditItem {
  const factory _BillingAuditItem({
    required final String invoiceNo,
    required final String date,
    required final String partyName,
    final double systemAmount,
    final double recalculatedAmount,
    final double variance,
    final double taxDiscrepancy,
    final List<String> issues,
    final bool isVerified,
  }) = _$BillingAuditItemImpl;

  factory _BillingAuditItem.fromJson(Map<String, dynamic> json) =
      _$BillingAuditItemImpl.fromJson;

  @override
  String get invoiceNo;
  @override
  String get date;
  @override
  String get partyName;
  @override
  double get systemAmount;
  @override
  double get recalculatedAmount;
  @override
  double get variance;
  @override
  double get taxDiscrepancy;
  @override
  List<String> get issues;
  @override
  bool get isVerified;

  /// Create a copy of BillingAuditItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BillingAuditItemImplCopyWith<_$BillingAuditItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BankAuditItem _$BankAuditItemFromJson(Map<String, dynamic> json) {
  return _BankAuditItem.fromJson(json);
}

/// @nodoc
mixin _$BankAuditItem {
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;
  String get date => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError; // 'Dr' or 'Cr'
  String? get systemVoucherNo => throw _privateConstructorUsedError;
  bool get isReconciled => throw _privateConstructorUsedError;
  String? get bankName => throw _privateConstructorUsedError;
  String? get referenceNo => throw _privateConstructorUsedError;

  /// Serializes this BankAuditItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BankAuditItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BankAuditItemCopyWith<BankAuditItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BankAuditItemCopyWith<$Res> {
  factory $BankAuditItemCopyWith(
    BankAuditItem value,
    $Res Function(BankAuditItem) then,
  ) = _$BankAuditItemCopyWithImpl<$Res, BankAuditItem>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    String date,
    String description,
    double amount,
    String type,
    String? systemVoucherNo,
    bool isReconciled,
    String? bankName,
    String? referenceNo,
  });
}

/// @nodoc
class _$BankAuditItemCopyWithImpl<$Res, $Val extends BankAuditItem>
    implements $BankAuditItemCopyWith<$Res> {
  _$BankAuditItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BankAuditItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? date = null,
    Object? description = null,
    Object? amount = null,
    Object? type = null,
    Object? systemVoucherNo = freezed,
    Object? isReconciled = null,
    Object? bankName = freezed,
    Object? referenceNo = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            systemVoucherNo: freezed == systemVoucherNo
                ? _value.systemVoucherNo
                : systemVoucherNo // ignore: cast_nullable_to_non_nullable
                      as String?,
            isReconciled: null == isReconciled
                ? _value.isReconciled
                : isReconciled // ignore: cast_nullable_to_non_nullable
                      as bool,
            bankName: freezed == bankName
                ? _value.bankName
                : bankName // ignore: cast_nullable_to_non_nullable
                      as String?,
            referenceNo: freezed == referenceNo
                ? _value.referenceNo
                : referenceNo // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BankAuditItemImplCopyWith<$Res>
    implements $BankAuditItemCopyWith<$Res> {
  factory _$$BankAuditItemImplCopyWith(
    _$BankAuditItemImpl value,
    $Res Function(_$BankAuditItemImpl) then,
  ) = __$$BankAuditItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    String date,
    String description,
    double amount,
    String type,
    String? systemVoucherNo,
    bool isReconciled,
    String? bankName,
    String? referenceNo,
  });
}

/// @nodoc
class __$$BankAuditItemImplCopyWithImpl<$Res>
    extends _$BankAuditItemCopyWithImpl<$Res, _$BankAuditItemImpl>
    implements _$$BankAuditItemImplCopyWith<$Res> {
  __$$BankAuditItemImplCopyWithImpl(
    _$BankAuditItemImpl _value,
    $Res Function(_$BankAuditItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BankAuditItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? date = null,
    Object? description = null,
    Object? amount = null,
    Object? type = null,
    Object? systemVoucherNo = freezed,
    Object? isReconciled = null,
    Object? bankName = freezed,
    Object? referenceNo = freezed,
  }) {
    return _then(
      _$BankAuditItemImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        systemVoucherNo: freezed == systemVoucherNo
            ? _value.systemVoucherNo
            : systemVoucherNo // ignore: cast_nullable_to_non_nullable
                  as String?,
        isReconciled: null == isReconciled
            ? _value.isReconciled
            : isReconciled // ignore: cast_nullable_to_non_nullable
                  as bool,
        bankName: freezed == bankName
            ? _value.bankName
            : bankName // ignore: cast_nullable_to_non_nullable
                  as String?,
        referenceNo: freezed == referenceNo
            ? _value.referenceNo
            : referenceNo // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BankAuditItemImpl implements _BankAuditItem {
  const _$BankAuditItemImpl({
    @JsonKey(name: '_id') this.id,
    required this.date,
    required this.description,
    required this.amount,
    required this.type,
    this.systemVoucherNo,
    this.isReconciled = false,
    this.bankName,
    this.referenceNo,
  });

  factory _$BankAuditItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$BankAuditItemImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String? id;
  @override
  final String date;
  @override
  final String description;
  @override
  final double amount;
  @override
  final String type;
  // 'Dr' or 'Cr'
  @override
  final String? systemVoucherNo;
  @override
  @JsonKey()
  final bool isReconciled;
  @override
  final String? bankName;
  @override
  final String? referenceNo;

  @override
  String toString() {
    return 'BankAuditItem(id: $id, date: $date, description: $description, amount: $amount, type: $type, systemVoucherNo: $systemVoucherNo, isReconciled: $isReconciled, bankName: $bankName, referenceNo: $referenceNo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BankAuditItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.systemVoucherNo, systemVoucherNo) ||
                other.systemVoucherNo == systemVoucherNo) &&
            (identical(other.isReconciled, isReconciled) ||
                other.isReconciled == isReconciled) &&
            (identical(other.bankName, bankName) ||
                other.bankName == bankName) &&
            (identical(other.referenceNo, referenceNo) ||
                other.referenceNo == referenceNo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    date,
    description,
    amount,
    type,
    systemVoucherNo,
    isReconciled,
    bankName,
    referenceNo,
  );

  /// Create a copy of BankAuditItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BankAuditItemImplCopyWith<_$BankAuditItemImpl> get copyWith =>
      __$$BankAuditItemImplCopyWithImpl<_$BankAuditItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BankAuditItemImplToJson(this);
  }
}

abstract class _BankAuditItem implements BankAuditItem {
  const factory _BankAuditItem({
    @JsonKey(name: '_id') final String? id,
    required final String date,
    required final String description,
    required final double amount,
    required final String type,
    final String? systemVoucherNo,
    final bool isReconciled,
    final String? bankName,
    final String? referenceNo,
  }) = _$BankAuditItemImpl;

  factory _BankAuditItem.fromJson(Map<String, dynamic> json) =
      _$BankAuditItemImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String? get id;
  @override
  String get date;
  @override
  String get description;
  @override
  double get amount;
  @override
  String get type; // 'Dr' or 'Cr'
  @override
  String? get systemVoucherNo;
  @override
  bool get isReconciled;
  @override
  String? get bankName;
  @override
  String? get referenceNo;

  /// Create a copy of BankAuditItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BankAuditItemImplCopyWith<_$BankAuditItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
