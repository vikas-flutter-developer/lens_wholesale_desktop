// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'power_range_library_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PowerRangeLibraryModel _$PowerRangeLibraryModelFromJson(
  Map<String, dynamic> json,
) {
  return _PowerRangeLibraryModel.fromJson(json);
}

/// @nodoc
mixin _$PowerRangeLibraryModel {
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;
  double get sphMin => throw _privateConstructorUsedError;
  double get sphMax => throw _privateConstructorUsedError;
  double get sphStep => throw _privateConstructorUsedError;
  double get cylMin => throw _privateConstructorUsedError;
  double get cylMax => throw _privateConstructorUsedError;
  double get cylStep => throw _privateConstructorUsedError;
  double get addMin => throw _privateConstructorUsedError;
  double get addMax => throw _privateConstructorUsedError;
  double get addStep => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  List<String> get groupNames => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;
  String? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this PowerRangeLibraryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PowerRangeLibraryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PowerRangeLibraryModelCopyWith<PowerRangeLibraryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PowerRangeLibraryModelCopyWith<$Res> {
  factory $PowerRangeLibraryModelCopyWith(
    PowerRangeLibraryModel value,
    $Res Function(PowerRangeLibraryModel) then,
  ) = _$PowerRangeLibraryModelCopyWithImpl<$Res, PowerRangeLibraryModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    double sphMin,
    double sphMax,
    double sphStep,
    double cylMin,
    double cylMax,
    double cylStep,
    double addMin,
    double addMax,
    double addStep,
    String label,
    List<String> groupNames,
    String? createdAt,
    String? updatedAt,
  });
}

/// @nodoc
class _$PowerRangeLibraryModelCopyWithImpl<
  $Res,
  $Val extends PowerRangeLibraryModel
>
    implements $PowerRangeLibraryModelCopyWith<$Res> {
  _$PowerRangeLibraryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PowerRangeLibraryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? sphMin = null,
    Object? sphMax = null,
    Object? sphStep = null,
    Object? cylMin = null,
    Object? cylMax = null,
    Object? cylStep = null,
    Object? addMin = null,
    Object? addMax = null,
    Object? addStep = null,
    Object? label = null,
    Object? groupNames = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            sphMin: null == sphMin
                ? _value.sphMin
                : sphMin // ignore: cast_nullable_to_non_nullable
                      as double,
            sphMax: null == sphMax
                ? _value.sphMax
                : sphMax // ignore: cast_nullable_to_non_nullable
                      as double,
            sphStep: null == sphStep
                ? _value.sphStep
                : sphStep // ignore: cast_nullable_to_non_nullable
                      as double,
            cylMin: null == cylMin
                ? _value.cylMin
                : cylMin // ignore: cast_nullable_to_non_nullable
                      as double,
            cylMax: null == cylMax
                ? _value.cylMax
                : cylMax // ignore: cast_nullable_to_non_nullable
                      as double,
            cylStep: null == cylStep
                ? _value.cylStep
                : cylStep // ignore: cast_nullable_to_non_nullable
                      as double,
            addMin: null == addMin
                ? _value.addMin
                : addMin // ignore: cast_nullable_to_non_nullable
                      as double,
            addMax: null == addMax
                ? _value.addMax
                : addMax // ignore: cast_nullable_to_non_nullable
                      as double,
            addStep: null == addStep
                ? _value.addStep
                : addStep // ignore: cast_nullable_to_non_nullable
                      as double,
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            groupNames: null == groupNames
                ? _value.groupNames
                : groupNames // ignore: cast_nullable_to_non_nullable
                      as List<String>,
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
}

/// @nodoc
abstract class _$$PowerRangeLibraryModelImplCopyWith<$Res>
    implements $PowerRangeLibraryModelCopyWith<$Res> {
  factory _$$PowerRangeLibraryModelImplCopyWith(
    _$PowerRangeLibraryModelImpl value,
    $Res Function(_$PowerRangeLibraryModelImpl) then,
  ) = __$$PowerRangeLibraryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    double sphMin,
    double sphMax,
    double sphStep,
    double cylMin,
    double cylMax,
    double cylStep,
    double addMin,
    double addMax,
    double addStep,
    String label,
    List<String> groupNames,
    String? createdAt,
    String? updatedAt,
  });
}

