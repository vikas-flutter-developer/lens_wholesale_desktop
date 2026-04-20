class TransactionSummary {
  final String? date;
  final String? vchNo;
  final String? vchSeries;
  final String? partyName;
  final String? gstin;
  final String? mobileNo;
  final double grossAmt;
  final double paidAmt;
  final double dueAmt;
  final String? billType;
  final String? mtrlCenter;
  final String? usedIn;
  final String? remark;
  final String? status;
  final String? createdBy;
  final String? transType;
  final String? docId;
  final List<TransactionItem>? items;

  // Alias getters for build parity
  double get totalBasic => grossAmt;
  double get taxAmt => paidAmt;
  double get netAmt => dueAmt;
  String? get transactionType => transType;

  TransactionSummary({
    this.date,
    this.vchNo,
    this.vchSeries,
    this.partyName,
    this.gstin,
    this.mobileNo,
    this.grossAmt = 0.0,
    this.paidAmt = 0.0,
    this.dueAmt = 0.0,
    this.billType,
    this.mtrlCenter,
    this.usedIn,
    this.remark,
    this.status,
    this.createdBy,
    this.transType,
    this.docId,
    this.items,
  });

  factory TransactionSummary.fromJson(Map<String, dynamic> json) {
    return TransactionSummary(
      date: json['date'],
      vchNo: json['vchNo'],
      vchSeries: json['vchSeries'],
      partyName: json['partyName'],
      gstin: json['gstin'],
      mobileNo: json['mobileNo'],
      grossAmt: (json['grossAmt'] ?? 0.0).toDouble(),
      paidAmt: (json['paidAmt'] ?? 0.0).toDouble(),
      dueAmt: (json['dueAmt'] ?? 0.0).toDouble(),
      billType: json['billType'],
      mtrlCenter: json['mtrlCenter'],
      usedIn: json['usedIn'],
      remark: json['remark'],
      status: json['status'],
      createdBy: json['createdBy'],
      transType: json['transType'],
      docId: json['docId'],
      items: json['items'] != null
          ? (json['items'] as List).map((i) => TransactionItem.fromJson(i)).toList()
          : null,
    );
  }
}

class TransactionItem {
  final double sph;
  final double cyl;
  final double add;

  TransactionItem({
    this.sph = 0.0,
    this.cyl = 0.0,
    this.add = 0.0,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    return TransactionItem(
      sph: (json['sph'] ?? 0.0).toDouble(),
      cyl: (json['cyl'] ?? 0.0).toDouble(),
      add: (json['add'] ?? 0.0).toDouble(),
    );
  }
}

class TransactionDetail {
  final String? date;
  final String? vchNo;
  final String? partyName;
  final String? mobileNo;
  final String? groupName;
  final String? productName;
  final String? modelNo;
  final String? size;
  final String? color;
  final String? itemDetail;
  final double qty;
  final double price;
  final double totalBasic;
  final double discountAmt;
  final double netAmt;
  final double taxAmt;
  final double dueAmt;
  final String? transType;

  TransactionDetail({
    this.date,
    this.vchNo,
    this.partyName,
    this.mobileNo,
    this.groupName,
    this.productName,
    this.modelNo,
    this.size,
    this.color,
    this.itemDetail,
    this.qty = 0.0,
    this.price = 0.0,
    this.totalBasic = 0.0,
    this.discountAmt = 0.0,
    this.netAmt = 0.0,
    this.taxAmt = 0.0,
    this.dueAmt = 0.0,
    this.transType,
  });

  factory TransactionDetail.fromJson(Map<String, dynamic> json) {
    return TransactionDetail(
      date: json['date'],
      vchNo: json['vchNo'],
      partyName: json['partyName'],
      mobileNo: json['mobNo'] ?? json['mobileNo'],
      groupName: json['group'] ?? json['groupName'],
      productName: json['product'] ?? json['productName'],
      modelNo: json['modelNo'] ?? json['model'],
      size: json['size'],
      color: json['color'],
      itemDetail: json['itemDetail'] ?? json['itemName'],
      qty: (json['qty'] ?? 0.0).toDouble(),
      price: (json['price'] ?? json['rate'] ?? 0.0).toDouble(),
      totalBasic: (json['ttlPrc'] ?? json['totalBasic'] ?? json['amount'] ?? 0.0).toDouble(),
      discountAmt: (json['disAmt'] ?? json['discountAmt'] ?? 0.0).toDouble(),
      netAmt: (json['ttlPrice'] ?? json['netAmt'] ?? json['totalPrice'] ?? 0.0).toDouble(),
      taxAmt: (json['gstWiseAmt'] ?? json['taxAmt'] ?? 0.0).toDouble(),
      dueAmt: (json['dueAmt'] ?? 0.0).toDouble(),
      transType: json['transType'],
    );
  }
}

class SaleSummaryFormat {
  final String? date;
  final String? billNo;
  final String? partyName;
  final String? mobileNo;
  final String? gstin;
  final String? state;
  final String? billType;
  final String? mtrlCntr;
  final double totalQty;
  final double totalAmt;
  final double taxableAmt;
  final double taxPercent;
  final double cgstPercent;
  final double cgstAmt;
  final double sgstPercent;
  final double sgstAmt;
  final String? docId;

  SaleSummaryFormat({
    this.date,
    this.billNo,
    this.partyName,
    this.mobileNo,
    this.gstin,
    this.state,
    this.billType,
    this.mtrlCntr,
    this.totalQty = 0.0,
    this.totalAmt = 0.0,
    this.taxableAmt = 0.0,
    this.taxPercent = 0.0,
    this.cgstPercent = 0.0,
    this.cgstAmt = 0.0,
    this.sgstPercent = 0.0,
    this.sgstAmt = 0.0,
    this.docId,
  });

  factory SaleSummaryFormat.fromJson(Map<String, dynamic> json) {
    return SaleSummaryFormat(
      date: json['date'],
      billNo: json['billNo'],
      partyName: json['partyName'],
      mobileNo: json['mobileNo']?.toString(),
      gstin: json['gstin'],
      state: json['state'],
      billType: json['billType'],
      mtrlCntr: json['mtrlCntr'],
      totalQty: (json['totalQty'] ?? 0.0).toDouble(),
      totalAmt: (json['totalAmt'] ?? 0.0).toDouble(),
      taxableAmt: (json['taxableAmt'] ?? 0.0).toDouble(),
      taxPercent: (json['taxPercent'] ?? 0.0).toDouble(),
      cgstPercent: (json['cgstPercent'] ?? 0.0).toDouble(),
      cgstAmt: (json['cgstAmt'] ?? 0.0).toDouble(),
      sgstPercent: (json['sgstPercent'] ?? 0.0).toDouble(),
      sgstAmt: (json['sgstAmt'] ?? 0.0).toDouble(),
      docId: json['_id'] ?? json['docId'],
    );
  }
}
