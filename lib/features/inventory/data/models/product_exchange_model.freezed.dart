// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_exchange_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProductExchangeModel _$ProductExchangeModelFromJson(Map<String, dynamic> json) {
  return _ProductExchangeModel.fromJson(json);
}

/// @nodoc
mixin _$ProductExchangeModel {
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;
  ExchangeBillData get billData => throw _privateConstructorUsedError;
  ExchangePartyData get partyData => throw _privateConstructorUsedError;
  List<ExchangeItemModel> get exchangeOutItems =>
      throw _privateConstructorUsedError;
  List<ExchangeItemModel> get exchangeInItems =>
      throw _privateConstructorUsedError;
  ExchangeTotals get totals => throw _privateConstructorUsedError;
  String get remarks => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;
  String? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ProductExchangeModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductExchangeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductExchangeModelCopyWith<ProductExchangeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductExchangeModelCopyWith<$Res> {
  factory $ProductExchangeModelCopyWith(
    ProductExchangeModel value,
    $Res Function(ProductExchangeModel) then,
  ) = _$ProductExchangeModelCopyWithImpl<$Res, ProductExchangeModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    ExchangeBillData billData,
    ExchangePartyData partyData,
    List<ExchangeItemModel> exchangeOutItems,
    List<ExchangeItemModel> exchangeInItems,
    ExchangeTotals totals,
    String remarks,
    String status,
    String? createdAt,
    String? updatedAt,
  });

  $ExchangeBillDataCopyWith<$Res> get billData;
  $ExchangePartyDataCopyWith<$Res> get partyData;
  $ExchangeTotalsCopyWith<$Res> get totals;
}

/// @nodoc
class _$ProductExchangeModelCopyWithImpl<
  $Res,
  $Val extends ProductExchangeModel
