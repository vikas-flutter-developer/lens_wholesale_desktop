class AccountGroupModel {
  final String id;
  final String accountGroupName;
  final String primaryGroup; // 'Y' or 'N'
  final String ledgerGroup;

  AccountGroupModel({
    required this.id,
    required this.accountGroupName,
    required this.primaryGroup,
    required this.ledgerGroup,
  });

  factory AccountGroupModel.fromJson(Map<String, dynamic> json) {
    return AccountGroupModel(
      id: json['_id'] ?? json['id'] ?? '',
      accountGroupName: json['accountGroupName'] ?? '',
      primaryGroup: json['primaryGroup'] ?? 'Y',
      ledgerGroup: json['LedgerGroup'] ?? json['ledgerGroup'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountGroupName': accountGroupName,
      'primaryGroup': primaryGroup,
      'LedgerGroup': ledgerGroup,
    };
  }

  AccountGroupModel copyWith({
    String? id,
    String? accountGroupName,
    String? primaryGroup,
    String? ledgerGroup,
  }) {
    return AccountGroupModel(
      id: id ?? this.id,
      accountGroupName: accountGroupName ?? this.accountGroupName,
      primaryGroup: primaryGroup ?? this.primaryGroup,
      ledgerGroup: ledgerGroup ?? this.ledgerGroup,
    );
  }
}
