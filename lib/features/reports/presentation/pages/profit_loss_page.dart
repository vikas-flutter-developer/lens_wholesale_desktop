import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:csv/csv.dart';
import 'package:printing/printing.dart';
import 'dart:typed_data';

import '../../data/providers/financial_provider.dart';
import '../../data/models/financial_models.dart';
import '../../../masters/data/providers/account_provider.dart';
import '../../../masters/data/models/account_model.dart';

class ProfitLossPage extends StatefulWidget {
  final int initialIndex;
  const ProfitLossPage({super.key, this.initialIndex = 0});

  @override
  State<ProfitLossPage> createState() => _ProfitLossPageState();
}

class _ProfitLossPageState extends State<ProfitLossPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _fromDate = DateTime(DateTime.now().year, DateTime.now().month - 1, 1);
  DateTime _toDate = DateTime.now();
  final _accountSearchCtrl = TextEditingController();
  final _groupCtrl = TextEditingController();
  final _productSearchCtrl = TextEditingController();
  bool _includeStockOutflow = false;

  // Added ScrollController for horizontal scrolling
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: widget.initialIndex);
    _tabController.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountProvider>().fetchAllAccounts();
      context.read<FinancialProvider>().fetchParentGroups();
      _handleSearch();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _horizontalScrollController.dispose(); // Properly dispose the scroll controller
    _accountSearchCtrl.dispose();
    _groupCtrl.dispose();
    _productSearchCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSearch() async {
    final provider = context.read<FinancialProvider>();
    final from = DateFormat('yyyy-MM-dd').format(_fromDate);
    final to = DateFormat('yyyy-MM-dd').format(_toDate);

    if (_tabController.index == 0) {
      await provider.fetchPLAccount({
        'dateFrom': from,
        'dateTo': to,
        'accountName': _accountSearchCtrl.text,
      });
    } else {
      await provider.fetchPLItem({
        'dateFrom': from,
        'dateTo': to,
        'groupName': _groupCtrl.text,
        'searchText': _productSearchCtrl.text,
        'includeStockOutflow': _includeStockOutflow,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildHeader(),
          _buildFilters(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAccountView(),
                _buildItemView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft, end: Alignment.centerRight,
          colors: [Color(0xFF1D4ED8), Color(0xFF4338CA)],
        ),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12)),
              child: const Icon(LucideIcons.dollarSign, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('PROFIT & LOSS ANALYSIS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 0.5)),
                Text('Reports & Statements', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
              ],
            ),
            const Spacer(),
            _buildTabSwitcher(),
            const Spacer(),
            Row(
              children: [
                _headerAction(LucideIcons.fileSpreadsheet, Colors.greenAccent, () {
                  final provider = context.read<FinancialProvider>();
                  _handleExport(provider);
                }, title: 'Excel'),
                const SizedBox(width: 8),
                _headerAction(LucideIcons.printer, Colors.white, () {}, title: 'Print'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerAction(IconData icon, Color color, VoidCallback onTap, {required String title}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }

  void _handleExport(FinancialProvider provider) {
    if (_tabController.index == 0) {
      if (provider.plAccount != null) _exportAccountCSV(provider.plAccount!);
    } else {
      if (provider.plItem != null) _exportItemCSV(provider.plItem!);
    }
  }

  void _exportAccountCSV(PLAccountReport data) {
    List<List<dynamic>> rows = [];
    rows.add(['PROFIT & LOSS ACCOUNT (By Account)']);
    rows.add(['Period:', '${DateFormat('dd/MM/yyyy').format(_fromDate)} to ${DateFormat('dd/MM/yyyy').format(_toDate)}']);
    rows.add([]);

    rows.add(['EXPENDITURE', 'AMOUNT', 'INCOME', 'AMOUNT']);

    final s = data.summary;
    rows.add(['Direct Expenses', s.totalDirectExpenses, 'Sale Accounts', s.totalSales]);
    rows.add(['Purchase Accounts', s.totalPurchase, 'Closing Stock', s.totalClosingStock]);
    rows.add(['Opening Stock', s.totalOpeningStock, '', '']);
    rows.add(['Indirect Expenses', s.totalIndirectExpenses, '', '']);
    rows.add([]);
    rows.add(['Total Expenses', s.totalExpenses, 'Total Income', s.totalIncome]);
    rows.add(['Net Profit/Loss', s.netProfit]);

    String csvData = const ListToCsvConverter().convert(rows);
    Printing.sharePdf(bytes: Uint8List.fromList(csvData.codeUnits), filename: 'pl_account.csv');
  }

  void _exportItemCSV(PLItemReport data) {
    List<List<dynamic>> rows = [];
    rows.add(['PROFIT & LOSS ANALYSIS (By Item)']);
    rows.add(['Period:', '${DateFormat('dd/MM/yyyy').format(_fromDate)} to ${DateFormat('dd/MM/yyyy').format(_toDate)}']);
    rows.add([]);

    rows.add(['Group', 'Item Name', 'Qty', 'Buy Price', 'Sell Price', 'Total Buy', 'Total Sell', 'Profit/Loss']);
    for (var r in data.reportData) {
      rows.add([
        r.groupName, r.itemName, r.stokOutQty,
        r.itemWiseProfit.purPrice, r.itemWiseProfit.salPrice,
        r.itemWiseProfit.totPurPrice, r.itemWiseProfit.totSalPrice,
        r.itemWiseProfit.profitLoss
      ]);
    }
    rows.add(['', '', '', '', '', data.summary.totalPurchaseAmount, data.summary.totalSaleAmount, data.summary.totalProfitLoss]);

    String csvData = const ListToCsvConverter().convert(rows);
    Printing.sharePdf(bytes: Uint8List.fromList(csvData.codeUnits), filename: 'pl_item.csv');
  }

  Widget _buildTabSwitcher() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: const Color(0xFF1E3A8A).withValues(alpha: 0.4), borderRadius: BorderRadius.circular(14)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _tabBtn('Account Wise', LucideIcons.users, 0),
          _tabBtn('Item Wise', LucideIcons.layoutGrid, 1),
        ],
      ),
    );
  }

  Widget _tabBtn(String label, IconData icon, int index) {
    bool active = _tabController.index == index;
    return InkWell(
      onTap: () {
        _tabController.animateTo(index);
        setState(() {});
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: active ? [const BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))] : [],
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: active ? const Color(0xFF1D4ED8) : Colors.white70),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: active ? const Color(0xFF1D4ED8) : Colors.white70, fontWeight: FontWeight.w700, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _filterCol('FROM DATE', _dateBtn(_fromDate, (d) => setState(() => _fromDate = d))),
              const SizedBox(width: 16),
              _filterCol('TO DATE', _dateBtn(_toDate, (d) => setState(() => _toDate = d))),
              const SizedBox(width: 16),
              if (_tabController.index == 0)
                Expanded(child: _filterCol('ACCOUNT SEARCH', _buildAccountAutocomplete()))
              else ...[
                Expanded(child: _filterCol('CATEGORY / GROUP', _buildGroupAutocomplete())),
                const SizedBox(width: 16),
                Expanded(child: _filterCol('PRODUCT SEARCH', _buildProductAutocomplete())),
              ],
              const SizedBox(width: 16),
              _buildActionButtons(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccountAutocomplete() {
    final provider = context.watch<AccountProvider>();
    return Autocomplete<AccountModel>(
      optionsBuilder: (val) {
        if (val.text.isEmpty) return provider.accounts.take(20);
        return provider.accounts.where((a) => a.name.toLowerCase().contains(val.text.toLowerCase())).take(20);
      },
      displayStringForOption: (a) => a.name,
      onSelected: (a) => _accountSearchCtrl.text = a.name,
      fieldViewBuilder: (ctx, ctrl, focus, onFieldSubmitted) {
        if (ctrl.text != _accountSearchCtrl.text && _accountSearchCtrl.text.isNotEmpty) {
          ctrl.text = _accountSearchCtrl.text;
        }
        return _textInput(ctrl, 'Search account...', focus: focus);
      },
    );
  }

  Widget _buildGroupAutocomplete() {
    final provider = context.watch<FinancialProvider>();
    return Autocomplete<String>(
      optionsBuilder: (val) {
        if (val.text.isEmpty) return provider.parentGroups.take(20);
        return provider.parentGroups.where((g) => g.toLowerCase().contains(val.text.toLowerCase())).take(20);
      },
      onSelected: (g) => _groupCtrl.text = g,
      fieldViewBuilder: (ctx, ctrl, focus, onFieldSubmitted) {
        if (ctrl.text != _groupCtrl.text && _groupCtrl.text.isNotEmpty) {
          ctrl.text = _groupCtrl.text;
        }
        return _textInput(ctrl, 'Filter by Group...', focus: focus);
      },
    );
  }

  Widget _buildProductAutocomplete() {
    return _textInput(_productSearchCtrl, 'Search products...');
  }

  Widget _textInput(TextEditingController ctrl, String hint, {FocusNode? focus}) {
    return TextField(
      controller: ctrl,
      focusNode: focus,
      decoration: InputDecoration(
        hintText: hint, filled: true, fillColor: const Color(0xFFF1F5F9),
        prefixIcon: const Icon(LucideIcons.search, size: 16, color: Color(0xFF64748B)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
    );
  }

  Widget _filterCol(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF64748B), letterSpacing: 1)),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _dateBtn(DateTime d, Function(DateTime) onSelect) {
    return InkWell(
      onTap: () async {
        final res = await showDatePicker(context: context, initialDate: d, firstDate: DateTime(2000), lastDate: DateTime(2100));
        if (res != null) onSelect(res);
      },
      child: Container(
        width: 140, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
        child: Row(children: [
          Text(DateFormat('dd-MM-yyyy').format(d), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B))),
          const Spacer(),
          const Icon(LucideIcons.calendar, size: 16, color: Color(0xFF2563EB))
        ]),
      ),
    );
  }

  Widget _buildActionButtons() {
    final provider = context.watch<FinancialProvider>();
    return Row(
      children: [
        if (_tabController.index == 1) ...[
          _outflowTogggle(),
          const SizedBox(width: 12),
        ],
        SizedBox(
          height: 44,
          child: ElevatedButton.icon(
            onPressed: provider.isLoading ? null : _handleSearch,
            icon: provider.isLoading ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(LucideIcons.search, size: 16),
            label: const Text('Search', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              elevation: 4, shadowColor: Colors.blue.withValues(alpha: 0.3),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 28),
            ),
          ),
        ),
        const SizedBox(width: 12),
        _iconBtn(LucideIcons.rotateCcw, () {
          _accountSearchCtrl.clear();
          _groupCtrl.clear();
          _productSearchCtrl.clear();
          setState(() {
            _fromDate = DateTime(DateTime.now().year, DateTime.now().month - 1, 1);
            _toDate = DateTime.now();
          });
          _handleSearch();
        }),
      ],
    );
  }

  Widget _outflowTogggle() {
    return InkWell(
      onTap: () => setState(() => _includeStockOutflow = !_includeStockOutflow),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            SizedBox(
              height: 18, width: 18,
              child: Checkbox(
                value: _includeStockOutflow,
                activeColor: const Color(0xFF2563EB),
                onChanged: (v) => setState(() => _includeStockOutflow = v ?? false),
              ),
            ),
            const SizedBox(width: 8),
            const Text('Stock Outflow', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF475569))),
          ],
        ),
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, size: 20, color: const Color(0xFF475569)),
      ),
    );
  }

  // --- Account View ---
  Widget _buildAccountView() {
    final provider = context.watch<FinancialProvider>();
    final data = provider.plAccount;
    if (provider.isLoading) return const Center(child: CircularProgressIndicator());
    if (data == null) return const Center(child: Text('Search to generate Account P&L'));

    return Column(
      children: [
        _buildSummaryCards([
          _summary('Gross Profit (C/O)', data.summary.grossProfitCO, Colors.amber),
          _summary('Gross Profit (B/F)', data.summary.grossProfitBF, Colors.indigo),
          _summary('Net Profit/Loss', data.summary.netProfit, data.summary.netProfit >= 0 ? const Color(0xFF10B981) : const Color(0xFFF43F5E), isLarge: true),
          _summary('Total Revenue', data.summary.totalIncome, Colors.blue),
        ]),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.blueGrey.shade200)),
              clipBehavior: Clip.antiAlias,
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(child: _accountSection('EXPENDITURE', LucideIcons.trendingDown, [
                      _accountGroup('Direct Expenses', data.expenses.directExpenses, data.summary.totalDirectExpenses),
                      _accountGroup('Purchase Accounts', data.expenses.purchaseAccounts, data.summary.totalPurchase),
                      _accountGroup('Opening Stock', data.expenses.openingStock, data.summary.totalOpeningStock),
                      _accountGroup('Indirect Expenses', data.expenses.indirectExpenses, data.summary.totalIndirectExpenses),
                    ], isExp: true)),
                    Container(width: 1, color: Colors.blueGrey.shade200),
                    Expanded(child: _accountSection('INCOME', LucideIcons.trendingUp, [
                      _accountGroup('Sale Accounts', data.income.saleAccounts, data.summary.totalSales),
                      _accountGroup('Closing Stock', data.income.closingStock, data.summary.totalClosingStock),
                    ])),
                  ],
                ),
              ),
            ),
          ),
        ),
        _buildAccountFooter(data.summary),
      ],
    );
  }

  Widget _buildAccountFooter(PLAccountSummary s) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        border: Border(top: BorderSide(color: Colors.blueGrey.shade100, width: 1)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Statement Summary', style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: -0.5)),
              Text('${DateFormat('yyyy-MM-dd').format(_fromDate)} TO ${DateFormat('yyyy-MM-dd').format(_toDate)}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
            ],
          ),
          const Spacer(),
          _footerStat('TOTAL EXP.', s.totalExpenses, const Color(0xFFF43F5E)),
          const SizedBox(width: 40),
          _footerStat('TOTAL INC.', s.totalIncome, const Color(0xFF10B981)),
          const SizedBox(width: 40),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.blue.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('FINAL NET PROFIT/LOSS', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                Text('₹${_f(s.netProfit.abs())} ${s.netProfit >= 0 ? "Cr" : "Dr"}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _footerStat(String label, double val, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
        Text('₹${_f(val)}', style: const TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.w900, fontSize: 18)),
      ],
    );
  }

  Widget _accountSection(String title, IconData icon, List<Widget> groups, {bool isExp = false}) {
    return Column(
      children: [
        Container(
          width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          color: isExp ? const Color(0xFFFFF1F2) : const Color(0xFFECFDF5),
          child: Row(
            children: [
              Icon(icon, size: 16, color: isExp ? const Color(0xFFBE123C) : const Color(0xFF047857)),
              const SizedBox(width: 8),
              Text(title, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: isExp ? const Color(0xFFBE123C) : const Color(0xFF047857), letterSpacing: 1)),
            ],
          ),
        ),
        Expanded(child: ListView(padding: EdgeInsets.zero, children: groups)),
      ],
    );
  }

  Widget _accountGroup(String title, List<PLAccountItem> items, double total) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), color: Colors.blueGrey.shade50.withOpacity(0.5),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(title.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.blueGrey, letterSpacing: 0.5)),
            Text('₹${NumberFormat('#,##,##0.00').format(total)}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          ]),
        ),
        ...items.map((e) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(e.accountName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
            Text('₹${NumberFormat('#,##,##0.00').format(e.amount)}', style: const TextStyle(fontSize: 12, fontFamily: 'monospace')),
          ]),
        )),
        const Divider(height: 1, thickness: 0.5),
      ],
    );
  }

  // --- Item View ---
  Widget _buildItemView() {
    final provider = context.watch<FinancialProvider>();
    final data = provider.plItem;
    if (provider.isLoading) return const Center(child: CircularProgressIndicator());
    if (data == null) return const Center(child: Text('Search to generate Item Margin Report'));

    return Column(
      children: [
        _buildSummaryCards([
          _summary('Purchase Total', data.summary.totalPurchaseAmount, Colors.blue, icon: LucideIcons.users),
          _summary('Sales Total', data.summary.totalSaleAmount, Colors.indigo, icon: LucideIcons.users),
          _summary('Total Inventory Profit', data.summary.totalProfitLoss, data.summary.totalProfitLoss >= 0 ? const Color(0xFF10B981) : const Color(0xFFF43F5E), isLarge: true),
          _performanceSplit(data.summary.profitableItems, data.summary.lossItems),
        ]),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 20, offset: const Offset(0, 10))],
              ),
              clipBehavior: Clip.antiAlias,
              // Method 1 Native Fix applied here: LayoutBuilder -> Scrollbar -> Vertical Scroll -> Horizontal Scroll -> ConstrainedBox -> DataTable
              child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Dynamic column spacing based on screen width
                    final double dynamicSpacing = constraints.maxWidth < 1000 ? 20.0 : 40.0;

                    return Scrollbar(
                      controller: _horizontalScrollController,
                      thumbVisibility: true,
                      trackVisibility: true,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          controller: _horizontalScrollController,
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              // Forces the table to stretch to at least the full container width
                              minWidth: constraints.maxWidth,
                            ),
                            child: DataTable(
                              headingRowHeight: 52,
                              dataRowMaxHeight: 80,
                              headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                              columnSpacing: dynamicSpacing,
                              columns: [
                                _col('PRODUCT ANALYSIS'),
                                _col('IN STOCK QTY', center: true),
                                _col('BUY INFO', center: true),
                                _col('SELL INFO', center: true),
                                _col('FINAL MARGIN', right: true),
                              ],
                              rows: data.reportData.map((e) => DataRow(
                                cells: [
                                  DataCell(Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(e.itemName, style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
                                      Text(e.groupName, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                                    ],
                                  )),
                                  DataCell(Center(child: Text(e.stokOutQty.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF475569))))),
                                  DataCell(Center(child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('AVG: ₹${e.itemWiseProfit.purPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold)),
                                      Text('₹${_f(e.itemWiseProfit.totPurPrice)}', style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF475569))),
                                    ],
                                  ))),
                                  DataCell(Center(child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('AVG: ₹${e.itemWiseProfit.salPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold)),
                                      Text('₹${_f(e.itemWiseProfit.totSalPrice)}', style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF475569))),
                                    ],
                                  ))),
                                  DataCell(Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: e.itemWiseProfit.profitLoss >= 0 ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(e.itemWiseProfit.profitLoss >= 0 ? LucideIcons.trendingUp : LucideIcons.trendingDown, size: 14, color: e.itemWiseProfit.profitLoss >= 0 ? const Color(0xFF15803D) : const Color(0xFFB91C1C)),
                                          const SizedBox(width: 8),
                                          Text('₹${_f(e.itemWiseProfit.profitLoss)}', style: TextStyle(fontWeight: FontWeight.w900, color: e.itemWiseProfit.profitLoss >= 0 ? const Color(0xFF15803D) : const Color(0xFFB91C1C), fontSize: 13)),
                                        ],
                                      ),
                                    ),
                                  )),
                                ],
                              )).toList(),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Existing DataColumn helper utilizing 'Expanded' to dynamically size the columns
  // along with ConstrainedBox minWidth from LayoutBuilder above.
  DataColumn _col(String label, {bool center = false, bool right = false}) {
    return DataColumn(
      label: Expanded(
        child: Text(
          label,
          textAlign: center ? TextAlign.center : (right ? TextAlign.right : TextAlign.left),
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF64748B), letterSpacing: 1),
        ),
      ),
    );
  }

  // --- Common UI ---
  Widget _buildSummaryCards(List<Widget> cards) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(children: cards.expand((c) => [Expanded(child: c), const SizedBox(width: 16)]).toList()..removeLast()),
    );
  }

  Widget _summary(String label, double val, Color color, {bool isLarge = false, IconData? icon}) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 1.5)),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(icon ?? LucideIcons.trendingUp, size: 14, color: color),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '₹ ${_f(val)}',
            style: TextStyle(fontSize: isLarge ? 24 : 18, fontWeight: FontWeight.w900, color: const Color(0xFF1E293B)),
          ),
        ],
      ),
    );
  }

  Widget _performanceSplit(int profitable, int loss) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          _splitItem('PROFITABLE', profitable.toString(), const Color(0xFF10B981)),
          const Divider(height: 16),
          _splitItem('LOSS/NO MARGIN', loss.toString(), const Color(0xFFF43F5E)),
        ],
      ),
    );
  }

  Widget _splitItem(String label, String val, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: color, letterSpacing: 0.5)),
        Text(val, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
      ],
    );
  }

  String _f(double v) => NumberFormat('#,##,##0.00').format(v);
}