// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'damage_entry_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DamageEntryModel _$DamageEntryModelFromJson(Map<String, dynamic> json) {
  return _DamageEntryModel.fromJson(json);
}

/// @nodoc
mixin _$DamageEntryModel {
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;
  String get billSeries => throw _privateConstructorUsedError;
  String get billNo => throw _privateConstructorUsedError;
  String? get date => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get godown => throw _privateConstructorUsedError;
  String get remark => throw _privateConstructorUsedError;
  List<DamageItemModel> get items => throw _privateConstructorUsedError;
  int get totalQty => throw _privateConstructorUsedError;
  double get totalAmt => throw _privateConstructorUsedError;
  String? get companyId => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;
  String? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this DamageEntryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DamageEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DamageEntryModelCopyWith<DamageEntryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DamageEntryModelCopyWith<$Res> {
  factory $DamageEntryModelCopyWith(
    DamageEntryModel value,
    $Res Function(DamageEntryModel) then,
  ) = _$DamageEntryModelCopyWithImpl<$Res, DamageEntryModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    String billSeries,
    String billNo,
    String? date,
    String type,
    String godown,
    String remark,
    List<DamageItemModel> items,
    int totalQty,
    double totalAmt,
    String? companyId,
    String? createdAt,
    String? updatedAt,
  });
}

/// @nodoc
class _$DamageEntryModelCopyWithImpl<$Res, $Val extends DamageEntryModel>
    implements $DamageEntryModelCopyWith<$Res> {
  _$DamageEntryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DamageEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? billSeries = null,
    Object? billNo = null,
    Object? date = freezed,
    Object? type = null,
    Object? godown = null,
    Object? remark = null,
    Object? items = null,
    Object? totalQty = null,
    Object? totalAmt = null,
    Object? companyId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            billSeries: null == billSeries
                ? _value.billSeries
                : billSeries // ignore: cast_nullable_to_non_nullable
                      as String,
            billNo: null == billNo
                ? _value.billNo
                : billNo // ignore: cast_nullable_to_non_nullable
                      as String,
            date: freezed == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String?,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            godown: null == godown
                ? _value.godown
                : godown // ignore: cast_nullable_to_non_nullable
                      as String,
            remark: null == remark
                ? _value.remark
                : remark // ignore: cast_nullable_to_non_nullable
                      as String,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<DamageItemModel>,
            totalQty: null == totalQty
                ? _value.totalQty
                : totalQty // ignore: cast_nullable_to_non_nullable
                      as int,
            totalAmt: null == totalAmt
                ? _value.totalAmt
                : totalAmt // ignore: cast_nullable_to_non_nullable
                      as double,
            companyId: freezed == companyId
                ? _value.companyId
                : companyId // ignore: cast_nullable_to_non_nullable
                      as String?,
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
abstract class _$$DamageEntryModelImplCopyWith<$Res>
    implements $DamageEntryModelCopyWith<$Res> {
  factory _$$DamageEntryModelImplCopyWith(
    _$DamageEntryModelImpl value,
    $Res Function(_$DamageEntryModelImpl) then,
  ) = __$$DamageEntryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    String billSeries,
    String billNo,
    String? date,
    String type,
    String godown,
    String remark,
    List<DamageItemModel> items,
    int totalQty,
    double totalAmt,
    String? companyId,
    String? createdAt,
    String? updatedAt,
  });
}

