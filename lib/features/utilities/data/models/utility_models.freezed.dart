// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'utility_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BackupLog _$BackupLogFromJson(Map<String, dynamic> json) {
  return _BackupLog.fromJson(json);
}

/// @nodoc
mixin _$BackupLog {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  int get size => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get storageLocation => throw _privateConstructorUsedError;
  String? get cloudPath => throw _privateConstructorUsedError;
  String? get localPath => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  @Deprecated('Use size instead')
  String? get fileSize => throw _privateConstructorUsedError;
  @Deprecated('Use name instead')
  String? get fileName => throw _privateConstructorUsedError;
  @Deprecated('Use createdAt instead')
  DateTime? get timestamp => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;

  /// Serializes this BackupLog to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BackupLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BackupLogCopyWith<BackupLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BackupLogCopyWith<$Res> {
  factory $BackupLogCopyWith(BackupLog value, $Res Function(BackupLog) then) =
      _$BackupLogCopyWithImpl<$Res, BackupLog>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String name,
    String type,
    int size,
    DateTime createdAt,
    DateTime updatedAt,
    String status,
    String storageLocation,
    String? cloudPath,
    String? localPath,
    String? error,
    @Deprecated('Use size instead') String? fileSize,
    @Deprecated('Use name instead') String? fileName,
    @Deprecated('Use createdAt instead') DateTime? timestamp,
    String version,
  });
}

/// @nodoc
class _$BackupLogCopyWithImpl<$Res, $Val extends BackupLog>
    implements $BackupLogCopyWith<$Res> {
  _$BackupLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BackupLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? size = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? status = null,
    Object? storageLocation = null,
    Object? cloudPath = freezed,
    Object? localPath = freezed,
    Object? error = freezed,
    Object? fileSize = freezed,
    Object? fileName = freezed,
    Object? timestamp = freezed,
    Object? version = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            size: null == size
                ? _value.size
                : size // ignore: cast_nullable_to_non_nullable
                      as int,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            storageLocation: null == storageLocation
                ? _value.storageLocation
                : storageLocation // ignore: cast_nullable_to_non_nullable
                      as String,
            cloudPath: freezed == cloudPath
                ? _value.cloudPath
                : cloudPath // ignore: cast_nullable_to_non_nullable
                      as String?,
            localPath: freezed == localPath
                ? _value.localPath
                : localPath // ignore: cast_nullable_to_non_nullable
                      as String?,
            error: freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as String?,
            fileSize: freezed == fileSize
                ? _value.fileSize
                : fileSize // ignore: cast_nullable_to_non_nullable
                      as String?,
            fileName: freezed == fileName
                ? _value.fileName
                : fileName // ignore: cast_nullable_to_non_nullable
                      as String?,
            timestamp: freezed == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            version: null == version
                ? _value.version
                : version // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BackupLogImplCopyWith<$Res>
    implements $BackupLogCopyWith<$Res> {
  factory _$$BackupLogImplCopyWith(
    _$BackupLogImpl value,
    $Res Function(_$BackupLogImpl) then,
  ) = __$$BackupLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String name,
    String type,
    int size,
    DateTime createdAt,
    DateTime updatedAt,
    String status,
    String storageLocation,
    String? cloudPath,
    String? localPath,
    String? error,
    @Deprecated('Use size instead') String? fileSize,
    @Deprecated('Use name instead') String? fileName,
    @Deprecated('Use createdAt instead') DateTime? timestamp,
    String version,
  });
}

