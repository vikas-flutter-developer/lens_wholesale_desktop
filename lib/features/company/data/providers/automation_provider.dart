import 'package:flutter/material.dart';

class CompanyAutomationProvider with ChangeNotifier {
  bool _isAutoInvoicingEnabled = true;
  final List<int> _selectedBillingDates = [15, 31];

  bool get isAutoInvoicingEnabled => _isAutoInvoicingEnabled;
  List<int> get selectedBillingDates => List.unmodifiable(_selectedBillingDates);

  void toggleAutoInvoicing(bool value) {
    _isAutoInvoicingEnabled = value;
    notifyListeners();
  }

  void toggleBillingDate(int day) {
    if (_selectedBillingDates.contains(day)) {
      _selectedBillingDates.remove(day);
    } else {
      if (_selectedBillingDates.length < 2) {
        _selectedBillingDates.add(day);
      } else {
        // Option A: Do nothing (strict max 2)
        // Option B: Remove oldest and add new
        _selectedBillingDates.removeAt(0);
        _selectedBillingDates.add(day);
      }
    }
    _selectedBillingDates.sort();
    notifyListeners();
  }

  Future<bool> saveSettings() async {
    // In a real app, this would call apiClient.dio.put('/company/automation', data: ...)
    // For now, we simulate a success after a delay.
    await Future.delayed(const Duration(milliseconds: 800));
    return true;
  }
}
