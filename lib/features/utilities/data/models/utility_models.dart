import 'package:freezed_annotation/freezed_annotation.dart';

part 'utility_models.freezed.dart';
part 'utility_models.g.dart';

@freezed
class BackupLog with _$BackupLog {
  const factory BackupLog({
    @JsonKey(name: '_id') required String id,
    required String name,
    required String type,
    @Default(0) int size,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String status,
    @Default('local') String storageLocation,
    String? cloudPath,
    String? localPath,
    String? error,
    @Deprecated('Use size instead') String? fileSize,
    @Deprecated('Use name instead') String? fileName,
    @Deprecated('Use createdAt instead') DateTime? timestamp,
    @Default('1.0.0') String version,
  }) = _BackupLog;


  factory BackupLog.fromJson(Map<String, dynamic> json) => _$BackupLogFromJson(json);
}

@freezed
class AppOffer with _$AppOffer {
  const factory AppOffer({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'Title') required String title,
    @JsonKey(name: 'Description') String? description,
    @JsonKey(name: 'DiscountValue') required double discountValue,
    @JsonKey(name: 'DiscountType') required String discountType, // 'Percent' or 'Flat'
    @JsonKey(name: 'ValidFrom') required DateTime validFrom,
    @JsonKey(name: 'ValidTo') required DateTime validTo,
    @JsonKey(name: 'IsActive') @Default(true) bool isActive,
    @JsonKey(name: 'BannerUrl') String? bannerUrl,
  }) = _AppOffer;

  factory AppOffer.fromJson(Map<String, dynamic> json) => _$AppOfferFromJson(json);
}

@freezed
class KeyBinding with _$KeyBinding {
  const factory KeyBinding({
    @JsonKey(name: '_id') String? id,
    required String action,
    required String keyCombination,
    @Default('Enabled') String status, // 'Enabled' or 'Disabled'
    String? module,
    String? description,
    String? url,
  }) = _KeyBinding;

  factory KeyBinding.fromJson(Map<String, dynamic> json) => _$KeyBindingFromJson(json);
}
