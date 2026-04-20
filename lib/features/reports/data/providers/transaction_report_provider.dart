import 'package:flutter/material.dart';
import '../models/transaction_report_models.dart';
import '../services/transaction_report_service.dart';

class TransactionReportProvider with ChangeNotifier {
  final TransactionReportService _service = TransactionReportService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<TransactionSummary> _summaries = [];
  List<TransactionSummary> get summaries => _summaries;

  List<TransactionDetail> _details = [];
  List<TransactionDetail> get details => _details;

  List<SaleSummaryFormat> _saleFormats = [];
  List<SaleSummaryFormat> get saleFormats => _saleFormats;

  Future<void> fetchSummaries(Map<String, dynamic> filters) async {
    _isLoading = true;
    notifyListeners();
    try {
      _summaries = await _service.getTransactionSummaryReport(filters);
    } catch (e) {
      debugPrint('Error fetching Transaction Summary Report: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDetails(Map<String, dynamic> filters) async {
    _isLoading = true;
    notifyListeners();
    try {
      _details = await _service.getTransactionDetailReport(filters);
    } catch (e) {
      debugPrint('Error fetching Transaction Detail Report: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSaleSummaryFormatReport(Map<String, dynamic> filters) async {
    _isLoading = true;
    notifyListeners();
    try {
      _saleFormats = await _service.getSaleSummaryFormatReport(filters);
    } catch (e) {
      debugPrint('Error fetching Sale Summary Format Report: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void resetAll() {
    _summaries = [];
    _details = [];
    _saleFormats = [];
    notifyListeners();
  }
}
