// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_group_model.freezed.dart';
part 'item_group_model.g.dart';

String _parseString(dynamic value) => value?.toString() ?? '';

@freezed
class ItemGroupModel with _$ItemGroupModel {
  const factory ItemGroupModel({
    @JsonKey(name: '_id') String? id,
    @Default('') String groupName,
    String? date,
    double? saleDiscount,
    @Default(false) bool saleDiscountApplyAll,
    double? purchaseDiscount,
    @JsonKey(fromJson: _parseString) String? hsnCode,
    @Default(false) bool hsnApplyAll,
    int? loyaltyPoint,
    @Default(false) bool loyaltyApplyAll,
    @JsonKey(fromJson: _parseString) String? textCategory1,
    @Default(false) bool textCategory1ApplyAll,
    @JsonKey(fromJson: _parseString) String? codeg1Limit,
    @JsonKey(fromJson: _parseString) String? taxCategory2,
    @Default(false) bool alertNegativeQty,
    @Default(false) bool restrictNegativeQty,
    @Default(true) bool canDelete,
    @JsonKey(fromJson: _parseString) String? createdAt,
    @JsonKey(fromJson: _parseString) String? updatedAt,
  }) = _ItemGroupModel;

  factory ItemGroupModel.fromJson(Map<String, dynamic> json) =>
      _$ItemGroupModelFromJson(json);
}