/// @nodoc
class __$$BackupLogImplCopyWithImpl<$Res>
    extends _$BackupLogCopyWithImpl<$Res, _$BackupLogImpl>
    implements _$$BackupLogImplCopyWith<$Res> {
  __$$BackupLogImplCopyWithImpl(
    _$BackupLogImpl _value,
    $Res Function(_$BackupLogImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BackupLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? size = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? status = null,
    Object? storageLocation = null,
    Object? cloudPath = freezed,
    Object? localPath = freezed,
    Object? error = freezed,
    Object? fileSize = freezed,
    Object? fileName = freezed,
    Object? timestamp = freezed,
    Object? version = null,
  }) {
    return _then(
      _$BackupLogImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        size: null == size
            ? _value.size
            : size // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        storageLocation: null == storageLocation
            ? _value.storageLocation
            : storageLocation // ignore: cast_nullable_to_non_nullable
                  as String,
        cloudPath: freezed == cloudPath
            ? _value.cloudPath
            : cloudPath // ignore: cast_nullable_to_non_nullable
                  as String?,
        localPath: freezed == localPath
            ? _value.localPath
            : localPath // ignore: cast_nullable_to_non_nullable
                  as String?,
        error: freezed == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
        fileSize: freezed == fileSize
            ? _value.fileSize
            : fileSize // ignore: cast_nullable_to_non_nullable
                  as String?,
        fileName: freezed == fileName
            ? _value.fileName
            : fileName // ignore: cast_nullable_to_non_nullable
                  as String?,
        timestamp: freezed == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        version: null == version
            ? _value.version
            : version // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BackupLogImpl implements _BackupLog {
  const _$BackupLogImpl({
    @JsonKey(name: '_id') required this.id,
    required this.name,
    required this.type,
    this.size = 0,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    this.storageLocation = 'local',
    this.cloudPath,
    this.localPath,
    this.error,
    @Deprecated('Use size instead') this.fileSize,
    @Deprecated('Use name instead') this.fileName,
    @Deprecated('Use createdAt instead') this.timestamp,
    this.version = '1.0.0',
  });

  factory _$BackupLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$BackupLogImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String name;
  @override
  final String type;
  @override
  @JsonKey()
  final int size;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String status;
  @override
  @JsonKey()
  final String storageLocation;
  @override
  final String? cloudPath;
  @override
  final String? localPath;
  @override
  final String? error;
  @override
  @Deprecated('Use size instead')
  final String? fileSize;
  @override
  @Deprecated('Use name instead')
  final String? fileName;
  @override
  @Deprecated('Use createdAt instead')
  final DateTime? timestamp;
  @override
  @JsonKey()
  final String version;

  @override
  String toString() {
    return 'BackupLog(id: $id, name: $name, type: $type, size: $size, createdAt: $createdAt, updatedAt: $updatedAt, status: $status, storageLocation: $storageLocation, cloudPath: $cloudPath, localPath: $localPath, error: $error, fileSize: $fileSize, fileName: $fileName, timestamp: $timestamp, version: $version)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BackupLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.storageLocation, storageLocation) ||
                other.storageLocation == storageLocation) &&
            (identical(other.cloudPath, cloudPath) ||
                other.cloudPath == cloudPath) &&
            (identical(other.localPath, localPath) ||
                other.localPath == localPath) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.fileSize, fileSize) ||
                other.fileSize == fileSize) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.version, version) || other.version == version));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    type,
    size,
    createdAt,
    updatedAt,
    status,
    storageLocation,
    cloudPath,
    localPath,
    error,
    fileSize,
    fileName,
    timestamp,
    version,
  );

  /// Create a copy of BackupLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BackupLogImplCopyWith<_$BackupLogImpl> get copyWith =>
      __$$BackupLogImplCopyWithImpl<_$BackupLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BackupLogImplToJson(this);
  }
}

abstract class _BackupLog implements BackupLog {
  const factory _BackupLog({
    @JsonKey(name: '_id') required final String id,
    required final String name,
    required final String type,
    final int size,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    required final String status,
    final String storageLocation,
    final String? cloudPath,
    final String? localPath,
    final String? error,
    @Deprecated('Use size instead') final String? fileSize,
    @Deprecated('Use name instead') final String? fileName,
    @Deprecated('Use createdAt instead') final DateTime? timestamp,
    final String version,
  }) = _$BackupLogImpl;

  factory _BackupLog.fromJson(Map<String, dynamic> json) =
      _$BackupLogImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get name;
  @override
  String get type;
  @override
  int get size;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  String get status;
  @override
  String get storageLocation;
  @override
  String? get cloudPath;
  @override
  String? get localPath;
  @override
  String? get error;
  @override
  @Deprecated('Use size instead')
  String? get fileSize;
  @override
  @Deprecated('Use name instead')
  String? get fileName;
  @override
  @Deprecated('Use createdAt instead')
  DateTime? get timestamp;
  @override
  String get version;

  /// Create a copy of BackupLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BackupLogImplCopyWith<_$BackupLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AppOffer _$AppOfferFromJson(Map<String, dynamic> json) {
  return _AppOffer.fromJson(json);
}

