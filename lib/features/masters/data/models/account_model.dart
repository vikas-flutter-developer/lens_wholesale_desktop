class AccountModel {
  final String id;
  final String name;
  final String? alias;
  final String printName;
  final String accountId;
  final List<String> groups;
  final List<String> stations;
  final String? accountDealerType;
  final String? gstin;
  final String? transporter;
  final String? contactPerson;
  final BalanceModel? openingBalance;
  final BalanceModel? previousYearBalance;
  final double? creditLimit;
  final String? enableLoyalty;
  final String? accountCategory;
  final String? cardNumber;
  final String? address;
  final String? state;
  final String? email;
  final String? telNumber;
  final String? mobileNumber;
  final String? pincode;
  final String? distance;
  final String? itPlan;
  final double? lstNumber;
  final double? cstNumber;
  final double? adharCardNumber;
  final String? dnd;
  final String? ex1;
  final String? dayLimit;
  final String? accountType;
  final String? password;
  final String? remark;
  final List<String>? tags;
  final DateTime? createdAt;

  AccountModel({
    required this.id,
    required this.name,
    this.alias,
    required this.printName,
    required this.accountId,
    required this.groups,
    required this.stations,
    this.accountDealerType,
    this.gstin,
    this.transporter,
    this.contactPerson,
    this.openingBalance,
    this.previousYearBalance,
    this.creditLimit,
    this.enableLoyalty,
    this.accountCategory,
    this.cardNumber,
    this.address,
    this.state,
    this.email,
    this.telNumber,
    this.mobileNumber,
    this.pincode,
    this.distance,
    this.itPlan,
    this.lstNumber,
    this.cstNumber,
    this.adharCardNumber,
    this.dnd,
    this.ex1,
    this.dayLimit,
    this.accountType,
    this.password,
    this.remark,
    this.tags,
    this.createdAt,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['_id'] ?? '',
      name: json['Name'] ?? '',
      alias: json['Alias'],
      printName: json['PrintName'] ?? '',
      accountId: json['AccountId']?.toString() ?? '',
      groups: List<String>.from(json['Groups'] ?? []),
      stations: List<String>.from(json['Stations'] ?? []),
      accountDealerType: json['AccountDealerType'],
      gstin: json['GSTIN'],
      transporter: json['Transporter'],
      contactPerson: json['ContactPerson'],
      openingBalance: json['OpeningBalance'] != null 
          ? BalanceModel.fromJson(json['OpeningBalance']) 
          : null,
      previousYearBalance: json['PreviousYearBalance'] != null 
          ? BalanceModel.fromJson(json['PreviousYearBalance']) 
          : null,
      creditLimit: (json['CreditLimit'] as num?)?.toDouble(),
      enableLoyalty: json['EnableLoyality'],
      accountCategory: json['AccountCategory'],
      cardNumber: json['CardNumber']?.toString(),
      address: json['Address'],
      state: json['State'],
      email: json['Email'],
      telNumber: json['TelNumber']?.toString(),
      mobileNumber: json['MobileNumber']?.toString(),
      pincode: json['Pincode']?.toString(),
      distance: json['Distance']?.toString(),
      itPlan: json['ItPlan'],
      lstNumber: (json['LstNumber'] as num?)?.toDouble(),
      cstNumber: (json['CstNumber'] as num?)?.toDouble(),
      adharCardNumber: (json['AdharCardNumber'] as num?)?.toDouble(),
      dnd: json['Dnd'],
      ex1: json['Ex1'],
      dayLimit: json['DayLimit']?.toString(),
      accountType: json['AccountType'],
      password: json['Password'],
      remark: json['Remark'],
      tags: List<String>.from(json['Tags'] ?? []),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Alias': alias,
      'PrintName': printName,
      'AccountId': accountId,
      'Groups': groups,
      'Stations': stations,
      'AccountDealerType': accountDealerType,
      'GSTIN': gstin,
      'Transporter': transporter,
      'ContactPerson': contactPerson,
      'OpeningBalance': openingBalance?.toJson(),
      'PreviousYearBalance': previousYearBalance?.toJson(),
      'CreditLimit': creditLimit,
      'EnableLoyality': enableLoyalty,
      'AccountCategory': accountCategory,
      'CardNumber': cardNumber,
      'Address': address,
      'State': state,
      'Email': email,
      'TelNumber': telNumber,
      'MobileNumber': mobileNumber,
      'Pincode': pincode,
      'Distance': distance,
      'ItPlan': itPlan,
      'LstNumber': lstNumber,
      'CstNumber': cstNumber,
      'AdharCardNumber': adharCardNumber,
      'Dnd': dnd,
      'Ex1': ex1,
      'DayLimit': dayLimit,
      'AccountType': accountType,
      'Password': password,
      'Remark': remark,
      'Tags': tags,
    };
  }
}

class BalanceModel {
  final double balance;
  final String type; // 'Dr' or 'Cr'

  BalanceModel({required this.balance, required this.type});

  factory BalanceModel.fromJson(Map<String, dynamic> json) {
    return BalanceModel(
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      type: json['type'] ?? 'Dr',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'balance': balance,
      'type': type,
    };
  }
}
