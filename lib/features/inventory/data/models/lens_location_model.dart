import 'package:freezed_annotation/freezed_annotation.dart';

part 'lens_location_model.freezed.dart';
part 'lens_location_model.g.dart';

String _parseString(dynamic value) => value?.toString() ?? '';

@freezed
class LensLocationModel with _$LensLocationModel {
  const factory LensLocationModel({
    @JsonKey(fromJson: _parseString) @Default('-') String godown,
    @JsonKey(fromJson: _parseString) @Default('-') String rack,
    @JsonKey(fromJson: _parseString) @Default('-') String box,
  }) = _LensLocationModel;

  factory LensLocationModel.fromJson(Map<String, dynamic> json) =>
      _$LensLocationModelFromJson(json);
}
