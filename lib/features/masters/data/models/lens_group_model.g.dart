// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lens_group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LensGroupModelImpl _$$LensGroupModelImplFromJson(Map<String, dynamic> json) =>
    _$LensGroupModelImpl(
      id: json['_id'] as String?,
      groupName: json['groupName'] as String? ?? '',
      productName: json['productName'] as String? ?? '',
      vendorItemName: json['vendorItemName'] as String? ?? '',
      billItemName: json['billItemName'] as String? ?? '',
      sphMin: _parseString(json['sphMin']),
      sphMax: _parseString(json['sphMax']),
      sphStep: json['sphStep'] == null ? '0.25' : _parseString(json['sphStep']),
      cylMin: _parseString(json['cylMin']),
      cylMax: _parseString(json['cylMax']),
      cylStep: json['cylStep'] == null ? '0.25' : _parseString(json['cylStep']),
      addMin: _parseString(json['addMin']),
      addMax: _parseString(json['addMax']),
      addStep: json['addStep'] == null ? '0.25' : _parseString(json['addStep']),
      axis: json['axis'] == null ? '' : _parseString(json['axis']),
      eye: json['eye'] == null ? '' : _parseString(json['eye']),
      powerGroups: json['powerGroups'] == null
          ? const []
          : _parsePowerGroups(json['powerGroups']),
      addGroups: json['addGroups'] == null
          ? const []
          : _parseAddGroups(json['addGroups']),
      salePrice: json['salePrice'] as Map<String, dynamic>?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$$LensGroupModelImplToJson(
  _$LensGroupModelImpl instance,
) => <String, dynamic>{
  '_id': instance.id,
  'groupName': instance.groupName,
  'productName': instance.productName,
  'vendorItemName': instance.vendorItemName,
  'billItemName': instance.billItemName,
  'sphMin': instance.sphMin,
  'sphMax': instance.sphMax,
  'sphStep': instance.sphStep,
  'cylMin': instance.cylMin,
  'cylMax': instance.cylMax,
  'cylStep': instance.cylStep,
  'addMin': instance.addMin,
  'addMax': instance.addMax,
  'addStep': instance.addStep,
  'axis': instance.axis,
  'eye': instance.eye,
  'powerGroups': instance.powerGroups,
  'addGroups': instance.addGroups,
  'salePrice': instance.salePrice,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};

_$LensPowerGroupImpl _$$LensPowerGroupImplFromJson(Map<String, dynamic> json) =>
    _$LensPowerGroupImpl(
      id: json['id'] as String?,
      label: _parseString(json['label']),
      sphMin: _parseString(json['sphMin']),
      sphMax: _parseString(json['sphMax']),
      sphStep: json['sphStep'] == null ? '0.25' : _parseString(json['sphStep']),
      cylMin: _parseString(json['cylMin']),
      cylMax: _parseString(json['cylMax']),
      cylStep: json['cylStep'] == null ? '0.25' : _parseString(json['cylStep']),
      addMin: _parseString(json['addMin']),
      addMax: _parseString(json['addMax']),
      addStep: json['addStep'] == null ? '0.25' : _parseString(json['addStep']),
      axis: _parseString(json['axis']),
      eye: _parseString(json['eye']),
    );

Map<String, dynamic> _$$LensPowerGroupImplToJson(
  _$LensPowerGroupImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'label': instance.label,
  'sphMin': instance.sphMin,
  'sphMax': instance.sphMax,
  'sphStep': instance.sphStep,
  'cylMin': instance.cylMin,
  'cylMax': instance.cylMax,
  'cylStep': instance.cylStep,
  'addMin': instance.addMin,
  'addMax': instance.addMax,
  'addStep': instance.addStep,
  'axis': instance.axis,
  'eye': instance.eye,
};

_$LensAddGroupImpl _$$LensAddGroupImplFromJson(Map<String, dynamic> json) =>
    _$LensAddGroupImpl(
      id: json['id'] as String?,
      name: json['name'] as String?,
      label: json['label'] as String?,
      combinations: json['combinations'] == null
          ? const []
          : _parseCombinations(json['combinations']),
    );

Map<String, dynamic> _$$LensAddGroupImplToJson(_$LensAddGroupImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'label': instance.label,
      'combinations': instance.combinations,
    };

_$LensCombinationImpl _$$LensCombinationImplFromJson(
  Map<String, dynamic> json,
) => _$LensCombinationImpl(
  id: json['id'] as String?,
  sph: json['sph'] == null ? '' : _parseString(json['sph']),
  cyl: json['cyl'] == null ? '' : _parseString(json['cyl']),
  add: json['add'] == null ? '' : _parseString(json['add']),
  axis: json['axis'] == null ? '' : _parseString(json['axis']),
  eye: json['eye'] == null ? '' : _parseString(json['eye']),
  barcode: json['barcode'] == null ? '' : _parseString(json['barcode']),
  boxNo: json['boxNo'] == null ? '' : _parseString(json['boxNo']),
  alertQty: (json['alertQty'] as num?)?.toInt() ?? 0,
  pPrice: (json['pPrice'] as num?)?.toDouble() ?? 0.0,
  sPrice: (json['sPrice'] as num?)?.toDouble() ?? 0.0,
  initStock: (json['initStock'] as num?)?.toInt() ?? 0,
  locations: json['locations'] == null
      ? const []
      : _parseLocations(json['locations']),
  locationQty: json['locationQty'] == null
      ? ''
      : _parseString(json['locationQty']),
);

Map<String, dynamic> _$$LensCombinationImplToJson(
  _$LensCombinationImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'sph': instance.sph,
  'cyl': instance.cyl,
  'add': instance.add,
  'axis': instance.axis,
  'eye': instance.eye,
  'barcode': instance.barcode,
  'boxNo': instance.boxNo,
  'alertQty': instance.alertQty,
  'pPrice': instance.pPrice,
  'sPrice': instance.sPrice,
  'initStock': instance.initStock,
  'locations': instance.locations,
  'locationQty': instance.locationQty,
};
