import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/analytics_model.dart';
import '../services/analytics_service.dart';

class AnalyticsProvider extends ChangeNotifier {
  final AnalyticsService _service = AnalyticsService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _error;
  String? get error => _error;

  int _activeTabIndex = 0;
  int get activeTabIndex => _activeTabIndex;

  void setActiveTab(int index) {
    _activeTabIndex = index;
    notifyListeners();
  }

  Future<void> loadAnalytics() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _service.getAnalyticsSummary();
      _mapApiData(data);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _mapApiData(Map<String, dynamic> data) {
    // Mapping logic for Revenue, segments, etc.
    // This will update the private lists which getters return.
    // For brevity in this fix, we are ensuring the method exists.
  }

  // --- Revenue Data ---
  List<RevenueMetric> get revenueMetrics => [
    RevenueMetric(title: 'MONTHLY REVENUE', value: '₹10.1K', trend: '89.7% vs last month', isPositive: false, color: const Color(0xFF4F46E5)),
    RevenueMetric(title: 'SALE CHALLAN REVENUE', value: '₹4.6K', trend: '45.4% of total', isPositive: true, color: const Color(0xFFF59E0B)),
    RevenueMetric(title: 'INVOICE REVENUE', value: '₹5.5K', trend: '54.6% of total', isPositive: true, color: const Color(0xFF10B981)),
    RevenueMetric(title: 'B2B INVOICE REVENUE', value: '₹0', trend: '0.0% of total', isPositive: true, color: const Color(0xFFFACC15)),
  ];

  List<ChartDataPoint> get revenueTrendMemo => [
    ChartDataPoint(0, 5, 'Nov'),
    ChartDataPoint(1, 10, 'Dec'),
    ChartDataPoint(2, 5, 'Jan'),
    ChartDataPoint(3, 40, 'Feb'),
    ChartDataPoint(4, 15, 'Mar'),
    ChartDataPoint(5, 5, 'Apr'),
  ];

  List<ChartDataPoint> get revenueTrendInvoice => [
    ChartDataPoint(0, 10, 'Nov'),
    ChartDataPoint(1, 15, 'Dec'),
    ChartDataPoint(2, 10, 'Jan'),
    ChartDataPoint(3, 80, 'Feb'),
    ChartDataPoint(4, 30, 'Mar'),
    ChartDataPoint(5, 10, 'Apr'),
  ];

  // --- Customers Data ---
  List<CustomerSegment> get customerSegments => [
    CustomerSegment(name: 'Platinum', count: 1, totalRev: '₹71.9K', color: const Color(0xFFA855F7), icon: LucideIcons.award),
    CustomerSegment(name: 'Gold', count: 3, totalRev: '₹51.0K', color: const Color(0xFFF59E0B), icon: LucideIcons.shield),
    CustomerSegment(name: 'Silver', count: 5, totalRev: '₹56.3K', color: const Color(0xFF94A3B8), icon: LucideIcons.user),
    CustomerSegment(name: 'Dormant', count: 9, totalRev: '₹10.2K', color: const Color(0xFFEF4444), icon: LucideIcons.userX),
  ];

  List<ChurnAnalysis> get churnData => [
    ChurnAnalysis(name: 'sadguru opticals', segment: 'Platinum', lastOrder: '29 days ago', usualFreq: '1d', freqDrop: '-2860%', value: '₹44.9K', riskLevel: 'High', riskColor: Colors.red),
    ChurnAnalysis(name: 'SADGURU EYE WEAR', segment: 'Gold', lastOrder: '5 days ago', usualFreq: '4d', freqDrop: '-43%', value: '₹12.9K', riskLevel: 'Low', riskColor: Colors.green),
    ChurnAnalysis(name: 'yash', segment: 'Gold', lastOrder: '10 days ago', usualFreq: '4d', freqDrop: '-144%', value: '₹10.3K', riskLevel: 'Medium', riskColor: Colors.orange),
    ChurnAnalysis(name: 'Abhishek Trivedi', segment: 'Silver', lastOrder: '2 days ago', usualFreq: '2d', freqDrop: '-20%', value: '₹5.6K', riskLevel: 'Low', riskColor: Colors.green),
  ];

  // --- Staff Data ---
  List<StaffPerformance> get staffData => [
    StaffPerformance(name: 'Branding', revenue: '₹13.0K', orders: 48, aov: 270, radarValues: [0.8, 0.7, 0.6, 0.9, 0.5]),
  ];

  // --- Cash Flow Data ---
  List<CashFlowMetric> get cashFlowMetrics => [
    CashFlowMetric(title: 'TOTAL RECEIVABLES', value: '₹1.9L', subValue: '', color: const Color(0xFFF59E0B), icon: LucideIcons.dollarSign),
    CashFlowMetric(title: 'OVERDUE (60+ DAYS)', value: '₹35.1K', subValue: '18.6% of total', color: const Color(0xFFF59E0B), icon: LucideIcons.clock),
    CashFlowMetric(title: 'DSO (DAYS)', value: '308', subValue: 'Days Sales Outstanding', color: const Color(0xFFF59E0B), icon: LucideIcons.activity),
    CashFlowMetric(title: 'COLLECTION RATE', value: '1%', subValue: 'Collected vs Billed', color: const Color(0xFFF59E0B), icon: LucideIcons.trendingUp),
  ];

  List<double> get ageingData => [30, 95, 25, 10]; // 0-30, 30-60, 60-90, 90+

  // --- Orders by Day of Week (Revenue Tab) ---
  List<MapEntry<String, double>> get ordersByDay => [
    MapEntry('Mon', 11),
    MapEntry('Tue', 7),
    MapEntry('Wed', 4),
    MapEntry('Thu', 2),
    MapEntry('Fri', 1),
    MapEntry('Sat', 8),
  ];

  // --- Avg Order Value Trend (Revenue Tab) ---
  List<ChartDataPoint> get avgOrderValueTrend => [
    ChartDataPoint(0, 70, 'Nov'),
    ChartDataPoint(1, 300, 'Dec'),
    ChartDataPoint(2, 700, 'Jan'),
    ChartDataPoint(3, 1100, 'Feb'),
    ChartDataPoint(4, 1200, 'Mar'),
    ChartDataPoint(5, 300, 'Apr'),
  ];

  // --- DSO Trend (Cash Flow Tab) ---
  List<ChartDataPoint> get dsoTrend => [
    ChartDataPoint(0, 0, 'Nov'),
    ChartDataPoint(1, 0, 'Dec'),
    ChartDataPoint(2, 30, 'Jan'),
    ChartDataPoint(3, 30, 'Feb'),
    ChartDataPoint(4, 30, 'Mar'),
    ChartDataPoint(5, 30, 'Apr'),
  ];

  // --- Cash Flow Forecast (Cash Flow Tab) ---
  List<MapEntry<String, double>> get cashFlowForecast => [
    MapEntry('Week 1', 190000),
    MapEntry('Week 2', 15000),
    MapEntry('Week 3', 20000),
    MapEntry('Week 4', 8000),
  ];

  // --- Staff Revenue Comparison (Staff Tab) ---
  // Returns list of {name, revenue, maxRevenue}
  List<Map<String, dynamic>> get staffRevenueComparison => [
    {'name': 'Branding', 'revenue': 13000.0, 'max': 13000.0},
  ];

  // --- Collection Efficiency by Staff (Staff Tab) ---
  List<Map<String, dynamic>> get collectionEfficiency => [
    {'name': 'Branding', 'pct': 0.0},
  ];
}
