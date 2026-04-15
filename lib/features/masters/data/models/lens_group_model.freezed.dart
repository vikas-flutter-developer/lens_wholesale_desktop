// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lens_group_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LensGroupModel _$LensGroupModelFromJson(Map<String, dynamic> json) {
  return _LensGroupModel.fromJson(json);
}

/// @nodoc
mixin _$LensGroupModel {
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;
  String get groupName => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  String get vendorItemName => throw _privateConstructorUsedError;
  String get billItemName => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String? get sphMin => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String? get sphMax => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String get sphStep => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String? get cylMin => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String? get cylMax => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String get cylStep => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String? get addMin => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String? get addMax => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String get addStep => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String get axis => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String get eye => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parsePowerGroups)
  List<LensPowerGroup> get powerGroups => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseAddGroups)
  List<LensAddGroup> get addGroups => throw _privateConstructorUsedError;
  Map<String, dynamic>? get salePrice => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;
  String? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this LensGroupModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LensGroupModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LensGroupModelCopyWith<LensGroupModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LensGroupModelCopyWith<$Res> {
  factory $LensGroupModelCopyWith(
    LensGroupModel value,
    $Res Function(LensGroupModel) then,
  ) = _$LensGroupModelCopyWithImpl<$Res, LensGroupModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    String groupName,
    String productName,
    String vendorItemName,
    String billItemName,
    @JsonKey(fromJson: _parseString) String? sphMin,
    @JsonKey(fromJson: _parseString) String? sphMax,
    @JsonKey(fromJson: _parseString) String sphStep,
    @JsonKey(fromJson: _parseString) String? cylMin,
    @JsonKey(fromJson: _parseString) String? cylMax,
    @JsonKey(fromJson: _parseString) String cylStep,
    @JsonKey(fromJson: _parseString) String? addMin,
    @JsonKey(fromJson: _parseString) String? addMax,
    @JsonKey(fromJson: _parseString) String addStep,
    @JsonKey(fromJson: _parseString) String axis,
    @JsonKey(fromJson: _parseString) String eye,
    @JsonKey(fromJson: _parsePowerGroups) List<LensPowerGroup> powerGroups,
    @JsonKey(fromJson: _parseAddGroups) List<LensAddGroup> addGroups,
    Map<String, dynamic>? salePrice,
    String? createdAt,
    String? updatedAt,
  });
}

/// @nodoc
class _$LensGroupModelCopyWithImpl<$Res, $Val extends LensGroupModel>
    implements $LensGroupModelCopyWith<$Res> {
  _$LensGroupModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LensGroupModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? groupName = null,
    Object? productName = null,
    Object? vendorItemName = null,
    Object? billItemName = null,
    Object? sphMin = freezed,
    Object? sphMax = freezed,
    Object? sphStep = null,
    Object? cylMin = freezed,
    Object? cylMax = freezed,
    Object? cylStep = null,
    Object? addMin = freezed,
    Object? addMax = freezed,
    Object? addStep = null,
    Object? axis = null,
    Object? eye = null,
    Object? powerGroups = null,
    Object? addGroups = null,
    Object? salePrice = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            groupName: null == groupName
                ? _value.groupName
                : groupName // ignore: cast_nullable_to_non_nullable
                      as String,
            productName: null == productName
                ? _value.productName
                : productName // ignore: cast_nullable_to_non_nullable
                      as String,
            vendorItemName: null == vendorItemName
                ? _value.vendorItemName
                : vendorItemName // ignore: cast_nullable_to_non_nullable
                      as String,
            billItemName: null == billItemName
                ? _value.billItemName
                : billItemName // ignore: cast_nullable_to_non_nullable
                      as String,
            sphMin: freezed == sphMin
                ? _value.sphMin
                : sphMin // ignore: cast_nullable_to_non_nullable
                      as String?,
            sphMax: freezed == sphMax
                ? _value.sphMax
                : sphMax // ignore: cast_nullable_to_non_nullable
                      as String?,
            sphStep: null == sphStep
                ? _value.sphStep
                : sphStep // ignore: cast_nullable_to_non_nullable
                      as String,
            cylMin: freezed == cylMin
                ? _value.cylMin
                : cylMin // ignore: cast_nullable_to_non_nullable
                      as String?,
            cylMax: freezed == cylMax
                ? _value.cylMax
                : cylMax // ignore: cast_nullable_to_non_nullable
                      as String?,
            cylStep: null == cylStep
                ? _value.cylStep
                : cylStep // ignore: cast_nullable_to_non_nullable
                      as String,
            addMin: freezed == addMin
                ? _value.addMin
                : addMin // ignore: cast_nullable_to_non_nullable
                      as String?,
            addMax: freezed == addMax
                ? _value.addMax
                : addMax // ignore: cast_nullable_to_non_nullable
                      as String?,
            addStep: null == addStep
                ? _value.addStep
                : addStep // ignore: cast_nullable_to_non_nullable
                      as String,
            axis: null == axis
                ? _value.axis
                : axis // ignore: cast_nullable_to_non_nullable
                      as String,
            eye: null == eye
                ? _value.eye
                : eye // ignore: cast_nullable_to_non_nullable
                      as String,
            powerGroups: null == powerGroups
                ? _value.powerGroups
                : powerGroups // ignore: cast_nullable_to_non_nullable
                      as List<LensPowerGroup>,
            addGroups: null == addGroups
                ? _value.addGroups
                : addGroups // ignore: cast_nullable_to_non_nullable
                      as List<LensAddGroup>,
            salePrice: freezed == salePrice
                ? _value.salePrice
                : salePrice // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
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
abstract class _$$LensGroupModelImplCopyWith<$Res>
    implements $LensGroupModelCopyWith<$Res> {
  factory _$$LensGroupModelImplCopyWith(
    _$LensGroupModelImpl value,
    $Res Function(_$LensGroupModelImpl) then,
  ) = __$$LensGroupModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    String groupName,
    String productName,
    String vendorItemName,
    String billItemName,
    @JsonKey(fromJson: _parseString) String? sphMin,
    @JsonKey(fromJson: _parseString) String? sphMax,
    @JsonKey(fromJson: _parseString) String sphStep,
    @JsonKey(fromJson: _parseString) String? cylMin,
    @JsonKey(fromJson: _parseString) String? cylMax,
    @JsonKey(fromJson: _parseString) String cylStep,
    @JsonKey(fromJson: _parseString) String? addMin,
    @JsonKey(fromJson: _parseString) String? addMax,
    @JsonKey(fromJson: _parseString) String addStep,
    @JsonKey(fromJson: _parseString) String axis,
    @JsonKey(fromJson: _parseString) String eye,
    @JsonKey(fromJson: _parsePowerGroups) List<LensPowerGroup> powerGroups,
    @JsonKey(fromJson: _parseAddGroups) List<LensAddGroup> addGroups,
    Map<String, dynamic>? salePrice,
    String? createdAt,
    String? updatedAt,
  });
}

