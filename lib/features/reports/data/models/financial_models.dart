class DayBookItem {
  final String? itemName;
  final String? orderNo;
  final String? eye;
  final String? sph;
  final String? cyl;
  final String? axis;
  final String? add;
  final String? remark;

  DayBookItem({
    this.itemName,
    this.orderNo,
    this.eye,
    this.sph,
    this.cyl,
    this.axis,
    this.add,
    this.remark,
  });

  factory DayBookItem.fromJson(Map<String, dynamic> json) {
    return DayBookItem(
      itemName: json['itemName']?.toString(),
      orderNo: json['orderNo']?.toString(),
      eye: json['eye']?.toString(),
      sph: json['sph']?.toString(),
      cyl: json['cyl']?.toString(),
      axis: json['axis']?.toString(),
      add: json['add']?.toString(),
      remark: json['remark']?.toString(),
    );
  }
}

class DayBookTransaction {
  final String date;
  final String transType;
  final String? vchNo;
  final String account;
  final double debit;
  final double credit;
  final String? docId;
  final List<DayBookItem>? items;

  DayBookTransaction({
    required this.date,
    required this.transType,
    this.vchNo,
    required this.account,
    required this.debit,
    required this.credit,
    this.docId,
    this.items,
  });

  factory DayBookTransaction.fromJson(Map<String, dynamic> json) {
    return DayBookTransaction(
      date: json['date']?.toString() ?? '',
      transType: json['transType']?.toString() ?? '',
      vchNo: json['vchNo']?.toString(),
      account: json['account']?.toString() ?? '',
      debit: _parseDouble(json['debit']),
      credit: _parseDouble(json['credit']),
      docId: json['docId']?.toString(),
      items: _parseList(json['items'], (i) => DayBookItem.fromJson(i as Map<String, dynamic>)),
    );
  }
}

class DayBookReport {
  final List<DayBookTransaction> transactions;
  final double totalDebit;
  final double totalCredit;
  final double balance;

  DayBookReport({
    required this.transactions,
    required this.totalDebit,
    required this.totalCredit,
    required this.balance,
  });

  factory DayBookReport.fromJson(Map<String, dynamic> json) {
    final summary = json['summary'] is Map ? json['summary'] : {};
    return DayBookReport(
      transactions: _parseList(json['transactions'], (t) => DayBookTransaction.fromJson(t as Map<String, dynamic>)) ?? [],
      totalDebit: _parseDouble(summary['totalDebit']),
      totalCredit: _parseDouble(summary['totalCredit']),
      balance: _parseDouble(summary['balance']),
    );
  }
}

// Support Helpers
double _parseDouble(dynamic v) {
  if (v == null) return 0.0;
  if (v is double) return v;
  if (v is int) return v.toDouble();
  if (v is String) return double.tryParse(v) ?? 0.0;
  return 0.0;
}

List<T>? _parseList<T>(dynamic v, T Function(dynamic) mapper) {
  if (v is List) {
    return v.map(mapper).toList();
  }
  return null;
}

// Cash Bank
class CashBankTransaction {
  final String date;
  final String? vchNo;
  final String account;
  final double cash;
  final double bank;
  final String? docId;
  final String? transType;

  CashBankTransaction({
    required this.date,
    this.vchNo,
    required this.account,
    required this.cash,
    required this.bank,
    this.docId,
    this.transType,
  });

  factory CashBankTransaction.fromJson(Map<String, dynamic> json) {
    return CashBankTransaction(
      date: json['date']?.toString() ?? '',
      vchNo: json['vchNo']?.toString(),
      account: json['account']?.toString() ?? '',
      cash: _parseDouble(json['cash']),
      bank: _parseDouble(json['bank']),
      docId: json['docId']?.toString(),
      transType: json['transType']?.toString(),
    );
  }
}

class CashBankReport {
  final List<CashBankTransaction> saleTransactions;
  final List<CashBankTransaction> purchaseTransactions;
  final double openingAmount;
  final double closingAmount;
  final double saleTotalCash;
  final double saleTotalBank;
  final double purchaseTotalCash;
  final double purchaseTotalBank;

  CashBankReport({
    required this.saleTransactions,
    required this.purchaseTransactions,
    required this.openingAmount,
    required this.closingAmount,
    required this.saleTotalCash,
    required this.saleTotalBank,
    required this.purchaseTotalCash,
    required this.purchaseTotalBank,
  });