/// @nodoc
mixin _$AppOffer {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'Title')
  String get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'Description')
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'DiscountValue')
  double get discountValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'DiscountType')
  String get discountType => throw _privateConstructorUsedError; // 'Percent' or 'Flat'
  @JsonKey(name: 'ValidFrom')
  DateTime get validFrom => throw _privateConstructorUsedError;
  @JsonKey(name: 'ValidTo')
  DateTime get validTo => throw _privateConstructorUsedError;
  @JsonKey(name: 'IsActive')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'BannerUrl')
  String? get bannerUrl => throw _privateConstructorUsedError;

  /// Serializes this AppOffer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppOffer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppOfferCopyWith<AppOffer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppOfferCopyWith<$Res> {
  factory $AppOfferCopyWith(AppOffer value, $Res Function(AppOffer) then) =
      _$AppOfferCopyWithImpl<$Res, AppOffer>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    @JsonKey(name: 'Title') String title,
    @JsonKey(name: 'Description') String? description,
    @JsonKey(name: 'DiscountValue') double discountValue,
    @JsonKey(name: 'DiscountType') String discountType,
    @JsonKey(name: 'ValidFrom') DateTime validFrom,
    @JsonKey(name: 'ValidTo') DateTime validTo,
    @JsonKey(name: 'IsActive') bool isActive,
    @JsonKey(name: 'BannerUrl') String? bannerUrl,
  });
}

/// @nodoc
class _$AppOfferCopyWithImpl<$Res, $Val extends AppOffer>
    implements $AppOfferCopyWith<$Res> {
  _$AppOfferCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppOffer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? discountValue = null,
    Object? discountType = null,
    Object? validFrom = null,
    Object? validTo = null,
    Object? isActive = null,
    Object? bannerUrl = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            discountValue: null == discountValue
                ? _value.discountValue
                : discountValue // ignore: cast_nullable_to_non_nullable
                      as double,
            discountType: null == discountType
                ? _value.discountType
                : discountType // ignore: cast_nullable_to_non_nullable
                      as String,
            validFrom: null == validFrom
                ? _value.validFrom
                : validFrom // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            validTo: null == validTo
                ? _value.validTo
                : validTo // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            bannerUrl: freezed == bannerUrl
                ? _value.bannerUrl
                : bannerUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppOfferImplCopyWith<$Res>
    implements $AppOfferCopyWith<$Res> {
  factory _$$AppOfferImplCopyWith(
    _$AppOfferImpl value,
    $Res Function(_$AppOfferImpl) then,
  ) = __$$AppOfferImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    @JsonKey(name: 'Title') String title,
    @JsonKey(name: 'Description') String? description,
    @JsonKey(name: 'DiscountValue') double discountValue,
    @JsonKey(name: 'DiscountType') String discountType,
    @JsonKey(name: 'ValidFrom') DateTime validFrom,
    @JsonKey(name: 'ValidTo') DateTime validTo,
    @JsonKey(name: 'IsActive') bool isActive,
    @JsonKey(name: 'BannerUrl') String? bannerUrl,
  });
}

