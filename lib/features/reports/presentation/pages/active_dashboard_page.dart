import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../data/providers/analytics_provider.dart';
import '../../data/models/analytics_model.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ActiveDashboardPage extends StatefulWidget {
  const ActiveDashboardPage({super.key});

  @override
  State<ActiveDashboardPage> createState() => _ActiveDashboardPageState();
}

class _ActiveDashboardPageState extends State<ActiveDashboardPage> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnalyticsProvider>().loadAnalytics();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Consumer<AnalyticsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFF59E0B)));
          }

          return Column(
            children: [
              _buildHeader(provider),
              _buildTabNavigation(provider),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.02, 0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: SingleChildScrollView(
                    key: ValueKey<int>(provider.activeTabIndex),
                    padding: const EdgeInsets.all(24),
                    child: _buildActiveTab(provider),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(AnalyticsProvider provider) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Wholesale AI Analytics',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Powered by AI • Real-time data • Live API connected',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () => provider.loadAnalytics(),
            icon: const Icon(LucideIcons.refreshCw, size: 14),
            label: const Text('Refresh Data'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF59E0B).withValues(alpha: 0.1),
              foregroundColor: const Color(0xFFF59E0B),
              side: BorderSide(color: const Color(0xFFF59E0B).withValues(alpha: 0.3)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabNavigation(AnalyticsProvider provider) {
    final tabs = [
      {'label': 'Revenue', 'icon': LucideIcons.trendingUp},
      {'label': 'Customers', 'icon': LucideIcons.users},
      {'label': 'Staff', 'icon': LucideIcons.award},
      {'label': 'Cash Flow', 'icon': LucideIcons.dollarSign},
      {'label': 'AI Insights', 'icon': LucideIcons.zap, 'isAI': true},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(tabs.length, (index) {
          final isSelected = provider.activeTabIndex == index;
          final tab = tabs[index];
          final isAI = tab['isAI'] == true;

          return GestureDetector(
            onTap: () => provider.setActiveTab(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFF59E0B).withValues(alpha: 0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? const Color(0xFFF59E0B).withValues(alpha: 0.5) : Colors.transparent,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    tab['icon'] as IconData,
                    size: 18,
                    color: isSelected ? const Color(0xFFF59E0B) : Colors.white.withValues(alpha: 0.5),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    tab['label'] as String,
                    style: TextStyle(
                      color: isSelected ? const Color(0xFFF59E0B) : Colors.white.withValues(alpha: 0.5),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  if (isAI) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'AI',
                        style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildActiveTab(AnalyticsProvider provider) {
    switch (provider.activeTabIndex) {
      case 0:
        return _RevenueTab(provider: provider);
      case 1:
        return _CustomersTab(provider: provider);
      case 2:
        return _StaffTab(provider: provider);
      case 3:
        return _CashFlowTab(provider: provider);
      default:
        return Container(
          height: 400,
          alignment: Alignment.center,
          child: const Text('AI Insights Coming Soon', style: TextStyle(color: Colors.white54, fontSize: 18)),
        );
    }
  }
}

// --- Revenue Tab Components ---
class _RevenueTab extends StatelessWidget {
  final AnalyticsProvider provider;
  const _RevenueTab({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimationLimiter(
          child: GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 1.8,
            children: List.generate(provider.revenueMetrics.length, (index) {
              return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: const Duration(milliseconds: 500),
                columnCount: 4,
                child: ScaleAnimation(
                  child: FadeInAnimation(
                    child: _MetricCard(metric: provider.revenueMetrics[index]),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: _RevenueTrendChart(provider: provider)),
            const SizedBox(width: 24),
            Expanded(flex: 1, child: _RevenueConcentrationChart(provider: provider)),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _OrdersByDayChart(provider: provider)),
            const SizedBox(width: 24),
            Expanded(child: _AvgOrderValueChart(provider: provider)),
          ],
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final RevenueMetric metric;
  const _MetricCard({required this.metric});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(metric.title, style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
              Icon(LucideIcons.trendingUp, color: metric.color.withValues(alpha: 0.5), size: 16),
            ],
          ),
          Text(metric.value, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
          Row(
            children: [
              Icon(
                metric.isPositive ? LucideIcons.arrowUpRight : LucideIcons.arrowDownRight,
                color: metric.isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                metric.trend,
                style: TextStyle(
                  color: metric.isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RevenueTrendChart extends StatelessWidget {
  final AnalyticsProvider provider;
  const _RevenueTrendChart({required this.provider});

  @override
  Widget build(BuildContext context) {
    return _ChartContainer(
      title: 'Revenue Trend — Memo vs Invoice vs B2B',
      subtitle: 'Last 6 months',
      child: SizedBox(
        height: 300,
        child: LineChart(
          LineChartData(
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (touchedSpot) => const Color(0xFF1E293B),
                tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                tooltipRoundedRadius: 8,
                getTooltipItems: (List<LineBarSpot> touchedSpots) {
                  return touchedSpots.map((spot) {
                    return LineTooltipItem(
                      '₹${spot.y.toStringAsFixed(1)}K',
                      const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    );
                  }).toList();
                },
              ),
            ),
            gridData: const FlGridData(show: true, drawVerticalLine: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) => Text('₹${value.toInt()}K', style: const TextStyle(color: Colors.white24, fontSize: 10)),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < provider.revenueTrendMemo.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(provider.revenueTrendMemo[index].label, style: const TextStyle(color: Colors.white38, fontSize: 10)),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: provider.revenueTrendMemo.map((p) => FlSpot(p.x, p.y)).toList(),
                isCurved: true,
                color: const Color(0xFFF59E0B),
                barWidth: 3,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(show: true, color: const Color(0xFFF59E0B).withValues(alpha: 0.1)),
              ),
              LineChartBarData(
                spots: provider.revenueTrendInvoice.map((p) => FlSpot(p.x, p.y)).toList(),
                isCurved: true,
                color: const Color(0xFF4F46E5),
                barWidth: 3,
                dotData: FlDotData(show: true, checkToShowDot: (spot, barData) => spot.x == 3),
                belowBarData: BarAreaData(show: true, color: const Color(0xFF4F46E5).withValues(alpha: 0.2)),
              ),
            ],
          ),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutBack,
        ),
      ),
    );
  }
}

class _RevenueConcentrationChart extends StatefulWidget {
  final AnalyticsProvider provider;
  const _RevenueConcentrationChart({required this.provider});

  @override
  State<_RevenueConcentrationChart> createState() => _RevenueConcentrationChartState();
}

class _RevenueConcentrationChartState extends State<_RevenueConcentrationChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final data = [
      {'name': 'shaharyaar zayer', 'value': 66.0, 'color': const Color(0xFF4F46E5), 'valText': '₹8.5K'},
      {'name': 'Abhishek Trivedi', 'value': 30.0, 'color': const Color(0xFFA855F7), 'valText': '₹3.9K'},
      {'name': 'Other', 'value': 4.0, 'color': const Color(0xFF10B981).withValues(alpha: 0.5), 'valText': '₹0.5K'},
    ];

    return _ChartContainer(
      title: 'Revenue Concentration',
      subtitle: 'Top 5 customers',
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                        });
                      },
                      enabled: true,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 60,
                    sections: List.generate(data.length, (i) {
                      final isTouched = i == touchedIndex;
                      final radius = isTouched ? 35.0 : 25.0;
                      return PieChartSectionData(
                        color: data[i]['color'] as Color,
                        value: data[i]['value'] as double,
                        radius: radius,
                        showTitle: false,
                      );
                    }),
                  ),
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                ),
                if (touchedIndex != -1 && touchedIndex < data.length)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Text(
                      '${data[touchedIndex]['name']} : ${data[touchedIndex]['value']}% (${data[touchedIndex]['valText']})',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildLegendItem('shaharyaar zayer', '66%', const Color(0xFF4F46E5)),
          _buildLegendItem('Abhishek Trivedi', '30%', const Color(0xFFA855F7)),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String name, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Text(name, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12)),
            ],
          ),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }
}

class _CustomersTab extends StatelessWidget {
  final AnalyticsProvider provider;
  const _CustomersTab({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimationLimiter(
          child: GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 2.2,
            children: List.generate(provider.customerSegments.length, (index) {
              return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: const Duration(milliseconds: 500),
                columnCount: 4,
                child: FlipAnimation(
                  child: FadeInAnimation(
                    child: _CustomerCard(segment: provider.customerSegments[index]),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 24),
        _ChartContainer(
          title: 'Churn Risk & Segmentation Analysis',
          subtitle: 'Identifying at-risk accounts based on buying patterns',
          child: Column(
            children: [
              _buildTableHeader(),
              const Divider(color: Color(0xFF334155)),
              ...provider.churnData.map((d) => _buildChurnRow(d)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTableHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(flex: 3, child: _headerCell('CUSTOMER NAME')),
          Expanded(flex: 2, child: _headerCell('SEGMENT')),
          Expanded(flex: 2, child: _headerCell('LAST ORDER')),
          Expanded(flex: 2, child: _headerCell('USUAL FREQ.')),
          Expanded(flex: 2, child: _headerCell('FREQ. DROP')),
          Expanded(flex: 2, child: _headerCell('MONTHLY VALUE')),
          Expanded(flex: 2, child: _headerCell('RISK LEVEL')),
        ],
      ),
    );
  }

  Widget _headerCell(String text) {
    return Text(text, style: const TextStyle(color: Colors.white24, fontSize: 10, fontWeight: FontWeight.w900));
  }

  Widget _buildChurnRow(ChurnAnalysis d) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(d.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(4)),
              child: Text(d.segment, style: const TextStyle(color: Colors.white60, fontSize: 10)),
            ),
          ),
          Expanded(flex: 2, child: Text(d.lastOrder, style: const TextStyle(color: Colors.white54, fontSize: 13))),
          Expanded(flex: 2, child: Text(d.usualFreq, style: const TextStyle(color: Colors.white54, fontSize: 13))),
          Expanded(flex: 2, child: Text(d.freqDrop, style: const TextStyle(color: Color(0xFFEF4444), fontSize: 13, fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text(d.value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13))),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(width: 6, height: 6, decoration: BoxDecoration(color: d.riskColor, shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Text(d.riskLevel, style: TextStyle(color: d.riskColor, fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  final CustomerSegment segment;
  const _CustomerCard({required this.segment});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: segment.color.withValues(alpha: 0.3)),
      ),
      child: Stack(
        children: [
          Positioned(left: 0, top: 0, bottom: 0, child: Container(width: 4, decoration: BoxDecoration(color: segment.color, borderRadius: const BorderRadius.horizontal(left: Radius.circular(12))))),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(segment.name, style: TextStyle(color: segment.color, fontWeight: FontWeight.bold, fontSize: 14)),
                    Icon(segment.icon, color: segment.color.withValues(alpha: 0.5), size: 16),
                  ],
                ),
                Text('${segment.count}', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
                Text('Total Rev: ${segment.totalRev}', style: const TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StaffTab extends StatelessWidget {
  final AnalyticsProvider provider;
  const _StaffTab({required this.provider});

  @override
  Widget build(BuildContext context) {
    final staff = provider.staffData[0];
    return Column(
      children: [
        // Hero Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Column(
            children: [
              Icon(LucideIcons.award, color: const Color(0xFFF59E0B), size: 28),
              const SizedBox(height: 12),
              Text(staff.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(staff.revenue, style: const TextStyle(color: Color(0xFFFACC15), fontSize: 36, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              Text('${staff.orders} orders - AOV ₹${staff.aov}', style: const TextStyle(color: Colors.white38, fontSize: 13)),
            ],
          ),
        ),
        // Staff Revenue Comparison + Radar side by side
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _StaffRevenueComparison(provider: provider)),
            const SizedBox(width: 24),
            Expanded(
              child: _ChartContainer(
                title: 'Performance Radar',
                subtitle: 'Multi-dimensional comparison (Top 3)',
                child: SizedBox(
                  height: 300,
                  child: RadarChart(
                    RadarChartData(
                      radarTouchData: RadarTouchData(enabled: true),
                      radarShape: RadarShape.polygon,
                      dataSets: [
                        RadarDataSet(
                          fillColor: const Color(0xFF4F46E5).withValues(alpha: 0.4),
                          borderColor: const Color(0xFF4F46E5),
                          entryRadius: 3,
                          dataEntries: staff.radarValues.map((v) => RadarEntry(value: v)).toList(),
                        ),
                      ],
                      tickCount: 5,
                      gridBorderData: const BorderSide(color: Colors.white10),
                      getTitle: (index, angle) {
                        const titles = ['Revenue', 'Volume', 'AOV', 'Collection', 'New Cust.'];
                        return RadarChartTitle(text: titles[index], angle: angle);
                      },
                      titleTextStyle: const TextStyle(color: Colors.white38, fontSize: 10),
                    ),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.decelerate,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _CollectionEfficiencyWidget(provider: provider),
      ],
    );
  }
}

class _CashFlowTab extends StatelessWidget {
  final AnalyticsProvider provider;
  const _CashFlowTab({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _ChartContainer(
              title: 'Receivables Aging',
              subtitle: 'Outstanding by time bucket',
              child: SizedBox(
                height: 280,
                child: BarChart(
                  BarChartData(
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (group) => const Color(0xFF1E293B),
                        tooltipRoundedRadius: 8,
                      ),
                    ),
                    gridData: const FlGridData(show: false),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const titles = ['0-30', '30-60', '60-90', '90+'];
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text('${titles[value.toInt()]} Days', style: const TextStyle(color: Colors.white38, fontSize: 9)),
                            );
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: [
                      BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 30, color: const Color(0xFFEF4444).withValues(alpha: 0.8), width: 50)]),
                      BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 95, color: const Color(0xFFEF4444), width: 50)]),
                      BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 25, color: const Color(0xFFEF4444).withValues(alpha: 0.6), width: 50)]),
                      BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 5, color: const Color(0xFFEF4444).withValues(alpha: 0.3), width: 50)]),
                    ],
                  ),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.elasticOut,
                ),
              ),
            )),
            const SizedBox(width: 24),
            Expanded(child: _DsoTrendChart(provider: provider)),
          ],
        ),
        const SizedBox(height: 24),
        _CashFlowForecastChart(provider: provider),
      ],
    );
  }
}

// --- Common UI Components ---
class _ChartContainer extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  const _ChartContainer({required this.title, required this.subtitle, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 13)),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }
}

