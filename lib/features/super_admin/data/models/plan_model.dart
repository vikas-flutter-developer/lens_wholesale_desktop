class PlanModel {
  final String id;
  final String planName;
  final double monthlyPrice;
  final double yearlyPrice;
  final int maxUsers;
  final int maxBranches;
  final List<String> features;
  final bool isActive;

  PlanModel({
    required this.id,
    required this.planName,
    required this.monthlyPrice,
    required this.yearlyPrice,
    required this.maxUsers,
    required this.maxBranches,
    required this.features,
    required this.isActive,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      id: json['_id'] ?? json['id'] ?? '',
      planName: json['planName'] ?? '',
      monthlyPrice: (json['monthlyPrice'] ?? 0).toDouble(),
      yearlyPrice: (json['yearlyPrice'] ?? 0).toDouble(),
      maxUsers: json['maxUsers'] ?? 1,
      maxBranches: json['maxBranches'] ?? 1,
      features: (json['features'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'planName': planName,
      'monthlyPrice': monthlyPrice,
      'yearlyPrice': yearlyPrice,
      'maxUsers': maxUsers,
      'maxBranches': maxBranches,
      'features': features,
      'isActive': isActive,
    };
  }

  PlanModel copyWith({
    String? id,
    String? planName,
    double? monthlyPrice,
    double? yearlyPrice,
    int? maxUsers,
    int? maxBranches,
    List<String>? features,
    bool? isActive,
  }) {
    return PlanModel(
      id: id ?? this.id,
      planName: planName ?? this.planName,
      monthlyPrice: monthlyPrice ?? this.monthlyPrice,
      yearlyPrice: yearlyPrice ?? this.yearlyPrice,
      maxUsers: maxUsers ?? this.maxUsers,
      maxBranches: maxBranches ?? this.maxBranches,
      features: features ?? this.features,
      isActive: isActive ?? this.isActive,
    );
  }
}
