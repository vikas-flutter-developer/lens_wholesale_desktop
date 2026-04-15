import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/active_report_model.dart';

import '../../../../core/utils/export_service.dart';

class ActiveReportProvider with ChangeNotifier {
  List<ActiveProductModel> _topProducts = [];
  List<ActiveBuyerModel> _topBuyers = [];
  bool _isLoading = false;
  String? _error;
  String _currentPeriod = 'week';
  String _currentMode = 'products'; // 'products' or 'buyers'

  List<ActiveProductModel> get topProducts => _topProducts;
  List<ActiveBuyerModel> get topBuyers => _topBuyers;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get currentPeriod => _currentPeriod;
  String get currentMode => _currentMode;

  void setPeriod(String period) {
    _currentPeriod = period;
    if (_currentMode == 'products') {
      fetchTopProducts();
    } else {
      _generateMockBuyers();
    }
  }

  void setMode(String mode) {
    _currentMode = mode;
    if (_currentMode == 'products' && _topProducts.isEmpty) {
      fetchTopProducts();
    } else if (_currentMode == 'buyers') {
      _generateMockBuyers();
    }
    notifyListeners();
  }

  Future<void> fetchTopProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await apiClient.dio.get('/active/topProducts', queryParameters: {
        'period': _currentPeriod,
        'limit': 50,
      });

      if (response.data != null && response.data['success'] == true) {
        final List data = response.data['data'] ?? [];
        _topProducts = data.map((json) => ActiveProductModel.fromJson(json)).toList();
      }
      _error = null;
    } on DioException catch (e) {
      _error = e.response?.data?['message'] ?? e.message ?? 'Failed to load products';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _generateMockBuyers() {
    // Exact mock data parity with React reference
    final allMocks = [
      ActiveBuyerModel(name: "Ravi Optics", orders: 3, total: 3700),
      ActiveBuyerModel(name: "Amit Store", orders: 2, total: 2700),
      ActiveBuyerModel(name: "Neha Optical", orders: 1, total: 750),
    ];

    // Simulate period filtering for mocks
    if (_currentPeriod == 'day') {
      _topBuyers = allMocks.sublist(0, 1);
    } else if (_currentPeriod == 'week') {
      _topBuyers = allMocks.sublist(0, 2);
    } else {
      _topBuyers = allMocks;
    }
    notifyListeners();
  }

  double get totalRevenue {
    if (_currentMode == 'products') {
      return _topProducts.fold(0, (sum, p) => sum + p.revenue);
    } else {
      return _topBuyers.fold(0, (sum, b) => sum + b.total);
    }
  }

  int get totalCount {
    if (_currentMode == 'products') {
      return _topProducts.fold(0, (sum, p) => sum + p.qty);
    } else {
      return _topBuyers.fold(0, (sum, b) => sum + b.orders);
    }
  }

  Future<String?> exportCSV() async {
    if (_currentMode == 'products') {
      return await ExportService.exportToCSV(
        fileName: 'top_products_${_currentPeriod}',
        reportTitle: 'Top Performing Products (${_currentPeriod.toUpperCase()})',
        headers: ['Rank', 'Product Name', 'Quantity Sold', 'Revenue (₹)'],
        data: _topProducts.asMap().entries.map((e) => [
          e.key + 1,
          e.value.name,
          e.value.qty,
          e.value.revenue,
        ]).toList(),
      );
    } else {
      return await ExportService.exportToCSV(
        fileName: 'top_buyers_${_currentPeriod}',
        reportTitle: 'Top Active Buyers (${_currentPeriod.toUpperCase()})',
        headers: ['Rank', 'Buyer Name', 'Total Orders', 'Total Value (₹)'],
        data: _topBuyers.asMap().entries.map((e) => [
          e.key + 1,
          e.value.name,
          e.value.orders,
          e.value.total,
        ]).toList(),
      );
    }
  }
}
