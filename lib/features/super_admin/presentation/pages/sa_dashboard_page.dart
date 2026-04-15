import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/network/api_client.dart';

class SADashboardPage extends StatefulWidget {
  const SADashboardPage({super.key});

  @override
  State<SADashboardPage> createState() => _SADashboardPageState();
}

class _SADashboardPageState extends State<SADashboardPage> {
  final Map<String, dynamic> _stats = {
    'totalCompanies': 0,
    'totalUsers': 0,
    'activeCompanies': 0,
    'inactiveCompanies': 0,
    'totalSales': 0,
    'totalOrders': 0,
    'recentActivities': []
  };
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    try {
      final res = await apiClient.dio.get('/super-admin/dashboard');
      if (mounted) {
        setState(() {
          _stats.addAll(res.data as Map<String, dynamic>);
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Dashboard error: $e");
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Text("Loading Dashboard...", style: TextStyle(color: Color(0xFF64748B))),
      );
    }

    final activities = _stats['recentActivities'] as List<dynamic>? ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            "Super Admin Overview",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Color(0xFF0F172A), letterSpacing: -0.5),
          ),
          const SizedBox(height: 8),
          const Text(
            "Manage all aspects of your SaaS platform from one central control panel.",
            style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 32),

          // Stat Cards Grid
          Wrap(
            spacing: 24,
            runSpacing: 24,
            children: [
              _buildStatCard(
                title: "Total Companies",
                value: _stats['totalCompanies'].toString(),
                icon: LucideIcons.building2,
                color: const Color(0xFF6366F1), // indigo-500
              ),
              _buildStatCard(
                title: "Total Users",
                value: _stats['totalUsers'].toString(),
                icon: LucideIcons.users,
                color: const Color(0xFF10B981), // emerald-500
              ),
              _buildStatCard(
                title: "Active Accounts",
                value: _stats['activeCompanies'].toString(),
                icon: LucideIcons.shieldCheck,
                color: const Color(0xFF3B82F6), // blue-500
              ),
              _buildStatCard(
                title: "Potential Alerts",
                value: _stats['inactiveCompanies'].toString(),
                icon: LucideIcons.alertCircle,
                color: const Color(0xFFF59E0B), // amber-500
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Lower Section
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // System Health (2/3 width)
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFF1F5F9)),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: Color(0xFFF8FAFC))),
                        ),
                        child: const Text("System Health & Distribution", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1E293B))),
                      ),
                      SizedBox(
                        height: 300,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(LucideIcons.activity, size: 48, color: Color(0xFFCBD5E1)),
                              SizedBox(width: 16),
                              Text("Analytics visualization coming soon", style: TextStyle(color: Color(0xFF94A3B8), fontStyle: FontStyle.italic, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 32),

              // Recent System Logs (1/3 width)
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFF1F5F9)),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: Color(0xFFF8FAFC))),
                        ),
                        child: const Text("Recent System Logs", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1E293B))),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: activities.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 32),
                                child: Text("No recent activity found", textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF94A3B8), fontStyle: FontStyle.italic)),
                              )
                            : Column(
                                children: activities.map((log) {
                                  // Example format mapping
                                  final msg = log['action'] ?? 'Unknown Action';
                                  final dateStr = log['timestamp'] ?? '';
                                  final parsedDate = DateTime.tryParse(dateStr);
                                  
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 8, height: 8, margin: const EdgeInsets.only(top: 6),
                                          decoration: BoxDecoration(color: Colors.blue.shade500, shape: BoxShape.circle),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(msg, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF334155), fontSize: 13)),
                                              if (parsedDate != null)
                                                Text(parsedDate.toLocal().toString().split('.')[0], style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStatCard({required String title, required String value, required IconData icon, required Color color}) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)), // slate-100
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Color(0xFF64748B), fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(color: Color(0xFF1E293B), fontSize: 28, fontWeight: FontWeight.w800)),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          )
        ],
      ),
    );
  }
}
