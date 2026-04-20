// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'item_master_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ItemMasterModel _$ItemMasterModelFromJson(Map<String, dynamic> json) {
  return _ItemMasterModel.fromJson(json);
}

/// @nodoc
mixin _$ItemMasterModel {
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;
  String get itemName => throw _privateConstructorUsedError;
  String get vendorItemName => throw _privateConstructorUsedError;
  String get billItemName => throw _privateConstructorUsedError;
  String get alias => throw _privateConstructorUsedError;
  String get printName => throw _privateConstructorUsedError;
  String get groupName => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  @JsonKey(name: 'altUnit')
  String get allUnit => throw _privateConstructorUsedError; // backend uses altUnit
  String get description => throw _privateConstructorUsedError;
  String get taxSetting =>
      throw _privateConstructorUsedError; // 'N' for No, 'Y' for Yes
  @JsonKey(name: 'openingStockQty')
  double? get openingStock => throw _privateConstructorUsedError; // backend uses openingStockQty
  double? get openingStockValue => throw _privateConstructorUsedError;
  double? get purchasePrice => throw _privateConstructorUsedError;
  double? get saleProfit => throw _privateConstructorUsedError;
  double? get salePrice => throw _privateConstructorUsedError;
  double? get mrpPrice => throw _privateConstructorUsedError;
  double? get saleDiscount => throw _privateConstructorUsedError;
  double? get purchaseDiscount => throw _privateConstructorUsedError;
  double? get minSalePrice => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String get hsnCode => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String get barcode => throw _privateConstructorUsedError;
  bool get stockable => throw _privateConstructorUsedError;
  String get godown => throw _privateConstructorUsedError;
  double? get loyaltyPoints =>
      throw _privateConstructorUsedError; // backend: Number
  double? get refAmn => throw _privateConstructorUsedError; // backend: Number
  double? get refAmntIndia =>
      throw _privateConstructorUsedError; // backend: Number
  bool get forLensProduct => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String get sellStockLevel => throw _privateConstructorUsedError;
  String get batchWiseDetails => throw _privateConstructorUsedError;
  @JsonKey(name: 'TaxCategory')
  String get taxCategory => throw _privateConstructorUsedError; // backend: TaxCategory
  @JsonKey(fromJson: _parseString)
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ItemMasterModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ItemMasterModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ItemMasterModelCopyWith<ItemMasterModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItemMasterModelCopyWith<$Res> {
  factory $ItemMasterModelCopyWith(
    ItemMasterModel value,
    $Res Function(ItemMasterModel) then,
  ) = _$ItemMasterModelCopyWithImpl<$Res, ItemMasterModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    String itemName,
    String vendorItemName,
    String billItemName,
    String alias,
    String printName,
    String groupName,
    String unit,
    @JsonKey(name: 'altUnit') String allUnit,
    String description,
    String taxSetting,
    @JsonKey(name: 'openingStockQty') double? openingStock,
    double? openingStockValue,
    double? purchasePrice,
    double? saleProfit,
    double? salePrice,
    double? mrpPrice,
    double? saleDiscount,
    double? purchaseDiscount,
    double? minSalePrice,
    @JsonKey(fromJson: _parseString) String hsnCode,
    @JsonKey(fromJson: _parseString) String barcode,
    bool stockable,
    String godown,
    double? loyaltyPoints,
    double? refAmn,
    double? refAmntIndia,
    bool forLensProduct,
    @JsonKey(fromJson: _parseString) String sellStockLevel,
    String batchWiseDetails,
    @JsonKey(name: 'TaxCategory') String taxCategory,
    @JsonKey(fromJson: _parseString) String? createdAt,
    @JsonKey(fromJson: _parseString) String? updatedAt,
  });
}

