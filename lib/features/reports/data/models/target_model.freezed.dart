// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'target_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TargetReport _$TargetReportFromJson(Map<String, dynamic> json) {
  return _TargetReport.fromJson(json);
}

/// @nodoc
mixin _$TargetReport {
  bool get success => throw _privateConstructorUsedError;
  TargetSummary? get summary => throw _privateConstructorUsedError;
  List<AgentPerformance> get data => throw _privateConstructorUsedError;

  /// Serializes this TargetReport to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TargetReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TargetReportCopyWith<TargetReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TargetReportCopyWith<$Res> {
  factory $TargetReportCopyWith(
    TargetReport value,
    $Res Function(TargetReport) then,
  ) = _$TargetReportCopyWithImpl<$Res, TargetReport>;
  @useResult
  $Res call({
    bool success,
    TargetSummary? summary,
    List<AgentPerformance> data,
  });

  $TargetSummaryCopyWith<$Res>? get summary;
}

/// @nodoc
class _$TargetReportCopyWithImpl<$Res, $Val extends TargetReport>
    implements $TargetReportCopyWith<$Res> {
  _$TargetReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TargetReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? summary = freezed,
    Object? data = null,
  }) {
    return _then(
      _value.copyWith(
            success: null == success
                ? _value.success
                : success // ignore: cast_nullable_to_non_nullable
                      as bool,
            summary: freezed == summary
                ? _value.summary
                : summary // ignore: cast_nullable_to_non_nullable
                      as TargetSummary?,
            data: null == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as List<AgentPerformance>,
          )
          as $Val,
    );
  }

  /// Create a copy of TargetReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TargetSummaryCopyWith<$Res>? get summary {
    if (_value.summary == null) {
      return null;
    }

    return $TargetSummaryCopyWith<$Res>(_value.summary!, (value) {
      return _then(_value.copyWith(summary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TargetReportImplCopyWith<$Res>
    implements $TargetReportCopyWith<$Res> {
  factory _$$TargetReportImplCopyWith(
    _$TargetReportImpl value,
    $Res Function(_$TargetReportImpl) then,
  ) = __$$TargetReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool success,
    TargetSummary? summary,
    List<AgentPerformance> data,
  });

  @override
  $TargetSummaryCopyWith<$Res>? get summary;
}

/// @nodoc
class __$$TargetReportImplCopyWithImpl<$Res>
    extends _$TargetReportCopyWithImpl<$Res, _$TargetReportImpl>
    implements _$$TargetReportImplCopyWith<$Res> {
  __$$TargetReportImplCopyWithImpl(
    _$TargetReportImpl _value,
    $Res Function(_$TargetReportImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TargetReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? summary = freezed,
    Object? data = null,
  }) {
    return _then(
      _$TargetReportImpl(
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        summary: freezed == summary
            ? _value.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as TargetSummary?,
        data: null == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as List<AgentPerformance>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TargetReportImpl implements _TargetReport {
  const _$TargetReportImpl({
    required this.success,
    this.summary,
    required final List<AgentPerformance> data,
  }) : _data = data;

  factory _$TargetReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$TargetReportImplFromJson(json);

  @override
  final bool success;
  @override
  final TargetSummary? summary;
  final List<AgentPerformance> _data;
  @override
  List<AgentPerformance> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  String toString() {
    return 'TargetReport(success: $success, summary: $summary, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TargetReportImpl &&
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

  /// Create a copy of TargetReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TargetReportImplCopyWith<_$TargetReportImpl> get copyWith =>
      __$$TargetReportImplCopyWithImpl<_$TargetReportImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TargetReportImplToJson(this);
  }
}

abstract class _TargetReport implements TargetReport {
  const factory _TargetReport({
    required final bool success,
    final TargetSummary? summary,
    required final List<AgentPerformance> data,
  }) = _$TargetReportImpl;

  factory _TargetReport.fromJson(Map<String, dynamic> json) =
      _$TargetReportImpl.fromJson;

  @override
  bool get success;
  @override
  TargetSummary? get summary;
  @override
  List<AgentPerformance> get data;

  /// Create a copy of TargetReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TargetReportImplCopyWith<_$TargetReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TargetSummary _$TargetSummaryFromJson(Map<String, dynamic> json) {
  return _TargetSummary.fromJson(json);
}

/// @nodoc
mixin _$TargetSummary {
  double get totalTarget => throw _privateConstructorUsedError;
  double get totalAchieved => throw _privateConstructorUsedError;
  double get ratio => throw _privateConstructorUsedError;

  /// Serializes this TargetSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TargetSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TargetSummaryCopyWith<TargetSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TargetSummaryCopyWith<$Res> {
  factory $TargetSummaryCopyWith(
    TargetSummary value,
    $Res Function(TargetSummary) then,
  ) = _$TargetSummaryCopyWithImpl<$Res, TargetSummary>;
  @useResult
  $Res call({double totalTarget, double totalAchieved, double ratio});
}

/// @nodoc
class _$TargetSummaryCopyWithImpl<$Res, $Val extends TargetSummary>
    implements $TargetSummaryCopyWith<$Res> {
  _$TargetSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TargetSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalTarget = null,
    Object? totalAchieved = null,
    Object? ratio = null,
  }) {
    return _then(
      _value.copyWith(
            totalTarget: null == totalTarget
                ? _value.totalTarget
                : totalTarget // ignore: cast_nullable_to_non_nullable
                      as double,
            totalAchieved: null == totalAchieved
                ? _value.totalAchieved
                : totalAchieved // ignore: cast_nullable_to_non_nullable
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
abstract class _$$TargetSummaryImplCopyWith<$Res>
    implements $TargetSummaryCopyWith<$Res> {
  factory _$$TargetSummaryImplCopyWith(
    _$TargetSummaryImpl value,
    $Res Function(_$TargetSummaryImpl) then,
  ) = __$$TargetSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double totalTarget, double totalAchieved, double ratio});
}

/// @nodoc
class __$$TargetSummaryImplCopyWithImpl<$Res>
    extends _$TargetSummaryCopyWithImpl<$Res, _$TargetSummaryImpl>
    implements _$$TargetSummaryImplCopyWith<$Res> {
  __$$TargetSummaryImplCopyWithImpl(
    _$TargetSummaryImpl _value,
    $Res Function(_$TargetSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TargetSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalTarget = null,
    Object? totalAchieved = null,
    Object? ratio = null,
  }) {
    return _then(
      _$TargetSummaryImpl(
        totalTarget: null == totalTarget
            ? _value.totalTarget
            : totalTarget // ignore: cast_nullable_to_non_nullable
                  as double,
        totalAchieved: null == totalAchieved
            ? _value.totalAchieved
            : totalAchieved // ignore: cast_nullable_to_non_nullable
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
class _$TargetSummaryImpl implements _TargetSummary {
  const _$TargetSummaryImpl({
    required this.totalTarget,
    required this.totalAchieved,
    required this.ratio,
  });

  factory _$TargetSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$TargetSummaryImplFromJson(json);

  @override
  final double totalTarget;
  @override
  final double totalAchieved;
  @override
  final double ratio;

  @override
  String toString() {
    return 'TargetSummary(totalTarget: $totalTarget, totalAchieved: $totalAchieved, ratio: $ratio)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TargetSummaryImpl &&
            (identical(other.totalTarget, totalTarget) ||
                other.totalTarget == totalTarget) &&
            (identical(other.totalAchieved, totalAchieved) ||
                other.totalAchieved == totalAchieved) &&
            (identical(other.ratio, ratio) || other.ratio == ratio));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, totalTarget, totalAchieved, ratio);

  /// Create a copy of TargetSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TargetSummaryImplCopyWith<_$TargetSummaryImpl> get copyWith =>
      __$$TargetSummaryImplCopyWithImpl<_$TargetSummaryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TargetSummaryImplToJson(this);
  }
}

abstract class _TargetSummary implements TargetSummary {
  const factory _TargetSummary({
    required final double totalTarget,
    required final double totalAchieved,
    required final double ratio,
  }) = _$TargetSummaryImpl;

  factory _TargetSummary.fromJson(Map<String, dynamic> json) =
      _$TargetSummaryImpl.fromJson;

  @override
  double get totalTarget;
  @override
  double get totalAchieved;
  @override
  double get ratio;

  /// Create a copy of TargetSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TargetSummaryImplCopyWith<_$TargetSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AgentPerformance _$AgentPerformanceFromJson(Map<String, dynamic> json) {
  return _AgentPerformance.fromJson(json);
}

/// @nodoc
mixin _$AgentPerformance {
  String get partyName => throw _privateConstructorUsedError;
  double get targetAmount => throw _privateConstructorUsedError;
  double get achieved => throw _privateConstructorUsedError;
  double get difference => throw _privateConstructorUsedError;
  double get ratio => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get targetId => throw _privateConstructorUsedError;
  String get periodType => throw _privateConstructorUsedError;
  int get year => throw _privateConstructorUsedError;
  int? get month => throw _privateConstructorUsedError;
  int? get quarter => throw _privateConstructorUsedError;

  /// Serializes this AgentPerformance to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AgentPerformance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AgentPerformanceCopyWith<AgentPerformance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AgentPerformanceCopyWith<$Res> {
  factory $AgentPerformanceCopyWith(
    AgentPerformance value,
    $Res Function(AgentPerformance) then,
  ) = _$AgentPerformanceCopyWithImpl<$Res, AgentPerformance>;
  @useResult
  $Res call({
    String partyName,
    double targetAmount,
    double achieved,
    double difference,
    double ratio,
    String status,
    String? targetId,
    String periodType,
    int year,
    int? month,
    int? quarter,
  });
}

/// @nodoc
class _$AgentPerformanceCopyWithImpl<$Res, $Val extends AgentPerformance>
    implements $AgentPerformanceCopyWith<$Res> {
  _$AgentPerformanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AgentPerformance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? partyName = null,
    Object? targetAmount = null,
    Object? achieved = null,
    Object? difference = null,
    Object? ratio = null,
    Object? status = null,
    Object? targetId = freezed,
    Object? periodType = null,
    Object? year = null,
    Object? month = freezed,
    Object? quarter = freezed,
  }) {
    return _then(
      _value.copyWith(
            partyName: null == partyName
                ? _value.partyName
                : partyName // ignore: cast_nullable_to_non_nullable
                      as String,
            targetAmount: null == targetAmount
                ? _value.targetAmount
                : targetAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            achieved: null == achieved
                ? _value.achieved
                : achieved // ignore: cast_nullable_to_non_nullable
                      as double,
            difference: null == difference
                ? _value.difference
                : difference // ignore: cast_nullable_to_non_nullable
                      as double,
            ratio: null == ratio
                ? _value.ratio
                : ratio // ignore: cast_nullable_to_non_nullable
                      as double,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            targetId: freezed == targetId
                ? _value.targetId
                : targetId // ignore: cast_nullable_to_non_nullable
                      as String?,
            periodType: null == periodType
                ? _value.periodType
                : periodType // ignore: cast_nullable_to_non_nullable
                      as String,
            year: null == year
                ? _value.year
                : year // ignore: cast_nullable_to_non_nullable
                      as int,
            month: freezed == month
                ? _value.month
                : month // ignore: cast_nullable_to_non_nullable
                      as int?,
            quarter: freezed == quarter
                ? _value.quarter
                : quarter // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AgentPerformanceImplCopyWith<$Res>
    implements $AgentPerformanceCopyWith<$Res> {
  factory _$$AgentPerformanceImplCopyWith(
    _$AgentPerformanceImpl value,
    $Res Function(_$AgentPerformanceImpl) then,
  ) = __$$AgentPerformanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String partyName,
    double targetAmount,
    double achieved,
    double difference,
    double ratio,
    String status,
    String? targetId,
    String periodType,
    int year,
    int? month,
    int? quarter,
  });
}

/// @nodoc
class __$$AgentPerformanceImplCopyWithImpl<$Res>
    extends _$AgentPerformanceCopyWithImpl<$Res, _$AgentPerformanceImpl>
    implements _$$AgentPerformanceImplCopyWith<$Res> {
  __$$AgentPerformanceImplCopyWithImpl(
    _$AgentPerformanceImpl _value,
    $Res Function(_$AgentPerformanceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AgentPerformance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? partyName = null,
    Object? targetAmount = null,
    Object? achieved = null,
    Object? difference = null,
    Object? ratio = null,
    Object? status = null,
    Object? targetId = freezed,
    Object? periodType = null,
    Object? year = null,
    Object? month = freezed,
    Object? quarter = freezed,
  }) {
    return _then(
      _$AgentPerformanceImpl(
        partyName: null == partyName
            ? _value.partyName
            : partyName // ignore: cast_nullable_to_non_nullable
                  as String,
        targetAmount: null == targetAmount
            ? _value.targetAmount
            : targetAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        achieved: null == achieved
            ? _value.achieved
            : achieved // ignore: cast_nullable_to_non_nullable
                  as double,
        difference: null == difference
            ? _value.difference
            : difference // ignore: cast_nullable_to_non_nullable
                  as double,
        ratio: null == ratio
            ? _value.ratio
            : ratio // ignore: cast_nullable_to_non_nullable
                  as double,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        targetId: freezed == targetId
            ? _value.targetId
            : targetId // ignore: cast_nullable_to_non_nullable
                  as String?,
        periodType: null == periodType
            ? _value.periodType
            : periodType // ignore: cast_nullable_to_non_nullable
                  as String,
        year: null == year
            ? _value.year
            : year // ignore: cast_nullable_to_non_nullable
                  as int,
        month: freezed == month
            ? _value.month
            : month // ignore: cast_nullable_to_non_nullable
                  as int?,
        quarter: freezed == quarter
            ? _value.quarter
            : quarter // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AgentPerformanceImpl implements _AgentPerformance {
  const _$AgentPerformanceImpl({
    required this.partyName,
    required this.targetAmount,
    required this.achieved,
    required this.difference,
    required this.ratio,
    required this.status,
    this.targetId,
    required this.periodType,
    required this.year,
    this.month,
    this.quarter,
  });

  factory _$AgentPerformanceImpl.fromJson(Map<String, dynamic> json) =>
      _$$AgentPerformanceImplFromJson(json);

  @override
  final String partyName;
  @override
  final double targetAmount;
  @override
  final double achieved;
  @override
  final double difference;
  @override
  final double ratio;
  @override
  final String status;
  @override
  final String? targetId;
  @override
  final String periodType;
  @override
  final int year;
  @override
  final int? month;
  @override
  final int? quarter;

  @override
  String toString() {
    return 'AgentPerformance(partyName: $partyName, targetAmount: $targetAmount, achieved: $achieved, difference: $difference, ratio: $ratio, status: $status, targetId: $targetId, periodType: $periodType, year: $year, month: $month, quarter: $quarter)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AgentPerformanceImpl &&
            (identical(other.partyName, partyName) ||
                other.partyName == partyName) &&
            (identical(other.targetAmount, targetAmount) ||
                other.targetAmount == targetAmount) &&
            (identical(other.achieved, achieved) ||
                other.achieved == achieved) &&
            (identical(other.difference, difference) ||
                other.difference == difference) &&
            (identical(other.ratio, ratio) || other.ratio == ratio) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.targetId, targetId) ||
                other.targetId == targetId) &&
            (identical(other.periodType, periodType) ||
                other.periodType == periodType) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.quarter, quarter) || other.quarter == quarter));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    partyName,
    targetAmount,
    achieved,
    difference,
    ratio,
    status,
    targetId,
    periodType,
    year,
    month,
    quarter,
  );

  /// Create a copy of AgentPerformance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AgentPerformanceImplCopyWith<_$AgentPerformanceImpl> get copyWith =>
      __$$AgentPerformanceImplCopyWithImpl<_$AgentPerformanceImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AgentPerformanceImplToJson(this);
  }
}

abstract class _AgentPerformance implements AgentPerformance {
  const factory _AgentPerformance({
    required final String partyName,
    required final double targetAmount,
    required final double achieved,
    required final double difference,
    required final double ratio,
    required final String status,
    final String? targetId,
    required final String periodType,
    required final int year,
    final int? month,
    final int? quarter,
  }) = _$AgentPerformanceImpl;

  factory _AgentPerformance.fromJson(Map<String, dynamic> json) =
      _$AgentPerformanceImpl.fromJson;

  @override
  String get partyName;
  @override
  double get targetAmount;
  @override
  double get achieved;
  @override
  double get difference;
  @override
  double get ratio;
  @override
  String get status;
  @override
  String? get targetId;
  @override
  String get periodType;
  @override
  int get year;
  @override
  int? get month;
  @override
  int? get quarter;

  /// Create a copy of AgentPerformance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AgentPerformanceImplCopyWith<_$AgentPerformanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TargetEntry _$TargetEntryFromJson(Map<String, dynamic> json) {
  return _TargetEntry.fromJson(json);
}

/// @nodoc
mixin _$TargetEntry {
  String get partyId => throw _privateConstructorUsedError;
  String get partyName => throw _privateConstructorUsedError;
  double get targetAmount => throw _privateConstructorUsedError;
  String get periodType => throw _privateConstructorUsedError;
  int get year => throw _privateConstructorUsedError;
  int? get month => throw _privateConstructorUsedError;
  int? get quarter => throw _privateConstructorUsedError;
  String get startDate => throw _privateConstructorUsedError;
  String get endDate => throw _privateConstructorUsedError;
  String? get targetType => throw _privateConstructorUsedError;

  /// Serializes this TargetEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TargetEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TargetEntryCopyWith<TargetEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TargetEntryCopyWith<$Res> {
  factory $TargetEntryCopyWith(
    TargetEntry value,
    $Res Function(TargetEntry) then,
  ) = _$TargetEntryCopyWithImpl<$Res, TargetEntry>;
  @useResult
  $Res call({
    String partyId,
    String partyName,
    double targetAmount,
    String periodType,
    int year,
    int? month,
    int? quarter,
    String startDate,
    String endDate,
    String? targetType,
  });
}

/// @nodoc
class _$TargetEntryCopyWithImpl<$Res, $Val extends TargetEntry>
    implements $TargetEntryCopyWith<$Res> {
  _$TargetEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TargetEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? partyId = null,
    Object? partyName = null,
    Object? targetAmount = null,
    Object? periodType = null,
    Object? year = null,
    Object? month = freezed,
    Object? quarter = freezed,
    Object? startDate = null,
    Object? endDate = null,
    Object? targetType = freezed,
  }) {
    return _then(
      _value.copyWith(
            partyId: null == partyId
                ? _value.partyId
                : partyId // ignore: cast_nullable_to_non_nullable
                      as String,
            partyName: null == partyName
                ? _value.partyName
                : partyName // ignore: cast_nullable_to_non_nullable
                      as String,
            targetAmount: null == targetAmount
                ? _value.targetAmount
                : targetAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            periodType: null == periodType
                ? _value.periodType
                : periodType // ignore: cast_nullable_to_non_nullable
                      as String,
            year: null == year
                ? _value.year
                : year // ignore: cast_nullable_to_non_nullable
                      as int,
            month: freezed == month
                ? _value.month
                : month // ignore: cast_nullable_to_non_nullable
                      as int?,
            quarter: freezed == quarter
                ? _value.quarter
                : quarter // ignore: cast_nullable_to_non_nullable
                      as int?,
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as String,
            endDate: null == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as String,
            targetType: freezed == targetType
                ? _value.targetType
                : targetType // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TargetEntryImplCopyWith<$Res>
    implements $TargetEntryCopyWith<$Res> {
  factory _$$TargetEntryImplCopyWith(
    _$TargetEntryImpl value,
    $Res Function(_$TargetEntryImpl) then,
  ) = __$$TargetEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String partyId,
    String partyName,
    double targetAmount,
    String periodType,
    int year,
    int? month,
    int? quarter,
    String startDate,
    String endDate,
    String? targetType,
  });
}

/// @nodoc
class __$$TargetEntryImplCopyWithImpl<$Res>
    extends _$TargetEntryCopyWithImpl<$Res, _$TargetEntryImpl>
    implements _$$TargetEntryImplCopyWith<$Res> {
  __$$TargetEntryImplCopyWithImpl(
    _$TargetEntryImpl _value,
    $Res Function(_$TargetEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TargetEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? partyId = null,
    Object? partyName = null,
    Object? targetAmount = null,
    Object? periodType = null,
    Object? year = null,
    Object? month = freezed,
    Object? quarter = freezed,
    Object? startDate = null,
    Object? endDate = null,
    Object? targetType = freezed,
  }) {
    return _then(
      _$TargetEntryImpl(
        partyId: null == partyId
            ? _value.partyId
            : partyId // ignore: cast_nullable_to_non_nullable
                  as String,
        partyName: null == partyName
            ? _value.partyName
            : partyName // ignore: cast_nullable_to_non_nullable
                  as String,
        targetAmount: null == targetAmount
            ? _value.targetAmount
            : targetAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        periodType: null == periodType
            ? _value.periodType
            : periodType // ignore: cast_nullable_to_non_nullable
                  as String,
        year: null == year
            ? _value.year
            : year // ignore: cast_nullable_to_non_nullable
                  as int,
        month: freezed == month
            ? _value.month
            : month // ignore: cast_nullable_to_non_nullable
                  as int?,
        quarter: freezed == quarter
            ? _value.quarter
            : quarter // ignore: cast_nullable_to_non_nullable
                  as int?,
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as String,
        endDate: null == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as String,
        targetType: freezed == targetType
            ? _value.targetType
            : targetType // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TargetEntryImpl implements _TargetEntry {
  const _$TargetEntryImpl({
    required this.partyId,
    required this.partyName,
    required this.targetAmount,
    required this.periodType,
    required this.year,
    this.month,
    this.quarter,
    required this.startDate,
    required this.endDate,
    this.targetType,
  });

  factory _$TargetEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$TargetEntryImplFromJson(json);

  @override
  final String partyId;
  @override
  final String partyName;
  @override
  final double targetAmount;
  @override
  final String periodType;
  @override
  final int year;
  @override
  final int? month;
  @override
  final int? quarter;
  @override
  final String startDate;
  @override
  final String endDate;
  @override
  final String? targetType;

  @override
  String toString() {
    return 'TargetEntry(partyId: $partyId, partyName: $partyName, targetAmount: $targetAmount, periodType: $periodType, year: $year, month: $month, quarter: $quarter, startDate: $startDate, endDate: $endDate, targetType: $targetType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TargetEntryImpl &&
            (identical(other.partyId, partyId) || other.partyId == partyId) &&
            (identical(other.partyName, partyName) ||
                other.partyName == partyName) &&
            (identical(other.targetAmount, targetAmount) ||
                other.targetAmount == targetAmount) &&
            (identical(other.periodType, periodType) ||
                other.periodType == periodType) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.quarter, quarter) || other.quarter == quarter) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.targetType, targetType) ||
                other.targetType == targetType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    partyId,
    partyName,
    targetAmount,
    periodType,
    year,
    month,
    quarter,
    startDate,
    endDate,
    targetType,
  );

  /// Create a copy of TargetEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TargetEntryImplCopyWith<_$TargetEntryImpl> get copyWith =>
      __$$TargetEntryImplCopyWithImpl<_$TargetEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TargetEntryImplToJson(this);
  }
}

abstract class _TargetEntry implements TargetEntry {
  const factory _TargetEntry({
    required final String partyId,
    required final String partyName,
    required final double targetAmount,
    required final String periodType,
    required final int year,
    final int? month,
    final int? quarter,
    required final String startDate,
    required final String endDate,
    final String? targetType,
  }) = _$TargetEntryImpl;

  factory _TargetEntry.fromJson(Map<String, dynamic> json) =
      _$TargetEntryImpl.fromJson;

  @override
  String get partyId;
  @override
  String get partyName;
  @override
  double get targetAmount;
  @override
  String get periodType;
  @override
  int get year;
  @override
  int? get month;
  @override
  int? get quarter;
  @override
  String get startDate;
  @override
  String get endDate;
  @override
  String? get targetType;

  /// Create a copy of TargetEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TargetEntryImplCopyWith<_$TargetEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
