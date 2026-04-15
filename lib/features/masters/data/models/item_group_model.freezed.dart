// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'item_group_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ItemGroupModel _$ItemGroupModelFromJson(Map<String, dynamic> json) {
  return _ItemGroupModel.fromJson(json);
}

/// @nodoc
mixin _$ItemGroupModel {
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;
  String get groupName => throw _privateConstructorUsedError;
  String? get date => throw _privateConstructorUsedError;
  double? get saleDiscount => throw _privateConstructorUsedError;
  bool get saleDiscountApplyAll => throw _privateConstructorUsedError;
  double? get purchaseDiscount => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String? get hsnCode => throw _privateConstructorUsedError;
  bool get hsnApplyAll => throw _privateConstructorUsedError;
  int? get loyaltyPoint => throw _privateConstructorUsedError;
  bool get loyaltyApplyAll => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String? get textCategory1 => throw _privateConstructorUsedError;
  bool get textCategory1ApplyAll => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String? get codeg1Limit => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String? get taxCategory2 => throw _privateConstructorUsedError;
  bool get alertNegativeQty => throw _privateConstructorUsedError;
  bool get restrictNegativeQty => throw _privateConstructorUsedError;
  bool get canDelete => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ItemGroupModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ItemGroupModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ItemGroupModelCopyWith<ItemGroupModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItemGroupModelCopyWith<$Res> {
  factory $ItemGroupModelCopyWith(
    ItemGroupModel value,
    $Res Function(ItemGroupModel) then,
  ) = _$ItemGroupModelCopyWithImpl<$Res, ItemGroupModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    String groupName,
    String? date,
    double? saleDiscount,
    bool saleDiscountApplyAll,
    double? purchaseDiscount,
    @JsonKey(fromJson: _parseString) String? hsnCode,
    bool hsnApplyAll,
    int? loyaltyPoint,
    bool loyaltyApplyAll,
    @JsonKey(fromJson: _parseString) String? textCategory1,
    bool textCategory1ApplyAll,
    @JsonKey(fromJson: _parseString) String? codeg1Limit,
    @JsonKey(fromJson: _parseString) String? taxCategory2,
    bool alertNegativeQty,
    bool restrictNegativeQty,
    bool canDelete,
    @JsonKey(fromJson: _parseString) String? createdAt,
    @JsonKey(fromJson: _parseString) String? updatedAt,
  });
}

