import 'package:flutter/material.dart';

class RevenueMetric {
  final String title;
  final String value;
  final String trend;
  final bool isPositive;
  final Color color;

  RevenueMetric({
    required this.title,
    required this.value,
    required this.trend,
    required this.isPositive,
    required this.color,
  });
}

class ChartDataPoint {
  final double x;
  final double y;
  final String label;

  ChartDataPoint(this.x, this.y, [this.label = '']);
}

class CustomerSegment {
  final String name;
  final int count;
  final String totalRev;
  final Color color;
  final IconData icon;

  CustomerSegment({
    required this.name,
    required this.count,
    required this.totalRev,
    required this.color,
    required this.icon,
  });
}

class ChurnAnalysis {
  final String name;
  final String segment;
  final String lastOrder;
  final String usualFreq;
  final String freqDrop;
  final String value;
  final String riskLevel;
  final Color riskColor;

  ChurnAnalysis({
    required this.name,
    required this.segment,
    required this.lastOrder,
    required this.usualFreq,
    required this.freqDrop,
    required this.value,
    required this.riskLevel,
    required this.riskColor,
  });
}

class StaffPerformance {
  final String name;
  final String revenue;
  final int orders;
  final int aov;
  final List<double> radarValues; // [Revenue, Volume, AOV, Collection, New Cust]

  StaffPerformance({
    required this.name,
    required this.revenue,
    required this.orders,
    required this.aov,
    required this.radarValues,
  });
}

class CashFlowMetric {
  final String title;
  final String value;
  final String subValue;
  final Color color;
  final IconData icon;

  CashFlowMetric({
    required this.title,
    required this.value,
    required this.subValue,
    required this.color,
    required this.icon,
  });
}
