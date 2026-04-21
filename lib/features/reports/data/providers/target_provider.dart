import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart' as csv;
import '../models/target_model.dart';
import '../models/collection_target_model.dart';
import '../services/target_service.dart';

class TargetProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  TargetReport? _saleReport;
  TargetReport? get saleReport => _saleReport;

  CollectionTargetReport? _collectionReport;
  CollectionTargetReport? get collectionReport => _collectionReport;

  int _selectedYear = DateTime.now().year;
  int get selectedYear => _selectedYear;

  String _selectedPeriodType = 'Monthly';
  String get selectedPeriodType => _selectedPeriodType;

  int _selectedMonth = DateTime.now().month;
  int get selectedMonth => _selectedMonth;

  int _selectedQuarter = ((DateTime.now().month - 1) / 3).floor() + 1;
  int get selectedQuarter => _selectedQuarter;

  void setFilters({int? year, String? periodType, int? month, int? quarter}) {
    if (year != null) _selectedYear = year;
    if (periodType != null) _selectedPeriodType = periodType;
    if (month != null) _selectedMonth = month;
    if (quarter != null) _selectedQuarter = quarter;
    notifyListeners();
  }

  Future<void> fetchSaleTargetReport() async {
    _isLoading = true;
    notifyListeners();

    try {
      final filters = {
        'year': _selectedYear,
        'periodType': _selectedPeriodType,
      };
      if (_selectedPeriodType == 'Monthly') filters['month'] = _selectedMonth;
      if (_selectedPeriodType == 'Quarterly') filters['quarter'] = _selectedQuarter;

      _saleReport = await targetService.getSaleTargetReport(filters);
    } catch (e) {
      debugPrint('Error fetching sale target report: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCollectionTargetReport(String targetType) async {
    _isLoading = true;
    notifyListeners();

    try {
      final filters = {
        'year': _selectedYear,
        'periodType': _selectedPeriodType,
        'targetType': targetType,
      };
      if (_selectedPeriodType == 'Monthly') filters['month'] = _selectedMonth;
      if (_selectedPeriodType == 'Quarterly') filters['quarter'] = _selectedQuarter;

      _collectionReport = await targetService.getCollectionTargetReport(filters);
    } catch (e) {
      debugPrint('Error fetching collection target report: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> saveTarget({
    required String partyId,
    required String partyName,
    required double amount,
    required bool isCollection,
    String? targetType,
  }) async {
    final now = DateTime.now();
    DateTime start, end;

    if (_selectedPeriodType == 'Yearly') {
      start = DateTime(_selectedYear, 1, 1);
      end = DateTime(_selectedYear, 12, 31);
    } else if (_selectedPeriodType == 'Monthly') {
      start = DateTime(_selectedYear, _selectedMonth, 1);
      end = DateTime(_selectedYear, _selectedMonth + 1, 0);
    } else {
      // Quarterly
      start = DateTime(_selectedYear, (_selectedQuarter - 1) * 3 + 1, 1);
      end = DateTime(_selectedYear, _selectedQuarter * 3 + 1, 0);
    }

    final entry = TargetEntry(
      partyId: partyId,
      partyName: partyName,
      targetAmount: amount,
      periodType: _selectedPeriodType,
      year: _selectedYear,
      month: _selectedPeriodType == 'Monthly' ? _selectedMonth : null,
      quarter: _selectedPeriodType == 'Quarterly' ? _selectedQuarter : null,
      startDate: start.toIso8601String(),
      endDate: end.toIso8601String(),
      targetType: targetType,
    );

    bool success;
    if (isCollection) {
      success = await targetService.saveCollectionTarget(entry);
    } else {
      success = await targetService.saveSaleTarget(entry);
    }

    if (success) {
      if (isCollection) {
        await fetchCollectionTargetReport(targetType ?? 'Customer');
      } else {
        await fetchSaleTargetReport();
      }
    }
    return success;
  }

  Uint8List exportToCsv(bool isCollection) {
    final List<List<dynamic>> rows;

    if (isCollection) {
      final report = _collectionReport;
      if (report == null) return Uint8List(0);
      rows = [
        ['Party Name', 'Target Amount', 'Received', 'Balance', 'Excess', 'Performance (%)', 'Status', 'Period', 'Year'],
      ];
      for (var p in report.data) {
        rows.add([p.partyName, p.targetAmount, p.received, p.balance, p.excess, p.performance, p.status, p.periodType, p.year]);
      }
    } else {
      final report = _saleReport;
      if (report == null) return Uint8List(0);
      rows = [
        ['Party Name', 'Target Amount', 'Achieved', 'Difference', 'Ratio (%)', 'Status', 'Period', 'Year'],
      ];
      for (var agent in report.data) {
        rows.add([agent.partyName, agent.targetAmount, agent.achieved, agent.difference, agent.ratio, agent.status, agent.periodType, agent.year]);
      }
    }

    final csvContent = const csv.ListToCsvConverter().convert(rows);
    return Uint8List.fromList(csvContent.codeUnits);
  }
}
