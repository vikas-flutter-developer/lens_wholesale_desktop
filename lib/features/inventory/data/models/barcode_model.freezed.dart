// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'barcode_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BarcodeModel _$BarcodeModelFromJson(Map<String, dynamic> json) {
  return _BarcodeModel.fromJson(json);
}

/// @nodoc
mixin _$BarcodeModel {
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'companyId')
  String? get companyId => throw _privateConstructorUsedError;
  String get barcode => throw _privateConstructorUsedError;
  String get productId => throw _privateConstructorUsedError;
  double get sph => throw _privateConstructorUsedError;
  double get cyl => throw _privateConstructorUsedError;
  double get axis => throw _privateConstructorUsedError;
  double get add => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;
  String? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this BarcodeModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BarcodeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BarcodeModelCopyWith<BarcodeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BarcodeModelCopyWith<$Res> {
  factory $BarcodeModelCopyWith(
    BarcodeModel value,
    $Res Function(BarcodeModel) then,
  ) = _$BarcodeModelCopyWithImpl<$Res, BarcodeModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    @JsonKey(name: 'companyId') String? companyId,
    String barcode,
    String productId,
    double sph,
    double cyl,
    double axis,
    double add,
    Map<String, dynamic> metadata,
    String? createdAt,
    String? updatedAt,
  });
}

/// @nodoc
class _$BarcodeModelCopyWithImpl<$Res, $Val extends BarcodeModel>
    implements $BarcodeModelCopyWith<$Res> {
  _$BarcodeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BarcodeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? companyId = freezed,
    Object? barcode = null,
    Object? productId = null,
    Object? sph = null,
    Object? cyl = null,
    Object? axis = null,
    Object? add = null,
    Object? metadata = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            companyId: freezed == companyId
                ? _value.companyId
                : companyId // ignore: cast_nullable_to_non_nullable
                      as String?,
            barcode: null == barcode
                ? _value.barcode
                : barcode // ignore: cast_nullable_to_non_nullable
                      as String,
            productId: null == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
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
            metadata: null == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
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
abstract class _$$BarcodeModelImplCopyWith<$Res>
    implements $BarcodeModelCopyWith<$Res> {
  factory _$$BarcodeModelImplCopyWith(
    _$BarcodeModelImpl value,
    $Res Function(_$BarcodeModelImpl) then,
  ) = __$$BarcodeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    @JsonKey(name: 'companyId') String? companyId,
    String barcode,
    String productId,
    double sph,
    double cyl,
    double axis,
    double add,
    Map<String, dynamic> metadata,
    String? createdAt,
    String? updatedAt,
  });
}

/// @nodoc
class __$$BarcodeModelImplCopyWithImpl<$Res>
    extends _$BarcodeModelCopyWithImpl<$Res, _$BarcodeModelImpl>
    implements _$$BarcodeModelImplCopyWith<$Res> {
  __$$BarcodeModelImplCopyWithImpl(
    _$BarcodeModelImpl _value,
    $Res Function(_$BarcodeModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BarcodeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? companyId = freezed,
    Object? barcode = null,
    Object? productId = null,
    Object? sph = null,
    Object? cyl = null,
    Object? axis = null,
    Object? add = null,
    Object? metadata = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$BarcodeModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        companyId: freezed == companyId
            ? _value.companyId
            : companyId // ignore: cast_nullable_to_non_nullable
                  as String?,
        barcode: null == barcode
            ? _value.barcode
            : barcode // ignore: cast_nullable_to_non_nullable
                  as String,
        productId: null == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
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
        metadata: null == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
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
class _$BarcodeModelImpl implements _BarcodeModel {
  const _$BarcodeModelImpl({
    @JsonKey(name: '_id') this.id,
    @JsonKey(name: 'companyId') this.companyId,
    required this.barcode,
    required this.productId,
    this.sph = 0,
    this.cyl = 0,
    this.axis = 0,
    this.add = 0,
    final Map<String, dynamic> metadata = const {},
    this.createdAt,
    this.updatedAt,
  }) : _metadata = metadata;

  factory _$BarcodeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BarcodeModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String? id;
  @override
  @JsonKey(name: 'companyId')
  final String? companyId;
  @override
  final String barcode;
  @override
  final String productId;
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
  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  final String? createdAt;
  @override
  final String? updatedAt;

  @override
  String toString() {
    return 'BarcodeModel(id: $id, companyId: $companyId, barcode: $barcode, productId: $productId, sph: $sph, cyl: $cyl, axis: $axis, add: $add, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BarcodeModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.barcode, barcode) || other.barcode == barcode) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.sph, sph) || other.sph == sph) &&
            (identical(other.cyl, cyl) || other.cyl == cyl) &&
            (identical(other.axis, axis) || other.axis == axis) &&
            (identical(other.add, add) || other.add == add) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
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
    companyId,
    barcode,
    productId,
    sph,
    cyl,
    axis,
    add,
    const DeepCollectionEquality().hash(_metadata),
    createdAt,
    updatedAt,
  );

  /// Create a copy of BarcodeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BarcodeModelImplCopyWith<_$BarcodeModelImpl> get copyWith =>
      __$$BarcodeModelImplCopyWithImpl<_$BarcodeModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BarcodeModelImplToJson(this);
  }
}

abstract class _BarcodeModel implements BarcodeModel {
  const factory _BarcodeModel({
    @JsonKey(name: '_id') final String? id,
    @JsonKey(name: 'companyId') final String? companyId,
    required final String barcode,
    required final String productId,
    final double sph,
    final double cyl,
    final double axis,
    final double add,
    final Map<String, dynamic> metadata,
    final String? createdAt,
    final String? updatedAt,
  }) = _$BarcodeModelImpl;

  factory _BarcodeModel.fromJson(Map<String, dynamic> json) =
      _$BarcodeModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String? get id;
  @override
  @JsonKey(name: 'companyId')
  String? get companyId;
  @override
  String get barcode;
  @override
  String get productId;
  @override
  double get sph;
  @override
  double get cyl;
  @override
  double get axis;
  @override
  double get add;
  @override
  Map<String, dynamic> get metadata;
  @override
  String? get createdAt;
  @override
  String? get updatedAt;

  /// Create a copy of BarcodeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BarcodeModelImplCopyWith<_$BarcodeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