/// @nodoc
class __$$LensGroupModelImplCopyWithImpl<$Res>
    extends _$LensGroupModelCopyWithImpl<$Res, _$LensGroupModelImpl>
    implements _$$LensGroupModelImplCopyWith<$Res> {
  __$$LensGroupModelImplCopyWithImpl(
    _$LensGroupModelImpl _value,
    $Res Function(_$LensGroupModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LensGroupModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? groupName = null,
    Object? productName = null,
    Object? vendorItemName = null,
    Object? billItemName = null,
    Object? sphMin = freezed,
    Object? sphMax = freezed,
    Object? sphStep = null,
    Object? cylMin = freezed,
    Object? cylMax = freezed,
    Object? cylStep = null,
    Object? addMin = freezed,
    Object? addMax = freezed,
    Object? addStep = null,
    Object? axis = null,
    Object? eye = null,
    Object? powerGroups = null,
    Object? addGroups = null,
    Object? salePrice = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$LensGroupModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        groupName: null == groupName
            ? _value.groupName
            : groupName // ignore: cast_nullable_to_non_nullable
                  as String,
        productName: null == productName
            ? _value.productName
            : productName // ignore: cast_nullable_to_non_nullable
                  as String,
        vendorItemName: null == vendorItemName
            ? _value.vendorItemName
            : vendorItemName // ignore: cast_nullable_to_non_nullable
                  as String,
        billItemName: null == billItemName
            ? _value.billItemName
            : billItemName // ignore: cast_nullable_to_non_nullable
                  as String,
        sphMin: freezed == sphMin
            ? _value.sphMin
            : sphMin // ignore: cast_nullable_to_non_nullable
                  as String?,
        sphMax: freezed == sphMax
            ? _value.sphMax
            : sphMax // ignore: cast_nullable_to_non_nullable
                  as String?,
        sphStep: null == sphStep
            ? _value.sphStep
            : sphStep // ignore: cast_nullable_to_non_nullable
                  as String,
        cylMin: freezed == cylMin
            ? _value.cylMin
            : cylMin // ignore: cast_nullable_to_non_nullable
                  as String?,
        cylMax: freezed == cylMax
            ? _value.cylMax
            : cylMax // ignore: cast_nullable_to_non_nullable
                  as String?,
        cylStep: null == cylStep
            ? _value.cylStep
            : cylStep // ignore: cast_nullable_to_non_nullable
                  as String,
        addMin: freezed == addMin
            ? _value.addMin
            : addMin // ignore: cast_nullable_to_non_nullable
                  as String?,
        addMax: freezed == addMax
            ? _value.addMax
            : addMax // ignore: cast_nullable_to_non_nullable
                  as String?,
        addStep: null == addStep
            ? _value.addStep
            : addStep // ignore: cast_nullable_to_non_nullable
                  as String,
        axis: null == axis
            ? _value.axis
            : axis // ignore: cast_nullable_to_non_nullable
                  as String,
        eye: null == eye
            ? _value.eye
            : eye // ignore: cast_nullable_to_non_nullable
                  as String,
        powerGroups: null == powerGroups
            ? _value._powerGroups
            : powerGroups // ignore: cast_nullable_to_non_nullable
                  as List<LensPowerGroup>,
        addGroups: null == addGroups
            ? _value._addGroups
            : addGroups // ignore: cast_nullable_to_non_nullable
                  as List<LensAddGroup>,
        salePrice: freezed == salePrice
            ? _value._salePrice
            : salePrice // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
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
class _$LensGroupModelImpl implements _LensGroupModel {
  const _$LensGroupModelImpl({
    @JsonKey(name: '_id') this.id,
    this.groupName = '',
    this.productName = '',
    this.vendorItemName = '',
    this.billItemName = '',
    @JsonKey(fromJson: _parseString) this.sphMin,
    @JsonKey(fromJson: _parseString) this.sphMax,
    @JsonKey(fromJson: _parseString) this.sphStep = '0.25',
    @JsonKey(fromJson: _parseString) this.cylMin,
    @JsonKey(fromJson: _parseString) this.cylMax,
    @JsonKey(fromJson: _parseString) this.cylStep = '0.25',
    @JsonKey(fromJson: _parseString) this.addMin,
    @JsonKey(fromJson: _parseString) this.addMax,
    @JsonKey(fromJson: _parseString) this.addStep = '0.25',
    @JsonKey(fromJson: _parseString) this.axis = '',
    @JsonKey(fromJson: _parseString) this.eye = '',
    @JsonKey(fromJson: _parsePowerGroups)
    final List<LensPowerGroup> powerGroups = const [],
    @JsonKey(fromJson: _parseAddGroups)
    final List<LensAddGroup> addGroups = const [],
    final Map<String, dynamic>? salePrice,
    this.createdAt,
    this.updatedAt,
  }) : _powerGroups = powerGroups,
       _addGroups = addGroups,
       _salePrice = salePrice;

  factory _$LensGroupModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LensGroupModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String? id;
  @override
  @JsonKey()
  final String groupName;
  @override
  @JsonKey()
  final String productName;
  @override
  @JsonKey()
  final String vendorItemName;
  @override
  @JsonKey()
  final String billItemName;
  @override
  @JsonKey(fromJson: _parseString)
  final String? sphMin;
  @override
  @JsonKey(fromJson: _parseString)
  final String? sphMax;
  @override
  @JsonKey(fromJson: _parseString)
  final String sphStep;
  @override
  @JsonKey(fromJson: _parseString)
  final String? cylMin;
  @override
  @JsonKey(fromJson: _parseString)
  final String? cylMax;
  @override
  @JsonKey(fromJson: _parseString)
  final String cylStep;
  @override
  @JsonKey(fromJson: _parseString)
  final String? addMin;
  @override
  @JsonKey(fromJson: _parseString)
  final String? addMax;
  @override
  @JsonKey(fromJson: _parseString)
  final String addStep;
  @override
  @JsonKey(fromJson: _parseString)
  final String axis;
  @override
  @JsonKey(fromJson: _parseString)
  final String eye;
  final List<LensPowerGroup> _powerGroups;
  @override
  @JsonKey(fromJson: _parsePowerGroups)
  List<LensPowerGroup> get powerGroups {
    if (_powerGroups is EqualUnmodifiableListView) return _powerGroups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_powerGroups);
  }

  final List<LensAddGroup> _addGroups;
  @override
  @JsonKey(fromJson: _parseAddGroups)
  List<LensAddGroup> get addGroups {
    if (_addGroups is EqualUnmodifiableListView) return _addGroups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_addGroups);
  }

  final Map<String, dynamic>? _salePrice;
  @override
  Map<String, dynamic>? get salePrice {
    final value = _salePrice;
    if (value == null) return null;
    if (_salePrice is EqualUnmodifiableMapView) return _salePrice;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? createdAt;
  @override
  final String? updatedAt;

  @override
  String toString() {
    return 'LensGroupModel(id: $id, groupName: $groupName, productName: $productName, vendorItemName: $vendorItemName, billItemName: $billItemName, sphMin: $sphMin, sphMax: $sphMax, sphStep: $sphStep, cylMin: $cylMin, cylMax: $cylMax, cylStep: $cylStep, addMin: $addMin, addMax: $addMax, addStep: $addStep, axis: $axis, eye: $eye, powerGroups: $powerGroups, addGroups: $addGroups, salePrice: $salePrice, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LensGroupModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.groupName, groupName) ||
                other.groupName == groupName) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.vendorItemName, vendorItemName) ||
                other.vendorItemName == vendorItemName) &&
            (identical(other.billItemName, billItemName) ||
                other.billItemName == billItemName) &&
            (identical(other.sphMin, sphMin) || other.sphMin == sphMin) &&
            (identical(other.sphMax, sphMax) || other.sphMax == sphMax) &&
            (identical(other.sphStep, sphStep) || other.sphStep == sphStep) &&
            (identical(other.cylMin, cylMin) || other.cylMin == cylMin) &&
            (identical(other.cylMax, cylMax) || other.cylMax == cylMax) &&
            (identical(other.cylStep, cylStep) || other.cylStep == cylStep) &&
            (identical(other.addMin, addMin) || other.addMin == addMin) &&
            (identical(other.addMax, addMax) || other.addMax == addMax) &&
            (identical(other.addStep, addStep) || other.addStep == addStep) &&
            (identical(other.axis, axis) || other.axis == axis) &&
            (identical(other.eye, eye) || other.eye == eye) &&
            const DeepCollectionEquality().equals(
              other._powerGroups,
              _powerGroups,
            ) &&
            const DeepCollectionEquality().equals(
              other._addGroups,
              _addGroups,
            ) &&
            const DeepCollectionEquality().equals(
              other._salePrice,
              _salePrice,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    groupName,
    productName,
    vendorItemName,
    billItemName,
    sphMin,
    sphMax,
    sphStep,
    cylMin,
    cylMax,
    cylStep,
    addMin,
    addMax,
    addStep,
    axis,
    eye,
    const DeepCollectionEquality().hash(_powerGroups),
    const DeepCollectionEquality().hash(_addGroups),
    const DeepCollectionEquality().hash(_salePrice),
    createdAt,
    updatedAt,
  ]);

  /// Create a copy of LensGroupModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LensGroupModelImplCopyWith<_$LensGroupModelImpl> get copyWith =>
      __$$LensGroupModelImplCopyWithImpl<_$LensGroupModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LensGroupModelImplToJson(this);
  }
}

