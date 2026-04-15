// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'damage_entry_model.freezed.dart';
part 'damage_entry_model.g.dart';

@freezed
class DamageEntryModel with _$DamageEntryModel {
  const factory DamageEntryModel({
    @JsonKey(name: '_id') String? id,
    @Default('DMG') String billSeries,
    @Default('') String billNo,
    String? date,
    @Default('Damage') String type,
    @Default('HO') String godown,
    @Default('') String remark,
    @Default([]) List<DamageItemModel> items,
    @Default(0) int totalQty,
    @Default(0.0) double totalAmt,
    String? companyId,
    String? createdAt,
    String? updatedAt,
  }) = _DamageEntryModel;

  factory DamageEntryModel.fromJson(Map<String, dynamic> json) =>
      _$DamageEntryModelFromJson(json);
}

@freezed
class DamageItemModel with _$DamageItemModel {
  const factory DamageItemModel({
    @JsonKey(name: '_id') String? id,
    @Default('') String code,
    @Default('') String itemName,
    @Default('') String partyName,
    @Default('') String orderNo,
    @Default('') String eye,
    @Default(0.0) double sph,
    @Default(0.0) double cyl,
    @Default(0.0) double axis,
    @Default(0.0) double add,
    @Default(0) int qty,
    @Default(0.0) double price,
    @Default(0.0) double totalAmt,
    @Default('') String combinationId,
  }) = _DamageItemModel;

  factory DamageItemModel.fromJson(Map<String, dynamic> json) =>
      _$DamageItemModelFromJson(json);
}