/// @nodoc
class __$$DamageEntryModelImplCopyWithImpl<$Res>
    extends _$DamageEntryModelCopyWithImpl<$Res, _$DamageEntryModelImpl>
    implements _$$DamageEntryModelImplCopyWith<$Res> {
  __$$DamageEntryModelImplCopyWithImpl(
    _$DamageEntryModelImpl _value,
    $Res Function(_$DamageEntryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DamageEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? billSeries = null,
    Object? billNo = null,
    Object? date = freezed,
    Object? type = null,
    Object? godown = null,
    Object? remark = null,
    Object? items = null,
    Object? totalQty = null,
    Object? totalAmt = null,
    Object? companyId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$DamageEntryModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        billSeries: null == billSeries
            ? _value.billSeries
            : billSeries // ignore: cast_nullable_to_non_nullable
                  as String,
        billNo: null == billNo
            ? _value.billNo
            : billNo // ignore: cast_nullable_to_non_nullable
                  as String,
        date: freezed == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        godown: null == godown
            ? _value.godown
            : godown // ignore: cast_nullable_to_non_nullable
                  as String,
        remark: null == remark
            ? _value.remark
            : remark // ignore: cast_nullable_to_non_nullable
                  as String,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<DamageItemModel>,
        totalQty: null == totalQty
            ? _value.totalQty
            : totalQty // ignore: cast_nullable_to_non_nullable
                  as int,
        totalAmt: null == totalAmt
            ? _value.totalAmt
            : totalAmt // ignore: cast_nullable_to_non_nullable
                  as double,
        companyId: freezed == companyId
            ? _value.companyId
            : companyId // ignore: cast_nullable_to_non_nullable
                  as String?,
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
class _$DamageEntryModelImpl implements _DamageEntryModel {
  const _$DamageEntryModelImpl({
    @JsonKey(name: '_id') this.id,
    this.billSeries = 'DMG',
    this.billNo = '',
    this.date,
    this.type = 'Damage',
    this.godown = 'HO',
    this.remark = '',
    final List<DamageItemModel> items = const [],
    this.totalQty = 0,
    this.totalAmt = 0.0,
    this.companyId,
    this.createdAt,
    this.updatedAt,
  }) : _items = items;

  factory _$DamageEntryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DamageEntryModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String? id;
  @override
  @JsonKey()
  final String billSeries;
  @override
  @JsonKey()
  final String billNo;
  @override
  final String? date;
  @override
  @JsonKey()
  final String type;
  @override
  @JsonKey()
  final String godown;
  @override
  @JsonKey()
  final String remark;
  final List<DamageItemModel> _items;
  @override
  @JsonKey()
  List<DamageItemModel> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey()
  final int totalQty;
  @override
  @JsonKey()
  final double totalAmt;
  @override
  final String? companyId;
  @override
  final String? createdAt;
  @override
  final String? updatedAt;

  @override
  String toString() {
    return 'DamageEntryModel(id: $id, billSeries: $billSeries, billNo: $billNo, date: $date, type: $type, godown: $godown, remark: $remark, items: $items, totalQty: $totalQty, totalAmt: $totalAmt, companyId: $companyId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DamageEntryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.billSeries, billSeries) ||
                other.billSeries == billSeries) &&
            (identical(other.billNo, billNo) || other.billNo == billNo) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.godown, godown) || other.godown == godown) &&
            (identical(other.remark, remark) || other.remark == remark) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.totalQty, totalQty) ||
                other.totalQty == totalQty) &&
            (identical(other.totalAmt, totalAmt) ||
                other.totalAmt == totalAmt) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
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
    billSeries,
    billNo,
    date,
    type,
    godown,
    remark,
    const DeepCollectionEquality().hash(_items),
    totalQty,
    totalAmt,
    companyId,
    createdAt,
    updatedAt,
  );

  /// Create a copy of DamageEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DamageEntryModelImplCopyWith<_$DamageEntryModelImpl> get copyWith =>
      __$$DamageEntryModelImplCopyWithImpl<_$DamageEntryModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DamageEntryModelImplToJson(this);
  }
}

abstract class _DamageEntryModel implements DamageEntryModel {
  const factory _DamageEntryModel({
    @JsonKey(name: '_id') final String? id,
    final String billSeries,
    final String billNo,
    final String? date,
    final String type,
    final String godown,
    final String remark,
    final List<DamageItemModel> items,
    final int totalQty,
    final double totalAmt,
    final String? companyId,
    final String? createdAt,
    final String? updatedAt,
  }) = _$DamageEntryModelImpl;

  factory _DamageEntryModel.fromJson(Map<String, dynamic> json) =
      _$DamageEntryModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String? get id;
  @override
  String get billSeries;
  @override
  String get billNo;
  @override
  String? get date;
  @override
  String get type;
  @override
  String get godown;
  @override
  String get remark;
  @override
  List<DamageItemModel> get items;
  @override
  int get totalQty;
  @override
  double get totalAmt;
  @override
  String? get companyId;
  @override
  String? get createdAt;
  @override
  String? get updatedAt;

  /// Create a copy of DamageEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DamageEntryModelImplCopyWith<_$DamageEntryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DamageItemModel _$DamageItemModelFromJson(Map<String, dynamic> json) {
  return _DamageItemModel.fromJson(json);
}

