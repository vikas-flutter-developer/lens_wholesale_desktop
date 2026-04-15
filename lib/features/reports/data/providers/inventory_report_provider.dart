import 'package:flutter/material.dart';
import '../models/inventory_report_models.dart';
import '../services/inventory_report_service.dart';

class InventoryReportProvider with ChangeNotifier {
  final InventoryReportService _service = InventoryReportService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

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
    notifyListeners();
    try {
      _reorderItems = await _service.getReorderReport(filters);
    } catch (e) {
      debugPrint('Error fetching Stock Reorder Report: $e');
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
    notifyListeners();
  }
}