  factory CashBankReport.fromJson(Map<String, dynamic> json) {
    final summary = json['summary'] is Map ? json['summary'] : {};
    return CashBankReport(
      saleTransactions: _parseList(json['saleTransactions'], (t) => CashBankTransaction.fromJson(t as Map<String, dynamic>)) ?? [],
      purchaseTransactions: _parseList(json['purchaseTransactions'], (t) => CashBankTransaction.fromJson(t as Map<String, dynamic>)) ?? [],
      openingAmount: _parseDouble(summary['openingAmount']),
      closingAmount: _parseDouble(summary['closingAmount']),
      saleTotalCash: _parseDouble(summary['saleTotalCash']),
      saleTotalBank: _parseDouble(summary['saleTotalBank']),
      purchaseTotalCash: _parseDouble(summary['purchaseTotalCash']),
      purchaseTotalBank: _parseDouble(summary['purchaseTotalBank']),
    );
  }
}

// Balance Sheet
class BalanceSection {
  final String name;
  final double amount;

  BalanceSection({required this.name, required this.amount});

  factory BalanceSection.fromJson(Map<String, dynamic> json) {
    return BalanceSection(
      name: json['name']?.toString() ?? '',
      amount: _parseDouble(json['amount']),
    );
  }
}

class BalanceSheetReport {
  final List<BalanceSection> liabilities;
  final List<BalanceSection> equity;
  final List<BalanceSection> assets;
  final double profitLossAc;
  final double lossForPeriod;
  final double diffInOpBal;
  final double totalLiabilities;
  final double totalEquity;
  final double totalAssets;
  final double grandTotalLeft;
  final double grandTotalRight;

  BalanceSheetReport({
    required this.liabilities,
    required this.equity,
    required this.assets,
    required this.profitLossAc,
    required this.lossForPeriod,
    required this.diffInOpBal,
    required this.totalLiabilities,
    required this.totalEquity,
    required this.totalAssets,
    required this.grandTotalLeft,
    required this.grandTotalRight,
  });

  factory BalanceSheetReport.fromJson(Map<String, dynamic> json) {
    final summary = json['summary'] is Map ? json['summary'] : {};
    return BalanceSheetReport(
      liabilities: _parseList(json['liabilities'], (t) => BalanceSection.fromJson(t as Map<String, dynamic>)) ?? [],
      equity: _parseList(json['equity'], (t) => BalanceSection.fromJson(t as Map<String, dynamic>)) ?? [],
      assets: _parseList(json['assets'], (t) => BalanceSection.fromJson(t as Map<String, dynamic>)) ?? [],
      profitLossAc: _parseDouble(json['profitLossA_c']),
      lossForPeriod: _parseDouble(json['lossForPeriod']),
      diffInOpBal: _parseDouble(json['diffInOpBal']),
      totalLiabilities: _parseDouble(summary['totalLiabilities']),
      totalEquity: _parseDouble(summary['totalEquity']),
      totalAssets: _parseDouble(summary['totalAssets']),
      grandTotalLeft: _parseDouble(summary['grandTotalLeft']),
      grandTotalRight: _parseDouble(summary['grandTotalRight']),
    );
  }
}

// P&L Account
class PLAccountItem {
  final String accountName;
  final double amount;
  final String? type;

  PLAccountItem({required this.accountName, required this.amount, this.type});

  factory PLAccountItem.fromJson(Map<String, dynamic> json) {
    return PLAccountItem(
      accountName: json['accountName']?.toString() ?? '',
      amount: _parseDouble(json['amount']),
      type: json['type']?.toString(),
    );
  }
}

class PLAccountSummary {
  final double totalDirectExpenses;
  final double totalPurchase;
  final double totalOpeningStock;
  final double totalIndirectExpenses;
  final double totalSales;
  final double totalClosingStock;
  final double grossProfitCO;
  final double grossProfitBF;
  final double totalExpenses;
  final double totalIncome;
  final double netProfit;

  PLAccountSummary({
    required this.totalDirectExpenses,
    required this.totalPurchase,
    required this.totalOpeningStock,
    required this.totalIndirectExpenses,
    required this.totalSales,
    required this.totalClosingStock,
    required this.grossProfitCO,
    required this.grossProfitBF,
    required this.totalExpenses,
    required this.totalIncome,
    required this.netProfit,
  });

