class PaymentHistoryModel {
  final String id;
  final String companyId;
  final String companyName;
  final String planName;
  final double amount;
  final String currency;
  final String paymentMethod;
  final String status; // 'paid', 'pending', 'failed'
  final String billingCycle; // 'monthly', 'yearly'
  final DateTime paidAt;
  final DateTime validUntil;

  PaymentHistoryModel({
    required this.id,
    required this.companyId,
    required this.companyName,
    required this.planName,
    required this.amount,
    required this.currency,
    required this.paymentMethod,
    required this.status,
    required this.billingCycle,
    required this.paidAt,
    required this.validUntil,
  });

  factory PaymentHistoryModel.fromJson(Map<String, dynamic> json) {
    return PaymentHistoryModel(
      id: json['_id'] ?? json['id'] ?? '',
      companyId: json['companyId'] ?? '',
      companyName: json['companyName'] ?? '',
      planName: json['planName'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'INR',
      paymentMethod: json['paymentMethod'] ?? 'online',
      status: json['status'] ?? 'pending',
      billingCycle: json['billingCycle'] ?? 'monthly',
      paidAt: DateTime.tryParse(json['paidAt'] ?? '') ?? DateTime.now(),
      validUntil: DateTime.tryParse(json['validUntil'] ?? '') ?? DateTime.now(),
    );
  }
}
