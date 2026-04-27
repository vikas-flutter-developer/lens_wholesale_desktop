// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lens_stock_report_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LensStockReportResponse _$LensStockReportResponseFromJson(
  Map<String, dynamic> json,
) {
  return _LensStockReportResponse.fromJson(json);
}

/// @nodoc
mixin _$LensStockReportResponse {
  bool get success => throw _privateConstructorUsedError;
  List<LensStockRow> get data => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  LensStockTotals get totals => throw _privateConstructorUsedError;

  /// Serializes this LensStockReportResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LensStockReportResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LensStockReportResponseCopyWith<LensStockReportResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LensStockReportResponseCopyWith<$Res> {
  factory $LensStockReportResponseCopyWith(
    LensStockReportResponse value,
    $Res Function(LensStockReportResponse) then,
  ) = _$LensStockReportResponseCopyWithImpl<$Res, LensStockReportResponse>;
  @useResult
  $Res call({
    bool success,
    List<LensStockRow> data,
    int total,
    int page,
    int limit,
    LensStockTotals totals,
  });

  $LensStockTotalsCopyWith<$Res> get totals;
}

/// @nodoc
class _$LensStockReportResponseCopyWithImpl<
  $Res,
  $Val extends LensStockReportResponse
>
    implements $LensStockReportResponseCopyWith<$Res> {
  _$LensStockReportResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LensStockReportResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = null,
    Object? total = null,
    Object? page = null,
    Object? limit = null,
    Object? totals = null,
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
                      as List<LensStockRow>,
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as int,
            page: null == page
                ? _value.page
                : page // ignore: cast_nullable_to_non_nullable
                      as int,
            limit: null == limit
                ? _value.limit
                : limit // ignore: cast_nullable_to_non_nullable
                      as int,
            totals: null == totals
                ? _value.totals
                : totals // ignore: cast_nullable_to_non_nullable
                      as LensStockTotals,
          )
          as $Val,
    );
  }

  /// Create a copy of LensStockReportResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LensStockTotalsCopyWith<$Res> get totals {
    return $LensStockTotalsCopyWith<$Res>(_value.totals, (value) {
      return _then(_value.copyWith(totals: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LensStockReportResponseImplCopyWith<$Res>
    implements $LensStockReportResponseCopyWith<$Res> {
  factory _$$LensStockReportResponseImplCopyWith(
    _$LensStockReportResponseImpl value,
    $Res Function(_$LensStockReportResponseImpl) then,
  ) = __$$LensStockReportResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool success,
    List<LensStockRow> data,
    int total,
    int page,
    int limit,
    LensStockTotals totals,
  });

  @override
  $LensStockTotalsCopyWith<$Res> get totals;
}

/// @nodoc
class __$$LensStockReportResponseImplCopyWithImpl<$Res>
    extends
        _$LensStockReportResponseCopyWithImpl<
          $Res,
          _$LensStockReportResponseImpl
        >
    implements _$$LensStockReportResponseImplCopyWith<$Res> {
  __$$LensStockReportResponseImplCopyWithImpl(
    _$LensStockReportResponseImpl _value,
    $Res Function(_$LensStockReportResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LensStockReportResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = null,
    Object? total = null,
    Object? page = null,
    Object? limit = null,
    Object? totals = null,
  }) {
    return _then(
      _$LensStockReportResponseImpl(
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        data: null == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as List<LensStockRow>,
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
        page: null == page
            ? _value.page
            : page // ignore: cast_nullable_to_non_nullable
                  as int,
        limit: null == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int,
        totals: null == totals
            ? _value.totals
            : totals // ignore: cast_nullable_to_non_nullable
                  as LensStockTotals,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LensStockReportResponseImpl implements _LensStockReportResponse {
  const _$LensStockReportResponseImpl({
    required this.success,
    required final List<LensStockRow> data,
    required this.total,
    required this.page,
    required this.limit,
    required this.totals,
  }) : _data = data;

  factory _$LensStockReportResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$LensStockReportResponseImplFromJson(json);

  @override
  final bool success;
  final List<LensStockRow> _data;
  @override
  List<LensStockRow> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final int total;
  @override
  final int page;
  @override
  final int limit;
  @override
  final LensStockTotals totals;

  @override
  String toString() {
    return 'LensStockReportResponse(success: $success, data: $data, total: $total, page: $page, limit: $limit, totals: $totals)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LensStockReportResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.totals, totals) || other.totals == totals));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    success,
    const DeepCollectionEquality().hash(_data),
    total,
    page,
    limit,
    totals,
  );

  /// Create a copy of LensStockReportResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LensStockReportResponseImplCopyWith<_$LensStockReportResponseImpl>
  get copyWith =>
      __$$LensStockReportResponseImplCopyWithImpl<
        _$LensStockReportResponseImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LensStockReportResponseImplToJson(this);
  }
}

abstract class _LensStockReportResponse implements LensStockReportResponse {
  const factory _LensStockReportResponse({
    required final bool success,
    required final List<LensStockRow> data,
    required final int total,
    required final int page,
    required final int limit,
    required final LensStockTotals totals,
  }) = _$LensStockReportResponseImpl;

  factory _LensStockReportResponse.fromJson(Map<String, dynamic> json) =
      _$LensStockReportResponseImpl.fromJson;

  @override
  bool get success;
  @override
  List<LensStockRow> get data;
  @override
  int get total;
  @override
  int get page;
  @override
  int get limit;
  @override
  LensStockTotals get totals;

  /// Create a copy of LensStockReportResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LensStockReportResponseImplCopyWith<_$LensStockReportResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}

LensStockRow _$LensStockRowFromJson(Map<String, dynamic> json) {
  return _LensStockRow.fromJson(json);
}

/// @nodoc
mixin _$LensStockRow {
  String? get lensGroupId => throw _privateConstructorUsedError;
  String? get groupName => throw _privateConstructorUsedError;
  String? get productName => throw _privateConstructorUsedError;
  dynamic get addValue => throw _privateConstructorUsedError;
  dynamic get sph => throw _privateConstructorUsedError;
  dynamic get cyl => throw _privateConstructorUsedError;
  dynamic get axis => throw _privateConstructorUsedError;
  String? get eye => throw _privateConstructorUsedError;
  String? get barcode => throw _privateConstructorUsedError;
  String? get boxNo => throw _privateConstructorUsedError;
  int? get alertQty => throw _privateConstructorUsedError;
  double? get pPrice => throw _privateConstructorUsedError;
  double? get sPrice => throw _privateConstructorUsedError;
  int? get initStock => throw _privateConstructorUsedError;
  int? get totalSoldQty => throw _privateConstructorUsedError;
  int? get currentStock => throw _privateConstructorUsedError;
  bool? get isVerified => throw _privateConstructorUsedError;
  String? get lastVerifiedDate => throw _privateConstructorUsedError;
  int? get verifiedQty => throw _privateConstructorUsedError;
  int? get excess_qty => throw _privateConstructorUsedError;

  /// Serializes this LensStockRow to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LensStockRow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LensStockRowCopyWith<LensStockRow> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LensStockRowCopyWith<$Res> {
  factory $LensStockRowCopyWith(
    LensStockRow value,
    $Res Function(LensStockRow) then,
  ) = _$LensStockRowCopyWithImpl<$Res, LensStockRow>;
  @useResult
  $Res call({
    String? lensGroupId,
    String? groupName,
    String? productName,
    dynamic addValue,
    dynamic sph,
    dynamic cyl,
    dynamic axis,
    String? eye,
    String? barcode,
    String? boxNo,
    int? alertQty,
    double? pPrice,
    double? sPrice,
    int? initStock,
    int? totalSoldQty,
    int? currentStock,
    bool? isVerified,
    String? lastVerifiedDate,
    int? verifiedQty,
    int? excess_qty,
  });
}

/// @nodoc
class _$LensStockRowCopyWithImpl<$Res, $Val extends LensStockRow>
    implements $LensStockRowCopyWith<$Res> {
  _$LensStockRowCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LensStockRow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lensGroupId = freezed,
    Object? groupName = freezed,
    Object? productName = freezed,
    Object? addValue = freezed,
    Object? sph = freezed,
    Object? cyl = freezed,
    Object? axis = freezed,
    Object? eye = freezed,
    Object? barcode = freezed,
    Object? boxNo = freezed,
    Object? alertQty = freezed,
    Object? pPrice = freezed,
    Object? sPrice = freezed,
    Object? initStock = freezed,
    Object? totalSoldQty = freezed,
    Object? currentStock = freezed,
    Object? isVerified = freezed,
    Object? lastVerifiedDate = freezed,
    Object? verifiedQty = freezed,
    Object? excess_qty = freezed,
  }) {
    return _then(
      _value.copyWith(
            lensGroupId: freezed == lensGroupId
                ? _value.lensGroupId
                : lensGroupId // ignore: cast_nullable_to_non_nullable
                      as String?,
            groupName: freezed == groupName
                ? _value.groupName
                : groupName // ignore: cast_nullable_to_non_nullable
                      as String?,
            productName: freezed == productName
                ? _value.productName
                : productName // ignore: cast_nullable_to_non_nullable
                      as String?,
            addValue: freezed == addValue
                ? _value.addValue
                : addValue // ignore: cast_nullable_to_non_nullable
                      as dynamic,
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
            eye: freezed == eye
                ? _value.eye
                : eye // ignore: cast_nullable_to_non_nullable
                      as String?,
            barcode: freezed == barcode
                ? _value.barcode
                : barcode // ignore: cast_nullable_to_non_nullable
                      as String?,
            boxNo: freezed == boxNo
                ? _value.boxNo
                : boxNo // ignore: cast_nullable_to_non_nullable
                      as String?,
            alertQty: freezed == alertQty
                ? _value.alertQty
                : alertQty // ignore: cast_nullable_to_non_nullable
                      as int?,
            pPrice: freezed == pPrice
                ? _value.pPrice
                : pPrice // ignore: cast_nullable_to_non_nullable
                      as double?,
            sPrice: freezed == sPrice
                ? _value.sPrice
                : sPrice // ignore: cast_nullable_to_non_nullable
                      as double?,
            initStock: freezed == initStock
                ? _value.initStock
                : initStock // ignore: cast_nullable_to_non_nullable
                      as int?,
            totalSoldQty: freezed == totalSoldQty
                ? _value.totalSoldQty
                : totalSoldQty // ignore: cast_nullable_to_non_nullable
                      as int?,
            currentStock: freezed == currentStock
                ? _value.currentStock
                : currentStock // ignore: cast_nullable_to_non_nullable
                      as int?,
            isVerified: freezed == isVerified
                ? _value.isVerified
                : isVerified // ignore: cast_nullable_to_non_nullable
                      as bool?,
            lastVerifiedDate: freezed == lastVerifiedDate
                ? _value.lastVerifiedDate
                : lastVerifiedDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            verifiedQty: freezed == verifiedQty
                ? _value.verifiedQty
                : verifiedQty // ignore: cast_nullable_to_non_nullable
                      as int?,
            excess_qty: freezed == excess_qty
                ? _value.excess_qty
                : excess_qty // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LensStockRowImplCopyWith<$Res>
    implements $LensStockRowCopyWith<$Res> {
  factory _$$LensStockRowImplCopyWith(
    _$LensStockRowImpl value,
    $Res Function(_$LensStockRowImpl) then,
  ) = __$$LensStockRowImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? lensGroupId,
    String? groupName,
    String? productName,
    dynamic addValue,
    dynamic sph,
    dynamic cyl,
    dynamic axis,
    String? eye,
    String? barcode,
    String? boxNo,
    int? alertQty,
    double? pPrice,
    double? sPrice,
    int? initStock,
    int? totalSoldQty,
    int? currentStock,
    bool? isVerified,
    String? lastVerifiedDate,
    int? verifiedQty,
    int? excess_qty,
  });
}

/// @nodoc
class __$$LensStockRowImplCopyWithImpl<$Res>
    extends _$LensStockRowCopyWithImpl<$Res, _$LensStockRowImpl>
    implements _$$LensStockRowImplCopyWith<$Res> {
  __$$LensStockRowImplCopyWithImpl(
    _$LensStockRowImpl _value,
    $Res Function(_$LensStockRowImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LensStockRow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lensGroupId = freezed,
    Object? groupName = freezed,
    Object? productName = freezed,
    Object? addValue = freezed,
    Object? sph = freezed,
    Object? cyl = freezed,
    Object? axis = freezed,
    Object? eye = freezed,
    Object? barcode = freezed,
    Object? boxNo = freezed,
    Object? alertQty = freezed,
    Object? pPrice = freezed,
    Object? sPrice = freezed,
    Object? initStock = freezed,
    Object? totalSoldQty = freezed,
    Object? currentStock = freezed,
    Object? isVerified = freezed,
    Object? lastVerifiedDate = freezed,
    Object? verifiedQty = freezed,
    Object? excess_qty = freezed,
  }) {
    return _then(
      _$LensStockRowImpl(
        lensGroupId: freezed == lensGroupId
            ? _value.lensGroupId
            : lensGroupId // ignore: cast_nullable_to_non_nullable
                  as String?,
        groupName: freezed == groupName
            ? _value.groupName
            : groupName // ignore: cast_nullable_to_non_nullable
                  as String?,
        productName: freezed == productName
            ? _value.productName
            : productName // ignore: cast_nullable_to_non_nullable
                  as String?,
        addValue: freezed == addValue
            ? _value.addValue
            : addValue // ignore: cast_nullable_to_non_nullable
                  as dynamic,
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
        eye: freezed == eye
            ? _value.eye
            : eye // ignore: cast_nullable_to_non_nullable
                  as String?,
        barcode: freezed == barcode
            ? _value.barcode
            : barcode // ignore: cast_nullable_to_non_nullable
                  as String?,
        boxNo: freezed == boxNo
            ? _value.boxNo
            : boxNo // ignore: cast_nullable_to_non_nullable
                  as String?,
        alertQty: freezed == alertQty
            ? _value.alertQty
            : alertQty // ignore: cast_nullable_to_non_nullable
                  as int?,
        pPrice: freezed == pPrice
            ? _value.pPrice
            : pPrice // ignore: cast_nullable_to_non_nullable
                  as double?,
        sPrice: freezed == sPrice
            ? _value.sPrice
            : sPrice // ignore: cast_nullable_to_non_nullable
                  as double?,
        initStock: freezed == initStock
            ? _value.initStock
            : initStock // ignore: cast_nullable_to_non_nullable
                  as int?,
        totalSoldQty: freezed == totalSoldQty
            ? _value.totalSoldQty
            : totalSoldQty // ignore: cast_nullable_to_non_nullable
                  as int?,
        currentStock: freezed == currentStock
            ? _value.currentStock
            : currentStock // ignore: cast_nullable_to_non_nullable
                  as int?,
        isVerified: freezed == isVerified
            ? _value.isVerified
            : isVerified // ignore: cast_nullable_to_non_nullable
                  as bool?,
        lastVerifiedDate: freezed == lastVerifiedDate
            ? _value.lastVerifiedDate
            : lastVerifiedDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        verifiedQty: freezed == verifiedQty
            ? _value.verifiedQty
            : verifiedQty // ignore: cast_nullable_to_non_nullable
                  as int?,
        excess_qty: freezed == excess_qty
            ? _value.excess_qty
            : excess_qty // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LensStockRowImpl implements _LensStockRow {
  const _$LensStockRowImpl({
    this.lensGroupId,
    this.groupName,
    this.productName,
    this.addValue,
    this.sph,
    this.cyl,
    this.axis,
    this.eye,
    this.barcode,
    this.boxNo,
    this.alertQty,
    this.pPrice,
    this.sPrice,
    this.initStock,
    this.totalSoldQty,
    this.currentStock,
    this.isVerified,
    this.lastVerifiedDate,
    this.verifiedQty,
    this.excess_qty,
  });

  factory _$LensStockRowImpl.fromJson(Map<String, dynamic> json) =>
      _$$LensStockRowImplFromJson(json);

  @override
  final String? lensGroupId;
  @override
  final String? groupName;
  @override
  final String? productName;
  @override
  final dynamic addValue;
  @override
  final dynamic sph;
  @override
  final dynamic cyl;
  @override
  final dynamic axis;
  @override
  final String? eye;
  @override
  final String? barcode;
  @override
  final String? boxNo;
  @override
  final int? alertQty;
  @override
  final double? pPrice;
  @override
  final double? sPrice;
  @override
  final int? initStock;
  @override
  final int? totalSoldQty;
  @override
  final int? currentStock;
  @override
  final bool? isVerified;
  @override
  final String? lastVerifiedDate;
  @override
  final int? verifiedQty;
  @override
  final int? excess_qty;

  @override
  String toString() {
    return 'LensStockRow(lensGroupId: $lensGroupId, groupName: $groupName, productName: $productName, addValue: $addValue, sph: $sph, cyl: $cyl, axis: $axis, eye: $eye, barcode: $barcode, boxNo: $boxNo, alertQty: $alertQty, pPrice: $pPrice, sPrice: $sPrice, initStock: $initStock, totalSoldQty: $totalSoldQty, currentStock: $currentStock, isVerified: $isVerified, lastVerifiedDate: $lastVerifiedDate, verifiedQty: $verifiedQty, excess_qty: $excess_qty)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LensStockRowImpl &&
            (identical(other.lensGroupId, lensGroupId) ||
                other.lensGroupId == lensGroupId) &&
            (identical(other.groupName, groupName) ||
                other.groupName == groupName) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            const DeepCollectionEquality().equals(other.addValue, addValue) &&
            const DeepCollectionEquality().equals(other.sph, sph) &&
            const DeepCollectionEquality().equals(other.cyl, cyl) &&
            const DeepCollectionEquality().equals(other.axis, axis) &&
            (identical(other.eye, eye) || other.eye == eye) &&
            (identical(other.barcode, barcode) || other.barcode == barcode) &&
            (identical(other.boxNo, boxNo) || other.boxNo == boxNo) &&
            (identical(other.alertQty, alertQty) ||
                other.alertQty == alertQty) &&
            (identical(other.pPrice, pPrice) || other.pPrice == pPrice) &&
            (identical(other.sPrice, sPrice) || other.sPrice == sPrice) &&
            (identical(other.initStock, initStock) ||
                other.initStock == initStock) &&
            (identical(other.totalSoldQty, totalSoldQty) ||
                other.totalSoldQty == totalSoldQty) &&
            (identical(other.currentStock, currentStock) ||
                other.currentStock == currentStock) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.lastVerifiedDate, lastVerifiedDate) ||
                other.lastVerifiedDate == lastVerifiedDate) &&
            (identical(other.verifiedQty, verifiedQty) ||
                other.verifiedQty == verifiedQty) &&
            (identical(other.excess_qty, excess_qty) ||
                other.excess_qty == excess_qty));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    lensGroupId,
    groupName,
    productName,
    const DeepCollectionEquality().hash(addValue),
    const DeepCollectionEquality().hash(sph),
    const DeepCollectionEquality().hash(cyl),
    const DeepCollectionEquality().hash(axis),
    eye,
    barcode,
    boxNo,
    alertQty,
    pPrice,
    sPrice,
    initStock,
    totalSoldQty,
    currentStock,
    isVerified,
    lastVerifiedDate,
    verifiedQty,
    excess_qty,
  ]);

  /// Create a copy of LensStockRow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LensStockRowImplCopyWith<_$LensStockRowImpl> get copyWith =>
      __$$LensStockRowImplCopyWithImpl<_$LensStockRowImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LensStockRowImplToJson(this);
  }
}

abstract class _LensStockRow implements LensStockRow {
  const factory _LensStockRow({
    final String? lensGroupId,
    final String? groupName,
    final String? productName,
    final dynamic addValue,
    final dynamic sph,
    final dynamic cyl,
    final dynamic axis,
    final String? eye,
    final String? barcode,
    final String? boxNo,
    final int? alertQty,
    final double? pPrice,
    final double? sPrice,
    final int? initStock,
    final int? totalSoldQty,
    final int? currentStock,
    final bool? isVerified,
    final String? lastVerifiedDate,
    final int? verifiedQty,
    final int? excess_qty,
  }) = _$LensStockRowImpl;

  factory _LensStockRow.fromJson(Map<String, dynamic> json) =
      _$LensStockRowImpl.fromJson;

  @override
  String? get lensGroupId;
  @override
  String? get groupName;
  @override
  String? get productName;
  @override
  dynamic get addValue;
  @override
  dynamic get sph;
  @override
  dynamic get cyl;
  @override
  dynamic get axis;
  @override
  String? get eye;
  @override
  String? get barcode;
  @override
  String? get boxNo;
  @override
  int? get alertQty;
  @override
  double? get pPrice;
  @override
  double? get sPrice;
  @override
  int? get initStock;
  @override
  int? get totalSoldQty;
  @override
  int? get currentStock;
  @override
  bool? get isVerified;
  @override
  String? get lastVerifiedDate;
  @override
  int? get verifiedQty;
  @override
  int? get excess_qty;

  /// Create a copy of LensStockRow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LensStockRowImplCopyWith<_$LensStockRowImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LensStockTotals _$LensStockTotalsFromJson(Map<String, dynamic> json) {
  return _LensStockTotals.fromJson(json);
}

/// @nodoc
mixin _$LensStockTotals {
  int get stockTotal => throw _privateConstructorUsedError;
  double get purValueTotal => throw _privateConstructorUsedError;
  double get saleValueTotal => throw _privateConstructorUsedError;

  /// Serializes this LensStockTotals to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LensStockTotals
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LensStockTotalsCopyWith<LensStockTotals> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LensStockTotalsCopyWith<$Res> {
  factory $LensStockTotalsCopyWith(
    LensStockTotals value,
    $Res Function(LensStockTotals) then,
  ) = _$LensStockTotalsCopyWithImpl<$Res, LensStockTotals>;
  @useResult
  $Res call({int stockTotal, double purValueTotal, double saleValueTotal});
}

/// @nodoc
class _$LensStockTotalsCopyWithImpl<$Res, $Val extends LensStockTotals>
    implements $LensStockTotalsCopyWith<$Res> {
  _$LensStockTotalsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LensStockTotals
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stockTotal = null,
    Object? purValueTotal = null,
    Object? saleValueTotal = null,
  }) {
    return _then(
      _value.copyWith(
            stockTotal: null == stockTotal
                ? _value.stockTotal
                : stockTotal // ignore: cast_nullable_to_non_nullable
                      as int,
            purValueTotal: null == purValueTotal
                ? _value.purValueTotal
                : purValueTotal // ignore: cast_nullable_to_non_nullable
                      as double,
            saleValueTotal: null == saleValueTotal
                ? _value.saleValueTotal
                : saleValueTotal // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LensStockTotalsImplCopyWith<$Res>
    implements $LensStockTotalsCopyWith<$Res> {
  factory _$$LensStockTotalsImplCopyWith(
    _$LensStockTotalsImpl value,
    $Res Function(_$LensStockTotalsImpl) then,
  ) = __$$LensStockTotalsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int stockTotal, double purValueTotal, double saleValueTotal});
}

/// @nodoc
class __$$LensStockTotalsImplCopyWithImpl<$Res>
    extends _$LensStockTotalsCopyWithImpl<$Res, _$LensStockTotalsImpl>
    implements _$$LensStockTotalsImplCopyWith<$Res> {
  __$$LensStockTotalsImplCopyWithImpl(
    _$LensStockTotalsImpl _value,
    $Res Function(_$LensStockTotalsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LensStockTotals
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stockTotal = null,
    Object? purValueTotal = null,
    Object? saleValueTotal = null,
  }) {
    return _then(
      _$LensStockTotalsImpl(
        stockTotal: null == stockTotal
            ? _value.stockTotal
            : stockTotal // ignore: cast_nullable_to_non_nullable
                  as int,
        purValueTotal: null == purValueTotal
            ? _value.purValueTotal
            : purValueTotal // ignore: cast_nullable_to_non_nullable
                  as double,
        saleValueTotal: null == saleValueTotal
            ? _value.saleValueTotal
            : saleValueTotal // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LensStockTotalsImpl implements _LensStockTotals {
  const _$LensStockTotalsImpl({
    this.stockTotal = 0,
    this.purValueTotal = 0.0,
    this.saleValueTotal = 0.0,
  });

  factory _$LensStockTotalsImpl.fromJson(Map<String, dynamic> json) =>
      _$$LensStockTotalsImplFromJson(json);

  @override
  @JsonKey()
  final int stockTotal;
  @override
  @JsonKey()
  final double purValueTotal;
  @override
  @JsonKey()
  final double saleValueTotal;

  @override
  String toString() {
    return 'LensStockTotals(stockTotal: $stockTotal, purValueTotal: $purValueTotal, saleValueTotal: $saleValueTotal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LensStockTotalsImpl &&
            (identical(other.stockTotal, stockTotal) ||
                other.stockTotal == stockTotal) &&
            (identical(other.purValueTotal, purValueTotal) ||
                other.purValueTotal == purValueTotal) &&
            (identical(other.saleValueTotal, saleValueTotal) ||
                other.saleValueTotal == saleValueTotal));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, stockTotal, purValueTotal, saleValueTotal);

  /// Create a copy of LensStockTotals
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LensStockTotalsImplCopyWith<_$LensStockTotalsImpl> get copyWith =>
      __$$LensStockTotalsImplCopyWithImpl<_$LensStockTotalsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LensStockTotalsImplToJson(this);
  }
}

abstract class _LensStockTotals implements LensStockTotals {
  const factory _LensStockTotals({
    final int stockTotal,
    final double purValueTotal,
    final double saleValueTotal,
  }) = _$LensStockTotalsImpl;

  factory _LensStockTotals.fromJson(Map<String, dynamic> json) =
      _$LensStockTotalsImpl.fromJson;

  @override
  int get stockTotal;
  @override
  double get purValueTotal;
  @override
  double get saleValueTotal;

  /// Create a copy of LensStockTotals
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LensStockTotalsImplCopyWith<_$LensStockTotalsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
