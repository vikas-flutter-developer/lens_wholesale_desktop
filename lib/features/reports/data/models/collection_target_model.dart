/// Models for the Customer / Vendor Collection Target Report.
/// The backend returns different fields from the Sale Target report
/// (received, balance, excess, performance) so we use dedicated models.
class CollectionTargetReport {
  final bool success;
  final CollectionSummary? summary;
  final List<CollectionParty> data;

  CollectionTargetReport({
    required this.success,
    this.summary,
    required this.data,
  });

  factory CollectionTargetReport.fromJson(Map<String, dynamic> json) {
    return CollectionTargetReport(
      success: json['success'] as bool? ?? false,
      summary: json['summary'] != null
          ? CollectionSummary.fromJson(json['summary'] as Map<String, dynamic>)
          : null,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => CollectionParty.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class CollectionSummary {
  final double totalTarget;
  final double totalReceived;
  final double totalBalance;
  final double totalExcess;
  final double achievement;

  CollectionSummary({
    required this.totalTarget,
    required this.totalReceived,
    required this.totalBalance,
    required this.totalExcess,
    required this.achievement,
  });

  factory CollectionSummary.fromJson(Map<String, dynamic> json) {
    return CollectionSummary(
      totalTarget: (json['totalTarget'] as num? ?? 0).toDouble(),
      totalReceived: (json['totalReceived'] as num? ?? 0).toDouble(),
      totalBalance: (json['totalBalance'] as num? ?? 0).toDouble(),
      totalExcess: (json['totalExcess'] as num? ?? 0).toDouble(),
      achievement: (json['achievement'] as num? ?? 0).toDouble(),
    );
  }
}

class CollectionParty {
  final String partyName;
  final double targetAmount;
  final double received;
  final double balance;
  final double excess;
  final double performance;
  final String status;
  final String? targetId;
  final String periodType;
  final int year;
  final int? month;
  final int? quarter;

  CollectionParty({
    required this.partyName,
    required this.targetAmount,
    required this.received,
    required this.balance,
    required this.excess,
    required this.performance,
    required this.status,
    this.targetId,
    required this.periodType,
    required this.year,
    this.month,
    this.quarter,
  });

  factory CollectionParty.fromJson(Map<String, dynamic> json) {
    String? targetId;
    final rawId = json['targetId'];
    if (rawId != null) {
      if (rawId is Map) {
        targetId = rawId['\$oid']?.toString() ?? rawId.toString();
      } else {
        targetId = rawId.toString();
      }
    }

    return CollectionParty(
      partyName: json['partyName'] as String? ?? '',
      targetAmount: (json['targetAmount'] as num? ?? 0).toDouble(),
      received: (json['received'] as num? ?? 0).toDouble(),
      balance: (json['balance'] as num? ?? 0).toDouble(),
      excess: (json['excess'] as num? ?? 0).toDouble(),
      performance: (json['performance'] as num? ?? 0).toDouble(),
      status: json['status'] as String? ?? 'No Target',
      targetId: targetId,
      periodType: json['periodType'] as String? ?? 'Monthly',
      year: (json['year'] as num? ?? DateTime.now().year).toInt(),
      month: (json['month'] as num?)?.toInt(),
      quarter: (json['quarter'] as num?)?.toInt(),
    );
  }
}

class CollectionHistoryItem {
  final double targetAmount;
  final double received;
  final double performance;
  final String status;
  final String periodType;
  final int year;
  final int? month;
  final int? quarter;

  CollectionHistoryItem({
    required this.targetAmount,
    required this.received,
    required this.performance,
    required this.status,
    required this.periodType,
    required this.year,
    this.month,
    this.quarter,
  });

  factory CollectionHistoryItem.fromJson(Map<String, dynamic> json) {
    return CollectionHistoryItem(
      targetAmount: (json['targetAmount'] as num? ?? 0).toDouble(),
      received: (json['received'] as num? ?? 0).toDouble(),
      performance: (json['performance'] as num? ?? 0).toDouble(),
      status: json['status'] as String? ?? 'No Target',
      periodType: json['periodType'] as String? ?? 'Monthly',
      year: (json['year'] as num? ?? DateTime.now().year).toInt(),
      month: (json['month'] as num?)?.toInt(),
      quarter: (json['quarter'] as num?)?.toInt(),
    );
  }
}