// ─── NEW: Orders by Day of Week ───────────────────────────────────────────────
class _OrdersByDayChart extends StatelessWidget {
  final AnalyticsProvider provider;
  const _OrdersByDayChart({required this.provider});

  @override
  Widget build(BuildContext context) {
    final days = provider.ordersByDay;
    return _ChartContainer(
      title: 'Orders by Day of Week',
      subtitle: 'Helps plan staffing',
      child: SizedBox(
        height: 220,
        child: BarChart(
          BarChartData(
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (_) => const Color(0xFF0F172A),
                tooltipRoundedRadius: 8,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    '${days[group.x].key}\n${rod.toY.toInt()} orders',
                    const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  );
                },
              ),
            ),
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (val, meta) {
                    final i = val.toInt();
                    if (i < 0 || i >= days.length) return const SizedBox();
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(days[i].key, style: const TextStyle(color: Colors.white38, fontSize: 11)),
                    );
                  },
                ),
              ),
              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            barGroups: List.generate(days.length, (i) => BarChartGroupData(
              x: i,
              barRods: [BarChartRodData(
                toY: days[i].value,
                color: const Color(0xFFF59E0B),
                width: 28,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
              )],
            )),
          ),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        ),
      ),
    );
  }
}

// ─── NEW: Avg Order Value Trend ───────────────────────────────────────────────
class _AvgOrderValueChart extends StatelessWidget {
  final AnalyticsProvider provider;
  const _AvgOrderValueChart({required this.provider});