abstract class _LensGroupModel implements LensGroupModel {
  const factory _LensGroupModel({
    @JsonKey(name: '_id') final String? id,
    final String groupName,
    final String productName,
    final String vendorItemName,
    final String billItemName,
    @JsonKey(fromJson: _parseString) final String? sphMin,
    @JsonKey(fromJson: _parseString) final String? sphMax,
    @JsonKey(fromJson: _parseString) final String sphStep,
    @JsonKey(fromJson: _parseString) final String? cylMin,
    @JsonKey(fromJson: _parseString) final String? cylMax,
    @JsonKey(fromJson: _parseString) final String cylStep,
    @JsonKey(fromJson: _parseString) final String? addMin,
    @JsonKey(fromJson: _parseString) final String? addMax,
    @JsonKey(fromJson: _parseString) final String addStep,
    @JsonKey(fromJson: _parseString) final String axis,
    @JsonKey(fromJson: _parseString) final String eye,
    @JsonKey(fromJson: _parsePowerGroups)
    final List<LensPowerGroup> powerGroups,
    @JsonKey(fromJson: _parseAddGroups) final List<LensAddGroup> addGroups,
    final Map<String, dynamic>? salePrice,
    final String? createdAt,
    final String? updatedAt,
  }) = _$LensGroupModelImpl;

  factory _LensGroupModel.fromJson(Map<String, dynamic> json) =
      _$LensGroupModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String? get id;
  @override
  String get groupName;
  @override
  String get productName;
  @override
  String get vendorItemName;
  @override
  String get billItemName;
  @override
  @JsonKey(fromJson: _parseString)
  String? get sphMin;
  @override
  @JsonKey(fromJson: _parseString)
  String? get sphMax;
  @override
  @JsonKey(fromJson: _parseString)
  String get sphStep;
  @override
  @JsonKey(fromJson: _parseString)
  String? get cylMin;
  @override
  @JsonKey(fromJson: _parseString)
  String? get cylMax;
  @override
  @JsonKey(fromJson: _parseString)
  String get cylStep;
  @override
  @JsonKey(fromJson: _parseString)
  String? get addMin;
  @override
  @JsonKey(fromJson: _parseString)
  String? get addMax;
  @override
  @JsonKey(fromJson: _parseString)
  String get addStep;
  @override
  @JsonKey(fromJson: _parseString)
  String get axis;
  @override
  @JsonKey(fromJson: _parseString)
  String get eye;
  @override
  @JsonKey(fromJson: _parsePowerGroups)
  List<LensPowerGroup> get powerGroups;
  @override
  @JsonKey(fromJson: _parseAddGroups)
  List<LensAddGroup> get addGroups;
  @override
  Map<String, dynamic>? get salePrice;
  @override
  String? get createdAt;
  @override
  String? get updatedAt;

