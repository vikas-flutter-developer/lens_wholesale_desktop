import 'package:freezed_annotation/freezed_annotation.dart';

part 'power_range_library_model.freezed.dart';
part 'power_range_library_model.g.dart';

@freezed
class PowerRangeLibraryModel with _$PowerRangeLibraryModel {
  const factory PowerRangeLibraryModel({
    @JsonKey(name: '_id') String? id,
    @Default(0.0) double sphMin,
    @Default(0.0) double sphMax,
    @Default(0.25) double sphStep,
    @Default(0.0) double cylMin,
    @Default(0.0) double cylMax,
    @Default(0.25) double cylStep,
    @Default(0.0) double addMin,
    @Default(0.0) double addMax,
    @Default(0.25) double addStep,
    @Default('') String label,
    @Default([]) List<String> groupNames,
    String? createdAt,
    String? updatedAt,
  }) = _PowerRangeLibraryModel;

  factory PowerRangeLibraryModel.fromJson(Map<String, dynamic> json) =>
      _$PowerRangeLibraryModelFromJson(json);
}