>
    implements $ProductExchangeModelCopyWith<$Res> {
  _$ProductExchangeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductExchangeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? billData = null,
    Object? partyData = null,
    Object? exchangeOutItems = null,
    Object? exchangeInItems = null,
    Object? totals = null,
    Object? remarks = null,
    Object? status = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            billData: null == billData
                ? _value.billData
                : billData // ignore: cast_nullable_to_non_nullable
                      as ExchangeBillData,
            partyData: null == partyData
                ? _value.partyData
                : partyData // ignore: cast_nullable_to_non_nullable
                      as ExchangePartyData,
            exchangeOutItems: null == exchangeOutItems
                ? _value.exchangeOutItems
                : exchangeOutItems // ignore: cast_nullable_to_non_nullable
                      as List<ExchangeItemModel>,
            exchangeInItems: null == exchangeInItems
                ? _value.exchangeInItems
                : exchangeInItems // ignore: cast_nullable_to_non_nullable
                      as List<ExchangeItemModel>,
            totals: null == totals
                ? _value.totals
                : totals // ignore: cast_nullable_to_non_nullable
                      as ExchangeTotals,
            remarks: null == remarks
                ? _value.remarks
                : remarks // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
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

  /// Create a copy of ProductExchangeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ExchangeBillDataCopyWith<$Res> get billData {
    return $ExchangeBillDataCopyWith<$Res>(_value.billData, (value) {
      return _then(_value.copyWith(billData: value) as $Val);
    });
  }

  /// Create a copy of ProductExchangeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ExchangePartyDataCopyWith<$Res> get partyData {
    return $ExchangePartyDataCopyWith<$Res>(_value.partyData, (value) {
      return _then(_value.copyWith(partyData: value) as $Val);
    });
  }

  /// Create a copy of ProductExchangeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ExchangeTotalsCopyWith<$Res> get totals {
    return $ExchangeTotalsCopyWith<$Res>(_value.totals, (value) {
      return _then(_value.copyWith(totals: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProductExchangeModelImplCopyWith<$Res>
    implements $ProductExchangeModelCopyWith<$Res> {
  factory _$$ProductExchangeModelImplCopyWith(
    _$ProductExchangeModelImpl value,
    $Res Function(_$ProductExchangeModelImpl) then,
  ) = __$$ProductExchangeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    ExchangeBillData billData,
    ExchangePartyData partyData,
    List<ExchangeItemModel> exchangeOutItems,
    List<ExchangeItemModel> exchangeInItems,
    ExchangeTotals totals,
    String remarks,
    String status,
    String? createdAt,
    String? updatedAt,
  });

  @override
  $ExchangeBillDataCopyWith<$Res> get billData;
  @override
  $ExchangePartyDataCopyWith<$Res> get partyData;
  @override
  $ExchangeTotalsCopyWith<$Res> get totals;
}

/// @nodoc
class __$$ProductExchangeModelImplCopyWithImpl<$Res>
    extends _$ProductExchangeModelCopyWithImpl<$Res, _$ProductExchangeModelImpl>
    implements _$$ProductExchangeModelImplCopyWith<$Res> {
  __$$ProductExchangeModelImplCopyWithImpl(
    _$ProductExchangeModelImpl _value,
    $Res Function(_$ProductExchangeModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductExchangeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? billData = null,
    Object? partyData = null,
    Object? exchangeOutItems = null,
    Object? exchangeInItems = null,
    Object? totals = null,
    Object? remarks = null,
    Object? status = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$ProductExchangeModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        billData: null == billData
            ? _value.billData
            : billData // ignore: cast_nullable_to_non_nullable
                  as ExchangeBillData,
        partyData: null == partyData
            ? _value.partyData
            : partyData // ignore: cast_nullable_to_non_nullable
                  as ExchangePartyData,
        exchangeOutItems: null == exchangeOutItems
            ? _value._exchangeOutItems
            : exchangeOutItems // ignore: cast_nullable_to_non_nullable
                  as List<ExchangeItemModel>,
        exchangeInItems: null == exchangeInItems
            ? _value._exchangeInItems
            : exchangeInItems // ignore: cast_nullable_to_non_nullable
                  as List<ExchangeItemModel>,
        totals: null == totals
            ? _value.totals
            : totals // ignore: cast_nullable_to_non_nullable
                  as ExchangeTotals,
        remarks: null == remarks
            ? _value.remarks
            : remarks // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
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
class _$ProductExchangeModelImpl implements _ProductExchangeModel {
  const _$ProductExchangeModelImpl({
    @JsonKey(name: '_id') this.id,
    this.billData = const ExchangeBillData(),
    this.partyData = const ExchangePartyData(),
    final List<ExchangeItemModel> exchangeOutItems = const [],
    final List<ExchangeItemModel> exchangeInItems = const [],
    this.totals = const ExchangeTotals(),
    this.remarks = '',
    this.status = 'Completed',
    this.createdAt,
    this.updatedAt,
  }) : _exchangeOutItems = exchangeOutItems,
       _exchangeInItems = exchangeInItems;

  factory _$ProductExchangeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductExchangeModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String? id;
  @override
  @JsonKey()
  final ExchangeBillData billData;
  @override
  @JsonKey()
  final ExchangePartyData partyData;
  final List<ExchangeItemModel> _exchangeOutItems;
  @override
  @JsonKey()
  List<ExchangeItemModel> get exchangeOutItems {
    if (_exchangeOutItems is EqualUnmodifiableListView)
      return _exchangeOutItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_exchangeOutItems);
  }

  final List<ExchangeItemModel> _exchangeInItems;
  @override
  @JsonKey()
  List<ExchangeItemModel> get exchangeInItems {
    if (_exchangeInItems is EqualUnmodifiableListView) return _exchangeInItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_exchangeInItems);
  }

  @override
  @JsonKey()
  final ExchangeTotals totals;
  @override
  @JsonKey()
  final String remarks;
  @override
  @JsonKey()
  final String status;
  @override
  final String? createdAt;
  @override
  final String? updatedAt;

  @override
  String toString() {
    return 'ProductExchangeModel(id: $id, billData: $billData, partyData: $partyData, exchangeOutItems: $exchangeOutItems, exchangeInItems: $exchangeInItems, totals: $totals, remarks: $remarks, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductExchangeModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.billData, billData) ||
                other.billData == billData) &&
            (identical(other.partyData, partyData) ||
                other.partyData == partyData) &&
            const DeepCollectionEquality().equals(
              other._exchangeOutItems,
              _exchangeOutItems,
            ) &&
            const DeepCollectionEquality().equals(
              other._exchangeInItems,
              _exchangeInItems,
            ) &&
            (identical(other.totals, totals) || other.totals == totals) &&
            (identical(other.remarks, remarks) || other.remarks == remarks) &&
            (identical(other.status, status) || other.status == status) &&
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
    billData,
    partyData,
    const DeepCollectionEquality().hash(_exchangeOutItems),
    const DeepCollectionEquality().hash(_exchangeInItems),
    totals,
    remarks,
    status,
    createdAt,
    updatedAt,
  );

  /// Create a copy of ProductExchangeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductExchangeModelImplCopyWith<_$ProductExchangeModelImpl>
  get copyWith =>
      __$$ProductExchangeModelImplCopyWithImpl<_$ProductExchangeModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductExchangeModelImplToJson(this);
  }
}

abstract class _ProductExchangeModel implements ProductExchangeModel {
  const factory _ProductExchangeModel({
    @JsonKey(name: '_id') final String? id,
    final ExchangeBillData billData,
    final ExchangePartyData partyData,
    final List<ExchangeItemModel> exchangeOutItems,
    final List<ExchangeItemModel> exchangeInItems,
    final ExchangeTotals totals,
    final String remarks,
    final String status,
    final String? createdAt,
    final String? updatedAt,
  }) = _$ProductExchangeModelImpl;

  factory _ProductExchangeModel.fromJson(Map<String, dynamic> json) =
      _$ProductExchangeModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String? get id;
  @override
  ExchangeBillData get billData;
  @override
  ExchangePartyData get partyData;
  @override
  List<ExchangeItemModel> get exchangeOutItems;
  @override
  List<ExchangeItemModel> get exchangeInItems;
  @override
  ExchangeTotals get totals;
  @override
  String get remarks;
  @override
  String get status;
  @override
  String? get createdAt;
  @override
  String? get updatedAt;

  /// Create a copy of ProductExchangeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductExchangeModelImplCopyWith<_$ProductExchangeModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

ExchangeBillData _$ExchangeBillDataFromJson(Map<String, dynamic> json) {
  return _ExchangeBillData.fromJson(json);
}

/// @nodoc
mixin _$ExchangeBillData {
  String get billSeries => throw _privateConstructorUsedError;
  String get billNo => throw _privateConstructorUsedError;
  String? get date => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get godown => throw _privateConstructorUsedError;
  String get bookedBy => throw _privateConstructorUsedError;

  /// Serializes this ExchangeBillData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExchangeBillData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExchangeBillDataCopyWith<ExchangeBillData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExchangeBillDataCopyWith<$Res> {
  factory $ExchangeBillDataCopyWith(
    ExchangeBillData value,
    $Res Function(ExchangeBillData) then,
  ) = _$ExchangeBillDataCopyWithImpl<$Res, ExchangeBillData>;
  @useResult
  $Res call({
    String billSeries,
    String billNo,
    String? date,
    String type,
    String godown,
    String bookedBy,
  });
}

/// @nodoc
class _$ExchangeBillDataCopyWithImpl<$Res, $Val extends ExchangeBillData>
    implements $ExchangeBillDataCopyWith<$Res> {
  _$ExchangeBillDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExchangeBillData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? billSeries = null,
    Object? billNo = null,
    Object? date = freezed,
    Object? type = null,
    Object? godown = null,
    Object? bookedBy = null,
  }) {
    return _then(
      _value.copyWith(
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
            bookedBy: null == bookedBy
                ? _value.bookedBy
                : bookedBy // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ExchangeBillDataImplCopyWith<$Res>
    implements $ExchangeBillDataCopyWith<$Res> {
  factory _$$ExchangeBillDataImplCopyWith(
    _$ExchangeBillDataImpl value,
    $Res Function(_$ExchangeBillDataImpl) then,
  ) = __$$ExchangeBillDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String billSeries,
    String billNo,
    String? date,
    String type,
    String godown,
    String bookedBy,
  });
}

/// @nodoc
class __$$ExchangeBillDataImplCopyWithImpl<$Res>
    extends _$ExchangeBillDataCopyWithImpl<$Res, _$ExchangeBillDataImpl>
    implements _$$ExchangeBillDataImplCopyWith<$Res> {
  __$$ExchangeBillDataImplCopyWithImpl(
    _$ExchangeBillDataImpl _value,
    $Res Function(_$ExchangeBillDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExchangeBillData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? billSeries = null,
    Object? billNo = null,
    Object? date = freezed,
    Object? type = null,
    Object? godown = null,
    Object? bookedBy = null,
  }) {
    return _then(
      _$ExchangeBillDataImpl(
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
        bookedBy: null == bookedBy
            ? _value.bookedBy
            : bookedBy // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ExchangeBillDataImpl implements _ExchangeBillData {
  const _$ExchangeBillDataImpl({
    this.billSeries = 'Exchange',
    this.billNo = '',
    this.date,
    this.type = 'Lens',
    this.godown = 'MT-1',
    this.bookedBy = '',
  });

  factory _$ExchangeBillDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExchangeBillDataImplFromJson(json);

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
  final String bookedBy;

  @override
  String toString() {
    return 'ExchangeBillData(billSeries: $billSeries, billNo: $billNo, date: $date, type: $type, godown: $godown, bookedBy: $bookedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExchangeBillDataImpl &&
            (identical(other.billSeries, billSeries) ||
                other.billSeries == billSeries) &&
            (identical(other.billNo, billNo) || other.billNo == billNo) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.godown, godown) || other.godown == godown) &&
            (identical(other.bookedBy, bookedBy) ||
                other.bookedBy == bookedBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    billSeries,
    billNo,
    date,
    type,
    godown,
    bookedBy,
  );

  /// Create a copy of ExchangeBillData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExchangeBillDataImplCopyWith<_$ExchangeBillDataImpl> get copyWith =>
      __$$ExchangeBillDataImplCopyWithImpl<_$ExchangeBillDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ExchangeBillDataImplToJson(this);
  }
}

abstract class _ExchangeBillData implements ExchangeBillData {
  const factory _ExchangeBillData({
    final String billSeries,
    final String billNo,
    final String? date,
    final String type,
    final String godown,
    final String bookedBy,
  }) = _$ExchangeBillDataImpl;

  factory _ExchangeBillData.fromJson(Map<String, dynamic> json) =
      _$ExchangeBillDataImpl.fromJson;

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
  String get bookedBy;

  /// Create a copy of ExchangeBillData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExchangeBillDataImplCopyWith<_$ExchangeBillDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ExchangePartyData _$ExchangePartyDataFromJson(Map<String, dynamic> json) {
  return _ExchangePartyData.fromJson(json);
}

/// @nodoc
mixin _$ExchangePartyData {
  String get partyAccount => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String get contactNumber => throw _privateConstructorUsedError;

  /// Serializes this ExchangePartyData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExchangePartyData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExchangePartyDataCopyWith<ExchangePartyData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExchangePartyDataCopyWith<$Res> {
  factory $ExchangePartyDataCopyWith(
    ExchangePartyData value,
    $Res Function(ExchangePartyData) then,
  ) = _$ExchangePartyDataCopyWithImpl<$Res, ExchangePartyData>;
  @useResult
  $Res call({String partyAccount, String address, String contactNumber});
}

/// @nodoc
class _$ExchangePartyDataCopyWithImpl<$Res, $Val extends ExchangePartyData>
    implements $ExchangePartyDataCopyWith<$Res> {
  _$ExchangePartyDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExchangePartyData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? partyAccount = null,
    Object? address = null,
    Object? contactNumber = null,
  }) {
    return _then(
      _value.copyWith(
            partyAccount: null == partyAccount
                ? _value.partyAccount
                : partyAccount // ignore: cast_nullable_to_non_nullable
                      as String,
            address: null == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String,
            contactNumber: null == contactNumber
                ? _value.contactNumber
                : contactNumber // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ExchangePartyDataImplCopyWith<$Res>
    implements $ExchangePartyDataCopyWith<$Res> {
  factory _$$ExchangePartyDataImplCopyWith(
    _$ExchangePartyDataImpl value,
    $Res Function(_$ExchangePartyDataImpl) then,
  ) = __$$ExchangePartyDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String partyAccount, String address, String contactNumber});
}

/// @nodoc
class __$$ExchangePartyDataImplCopyWithImpl<$Res>
    extends _$ExchangePartyDataCopyWithImpl<$Res, _$ExchangePartyDataImpl>
    implements _$$ExchangePartyDataImplCopyWith<$Res> {
  __$$ExchangePartyDataImplCopyWithImpl(
    _$ExchangePartyDataImpl _value,
    $Res Function(_$ExchangePartyDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExchangePartyData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? partyAccount = null,
    Object? address = null,
    Object? contactNumber = null,
  }) {
    return _then(
      _$ExchangePartyDataImpl(
        partyAccount: null == partyAccount
            ? _value.partyAccount
            : partyAccount // ignore: cast_nullable_to_non_nullable
                  as String,
        address: null == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String,
        contactNumber: null == contactNumber
            ? _value.contactNumber
            : contactNumber // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ExchangePartyDataImpl implements _ExchangePartyData {
  const _$ExchangePartyDataImpl({
    this.partyAccount = '',
    this.address = '',
    this.contactNumber = '',
  });

  factory _$ExchangePartyDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExchangePartyDataImplFromJson(json);

  @override
  @JsonKey()
  final String partyAccount;
  @override
  @JsonKey()
  final String address;
  @override
  @JsonKey()
  final String contactNumber;

  @override
  String toString() {
    return 'ExchangePartyData(partyAccount: $partyAccount, address: $address, contactNumber: $contactNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExchangePartyDataImpl &&
            (identical(other.partyAccount, partyAccount) ||
                other.partyAccount == partyAccount) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.contactNumber, contactNumber) ||
                other.contactNumber == contactNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, partyAccount, address, contactNumber);

  /// Create a copy of ExchangePartyData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExchangePartyDataImplCopyWith<_$ExchangePartyDataImpl> get copyWith =>
      __$$ExchangePartyDataImplCopyWithImpl<_$ExchangePartyDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ExchangePartyDataImplToJson(this);
  }
}

abstract class _ExchangePartyData implements ExchangePartyData {
  const factory _ExchangePartyData({
    final String partyAccount,
    final String address,
    final String contactNumber,
  }) = _$ExchangePartyDataImpl;

  factory _ExchangePartyData.fromJson(Map<String, dynamic> json) =
      _$ExchangePartyDataImpl.fromJson;

  @override
  String get partyAccount;
  @override
  String get address;
  @override
  String get contactNumber;

  /// Create a copy of ExchangePartyData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExchangePartyDataImplCopyWith<_$ExchangePartyDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ExchangeItemModel _$ExchangeItemModelFromJson(Map<String, dynamic> json) {
  return _ExchangeItemModel.fromJson(json);
}

/// @nodoc
mixin _$ExchangeItemModel {
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String get itemName => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  String get dia => throw _privateConstructorUsedError;
  String get eye => throw _privateConstructorUsedError;
  double get sph => throw _privateConstructorUsedError;
  double get cyl => throw _privateConstructorUsedError;
  double get axis => throw _privateConstructorUsedError;
  double get add => throw _privateConstructorUsedError;
  String get remark => throw _privateConstructorUsedError;
  int get qty => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;

  /// Serializes this ExchangeItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExchangeItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExchangeItemModelCopyWith<ExchangeItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExchangeItemModelCopyWith<$Res> {
  factory $ExchangeItemModelCopyWith(
    ExchangeItemModel value,
    $Res Function(ExchangeItemModel) then,
  ) = _$ExchangeItemModelCopyWithImpl<$Res, ExchangeItemModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    String code,
    String itemName,
    String unit,
    String dia,
    String eye,
    double sph,
    double cyl,
    double axis,
    double add,
    String remark,
    int qty,
    double price,
    double totalAmount,
  });
}

/// @nodoc
class _$ExchangeItemModelCopyWithImpl<$Res, $Val extends ExchangeItemModel>
    implements $ExchangeItemModelCopyWith<$Res> {
  _$ExchangeItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExchangeItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? code = null,
    Object? itemName = null,
    Object? unit = null,
    Object? dia = null,
    Object? eye = null,
    Object? sph = null,
    Object? cyl = null,
    Object? axis = null,
    Object? add = null,
    Object? remark = null,
    Object? qty = null,
    Object? price = null,
    Object? totalAmount = null,
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
            unit: null == unit
                ? _value.unit
                : unit // ignore: cast_nullable_to_non_nullable
                      as String,
            dia: null == dia
                ? _value.dia
                : dia // ignore: cast_nullable_to_non_nullable
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
            remark: null == remark
                ? _value.remark
                : remark // ignore: cast_nullable_to_non_nullable
                      as String,
            qty: null == qty
                ? _value.qty
                : qty // ignore: cast_nullable_to_non_nullable
                      as int,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            totalAmount: null == totalAmount
                ? _value.totalAmount
                : totalAmount // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ExchangeItemModelImplCopyWith<$Res>
    implements $ExchangeItemModelCopyWith<$Res> {
  factory _$$ExchangeItemModelImplCopyWith(
    _$ExchangeItemModelImpl value,
    $Res Function(_$ExchangeItemModelImpl) then,
  ) = __$$ExchangeItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    String code,
    String itemName,
    String unit,
    String dia,
    String eye,
    double sph,
    double cyl,
    double axis,
    double add,
    String remark,
    int qty,
    double price,
    double totalAmount,
  });
}

/// @nodoc
class __$$ExchangeItemModelImplCopyWithImpl<$Res>
    extends _$ExchangeItemModelCopyWithImpl<$Res, _$ExchangeItemModelImpl>
    implements _$$ExchangeItemModelImplCopyWith<$Res> {
  __$$ExchangeItemModelImplCopyWithImpl(
    _$ExchangeItemModelImpl _value,
    $Res Function(_$ExchangeItemModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExchangeItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? code = null,
    Object? itemName = null,
    Object? unit = null,
    Object? dia = null,
    Object? eye = null,
    Object? sph = null,
    Object? cyl = null,
    Object? axis = null,
    Object? add = null,
    Object? remark = null,
    Object? qty = null,
    Object? price = null,
    Object? totalAmount = null,
  }) {
    return _then(
      _$ExchangeItemModelImpl(
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
        unit: null == unit
            ? _value.unit
            : unit // ignore: cast_nullable_to_non_nullable
                  as String,
        dia: null == dia
            ? _value.dia
            : dia // ignore: cast_nullable_to_non_nullable
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
        remark: null == remark
            ? _value.remark
            : remark // ignore: cast_nullable_to_non_nullable
                  as String,
        qty: null == qty
            ? _value.qty
            : qty // ignore: cast_nullable_to_non_nullable
                  as int,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        totalAmount: null == totalAmount
            ? _value.totalAmount
            : totalAmount // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ExchangeItemModelImpl implements _ExchangeItemModel {
  const _$ExchangeItemModelImpl({
    @JsonKey(name: '_id') this.id,
    this.code = '',
    this.itemName = '',
    this.unit = '',
    this.dia = '',
    this.eye = '',
    this.sph = 0.0,
    this.cyl = 0.0,
    this.axis = 0.0,
    this.add = 0.0,
    this.remark = '',
    this.qty = 0,
    this.price = 0.0,
    this.totalAmount = 0.0,
  });

  factory _$ExchangeItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExchangeItemModelImplFromJson(json);

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
  final String unit;
  @override
  @JsonKey()
  final String dia;
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
  final String remark;
  @override
  @JsonKey()
  final int qty;
  @override
  @JsonKey()
  final double price;
  @override
  @JsonKey()
  final double totalAmount;

  @override
  String toString() {
    return 'ExchangeItemModel(id: $id, code: $code, itemName: $itemName, unit: $unit, dia: $dia, eye: $eye, sph: $sph, cyl: $cyl, axis: $axis, add: $add, remark: $remark, qty: $qty, price: $price, totalAmount: $totalAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExchangeItemModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.itemName, itemName) ||
                other.itemName == itemName) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.dia, dia) || other.dia == dia) &&
            (identical(other.eye, eye) || other.eye == eye) &&
            (identical(other.sph, sph) || other.sph == sph) &&
            (identical(other.cyl, cyl) || other.cyl == cyl) &&
            (identical(other.axis, axis) || other.axis == axis) &&
            (identical(other.add, add) || other.add == add) &&
            (identical(other.remark, remark) || other.remark == remark) &&
            (identical(other.qty, qty) || other.qty == qty) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    code,
    itemName,
    unit,
    dia,
    eye,
    sph,
    cyl,
    axis,
    add,
    remark,
    qty,
    price,
    totalAmount,
  );

  /// Create a copy of ExchangeItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExchangeItemModelImplCopyWith<_$ExchangeItemModelImpl> get copyWith =>
      __$$ExchangeItemModelImplCopyWithImpl<_$ExchangeItemModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ExchangeItemModelImplToJson(this);
  }
}