/// @nodoc
class _$ItemGroupModelCopyWithImpl<$Res, $Val extends ItemGroupModel>
    implements $ItemGroupModelCopyWith<$Res> {
  _$ItemGroupModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ItemGroupModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? groupName = null,
    Object? date = freezed,
    Object? saleDiscount = freezed,
    Object? saleDiscountApplyAll = null,
    Object? purchaseDiscount = freezed,
    Object? hsnCode = freezed,
    Object? hsnApplyAll = null,
    Object? loyaltyPoint = freezed,
    Object? loyaltyApplyAll = null,
    Object? textCategory1 = freezed,
    Object? textCategory1ApplyAll = null,
    Object? codeg1Limit = freezed,
    Object? taxCategory2 = freezed,
    Object? alertNegativeQty = null,
    Object? restrictNegativeQty = null,
    Object? canDelete = null,
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
            date: freezed == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String?,
            saleDiscount: freezed == saleDiscount
                ? _value.saleDiscount
                : saleDiscount // ignore: cast_nullable_to_non_nullable
                      as double?,
            saleDiscountApplyAll: null == saleDiscountApplyAll
                ? _value.saleDiscountApplyAll
                : saleDiscountApplyAll // ignore: cast_nullable_to_non_nullable
                      as bool,
            purchaseDiscount: freezed == purchaseDiscount
                ? _value.purchaseDiscount
                : purchaseDiscount // ignore: cast_nullable_to_non_nullable
                      as double?,
            hsnCode: freezed == hsnCode
                ? _value.hsnCode
                : hsnCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            hsnApplyAll: null == hsnApplyAll
                ? _value.hsnApplyAll
                : hsnApplyAll // ignore: cast_nullable_to_non_nullable
                      as bool,
            loyaltyPoint: freezed == loyaltyPoint
                ? _value.loyaltyPoint
                : loyaltyPoint // ignore: cast_nullable_to_non_nullable
                      as int?,
            loyaltyApplyAll: null == loyaltyApplyAll
                ? _value.loyaltyApplyAll
                : loyaltyApplyAll // ignore: cast_nullable_to_non_nullable
                      as bool,
            textCategory1: freezed == textCategory1
                ? _value.textCategory1
                : textCategory1 // ignore: cast_nullable_to_non_nullable
                      as String?,
            textCategory1ApplyAll: null == textCategory1ApplyAll
                ? _value.textCategory1ApplyAll
                : textCategory1ApplyAll // ignore: cast_nullable_to_non_nullable
                      as bool,
            codeg1Limit: freezed == codeg1Limit
                ? _value.codeg1Limit
                : codeg1Limit // ignore: cast_nullable_to_non_nullable
                      as String?,
            taxCategory2: freezed == taxCategory2
                ? _value.taxCategory2
                : taxCategory2 // ignore: cast_nullable_to_non_nullable
                      as String?,
            alertNegativeQty: null == alertNegativeQty
                ? _value.alertNegativeQty
                : alertNegativeQty // ignore: cast_nullable_to_non_nullable
                      as bool,
            restrictNegativeQty: null == restrictNegativeQty
                ? _value.restrictNegativeQty
                : restrictNegativeQty // ignore: cast_nullable_to_non_nullable
                      as bool,
            canDelete: null == canDelete
                ? _value.canDelete
                : canDelete // ignore: cast_nullable_to_non_nullable
                      as bool,
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
abstract class _$$ItemGroupModelImplCopyWith<$Res>
    implements $ItemGroupModelCopyWith<$Res> {
  factory _$$ItemGroupModelImplCopyWith(
    _$ItemGroupModelImpl value,
    $Res Function(_$ItemGroupModelImpl) then,
  ) = __$$ItemGroupModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    String groupName,
    String? date,
    double? saleDiscount,
    bool saleDiscountApplyAll,
    double? purchaseDiscount,
    @JsonKey(fromJson: _parseString) String? hsnCode,
    bool hsnApplyAll,
    int? loyaltyPoint,
    bool loyaltyApplyAll,
    @JsonKey(fromJson: _parseString) String? textCategory1,
    bool textCategory1ApplyAll,
    @JsonKey(fromJson: _parseString) String? codeg1Limit,
    @JsonKey(fromJson: _parseString) String? taxCategory2,
    bool alertNegativeQty,
    bool restrictNegativeQty,
    bool canDelete,
    @JsonKey(fromJson: _parseString) String? createdAt,
    @JsonKey(fromJson: _parseString) String? updatedAt,
  });
}

