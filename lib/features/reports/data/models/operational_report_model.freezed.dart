// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'operational_report_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OrderToChallanReport _$OrderToChallanReportFromJson(Map<String, dynamic> json) {
  return _OrderToChallanReport.fromJson(json);
}

/// @nodoc
mixin _$OrderToChallanReport {
  bool get success => throw _privateConstructorUsedError;
  OrderToChallanSummary get summary => throw _privateConstructorUsedError;
  List<OrderToChallanDetail> get details => throw _privateConstructorUsedError;

  /// Serializes this OrderToChallanReport to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderToChallanReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderToChallanReportCopyWith<OrderToChallanReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderToChallanReportCopyWith<$Res> {
  factory $OrderToChallanReportCopyWith(
    OrderToChallanReport value,
    $Res Function(OrderToChallanReport) then,
  ) = _$OrderToChallanReportCopyWithImpl<$Res, OrderToChallanReport>;
  @useResult
  $Res call({
    bool success,
    OrderToChallanSummary summary,
    List<OrderToChallanDetail> details,
  });

  $OrderToChallanSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class _$OrderToChallanReportCopyWithImpl<
  $Res,
  $Val extends OrderToChallanReport
>
    implements $OrderToChallanReportCopyWith<$Res> {
  _$OrderToChallanReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderToChallanReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? summary = null,
    Object? details = null,
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
                      as OrderToChallanSummary,
            details: null == details
                ? _value.details
                : details // ignore: cast_nullable_to_non_nullable
                      as List<OrderToChallanDetail>,
          )
          as $Val,
    );
  }

  /// Create a copy of OrderToChallanReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderToChallanSummaryCopyWith<$Res> get summary {
    return $OrderToChallanSummaryCopyWith<$Res>(_value.summary, (value) {
      return _then(_value.copyWith(summary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrderToChallanReportImplCopyWith<$Res>
    implements $OrderToChallanReportCopyWith<$Res> {
  factory _$$OrderToChallanReportImplCopyWith(
    _$OrderToChallanReportImpl value,
    $Res Function(_$OrderToChallanReportImpl) then,
  ) = __$$OrderToChallanReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool success,
    OrderToChallanSummary summary,
    List<OrderToChallanDetail> details,
  });

  @override
  $OrderToChallanSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class __$$OrderToChallanReportImplCopyWithImpl<$Res>
    extends _$OrderToChallanReportCopyWithImpl<$Res, _$OrderToChallanReportImpl>
    implements _$$OrderToChallanReportImplCopyWith<$Res> {
  __$$OrderToChallanReportImplCopyWithImpl(
    _$OrderToChallanReportImpl _value,
    $Res Function(_$OrderToChallanReportImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderToChallanReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? summary = null,
    Object? details = null,
  }) {
    return _then(
      _$OrderToChallanReportImpl(
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        summary: null == summary
            ? _value.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as OrderToChallanSummary,
        details: null == details
            ? _value._details
            : details // ignore: cast_nullable_to_non_nullable
                  as List<OrderToChallanDetail>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderToChallanReportImpl implements _OrderToChallanReport {
  const _$OrderToChallanReportImpl({
    required this.success,
    required this.summary,
    required final List<OrderToChallanDetail> details,
  }) : _details = details;

  factory _$OrderToChallanReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderToChallanReportImplFromJson(json);

  @override
  final bool success;
  @override
  final OrderToChallanSummary summary;
  final List<OrderToChallanDetail> _details;
  @override
  List<OrderToChallanDetail> get details {
    if (_details is EqualUnmodifiableListView) return _details;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_details);
  }

  @override
  String toString() {
    return 'OrderToChallanReport(success: $success, summary: $summary, details: $details)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderToChallanReportImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            const DeepCollectionEquality().equals(other._details, _details));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    success,
    summary,
    const DeepCollectionEquality().hash(_details),
  );

  /// Create a copy of OrderToChallanReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderToChallanReportImplCopyWith<_$OrderToChallanReportImpl>
  get copyWith =>
      __$$OrderToChallanReportImplCopyWithImpl<_$OrderToChallanReportImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderToChallanReportImplToJson(this);
  }
}

abstract class _OrderToChallanReport implements OrderToChallanReport {
  const factory _OrderToChallanReport({
    required final bool success,
    required final OrderToChallanSummary summary,
    required final List<OrderToChallanDetail> details,
  }) = _$OrderToChallanReportImpl;

  factory _OrderToChallanReport.fromJson(Map<String, dynamic> json) =
      _$OrderToChallanReportImpl.fromJson;

  @override
  bool get success;
  @override
  OrderToChallanSummary get summary;
  @override
  List<OrderToChallanDetail> get details;

  /// Create a copy of OrderToChallanReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderToChallanReportImplCopyWith<_$OrderToChallanReportImpl>
  get copyWith => throw _privateConstructorUsedError;
}

OrderToChallanSummary _$OrderToChallanSummaryFromJson(
  Map<String, dynamic> json,
) {
  return _OrderToChallanSummary.fromJson(json);
}

/// @nodoc
mixin _$OrderToChallanSummary {
  int get totalOrders => throw _privateConstructorUsedError;
  int get completedOrders => throw _privateConstructorUsedError;
  int get pendingOrders => throw _privateConstructorUsedError;
  double get avgTime => throw _privateConstructorUsedError;

  /// Serializes this OrderToChallanSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderToChallanSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderToChallanSummaryCopyWith<OrderToChallanSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderToChallanSummaryCopyWith<$Res> {
  factory $OrderToChallanSummaryCopyWith(
    OrderToChallanSummary value,
    $Res Function(OrderToChallanSummary) then,
  ) = _$OrderToChallanSummaryCopyWithImpl<$Res, OrderToChallanSummary>;
  @useResult
  $Res call({
    int totalOrders,
    int completedOrders,
    int pendingOrders,
    double avgTime,
  });
}

/// @nodoc
class _$OrderToChallanSummaryCopyWithImpl<
  $Res,
  $Val extends OrderToChallanSummary
>
    implements $OrderToChallanSummaryCopyWith<$Res> {
  _$OrderToChallanSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderToChallanSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalOrders = null,
    Object? completedOrders = null,
    Object? pendingOrders = null,
    Object? avgTime = null,
  }) {
    return _then(
      _value.copyWith(
            totalOrders: null == totalOrders
                ? _value.totalOrders
                : totalOrders // ignore: cast_nullable_to_non_nullable
                      as int,
            completedOrders: null == completedOrders
                ? _value.completedOrders
                : completedOrders // ignore: cast_nullable_to_non_nullable
                      as int,
            pendingOrders: null == pendingOrders
                ? _value.pendingOrders
                : pendingOrders // ignore: cast_nullable_to_non_nullable
                      as int,
            avgTime: null == avgTime
                ? _value.avgTime
                : avgTime // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderToChallanSummaryImplCopyWith<$Res>
    implements $OrderToChallanSummaryCopyWith<$Res> {
  factory _$$OrderToChallanSummaryImplCopyWith(
    _$OrderToChallanSummaryImpl value,
    $Res Function(_$OrderToChallanSummaryImpl) then,
  ) = __$$OrderToChallanSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalOrders,
    int completedOrders,
    int pendingOrders,
    double avgTime,
  });
}

/// @nodoc
class __$$OrderToChallanSummaryImplCopyWithImpl<$Res>
    extends
        _$OrderToChallanSummaryCopyWithImpl<$Res, _$OrderToChallanSummaryImpl>
    implements _$$OrderToChallanSummaryImplCopyWith<$Res> {
  __$$OrderToChallanSummaryImplCopyWithImpl(
    _$OrderToChallanSummaryImpl _value,
    $Res Function(_$OrderToChallanSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderToChallanSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalOrders = null,
    Object? completedOrders = null,
    Object? pendingOrders = null,
    Object? avgTime = null,
  }) {
    return _then(
      _$OrderToChallanSummaryImpl(
        totalOrders: null == totalOrders
            ? _value.totalOrders
            : totalOrders // ignore: cast_nullable_to_non_nullable
                  as int,
        completedOrders: null == completedOrders
            ? _value.completedOrders
            : completedOrders // ignore: cast_nullable_to_non_nullable
                  as int,
        pendingOrders: null == pendingOrders
            ? _value.pendingOrders
            : pendingOrders // ignore: cast_nullable_to_non_nullable
                  as int,
        avgTime: null == avgTime
            ? _value.avgTime
            : avgTime // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderToChallanSummaryImpl implements _OrderToChallanSummary {
  const _$OrderToChallanSummaryImpl({
    required this.totalOrders,
    required this.completedOrders,
    required this.pendingOrders,
    required this.avgTime,
  });

  factory _$OrderToChallanSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderToChallanSummaryImplFromJson(json);

  @override
  final int totalOrders;
  @override
  final int completedOrders;
  @override
  final int pendingOrders;
  @override
  final double avgTime;

  @override
  String toString() {
    return 'OrderToChallanSummary(totalOrders: $totalOrders, completedOrders: $completedOrders, pendingOrders: $pendingOrders, avgTime: $avgTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderToChallanSummaryImpl &&
            (identical(other.totalOrders, totalOrders) ||
                other.totalOrders == totalOrders) &&
            (identical(other.completedOrders, completedOrders) ||
                other.completedOrders == completedOrders) &&
            (identical(other.pendingOrders, pendingOrders) ||
                other.pendingOrders == pendingOrders) &&
            (identical(other.avgTime, avgTime) || other.avgTime == avgTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalOrders,
    completedOrders,
    pendingOrders,
    avgTime,
  );

  /// Create a copy of OrderToChallanSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderToChallanSummaryImplCopyWith<_$OrderToChallanSummaryImpl>
  get copyWith =>
      __$$OrderToChallanSummaryImplCopyWithImpl<_$OrderToChallanSummaryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderToChallanSummaryImplToJson(this);
  }
}

abstract class _OrderToChallanSummary implements OrderToChallanSummary {
  const factory _OrderToChallanSummary({
    required final int totalOrders,
    required final int completedOrders,
    required final int pendingOrders,
    required final double avgTime,
  }) = _$OrderToChallanSummaryImpl;

  factory _OrderToChallanSummary.fromJson(Map<String, dynamic> json) =
      _$OrderToChallanSummaryImpl.fromJson;

  @override
  int get totalOrders;
  @override
  int get completedOrders;
  @override
  int get pendingOrders;
  @override
  double get avgTime;

  /// Create a copy of OrderToChallanSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderToChallanSummaryImplCopyWith<_$OrderToChallanSummaryImpl>
  get copyWith => throw _privateConstructorUsedError;
}

OrderToChallanDetail _$OrderToChallanDetailFromJson(Map<String, dynamic> json) {
  return _OrderToChallanDetail.fromJson(json);
}

/// @nodoc
mixin _$OrderToChallanDetail {
  String get orderNo => throw _privateConstructorUsedError;
  String get orderDate => throw _privateConstructorUsedError;
  String get orderCreatedAt => throw _privateConstructorUsedError;
  String? get challanNo => throw _privateConstructorUsedError;
  String? get challanDate => throw _privateConstructorUsedError;
  String? get challanCreatedAt => throw _privateConstructorUsedError;
  String get partyName => throw _privateConstructorUsedError;
  double get timeDifference => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;

  /// Serializes this OrderToChallanDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderToChallanDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderToChallanDetailCopyWith<OrderToChallanDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderToChallanDetailCopyWith<$Res> {
  factory $OrderToChallanDetailCopyWith(
    OrderToChallanDetail value,
    $Res Function(OrderToChallanDetail) then,
  ) = _$OrderToChallanDetailCopyWithImpl<$Res, OrderToChallanDetail>;
  @useResult
  $Res call({
    String orderNo,
    String orderDate,
    String orderCreatedAt,
    String? challanNo,
    String? challanDate,
    String? challanCreatedAt,
    String partyName,
    double timeDifference,
    String status,
  });
}

/// @nodoc
class _$OrderToChallanDetailCopyWithImpl<
  $Res,
  $Val extends OrderToChallanDetail
>
    implements $OrderToChallanDetailCopyWith<$Res> {
  _$OrderToChallanDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderToChallanDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderNo = null,
    Object? orderDate = null,
    Object? orderCreatedAt = null,
    Object? challanNo = freezed,
    Object? challanDate = freezed,
    Object? challanCreatedAt = freezed,
    Object? partyName = null,
    Object? timeDifference = null,
    Object? status = null,
  }) {
    return _then(
      _value.copyWith(
            orderNo: null == orderNo
                ? _value.orderNo
                : orderNo // ignore: cast_nullable_to_non_nullable
                      as String,
            orderDate: null == orderDate
                ? _value.orderDate
                : orderDate // ignore: cast_nullable_to_non_nullable
                      as String,
            orderCreatedAt: null == orderCreatedAt
                ? _value.orderCreatedAt
                : orderCreatedAt // ignore: cast_nullable_to_non_nullable
                      as String,
            challanNo: freezed == challanNo
                ? _value.challanNo
                : challanNo // ignore: cast_nullable_to_non_nullable
                      as String?,
            challanDate: freezed == challanDate
                ? _value.challanDate
                : challanDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            challanCreatedAt: freezed == challanCreatedAt
                ? _value.challanCreatedAt
                : challanCreatedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            partyName: null == partyName
                ? _value.partyName
                : partyName // ignore: cast_nullable_to_non_nullable
                      as String,
            timeDifference: null == timeDifference
                ? _value.timeDifference
                : timeDifference // ignore: cast_nullable_to_non_nullable
                      as double,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderToChallanDetailImplCopyWith<$Res>
    implements $OrderToChallanDetailCopyWith<$Res> {
  factory _$$OrderToChallanDetailImplCopyWith(
    _$OrderToChallanDetailImpl value,
    $Res Function(_$OrderToChallanDetailImpl) then,
  ) = __$$OrderToChallanDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String orderNo,
    String orderDate,
    String orderCreatedAt,
    String? challanNo,
    String? challanDate,
    String? challanCreatedAt,
    String partyName,
    double timeDifference,
    String status,
  });
}

/// @nodoc
class __$$OrderToChallanDetailImplCopyWithImpl<$Res>
    extends _$OrderToChallanDetailCopyWithImpl<$Res, _$OrderToChallanDetailImpl>
    implements _$$OrderToChallanDetailImplCopyWith<$Res> {
  __$$OrderToChallanDetailImplCopyWithImpl(
    _$OrderToChallanDetailImpl _value,
    $Res Function(_$OrderToChallanDetailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderToChallanDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderNo = null,
    Object? orderDate = null,
    Object? orderCreatedAt = null,
    Object? challanNo = freezed,
    Object? challanDate = freezed,
    Object? challanCreatedAt = freezed,
    Object? partyName = null,
    Object? timeDifference = null,
    Object? status = null,
  }) {
    return _then(
      _$OrderToChallanDetailImpl(
        orderNo: null == orderNo
            ? _value.orderNo
            : orderNo // ignore: cast_nullable_to_non_nullable
                  as String,
        orderDate: null == orderDate
            ? _value.orderDate
            : orderDate // ignore: cast_nullable_to_non_nullable
                  as String,
        orderCreatedAt: null == orderCreatedAt
            ? _value.orderCreatedAt
            : orderCreatedAt // ignore: cast_nullable_to_non_nullable
                  as String,
        challanNo: freezed == challanNo
            ? _value.challanNo
            : challanNo // ignore: cast_nullable_to_non_nullable
                  as String?,
        challanDate: freezed == challanDate
            ? _value.challanDate
            : challanDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        challanCreatedAt: freezed == challanCreatedAt
            ? _value.challanCreatedAt
            : challanCreatedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        partyName: null == partyName
            ? _value.partyName
            : partyName // ignore: cast_nullable_to_non_nullable
                  as String,
        timeDifference: null == timeDifference
            ? _value.timeDifference
            : timeDifference // ignore: cast_nullable_to_non_nullable
                  as double,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderToChallanDetailImpl implements _OrderToChallanDetail {
  const _$OrderToChallanDetailImpl({
    required this.orderNo,
    required this.orderDate,
    required this.orderCreatedAt,
    this.challanNo,
    this.challanDate,
    this.challanCreatedAt,
    required this.partyName,
    required this.timeDifference,
    required this.status,
  });

  factory _$OrderToChallanDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderToChallanDetailImplFromJson(json);

  @override
  final String orderNo;
  @override
  final String orderDate;
  @override
  final String orderCreatedAt;
  @override
  final String? challanNo;
  @override
  final String? challanDate;
  @override
  final String? challanCreatedAt;
  @override
  final String partyName;
  @override
  final double timeDifference;
  @override
  final String status;

  @override
  String toString() {
    return 'OrderToChallanDetail(orderNo: $orderNo, orderDate: $orderDate, orderCreatedAt: $orderCreatedAt, challanNo: $challanNo, challanDate: $challanDate, challanCreatedAt: $challanCreatedAt, partyName: $partyName, timeDifference: $timeDifference, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderToChallanDetailImpl &&
            (identical(other.orderNo, orderNo) || other.orderNo == orderNo) &&
            (identical(other.orderDate, orderDate) ||
                other.orderDate == orderDate) &&
            (identical(other.orderCreatedAt, orderCreatedAt) ||
                other.orderCreatedAt == orderCreatedAt) &&
            (identical(other.challanNo, challanNo) ||
                other.challanNo == challanNo) &&
            (identical(other.challanDate, challanDate) ||
                other.challanDate == challanDate) &&
            (identical(other.challanCreatedAt, challanCreatedAt) ||
                other.challanCreatedAt == challanCreatedAt) &&
            (identical(other.partyName, partyName) ||
                other.partyName == partyName) &&
            (identical(other.timeDifference, timeDifference) ||
                other.timeDifference == timeDifference) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    orderNo,
    orderDate,
    orderCreatedAt,
    challanNo,
    challanDate,
    challanCreatedAt,
    partyName,
    timeDifference,
    status,
  );

  /// Create a copy of OrderToChallanDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderToChallanDetailImplCopyWith<_$OrderToChallanDetailImpl>
  get copyWith =>
      __$$OrderToChallanDetailImplCopyWithImpl<_$OrderToChallanDetailImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderToChallanDetailImplToJson(this);
  }
}

abstract class _OrderToChallanDetail implements OrderToChallanDetail {
  const factory _OrderToChallanDetail({
    required final String orderNo,
    required final String orderDate,
    required final String orderCreatedAt,
    final String? challanNo,
    final String? challanDate,
    final String? challanCreatedAt,
    required final String partyName,
    required final double timeDifference,
    required final String status,
  }) = _$OrderToChallanDetailImpl;

  factory _OrderToChallanDetail.fromJson(Map<String, dynamic> json) =
      _$OrderToChallanDetailImpl.fromJson;

  @override
  String get orderNo;
  @override
  String get orderDate;
  @override
  String get orderCreatedAt;
  @override
  String? get challanNo;
  @override
  String? get challanDate;
  @override
  String? get challanCreatedAt;
  @override
  String get partyName;
  @override
  double get timeDifference;
  @override
  String get status;

  /// Create a copy of OrderToChallanDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderToChallanDetailImplCopyWith<_$OrderToChallanDetailImpl>
  get copyWith => throw _privateConstructorUsedError;
}

CancelledOrderRatioReport _$CancelledOrderRatioReportFromJson(
  Map<String, dynamic> json,
) {
  return _CancelledOrderRatioReport.fromJson(json);
}

/// @nodoc
mixin _$CancelledOrderRatioReport {
  bool get success => throw _privateConstructorUsedError;
  CancelledOrderRatioSummary get summary => throw _privateConstructorUsedError;
  List<CancelledOrderRatioDetail> get details =>
      throw _privateConstructorUsedError;
  List<PartyWiseRatio> get partyWise => throw _privateConstructorUsedError;
  List<RatioTrend> get trend => throw _privateConstructorUsedError;

  /// Serializes this CancelledOrderRatioReport to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CancelledOrderRatioReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CancelledOrderRatioReportCopyWith<CancelledOrderRatioReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CancelledOrderRatioReportCopyWith<$Res> {
  factory $CancelledOrderRatioReportCopyWith(
    CancelledOrderRatioReport value,
    $Res Function(CancelledOrderRatioReport) then,
  ) = _$CancelledOrderRatioReportCopyWithImpl<$Res, CancelledOrderRatioReport>;
  @useResult
  $Res call({
    bool success,
    CancelledOrderRatioSummary summary,
    List<CancelledOrderRatioDetail> details,
    List<PartyWiseRatio> partyWise,
    List<RatioTrend> trend,
  });

  $CancelledOrderRatioSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class _$CancelledOrderRatioReportCopyWithImpl<
  $Res,
  $Val extends CancelledOrderRatioReport
>
    implements $CancelledOrderRatioReportCopyWith<$Res> {
  _$CancelledOrderRatioReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CancelledOrderRatioReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? summary = null,
    Object? details = null,
    Object? partyWise = null,
    Object? trend = null,
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
                      as CancelledOrderRatioSummary,
            details: null == details
                ? _value.details
                : details // ignore: cast_nullable_to_non_nullable
                      as List<CancelledOrderRatioDetail>,
            partyWise: null == partyWise
                ? _value.partyWise
                : partyWise // ignore: cast_nullable_to_non_nullable
                      as List<PartyWiseRatio>,
            trend: null == trend
                ? _value.trend
                : trend // ignore: cast_nullable_to_non_nullable
                      as List<RatioTrend>,
          )
          as $Val,
    );
  }

  /// Create a copy of CancelledOrderRatioReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CancelledOrderRatioSummaryCopyWith<$Res> get summary {
    return $CancelledOrderRatioSummaryCopyWith<$Res>(_value.summary, (value) {
      return _then(_value.copyWith(summary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CancelledOrderRatioReportImplCopyWith<$Res>
    implements $CancelledOrderRatioReportCopyWith<$Res> {
  factory _$$CancelledOrderRatioReportImplCopyWith(
    _$CancelledOrderRatioReportImpl value,
    $Res Function(_$CancelledOrderRatioReportImpl) then,
  ) = __$$CancelledOrderRatioReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool success,
    CancelledOrderRatioSummary summary,
    List<CancelledOrderRatioDetail> details,
    List<PartyWiseRatio> partyWise,
    List<RatioTrend> trend,
  });

  @override
  $CancelledOrderRatioSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class __$$CancelledOrderRatioReportImplCopyWithImpl<$Res>
    extends
        _$CancelledOrderRatioReportCopyWithImpl<
          $Res,
          _$CancelledOrderRatioReportImpl
        >
    implements _$$CancelledOrderRatioReportImplCopyWith<$Res> {
  __$$CancelledOrderRatioReportImplCopyWithImpl(
    _$CancelledOrderRatioReportImpl _value,
    $Res Function(_$CancelledOrderRatioReportImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CancelledOrderRatioReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? summary = null,
    Object? details = null,
    Object? partyWise = null,
    Object? trend = null,
  }) {
    return _then(
      _$CancelledOrderRatioReportImpl(
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        summary: null == summary
            ? _value.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as CancelledOrderRatioSummary,
        details: null == details
            ? _value._details
            : details // ignore: cast_nullable_to_non_nullable
                  as List<CancelledOrderRatioDetail>,
        partyWise: null == partyWise
            ? _value._partyWise
            : partyWise // ignore: cast_nullable_to_non_nullable
                  as List<PartyWiseRatio>,
        trend: null == trend
            ? _value._trend
            : trend // ignore: cast_nullable_to_non_nullable
                  as List<RatioTrend>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CancelledOrderRatioReportImpl implements _CancelledOrderRatioReport {
  const _$CancelledOrderRatioReportImpl({
    required this.success,
    required this.summary,
    required final List<CancelledOrderRatioDetail> details,
    required final List<PartyWiseRatio> partyWise,
    required final List<RatioTrend> trend,
  }) : _details = details,
       _partyWise = partyWise,
       _trend = trend;

  factory _$CancelledOrderRatioReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$CancelledOrderRatioReportImplFromJson(json);

  @override
  final bool success;
  @override
  final CancelledOrderRatioSummary summary;
  final List<CancelledOrderRatioDetail> _details;
  @override
  List<CancelledOrderRatioDetail> get details {
    if (_details is EqualUnmodifiableListView) return _details;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_details);
  }

  final List<PartyWiseRatio> _partyWise;
  @override
  List<PartyWiseRatio> get partyWise {
    if (_partyWise is EqualUnmodifiableListView) return _partyWise;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_partyWise);
  }

  final List<RatioTrend> _trend;
  @override
  List<RatioTrend> get trend {
    if (_trend is EqualUnmodifiableListView) return _trend;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_trend);
  }

  @override
  String toString() {
    return 'CancelledOrderRatioReport(success: $success, summary: $summary, details: $details, partyWise: $partyWise, trend: $trend)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CancelledOrderRatioReportImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            const DeepCollectionEquality().equals(other._details, _details) &&
            const DeepCollectionEquality().equals(
              other._partyWise,
              _partyWise,
            ) &&
            const DeepCollectionEquality().equals(other._trend, _trend));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    success,
    summary,
    const DeepCollectionEquality().hash(_details),
    const DeepCollectionEquality().hash(_partyWise),
    const DeepCollectionEquality().hash(_trend),
  );

  /// Create a copy of CancelledOrderRatioReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CancelledOrderRatioReportImplCopyWith<_$CancelledOrderRatioReportImpl>
  get copyWith =>
      __$$CancelledOrderRatioReportImplCopyWithImpl<
        _$CancelledOrderRatioReportImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CancelledOrderRatioReportImplToJson(this);
  }
}

abstract class _CancelledOrderRatioReport implements CancelledOrderRatioReport {
  const factory _CancelledOrderRatioReport({
    required final bool success,
    required final CancelledOrderRatioSummary summary,
    required final List<CancelledOrderRatioDetail> details,
    required final List<PartyWiseRatio> partyWise,
    required final List<RatioTrend> trend,
  }) = _$CancelledOrderRatioReportImpl;

  factory _CancelledOrderRatioReport.fromJson(Map<String, dynamic> json) =
      _$CancelledOrderRatioReportImpl.fromJson;

  @override
  bool get success;
  @override
  CancelledOrderRatioSummary get summary;
  @override
  List<CancelledOrderRatioDetail> get details;
  @override
  List<PartyWiseRatio> get partyWise;
  @override
  List<RatioTrend> get trend;

  /// Create a copy of CancelledOrderRatioReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CancelledOrderRatioReportImplCopyWith<_$CancelledOrderRatioReportImpl>
  get copyWith => throw _privateConstructorUsedError;
}

CancelledOrderRatioSummary _$CancelledOrderRatioSummaryFromJson(
  Map<String, dynamic> json,
) {
  return _CancelledOrderRatioSummary.fromJson(json);
}

/// @nodoc
mixin _$CancelledOrderRatioSummary {
  int? get totalOrders => throw _privateConstructorUsedError;
  int? get cancelledOrders => throw _privateConstructorUsedError;
  int? get activeOrders => throw _privateConstructorUsedError;
  double? get ratio => throw _privateConstructorUsedError;
  Map<String, dynamic>? get sale => throw _privateConstructorUsedError;
  Map<String, dynamic>? get purchase => throw _privateConstructorUsedError;

  /// Serializes this CancelledOrderRatioSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CancelledOrderRatioSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CancelledOrderRatioSummaryCopyWith<CancelledOrderRatioSummary>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CancelledOrderRatioSummaryCopyWith<$Res> {
  factory $CancelledOrderRatioSummaryCopyWith(
    CancelledOrderRatioSummary value,
    $Res Function(CancelledOrderRatioSummary) then,
  ) =
      _$CancelledOrderRatioSummaryCopyWithImpl<
        $Res,
        CancelledOrderRatioSummary
      >;
  @useResult
  $Res call({
    int? totalOrders,
    int? cancelledOrders,
    int? activeOrders,
    double? ratio,
    Map<String, dynamic>? sale,
    Map<String, dynamic>? purchase,
  });
}

/// @nodoc
class _$CancelledOrderRatioSummaryCopyWithImpl<
  $Res,
  $Val extends CancelledOrderRatioSummary
>
    implements $CancelledOrderRatioSummaryCopyWith<$Res> {
  _$CancelledOrderRatioSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CancelledOrderRatioSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalOrders = freezed,
    Object? cancelledOrders = freezed,
    Object? activeOrders = freezed,
    Object? ratio = freezed,
    Object? sale = freezed,
    Object? purchase = freezed,
  }) {
    return _then(
      _value.copyWith(
            totalOrders: freezed == totalOrders
                ? _value.totalOrders
                : totalOrders // ignore: cast_nullable_to_non_nullable
                      as int?,
            cancelledOrders: freezed == cancelledOrders
                ? _value.cancelledOrders
                : cancelledOrders // ignore: cast_nullable_to_non_nullable
                      as int?,
            activeOrders: freezed == activeOrders
                ? _value.activeOrders
                : activeOrders // ignore: cast_nullable_to_non_nullable
                      as int?,
            ratio: freezed == ratio
                ? _value.ratio
                : ratio // ignore: cast_nullable_to_non_nullable
                      as double?,
            sale: freezed == sale
                ? _value.sale
                : sale // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            purchase: freezed == purchase
                ? _value.purchase
                : purchase // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CancelledOrderRatioSummaryImplCopyWith<$Res>
    implements $CancelledOrderRatioSummaryCopyWith<$Res> {
  factory _$$CancelledOrderRatioSummaryImplCopyWith(
    _$CancelledOrderRatioSummaryImpl value,
    $Res Function(_$CancelledOrderRatioSummaryImpl) then,
  ) = __$$CancelledOrderRatioSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int? totalOrders,
    int? cancelledOrders,
    int? activeOrders,
    double? ratio,
    Map<String, dynamic>? sale,
    Map<String, dynamic>? purchase,
  });
}

/// @nodoc
class __$$CancelledOrderRatioSummaryImplCopyWithImpl<$Res>
    extends
        _$CancelledOrderRatioSummaryCopyWithImpl<
          $Res,
          _$CancelledOrderRatioSummaryImpl
        >
    implements _$$CancelledOrderRatioSummaryImplCopyWith<$Res> {
  __$$CancelledOrderRatioSummaryImplCopyWithImpl(
    _$CancelledOrderRatioSummaryImpl _value,
    $Res Function(_$CancelledOrderRatioSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CancelledOrderRatioSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalOrders = freezed,
    Object? cancelledOrders = freezed,
    Object? activeOrders = freezed,
    Object? ratio = freezed,
    Object? sale = freezed,
    Object? purchase = freezed,
  }) {
    return _then(
      _$CancelledOrderRatioSummaryImpl(
        totalOrders: freezed == totalOrders
            ? _value.totalOrders
            : totalOrders // ignore: cast_nullable_to_non_nullable
                  as int?,
        cancelledOrders: freezed == cancelledOrders
            ? _value.cancelledOrders
            : cancelledOrders // ignore: cast_nullable_to_non_nullable
                  as int?,
        activeOrders: freezed == activeOrders
            ? _value.activeOrders
            : activeOrders // ignore: cast_nullable_to_non_nullable
                  as int?,
        ratio: freezed == ratio
            ? _value.ratio
            : ratio // ignore: cast_nullable_to_non_nullable
                  as double?,
        sale: freezed == sale
            ? _value._sale
            : sale // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        purchase: freezed == purchase
            ? _value._purchase
            : purchase // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CancelledOrderRatioSummaryImpl implements _CancelledOrderRatioSummary {
  const _$CancelledOrderRatioSummaryImpl({
    this.totalOrders,
    this.cancelledOrders,
    this.activeOrders,
    this.ratio,
    final Map<String, dynamic>? sale,
    final Map<String, dynamic>? purchase,
  }) : _sale = sale,
       _purchase = purchase;

  factory _$CancelledOrderRatioSummaryImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$CancelledOrderRatioSummaryImplFromJson(json);

  @override
  final int? totalOrders;
  @override
  final int? cancelledOrders;
  @override
  final int? activeOrders;
  @override
  final double? ratio;
  final Map<String, dynamic>? _sale;
  @override
  Map<String, dynamic>? get sale {
    final value = _sale;
    if (value == null) return null;
    if (_sale is EqualUnmodifiableMapView) return _sale;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _purchase;
  @override
  Map<String, dynamic>? get purchase {
    final value = _purchase;
    if (value == null) return null;
    if (_purchase is EqualUnmodifiableMapView) return _purchase;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'CancelledOrderRatioSummary(totalOrders: $totalOrders, cancelledOrders: $cancelledOrders, activeOrders: $activeOrders, ratio: $ratio, sale: $sale, purchase: $purchase)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CancelledOrderRatioSummaryImpl &&
            (identical(other.totalOrders, totalOrders) ||
                other.totalOrders == totalOrders) &&
            (identical(other.cancelledOrders, cancelledOrders) ||
                other.cancelledOrders == cancelledOrders) &&
            (identical(other.activeOrders, activeOrders) ||
                other.activeOrders == activeOrders) &&
            (identical(other.ratio, ratio) || other.ratio == ratio) &&
            const DeepCollectionEquality().equals(other._sale, _sale) &&
            const DeepCollectionEquality().equals(other._purchase, _purchase));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalOrders,
    cancelledOrders,
    activeOrders,
    ratio,
    const DeepCollectionEquality().hash(_sale),
    const DeepCollectionEquality().hash(_purchase),
  );

  /// Create a copy of CancelledOrderRatioSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CancelledOrderRatioSummaryImplCopyWith<_$CancelledOrderRatioSummaryImpl>
  get copyWith =>
      __$$CancelledOrderRatioSummaryImplCopyWithImpl<
        _$CancelledOrderRatioSummaryImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CancelledOrderRatioSummaryImplToJson(this);
  }
}

abstract class _CancelledOrderRatioSummary
    implements CancelledOrderRatioSummary {
  const factory _CancelledOrderRatioSummary({
    final int? totalOrders,
    final int? cancelledOrders,
    final int? activeOrders,
    final double? ratio,
    final Map<String, dynamic>? sale,
    final Map<String, dynamic>? purchase,
  }) = _$CancelledOrderRatioSummaryImpl;

  factory _CancelledOrderRatioSummary.fromJson(Map<String, dynamic> json) =
      _$CancelledOrderRatioSummaryImpl.fromJson;

  @override
  int? get totalOrders;
  @override
  int? get cancelledOrders;
  @override
  int? get activeOrders;
  @override
  double? get ratio;
  @override
  Map<String, dynamic>? get sale;
  @override
  Map<String, dynamic>? get purchase;

  /// Create a copy of CancelledOrderRatioSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CancelledOrderRatioSummaryImplCopyWith<_$CancelledOrderRatioSummaryImpl>
  get copyWith => throw _privateConstructorUsedError;
}

CancelledOrderRatioDetail _$CancelledOrderRatioDetailFromJson(
  Map<String, dynamic> json,
) {
  return _CancelledOrderRatioDetail.fromJson(json);
}

/// @nodoc
mixin _$CancelledOrderRatioDetail {
  String get date => throw _privateConstructorUsedError;
  String get transactionType => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  String get partyName => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  double get netAmount => throw _privateConstructorUsedError;
  bool get cancelledOrders => throw _privateConstructorUsedError;

  /// Serializes this CancelledOrderRatioDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CancelledOrderRatioDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CancelledOrderRatioDetailCopyWith<CancelledOrderRatioDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CancelledOrderRatioDetailCopyWith<$Res> {
  factory $CancelledOrderRatioDetailCopyWith(
    CancelledOrderRatioDetail value,
    $Res Function(CancelledOrderRatioDetail) then,
  ) = _$CancelledOrderRatioDetailCopyWithImpl<$Res, CancelledOrderRatioDetail>;
  @useResult
  $Res call({
    String date,
    String transactionType,
    String label,
    String partyName,
    String status,
    double netAmount,
    bool cancelledOrders,
  });
}

/// @nodoc
class _$CancelledOrderRatioDetailCopyWithImpl<
  $Res,
  $Val extends CancelledOrderRatioDetail
>
    implements $CancelledOrderRatioDetailCopyWith<$Res> {
  _$CancelledOrderRatioDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CancelledOrderRatioDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? transactionType = null,
    Object? label = null,
    Object? partyName = null,
    Object? status = null,
    Object? netAmount = null,
    Object? cancelledOrders = null,
  }) {
    return _then(
      _value.copyWith(
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String,
            transactionType: null == transactionType
                ? _value.transactionType
                : transactionType // ignore: cast_nullable_to_non_nullable
                      as String,
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            partyName: null == partyName
                ? _value.partyName
                : partyName // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            netAmount: null == netAmount
                ? _value.netAmount
                : netAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            cancelledOrders: null == cancelledOrders
                ? _value.cancelledOrders
                : cancelledOrders // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CancelledOrderRatioDetailImplCopyWith<$Res>
    implements $CancelledOrderRatioDetailCopyWith<$Res> {
  factory _$$CancelledOrderRatioDetailImplCopyWith(
    _$CancelledOrderRatioDetailImpl value,
    $Res Function(_$CancelledOrderRatioDetailImpl) then,
  ) = __$$CancelledOrderRatioDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String date,
    String transactionType,
    String label,
    String partyName,
    String status,
    double netAmount,
    bool cancelledOrders,
  });
}

/// @nodoc
class __$$CancelledOrderRatioDetailImplCopyWithImpl<$Res>
    extends
        _$CancelledOrderRatioDetailCopyWithImpl<
          $Res,
          _$CancelledOrderRatioDetailImpl
        >
    implements _$$CancelledOrderRatioDetailImplCopyWith<$Res> {
  __$$CancelledOrderRatioDetailImplCopyWithImpl(
    _$CancelledOrderRatioDetailImpl _value,
    $Res Function(_$CancelledOrderRatioDetailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CancelledOrderRatioDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? transactionType = null,
    Object? label = null,
    Object? partyName = null,
    Object? status = null,
    Object? netAmount = null,
    Object? cancelledOrders = null,
  }) {
    return _then(
      _$CancelledOrderRatioDetailImpl(
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String,
        transactionType: null == transactionType
            ? _value.transactionType
            : transactionType // ignore: cast_nullable_to_non_nullable
                  as String,
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        partyName: null == partyName
            ? _value.partyName
            : partyName // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        netAmount: null == netAmount
            ? _value.netAmount
            : netAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        cancelledOrders: null == cancelledOrders
            ? _value.cancelledOrders
            : cancelledOrders // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CancelledOrderRatioDetailImpl implements _CancelledOrderRatioDetail {
  const _$CancelledOrderRatioDetailImpl({
    required this.date,
    required this.transactionType,
    required this.label,
    required this.partyName,
    required this.status,
    required this.netAmount,
    required this.cancelledOrders,
  });

  factory _$CancelledOrderRatioDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$CancelledOrderRatioDetailImplFromJson(json);

  @override
  final String date;
  @override
  final String transactionType;
  @override
  final String label;
  @override
  final String partyName;
  @override
  final String status;
  @override
  final double netAmount;
  @override
  final bool cancelledOrders;

  @override
  String toString() {
    return 'CancelledOrderRatioDetail(date: $date, transactionType: $transactionType, label: $label, partyName: $partyName, status: $status, netAmount: $netAmount, cancelledOrders: $cancelledOrders)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CancelledOrderRatioDetailImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.transactionType, transactionType) ||
                other.transactionType == transactionType) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.partyName, partyName) ||
                other.partyName == partyName) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.netAmount, netAmount) ||
                other.netAmount == netAmount) &&
            (identical(other.cancelledOrders, cancelledOrders) ||
                other.cancelledOrders == cancelledOrders));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    date,
    transactionType,
    label,
    partyName,
    status,
    netAmount,
    cancelledOrders,
  );

  /// Create a copy of CancelledOrderRatioDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CancelledOrderRatioDetailImplCopyWith<_$CancelledOrderRatioDetailImpl>
  get copyWith =>
      __$$CancelledOrderRatioDetailImplCopyWithImpl<
        _$CancelledOrderRatioDetailImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CancelledOrderRatioDetailImplToJson(this);
  }
}

abstract class _CancelledOrderRatioDetail implements CancelledOrderRatioDetail {
  const factory _CancelledOrderRatioDetail({
    required final String date,
    required final String transactionType,
    required final String label,
    required final String partyName,
    required final String status,
    required final double netAmount,
    required final bool cancelledOrders,
  }) = _$CancelledOrderRatioDetailImpl;

  factory _CancelledOrderRatioDetail.fromJson(Map<String, dynamic> json) =
      _$CancelledOrderRatioDetailImpl.fromJson;

  @override
  String get date;
  @override
  String get transactionType;
  @override
  String get label;
  @override
  String get partyName;
  @override
  String get status;
  @override
  double get netAmount;
  @override
  bool get cancelledOrders;

  /// Create a copy of CancelledOrderRatioDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CancelledOrderRatioDetailImplCopyWith<_$CancelledOrderRatioDetailImpl>
  get copyWith => throw _privateConstructorUsedError;
}

PartyWiseRatio _$PartyWiseRatioFromJson(Map<String, dynamic> json) {
  return _PartyWiseRatio.fromJson(json);
}

/// @nodoc
mixin _$PartyWiseRatio {
  String get partyName => throw _privateConstructorUsedError;
  int get totalOrders => throw _privateConstructorUsedError;
  int get cancelledOrders => throw _privateConstructorUsedError;
  double get ratio => throw _privateConstructorUsedError;

  /// Serializes this PartyWiseRatio to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PartyWiseRatio
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PartyWiseRatioCopyWith<PartyWiseRatio> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PartyWiseRatioCopyWith<$Res> {
  factory $PartyWiseRatioCopyWith(
    PartyWiseRatio value,
    $Res Function(PartyWiseRatio) then,
  ) = _$PartyWiseRatioCopyWithImpl<$Res, PartyWiseRatio>;
  @useResult
  $Res call({
    String partyName,
    int totalOrders,
    int cancelledOrders,
    double ratio,
  });
}

/// @nodoc
class _$PartyWiseRatioCopyWithImpl<$Res, $Val extends PartyWiseRatio>
    implements $PartyWiseRatioCopyWith<$Res> {
  _$PartyWiseRatioCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PartyWiseRatio
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? partyName = null,
    Object? totalOrders = null,
    Object? cancelledOrders = null,
    Object? ratio = null,
  }) {
    return _then(
      _value.copyWith(
            partyName: null == partyName
                ? _value.partyName
                : partyName // ignore: cast_nullable_to_non_nullable
                      as String,
            totalOrders: null == totalOrders
                ? _value.totalOrders
                : totalOrders // ignore: cast_nullable_to_non_nullable
                      as int,
            cancelledOrders: null == cancelledOrders
                ? _value.cancelledOrders
                : cancelledOrders // ignore: cast_nullable_to_non_nullable
                      as int,
            ratio: null == ratio
                ? _value.ratio
                : ratio // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PartyWiseRatioImplCopyWith<$Res>
    implements $PartyWiseRatioCopyWith<$Res> {
  factory _$$PartyWiseRatioImplCopyWith(
    _$PartyWiseRatioImpl value,
    $Res Function(_$PartyWiseRatioImpl) then,
  ) = __$$PartyWiseRatioImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String partyName,
    int totalOrders,
    int cancelledOrders,
    double ratio,
  });
}

/// @nodoc
class __$$PartyWiseRatioImplCopyWithImpl<$Res>
    extends _$PartyWiseRatioCopyWithImpl<$Res, _$PartyWiseRatioImpl>
    implements _$$PartyWiseRatioImplCopyWith<$Res> {
  __$$PartyWiseRatioImplCopyWithImpl(
    _$PartyWiseRatioImpl _value,
    $Res Function(_$PartyWiseRatioImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PartyWiseRatio
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? partyName = null,
    Object? totalOrders = null,
    Object? cancelledOrders = null,
    Object? ratio = null,
  }) {
    return _then(
      _$PartyWiseRatioImpl(
        partyName: null == partyName
            ? _value.partyName
            : partyName // ignore: cast_nullable_to_non_nullable
                  as String,
        totalOrders: null == totalOrders
            ? _value.totalOrders
            : totalOrders // ignore: cast_nullable_to_non_nullable
                  as int,
        cancelledOrders: null == cancelledOrders
            ? _value.cancelledOrders
            : cancelledOrders // ignore: cast_nullable_to_non_nullable
                  as int,
        ratio: null == ratio
            ? _value.ratio
            : ratio // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PartyWiseRatioImpl implements _PartyWiseRatio {
  const _$PartyWiseRatioImpl({
    required this.partyName,
    required this.totalOrders,
    required this.cancelledOrders,
    required this.ratio,
  });

  factory _$PartyWiseRatioImpl.fromJson(Map<String, dynamic> json) =>
      _$$PartyWiseRatioImplFromJson(json);

  @override
  final String partyName;
  @override
  final int totalOrders;
  @override
  final int cancelledOrders;
  @override
  final double ratio;

  @override
  String toString() {
    return 'PartyWiseRatio(partyName: $partyName, totalOrders: $totalOrders, cancelledOrders: $cancelledOrders, ratio: $ratio)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PartyWiseRatioImpl &&
            (identical(other.partyName, partyName) ||
                other.partyName == partyName) &&
            (identical(other.totalOrders, totalOrders) ||
                other.totalOrders == totalOrders) &&
            (identical(other.cancelledOrders, cancelledOrders) ||
                other.cancelledOrders == cancelledOrders) &&
            (identical(other.ratio, ratio) || other.ratio == ratio));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, partyName, totalOrders, cancelledOrders, ratio);

  /// Create a copy of PartyWiseRatio
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PartyWiseRatioImplCopyWith<_$PartyWiseRatioImpl> get copyWith =>
      __$$PartyWiseRatioImplCopyWithImpl<_$PartyWiseRatioImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PartyWiseRatioImplToJson(this);
  }
}

abstract class _PartyWiseRatio implements PartyWiseRatio {
  const factory _PartyWiseRatio({
    required final String partyName,
    required final int totalOrders,
    required final int cancelledOrders,
    required final double ratio,
  }) = _$PartyWiseRatioImpl;

  factory _PartyWiseRatio.fromJson(Map<String, dynamic> json) =
      _$PartyWiseRatioImpl.fromJson;

  @override
  String get partyName;
  @override
  int get totalOrders;
  @override
  int get cancelledOrders;
  @override
  double get ratio;

  /// Create a copy of PartyWiseRatio
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PartyWiseRatioImplCopyWith<_$PartyWiseRatioImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RatioTrend _$RatioTrendFromJson(Map<String, dynamic> json) {
  return _RatioTrend.fromJson(json);
}

/// @nodoc
mixin _$RatioTrend {
  String get period => throw _privateConstructorUsedError;
  double get ratio => throw _privateConstructorUsedError;

  /// Serializes this RatioTrend to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RatioTrend
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RatioTrendCopyWith<RatioTrend> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RatioTrendCopyWith<$Res> {
  factory $RatioTrendCopyWith(
    RatioTrend value,
    $Res Function(RatioTrend) then,
  ) = _$RatioTrendCopyWithImpl<$Res, RatioTrend>;
  @useResult
  $Res call({String period, double ratio});
}

/// @nodoc
class _$RatioTrendCopyWithImpl<$Res, $Val extends RatioTrend>
    implements $RatioTrendCopyWith<$Res> {
  _$RatioTrendCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RatioTrend
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? period = null, Object? ratio = null}) {
    return _then(
      _value.copyWith(
            period: null == period
                ? _value.period
                : period // ignore: cast_nullable_to_non_nullable
                      as String,
            ratio: null == ratio
                ? _value.ratio
                : ratio // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RatioTrendImplCopyWith<$Res>
    implements $RatioTrendCopyWith<$Res> {
  factory _$$RatioTrendImplCopyWith(
    _$RatioTrendImpl value,
    $Res Function(_$RatioTrendImpl) then,
  ) = __$$RatioTrendImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String period, double ratio});
}

/// @nodoc
class __$$RatioTrendImplCopyWithImpl<$Res>
    extends _$RatioTrendCopyWithImpl<$Res, _$RatioTrendImpl>
    implements _$$RatioTrendImplCopyWith<$Res> {
  __$$RatioTrendImplCopyWithImpl(
    _$RatioTrendImpl _value,
    $Res Function(_$RatioTrendImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RatioTrend
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? period = null, Object? ratio = null}) {
    return _then(
      _$RatioTrendImpl(
        period: null == period
            ? _value.period
            : period // ignore: cast_nullable_to_non_nullable
                  as String,
        ratio: null == ratio
            ? _value.ratio
            : ratio // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RatioTrendImpl implements _RatioTrend {
  const _$RatioTrendImpl({required this.period, required this.ratio});

  factory _$RatioTrendImpl.fromJson(Map<String, dynamic> json) =>
      _$$RatioTrendImplFromJson(json);

  @override
  final String period;
  @override
  final double ratio;

  @override
  String toString() {
    return 'RatioTrend(period: $period, ratio: $ratio)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RatioTrendImpl &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.ratio, ratio) || other.ratio == ratio));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, period, ratio);

  /// Create a copy of RatioTrend
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RatioTrendImplCopyWith<_$RatioTrendImpl> get copyWith =>
      __$$RatioTrendImplCopyWithImpl<_$RatioTrendImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RatioTrendImplToJson(this);
  }
}

abstract class _RatioTrend implements RatioTrend {
  const factory _RatioTrend({
    required final String period,
    required final double ratio,
  }) = _$RatioTrendImpl;

  factory _RatioTrend.fromJson(Map<String, dynamic> json) =
      _$RatioTrendImpl.fromJson;

  @override
  String get period;
  @override
  double get ratio;

  /// Create a copy of RatioTrend
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RatioTrendImplCopyWith<_$RatioTrendImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SaleReturnRatioReport _$SaleReturnRatioReportFromJson(
  Map<String, dynamic> json,
) {
  return _SaleReturnRatioReport.fromJson(json);
}

/// @nodoc
mixin _$SaleReturnRatioReport {
  bool get success => throw _privateConstructorUsedError;
  SaleReturnRatioSummary get summary => throw _privateConstructorUsedError;
  List<PartyWiseReturnRatio> get partyWise =>
      throw _privateConstructorUsedError;
  List<RatioTrend> get trend => throw _privateConstructorUsedError;

  /// Serializes this SaleReturnRatioReport to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SaleReturnRatioReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SaleReturnRatioReportCopyWith<SaleReturnRatioReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SaleReturnRatioReportCopyWith<$Res> {
  factory $SaleReturnRatioReportCopyWith(
    SaleReturnRatioReport value,
    $Res Function(SaleReturnRatioReport) then,
  ) = _$SaleReturnRatioReportCopyWithImpl<$Res, SaleReturnRatioReport>;
  @useResult
  $Res call({
    bool success,
    SaleReturnRatioSummary summary,
    List<PartyWiseReturnRatio> partyWise,
    List<RatioTrend> trend,
  });

  $SaleReturnRatioSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class _$SaleReturnRatioReportCopyWithImpl<
  $Res,
  $Val extends SaleReturnRatioReport
>
    implements $SaleReturnRatioReportCopyWith<$Res> {
  _$SaleReturnRatioReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SaleReturnRatioReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? summary = null,
    Object? partyWise = null,
    Object? trend = null,
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
                      as SaleReturnRatioSummary,
            partyWise: null == partyWise
                ? _value.partyWise
                : partyWise // ignore: cast_nullable_to_non_nullable
                      as List<PartyWiseReturnRatio>,
            trend: null == trend
                ? _value.trend
                : trend // ignore: cast_nullable_to_non_nullable
                      as List<RatioTrend>,
          )
          as $Val,
    );
  }

  /// Create a copy of SaleReturnRatioReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SaleReturnRatioSummaryCopyWith<$Res> get summary {
    return $SaleReturnRatioSummaryCopyWith<$Res>(_value.summary, (value) {
      return _then(_value.copyWith(summary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SaleReturnRatioReportImplCopyWith<$Res>
    implements $SaleReturnRatioReportCopyWith<$Res> {
  factory _$$SaleReturnRatioReportImplCopyWith(
    _$SaleReturnRatioReportImpl value,
    $Res Function(_$SaleReturnRatioReportImpl) then,
  ) = __$$SaleReturnRatioReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool success,
    SaleReturnRatioSummary summary,
    List<PartyWiseReturnRatio> partyWise,
    List<RatioTrend> trend,
  });

  @override
  $SaleReturnRatioSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class __$$SaleReturnRatioReportImplCopyWithImpl<$Res>
    extends
        _$SaleReturnRatioReportCopyWithImpl<$Res, _$SaleReturnRatioReportImpl>
    implements _$$SaleReturnRatioReportImplCopyWith<$Res> {
  __$$SaleReturnRatioReportImplCopyWithImpl(
    _$SaleReturnRatioReportImpl _value,
    $Res Function(_$SaleReturnRatioReportImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SaleReturnRatioReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? summary = null,
    Object? partyWise = null,
    Object? trend = null,
  }) {
    return _then(
      _$SaleReturnRatioReportImpl(
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        summary: null == summary
            ? _value.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as SaleReturnRatioSummary,
        partyWise: null == partyWise
            ? _value._partyWise
            : partyWise // ignore: cast_nullable_to_non_nullable
                  as List<PartyWiseReturnRatio>,
        trend: null == trend
            ? _value._trend
            : trend // ignore: cast_nullable_to_non_nullable
                  as List<RatioTrend>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SaleReturnRatioReportImpl implements _SaleReturnRatioReport {
  const _$SaleReturnRatioReportImpl({
    required this.success,
    required this.summary,
    required final List<PartyWiseReturnRatio> partyWise,
    required final List<RatioTrend> trend,
  }) : _partyWise = partyWise,
       _trend = trend;

  factory _$SaleReturnRatioReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$SaleReturnRatioReportImplFromJson(json);

  @override
  final bool success;
  @override
  final SaleReturnRatioSummary summary;
  final List<PartyWiseReturnRatio> _partyWise;
  @override
  List<PartyWiseReturnRatio> get partyWise {
    if (_partyWise is EqualUnmodifiableListView) return _partyWise;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_partyWise);
  }

  final List<RatioTrend> _trend;
  @override
  List<RatioTrend> get trend {
    if (_trend is EqualUnmodifiableListView) return _trend;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_trend);
  }

  @override
  String toString() {
    return 'SaleReturnRatioReport(success: $success, summary: $summary, partyWise: $partyWise, trend: $trend)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SaleReturnRatioReportImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            const DeepCollectionEquality().equals(
              other._partyWise,
              _partyWise,
            ) &&
            const DeepCollectionEquality().equals(other._trend, _trend));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    success,
    summary,
    const DeepCollectionEquality().hash(_partyWise),
    const DeepCollectionEquality().hash(_trend),
  );

  /// Create a copy of SaleReturnRatioReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SaleReturnRatioReportImplCopyWith<_$SaleReturnRatioReportImpl>
  get copyWith =>
      __$$SaleReturnRatioReportImplCopyWithImpl<_$SaleReturnRatioReportImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SaleReturnRatioReportImplToJson(this);
  }
}

abstract class _SaleReturnRatioReport implements SaleReturnRatioReport {
  const factory _SaleReturnRatioReport({
    required final bool success,
    required final SaleReturnRatioSummary summary,
    required final List<PartyWiseReturnRatio> partyWise,
    required final List<RatioTrend> trend,
  }) = _$SaleReturnRatioReportImpl;

  factory _SaleReturnRatioReport.fromJson(Map<String, dynamic> json) =
      _$SaleReturnRatioReportImpl.fromJson;

  @override
  bool get success;
  @override
  SaleReturnRatioSummary get summary;
  @override
  List<PartyWiseReturnRatio> get partyWise;
  @override
  List<RatioTrend> get trend;

  /// Create a copy of SaleReturnRatioReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SaleReturnRatioReportImplCopyWith<_$SaleReturnRatioReportImpl>
  get copyWith => throw _privateConstructorUsedError;
}

SaleReturnRatioSummary _$SaleReturnRatioSummaryFromJson(
  Map<String, dynamic> json,
) {
  return _SaleReturnRatioSummary.fromJson(json);
}

/// @nodoc
mixin _$SaleReturnRatioSummary {
  double get totalSale => throw _privateConstructorUsedError;
  double get totalReturn => throw _privateConstructorUsedError;
  double get netSale => throw _privateConstructorUsedError;
  double get ratio => throw _privateConstructorUsedError;

  /// Serializes this SaleReturnRatioSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SaleReturnRatioSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SaleReturnRatioSummaryCopyWith<SaleReturnRatioSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SaleReturnRatioSummaryCopyWith<$Res> {
  factory $SaleReturnRatioSummaryCopyWith(
    SaleReturnRatioSummary value,
    $Res Function(SaleReturnRatioSummary) then,
  ) = _$SaleReturnRatioSummaryCopyWithImpl<$Res, SaleReturnRatioSummary>;
  @useResult
  $Res call({
    double totalSale,
    double totalReturn,
    double netSale,
    double ratio,
  });
}

/// @nodoc
class _$SaleReturnRatioSummaryCopyWithImpl<
  $Res,
  $Val extends SaleReturnRatioSummary
>
    implements $SaleReturnRatioSummaryCopyWith<$Res> {
  _$SaleReturnRatioSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SaleReturnRatioSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalSale = null,
    Object? totalReturn = null,
    Object? netSale = null,
    Object? ratio = null,
  }) {
    return _then(
      _value.copyWith(
            totalSale: null == totalSale
                ? _value.totalSale
                : totalSale // ignore: cast_nullable_to_non_nullable
                      as double,
            totalReturn: null == totalReturn
                ? _value.totalReturn
                : totalReturn // ignore: cast_nullable_to_non_nullable
                      as double,
            netSale: null == netSale
                ? _value.netSale
                : netSale // ignore: cast_nullable_to_non_nullable
                      as double,
            ratio: null == ratio
                ? _value.ratio
                : ratio // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SaleReturnRatioSummaryImplCopyWith<$Res>
    implements $SaleReturnRatioSummaryCopyWith<$Res> {
  factory _$$SaleReturnRatioSummaryImplCopyWith(
    _$SaleReturnRatioSummaryImpl value,
    $Res Function(_$SaleReturnRatioSummaryImpl) then,
  ) = __$$SaleReturnRatioSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double totalSale,
    double totalReturn,
    double netSale,
    double ratio,
  });
}

/// @nodoc
class __$$SaleReturnRatioSummaryImplCopyWithImpl<$Res>
    extends
        _$SaleReturnRatioSummaryCopyWithImpl<$Res, _$SaleReturnRatioSummaryImpl>
    implements _$$SaleReturnRatioSummaryImplCopyWith<$Res> {
  __$$SaleReturnRatioSummaryImplCopyWithImpl(
    _$SaleReturnRatioSummaryImpl _value,
    $Res Function(_$SaleReturnRatioSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SaleReturnRatioSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalSale = null,
    Object? totalReturn = null,
    Object? netSale = null,
    Object? ratio = null,
  }) {
    return _then(
      _$SaleReturnRatioSummaryImpl(
        totalSale: null == totalSale
            ? _value.totalSale
            : totalSale // ignore: cast_nullable_to_non_nullable
                  as double,
        totalReturn: null == totalReturn
            ? _value.totalReturn
            : totalReturn // ignore: cast_nullable_to_non_nullable
                  as double,
        netSale: null == netSale
            ? _value.netSale
            : netSale // ignore: cast_nullable_to_non_nullable
                  as double,
        ratio: null == ratio
            ? _value.ratio
            : ratio // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SaleReturnRatioSummaryImpl implements _SaleReturnRatioSummary {
  const _$SaleReturnRatioSummaryImpl({
    this.totalSale = 0.0,
    this.totalReturn = 0.0,
    this.netSale = 0.0,
    this.ratio = 0.0,
  });

  factory _$SaleReturnRatioSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$SaleReturnRatioSummaryImplFromJson(json);

  @override
  @JsonKey()
  final double totalSale;
  @override
  @JsonKey()
  final double totalReturn;
  @override
  @JsonKey()
  final double netSale;
  @override
  @JsonKey()
  final double ratio;

  @override
  String toString() {
    return 'SaleReturnRatioSummary(totalSale: $totalSale, totalReturn: $totalReturn, netSale: $netSale, ratio: $ratio)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SaleReturnRatioSummaryImpl &&
            (identical(other.totalSale, totalSale) ||
                other.totalSale == totalSale) &&
            (identical(other.totalReturn, totalReturn) ||
                other.totalReturn == totalReturn) &&
            (identical(other.netSale, netSale) || other.netSale == netSale) &&
            (identical(other.ratio, ratio) || other.ratio == ratio));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, totalSale, totalReturn, netSale, ratio);

  /// Create a copy of SaleReturnRatioSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SaleReturnRatioSummaryImplCopyWith<_$SaleReturnRatioSummaryImpl>
  get copyWith =>
      __$$SaleReturnRatioSummaryImplCopyWithImpl<_$SaleReturnRatioSummaryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SaleReturnRatioSummaryImplToJson(this);
  }
}

abstract class _SaleReturnRatioSummary implements SaleReturnRatioSummary {
  const factory _SaleReturnRatioSummary({
    final double totalSale,
    final double totalReturn,
    final double netSale,
    final double ratio,
  }) = _$SaleReturnRatioSummaryImpl;

  factory _SaleReturnRatioSummary.fromJson(Map<String, dynamic> json) =
      _$SaleReturnRatioSummaryImpl.fromJson;

  @override
  double get totalSale;
  @override
  double get totalReturn;
  @override
  double get netSale;
  @override
  double get ratio;

  /// Create a copy of SaleReturnRatioSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SaleReturnRatioSummaryImplCopyWith<_$SaleReturnRatioSummaryImpl>
  get copyWith => throw _privateConstructorUsedError;
}

PartyWiseReturnRatio _$PartyWiseReturnRatioFromJson(Map<String, dynamic> json) {
  return _PartyWiseReturnRatio.fromJson(json);
}

/// @nodoc
mixin _$PartyWiseReturnRatio {
  String get partyName => throw _privateConstructorUsedError;
  double get totalSale => throw _privateConstructorUsedError;
  double get totalReturn => throw _privateConstructorUsedError;
  double get netSale => throw _privateConstructorUsedError;
  double get ratio => throw _privateConstructorUsedError;

  /// Serializes this PartyWiseReturnRatio to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PartyWiseReturnRatio
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PartyWiseReturnRatioCopyWith<PartyWiseReturnRatio> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PartyWiseReturnRatioCopyWith<$Res> {
  factory $PartyWiseReturnRatioCopyWith(
    PartyWiseReturnRatio value,
    $Res Function(PartyWiseReturnRatio) then,
  ) = _$PartyWiseReturnRatioCopyWithImpl<$Res, PartyWiseReturnRatio>;
  @useResult
  $Res call({
    String partyName,
    double totalSale,
    double totalReturn,
    double netSale,
    double ratio,
  });
}

/// @nodoc
class _$PartyWiseReturnRatioCopyWithImpl<
  $Res,
  $Val extends PartyWiseReturnRatio
>
    implements $PartyWiseReturnRatioCopyWith<$Res> {
  _$PartyWiseReturnRatioCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PartyWiseReturnRatio
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? partyName = null,
    Object? totalSale = null,
    Object? totalReturn = null,
    Object? netSale = null,
    Object? ratio = null,
  }) {
    return _then(
      _value.copyWith(
            partyName: null == partyName
                ? _value.partyName
                : partyName // ignore: cast_nullable_to_non_nullable
                      as String,
            totalSale: null == totalSale
                ? _value.totalSale
                : totalSale // ignore: cast_nullable_to_non_nullable
                      as double,
            totalReturn: null == totalReturn
                ? _value.totalReturn
                : totalReturn // ignore: cast_nullable_to_non_nullable
                      as double,
            netSale: null == netSale
                ? _value.netSale
                : netSale // ignore: cast_nullable_to_non_nullable
                      as double,
            ratio: null == ratio
                ? _value.ratio
                : ratio // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PartyWiseReturnRatioImplCopyWith<$Res>
    implements $PartyWiseReturnRatioCopyWith<$Res> {
  factory _$$PartyWiseReturnRatioImplCopyWith(
    _$PartyWiseReturnRatioImpl value,
    $Res Function(_$PartyWiseReturnRatioImpl) then,
  ) = __$$PartyWiseReturnRatioImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String partyName,
    double totalSale,
    double totalReturn,
    double netSale,
    double ratio,
  });
}

/// @nodoc
class __$$PartyWiseReturnRatioImplCopyWithImpl<$Res>
    extends _$PartyWiseReturnRatioCopyWithImpl<$Res, _$PartyWiseReturnRatioImpl>
    implements _$$PartyWiseReturnRatioImplCopyWith<$Res> {
  __$$PartyWiseReturnRatioImplCopyWithImpl(
    _$PartyWiseReturnRatioImpl _value,
    $Res Function(_$PartyWiseReturnRatioImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PartyWiseReturnRatio
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? partyName = null,
    Object? totalSale = null,
    Object? totalReturn = null,
    Object? netSale = null,
    Object? ratio = null,
  }) {
    return _then(
      _$PartyWiseReturnRatioImpl(
        partyName: null == partyName
            ? _value.partyName
            : partyName // ignore: cast_nullable_to_non_nullable
                  as String,
        totalSale: null == totalSale
            ? _value.totalSale
            : totalSale // ignore: cast_nullable_to_non_nullable
                  as double,
        totalReturn: null == totalReturn
            ? _value.totalReturn
            : totalReturn // ignore: cast_nullable_to_non_nullable
                  as double,
        netSale: null == netSale
            ? _value.netSale
            : netSale // ignore: cast_nullable_to_non_nullable
                  as double,
        ratio: null == ratio
            ? _value.ratio
            : ratio // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PartyWiseReturnRatioImpl implements _PartyWiseReturnRatio {
  const _$PartyWiseReturnRatioImpl({
    required this.partyName,
    this.totalSale = 0.0,
    this.totalReturn = 0.0,
    this.netSale = 0.0,
    this.ratio = 0.0,
  });

  factory _$PartyWiseReturnRatioImpl.fromJson(Map<String, dynamic> json) =>
      _$$PartyWiseReturnRatioImplFromJson(json);

  @override
  final String partyName;
  @override
  @JsonKey()
  final double totalSale;
  @override
  @JsonKey()
  final double totalReturn;
  @override
  @JsonKey()
  final double netSale;
  @override
  @JsonKey()
  final double ratio;

  @override
  String toString() {
    return 'PartyWiseReturnRatio(partyName: $partyName, totalSale: $totalSale, totalReturn: $totalReturn, netSale: $netSale, ratio: $ratio)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PartyWiseReturnRatioImpl &&
            (identical(other.partyName, partyName) ||
                other.partyName == partyName) &&
            (identical(other.totalSale, totalSale) ||
                other.totalSale == totalSale) &&
            (identical(other.totalReturn, totalReturn) ||
                other.totalReturn == totalReturn) &&
            (identical(other.netSale, netSale) || other.netSale == netSale) &&
            (identical(other.ratio, ratio) || other.ratio == ratio));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    partyName,
    totalSale,
    totalReturn,
    netSale,
    ratio,
  );

  /// Create a copy of PartyWiseReturnRatio
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PartyWiseReturnRatioImplCopyWith<_$PartyWiseReturnRatioImpl>
  get copyWith =>
      __$$PartyWiseReturnRatioImplCopyWithImpl<_$PartyWiseReturnRatioImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PartyWiseReturnRatioImplToJson(this);
  }
}

abstract class _PartyWiseReturnRatio implements PartyWiseReturnRatio {
  const factory _PartyWiseReturnRatio({
    required final String partyName,
    final double totalSale,
    final double totalReturn,
    final double netSale,
    final double ratio,
  }) = _$PartyWiseReturnRatioImpl;

  factory _PartyWiseReturnRatio.fromJson(Map<String, dynamic> json) =
      _$PartyWiseReturnRatioImpl.fromJson;

  @override
  String get partyName;
  @override
  double get totalSale;
  @override
  double get totalReturn;
  @override
  double get netSale;
  @override
  double get ratio;

  /// Create a copy of PartyWiseReturnRatio
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PartyWiseReturnRatioImplCopyWith<_$PartyWiseReturnRatioImpl>
  get copyWith => throw _privateConstructorUsedError;
}
