class CompanyModel {
  final String id;
  final String companyName;
  final String ownerName;
  final String email;
  final String phone;
  final String gstin;
  final String address;
  final bool isActive;

  CompanyModel({
    required this.id,
    required this.companyName,
    required this.ownerName,
    required this.email,
    required this.phone,
    required this.gstin,
    required this.address,
    required this.isActive,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['_id'] ?? json['id'] ?? '',
      companyName: json['companyName'] ?? '',
      ownerName: json['ownerName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      gstin: json['gstin'] ?? '',
      address: json['address'] ?? '',
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyName': companyName,
      'ownerName': ownerName,
      'email': email,
      'phone': phone,
      'gstin': gstin,
      'address': address,
      'isActive': isActive,
    };
  }

  CompanyModel copyWith({
    String? id,
    String? companyName,
    String? ownerName,
    String? email,
    String? phone,
    String? gstin,
    String? address,
    bool? isActive,
  }) {
    return CompanyModel(
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
      ownerName: ownerName ?? this.ownerName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gstin: gstin ?? this.gstin,
      address: address ?? this.address,
      isActive: isActive ?? this.isActive,
    );
  }
}