/// @nodoc
class __$$AppOfferImplCopyWithImpl<$Res>
    extends _$AppOfferCopyWithImpl<$Res, _$AppOfferImpl>
    implements _$$AppOfferImplCopyWith<$Res> {
  __$$AppOfferImplCopyWithImpl(
    _$AppOfferImpl _value,
    $Res Function(_$AppOfferImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppOffer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? discountValue = null,
    Object? discountType = null,
    Object? validFrom = null,
    Object? validTo = null,
    Object? isActive = null,
    Object? bannerUrl = freezed,
  }) {
    return _then(
      _$AppOfferImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        discountValue: null == discountValue
            ? _value.discountValue
            : discountValue // ignore: cast_nullable_to_non_nullable
                  as double,
        discountType: null == discountType
            ? _value.discountType
            : discountType // ignore: cast_nullable_to_non_nullable
                  as String,
        validFrom: null == validFrom
            ? _value.validFrom
            : validFrom // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        validTo: null == validTo
            ? _value.validTo
            : validTo // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        bannerUrl: freezed == bannerUrl
            ? _value.bannerUrl
            : bannerUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppOfferImpl implements _AppOffer {
  const _$AppOfferImpl({
    @JsonKey(name: '_id') required this.id,
    @JsonKey(name: 'Title') required this.title,
    @JsonKey(name: 'Description') this.description,
    @JsonKey(name: 'DiscountValue') required this.discountValue,
    @JsonKey(name: 'DiscountType') required this.discountType,
    @JsonKey(name: 'ValidFrom') required this.validFrom,
    @JsonKey(name: 'ValidTo') required this.validTo,
    @JsonKey(name: 'IsActive') this.isActive = true,
    @JsonKey(name: 'BannerUrl') this.bannerUrl,
  });

  factory _$AppOfferImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppOfferImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  @JsonKey(name: 'Title')
  final String title;
  @override
  @JsonKey(name: 'Description')
  final String? description;
  @override
  @JsonKey(name: 'DiscountValue')
  final double discountValue;
  @override
  @JsonKey(name: 'DiscountType')
  final String discountType;
  // 'Percent' or 'Flat'
  @override
  @JsonKey(name: 'ValidFrom')
  final DateTime validFrom;
  @override
  @JsonKey(name: 'ValidTo')
  final DateTime validTo;
  @override
  @JsonKey(name: 'IsActive')
  final bool isActive;
  @override
  @JsonKey(name: 'BannerUrl')
  final String? bannerUrl;

  @override
  String toString() {
    return 'AppOffer(id: $id, title: $title, description: $description, discountValue: $discountValue, discountType: $discountType, validFrom: $validFrom, validTo: $validTo, isActive: $isActive, bannerUrl: $bannerUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppOfferImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.discountValue, discountValue) ||
                other.discountValue == discountValue) &&
            (identical(other.discountType, discountType) ||
                other.discountType == discountType) &&
            (identical(other.validFrom, validFrom) ||
                other.validFrom == validFrom) &&
            (identical(other.validTo, validTo) || other.validTo == validTo) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.bannerUrl, bannerUrl) ||
                other.bannerUrl == bannerUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    discountValue,
    discountType,
    validFrom,
    validTo,
    isActive,
    bannerUrl,
  );

  /// Create a copy of AppOffer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppOfferImplCopyWith<_$AppOfferImpl> get copyWith =>
      __$$AppOfferImplCopyWithImpl<_$AppOfferImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppOfferImplToJson(this);
  }
}

abstract class _AppOffer implements AppOffer {
  const factory _AppOffer({
    @JsonKey(name: '_id') required final String id,
    @JsonKey(name: 'Title') required final String title,
    @JsonKey(name: 'Description') final String? description,
    @JsonKey(name: 'DiscountValue') required final double discountValue,
    @JsonKey(name: 'DiscountType') required final String discountType,
    @JsonKey(name: 'ValidFrom') required final DateTime validFrom,
    @JsonKey(name: 'ValidTo') required final DateTime validTo,
    @JsonKey(name: 'IsActive') final bool isActive,
    @JsonKey(name: 'BannerUrl') final String? bannerUrl,
  }) = _$AppOfferImpl;

  factory _AppOffer.fromJson(Map<String, dynamic> json) =
      _$AppOfferImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  @JsonKey(name: 'Title')
  String get title;
  @override
  @JsonKey(name: 'Description')
  String? get description;
  @override
  @JsonKey(name: 'DiscountValue')
  double get discountValue;
  @override
  @JsonKey(name: 'DiscountType')
  String get discountType; // 'Percent' or 'Flat'
  @override
  @JsonKey(name: 'ValidFrom')
  DateTime get validFrom;
  @override
  @JsonKey(name: 'ValidTo')
  DateTime get validTo;
  @override
  @JsonKey(name: 'IsActive')
  bool get isActive;
  @override
  @JsonKey(name: 'BannerUrl')
  String? get bannerUrl;

  /// Create a copy of AppOffer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppOfferImplCopyWith<_$AppOfferImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

KeyBinding _$KeyBindingFromJson(Map<String, dynamic> json) {
  return _KeyBinding.fromJson(json);
}

/// @nodoc
mixin _$KeyBinding {
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;
  String get action => throw _privateConstructorUsedError;
  String get keyCombination => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // 'Enabled' or 'Disabled'
  String? get module => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;

  /// Serializes this KeyBinding to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KeyBinding
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KeyBindingCopyWith<KeyBinding> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KeyBindingCopyWith<$Res> {
  factory $KeyBindingCopyWith(
    KeyBinding value,
    $Res Function(KeyBinding) then,
  ) = _$KeyBindingCopyWithImpl<$Res, KeyBinding>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    String action,
    String keyCombination,
    String status,
    String? module,
    String? description,
    String? url,
  });
}