/// @nodoc
class _$ItemMasterModelCopyWithImpl<$Res, $Val extends ItemMasterModel>
    implements $ItemMasterModelCopyWith<$Res> {
  _$ItemMasterModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ItemMasterModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? itemName = null,
    Object? vendorItemName = null,
    Object? billItemName = null,
    Object? alias = null,
    Object? printName = null,
    Object? groupName = null,
    Object? unit = null,
    Object? allUnit = null,
    Object? description = null,
    Object? taxSetting = null,
    Object? openingStock = freezed,
    Object? openingStockValue = freezed,
    Object? purchasePrice = freezed,
    Object? saleProfit = freezed,
    Object? salePrice = freezed,
    Object? mrpPrice = freezed,
    Object? saleDiscount = freezed,
    Object? purchaseDiscount = freezed,
    Object? minSalePrice = freezed,
    Object? hsnCode = null,
    Object? barcode = null,
    Object? stockable = null,
    Object? godown = null,
    Object? loyaltyPoints = freezed,
    Object? refAmn = freezed,
    Object? refAmntIndia = freezed,
    Object? forLensProduct = null,
    Object? sellStockLevel = null,
    Object? batchWiseDetails = null,
    Object? taxCategory = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            itemName: null == itemName
                ? _value.itemName
                : itemName // ignore: cast_nullable_to_non_nullable
                      as String,
            vendorItemName: null == vendorItemName
                ? _value.vendorItemName
                : vendorItemName // ignore: cast_nullable_to_non_nullable
                      as String,
            billItemName: null == billItemName
                ? _value.billItemName
                : billItemName // ignore: cast_nullable_to_non_nullable
                      as String,
            alias: null == alias
                ? _value.alias
                : alias // ignore: cast_nullable_to_non_nullable
                      as String,
            printName: null == printName
                ? _value.printName
                : printName // ignore: cast_nullable_to_non_nullable
                      as String,
            groupName: null == groupName
                ? _value.groupName
                : groupName // ignore: cast_nullable_to_non_nullable
                      as String,
            unit: null == unit
                ? _value.unit
                : unit // ignore: cast_nullable_to_non_nullable
                      as String,
            allUnit: null == allUnit
                ? _value.allUnit
                : allUnit // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            taxSetting: null == taxSetting
                ? _value.taxSetting
                : taxSetting // ignore: cast_nullable_to_non_nullable
                      as String,
            openingStock: freezed == openingStock
                ? _value.openingStock
                : openingStock // ignore: cast_nullable_to_non_nullable
                      as double?,
            openingStockValue: freezed == openingStockValue
                ? _value.openingStockValue
                : openingStockValue // ignore: cast_nullable_to_non_nullable
                      as double?,
            purchasePrice: freezed == purchasePrice
                ? _value.purchasePrice
                : purchasePrice // ignore: cast_nullable_to_non_nullable
                      as double?,
            saleProfit: freezed == saleProfit
                ? _value.saleProfit
                : saleProfit // ignore: cast_nullable_to_non_nullable
                      as double?,
            salePrice: freezed == salePrice
                ? _value.salePrice
                : salePrice // ignore: cast_nullable_to_non_nullable
                      as double?,
            mrpPrice: freezed == mrpPrice
                ? _value.mrpPrice
                : mrpPrice // ignore: cast_nullable_to_non_nullable
                      as double?,
            saleDiscount: freezed == saleDiscount
                ? _value.saleDiscount
                : saleDiscount // ignore: cast_nullable_to_non_nullable
                      as double?,
            purchaseDiscount: freezed == purchaseDiscount
                ? _value.purchaseDiscount
                : purchaseDiscount // ignore: cast_nullable_to_non_nullable
                      as double?,
            minSalePrice: freezed == minSalePrice
                ? _value.minSalePrice
                : minSalePrice // ignore: cast_nullable_to_non_nullable
                      as double?,
            hsnCode: null == hsnCode
                ? _value.hsnCode
                : hsnCode // ignore: cast_nullable_to_non_nullable
                      as String,
            barcode: null == barcode
                ? _value.barcode
                : barcode // ignore: cast_nullable_to_non_nullable
                      as String,
            stockable: null == stockable
                ? _value.stockable
                : stockable // ignore: cast_nullable_to_non_nullable
                      as bool,
            godown: null == godown
                ? _value.godown
                : godown // ignore: cast_nullable_to_non_nullable
                      as String,
            loyaltyPoints: freezed == loyaltyPoints
                ? _value.loyaltyPoints
                : loyaltyPoints // ignore: cast_nullable_to_non_nullable
                      as double?,
            refAmn: freezed == refAmn
                ? _value.refAmn
                : refAmn // ignore: cast_nullable_to_non_nullable
                      as double?,
            refAmntIndia: freezed == refAmntIndia
                ? _value.refAmntIndia
                : refAmntIndia // ignore: cast_nullable_to_non_nullable
                      as double?,
            forLensProduct: null == forLensProduct
                ? _value.forLensProduct
                : forLensProduct // ignore: cast_nullable_to_non_nullable
                      as bool,
            sellStockLevel: null == sellStockLevel
                ? _value.sellStockLevel
                : sellStockLevel // ignore: cast_nullable_to_non_nullable
                      as String,
            batchWiseDetails: null == batchWiseDetails
                ? _value.batchWiseDetails
                : batchWiseDetails // ignore: cast_nullable_to_non_nullable
                      as String,
            taxCategory: null == taxCategory
                ? _value.taxCategory
                : taxCategory // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ItemMasterModelImplCopyWith<$Res>
    implements $ItemMasterModelCopyWith<$Res> {
  factory _$$ItemMasterModelImplCopyWith(
    _$ItemMasterModelImpl value,
    $Res Function(_$ItemMasterModelImpl) then,
  ) = __$$ItemMasterModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String? id,
    String itemName,
    String vendorItemName,
    String billItemName,
    String alias,
    String printName,
    String groupName,
    String unit,
    @JsonKey(name: 'altUnit') String allUnit,
    String description,
    String taxSetting,
    @JsonKey(name: 'openingStockQty') double? openingStock,
    double? openingStockValue,
    double? purchasePrice,
    double? saleProfit,
    double? salePrice,
    double? mrpPrice,
    double? saleDiscount,
    double? purchaseDiscount,
    double? minSalePrice,
    @JsonKey(fromJson: _parseString) String hsnCode,
    @JsonKey(fromJson: _parseString) String barcode,
    bool stockable,
    String godown,
    double? loyaltyPoints,
    double? refAmn,
    double? refAmntIndia,
    bool forLensProduct,
    @JsonKey(fromJson: _parseString) String sellStockLevel,
    String batchWiseDetails,
    @JsonKey(name: 'TaxCategory') String taxCategory,
    @JsonKey(fromJson: _parseString) String? createdAt,
    @JsonKey(fromJson: _parseString) String? updatedAt,
  });
}

