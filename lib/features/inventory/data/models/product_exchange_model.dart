// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_exchange_model.freezed.dart';
part 'product_exchange_model.g.dart';

@freezed
class ProductExchangeModel with _$ProductExchangeModel {
  const factory ProductExchangeModel({
    @JsonKey(name: '_id') String? id,
    @Default(ExchangeBillData()) ExchangeBillData billData,
    @Default(ExchangePartyData()) ExchangePartyData partyData,
    @Default([]) List<ExchangeItemModel> exchangeOutItems,
    @Default([]) List<ExchangeItemModel> exchangeInItems,
    @Default(ExchangeTotals()) ExchangeTotals totals,
    @Default('') String remarks,
    @Default('Completed') String status,
    String? createdAt,
    String? updatedAt,
  }) = _ProductExchangeModel;

  factory ProductExchangeModel.fromJson(Map<String, dynamic> json) =>
      _$ProductExchangeModelFromJson(json);
}

@freezed
class ExchangeBillData with _$ExchangeBillData {
  const factory ExchangeBillData({
    @Default('Exchange') String billSeries,
    @Default('') String billNo,
    String? date,
    @Default('Lens') String type,
    @Default('MT-1') String godown,
    @Default('') String bookedBy,
  }) = _ExchangeBillData;

  factory ExchangeBillData.fromJson(Map<String, dynamic> json) =>
      _$ExchangeBillDataFromJson(json);
}

@freezed
class ExchangePartyData with _$ExchangePartyData {
  const factory ExchangePartyData({
    @Default('') String partyAccount,
    @Default('') String address,
    @Default('') String contactNumber,
  }) = _ExchangePartyData;

  factory ExchangePartyData.fromJson(Map<String, dynamic> json) =>
      _$ExchangePartyDataFromJson(json);
}

@freezed
class ExchangeItemModel with _$ExchangeItemModel {
  const factory ExchangeItemModel({
    @JsonKey(name: '_id') String? id,
    @Default('') String code,
    @Default('') String itemName,
    @Default('') String unit,
    @Default('') String dia,
    @Default('') String eye,
    @Default(0.0) double sph,
    @Default(0.0) double cyl,
    @Default(0.0) double axis,
    @Default(0.0) double add,
    @Default('') String remark,
    @Default(0) int qty,
    @Default(0.0) double price,
    @Default(0.0) double totalAmount,
  }) = _ExchangeItemModel;

  factory ExchangeItemModel.fromJson(Map<String, dynamic> json) =>
      _$ExchangeItemModelFromJson(json);
}

@freezed
class ExchangeTotals with _$ExchangeTotals {
  const factory ExchangeTotals({
    @Default(0) int totalExchInQty,
    @Default(0.0) double totalExchInAmnt,
    @Default(0) int totalExchOutQty,
    @Default(0.0) double totalExchOutAmnt,
  }) = _ExchangeTotals;

  factory ExchangeTotals.fromJson(Map<String, dynamic> json) =>
      _$ExchangeTotalsFromJson(json);
}