  @override
  Widget build(BuildContext context) {
    final pts = provider.avgOrderValueTrend;
    return _ChartContainer(
      title: 'Avg Order Value Trend',
      subtitle: 'Last 6 months',
      child: SizedBox(
        height: 220,
        child: LineChart(
          LineChartData(
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (_) => const Color(0xFF0F172A),
                tooltipRoundedRadius: 8,
                getTooltipItems: (spots) => spots.map((s) =>
                  LineTooltipItem('₹${s.y.toStringAsFixed(0)}', const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))
                ).toList(),
              ),
            ),
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (val, meta) {
                    final i = val.toInt();
                    if (i < 0 || i >= pts.length) return const SizedBox();
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(pts[i].label, style: const TextStyle(color: Colors.white38, fontSize: 10)),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (val, meta) => Text('₹${val.toInt()}', style: const TextStyle(color: Colors.white24, fontSize: 9)),
                ),
              ),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            lineBarsData: [LineChartBarData(
              spots: pts.map((p) => FlSpot(p.x, p.y)).toList(),
              isCurved: true,
              color: const Color(0xFF10B981),
              barWidth: 3,
              dotData: FlDotData(show: true, checkToShowDot: (_, b) => true),
              belowBarData: BarAreaData(show: true, color: const Color(0xFF10B981).withValues(alpha: 0.1)),
            )],
          ),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        ),
      ),
    );
  }
}