/// @nodoc
class __$$ItemGroupModelImplCopyWithImpl<$Res>
    extends _$ItemGroupModelCopyWithImpl<$Res, _$ItemGroupModelImpl>
    implements _$$ItemGroupModelImplCopyWith<$Res> {
  __$$ItemGroupModelImplCopyWithImpl(
    _$ItemGroupModelImpl _value,
    $Res Function(_$ItemGroupModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ItemGroupModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? groupName = null,
    Object? date = freezed,
    Object? saleDiscount = freezed,
    Object? saleDiscountApplyAll = null,
    Object? purchaseDiscount = freezed,
    Object? hsnCode = freezed,
    Object? hsnApplyAll = null,
    Object? loyaltyPoint = freezed,
    Object? loyaltyApplyAll = null,
    Object? textCategory1 = freezed,
    Object? textCategory1ApplyAll = null,
    Object? codeg1Limit = freezed,
    Object? taxCategory2 = freezed,
    Object? alertNegativeQty = null,
    Object? restrictNegativeQty = null,
    Object? canDelete = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$ItemGroupModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        groupName: null == groupName
            ? _value.groupName
            : groupName // ignore: cast_nullable_to_non_nullable
                  as String,
        date: freezed == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String?,
        saleDiscount: freezed == saleDiscount
            ? _value.saleDiscount
            : saleDiscount // ignore: cast_nullable_to_non_nullable
                  as double?,
        saleDiscountApplyAll: null == saleDiscountApplyAll
            ? _value.saleDiscountApplyAll
            : saleDiscountApplyAll // ignore: cast_nullable_to_non_nullable
                  as bool,
        purchaseDiscount: freezed == purchaseDiscount
            ? _value.purchaseDiscount
            : purchaseDiscount // ignore: cast_nullable_to_non_nullable
                  as double?,
        hsnCode: freezed == hsnCode
            ? _value.hsnCode
            : hsnCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        hsnApplyAll: null == hsnApplyAll
            ? _value.hsnApplyAll
            : hsnApplyAll // ignore: cast_nullable_to_non_nullable
                  as bool,
        loyaltyPoint: freezed == loyaltyPoint
            ? _value.loyaltyPoint
            : loyaltyPoint // ignore: cast_nullable_to_non_nullable
                  as int?,
        loyaltyApplyAll: null == loyaltyApplyAll
            ? _value.loyaltyApplyAll
            : loyaltyApplyAll // ignore: cast_nullable_to_non_nullable
                  as bool,
        textCategory1: freezed == textCategory1
            ? _value.textCategory1
            : textCategory1 // ignore: cast_nullable_to_non_nullable
                  as String?,
        textCategory1ApplyAll: null == textCategory1ApplyAll
            ? _value.textCategory1ApplyAll
            : textCategory1ApplyAll // ignore: cast_nullable_to_non_nullable
                  as bool,
        codeg1Limit: freezed == codeg1Limit
            ? _value.codeg1Limit
            : codeg1Limit // ignore: cast_nullable_to_non_nullable
                  as String?,
        taxCategory2: freezed == taxCategory2
            ? _value.taxCategory2
            : taxCategory2 // ignore: cast_nullable_to_non_nullable
                  as String?,
        alertNegativeQty: null == alertNegativeQty
            ? _value.alertNegativeQty
            : alertNegativeQty // ignore: cast_nullable_to_non_nullable
                  as bool,
        restrictNegativeQty: null == restrictNegativeQty
            ? _value.restrictNegativeQty
            : restrictNegativeQty // ignore: cast_nullable_to_non_nullable
                  as bool,
        canDelete: null == canDelete
            ? _value.canDelete
            : canDelete // ignore: cast_nullable_to_non_nullable
                  as bool,
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
class _$ItemGroupModelImpl implements _ItemGroupModel {
  const _$ItemGroupModelImpl({
    @JsonKey(name: '_id') this.id,
    this.groupName = '',
    this.date,
    this.saleDiscount,
    this.saleDiscountApplyAll = false,
    this.purchaseDiscount,
    @JsonKey(fromJson: _parseString) this.hsnCode,
    this.hsnApplyAll = false,
    this.loyaltyPoint,
    this.loyaltyApplyAll = false,
    @JsonKey(fromJson: _parseString) this.textCategory1,
    this.textCategory1ApplyAll = false,
    @JsonKey(fromJson: _parseString) this.codeg1Limit,
    @JsonKey(fromJson: _parseString) this.taxCategory2,
    this.alertNegativeQty = false,
    this.restrictNegativeQty = false,
    this.canDelete = true,
    @JsonKey(fromJson: _parseString) this.createdAt,
    @JsonKey(fromJson: _parseString) this.updatedAt,
  });

  factory _$ItemGroupModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ItemGroupModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String? id;
  @override
  @JsonKey()
  final String groupName;
  @override
  final String? date;
  @override
  final double? saleDiscount;
  @override
  @JsonKey()
  final bool saleDiscountApplyAll;
  @override
  final double? purchaseDiscount;
  @override
  @JsonKey(fromJson: _parseString)
  final String? hsnCode;
  @override
  @JsonKey()
  final bool hsnApplyAll;
  @override
  final int? loyaltyPoint;
  @override
  @JsonKey()
  final bool loyaltyApplyAll;
  @override
  @JsonKey(fromJson: _parseString)
  final String? textCategory1;
  @override
  @JsonKey()
  final bool textCategory1ApplyAll;
  @override
  @JsonKey(fromJson: _parseString)
  final String? codeg1Limit;
  @override
  @JsonKey(fromJson: _parseString)
  final String? taxCategory2;
  @override
  @JsonKey()
  final bool alertNegativeQty;
  @override
  @JsonKey()
  final bool restrictNegativeQty;
  @override
  @JsonKey()
  final bool canDelete;
  @override
  @JsonKey(fromJson: _parseString)
  final String? createdAt;
  @override
  @JsonKey(fromJson: _parseString)
  final String? updatedAt;

  @override
  String toString() {
    return 'ItemGroupModel(id: $id, groupName: $groupName, date: $date, saleDiscount: $saleDiscount, saleDiscountApplyAll: $saleDiscountApplyAll, purchaseDiscount: $purchaseDiscount, hsnCode: $hsnCode, hsnApplyAll: $hsnApplyAll, loyaltyPoint: $loyaltyPoint, loyaltyApplyAll: $loyaltyApplyAll, textCategory1: $textCategory1, textCategory1ApplyAll: $textCategory1ApplyAll, codeg1Limit: $codeg1Limit, taxCategory2: $taxCategory2, alertNegativeQty: $alertNegativeQty, restrictNegativeQty: $restrictNegativeQty, canDelete: $canDelete, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ItemGroupModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.groupName, groupName) ||
                other.groupName == groupName) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.saleDiscount, saleDiscount) ||
                other.saleDiscount == saleDiscount) &&
            (identical(other.saleDiscountApplyAll, saleDiscountApplyAll) ||
                other.saleDiscountApplyAll == saleDiscountApplyAll) &&
            (identical(other.purchaseDiscount, purchaseDiscount) ||
                other.purchaseDiscount == purchaseDiscount) &&
            (identical(other.hsnCode, hsnCode) || other.hsnCode == hsnCode) &&
            (identical(other.hsnApplyAll, hsnApplyAll) ||
                other.hsnApplyAll == hsnApplyAll) &&
            (identical(other.loyaltyPoint, loyaltyPoint) ||
                other.loyaltyPoint == loyaltyPoint) &&
            (identical(other.loyaltyApplyAll, loyaltyApplyAll) ||
                other.loyaltyApplyAll == loyaltyApplyAll) &&
            (identical(other.textCategory1, textCategory1) ||
                other.textCategory1 == textCategory1) &&
            (identical(other.textCategory1ApplyAll, textCategory1ApplyAll) ||
                other.textCategory1ApplyAll == textCategory1ApplyAll) &&
            (identical(other.codeg1Limit, codeg1Limit) ||
                other.codeg1Limit == codeg1Limit) &&
            (identical(other.taxCategory2, taxCategory2) ||
                other.taxCategory2 == taxCategory2) &&
            (identical(other.alertNegativeQty, alertNegativeQty) ||
                other.alertNegativeQty == alertNegativeQty) &&
            (identical(other.restrictNegativeQty, restrictNegativeQty) ||
                other.restrictNegativeQty == restrictNegativeQty) &&
            (identical(other.canDelete, canDelete) ||
                other.canDelete == canDelete) &&
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
    date,
    saleDiscount,
    saleDiscountApplyAll,
    purchaseDiscount,
    hsnCode,
    hsnApplyAll,
    loyaltyPoint,
    loyaltyApplyAll,
    textCategory1,
    textCategory1ApplyAll,
    codeg1Limit,
    taxCategory2,
    alertNegativeQty,
    restrictNegativeQty,
    canDelete,
    createdAt,
    updatedAt,
  ]);

  /// Create a copy of ItemGroupModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ItemGroupModelImplCopyWith<_$ItemGroupModelImpl> get copyWith =>
      __$$ItemGroupModelImplCopyWithImpl<_$ItemGroupModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ItemGroupModelImplToJson(this);
  }
}