/// @nodoc
class __$$ItemMasterModelImplCopyWithImpl<$Res>
    extends _$ItemMasterModelCopyWithImpl<$Res, _$ItemMasterModelImpl>
    implements _$$ItemMasterModelImplCopyWith<$Res> {
  __$$ItemMasterModelImplCopyWithImpl(
    _$ItemMasterModelImpl _value,
    $Res Function(_$ItemMasterModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ItemMasterModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? itemName = null,
    Object? vendorItemName = null,
    Object? billItemName = null,
    Object? alias = null,
    Object? printName = null,
    Object? groupName = null,
    Object? unit = null,
    Object? allUnit = null,
    Object? description = null,
    Object? taxSetting = null,
    Object? openingStock = freezed,
    Object? openingStockValue = freezed,
    Object? purchasePrice = freezed,
    Object? saleProfit = freezed,
    Object? salePrice = freezed,
    Object? mrpPrice = freezed,
    Object? saleDiscount = freezed,
    Object? purchaseDiscount = freezed,
    Object? minSalePrice = freezed,
    Object? hsnCode = null,
    Object? barcode = null,
    Object? stockable = null,
    Object? godown = null,
    Object? loyaltyPoints = freezed,
    Object? refAmn = freezed,
    Object? refAmntIndia = freezed,
    Object? forLensProduct = null,
    Object? sellStockLevel = null,
    Object? batchWiseDetails = null,
    Object? taxCategory = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$ItemMasterModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        itemName: null == itemName
            ? _value.itemName
            : itemName // ignore: cast_nullable_to_non_nullable
                  as String,
        vendorItemName: null == vendorItemName
            ? _value.vendorItemName
            : vendorItemName // ignore: cast_nullable_to_non_nullable
                  as String,
        billItemName: null == billItemName
            ? _value.billItemName
            : billItemName // ignore: cast_nullable_to_non_nullable
                  as String,
        alias: null == alias
            ? _value.alias
            : alias // ignore: cast_nullable_to_non_nullable
                  as String,
        printName: null == printName
            ? _value.printName
            : printName // ignore: cast_nullable_to_non_nullable
                  as String,
        groupName: null == groupName
            ? _value.groupName
            : groupName // ignore: cast_nullable_to_non_nullable
                  as String,
        unit: null == unit
            ? _value.unit
            : unit // ignore: cast_nullable_to_non_nullable
                  as String,
        allUnit: null == allUnit
            ? _value.allUnit
            : allUnit // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        taxSetting: null == taxSetting
            ? _value.taxSetting
            : taxSetting // ignore: cast_nullable_to_non_nullable
                  as String,
        openingStock: freezed == openingStock
            ? _value.openingStock
            : openingStock // ignore: cast_nullable_to_non_nullable
                  as double?,
        openingStockValue: freezed == openingStockValue
            ? _value.openingStockValue
            : openingStockValue // ignore: cast_nullable_to_non_nullable
                  as double?,
        purchasePrice: freezed == purchasePrice
            ? _value.purchasePrice
            : purchasePrice // ignore: cast_nullable_to_non_nullable
                  as double?,
        saleProfit: freezed == saleProfit
            ? _value.saleProfit
            : saleProfit // ignore: cast_nullable_to_non_nullable
                  as double?,
        salePrice: freezed == salePrice
            ? _value.salePrice
            : salePrice // ignore: cast_nullable_to_non_nullable
                  as double?,
        mrpPrice: freezed == mrpPrice
            ? _value.mrpPrice
            : mrpPrice // ignore: cast_nullable_to_non_nullable
                  as double?,
        saleDiscount: freezed == saleDiscount
            ? _value.saleDiscount
            : saleDiscount // ignore: cast_nullable_to_non_nullable
                  as double?,
        purchaseDiscount: freezed == purchaseDiscount
            ? _value.purchaseDiscount
            : purchaseDiscount // ignore: cast_nullable_to_non_nullable
                  as double?,
        minSalePrice: freezed == minSalePrice
            ? _value.minSalePrice
            : minSalePrice // ignore: cast_nullable_to_non_nullable
                  as double?,
        hsnCode: null == hsnCode
            ? _value.hsnCode
            : hsnCode // ignore: cast_nullable_to_non_nullable
                  as String,
        barcode: null == barcode
            ? _value.barcode
            : barcode // ignore: cast_nullable_to_non_nullable
                  as String,
        stockable: null == stockable
            ? _value.stockable
            : stockable // ignore: cast_nullable_to_non_nullable
                  as bool,
        godown: null == godown
            ? _value.godown
            : godown // ignore: cast_nullable_to_non_nullable
                  as String,
        loyaltyPoints: freezed == loyaltyPoints
            ? _value.loyaltyPoints
            : loyaltyPoints // ignore: cast_nullable_to_non_nullable
                  as double?,
        refAmn: freezed == refAmn
            ? _value.refAmn
            : refAmn // ignore: cast_nullable_to_non_nullable
                  as double?,
        refAmntIndia: freezed == refAmntIndia
            ? _value.refAmntIndia
            : refAmntIndia // ignore: cast_nullable_to_non_nullable
                  as double?,
        forLensProduct: null == forLensProduct
            ? _value.forLensProduct
            : forLensProduct // ignore: cast_nullable_to_non_nullable
                  as bool,
        sellStockLevel: null == sellStockLevel
            ? _value.sellStockLevel
            : sellStockLevel // ignore: cast_nullable_to_non_nullable
                  as String,
        batchWiseDetails: null == batchWiseDetails
            ? _value.batchWiseDetails
            : batchWiseDetails // ignore: cast_nullable_to_non_nullable
                  as String,
        taxCategory: null == taxCategory
            ? _value.taxCategory
            : taxCategory // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ItemMasterModelImpl implements _ItemMasterModel {
  const _$ItemMasterModelImpl({
    @JsonKey(name: '_id') this.id,
    this.itemName = '',
    this.vendorItemName = '',
    this.billItemName = '',
    this.alias = '',
    this.printName = '',
    this.groupName = '',
    this.unit = '',
    @JsonKey(name: 'altUnit') this.allUnit = '',
    this.description = '',
    this.taxSetting = 'N',
    @JsonKey(name: 'openingStockQty') this.openingStock,
    this.openingStockValue,
    this.purchasePrice,
    this.saleProfit,
    this.salePrice,
    this.mrpPrice,
    this.saleDiscount,
    this.purchaseDiscount,
    this.minSalePrice,
    @JsonKey(fromJson: _parseString) this.hsnCode = '',
    @JsonKey(fromJson: _parseString) this.barcode = '',
    this.stockable = false,
    this.godown = '',
    this.loyaltyPoints,
    this.refAmn,
    this.refAmntIndia,
    this.forLensProduct = false,
    @JsonKey(fromJson: _parseString) this.sellStockLevel = '',
    this.batchWiseDetails = '',
    @JsonKey(name: 'TaxCategory') this.taxCategory = '',
    @JsonKey(fromJson: _parseString) this.createdAt,
    @JsonKey(fromJson: _parseString) this.updatedAt,
  });

  factory _$ItemMasterModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ItemMasterModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String? id;
  @override
  @JsonKey()
  final String itemName;
  @override
  @JsonKey()
  final String vendorItemName;
  @override
  @JsonKey()
  final String billItemName;
  @override
  @JsonKey()
  final String alias;
  @override
  @JsonKey()
  final String printName;
  @override
  @JsonKey()
  final String groupName;
  @override
  @JsonKey()
  final String unit;
  @override
  @JsonKey(name: 'altUnit')
  final String allUnit;
  // backend uses altUnit
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final String taxSetting;
  // 'N' for No, 'Y' for Yes
  @override
  @JsonKey(name: 'openingStockQty')
  final double? openingStock;
  // backend uses openingStockQty
  @override
  final double? openingStockValue;
  @override
  final double? purchasePrice;
  @override
  final double? saleProfit;
  @override
  final double? salePrice;
  @override
  final double? mrpPrice;
  @override
  final double? saleDiscount;
  @override
  final double? purchaseDiscount;
  @override
  final double? minSalePrice;
  @override
  @JsonKey(fromJson: _parseString)
  final String hsnCode;
  @override
  @JsonKey(fromJson: _parseString)
  final String barcode;
  @override
  @JsonKey()
  final bool stockable;
  @override
  @JsonKey()
  final String godown;
  @override
  final double? loyaltyPoints;
  // backend: Number
  @override
  final double? refAmn;
  // backend: Number
  @override
  final double? refAmntIndia;
  // backend: Number
  @override
  @JsonKey()
  final bool forLensProduct;
  @override
  @JsonKey(fromJson: _parseString)
  final String sellStockLevel;
  @override
  @JsonKey()
  final String batchWiseDetails;
  @override
  @JsonKey(name: 'TaxCategory')
  final String taxCategory;
  // backend: TaxCategory
  @override
  @JsonKey(fromJson: _parseString)
  final String? createdAt;
  @override
  @JsonKey(fromJson: _parseString)
  final String? updatedAt;

  @override
  String toString() {
    return 'ItemMasterModel(id: $id, itemName: $itemName, vendorItemName: $vendorItemName, billItemName: $billItemName, alias: $alias, printName: $printName, groupName: $groupName, unit: $unit, allUnit: $allUnit, description: $description, taxSetting: $taxSetting, openingStock: $openingStock, openingStockValue: $openingStockValue, purchasePrice: $purchasePrice, saleProfit: $saleProfit, salePrice: $salePrice, mrpPrice: $mrpPrice, saleDiscount: $saleDiscount, purchaseDiscount: $purchaseDiscount, minSalePrice: $minSalePrice, hsnCode: $hsnCode, barcode: $barcode, stockable: $stockable, godown: $godown, loyaltyPoints: $loyaltyPoints, refAmn: $refAmn, refAmntIndia: $refAmntIndia, forLensProduct: $forLensProduct, sellStockLevel: $sellStockLevel, batchWiseDetails: $batchWiseDetails, taxCategory: $taxCategory, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ItemMasterModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.itemName, itemName) ||
                other.itemName == itemName) &&
            (identical(other.vendorItemName, vendorItemName) ||
                other.vendorItemName == vendorItemName) &&
            (identical(other.billItemName, billItemName) ||
                other.billItemName == billItemName) &&
            (identical(other.alias, alias) || other.alias == alias) &&
            (identical(other.printName, printName) ||
                other.printName == printName) &&
            (identical(other.groupName, groupName) ||
                other.groupName == groupName) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.allUnit, allUnit) || other.allUnit == allUnit) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.taxSetting, taxSetting) ||
                other.taxSetting == taxSetting) &&
            (identical(other.openingStock, openingStock) ||
                other.openingStock == openingStock) &&
            (identical(other.openingStockValue, openingStockValue) ||
                other.openingStockValue == openingStockValue) &&
            (identical(other.purchasePrice, purchasePrice) ||
                other.purchasePrice == purchasePrice) &&
            (identical(other.saleProfit, saleProfit) ||
                other.saleProfit == saleProfit) &&
            (identical(other.salePrice, salePrice) ||
                other.salePrice == salePrice) &&
            (identical(other.mrpPrice, mrpPrice) ||
                other.mrpPrice == mrpPrice) &&
            (identical(other.saleDiscount, saleDiscount) ||
                other.saleDiscount == saleDiscount) &&
            (identical(other.purchaseDiscount, purchaseDiscount) ||
                other.purchaseDiscount == purchaseDiscount) &&
            (identical(other.minSalePrice, minSalePrice) ||
                other.minSalePrice == minSalePrice) &&
            (identical(other.hsnCode, hsnCode) || other.hsnCode == hsnCode) &&
            (identical(other.barcode, barcode) || other.barcode == barcode) &&
            (identical(other.stockable, stockable) ||
                other.stockable == stockable) &&
            (identical(other.godown, godown) || other.godown == godown) &&
            (identical(other.loyaltyPoints, loyaltyPoints) ||
                other.loyaltyPoints == loyaltyPoints) &&
            (identical(other.refAmn, refAmn) || other.refAmn == refAmn) &&
            (identical(other.refAmntIndia, refAmntIndia) ||
                other.refAmntIndia == refAmntIndia) &&
            (identical(other.forLensProduct, forLensProduct) ||
                other.forLensProduct == forLensProduct) &&
            (identical(other.sellStockLevel, sellStockLevel) ||
                other.sellStockLevel == sellStockLevel) &&
            (identical(other.batchWiseDetails, batchWiseDetails) ||
                other.batchWiseDetails == batchWiseDetails) &&
            (identical(other.taxCategory, taxCategory) ||
                other.taxCategory == taxCategory) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    itemName,
    vendorItemName,
    billItemName,
    alias,
    printName,
    groupName,
    unit,
    allUnit,
    description,
    taxSetting,
    openingStock,
    openingStockValue,
    purchasePrice,
    saleProfit,
    salePrice,
    mrpPrice,
    saleDiscount,
    purchaseDiscount,
    minSalePrice,
    hsnCode,
    barcode,
    stockable,
    godown,
    loyaltyPoints,
    refAmn,
    refAmntIndia,
    forLensProduct,
    sellStockLevel,
    batchWiseDetails,
    taxCategory,
    createdAt,
    updatedAt,
  ]);

  /// Create a copy of ItemMasterModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ItemMasterModelImplCopyWith<_$ItemMasterModelImpl> get copyWith =>
      __$$ItemMasterModelImplCopyWithImpl<_$ItemMasterModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ItemMasterModelImplToJson(this);
  }
}