/// @nodoc
mixin _$DamageItemModel {
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String get itemName => throw _privateConstructorUsedError;
  String get partyName => throw _privateConstructorUsedError;
  String get orderNo => throw _privateConstructorUsedError;
  String get eye => throw _privateConstructorUsedError;
  double get sph => throw _privateConstructorUsedError;
  double get cyl => throw _privateConstructorUsedError;
  double get axis => throw _privateConstructorUsedError;
  double get add => throw _privateConstructorUsedError;
  int get qty => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  double get totalAmt => throw _privateConstructorUsedError;
  String get combinationId => throw _privateConstructorUsedError;

  /// Serializes this DamageItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DamageItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DamageItemModelCopyWith<DamageItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DamageItemModelCopyWith<$Res> {
  factory $DamageItemModelCopyWith(
    DamageItemModel value,
    $Res Function(DamageItemModel) then,
  ) = _$DamageItemModelCopyWithImpl<$Res, DamageItemModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    String code,
    String itemName,
    String partyName,
    String orderNo,
    String eye,
    double sph,
    double cyl,
    double axis,
    double add,
    int qty,
    double price,
    double totalAmt,
    String combinationId,
  });
}

/// @nodoc
class _$DamageItemModelCopyWithImpl<$Res, $Val extends DamageItemModel>
    implements $DamageItemModelCopyWith<$Res> {
  _$DamageItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DamageItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? code = null,
    Object? itemName = null,
    Object? partyName = null,
    Object? orderNo = null,
    Object? eye = null,
    Object? sph = null,
    Object? cyl = null,
    Object? axis = null,
    Object? add = null,
    Object? qty = null,
    Object? price = null,
    Object? totalAmt = null,
    Object? combinationId = null,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            code: null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String,
            itemName: null == itemName
                ? _value.itemName
                : itemName // ignore: cast_nullable_to_non_nullable
                      as String,
            partyName: null == partyName
                ? _value.partyName
                : partyName // ignore: cast_nullable_to_non_nullable
                      as String,
            orderNo: null == orderNo
                ? _value.orderNo
                : orderNo // ignore: cast_nullable_to_non_nullable
                      as String,
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
                      as double,
            add: null == add
                ? _value.add
                : add // ignore: cast_nullable_to_non_nullable
                      as double,
            qty: null == qty
                ? _value.qty
                : qty // ignore: cast_nullable_to_non_nullable
                      as int,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            totalAmt: null == totalAmt
                ? _value.totalAmt
                : totalAmt // ignore: cast_nullable_to_non_nullable
                      as double,
            combinationId: null == combinationId
                ? _value.combinationId
                : combinationId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DamageItemModelImplCopyWith<$Res>
    implements $DamageItemModelCopyWith<$Res> {
  factory _$$DamageItemModelImplCopyWith(
    _$DamageItemModelImpl value,
    $Res Function(_$DamageItemModelImpl) then,
  ) = __$$DamageItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    String code,
    String itemName,
    String partyName,
    String orderNo,
    String eye,
    double sph,
    double cyl,
    double axis,
    double add,
    int qty,
    double price,
    double totalAmt,
    String combinationId,
  });
}