  /// Create a copy of LensGroupModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LensGroupModelImplCopyWith<_$LensGroupModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LensPowerGroup _$LensPowerGroupFromJson(Map<String, dynamic> json) {
  return _LensPowerGroup.fromJson(json);
}

/// @nodoc
mixin _$LensPowerGroup {
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String? get label => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String? get sphMin => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String? get sphMax => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String get sphStep => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String? get cylMin => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String? get cylMax => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String get cylStep => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String? get addMin => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String? get addMax => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String get addStep => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String? get axis => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String? get eye => throw _privateConstructorUsedError;

  /// Serializes this LensPowerGroup to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LensPowerGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LensPowerGroupCopyWith<LensPowerGroup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LensPowerGroupCopyWith<$Res> {
  factory $LensPowerGroupCopyWith(
    LensPowerGroup value,
    $Res Function(LensPowerGroup) then,
  ) = _$LensPowerGroupCopyWithImpl<$Res, LensPowerGroup>;
  @useResult
  $Res call({
    String? id,
    @JsonKey(fromJson: _parseString) String? label,
    @JsonKey(fromJson: _parseString) String? sphMin,
    @JsonKey(fromJson: _parseString) String? sphMax,
    @JsonKey(fromJson: _parseString) String sphStep,
    @JsonKey(fromJson: _parseString) String? cylMin,
    @JsonKey(fromJson: _parseString) String? cylMax,
    @JsonKey(fromJson: _parseString) String cylStep,
    @JsonKey(fromJson: _parseString) String? addMin,
    @JsonKey(fromJson: _parseString) String? addMax,
    @JsonKey(fromJson: _parseString) String addStep,
    @JsonKey(fromJson: _parseString) String? axis,
    @JsonKey(fromJson: _parseString) String? eye,
  });
}

/// @nodoc
class _$LensPowerGroupCopyWithImpl<$Res, $Val extends LensPowerGroup>
    implements $LensPowerGroupCopyWith<$Res> {
  _$LensPowerGroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LensPowerGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? label = freezed,
    Object? sphMin = freezed,
    Object? sphMax = freezed,
    Object? sphStep = null,
    Object? cylMin = freezed,
    Object? cylMax = freezed,
    Object? cylStep = null,
    Object? addMin = freezed,
    Object? addMax = freezed,
    Object? addStep = null,
    Object? axis = freezed,
    Object? eye = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            label: freezed == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String?,
            sphMin: freezed == sphMin
                ? _value.sphMin
                : sphMin // ignore: cast_nullable_to_non_nullable
                      as String?,
            sphMax: freezed == sphMax
                ? _value.sphMax
                : sphMax // ignore: cast_nullable_to_non_nullable
                      as String?,
            sphStep: null == sphStep
                ? _value.sphStep
                : sphStep // ignore: cast_nullable_to_non_nullable
                      as String,
            cylMin: freezed == cylMin
                ? _value.cylMin
                : cylMin // ignore: cast_nullable_to_non_nullable
                      as String?,
            cylMax: freezed == cylMax
                ? _value.cylMax
                : cylMax // ignore: cast_nullable_to_non_nullable
                      as String?,
            cylStep: null == cylStep
                ? _value.cylStep
                : cylStep // ignore: cast_nullable_to_non_nullable
                      as String,
            addMin: freezed == addMin
                ? _value.addMin
                : addMin // ignore: cast_nullable_to_non_nullable
                      as String?,
            addMax: freezed == addMax
                ? _value.addMax
                : addMax // ignore: cast_nullable_to_non_nullable
                      as String?,
            addStep: null == addStep
                ? _value.addStep
                : addStep // ignore: cast_nullable_to_non_nullable
                      as String,
            axis: freezed == axis
                ? _value.axis
                : axis // ignore: cast_nullable_to_non_nullable
                      as String?,
            eye: freezed == eye
                ? _value.eye
                : eye // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LensPowerGroupImplCopyWith<$Res>
    implements $LensPowerGroupCopyWith<$Res> {
  factory _$$LensPowerGroupImplCopyWith(
    _$LensPowerGroupImpl value,
    $Res Function(_$LensPowerGroupImpl) then,
  ) = __$$LensPowerGroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? id,
    @JsonKey(fromJson: _parseString) String? label,
    @JsonKey(fromJson: _parseString) String? sphMin,
    @JsonKey(fromJson: _parseString) String? sphMax,
    @JsonKey(fromJson: _parseString) String sphStep,
    @JsonKey(fromJson: _parseString) String? cylMin,
    @JsonKey(fromJson: _parseString) String? cylMax,
    @JsonKey(fromJson: _parseString) String cylStep,
    @JsonKey(fromJson: _parseString) String? addMin,
    @JsonKey(fromJson: _parseString) String? addMax,
    @JsonKey(fromJson: _parseString) String addStep,
    @JsonKey(fromJson: _parseString) String? axis,
    @JsonKey(fromJson: _parseString) String? eye,
  });
}