abstract class _ItemMasterModel implements ItemMasterModel {
  const factory _ItemMasterModel({
    @JsonKey(name: '_id') final String? id,
    final String itemName,
    final String vendorItemName,
    final String billItemName,
    final String alias,
    final String printName,
    final String groupName,
    final String unit,
    @JsonKey(name: 'altUnit') final String allUnit,
    final String description,
    final String taxSetting,
    @JsonKey(name: 'openingStockQty') final double? openingStock,
    final double? openingStockValue,
    final double? purchasePrice,
    final double? saleProfit,
    final double? salePrice,
    final double? mrpPrice,
    final double? saleDiscount,
    final double? purchaseDiscount,
    final double? minSalePrice,
    @JsonKey(fromJson: _parseString) final String hsnCode,
    @JsonKey(fromJson: _parseString) final String barcode,
    final bool stockable,
    final String godown,
    final double? loyaltyPoints,
    final double? refAmn,
    final double? refAmntIndia,
    final bool forLensProduct,
    @JsonKey(fromJson: _parseString) final String sellStockLevel,
    final String batchWiseDetails,
    @JsonKey(name: 'TaxCategory') final String taxCategory,
    @JsonKey(fromJson: _parseString) final String? createdAt,
    @JsonKey(fromJson: _parseString) final String? updatedAt,
  }) = _$ItemMasterModelImpl;