abstract class _ExchangeItemModel implements ExchangeItemModel {
  const factory _ExchangeItemModel({
    @JsonKey(name: '_id') final String? id,
    final String code,
    final String itemName,
    final String unit,
    final String dia,
    final String eye,
    final double sph,
    final double cyl,
    final double axis,
    final double add,
    final String remark,
    final int qty,
    final double price,
    final double totalAmount,
  }) = _$ExchangeItemModelImpl;

  factory _ExchangeItemModel.fromJson(Map<String, dynamic> json) =
      _$ExchangeItemModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String? get id;
  @override
  String get code;
  @override
  String get itemName;
  @override
  String get unit;
  @override
  String get dia;
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
  String get remark;
  @override
  int get qty;
  @override
  double get price;
  @override
  double get totalAmount;

  /// Create a copy of ExchangeItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExchangeItemModelImplCopyWith<_$ExchangeItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ExchangeTotals _$ExchangeTotalsFromJson(Map<String, dynamic> json) {
  return _ExchangeTotals.fromJson(json);
}

/// @nodoc
mixin _$ExchangeTotals {
  int get totalExchInQty => throw _privateConstructorUsedError;
  double get totalExchInAmnt => throw _privateConstructorUsedError;
  int get totalExchOutQty => throw _privateConstructorUsedError;
  double get totalExchOutAmnt => throw _privateConstructorUsedError;

  /// Serializes this ExchangeTotals to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExchangeTotals
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExchangeTotalsCopyWith<ExchangeTotals> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExchangeTotalsCopyWith<$Res> {
  factory $ExchangeTotalsCopyWith(
    ExchangeTotals value,
    $Res Function(ExchangeTotals) then,
  ) = _$ExchangeTotalsCopyWithImpl<$Res, ExchangeTotals>;
  @useResult
  $Res call({
    int totalExchInQty,
    double totalExchInAmnt,
    int totalExchOutQty,
    double totalExchOutAmnt,
  });
}

/// @nodoc
class _$ExchangeTotalsCopyWithImpl<$Res, $Val extends ExchangeTotals>
    implements $ExchangeTotalsCopyWith<$Res> {
  _$ExchangeTotalsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExchangeTotals
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalExchInQty = null,
    Object? totalExchInAmnt = null,
    Object? totalExchOutQty = null,
    Object? totalExchOutAmnt = null,
  }) {
    return _then(
      _value.copyWith(
            totalExchInQty: null == totalExchInQty
                ? _value.totalExchInQty
                : totalExchInQty // ignore: cast_nullable_to_non_nullable
                      as int,
            totalExchInAmnt: null == totalExchInAmnt
                ? _value.totalExchInAmnt
                : totalExchInAmnt // ignore: cast_nullable_to_non_nullable
                      as double,
            totalExchOutQty: null == totalExchOutQty
                ? _value.totalExchOutQty
                : totalExchOutQty // ignore: cast_nullable_to_non_nullable
                      as int,
            totalExchOutAmnt: null == totalExchOutAmnt
                ? _value.totalExchOutAmnt
                : totalExchOutAmnt // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ExchangeTotalsImplCopyWith<$Res>
    implements $ExchangeTotalsCopyWith<$Res> {
  factory _$$ExchangeTotalsImplCopyWith(
    _$ExchangeTotalsImpl value,
    $Res Function(_$ExchangeTotalsImpl) then,
  ) = __$$ExchangeTotalsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalExchInQty,
    double totalExchInAmnt,
    int totalExchOutQty,
    double totalExchOutAmnt,
  });
}

/// @nodoc
class __$$ExchangeTotalsImplCopyWithImpl<$Res>
    extends _$ExchangeTotalsCopyWithImpl<$Res, _$ExchangeTotalsImpl>
    implements _$$ExchangeTotalsImplCopyWith<$Res> {
  __$$ExchangeTotalsImplCopyWithImpl(
    _$ExchangeTotalsImpl _value,
    $Res Function(_$ExchangeTotalsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExchangeTotals
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalExchInQty = null,
    Object? totalExchInAmnt = null,
    Object? totalExchOutQty = null,
    Object? totalExchOutAmnt = null,
  }) {
    return _then(
      _$ExchangeTotalsImpl(
        totalExchInQty: null == totalExchInQty
            ? _value.totalExchInQty
            : totalExchInQty // ignore: cast_nullable_to_non_nullable
                  as int,
        totalExchInAmnt: null == totalExchInAmnt
            ? _value.totalExchInAmnt
            : totalExchInAmnt // ignore: cast_nullable_to_non_nullable
                  as double,
        totalExchOutQty: null == totalExchOutQty
            ? _value.totalExchOutQty
            : totalExchOutQty // ignore: cast_nullable_to_non_nullable
                  as int,
        totalExchOutAmnt: null == totalExchOutAmnt
            ? _value.totalExchOutAmnt
            : totalExchOutAmnt // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ExchangeTotalsImpl implements _ExchangeTotals {
  const _$ExchangeTotalsImpl({
    this.totalExchInQty = 0,
    this.totalExchInAmnt = 0.0,
    this.totalExchOutQty = 0,
    this.totalExchOutAmnt = 0.0,
  });

  factory _$ExchangeTotalsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExchangeTotalsImplFromJson(json);

  @override
  @JsonKey()
  final int totalExchInQty;
  @override
  @JsonKey()
  final double totalExchInAmnt;
  @override
  @JsonKey()
  final int totalExchOutQty;
  @override
  @JsonKey()
  final double totalExchOutAmnt;

  @override
  String toString() {
    return 'ExchangeTotals(totalExchInQty: $totalExchInQty, totalExchInAmnt: $totalExchInAmnt, totalExchOutQty: $totalExchOutQty, totalExchOutAmnt: $totalExchOutAmnt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExchangeTotalsImpl &&
            (identical(other.totalExchInQty, totalExchInQty) ||
                other.totalExchInQty == totalExchInQty) &&
            (identical(other.totalExchInAmnt, totalExchInAmnt) ||
                other.totalExchInAmnt == totalExchInAmnt) &&
            (identical(other.totalExchOutQty, totalExchOutQty) ||
                other.totalExchOutQty == totalExchOutQty) &&
            (identical(other.totalExchOutAmnt, totalExchOutAmnt) ||
                other.totalExchOutAmnt == totalExchOutAmnt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalExchInQty,
    totalExchInAmnt,
    totalExchOutQty,
    totalExchOutAmnt,
  );

  /// Create a copy of ExchangeTotals
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExchangeTotalsImplCopyWith<_$ExchangeTotalsImpl> get copyWith =>
      __$$ExchangeTotalsImplCopyWithImpl<_$ExchangeTotalsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ExchangeTotalsImplToJson(this);
  }
}

abstract class _ExchangeTotals implements ExchangeTotals {
  const factory _ExchangeTotals({
    final int totalExchInQty,
    final double totalExchInAmnt,
    final int totalExchOutQty,
    final double totalExchOutAmnt,
  }) = _$ExchangeTotalsImpl;

  factory _ExchangeTotals.fromJson(Map<String, dynamic> json) =
      _$ExchangeTotalsImpl.fromJson;

  @override
  int get totalExchInQty;
  @override
  double get totalExchInAmnt;
  @override
  int get totalExchOutQty;
  @override
  double get totalExchOutAmnt;

  /// Create a copy of ExchangeTotals
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExchangeTotalsImplCopyWith<_$ExchangeTotalsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
