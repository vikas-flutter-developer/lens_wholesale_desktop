// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_master_model.freezed.dart';
part 'item_master_model.g.dart';

String _parseString(dynamic value) => value?.toString() ?? '';

@freezed
class ItemMasterModel with _$ItemMasterModel {
  const factory ItemMasterModel({
    @JsonKey(name: '_id') String? id,
    @Default('') String itemName,
    @Default('') String billItemName,
    @Default('') String alias,
    @Default('') String printName,
    @Default('') String groupName,
    @Default('') String unit,
    @Default('') String allUnit, // React uses allUnit for altUnit
    @Default('') String description,
    @Default('N') String taxSetting, // 'N' for No, 'Y' for Yes
    double? openingStock,
    double? openingStockValue,
    double? purchasePrice,
    double? saleProfit,
    double? salePrice,
    double? mrpPrice,
    double? saleDiscount,
    double? purchaseDiscount,
    double? minSalePrice,
    @JsonKey(fromJson: _parseString) @Default('') String hsnCode,
    @JsonKey(fromJson: _parseString) @Default('') String barcode,
    @Default('') String stockable,
    @Default('') String godown,
    @JsonKey(fromJson: _parseString) @Default('') String loyaltyPoints,
    @JsonKey(fromJson: _parseString) @Default('') String refAmn,
    @JsonKey(fromJson: _parseString) @Default('') String refAmntIndia,
    @Default(false) bool forLensProduct,
    @JsonKey(fromJson: _parseString) @Default('') String sellStockLevel,
    @Default('') String batchWiseDetails,
    @Default('') String taxCategory,
    @JsonKey(fromJson: _parseString) String? createdAt,
    @JsonKey(fromJson: _parseString) String? updatedAt,
  }) = _ItemMasterModel;

  factory ItemMasterModel.fromJson(Map<String, dynamic> json) =>
      _$ItemMasterModelFromJson(json);
}
