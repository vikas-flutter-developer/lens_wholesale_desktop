// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'barcode_model.freezed.dart';
part 'barcode_model.g.dart';

@freezed
class BarcodeModel with _$BarcodeModel {
  const factory BarcodeModel({
    @JsonKey(name: '_id') String? id,
    @JsonKey(name: 'companyId') String? companyId,
    required String barcode,
    required String productId,
    @Default(0) double sph,
    @Default(0) double cyl,
    @Default(0) double axis,
    @Default(0) double add,
    @Default({}) Map<String, dynamic> metadata,
    String? createdAt,
    String? updatedAt,
  }) = _BarcodeModel;

  factory BarcodeModel.fromJson(Map<String, dynamic> json) =>
      _$BarcodeModelFromJson(json);
}