  factory PLAccountSummary.fromJson(Map<String, dynamic> json) {
    return PLAccountSummary(
      totalDirectExpenses: _parseDouble(json['totalDirectExpenses']),
      totalPurchase: _parseDouble(json['totalPurchase']),
      totalOpeningStock: _parseDouble(json['totalOpeningStock']),
      totalIndirectExpenses: _parseDouble(json['totalIndirectExpenses']),
      totalSales: _parseDouble(json['totalSales']),
      totalClosingStock: _parseDouble(json['totalClosingStock']),
      grossProfitCO: _parseDouble(json['grossProfitCO']),
      grossProfitBF: _parseDouble(json['grossProfitBF']),
      totalExpenses: _parseDouble(json['totalExpenses']),
      totalIncome: _parseDouble(json['totalIncome']),
      netProfit: _parseDouble(json['netProfit']),
    );
  }
}

class PLAccountExpenses {
  final List<PLAccountItem> directExpenses;
  final List<PLAccountItem> purchaseAccounts;
  final List<PLAccountItem> openingStock;
  final List<PLAccountItem> indirectExpenses;

  PLAccountExpenses({
    required this.directExpenses,
    required this.purchaseAccounts,
    required this.openingStock,
    required this.indirectExpenses,
  });

  factory PLAccountExpenses.fromJson(Map<String, dynamic> json) {
    return PLAccountExpenses(
      directExpenses: _parseList(json['directExpenses'], (t) => PLAccountItem.fromJson(t as Map<String, dynamic>)) ?? [],
      purchaseAccounts: _parseList(json['purchaseAccounts'], (t) => PLAccountItem.fromJson(t as Map<String, dynamic>)) ?? [],
      openingStock: _parseList(json['openingStock'], (t) => PLAccountItem.fromJson(t as Map<String, dynamic>)) ?? [],
      indirectExpenses: _parseList(json['indirectExpenses'], (t) => PLAccountItem.fromJson(t as Map<String, dynamic>)) ?? [],
    );
  }
}

class PLAccountIncome {
  final List<PLAccountItem> saleAccounts;
  final List<PLAccountItem> closingStock;

  PLAccountIncome({
    required this.saleAccounts,
    required this.closingStock,
  });

  factory PLAccountIncome.fromJson(Map<String, dynamic> json) {
    return PLAccountIncome(
      saleAccounts: _parseList(json['saleAccounts'], (t) => PLAccountItem.fromJson(t as Map<String, dynamic>)) ?? [],
      closingStock: _parseList(json['closingStock'], (t) => PLAccountItem.fromJson(t as Map<String, dynamic>)) ?? [],
    );
  }
}

class PLAccountReport {
  final PLAccountExpenses expenses;
  final PLAccountIncome income;
  final PLAccountSummary summary;

  PLAccountReport({
    required this.expenses,
    required this.income,
    required this.summary,
  });

  factory PLAccountReport.fromJson(Map<String, dynamic> json) {
    return PLAccountReport(
      expenses: PLAccountExpenses.fromJson(json['expenses'] is Map ? json['expenses'] : {}),
      income: PLAccountIncome.fromJson(json['income'] is Map ? json['income'] : {}),
      summary: PLAccountSummary.fromJson(json['summary'] is Map ? json['summary'] : {}),
    );
  }
}

// P&L Item
class PLItemProfit {
  final double purPrice;
  final double salPrice;
  final double totPurPrice;
  final double totSalPrice;
  final double profitLoss;

  PLItemProfit({
    required this.purPrice,
    required this.salPrice,
    required this.totPurPrice,
    required this.totSalPrice,
    required this.profitLoss,
  });

  factory PLItemProfit.fromJson(Map<String, dynamic> json) {
    return PLItemProfit(
      purPrice: _parseDouble(json['purPrice']),
      salPrice: _parseDouble(json['salPrice']),
      totPurPrice: _parseDouble(json['totPurPrice']),
      totSalPrice: _parseDouble(json['totSalPrice']),
      profitLoss: _parseDouble(json['profitLoss']),
    );
  }
}

class PLItemRow {
  final String groupName;
  final String itemName;
  final double stokOutQty;
  final PLItemProfit itemWiseProfit;

  PLItemRow({
    required this.groupName,
    required this.itemName,
    required this.stokOutQty,
    required this.itemWiseProfit,
  });