/// @nodoc
class __$$LensPowerGroupImplCopyWithImpl<$Res>
    extends _$LensPowerGroupCopyWithImpl<$Res, _$LensPowerGroupImpl>
    implements _$$LensPowerGroupImplCopyWith<$Res> {
  __$$LensPowerGroupImplCopyWithImpl(
    _$LensPowerGroupImpl _value,
    $Res Function(_$LensPowerGroupImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LensPowerGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? label = freezed,
    Object? sphMin = freezed,
    Object? sphMax = freezed,
    Object? sphStep = null,
    Object? cylMin = freezed,
    Object? cylMax = freezed,
    Object? cylStep = null,
    Object? addMin = freezed,
    Object? addMax = freezed,
    Object? addStep = null,
    Object? axis = freezed,
    Object? eye = freezed,
  }) {
    return _then(
      _$LensPowerGroupImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        label: freezed == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String?,
        sphMin: freezed == sphMin
            ? _value.sphMin
            : sphMin // ignore: cast_nullable_to_non_nullable
                  as String?,
        sphMax: freezed == sphMax
            ? _value.sphMax
            : sphMax // ignore: cast_nullable_to_non_nullable
                  as String?,
        sphStep: null == sphStep
            ? _value.sphStep
            : sphStep // ignore: cast_nullable_to_non_nullable
                  as String,
        cylMin: freezed == cylMin
            ? _value.cylMin
            : cylMin // ignore: cast_nullable_to_non_nullable
                  as String?,
        cylMax: freezed == cylMax
            ? _value.cylMax
            : cylMax // ignore: cast_nullable_to_non_nullable
                  as String?,
        cylStep: null == cylStep
            ? _value.cylStep
            : cylStep // ignore: cast_nullable_to_non_nullable
                  as String,
        addMin: freezed == addMin
            ? _value.addMin
            : addMin // ignore: cast_nullable_to_non_nullable
                  as String?,
        addMax: freezed == addMax
            ? _value.addMax
            : addMax // ignore: cast_nullable_to_non_nullable
                  as String?,
        addStep: null == addStep
            ? _value.addStep
            : addStep // ignore: cast_nullable_to_non_nullable
                  as String,
        axis: freezed == axis
            ? _value.axis
            : axis // ignore: cast_nullable_to_non_nullable
                  as String?,
        eye: freezed == eye
            ? _value.eye
            : eye // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LensPowerGroupImpl implements _LensPowerGroup {
  const _$LensPowerGroupImpl({
    this.id,
    @JsonKey(fromJson: _parseString) this.label,
    @JsonKey(fromJson: _parseString) this.sphMin,
    @JsonKey(fromJson: _parseString) this.sphMax,
    @JsonKey(fromJson: _parseString) this.sphStep = '0.25',
    @JsonKey(fromJson: _parseString) this.cylMin,
    @JsonKey(fromJson: _parseString) this.cylMax,
    @JsonKey(fromJson: _parseString) this.cylStep = '0.25',
    @JsonKey(fromJson: _parseString) this.addMin,
    @JsonKey(fromJson: _parseString) this.addMax,
    @JsonKey(fromJson: _parseString) this.addStep = '0.25',
    @JsonKey(fromJson: _parseString) this.axis,
    @JsonKey(fromJson: _parseString) this.eye,
  });

  factory _$LensPowerGroupImpl.fromJson(Map<String, dynamic> json) =>
      _$$LensPowerGroupImplFromJson(json);

  @override
  final String? id;
  @override
  @JsonKey(fromJson: _parseString)
  final String? label;
  @override
  @JsonKey(fromJson: _parseString)
  final String? sphMin;
  @override
  @JsonKey(fromJson: _parseString)
  final String? sphMax;
  @override
  @JsonKey(fromJson: _parseString)
  final String sphStep;
  @override
  @JsonKey(fromJson: _parseString)
  final String? cylMin;
  @override
  @JsonKey(fromJson: _parseString)
  final String? cylMax;
  @override
  @JsonKey(fromJson: _parseString)
  final String cylStep;
  @override
  @JsonKey(fromJson: _parseString)
  final String? addMin;
  @override
  @JsonKey(fromJson: _parseString)
  final String? addMax;
  @override
  @JsonKey(fromJson: _parseString)
  final String addStep;
  @override
  @JsonKey(fromJson: _parseString)
  final String? axis;
  @override
  @JsonKey(fromJson: _parseString)
  final String? eye;

  @override
  String toString() {
    return 'LensPowerGroup(id: $id, label: $label, sphMin: $sphMin, sphMax: $sphMax, sphStep: $sphStep, cylMin: $cylMin, cylMax: $cylMax, cylStep: $cylStep, addMin: $addMin, addMax: $addMax, addStep: $addStep, axis: $axis, eye: $eye)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LensPowerGroupImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.sphMin, sphMin) || other.sphMin == sphMin) &&
            (identical(other.sphMax, sphMax) || other.sphMax == sphMax) &&
            (identical(other.sphStep, sphStep) || other.sphStep == sphStep) &&
            (identical(other.cylMin, cylMin) || other.cylMin == cylMin) &&
            (identical(other.cylMax, cylMax) || other.cylMax == cylMax) &&
            (identical(other.cylStep, cylStep) || other.cylStep == cylStep) &&
            (identical(other.addMin, addMin) || other.addMin == addMin) &&
            (identical(other.addMax, addMax) || other.addMax == addMax) &&
            (identical(other.addStep, addStep) || other.addStep == addStep) &&
            (identical(other.axis, axis) || other.axis == axis) &&
            (identical(other.eye, eye) || other.eye == eye));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    label,
    sphMin,
    sphMax,
    sphStep,
    cylMin,
    cylMax,
    cylStep,
    addMin,
    addMax,
    addStep,
    axis,
    eye,
  );

  /// Create a copy of LensPowerGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LensPowerGroupImplCopyWith<_$LensPowerGroupImpl> get copyWith =>
      __$$LensPowerGroupImplCopyWithImpl<_$LensPowerGroupImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LensPowerGroupImplToJson(this);
  }
}

abstract class _LensPowerGroup implements LensPowerGroup {
  const factory _LensPowerGroup({
    final String? id,
    @JsonKey(fromJson: _parseString) final String? label,
    @JsonKey(fromJson: _parseString) final String? sphMin,
    @JsonKey(fromJson: _parseString) final String? sphMax,
    @JsonKey(fromJson: _parseString) final String sphStep,
    @JsonKey(fromJson: _parseString) final String? cylMin,
    @JsonKey(fromJson: _parseString) final String? cylMax,
    @JsonKey(fromJson: _parseString) final String cylStep,
    @JsonKey(fromJson: _parseString) final String? addMin,
    @JsonKey(fromJson: _parseString) final String? addMax,
    @JsonKey(fromJson: _parseString) final String addStep,
    @JsonKey(fromJson: _parseString) final String? axis,
    @JsonKey(fromJson: _parseString) final String? eye,
  }) = _$LensPowerGroupImpl;

