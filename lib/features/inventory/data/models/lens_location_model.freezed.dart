// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lens_location_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LensLocationModel _$LensLocationModelFromJson(Map<String, dynamic> json) {
  return _LensLocationModel.fromJson(json);
}

/// @nodoc
mixin _$LensLocationModel {
  @JsonKey(fromJson: _parseString)
  String get godown => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String get rack => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String get box => throw _privateConstructorUsedError;

  /// Serializes this LensLocationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LensLocationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LensLocationModelCopyWith<LensLocationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LensLocationModelCopyWith<$Res> {
  factory $LensLocationModelCopyWith(
    LensLocationModel value,
    $Res Function(LensLocationModel) then,
  ) = _$LensLocationModelCopyWithImpl<$Res, LensLocationModel>;
  @useResult
  $Res call({
    @JsonKey(fromJson: _parseString) String godown,
    @JsonKey(fromJson: _parseString) String rack,
    @JsonKey(fromJson: _parseString) String box,
  });
}

/// @nodoc
class _$LensLocationModelCopyWithImpl<$Res, $Val extends LensLocationModel>
    implements $LensLocationModelCopyWith<$Res> {
  _$LensLocationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LensLocationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? godown = null, Object? rack = null, Object? box = null}) {
    return _then(
      _value.copyWith(
            godown: null == godown
                ? _value.godown
                : godown // ignore: cast_nullable_to_non_nullable
                      as String,
            rack: null == rack
                ? _value.rack
                : rack // ignore: cast_nullable_to_non_nullable
                      as String,
            box: null == box
                ? _value.box
                : box // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LensLocationModelImplCopyWith<$Res>
    implements $LensLocationModelCopyWith<$Res> {
  factory _$$LensLocationModelImplCopyWith(
    _$LensLocationModelImpl value,
    $Res Function(_$LensLocationModelImpl) then,
  ) = __$$LensLocationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: _parseString) String godown,
    @JsonKey(fromJson: _parseString) String rack,
    @JsonKey(fromJson: _parseString) String box,
  });
}

/// @nodoc
class __$$LensLocationModelImplCopyWithImpl<$Res>
    extends _$LensLocationModelCopyWithImpl<$Res, _$LensLocationModelImpl>
    implements _$$LensLocationModelImplCopyWith<$Res> {
  __$$LensLocationModelImplCopyWithImpl(
    _$LensLocationModelImpl _value,
    $Res Function(_$LensLocationModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LensLocationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? godown = null, Object? rack = null, Object? box = null}) {
    return _then(
      _$LensLocationModelImpl(
        godown: null == godown
            ? _value.godown
            : godown // ignore: cast_nullable_to_non_nullable
                  as String,
        rack: null == rack
            ? _value.rack
            : rack // ignore: cast_nullable_to_non_nullable
                  as String,
        box: null == box
            ? _value.box
            : box // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LensLocationModelImpl implements _LensLocationModel {
  const _$LensLocationModelImpl({
    @JsonKey(fromJson: _parseString) this.godown = '-',
    @JsonKey(fromJson: _parseString) this.rack = '-',
    @JsonKey(fromJson: _parseString) this.box = '-',
  });

  factory _$LensLocationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LensLocationModelImplFromJson(json);

  @override
  @JsonKey(fromJson: _parseString)
  final String godown;
  @override
  @JsonKey(fromJson: _parseString)
  final String rack;
  @override
  @JsonKey(fromJson: _parseString)
  final String box;

  @override
  String toString() {
    return 'LensLocationModel(godown: $godown, rack: $rack, box: $box)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LensLocationModelImpl &&
            (identical(other.godown, godown) || other.godown == godown) &&
            (identical(other.rack, rack) || other.rack == rack) &&
            (identical(other.box, box) || other.box == box));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, godown, rack, box);

  /// Create a copy of LensLocationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LensLocationModelImplCopyWith<_$LensLocationModelImpl> get copyWith =>
      __$$LensLocationModelImplCopyWithImpl<_$LensLocationModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LensLocationModelImplToJson(this);
  }
}

abstract class _LensLocationModel implements LensLocationModel {
  const factory _LensLocationModel({
    @JsonKey(fromJson: _parseString) final String godown,
    @JsonKey(fromJson: _parseString) final String rack,
    @JsonKey(fromJson: _parseString) final String box,
  }) = _$LensLocationModelImpl;

  factory _LensLocationModel.fromJson(Map<String, dynamic> json) =
      _$LensLocationModelImpl.fromJson;

  @override
  @JsonKey(fromJson: _parseString)
  String get godown;
  @override
  @JsonKey(fromJson: _parseString)
  String get rack;
  @override
  @JsonKey(fromJson: _parseString)
  String get box;

  /// Create a copy of LensLocationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LensLocationModelImplCopyWith<_$LensLocationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
