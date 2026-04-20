// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../inventory/data/models/lens_location_model.dart';

part 'lens_group_model.freezed.dart';
part 'lens_group_model.g.dart';

String _parseString(dynamic value) => value?.toString() ?? '';

List<LensPowerGroup> _parsePowerGroups(dynamic json) =>
    (json is List) ? json.map((e) => LensPowerGroup.fromJson(e as Map<String, dynamic>)).toList() : [];

List<LensAddGroup> _parseAddGroups(dynamic json) =>
    (json is List) ? json.map((e) => LensAddGroup.fromJson(e as Map<String, dynamic>)).toList() : [];

List<LensCombination> _parseCombinations(dynamic json) =>
    (json is List) ? json.map((e) => LensCombination.fromJson(e as Map<String, dynamic>)).toList() : [];

List<LensLocationModel> _parseLocations(dynamic json) =>
    (json is List) ? json.map((e) => LensLocationModel.fromJson(e as Map<String, dynamic>)).toList() : [];


@freezed
class LensGroupModel with _$LensGroupModel {
  const factory LensGroupModel({
    @JsonKey(name: '_id') String? id,
    @Default('') String groupName,
    @Default('') String productName,
    @Default('') String vendorItemName,
    @Default('') String billItemName,
    @JsonKey(fromJson: _parseString) String? sphMin,
    @JsonKey(fromJson: _parseString) String? sphMax,
    @JsonKey(fromJson: _parseString) @Default('0.25') String sphStep,
    @JsonKey(fromJson: _parseString) String? cylMin,
    @JsonKey(fromJson: _parseString) String? cylMax,
    @JsonKey(fromJson: _parseString) @Default('0.25') String cylStep,
    @JsonKey(fromJson: _parseString) String? addMin,
    @JsonKey(fromJson: _parseString) String? addMax,
    @JsonKey(fromJson: _parseString) @Default('0.25') String addStep,
    @JsonKey(fromJson: _parseString) @Default('') String axis,
    @JsonKey(fromJson: _parseString) @Default('') String eye,
    @JsonKey(fromJson: _parsePowerGroups) @Default([]) List<LensPowerGroup> powerGroups,
    @JsonKey(fromJson: _parseAddGroups) @Default([]) List<LensAddGroup> addGroups,
    Map<String, dynamic>? salePrice,
    String? createdAt,
    String? updatedAt,
  }) = _LensGroupModel;

  factory LensGroupModel.fromJson(Map<String, dynamic> json) =>
      _$LensGroupModelFromJson(json);
}

@freezed
class LensPowerGroup with _$LensPowerGroup {
  const factory LensPowerGroup({
    String? id,
    @JsonKey(fromJson: _parseString) String? label,
    @JsonKey(fromJson: _parseString) String? sphMin,
    @JsonKey(fromJson: _parseString) String? sphMax,
    @JsonKey(fromJson: _parseString) @Default('0.25') String sphStep,
    @JsonKey(fromJson: _parseString) String? cylMin,
    @JsonKey(fromJson: _parseString) String? cylMax,
    @JsonKey(fromJson: _parseString) @Default('0.25') String cylStep,
    @JsonKey(fromJson: _parseString) String? addMin,
    @JsonKey(fromJson: _parseString) String? addMax,
    @JsonKey(fromJson: _parseString) @Default('0.25') String addStep,
    @JsonKey(fromJson: _parseString) String? axis,
    @JsonKey(fromJson: _parseString) String? eye,
  }) = _LensPowerGroup;

  factory LensPowerGroup.fromJson(Map<String, dynamic> json) =>
      _$LensPowerGroupFromJson(json);
}

@freezed
class LensAddGroup with _$LensAddGroup {
  const factory LensAddGroup({
    String? id,
    String? name,
    String? label,
    @JsonKey(name: 'addValue', fromJson: _parseString) String? addValue,
    @JsonKey(fromJson: _parseCombinations) @Default([]) List<LensCombination> combinations,
  }) = _LensAddGroup;

  factory LensAddGroup.fromJson(Map<String, dynamic> json) =>
      _$LensAddGroupFromJson(json);
}

@freezed
class LensCombination with _$LensCombination {
  const factory LensCombination({
    String? id,
    @JsonKey(fromJson: _parseString) @Default('') String sph,
    @JsonKey(fromJson: _parseString) @Default('') String cyl,
    @JsonKey(fromJson: _parseString) @Default('') String add,
    @JsonKey(fromJson: _parseString) @Default('') String axis,
    @JsonKey(fromJson: _parseString) @Default('') String eye,
    @JsonKey(fromJson: _parseString) @Default('') String barcode,
    @JsonKey(fromJson: _parseString) @Default('') String boxNo,
    @Default(0) int alertQty,
    @Default(0.0) double pPrice,
    @Default(0.0) double sPrice,
    @Default(0) int initStock,
    @JsonKey(fromJson: _parseLocations) @Default([]) List<LensLocationModel> locations,
    @JsonKey(fromJson: _parseString) @Default('') String locationQty,
  }) = _LensCombination;

  factory LensCombination.fromJson(Map<String, dynamic> json) =>
      _$LensCombinationFromJson(json);
}
