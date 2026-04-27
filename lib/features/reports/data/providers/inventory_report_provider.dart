import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/inventory_report_models.dart';
import '../models/lens_stock_report_models.dart';
import '../services/inventory_report_service.dart';

class InventoryReportProvider with ChangeNotifier {
  final InventoryReportService _service = InventoryReportService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Lens Movement Report
  LensMovementReportData? _lensMovementData;
  LensMovementReportData? get lensMovementData => _lensMovementData;

  Future<void> fetchLensMovementReport(Map<String, dynamic> filters) async {
    _isLoading = true;
    notifyListeners();
    try {
      _lensMovementData = await _service.getLensMovementReport(filters);
    } catch (e) {
      debugPrint('Error fetching Lens Movement Report: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Power Movement Report
  PowerMovementReportData? _powerMovementData;
  PowerMovementReportData? get powerMovementData => _powerMovementData;

  Future<void> fetchPowerMovementReport(Map<String, dynamic> filters) async {
    _isLoading = true;
    notifyListeners();
    try {
      _powerMovementData = await _service.getPowerMovementReport(filters);
    } catch (e) {
      debugPrint('Error fetching Power Movement Report: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Party Wise Item Report
  List<PartyWiseItem>? _partyWiseItems;
  List<PartyWiseItem>? get partyWiseItems => _partyWiseItems;

  Future<void> fetchPartyWiseItemReport(Map<String, dynamic> filters) async {
    _isLoading = true;
    notifyListeners();
    try {
      _partyWiseItems = await _service.getPartyWiseItemReport(filters);
    } catch (e) {
      debugPrint('Error fetching Party Wise Item Report: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Stock Reorder Report
  List<StockReorderItem>? _reorderItems;
  List<StockReorderItem>? get reorderItems => _reorderItems;

  Future<void> fetchReorderReport(Map<String, dynamic> filters) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _reorderItems = await _service.getReorderReport(filters);
    } catch (e) {
      _error = e.toString();
      debugPrint('Error fetching Stock Reorder Report: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sale Item Group Wise Report
  List<SaleItemGroupWiseItem>? _saleItemGroupWiseItems;
  List<SaleItemGroupWiseItem>? get saleItemGroupWiseItems => _saleItemGroupWiseItems;

  Future<void> fetchSaleItemGroupWiseReport(Map<String, dynamic> filters) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _saleItemGroupWiseItems = await _service.getSaleItemGroupWiseReport(filters);
    } catch (e) {
      _error = e.toString();
      debugPrint('Error fetching Sale Item Group Wise Report: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Booked By Report
  List<BookedByReportItem>? _bookedByItems;
  List<BookedByReportItem>? get bookedByItems => _bookedByItems;

  Future<void> fetchBookedByReport() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final lensOrders = await _service.getAllLensSaleOrders();
      final rxOrders = await _service.getAllRxSaleOrders();
      final contactOrders = await _service.getAllContactLensSaleOrders();

      List<BookedByReportItem> flattened = [];

      void processOrders(List<dynamic> orders, String type) {
        for (var order in orders) {
          final billData = order['billData'];
          if (billData == null) continue;
          
          final rawBookedBy = billData['bookedBy'] ?? billData['booked_by'];
          if (rawBookedBy == null || rawBookedBy.toString().trim().isEmpty) continue;

          final items = order['items'] as List?;
          if (items == null) continue;

          final partyData = order['partyData'];
          final partyName = partyData != null ? partyData['partyAccount'] : '';
          final billNo = billData['billNo'] ?? billData['bill_no'] ?? '';
          final date = billData['date'] ?? order['createdAt'];
          final time = _getTimeString(order['createdAt']);
          final bookedBy = _normalizeBookedBy(rawBookedBy);
          final netAmount = (order['netAmount'] ?? 0).toDouble();

          for (var i = 0; i < items.length; i++) {
            final item = items[i];
            flattened.add(BookedByReportItem(
              id: '${order['_id']}-$i',
              orderDate: date,
              orderTime: time,
              billNo: billNo.toString(),
              bookedBy: bookedBy,
              itemName: item['itemName'] ?? item['productName'] ?? '',
              eye: item['eye'] ?? '',
              sph: item['sph'],
              cyl: item['cyl'],
              axis: item['axis'],
              add: item['add'],
              qty: (item['qty'] ?? 0).toInt(),
              netAmount: netAmount,
              partyName: partyName,
              remark: item['remark'] ?? order['remark'] ?? '',
              orderType: type,
            ));
          }
        }
      }

      processOrders(lensOrders, 'Lens');
      processOrders(rxOrders, 'Rx');
      processOrders(contactOrders, 'ContactLens');

      _bookedByItems = flattened;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error fetching Booked By Report: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _normalizeBookedBy(dynamic name) {
    if (name == null || name is! String) return '';
    return name.trim().split(' ').map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1).toLowerCase() : '').join(' ');
  }

  String _getTimeString(dynamic dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr.toString());
      return DateFormat('hh:mm:ss a').format(date.toLocal());
    } catch (_) {
      return '';
    }
  }

  // Lens Stock Report
  LensStockReportResponse? _lensStockResponse;
  LensStockReportResponse? get lensStockResponse => _lensStockResponse;

  Future<void> fetchLensStockReport(Map<String, dynamic> filters) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _lensStockResponse = await _service.getLensStockReport(filters);
    } catch (e) {
      _error = e.toString();
      debugPrint('Error fetching Lens Stock Report: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Power Range Library for filter
  List<dynamic> _powerRangeLibrary = [];
  List<dynamic> get powerRangeLibrary => _powerRangeLibrary;
  bool _isLoadingLibrary = false;
  bool get isLoadingLibrary => _isLoadingLibrary;

  Future<void> fetchPowerRangeLibrary(String groupName) async {
    _isLoadingLibrary = true;
    notifyListeners();
    try {
      _powerRangeLibrary = await _service.getPowerRangeLibrary(groupName);
    } catch (e) {
      debugPrint('Error fetching Power Range Library: $e');
      _powerRangeLibrary = [];
    } finally {
      _isLoadingLibrary = false;
      notifyListeners();
    }
  }

  // Customer Item Sales Report
  CustomerItemSalesResponse? _customerItemSalesResponse;
  CustomerItemSalesResponse? get customerItemSalesResponse => _customerItemSalesResponse;

  Future<void> fetchCustomerItemSalesReport(Map<String, dynamic> filters) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await _service.getCustomerItemSalesReport(filters);
      
      // Group by itemName logic as seen in React frontend
      final Map<String, CustomerItemSalesItem> groupedMap = {};
      double totalOrders = 0;

      for (var item in response.data) {
        final name = item.itemName;
        if (groupedMap.containsKey(name)) {
          final existing = groupedMap[name]!;
          groupedMap[name] = existing.copyWith(
            totalQty: existing.totalQty + item.totalQty,
            totalRevenue: existing.totalRevenue + item.totalRevenue,
            orderCount: existing.orderCount + item.orderCount,
          );
        } else {
          groupedMap[name] = item;
        }
        totalOrders += item.orderCount;
      }

      final groupedData = groupedMap.values.toList();
      _customerItemSalesResponse = response.copyWith(
        data: groupedData,
        summary: response.summary.copyWith(
          totalItems: groupedData.length,
          totalOrders: totalOrders.toInt(),
        ),
      );
    } catch (e) {
      _error = e.toString();
      debugPrint('Error fetching Customer Item Sales Report: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Bank Verification Transactions
  List<dynamic> _bankTransactions = [];
  List<dynamic> get bankTransactions => _bankTransactions;

  Future<void> fetchBankTransactions(Map<String, dynamic> filters) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _bankTransactions = await _service.getBankVerificationTransactions(filters);
    } catch (e) {
      _error = e.toString();
      debugPrint('Error fetching Bank Verification Transactions: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Item Stock Summary Report
  ItemStockSummaryResponse? _itemStockSummary;
  ItemStockSummaryResponse? get itemStockSummary => _itemStockSummary;

  Future<void> fetchItemStockSummaryReport(Map<String, dynamic> filters) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _itemStockSummary = await _service.getItemStockSummaryReport(filters);
    } catch (e) {
      _error = e.toString();
      debugPrint('Error fetching Item Stock Summary Report: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void resetAll() {
    _lensMovementData = null;
    _powerMovementData = null;
    _partyWiseItems = null;
    _reorderItems = null;
    _saleItemGroupWiseItems = null;
    _bookedByItems = null;
    _lensStockResponse = null;
    _customerItemSalesResponse = null;
    _powerRangeLibrary = [];
    _bankTransactions = [];
    _itemStockSummary = null;
    notifyListeners();
  }
}