  factory PLItemRow.fromJson(Map<String, dynamic> json) {
    return PLItemRow(
      groupName: json['groupName']?.toString() ?? '',
      itemName: json['itemName']?.toString() ?? '',
      stokOutQty: _parseDouble(json['stokOutQty']),
      itemWiseProfit: PLItemProfit.fromJson(json['itemWiseProfit'] is Map ? json['itemWiseProfit'] : {}),
    );
  }
}

class PLItemSummary {
  final double totalPurchaseAmount;
  final double totalSaleAmount;
  final double totalProfitLoss;
  final int profitableItems;
  final int lossItems;

  PLItemSummary({
    required this.totalPurchaseAmount,
    required this.totalSaleAmount,
    required this.totalProfitLoss,
    required this.profitableItems,
    required this.lossItems,
  });

  factory PLItemSummary.fromJson(Map<String, dynamic> json) {
    return PLItemSummary(
      totalPurchaseAmount: _parseDouble(json['totalPurchaseAmount']),
      totalSaleAmount: _parseDouble(json['totalSaleAmount']),
      totalProfitLoss: _parseDouble(json['totalProfitLoss']),
      profitableItems: _parseDouble(json['profitableItems']).toInt(),
      lossItems: _parseDouble(json['lossItems']).toInt(),
    );
  }
}

class PLItemReport {
  final List<PLItemRow> reportData;
  final PLItemSummary summary;

  PLItemReport({
    required this.reportData,
    required this.summary,
  });

  factory PLItemReport.fromJson(Map<String, dynamic> json) {
    return PLItemReport(
      reportData: _parseList(json['reportData'], (t) => PLItemRow.fromJson(t as Map<String, dynamic>)) ?? [],
      summary: PLItemSummary.fromJson(json['summary'] is Map ? json['summary'] : {}),
    );
  }
}
// Collection Report
class CollectionRow {
  final String date;
  final String? firmName;
  final double totalBusiness;
  final double cashDr;
  final double cashCr;
  final double bankDr;
  final double bankCr;
  final double othDr;
  final double othCr;
  final String balance;
  final String? detail;

  CollectionRow({
    required this.date,
    this.firmName,
    required this.totalBusiness,
    required this.cashDr,
    required this.cashCr,
    required this.bankDr,
    required this.bankCr,
    required this.othDr,
    required this.othCr,
    required this.balance,
    this.detail,
  });

  factory CollectionRow.fromJson(Map<String, dynamic> json) {
    return CollectionRow(
      date: json['date']?.toString() ?? '',
      firmName: json['firmName']?.toString(),
      totalBusiness: _parseDouble(json['totalBusiness']),
      cashDr: _parseDouble(json['cashDr']),
      cashCr: _parseDouble(json['cashCr']),
      bankDr: _parseDouble(json['bankDr']),
      bankCr: _parseDouble(json['bankCr']),
      othDr: _parseDouble(json['othDr']),
      othCr: _parseDouble(json['othCr']),
      balance: json['balance']?.toString() ?? '0.00 Dr',
      detail: json['detail']?.toString(),
    );
  }
}

class CollectionReport {
  final List<CollectionRow> reportData;
  final double totalBusiness;
  final double totalCashDr;
  final double totalCashCr;
  final double totalBankDr;
  final double totalBankCr;

  CollectionReport({
    required this.reportData,
    required this.totalBusiness,
    required this.totalCashDr,
    required this.totalCashCr,
    required this.totalBankDr,
    required this.totalBankCr,
  });

  factory CollectionReport.fromJson(dynamic json) {
    List<dynamic> list = [];
    if (json is List) {
      list = json;
    } else if (json is Map && json.containsKey('data')) {
      list = json['data'];
    }

    final data = list.map((i) => CollectionRow.fromJson(i as Map<String, dynamic>)).toList();
    
    return CollectionReport(
      reportData: data,
      totalBusiness: data.fold(0, (s, r) => s + r.totalBusiness),
      totalCashDr: data.fold(0, (s, r) => s + r.cashDr),
      totalCashCr: data.fold(0, (s, r) => s + r.cashCr),
      totalBankDr: data.fold(0, (s, r) => s + r.bankDr),
      totalBankCr: data.fold(0, (s, r) => s + r.bankCr),
    );
  }
}