  factory _ItemMasterModel.fromJson(Map<String, dynamic> json) =
      _$ItemMasterModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String? get id;
  @override
  String get itemName;
  @override
  String get vendorItemName;
  @override
  String get billItemName;
  @override
  String get alias;
  @override
  String get printName;
  @override
  String get groupName;
  @override
  String get unit;
  @override
  @JsonKey(name: 'altUnit')
  String get allUnit; // backend uses altUnit
  @override
  String get description;
  @override
  String get taxSetting; // 'N' for No, 'Y' for Yes
  @override
  @JsonKey(name: 'openingStockQty')
  double? get openingStock; // backend uses openingStockQty
  @override
  double? get openingStockValue;
  @override
  double? get purchasePrice;
  @override
  double? get saleProfit;
  @override
  double? get salePrice;
  @override
  double? get mrpPrice;
  @override
  double? get saleDiscount;
  @override
  double? get purchaseDiscount;
  @override
  double? get minSalePrice;
  @override
  @JsonKey(fromJson: _parseString)
  String get hsnCode;
  @override
  @JsonKey(fromJson: _parseString)
  String get barcode;
  @override
  bool get stockable;
  @override
  String get godown;
  @override
  double? get loyaltyPoints; // backend: Number
  @override
  double? get refAmn; // backend: Number
  @override
  double? get refAmntIndia; // backend: Number
  @override
  bool get forLensProduct;
  @override
  @JsonKey(fromJson: _parseString)
  String get sellStockLevel;
  @override
  String get batchWiseDetails;
  @override
  @JsonKey(name: 'TaxCategory')
  String get taxCategory; // backend: TaxCategory
  @override
  @JsonKey(fromJson: _parseString)
  String? get createdAt;
  @override
  @JsonKey(fromJson: _parseString)
  String? get updatedAt;

  /// Create a copy of ItemMasterModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ItemMasterModelImplCopyWith<_$ItemMasterModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