// ─── NEW: Staff Revenue Comparison ────────────────────────────────────────────
class _StaffRevenueComparison extends StatelessWidget {
  final AnalyticsProvider provider;
  const _StaffRevenueComparison({required this.provider});

  @override
  Widget build(BuildContext context) {
    final items = provider.staffRevenueComparison;
    return _ChartContainer(
      title: 'Staff Revenue Comparison',
      subtitle: 'This month',
      child: Column(
        children: items.map((item) {
          final pct = item['max'] > 0 ? (item['revenue'] as double) / (item['max'] as double) : 0.0;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                SizedBox(width: 80, child: Text(item['name'] as String, style: const TextStyle(color: Colors.white60, fontSize: 13))),
                const SizedBox(width: 12),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: pct,
                      minHeight: 20,
                      backgroundColor: Colors.white10,
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF59E0B)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text('₹${((item['revenue'] as double) / 1000).toStringAsFixed(1)}K',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── NEW: Collection Efficiency by Staff ──────────────────────────────────────
class _CollectionEfficiencyWidget extends StatelessWidget {
  final AnalyticsProvider provider;
  const _CollectionEfficiencyWidget({required this.provider});

  @override
  Widget build(BuildContext context) {
    final items = provider.collectionEfficiency;
    return _ChartContainer(
      title: 'Collection Efficiency by Staff',
      subtitle: '% of receivables collected on time',
      child: Column(
        children: items.map((item) {
          final pct = (item['pct'] as double);
          final color = pct >= 75 ? const Color(0xFF10B981) : pct >= 40 ? const Color(0xFFF59E0B) : const Color(0xFFEF4444);
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${pct.toStringAsFixed(0)}%',
                      style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.w900)),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(item['name'] as String,
                    style: const TextStyle(color: Colors.white54, fontSize: 13)),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── NEW: DSO Trend ───────────────────────────────────────────────────────────
class _DsoTrendChart extends StatelessWidget {
  final AnalyticsProvider provider;
  const _DsoTrendChart({required this.provider});

  @override
  Widget build(BuildContext context) {
    final pts = provider.dsoTrend;
    return _ChartContainer(
      title: 'DSO Trend',
      subtitle: 'Days Sales Outstanding — last 6 months',
      child: SizedBox(
        height: 280,
        child: LineChart(
          LineChartData(
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (_) => const Color(0xFF0F172A),
                tooltipRoundedRadius: 8,
                getTooltipItems: (spots) => spots.map((s) =>
                  LineTooltipItem('${s.y.toStringAsFixed(0)} days', const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))
                ).toList(),
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (_) => const FlLine(color: Colors.white10, strokeWidth: 1),
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (val, meta) {
                    final i = val.toInt();
                    if (i < 0 || i >= pts.length) return const SizedBox();
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(pts[i].label, style: const TextStyle(color: Colors.white38, fontSize: 10)),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 28,
                  getTitlesWidget: (val, meta) => Text('${val.toInt()}', style: const TextStyle(color: Colors.white24, fontSize: 9)),
                ),
              ),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            lineBarsData: [LineChartBarData(
              spots: pts.map((p) => FlSpot(p.x, p.y)).toList(),
              isCurved: true,
              color: const Color(0xFFF59E0B),
              barWidth: 3,
              dotData: FlDotData(show: true, checkToShowDot: (_, b) => true),
              belowBarData: BarAreaData(show: true, color: const Color(0xFFF59E0B).withValues(alpha: 0.1)),
            )],
          ),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOut,
        ),
      ),
    );
  }
}

// ─── NEW: Cash Flow Forecast ──────────────────────────────────────────────────
class _CashFlowForecastChart extends StatelessWidget {
  final AnalyticsProvider provider;
  const _CashFlowForecastChart({required this.provider});

  @override
  Widget build(BuildContext context) {
    final forecast = provider.cashFlowForecast;
    final maxVal = forecast.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    return _ChartContainer(
      title: 'Cash Flow Forecast',
      subtitle: 'Expected collections for next 4 weeks',
      child: SizedBox(
        height: 260,
        child: BarChart(
          BarChartData(
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (_) => const Color(0xFF0F172A),
                tooltipRoundedRadius: 8,
                getTooltipItem: (group, gi, rod, ri) {
                  final val = rod.toY;
                  final label = val >= 100000 ? '₹${(val / 100000).toStringAsFixed(1)}L' : '₹${(val / 1000).toStringAsFixed(0)}K';
                  return BarTooltipItem(
                    '${forecast[group.x].key}\n$label',
                    const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  );
                },
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (_) => const FlLine(color: Colors.white10, strokeWidth: 1),
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (val, meta) {
                    final i = val.toInt();
                    if (i < 0 || i >= forecast.length) return const SizedBox();
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(forecast[i].key, style: const TextStyle(color: Colors.white38, fontSize: 11)),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 46,
                  getTitlesWidget: (val, meta) {
                    final label = val >= 100000 ? '₹${(val / 100000).toStringAsFixed(1)}L' : '₹${(val / 1000).toStringAsFixed(0)}K';
                    return Text(label, style: const TextStyle(color: Colors.white24, fontSize: 9));
                  },
                ),
              ),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            maxY: maxVal * 1.2,
            barGroups: List.generate(forecast.length, (i) => BarChartGroupData(
              x: i,
              barRods: [BarChartRodData(
                toY: forecast[i].value,
                color: const Color(0xFF10B981),
                width: 40,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
              )],
            )),
          ),
          duration: const Duration(milliseconds: 600),
          curve: Curves.elasticOut,
        ),
      ),
    );
  }
}
