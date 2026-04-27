// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_master_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ItemMasterModelImpl _$$ItemMasterModelImplFromJson(
  Map<String, dynamic> json,
) => _$ItemMasterModelImpl(
  id: json['_id'] as String?,
  itemName: json['itemName'] as String? ?? '',
  vendorItemName: json['vendorItemName'] as String? ?? '',
  billItemName: json['billItemName'] as String? ?? '',
  alias: json['alias'] as String? ?? '',
  printName: json['printName'] as String? ?? '',
  groupName: json['groupName'] as String? ?? '',
  unit: json['unit'] as String? ?? '',
  allUnit: json['altUnit'] as String? ?? '',
  description: json['description'] as String? ?? '',
  taxSetting: json['taxSetting'] as String? ?? 'N',
  openingStock: (json['openingStockQty'] as num?)?.toDouble(),
  openingStockValue: (json['openingStockValue'] as num?)?.toDouble(),
  purchasePrice: (json['purchasePrice'] as num?)?.toDouble(),
  saleProfit: (json['saleProfit'] as num?)?.toDouble(),
  salePrice: (json['salePrice'] as num?)?.toDouble(),
  mrpPrice: (json['mrpPrice'] as num?)?.toDouble(),
  gst: (json['gst'] as num?)?.toDouble(),
  saleDiscount: (json['saleDiscount'] as num?)?.toDouble(),
  purchaseDiscount: (json['purchaseDiscount'] as num?)?.toDouble(),
  minSalePrice: (json['minSalePrice'] as num?)?.toDouble(),
  hsnCode: json['hsnCode'] == null ? '' : _parseString(json['hsnCode']),
  barcode: json['barcode'] == null ? '' : _parseString(json['barcode']),
  stockable: json['stockable'] as bool? ?? false,
  godown: json['godown'] as String? ?? '',
  loyaltyPoints: (json['loyaltyPoints'] as num?)?.toDouble(),
  refAmn: (json['refAmn'] as num?)?.toDouble(),
  refAmntIndia: (json['refAmntIndia'] as num?)?.toDouble(),
  forLensProduct: json['forLensProduct'] as bool? ?? false,
  sellStockLevel: json['sellStockLevel'] == null
      ? ''
      : _parseString(json['sellStockLevel']),
  batchWiseDetails: json['batchWiseDetails'] as String? ?? '',
  taxCategory: json['TaxCategory'] as String? ?? '',
  createdAt: _parseString(json['createdAt']),
  updatedAt: _parseString(json['updatedAt']),
);

Map<String, dynamic> _$$ItemMasterModelImplToJson(
  _$ItemMasterModelImpl instance,
) => <String, dynamic>{
  '_id': instance.id,
  'itemName': instance.itemName,
  'vendorItemName': instance.vendorItemName,
  'billItemName': instance.billItemName,
  'alias': instance.alias,
  'printName': instance.printName,
  'groupName': instance.groupName,
  'unit': instance.unit,
  'altUnit': instance.allUnit,
  'description': instance.description,
  'taxSetting': instance.taxSetting,
  'openingStockQty': instance.openingStock,
  'openingStockValue': instance.openingStockValue,
  'purchasePrice': instance.purchasePrice,
  'saleProfit': instance.saleProfit,
  'salePrice': instance.salePrice,
  'mrpPrice': instance.mrpPrice,
  'gst': instance.gst,
  'saleDiscount': instance.saleDiscount,
  'purchaseDiscount': instance.purchaseDiscount,
  'minSalePrice': instance.minSalePrice,
  'hsnCode': instance.hsnCode,
  'barcode': instance.barcode,
  'stockable': instance.stockable,
  'godown': instance.godown,
  'loyaltyPoints': instance.loyaltyPoints,
  'refAmn': instance.refAmn,
  'refAmntIndia': instance.refAmntIndia,
  'forLensProduct': instance.forLensProduct,
  'sellStockLevel': instance.sellStockLevel,
  'batchWiseDetails': instance.batchWiseDetails,
  'TaxCategory': instance.taxCategory,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};
