class ActiveProductModel {
  final String name;
  final int qty;
  final double revenue;

  ActiveProductModel({
    required this.name,
    required this.qty,
    required this.revenue,
  });

  factory ActiveProductModel.fromJson(Map<String, dynamic> json) {
    return ActiveProductModel(
      name: json['name'] ?? 'Unknown',
      qty: (json['qty'] as num?)?.toInt() ?? 0,
      revenue: (json['revenue'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class ActiveBuyerModel {
  final String name;
  final int orders;
  final double total;

  ActiveBuyerModel({
    required this.name,
    required this.orders,
    required this.total,
  });
}