/// @nodoc
class __$$PowerRangeLibraryModelImplCopyWithImpl<$Res>
    extends
        _$PowerRangeLibraryModelCopyWithImpl<$Res, _$PowerRangeLibraryModelImpl>
    implements _$$PowerRangeLibraryModelImplCopyWith<$Res> {
  __$$PowerRangeLibraryModelImplCopyWithImpl(
    _$PowerRangeLibraryModelImpl _value,
    $Res Function(_$PowerRangeLibraryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PowerRangeLibraryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? sphMin = null,
    Object? sphMax = null,
    Object? sphStep = null,
    Object? cylMin = null,
    Object? cylMax = null,
    Object? cylStep = null,
    Object? addMin = null,
    Object? addMax = null,
    Object? addStep = null,
    Object? label = null,
    Object? groupNames = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$PowerRangeLibraryModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        sphMin: null == sphMin
            ? _value.sphMin
            : sphMin // ignore: cast_nullable_to_non_nullable
                  as double,
        sphMax: null == sphMax
            ? _value.sphMax
            : sphMax // ignore: cast_nullable_to_non_nullable
                  as double,
        sphStep: null == sphStep
            ? _value.sphStep
            : sphStep // ignore: cast_nullable_to_non_nullable
                  as double,
        cylMin: null == cylMin
            ? _value.cylMin
            : cylMin // ignore: cast_nullable_to_non_nullable
                  as double,
        cylMax: null == cylMax
            ? _value.cylMax
            : cylMax // ignore: cast_nullable_to_non_nullable
                  as double,
        cylStep: null == cylStep
            ? _value.cylStep
            : cylStep // ignore: cast_nullable_to_non_nullable
                  as double,
        addMin: null == addMin
            ? _value.addMin
            : addMin // ignore: cast_nullable_to_non_nullable
                  as double,
        addMax: null == addMax
            ? _value.addMax
            : addMax // ignore: cast_nullable_to_non_nullable
                  as double,
        addStep: null == addStep
            ? _value.addStep
            : addStep // ignore: cast_nullable_to_non_nullable
                  as double,
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        groupNames: null == groupNames
            ? _value._groupNames
            : groupNames // ignore: cast_nullable_to_non_nullable
                  as List<String>,
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
class _$PowerRangeLibraryModelImpl implements _PowerRangeLibraryModel {
  const _$PowerRangeLibraryModelImpl({
    @JsonKey(name: '_id') this.id,
    this.sphMin = 0.0,
    this.sphMax = 0.0,
    this.sphStep = 0.25,
    this.cylMin = 0.0,
    this.cylMax = 0.0,
    this.cylStep = 0.25,
    this.addMin = 0.0,
    this.addMax = 0.0,
    this.addStep = 0.25,
    this.label = '',
    final List<String> groupNames = const [],
    this.createdAt,
    this.updatedAt,
  }) : _groupNames = groupNames;

  factory _$PowerRangeLibraryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PowerRangeLibraryModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String? id;
  @override
  @JsonKey()
  final double sphMin;
  @override
  @JsonKey()
  final double sphMax;
  @override
  @JsonKey()
  final double sphStep;
  @override
  @JsonKey()
  final double cylMin;
  @override
  @JsonKey()
  final double cylMax;
  @override
  @JsonKey()
  final double cylStep;
  @override
  @JsonKey()
  final double addMin;
  @override
  @JsonKey()
  final double addMax;
  @override
  @JsonKey()
  final double addStep;
  @override
  @JsonKey()
  final String label;
  final List<String> _groupNames;
  @override
  @JsonKey()
  List<String> get groupNames {
    if (_groupNames is EqualUnmodifiableListView) return _groupNames;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_groupNames);
  }

  @override
  final String? createdAt;
  @override
  final String? updatedAt;

  @override
  String toString() {
    return 'PowerRangeLibraryModel(id: $id, sphMin: $sphMin, sphMax: $sphMax, sphStep: $sphStep, cylMin: $cylMin, cylMax: $cylMax, cylStep: $cylStep, addMin: $addMin, addMax: $addMax, addStep: $addStep, label: $label, groupNames: $groupNames, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PowerRangeLibraryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sphMin, sphMin) || other.sphMin == sphMin) &&
            (identical(other.sphMax, sphMax) || other.sphMax == sphMax) &&
            (identical(other.sphStep, sphStep) || other.sphStep == sphStep) &&
            (identical(other.cylMin, cylMin) || other.cylMin == cylMin) &&
            (identical(other.cylMax, cylMax) || other.cylMax == cylMax) &&
            (identical(other.cylStep, cylStep) || other.cylStep == cylStep) &&
            (identical(other.addMin, addMin) || other.addMin == addMin) &&
            (identical(other.addMax, addMax) || other.addMax == addMax) &&
            (identical(other.addStep, addStep) || other.addStep == addStep) &&
            (identical(other.label, label) || other.label == label) &&
            const DeepCollectionEquality().equals(
              other._groupNames,
              _groupNames,
            ) &&
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
    sphMin,
    sphMax,
    sphStep,
    cylMin,
    cylMax,
    cylStep,
    addMin,
    addMax,
    addStep,
    label,
    const DeepCollectionEquality().hash(_groupNames),
    createdAt,
    updatedAt,
  );

  /// Create a copy of PowerRangeLibraryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PowerRangeLibraryModelImplCopyWith<_$PowerRangeLibraryModelImpl>
  get copyWith =>
      __$$PowerRangeLibraryModelImplCopyWithImpl<_$PowerRangeLibraryModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PowerRangeLibraryModelImplToJson(this);
  }
}

abstract class _PowerRangeLibraryModel implements PowerRangeLibraryModel {
  const factory _PowerRangeLibraryModel({
    @JsonKey(name: '_id') final String? id,
    final double sphMin,
    final double sphMax,
    final double sphStep,
    final double cylMin,
    final double cylMax,
    final double cylStep,
    final double addMin,
    final double addMax,
    final double addStep,
    final String label,
    final List<String> groupNames,
    final String? createdAt,
    final String? updatedAt,
  }) = _$PowerRangeLibraryModelImpl;

  factory _PowerRangeLibraryModel.fromJson(Map<String, dynamic> json) =
      _$PowerRangeLibraryModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String? get id;
  @override
  double get sphMin;
  @override
  double get sphMax;
  @override
  double get sphStep;
  @override
  double get cylMin;
  @override
  double get cylMax;
  @override
  double get cylStep;
  @override
  double get addMin;
  @override
  double get addMax;
  @override
  double get addStep;
  @override
  String get label;
  @override
  List<String> get groupNames;
  @override
  String? get createdAt;
  @override
  String? get updatedAt;

  /// Create a copy of PowerRangeLibraryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PowerRangeLibraryModelImplCopyWith<_$PowerRangeLibraryModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
