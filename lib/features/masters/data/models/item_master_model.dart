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
    @Default('') String vendorItemName,
    @Default('') String billItemName,
    @Default('') String alias,
    @Default('') String printName,
    @Default('') String groupName,
    @Default('') String unit,
    @JsonKey(name: 'altUnit') @Default('') String allUnit, // backend uses altUnit
    @Default('') String description,
    @Default('N') String taxSetting, // 'N' for No, 'Y' for Yes
    @JsonKey(name: 'openingStockQty') double? openingStock, // backend uses openingStockQty
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
    @Default(false) bool stockable,
    @Default('') String godown,
    double? loyaltyPoints, // backend: Number
    double? refAmn, // backend: Number
    double? refAmntIndia, // backend: Number
    @Default(false) bool forLensProduct,
    @JsonKey(fromJson: _parseString) @Default('') String sellStockLevel,
    @Default('') String batchWiseDetails,
    @JsonKey(name: 'TaxCategory') @Default('') String taxCategory, // backend: TaxCategory
    @JsonKey(fromJson: _parseString) String? createdAt,
    @JsonKey(fromJson: _parseString) String? updatedAt,
  }) = _ItemMasterModel;

  factory ItemMasterModel.fromJson(Map<String, dynamic> json) =>
      _$ItemMasterModelFromJson(json);
}
