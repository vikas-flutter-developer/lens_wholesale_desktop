class SystemSettingsModel {
  final String id;
  final String appName;
  final String supportEmail;
  final String supportPhone;
  final String currency;
  final String gstNumber;
  final String address;
  final int trialDays;
  final bool maintenanceMode;
  final bool allowNewRegistrations;

  SystemSettingsModel({
    required this.id,
    required this.appName,
    required this.supportEmail,
    required this.supportPhone,
    required this.currency,
    required this.gstNumber,
    required this.address,
    required this.trialDays,
    required this.maintenanceMode,
    required this.allowNewRegistrations,
  });

  factory SystemSettingsModel.fromJson(Map<String, dynamic> json) {
    return SystemSettingsModel(
      id: json['_id'] ?? json['id'] ?? '',
      appName: json['appName'] ?? 'Lens ERP',
      supportEmail: json['supportEmail'] ?? '',
      supportPhone: json['supportPhone'] ?? '',
      currency: json['currency'] ?? 'INR',
      gstNumber: json['gstNumber'] ?? '',
      address: json['address'] ?? '',
      trialDays: json['trialDays'] ?? 14,
      maintenanceMode: json['maintenanceMode'] ?? false,
      allowNewRegistrations: json['allowNewRegistrations'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appName': appName,
      'supportEmail': supportEmail,
      'supportPhone': supportPhone,
      'currency': currency,
      'gstNumber': gstNumber,
      'address': address,
      'trialDays': trialDays,
      'maintenanceMode': maintenanceMode,
      'allowNewRegistrations': allowNewRegistrations,
    };
  }

  SystemSettingsModel copyWith({
    String? id,
    String? appName,
    String? supportEmail,
    String? supportPhone,
    String? currency,
    String? gstNumber,
    String? address,
    int? trialDays,
    bool? maintenanceMode,
    bool? allowNewRegistrations,
  }) {
    return SystemSettingsModel(
      id: id ?? this.id,
      appName: appName ?? this.appName,
      supportEmail: supportEmail ?? this.supportEmail,
      supportPhone: supportPhone ?? this.supportPhone,
      currency: currency ?? this.currency,
      gstNumber: gstNumber ?? this.gstNumber,
      address: address ?? this.address,
      trialDays: trialDays ?? this.trialDays,
      maintenanceMode: maintenanceMode ?? this.maintenanceMode,
      allowNewRegistrations: allowNewRegistrations ?? this.allowNewRegistrations,
    );
  }
}