  factory _LensPowerGroup.fromJson(Map<String, dynamic> json) =
      _$LensPowerGroupImpl.fromJson;

  @override
  String? get id;
  @override
  @JsonKey(fromJson: _parseString)
  String? get label;
  @override
  @JsonKey(fromJson: _parseString)
  String? get sphMin;
  @override
  @JsonKey(fromJson: _parseString)
  String? get sphMax;
  @override
  @JsonKey(fromJson: _parseString)
  String get sphStep;
  @override
  @JsonKey(fromJson: _parseString)
  String? get cylMin;
  @override
  @JsonKey(fromJson: _parseString)
  String? get cylMax;
  @override
  @JsonKey(fromJson: _parseString)
  String get cylStep;
  @override
  @JsonKey(fromJson: _parseString)
  String? get addMin;
  @override
  @JsonKey(fromJson: _parseString)
  String? get addMax;
  @override
  @JsonKey(fromJson: _parseString)
  String get addStep;
  @override
  @JsonKey(fromJson: _parseString)
  String? get axis;
  @override
  @JsonKey(fromJson: _parseString)
  String? get eye;

  /// Create a copy of LensPowerGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LensPowerGroupImplCopyWith<_$LensPowerGroupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LensAddGroup _$LensAddGroupFromJson(Map<String, dynamic> json) {
  return _LensAddGroup.fromJson(json);
}

/// @nodoc
mixin _$LensAddGroup {
  String? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get label => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseCombinations)
  List<LensCombination> get combinations => throw _privateConstructorUsedError;

  /// Serializes this LensAddGroup to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LensAddGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LensAddGroupCopyWith<LensAddGroup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LensAddGroupCopyWith<$Res> {
  factory $LensAddGroupCopyWith(
    LensAddGroup value,
    $Res Function(LensAddGroup) then,
  ) = _$LensAddGroupCopyWithImpl<$Res, LensAddGroup>;
  @useResult
  $Res call({
    String? id,
    String? name,
    String? label,
    @JsonKey(fromJson: _parseCombinations) List<LensCombination> combinations,
  });
}

/// @nodoc
class _$LensAddGroupCopyWithImpl<$Res, $Val extends LensAddGroup>
    implements $LensAddGroupCopyWith<$Res> {
  _$LensAddGroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LensAddGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? label = freezed,
    Object? combinations = null,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            label: freezed == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String?,
            combinations: null == combinations
                ? _value.combinations
                : combinations // ignore: cast_nullable_to_non_nullable
                      as List<LensCombination>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LensAddGroupImplCopyWith<$Res>
    implements $LensAddGroupCopyWith<$Res> {
  factory _$$LensAddGroupImplCopyWith(
    _$LensAddGroupImpl value,
    $Res Function(_$LensAddGroupImpl) then,
  ) = __$$LensAddGroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? id,
    String? name,
    String? label,
    @JsonKey(fromJson: _parseCombinations) List<LensCombination> combinations,
  });
}

