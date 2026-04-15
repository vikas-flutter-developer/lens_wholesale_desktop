class OutstandingReportResponse {
  final List<OutstandingItem> data;
  final OutstandingSummary? summary;

  OutstandingReportResponse({required this.data, this.summary});

  factory OutstandingReportResponse.fromJson(Map<String, dynamic> json) {
    return OutstandingReportResponse(
      data: (json['data'] as List?)
              ?.map((item) => OutstandingItem.fromJson(item))
              .toList() ??
          [],
      summary: json['summary'] != null
          ? OutstandingSummary.fromJson(json['summary'])
          : null,
    );
  }
}

class OutstandingItem {
  final String? id;
  final String particular;
  final String? contactNo;
  final String? address;
  final String? groupName;
  final String? state;
  final double days1to30;
  final double days31to60;
  final double days61to90;
  final double above90Days;
  final double totalOutstanding;

  OutstandingItem({
    this.id,
    required this.particular,
    this.contactNo,
    this.address,
    this.groupName,
    this.state,
    required this.days1to30,
    required this.days31to60,
    required this.days61to90,
    required this.above90Days,
    required this.totalOutstanding,
  });

  factory OutstandingItem.fromJson(Map<String, dynamic> json) {
    return OutstandingItem(
      id: json['_id']?.toString(),
      particular: json['particular'] ?? '',
      contactNo: json['contactNo']?.toString(),
      address: json['address']?.toString(),
      groupName: json['groupName']?.toString(),
      state: json['state']?.toString(),
      days1to30: double.tryParse(json['days1to30'].toString()) ?? 0.0,
      days31to60: double.tryParse(json['days31to60'].toString()) ?? 0.0,
      days61to90: double.tryParse(json['days61to90'].toString()) ?? 0.0,
      above90Days: double.tryParse(json['above90Days'].toString()) ?? 0.0,
      totalOutstanding: double.tryParse(json['totalOutstanding'].toString()) ?? 0.0,
    );
  }
}

class OutstandingSummary {
  final int totalAccounts;
  final double total1to30;
  final double total31to60;
  final double total61to90;
  final double totalAbove90;
  final double grandTotal;

  OutstandingSummary({
    required this.totalAccounts,
    required this.total1to30,
    required this.total31to60,
    required this.total61to90,
    required this.totalAbove90,
    required this.grandTotal,
  });

  factory OutstandingSummary.fromJson(Map<String, dynamic> json) {
    return OutstandingSummary(
      totalAccounts: int.tryParse(json['totalAccounts'].toString()) ?? 0,
      total1to30: double.tryParse(json['total1to30'].toString()) ?? 0.0,
      total31to60: double.tryParse(json['total31to60'].toString()) ?? 0.0,
      total61to90: double.tryParse(json['total61to90'].toString()) ?? 0.0,
      totalAbove90: double.tryParse(json['totalAbove90'].toString()) ?? 0.0,
      grandTotal: double.tryParse(json['grandTotal'].toString()) ?? 0.0,
    );
  }
}