/// @nodoc
class __$$DamageItemModelImplCopyWithImpl<$Res>
    extends _$DamageItemModelCopyWithImpl<$Res, _$DamageItemModelImpl>
    implements _$$DamageItemModelImplCopyWith<$Res> {
  __$$DamageItemModelImplCopyWithImpl(
    _$DamageItemModelImpl _value,
    $Res Function(_$DamageItemModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DamageItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? code = null,
    Object? itemName = null,
    Object? partyName = null,
    Object? orderNo = null,
    Object? eye = null,
    Object? sph = null,
    Object? cyl = null,
    Object? axis = null,
    Object? add = null,
    Object? qty = null,
    Object? price = null,
    Object? totalAmt = null,
    Object? combinationId = null,
  }) {
    return _then(
      _$DamageItemModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        code: null == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String,
        itemName: null == itemName
            ? _value.itemName
            : itemName // ignore: cast_nullable_to_non_nullable
                  as String,
        partyName: null == partyName
            ? _value.partyName
            : partyName // ignore: cast_nullable_to_non_nullable
                  as String,
        orderNo: null == orderNo
            ? _value.orderNo
            : orderNo // ignore: cast_nullable_to_non_nullable
                  as String,
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
                  as double,
        add: null == add
            ? _value.add
            : add // ignore: cast_nullable_to_non_nullable
                  as double,
        qty: null == qty
            ? _value.qty
            : qty // ignore: cast_nullable_to_non_nullable
                  as int,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        totalAmt: null == totalAmt
            ? _value.totalAmt
            : totalAmt // ignore: cast_nullable_to_non_nullable
                  as double,
        combinationId: null == combinationId
            ? _value.combinationId
            : combinationId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DamageItemModelImpl implements _DamageItemModel {
  const _$DamageItemModelImpl({
    @JsonKey(name: '_id') this.id,
    this.code = '',
    this.itemName = '',
    this.partyName = '',
    this.orderNo = '',
    this.eye = '',
    this.sph = 0.0,
    this.cyl = 0.0,
    this.axis = 0.0,
    this.add = 0.0,
    this.qty = 0,
    this.price = 0.0,
    this.totalAmt = 0.0,
    this.combinationId = '',
  });

  factory _$DamageItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DamageItemModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String? id;
  @override
  @JsonKey()
  final String code;
  @override
  @JsonKey()
  final String itemName;
  @override
  @JsonKey()
  final String partyName;
  @override
  @JsonKey()
  final String orderNo;
  @override
  @JsonKey()
  final String eye;
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
  @override
  @JsonKey()
  final int qty;
  @override
  @JsonKey()
  final double price;
  @override
  @JsonKey()
  final double totalAmt;
  @override
  @JsonKey()
  final String combinationId;

  @override
  String toString() {
    return 'DamageItemModel(id: $id, code: $code, itemName: $itemName, partyName: $partyName, orderNo: $orderNo, eye: $eye, sph: $sph, cyl: $cyl, axis: $axis, add: $add, qty: $qty, price: $price, totalAmt: $totalAmt, combinationId: $combinationId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DamageItemModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.itemName, itemName) ||
                other.itemName == itemName) &&
            (identical(other.partyName, partyName) ||
                other.partyName == partyName) &&
            (identical(other.orderNo, orderNo) || other.orderNo == orderNo) &&
            (identical(other.eye, eye) || other.eye == eye) &&
            (identical(other.sph, sph) || other.sph == sph) &&
            (identical(other.cyl, cyl) || other.cyl == cyl) &&
            (identical(other.axis, axis) || other.axis == axis) &&
            (identical(other.add, add) || other.add == add) &&
            (identical(other.qty, qty) || other.qty == qty) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.totalAmt, totalAmt) ||
                other.totalAmt == totalAmt) &&
            (identical(other.combinationId, combinationId) ||
                other.combinationId == combinationId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    code,
    itemName,
    partyName,
    orderNo,
    eye,
    sph,
    cyl,
    axis,
    add,
    qty,
    price,
    totalAmt,
    combinationId,
  );

  /// Create a copy of DamageItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DamageItemModelImplCopyWith<_$DamageItemModelImpl> get copyWith =>
      __$$DamageItemModelImplCopyWithImpl<_$DamageItemModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DamageItemModelImplToJson(this);
  }
}

abstract class _DamageItemModel implements DamageItemModel {
  const factory _DamageItemModel({
    @JsonKey(name: '_id') final String? id,
    final String code,
    final String itemName,
    final String partyName,
    final String orderNo,
    final String eye,
    final double sph,
    final double cyl,
    final double axis,
    final double add,
    final int qty,
    final double price,
    final double totalAmt,
    final String combinationId,
  }) = _$DamageItemModelImpl;

  factory _DamageItemModel.fromJson(Map<String, dynamic> json) =
      _$DamageItemModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String? get id;
  @override
  String get code;
  @override
  String get itemName;
  @override
  String get partyName;
  @override
  String get orderNo;
  @override
  String get eye;
  @override
  double get sph;
  @override
  double get cyl;
  @override
  double get axis;
  @override
  double get add;
  @override
  int get qty;
  @override
  double get price;
  @override
  double get totalAmt;
  @override
  String get combinationId;

  /// Create a copy of DamageItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DamageItemModelImplCopyWith<_$DamageItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
