import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:excel/excel.dart' as xl;
import 'package:file_picker/file_picker.dart';
import '../../data/models/operational_report_model.dart';
import '../../data/providers/operational_report_provider.dart';
import '../../../../core/network/api_client.dart';
import '../../../masters/data/providers/account_provider.dart';
import '../../../masters/data/models/account_model.dart';

class SalesGrowthComparisonPage extends StatefulWidget {
  const SalesGrowthComparisonPage({Key? key}) : super(key: key);
  @override
  _SalesGrowthComparisonPageState createState() =>
      _SalesGrowthComparisonPageState();
}

class _SalesGrowthComparisonPageState extends State<SalesGrowthComparisonPage> {
  final NumberFormat _fmt = NumberFormat('#,##,##0.00', 'en_IN');
  final NumberFormat _fmtInt = NumberFormat('#,##,##0', 'en_IN');

  String _selectedMonth = DateTime.now().month.toString();
  String _selectedYear = DateTime.now().year.toString();
  String _partyName = '';
  String _activeView = 'table';
  String _sortKey = 'currSales';
  String _sortDir = 'desc';

  bool _isInit = true;
  bool _searched = false;

  final TextEditingController _partyCtrl = TextEditingController();

  final List<String> _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountProvider>().fetchAllAccounts();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _loadData();
      _isInit = false;
    }
  }



  void _loadData() {
    final provider = Provider.of<OperationalReportProvider>(
      context,
      listen: false,
    );
    provider
        .fetchSalesGrowthComparisonReport({
          'month': _selectedMonth,
          'year': _selectedYear,
          'partyName': _partyName,
        })
        .then((_) {
          setState(() => _searched = true);
        });
  }

  void _reset() {
    setState(() {
      _selectedMonth = DateTime.now().month.toString();
      _selectedYear = DateTime.now().year.toString();
      _partyCtrl.clear();
      _partyName = '';
      _searched = false;
    });
    _loadData();
  }

  void _handleSort(String key) {
    setState(() {
      if (_sortKey == key) {
        _sortDir = _sortDir == 'asc' ? 'desc' : 'asc';
      } else {
        _sortKey = key;
        _sortDir = 'desc';
      }
    });
  }

  List<SalesGrowthDetail> _getSortedData(List<SalesGrowthDetail> data) {
    final list = List<SalesGrowthDetail>.from(data);
    list.sort((a, b) {
      dynamic valA;
      dynamic valB;
      switch (_sortKey) {
        case 'partyName':
          valA = a.partyName.toLowerCase();
          valB = b.partyName.toLowerCase();
          break;
        case 'currSales':
          valA = a.currSales;
          valB = b.currSales;
          break;
        case 'prevSales':
          valA = a.prevSales;
          valB = b.prevSales;
          break;
        case 'lySales':
          valA = a.lySales;
          valB = b.lySales;
          break;
        case 'momGrowth':
          valA = a.momGrowth ?? -999999.0;
          valB = b.momGrowth ?? -999999.0;
          break;
        case 'yoyGrowth':
          valA = a.yoyGrowth ?? -999999.0;
          valB = b.yoyGrowth ?? -999999.0;
          break;
        default:
          valA = a.currSales;
          valB = b.currSales;
      }
      if (valA is String && valB is String) {
        return _sortDir == 'asc' ? valA.compareTo(valB) : valB.compareTo(valA);
      }
      return _sortDir == 'asc' ? valA.compareTo(valB) : valB.compareTo(valA);
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OperationalReportProvider>(context);
    final report = provider.salesGrowthReport;
    final summary = report?.summary;
    final rawData = report?.data ?? [];
    final sortedData = _getSortedData(rawData);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Row(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
              ),
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(24),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _buildHeader(provider, sortedData, summary),
                        const SizedBox(height: 20),
                        _buildSearchFilters(provider),
                        const SizedBox(height: 20),
                        if (summary != null) ...[
                          _buildSummaryCards(summary),
                          const SizedBox(height: 20),
                        ],
                        if (report != null &&
                            report.success &&
                            rawData.isNotEmpty &&
                            summary != null) ...[
                          _buildInsights(rawData, summary),
                          const SizedBox(height: 20),
                        ],
                        if (_activeView == 'table')
                          _buildTableView(sortedData, summary),
                        if (_activeView == 'chart')
                          _buildChartView(sortedData, summary),
                        const SizedBox(height: 40),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    OperationalReportProvider provider,
    List<SalesGrowthDetail> sortedData,
    SalesGrowthSummary? summary,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade600,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        LucideIcons.trendingUp,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Sales Growth Comparison Report',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  summary != null
                      ? '${summary.currLabel} vs ${summary.prevLabel} vs ${summary.lyLabel}'
                      : 'Compare sales across 3 time periods',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    _toggleBtn('table', 'Table', LucideIcons.clipboardList),
                    const SizedBox(width: 4),
                    _toggleBtn('chart', 'Chart', LucideIcons.barChart2),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _actionBtn(
                'Excel',
                LucideIcons.fileSpreadsheet,
                Colors.white,
                () => _exportExcel(sortedData, summary),
                isLight: true,
              ),
              const SizedBox(width: 12),
              _actionBtn(
                'Print',
                LucideIcons.printer,
                const Color(0xFF0F172A),
                () => _printPdf(sortedData, summary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _toggleBtn(String val, String label, IconData icon) {
    final active = _activeView == val;
    return InkWell(
      onTap: () => setState(() => _activeView = val),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: active ? Colors.blue.shade50 : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: active ? Colors.blue.shade600 : Colors.grey.shade500,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: active ? Colors.blue.shade600 : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionBtn(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap, {
    bool isLight = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: isLight ? Border.all(color: Colors.grey.shade200) : null,
          boxShadow: isLight ? null : [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isLight ? Colors.grey.shade700 : Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isLight ? Colors.grey.shade700 : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchFilters(OperationalReportProvider provider) {
    final years = List.generate(6, (i) => (DateTime.now().year - i).toString());

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'MONTH',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF64748B),
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedMonth,
                      items: List.generate(
                        12,
                        (i) => DropdownMenuItem(
                          value: (i + 1).toString(),
                          child: Text(
                            _monthNames[i],
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                      onChanged: (v) => setState(() => _selectedMonth = v!),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'YEAR',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF64748B),
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedYear,
                      items: years
                          .map(
                            (y) => DropdownMenuItem(
                              value: y,
                              child: Text(
                                y,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _selectedYear = v!),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PARTY NAME',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF64748B),
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Consumer<AccountProvider>(
                  builder: (context, accProv, _) => Autocomplete<AccountModel>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.isEmpty) {
                        return const Iterable<AccountModel>.empty();
                      }
                      return accProv.accounts.where((AccountModel option) {
                        return option.name.toLowerCase().contains(textEditingValue.text.toLowerCase());
                      });
                    },
                    displayStringForOption: (AccountModel option) => option.name,
                    onSelected: (AccountModel selection) {
                      _partyCtrl.text = selection.name;
                      _partyName = selection.name;
                      _loadData();
                    },
                    fieldViewBuilder: (context, textController, focusNode, onFieldSubmitted) {
                      if (textController.text != _partyCtrl.text) {
                        textController.text = _partyCtrl.text;
                      }
                      return Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: textController,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            hintText: 'Search Party...',
                            hintStyle: const TextStyle(fontSize: 13),
                            prefixIcon: const Icon(LucideIcons.search, size: 16, color: Colors.grey),
                            suffixIcon: _partyCtrl.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(LucideIcons.x, size: 16),
                                    onPressed: () {
                                      textController.clear();
                                      _partyCtrl.clear();
                                      setState(() => _partyName = '');
                                      _loadData();
                                    },
                                  )
                                : null,
                          ),
                          style: const TextStyle(fontSize: 13),
                          onChanged: (val) {
                            _partyCtrl.text = val;
                            setState(() => _partyName = val);
                            if (val.isEmpty) _loadData();
                          },
                          onSubmitted: (_) => _loadData(),
                        ),
                      );
                    },
                    optionsViewBuilder: (context, onSelected, options) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          elevation: 4,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 300,
                            constraints: const BoxConstraints(maxHeight: 300),
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: options.length,
                              itemBuilder: (BuildContext context, int index) {
                                final AccountModel option = options.elementAt(index);
                                return InkWell(
                                  onTap: () => onSelected(option),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(option.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            height: 48,
            child: ElevatedButton.icon(
              onPressed: provider.isLoading ? null : _loadData,
              icon: provider.isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(LucideIcons.search, size: 16),
              label: const Text(
                'Search',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 48,
            child: OutlinedButton(
              onPressed: _reset,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFE2E8F0)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Icon(
                LucideIcons.rotateCcw,
                size: 16,
                color: Color(0xFF64748B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(SalesGrowthSummary summary) {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            summary.currLabel,
            '₹${_fmt.format(summary.currTotal)}',
            'Current period sales',
            LucideIcons.indianRupee,
            [const Color(0xFF4F46E5), const Color(0xFF3730A3)],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _statCard(
            summary.prevLabel,
            '₹${_fmt.format(summary.prevTotal)}',
            'Previous month sales',
            LucideIcons.calendar,
            [const Color(0xFF3B82F6), const Color(0xFF1D4ED8)],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _statCard(
            summary.lyLabel,
            '₹${_fmt.format(summary.lyTotal)}',
            'Last year same month',
            LucideIcons.barChart2,
            [const Color(0xFF8B5CF6), const Color(0xFF6D28D9)],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _statCard(
            'Month-over-Month',
            '${summary.momGrowthPct >= 0 ? '+' : ''}${summary.momGrowthPct}%',
            '${summary.growingParties} growing parties',
            summary.momGrowthPct >= 0
                ? LucideIcons.trendingUp
                : LucideIcons.trendingDown,
            summary.momGrowthPct >= 0
                ? [const Color(0xFF10B981), const Color(0xFF047857)]
                : [const Color(0xFFF43F5E), const Color(0xFFBE123C)],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _statCard(
            'Year-over-Year',
            '${summary.yoyGrowthPct >= 0 ? '+' : ''}${summary.yoyGrowthPct}%',
            'vs ${summary.lyLabel}',
            summary.yoyGrowthPct >= 0
                ? LucideIcons.trendingUp
                : LucideIcons.trendingDown,
            summary.yoyGrowthPct >= 0
                ? [const Color(0xFF14B8A6), const Color(0xFF0F766E)]
                : [const Color(0xFFF59E0B), const Color(0xFFB45309)],
          ),
        ),
      ],
    );
  }

  Widget _statCard(
    String label,
    String value,
    String sub,
    IconData icon,
    List<Color> colors,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade500,
                  letterSpacing: 1,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: colors.first.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: colors.first, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sub,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildInsights(
    List<SalesGrowthDetail> data,
    SalesGrowthSummary summary,
  ) {
    final List<Map<String, dynamic>> tips = [];
    if (summary.momGrowthPct > 0) {
      tips.add({
        'icon': '📈',
        'text':
            'Overall sales grew by ${summary.momGrowthPct}% compared to previous month',
        'type': 'good',
      });
    } else if (summary.momGrowthPct < 0) {
      tips.add({
        'icon': '📉',
        'text':
            'Overall sales declined by ${summary.momGrowthPct.abs()}% compared to previous month',
        'type': 'bad',
      });
    }

    SalesGrowthDetail? topGrower;
    double maxG = -999999;
    SalesGrowthDetail? topDecliner;
    double minG = 999999;

    for (var d in data) {
      if (d.momGrowth != null) {
        if (d.momGrowth! > maxG) {
          maxG = d.momGrowth!;
          topGrower = d;
        }
        if (d.momGrowth! < minG) {
          minG = d.momGrowth!;
          topDecliner = d;
        }
      }
    }

    if (topGrower != null && topGrower.momGrowth != null) {
      tips.add({
        'icon': '⭐',
        'text':
            '${topGrower.partyName} had highest growth at +${topGrower.momGrowth}%',
        'type': 'info',
      });
    }
    if (topDecliner != null &&
        topDecliner.momGrowth != null &&
        topDecliner.momGrowth! < 0) {
      tips.add({
        'icon': '⚠️',
        'text':
            '${topDecliner.partyName} had biggest decline at ${topDecliner.momGrowth}%',
        'type': 'warn',
      });
    }
    tips.add({
      'icon': '👥',
      'text':
          '${summary.growingParties} growing vs ${summary.degrowingParties} declining parties this month',
      'type': 'info',
    });

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEEF2FF), Color(0xFFEFF6FF)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E7FF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(LucideIcons.zap, size: 16, color: Color(0xFF4338CA)),
              SizedBox(width: 8),
              Text(
                'Key Insights',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3730A3),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: tips.map((t) {
              Color bg;
              Color text;
              Color border;
              if (t['type'] == 'good') {
                bg = const Color(0xFFECFDF5);
                text = const Color(0xFF065F46);
                border = const Color(0xFFD1FAE5);
              } else if (t['type'] == 'bad') {
                bg = const Color(0xFFFFF1F2);
                text = const Color(0xFF9F1239);
                border = const Color(0xFFFFE4E6);
              } else if (t['type'] == 'warn') {
                bg = const Color(0xFFFFFBEB);
                text = const Color(0xFF92400E);
                border = const Color(0xFFFEF3C7);
              } else {
                bg = Colors.white;
                text = const Color(0xFF334155);
                border = const Color(0xFFF1F5F9);
              }

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(t['icon']),
                    const SizedBox(width: 8),
                    Text(
                      t['text'],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: text,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTableView(
    List<SalesGrowthDetail> data,
    SalesGrowthSummary? summary,
  ) {
    if (data.isEmpty) {
      return Container(
        height: 300,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.barChart2, size: 40, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              _searched
                  ? 'No data for selected filters'
                  : 'Click search to load report',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${data.length} Parties — sorted by $_sortKey',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF334155),
                  ),
                ),
                Row(
                  children: const [
                    Icon(
                      LucideIcons.arrowUpRight,
                      size: 14,
                      color: Color(0xFF059669),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Growth',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF059669),
                      ),
                    ),
                    SizedBox(width: 16),
                    Icon(
                      LucideIcons.arrowDownRight,
                      size: 14,
                      color: Color(0xFFE11D48),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Degrowth',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE11D48),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            color: Colors.blueGrey.shade800,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                SizedBox(
                  width: 60,
                  child: Center(child: Text('SR', style: _hStyle())),
                ),
                Expanded(
                  flex: 3,
                  child: _sortableCol('Party Name', 'partyName'),
                ),
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _sortableCol(
                      summary?.currLabel ?? 'Current',
                      'currSales',
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _sortableCol(
                      summary?.prevLabel ?? 'Previous',
                      'prevSales',
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _sortableCol(
                      summary?.lyLabel ?? 'Last Year',
                      'lySales',
                    ),
                  ),
                ),
                Expanded(
                  child: Center(child: _sortableCol('MoM%', 'momGrowth')),
                ),
                Expanded(
                  child: Center(child: _sortableCol('YoY%', 'yoyGrowth')),
                ),
                Expanded(
                  flex: 2,
                  child: Center(child: Text('MoM Status', style: _hStyle())),
                ),
                Expanded(
                  child: Center(child: Text('Invoices', style: _hStyle())),
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.length,
            itemBuilder: (ctx, i) {
              final d = data[i];
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 60,
                      child: Center(
                        child: Text(
                          (i + 1).toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        d.partyName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '₹${_fmt.format(d.currSales)}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4338CA),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '₹${_fmt.format(d.prevSales)}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF475569),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '₹${_fmt.format(d.lySales)}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),
                    Expanded(child: Center(child: _growthPill(d.momGrowth))),
                    Expanded(child: Center(child: _growthPill(d.yoyGrowth))),
                    Expanded(
                      flex: 2,
                      child: Center(child: _statusBadge(d.momStatus)),
                    ),
                    Expanded(
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            d.currInvoices.toString(),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          if (summary != null)
            Container(
              color: Colors.grey.shade100,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  SizedBox(width: 60),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'GRAND TOTAL',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '₹${_fmt.format(summary.currTotal)}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '₹${_fmt.format(summary.prevTotal)}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '₹${_fmt.format(summary.lyTotal)}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(child: _growthPill(summary.momGrowthPct)),
                  ),
                  Expanded(
                    child: Center(child: _growthPill(summary.yoyGrowthPct)),
                  ),
                  Expanded(flex: 2, child: const SizedBox()),
                  Expanded(child: const SizedBox()),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildChartView(
    List<SalesGrowthDetail> data,
    SalesGrowthSummary? summary,
  ) {
    if (data.isEmpty) return const SizedBox();

    final top10 = data.take(10).toList();
    double maxVal = 1;
    for (var r in top10) {
      if (r.currSales > maxVal) maxVal = r.currSales;
      if (r.prevSales > maxVal) maxVal = r.prevSales;
      if (r.lySales > maxVal) maxVal = r.lySales;
    }

    final topGrowers = List<SalesGrowthDetail>.from(
      data.where((e) => e.momStatus == 'Growth'),
    );
    topGrowers.sort((a, b) => (b.momGrowth ?? 0).compareTo(a.momGrowth ?? 0));

    final topDecliners = List<SalesGrowthDetail>.from(
      data.where((e) => e.momStatus == 'Degrowth'),
    );
    topDecliners.sort((a, b) => (a.momGrowth ?? 0).compareTo(b.momGrowth ?? 0));

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      LucideIcons.barChart2,
                      color: Color(0xFF6366F1),
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Top 10 Parties — Sales Comparison',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ...top10
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    e.partyName,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF334155),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                _growthPill(e.momGrowth),
                              ],
                            ),
                            const SizedBox(height: 8),
                            _chartBar(
                              summary?.currLabel ?? 'Current',
                              e.currSales,
                              maxVal,
                              const Color(0xFF6366F1),
                            ),
                            const SizedBox(height: 4),
                            _chartBar(
                              summary?.prevLabel ?? 'Previous',
                              e.prevSales,
                              maxVal,
                              const Color(0xFF93C5FD),
                            ),
                            const SizedBox(height: 4),
                            _chartBar(
                              summary?.lyLabel ?? 'Last Year',
                              e.lySales,
                              maxVal,
                              const Color(0xFFCBD5E1),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          LucideIcons.trendingUp,
                          color: Color(0xFF10B981),
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Top 5 Growing Parties',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...topGrowers
                        .take(5)
                        .map(
                          (e) => Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECFDF5),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFD1FAE5),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        e.partyName,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1E293B),
                                        ),
                                        maxLines: 1,
                                      ),
                                      Text(
                                        '₹${_fmtInt.format(e.currSales)} this month',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF059669),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _growthPill(e.momGrowth),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          LucideIcons.trendingDown,
                          color: Color(0xFFF43F5E),
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Top 5 Declining Parties',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...topDecliners
                        .take(5)
                        .map(
                          (e) => Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF1F2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFFFE4E6),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        e.partyName,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1E293B),
                                        ),
                                        maxLines: 1,
                                      ),
                                      Text(
                                        '₹${_fmtInt.format(e.currSales)} this month',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFFE11D48),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _growthPill(e.momGrowth),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _chartBar(String label, double val, double maxVal, Color c) {
    double pct = maxVal == 0 ? 0 : (val / maxVal);
    if (pct > 1) pct = 1;
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
          ),
        ),
        Expanded(
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: pct,
              child: Container(
                decoration: BoxDecoration(
                  color: c,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 80,
          child: Text(
            '₹${_fmtInt.format(val)}',
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF475569),
            ),
          ),
        ),
      ],
    );
  }

  Widget _sortableCol(String label, String key) {
    final active = _sortKey == key;
    return InkWell(
      onTap: () => _handleSort(key),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: _hStyle()),
          const SizedBox(width: 4),
          Icon(
            active
                ? (_sortDir == 'asc'
                      ? LucideIcons.chevronUp
                      : LucideIcons.chevronDown)
                : LucideIcons.arrowUpDown,
            size: 12,
            color: active ? Colors.white : Colors.white38,
          ),
        ],
      ),
    );
  }

  TextStyle _hStyle() => const TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 1,
  );

  Widget _growthPill(double? val) {
    if (val == null)
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'N/A',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      );
    final pos = val >= 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: pos ? const Color(0xFFD1FAE5) : const Color(0xFFFFE4E6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            pos ? LucideIcons.arrowUpRight : LucideIcons.arrowDownRight,
            size: 12,
            color: pos ? const Color(0xFF059669) : const Color(0xFFE11D48),
          ),
          const SizedBox(width: 4),
          Text(
            '${pos ? '+' : ''}$val%',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: pos ? const Color(0xFF059669) : const Color(0xFFE11D48),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    if (status == 'Growth') return _growthPill(1); // Reusing pill style
    if (status == 'Degrowth') return _growthPill(-1);
    return _growthPill(null);
  }

  Future<void> _exportExcel(
    List<SalesGrowthDetail> data,
    SalesGrowthSummary? summary,
  ) async {
    if (data.isEmpty) return;
    try {
      final excel = xl.Excel.createExcel();
      final sheet = excel['Sales Growth'];

      sheet.appendRow([
        xl.TextCellValue('SR No'),
        xl.TextCellValue('Party Name'),
        xl.TextCellValue('${summary?.currLabel ?? 'Current'} Sales'),
        xl.TextCellValue('${summary?.prevLabel ?? 'Previous'} Sales'),
        xl.TextCellValue('${summary?.lyLabel ?? 'Last Year'} Sales'),
        xl.TextCellValue('MoM Growth %'),
        xl.TextCellValue('YoY Growth %'),
        xl.TextCellValue('MoM Status'),
        xl.TextCellValue('Invoices'),
      ]);

      for (int i = 0; i < data.length; i++) {
        final d = data[i];
        sheet.appendRow([
          xl.IntCellValue(i + 1),
          xl.TextCellValue(d.partyName),
          xl.DoubleCellValue(d.currSales),
          xl.DoubleCellValue(d.prevSales),
          xl.DoubleCellValue(d.lySales),
          xl.TextCellValue(d.momGrowth?.toString() ?? 'N/A'),
          xl.TextCellValue(d.yoyGrowth?.toString() ?? 'N/A'),
          xl.TextCellValue(d.momStatus),
          xl.IntCellValue(d.currInvoices),
        ]);
      }

      final path = await FilePicker.saveFile(
        dialogTitle: 'Save Excel File',
        fileName: 'SalesGrowthReport.xlsx',
        allowedExtensions: ['xlsx'],
        type: FileType.custom,
      );
      if (path != null) {
        final bytes = excel.encode()!;
        final file = File(path);
        await file.writeAsBytes(bytes);
      }
    } catch (e) {
      debugPrint('Export err: $e');
    }
  }

  Future<void> _printPdf(
    List<SalesGrowthDetail> data,
    SalesGrowthSummary? summary,
  ) async {
    if (data.isEmpty) return;
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.portrait,
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) {
          return [
            pw.Text(
              'Sales Growth Comparison Report',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            if (summary != null)
              pw.Text(
                '${summary.currLabel} vs ${summary.prevLabel} vs ${summary.lyLabel}',
                style: const pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey700,
                ),
              ),
            pw.SizedBox(height: 20),
            pw.TableHelper.fromTextArray(
              headers: [
                'SR',
                'Party Name',
                summary?.currLabel ?? 'Current',
                summary?.prevLabel ?? 'Prev',
                summary?.lyLabel ?? 'LY',
                'MoM%',
                'YoY%',
                'Status',
              ],
              data: List.generate(data.length, (i) {
                final d = data[i];
                return [
                  (i + 1).toString(),
                  d.partyName,
                  'Rs ${_fmt.format(d.currSales)}',
                  'Rs ${_fmt.format(d.prevSales)}',
                  'Rs ${_fmt.format(d.lySales)}',
                  '${d.momGrowth ?? 'N/A'}',
                  '${d.yoyGrowth ?? 'N/A'}',
                  d.momStatus,
                ];
              }),
              headerStyle: pw.TextStyle(
                fontSize: 8,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColor.fromInt(0xFF1E40AF),
              ),
              cellStyle: const pw.TextStyle(fontSize: 8),
              cellAlignments: {
                0: pw.Alignment.center,
                1: pw.Alignment.centerLeft,
                2: pw.Alignment.centerRight,
                3: pw.Alignment.centerRight,
                4: pw.Alignment.centerRight,
                5: pw.Alignment.center,
                6: pw.Alignment.center,
                7: pw.Alignment.center,
              },
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