/// @nodoc
class _$KeyBindingCopyWithImpl<$Res, $Val extends KeyBinding>
    implements $KeyBindingCopyWith<$Res> {
  _$KeyBindingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KeyBinding
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? action = null,
    Object? keyCombination = null,
    Object? status = null,
    Object? module = freezed,
    Object? description = freezed,
    Object? url = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            action: null == action
                ? _value.action
                : action // ignore: cast_nullable_to_non_nullable
                      as String,
            keyCombination: null == keyCombination
                ? _value.keyCombination
                : keyCombination // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            module: freezed == module
                ? _value.module
                : module // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            url: freezed == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$KeyBindingImplCopyWith<$Res>
    implements $KeyBindingCopyWith<$Res> {
  factory _$$KeyBindingImplCopyWith(
    _$KeyBindingImpl value,
    $Res Function(_$KeyBindingImpl) then,
  ) = __$$KeyBindingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    String action,
    String keyCombination,
    String status,
    String? module,
    String? description,
    String? url,
  });
}

/// @nodoc
class __$$KeyBindingImplCopyWithImpl<$Res>
    extends _$KeyBindingCopyWithImpl<$Res, _$KeyBindingImpl>
    implements _$$KeyBindingImplCopyWith<$Res> {
  __$$KeyBindingImplCopyWithImpl(
    _$KeyBindingImpl _value,
    $Res Function(_$KeyBindingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of KeyBinding
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? action = null,
    Object? keyCombination = null,
    Object? status = null,
    Object? module = freezed,
    Object? description = freezed,
    Object? url = freezed,
  }) {
    return _then(
      _$KeyBindingImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        action: null == action
            ? _value.action
            : action // ignore: cast_nullable_to_non_nullable
                  as String,
        keyCombination: null == keyCombination
            ? _value.keyCombination
            : keyCombination // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        module: freezed == module
            ? _value.module
            : module // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        url: freezed == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$KeyBindingImpl implements _KeyBinding {
  const _$KeyBindingImpl({
    @JsonKey(name: '_id') this.id,
    required this.action,
    required this.keyCombination,
    this.status = 'Enabled',
    this.module,
    this.description,
    this.url,
  });

  factory _$KeyBindingImpl.fromJson(Map<String, dynamic> json) =>
      _$$KeyBindingImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String? id;
  @override
  final String action;
  @override
  final String keyCombination;
  @override
  @JsonKey()
  final String status;
  // 'Enabled' or 'Disabled'
  @override
  final String? module;
  @override
  final String? description;
  @override
  final String? url;

  @override
  String toString() {
    return 'KeyBinding(id: $id, action: $action, keyCombination: $keyCombination, status: $status, module: $module, description: $description, url: $url)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KeyBindingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.keyCombination, keyCombination) ||
                other.keyCombination == keyCombination) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.module, module) || other.module == module) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    action,
    keyCombination,
    status,
    module,
    description,
    url,
  );

  /// Create a copy of KeyBinding
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KeyBindingImplCopyWith<_$KeyBindingImpl> get copyWith =>
      __$$KeyBindingImplCopyWithImpl<_$KeyBindingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KeyBindingImplToJson(this);
  }
}

abstract class _KeyBinding implements KeyBinding {
  const factory _KeyBinding({
    @JsonKey(name: '_id') final String? id,
    required final String action,
    required final String keyCombination,
    final String status,
    final String? module,
    final String? description,
    final String? url,
  }) = _$KeyBindingImpl;

  factory _KeyBinding.fromJson(Map<String, dynamic> json) =
      _$KeyBindingImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String? get id;
  @override
  String get action;
  @override
  String get keyCombination;
  @override
  String get status; // 'Enabled' or 'Disabled'
  @override
  String? get module;
  @override
  String? get description;
  @override
  String? get url;

  /// Create a copy of KeyBinding
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KeyBindingImplCopyWith<_$KeyBindingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