/// @nodoc
class __$$LensAddGroupImplCopyWithImpl<$Res>
    extends _$LensAddGroupCopyWithImpl<$Res, _$LensAddGroupImpl>
    implements _$$LensAddGroupImplCopyWith<$Res> {
  __$$LensAddGroupImplCopyWithImpl(
    _$LensAddGroupImpl _value,
    $Res Function(_$LensAddGroupImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LensAddGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? label = freezed,
    Object? combinations = null,
  }) {
    return _then(
      _$LensAddGroupImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        label: freezed == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String?,
        combinations: null == combinations
            ? _value._combinations
            : combinations // ignore: cast_nullable_to_non_nullable
                  as List<LensCombination>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LensAddGroupImpl implements _LensAddGroup {
  const _$LensAddGroupImpl({
    this.id,
    this.name,
    this.label,
    @JsonKey(fromJson: _parseCombinations)
    final List<LensCombination> combinations = const [],
  }) : _combinations = combinations;

  factory _$LensAddGroupImpl.fromJson(Map<String, dynamic> json) =>
      _$$LensAddGroupImplFromJson(json);

  @override
  final String? id;
  @override
  final String? name;
  @override
  final String? label;
  final List<LensCombination> _combinations;
  @override
  @JsonKey(fromJson: _parseCombinations)
  List<LensCombination> get combinations {
    if (_combinations is EqualUnmodifiableListView) return _combinations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_combinations);
  }

  @override
  String toString() {
    return 'LensAddGroup(id: $id, name: $name, label: $label, combinations: $combinations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LensAddGroupImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.label, label) || other.label == label) &&
            const DeepCollectionEquality().equals(
              other._combinations,
              _combinations,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    label,
    const DeepCollectionEquality().hash(_combinations),
  );

  /// Create a copy of LensAddGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LensAddGroupImplCopyWith<_$LensAddGroupImpl> get copyWith =>
      __$$LensAddGroupImplCopyWithImpl<_$LensAddGroupImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LensAddGroupImplToJson(this);
  }
}

abstract class _LensAddGroup implements LensAddGroup {
  const factory _LensAddGroup({
    final String? id,
    final String? name,
    final String? label,
    @JsonKey(fromJson: _parseCombinations)
    final List<LensCombination> combinations,
  }) = _$LensAddGroupImpl;

  factory _LensAddGroup.fromJson(Map<String, dynamic> json) =
      _$LensAddGroupImpl.fromJson;

  @override
  String? get id;
  @override
  String? get name;
  @override
  String? get label;
  @override
  @JsonKey(fromJson: _parseCombinations)
  List<LensCombination> get combinations;

  /// Create a copy of LensAddGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LensAddGroupImplCopyWith<_$LensAddGroupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LensCombination _$LensCombinationFromJson(Map<String, dynamic> json) {
  return _LensCombination.fromJson(json);
}

/// @nodoc
mixin _$LensCombination {
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String get sph => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String get cyl => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String get add => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String get axis => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String get eye => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String get barcode => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String get boxNo => throw _privateConstructorUsedError;
  int get alertQty => throw _privateConstructorUsedError;
  double get pPrice => throw _privateConstructorUsedError;
  double get sPrice => throw _privateConstructorUsedError;
  int get initStock => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseLocations)
  List<LensLocationModel> get locations => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String get locationQty => throw _privateConstructorUsedError;

  /// Serializes this LensCombination to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LensCombination
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LensCombinationCopyWith<LensCombination> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LensCombinationCopyWith<$Res> {
  factory $LensCombinationCopyWith(
    LensCombination value,
    $Res Function(LensCombination) then,
  ) = _$LensCombinationCopyWithImpl<$Res, LensCombination>;
  @useResult
  $Res call({
    String? id,
    @JsonKey(fromJson: _parseString) String sph,
    @JsonKey(fromJson: _parseString) String cyl,
    @JsonKey(fromJson: _parseString) String add,
    @JsonKey(fromJson: _parseString) String axis,
    @JsonKey(fromJson: _parseString) String eye,
    @JsonKey(fromJson: _parseString) String barcode,
    @JsonKey(fromJson: _parseString) String boxNo,
    int alertQty,
    double pPrice,
    double sPrice,
    int initStock,
    @JsonKey(fromJson: _parseLocations) List<LensLocationModel> locations,
    @JsonKey(fromJson: _parseString) String locationQty,
  });
}

/// @nodoc
class _$LensCombinationCopyWithImpl<$Res, $Val extends LensCombination>
    implements $LensCombinationCopyWith<$Res> {
  _$LensCombinationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LensCombination
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? sph = null,
    Object? cyl = null,
    Object? add = null,
    Object? axis = null,
    Object? eye = null,
    Object? barcode = null,
    Object? boxNo = null,
    Object? alertQty = null,
    Object? pPrice = null,
    Object? sPrice = null,
    Object? initStock = null,
    Object? locations = null,
    Object? locationQty = null,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            sph: null == sph
                ? _value.sph
                : sph // ignore: cast_nullable_to_non_nullable
                      as String,
            cyl: null == cyl
                ? _value.cyl
                : cyl // ignore: cast_nullable_to_non_nullable
                      as String,
            add: null == add
                ? _value.add
                : add // ignore: cast_nullable_to_non_nullable
                      as String,
            axis: null == axis
                ? _value.axis
                : axis // ignore: cast_nullable_to_non_nullable
                      as String,
            eye: null == eye
                ? _value.eye
                : eye // ignore: cast_nullable_to_non_nullable
                      as String,
            barcode: null == barcode
                ? _value.barcode
                : barcode // ignore: cast_nullable_to_non_nullable
                      as String,
            boxNo: null == boxNo
                ? _value.boxNo
                : boxNo // ignore: cast_nullable_to_non_nullable
                      as String,
            alertQty: null == alertQty
                ? _value.alertQty
                : alertQty // ignore: cast_nullable_to_non_nullable
                      as int,
            pPrice: null == pPrice
                ? _value.pPrice
                : pPrice // ignore: cast_nullable_to_non_nullable
                      as double,
            sPrice: null == sPrice
                ? _value.sPrice
                : sPrice // ignore: cast_nullable_to_non_nullable
                      as double,
            initStock: null == initStock
                ? _value.initStock
                : initStock // ignore: cast_nullable_to_non_nullable
                      as int,
            locations: null == locations
                ? _value.locations
                : locations // ignore: cast_nullable_to_non_nullable
                      as List<LensLocationModel>,
            locationQty: null == locationQty
                ? _value.locationQty
                : locationQty // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LensCombinationImplCopyWith<$Res>
    implements $LensCombinationCopyWith<$Res> {
  factory _$$LensCombinationImplCopyWith(
    _$LensCombinationImpl value,
    $Res Function(_$LensCombinationImpl) then,
  ) = __$$LensCombinationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? id,
    @JsonKey(fromJson: _parseString) String sph,
    @JsonKey(fromJson: _parseString) String cyl,
    @JsonKey(fromJson: _parseString) String add,
    @JsonKey(fromJson: _parseString) String axis,
    @JsonKey(fromJson: _parseString) String eye,
    @JsonKey(fromJson: _parseString) String barcode,
    @JsonKey(fromJson: _parseString) String boxNo,
    int alertQty,
    double pPrice,
    double sPrice,
    int initStock,
    @JsonKey(fromJson: _parseLocations) List<LensLocationModel> locations,
    @JsonKey(fromJson: _parseString) String locationQty,
  });
}

/// @nodoc
class __$$LensCombinationImplCopyWithImpl<$Res>
    extends _$LensCombinationCopyWithImpl<$Res, _$LensCombinationImpl>
    implements _$$LensCombinationImplCopyWith<$Res> {
  __$$LensCombinationImplCopyWithImpl(
    _$LensCombinationImpl _value,
    $Res Function(_$LensCombinationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LensCombination
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? sph = null,
    Object? cyl = null,
    Object? add = null,
    Object? axis = null,
    Object? eye = null,
    Object? barcode = null,
    Object? boxNo = null,
    Object? alertQty = null,
    Object? pPrice = null,
    Object? sPrice = null,
    Object? initStock = null,
    Object? locations = null,
    Object? locationQty = null,
  }) {
    return _then(
      _$LensCombinationImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        sph: null == sph
            ? _value.sph
            : sph // ignore: cast_nullable_to_non_nullable
                  as String,
        cyl: null == cyl
            ? _value.cyl
            : cyl // ignore: cast_nullable_to_non_nullable
                  as String,
        add: null == add
            ? _value.add
            : add // ignore: cast_nullable_to_non_nullable
                  as String,
        axis: null == axis
            ? _value.axis
            : axis // ignore: cast_nullable_to_non_nullable
                  as String,
        eye: null == eye
            ? _value.eye
            : eye // ignore: cast_nullable_to_non_nullable
                  as String,
        barcode: null == barcode
            ? _value.barcode
            : barcode // ignore: cast_nullable_to_non_nullable
                  as String,
        boxNo: null == boxNo
            ? _value.boxNo
            : boxNo // ignore: cast_nullable_to_non_nullable
                  as String,
        alertQty: null == alertQty
            ? _value.alertQty
            : alertQty // ignore: cast_nullable_to_non_nullable
                  as int,
        pPrice: null == pPrice
            ? _value.pPrice
            : pPrice // ignore: cast_nullable_to_non_nullable
                  as double,
        sPrice: null == sPrice
            ? _value.sPrice
            : sPrice // ignore: cast_nullable_to_non_nullable
                  as double,
        initStock: null == initStock
            ? _value.initStock
            : initStock // ignore: cast_nullable_to_non_nullable
                  as int,
        locations: null == locations
            ? _value._locations
            : locations // ignore: cast_nullable_to_non_nullable
                  as List<LensLocationModel>,
        locationQty: null == locationQty
            ? _value.locationQty
            : locationQty // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LensCombinationImpl implements _LensCombination {
  const _$LensCombinationImpl({
    this.id,
    @JsonKey(fromJson: _parseString) this.sph = '',
    @JsonKey(fromJson: _parseString) this.cyl = '',
    @JsonKey(fromJson: _parseString) this.add = '',
    @JsonKey(fromJson: _parseString) this.axis = '',
    @JsonKey(fromJson: _parseString) this.eye = '',
    @JsonKey(fromJson: _parseString) this.barcode = '',
    @JsonKey(fromJson: _parseString) this.boxNo = '',
    this.alertQty = 0,
    this.pPrice = 0.0,
    this.sPrice = 0.0,
    this.initStock = 0,
    @JsonKey(fromJson: _parseLocations)
    final List<LensLocationModel> locations = const [],
    @JsonKey(fromJson: _parseString) this.locationQty = '',
  }) : _locations = locations;

  factory _$LensCombinationImpl.fromJson(Map<String, dynamic> json) =>
      _$$LensCombinationImplFromJson(json);

  @override
  final String? id;
  @override
  @JsonKey(fromJson: _parseString)
  final String sph;
  @override
  @JsonKey(fromJson: _parseString)
  final String cyl;
  @override
  @JsonKey(fromJson: _parseString)
  final String add;
  @override
  @JsonKey(fromJson: _parseString)
  final String axis;
  @override
  @JsonKey(fromJson: _parseString)
  final String eye;
  @override
  @JsonKey(fromJson: _parseString)
  final String barcode;
  @override
  @JsonKey(fromJson: _parseString)
  final String boxNo;
  @override
  @JsonKey()
  final int alertQty;
  @override
  @JsonKey()
  final double pPrice;
  @override
  @JsonKey()
  final double sPrice;
  @override
  @JsonKey()
  final int initStock;
  final List<LensLocationModel> _locations;
  @override
  @JsonKey(fromJson: _parseLocations)
  List<LensLocationModel> get locations {
    if (_locations is EqualUnmodifiableListView) return _locations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_locations);
  }

  @override
  @JsonKey(fromJson: _parseString)
  final String locationQty;

  @override
  String toString() {
    return 'LensCombination(id: $id, sph: $sph, cyl: $cyl, add: $add, axis: $axis, eye: $eye, barcode: $barcode, boxNo: $boxNo, alertQty: $alertQty, pPrice: $pPrice, sPrice: $sPrice, initStock: $initStock, locations: $locations, locationQty: $locationQty)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LensCombinationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sph, sph) || other.sph == sph) &&
            (identical(other.cyl, cyl) || other.cyl == cyl) &&
            (identical(other.add, add) || other.add == add) &&
            (identical(other.axis, axis) || other.axis == axis) &&
            (identical(other.eye, eye) || other.eye == eye) &&
            (identical(other.barcode, barcode) || other.barcode == barcode) &&
            (identical(other.boxNo, boxNo) || other.boxNo == boxNo) &&
            (identical(other.alertQty, alertQty) ||
                other.alertQty == alertQty) &&
            (identical(other.pPrice, pPrice) || other.pPrice == pPrice) &&
            (identical(other.sPrice, sPrice) || other.sPrice == sPrice) &&
            (identical(other.initStock, initStock) ||
                other.initStock == initStock) &&
            const DeepCollectionEquality().equals(
              other._locations,
              _locations,
            ) &&
            (identical(other.locationQty, locationQty) ||
                other.locationQty == locationQty));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    sph,
    cyl,
    add,
    axis,
    eye,
    barcode,
    boxNo,
    alertQty,
    pPrice,
    sPrice,
    initStock,
    const DeepCollectionEquality().hash(_locations),
    locationQty,
  );

  /// Create a copy of LensCombination
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LensCombinationImplCopyWith<_$LensCombinationImpl> get copyWith =>
      __$$LensCombinationImplCopyWithImpl<_$LensCombinationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LensCombinationImplToJson(this);
  }
}