abstract class _ItemGroupModel implements ItemGroupModel {
  const factory _ItemGroupModel({
    @JsonKey(name: '_id') final String? id,
    final String groupName,
    final String? date,
    final double? saleDiscount,
    final bool saleDiscountApplyAll,
    final double? purchaseDiscount,
    @JsonKey(fromJson: _parseString) final String? hsnCode,
    final bool hsnApplyAll,
    final int? loyaltyPoint,
    final bool loyaltyApplyAll,
    @JsonKey(fromJson: _parseString) final String? textCategory1,
    final bool textCategory1ApplyAll,
    @JsonKey(fromJson: _parseString) final String? codeg1Limit,
    @JsonKey(fromJson: _parseString) final String? taxCategory2,
    final bool alertNegativeQty,
    final bool restrictNegativeQty,
    final bool canDelete,
    @JsonKey(fromJson: _parseString) final String? createdAt,
    @JsonKey(fromJson: _parseString) final String? updatedAt,
  }) = _$ItemGroupModelImpl;

  factory _ItemGroupModel.fromJson(Map<String, dynamic> json) =
      _$ItemGroupModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String? get id;
  @override
  String get groupName;
  @override
  String? get date;
  @override
  double? get saleDiscount;
  @override
  bool get saleDiscountApplyAll;
  @override
  double? get purchaseDiscount;
  @override
  @JsonKey(fromJson: _parseString)
  String? get hsnCode;
  @override
  bool get hsnApplyAll;
  @override
  int? get loyaltyPoint;
  @override
  bool get loyaltyApplyAll;
  @override
  @JsonKey(fromJson: _parseString)
  String? get textCategory1;
  @override
  bool get textCategory1ApplyAll;
  @override
  @JsonKey(fromJson: _parseString)
  String? get codeg1Limit;
  @override
  @JsonKey(fromJson: _parseString)
  String? get taxCategory2;
  @override
  bool get alertNegativeQty;
  @override
  bool get restrictNegativeQty;
  @override
  bool get canDelete;
  @override
  @JsonKey(fromJson: _parseString)
  String? get createdAt;
  @override
  @JsonKey(fromJson: _parseString)
  String? get updatedAt;

  /// Create a copy of ItemGroupModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ItemGroupModelImplCopyWith<_$ItemGroupModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
