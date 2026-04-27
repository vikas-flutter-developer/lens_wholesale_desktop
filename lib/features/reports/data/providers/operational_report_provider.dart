import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:csv/csv.dart' as csv;
import '../models/operational_report_model.dart';
import '../services/operational_report_service.dart';

class OperationalReportProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  OrderToChallanReport? _orderToChallanReport;
  OrderToChallanReport? get orderToChallanReport => _orderToChallanReport;

  OrderToChallanReport? _purchaseOrderToChallanReport;
  OrderToChallanReport? get purchaseOrderToChallanReport => _purchaseOrderToChallanReport;

  CancelledOrderRatioReport? _cancelledOrderRatioReport;
  CancelledOrderRatioReport? get cancelledOrderRatioReport => _cancelledOrderRatioReport;

  SaleReturnRatioReport? _saleReturnRatioReport;
  SaleReturnRatioReport? get saleReturnRatioReport => _saleReturnRatioReport;

  SalesGrowthReport? _salesGrowthReport;
  SalesGrowthReport? get salesGrowthReport => _salesGrowthReport;

  int _threshold = 30;
  int get threshold => _threshold;

  int _purchaseThreshold = 30;
  int get purchaseThreshold => _purchaseThreshold;

  OperationalReportProvider() {
    _loadThreshold();
  }

  Future<void> _loadThreshold() async {
    final prefs = await SharedPreferences.getInstance();
    _threshold = prefs.getInt('orderThreshold') ?? 30;
    _purchaseThreshold = prefs.getInt('purchaseOrderThreshold') ?? 30;
    notifyListeners();
  }

  Future<void> setThreshold(int val) async {
    _threshold = val;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('orderThreshold', val);
    notifyListeners();
  }

  Future<void> setPurchaseThreshold(int val) async {
    _purchaseThreshold = val;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('purchaseOrderThreshold', val);
    notifyListeners();
  }

  Future<void> fetchOrderToChallanReport(Map<String, dynamic> filters) async {
    _isLoading = true;
    notifyListeners();

    try {
      _orderToChallanReport = await operationalReportService.getOrderToChallanReport(filters);
    } catch (e) {
      debugPrint('Error fetching Order to Challan report: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPurchaseOrderToChallanReport(Map<String, dynamic> filters) async {
    _isLoading = true;
    notifyListeners();

    try {
      _purchaseOrderToChallanReport = await operationalReportService.getPurchaseOrderToChallanReport(filters);
    } catch (e) {
      debugPrint('Error fetching Purchase Order to Challan report: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCancelledOrderRatioReport(Map<String, dynamic> filters) async {
    _isLoading = true;
    notifyListeners();

    try {
      _cancelledOrderRatioReport = await operationalReportService.getCancelledOrderRatioReport(filters);
    } catch (e) {
      debugPrint('Error fetching Cancelled Order Ratio report: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSaleReturnRatioReport(Map<String, dynamic> filters) async {
    _isLoading = true;
    notifyListeners();

    try {
      _saleReturnRatioReport = await operationalReportService.getSaleReturnRatioReport(filters);
    } catch (e) {
      debugPrint('Error fetching Sale Return Ratio report: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSalesGrowthComparisonReport(Map<String, dynamic> filters) async {
    _isLoading = true;
    notifyListeners();

    try {
      _salesGrowthReport = await operationalReportService.getSalesGrowthComparisonReport(filters);
    } catch (e) {
      debugPrint('Error fetching Sales Growth report: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Uint8List exportOrderToChallanCsv() {
    if (_orderToChallanReport == null) return Uint8List(0);

    final List<List<dynamic>> rows = [
      ['Order No', 'Order Date', 'Challan No', 'Challan Date', 'Party Name', 'Difference (Mins)', 'Status'],
    ];

    for (var d in _orderToChallanReport!.details) {
      rows.add([
        d.orderNo,
        d.orderDate,
        d.challanNo ?? 'N/A',
        d.challanDate ?? 'N/A',
        d.partyName,
        d.timeDifference?.toInt() ?? 0,
        d.status,
      ]);
    }

    final csvContent = const csv.ListToCsvConverter().convert(rows);
    return Uint8List.fromList(csvContent.codeUnits);
  }

  Uint8List exportPurchaseOrderToChallanCsv() {
    if (_purchaseOrderToChallanReport == null) return Uint8List(0);

    final List<List<dynamic>> rows = [
      ['Order No', 'Order Date', 'Challan No', 'Challan Date', 'Party Name', 'Difference (Mins)', 'Status'],
    ];

    for (var d in _purchaseOrderToChallanReport!.details) {
      rows.add([
        d.orderNo,
        d.orderDate,
        d.challanNo ?? 'N/A',
        d.challanDate ?? 'N/A',
        d.partyName,
        d.timeDifference?.toInt() ?? 0,
        d.status,
      ]);
    }

    final csvContent = const csv.ListToCsvConverter().convert(rows);
    return Uint8List.fromList(csvContent.codeUnits);
  }

  Uint8List exportCancelledRatioCsv() {
    if (_cancelledOrderRatioReport == null) return Uint8List(0);

    final List<List<dynamic>> rows = [
      ['Date', 'Type', 'Document', 'Party Name', 'Amount', 'Status'],
    ];

    for (var d in _cancelledOrderRatioReport!.details) {
      rows.add([
        d.date,
        d.transactionType,
        d.label,
        d.partyName,
        d.netAmount,
        d.status,
      ]);
    }

    final csvContent = const csv.ListToCsvConverter().convert(rows);
    return Uint8List.fromList(csvContent.codeUnits);
  }

  Uint8List exportSaleReturnRatioCsv() {
    if (_saleReturnRatioReport == null) return Uint8List(0);

    final List<List<dynamic>> rows = [
      ['Party Name', 'Total Sale', 'Total Return', 'Net Sale', 'Ratio (%)'],
    ];

    for (var d in _saleReturnRatioReport!.partyWise) {
      rows.add([
        d.partyName,
        d.totalSale,
        d.totalReturn,
        d.netSale,
        d.ratio,
      ]);
    }

    final csvContent = const csv.ListToCsvConverter().convert(rows);
    return Uint8List.fromList(csvContent.codeUnits);
  }
}
