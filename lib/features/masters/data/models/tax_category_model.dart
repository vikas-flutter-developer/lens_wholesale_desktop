class TaxCategoryModel {
  final String id;
  final String name;
  final String type; // 'goods' or 'services'
  final double localTax1; // CGST
  final double localTax2; // SGST
  final double centralTax; // IGST
  final double cessTax;
  final String taxOnMRP; // 'yes' or 'no'
  final bool isDefault;
  final String? remarks;

  TaxCategoryModel({
    required this.id,
    required this.name,
    required this.type,
    required this.localTax1,
    required this.localTax2,
    required this.centralTax,
    required this.cessTax,
    required this.taxOnMRP,
    required this.isDefault,
    this.remarks,
  });

  factory TaxCategoryModel.fromJson(Map<String, dynamic> json) {
    return TaxCategoryModel(
      id: json['_id'] ?? '',
      name: json['Name'] ?? json['name'] ?? '',
      type: json['type'] ?? 'goods',
      localTax1: (json['localTax1'] as num?)?.toDouble() ?? 0.0,
      localTax2: (json['localTax2'] as num?)?.toDouble() ?? 0.0,
      centralTax: (json['centralTax'] as num?)?.toDouble() ?? 0.0,
      cessTax: (json['cessTax'] as num?)?.toDouble() ?? 0.0,
      taxOnMRP: json['taxOnMRP']?.toString() ?? 'no',
      isDefault: json['isDefault'] == true,
      remarks: json['remarks'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'type': type,
      'localTax1': localTax1,
      'localTax2': localTax2,
      'centralTax': centralTax,
      'cessTax': cessTax,
      'taxOnMRP': taxOnMRP,
      'isDefault': isDefault,
      'remarks': remarks,
    };
  }
}