abstract class _LensCombination implements LensCombination {
  const factory _LensCombination({
    final String? id,
    @JsonKey(fromJson: _parseString) final String sph,
    @JsonKey(fromJson: _parseString) final String cyl,
    @JsonKey(fromJson: _parseString) final String add,
    @JsonKey(fromJson: _parseString) final String axis,
    @JsonKey(fromJson: _parseString) final String eye,
    @JsonKey(fromJson: _parseString) final String barcode,
    @JsonKey(fromJson: _parseString) final String boxNo,
    final int alertQty,
    final double pPrice,
    final double sPrice,
    final int initStock,
    @JsonKey(fromJson: _parseLocations) final List<LensLocationModel> locations,
    @JsonKey(fromJson: _parseString) final String locationQty,
  }) = _$LensCombinationImpl;

  factory _LensCombination.fromJson(Map<String, dynamic> json) =
      _$LensCombinationImpl.fromJson;

  @override
  String? get id;
  @override
  @JsonKey(fromJson: _parseString)
  String get sph;
  @override
  @JsonKey(fromJson: _parseString)
  String get cyl;
  @override
  @JsonKey(fromJson: _parseString)
  String get add;
  @override
  @JsonKey(fromJson: _parseString)
  String get axis;
  @override
  @JsonKey(fromJson: _parseString)
  String get eye;
  @override
  @JsonKey(fromJson: _parseString)
  String get barcode;
  @override
  @JsonKey(fromJson: _parseString)
  String get boxNo;
  @override
  int get alertQty;
  @override
  double get pPrice;
  @override
  double get sPrice;
  @override
  int get initStock;
  @override
  @JsonKey(fromJson: _parseLocations)
  List<LensLocationModel> get locations;
  @override
  @JsonKey(fromJson: _parseString)
  String get locationQty;

  /// Create a copy of LensCombination
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LensCombinationImplCopyWith<_$LensCombinationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
