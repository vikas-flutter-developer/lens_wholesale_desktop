import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:csv/csv.dart';
import 'package:printing/printing.dart';
import 'dart:typed_data';

import '../../data/providers/financial_provider.dart';
import '../../data/models/financial_models.dart';

class BalanceSheetPage extends StatefulWidget {
  const BalanceSheetPage({super.key});

  @override
  State<BalanceSheetPage> createState() => _BalanceSheetPageState();
}

class _BalanceSheetPageState extends State<BalanceSheetPage> {
  DateTime _fromDate = DateTime(DateTime.now().year, 1, 1);
  DateTime _toDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _handleSearch());
  }

  Future<void> _handleSearch() async {
    final provider = context.read<FinancialProvider>();
    await provider.fetchBalanceSheet(
      DateFormat('yyyy-MM-dd').format(_fromDate),
      DateFormat('yyyy-MM-dd').format(_toDate),
    );
  }

  void _exportCSV(BalanceSheetReport data) {
    List<List<dynamic>> rows = [];
    rows.add(['BALANCE SHEET']);
    rows.add(['Period:', '${DateFormat('dd/MM/yyyy').format(_fromDate)} to ${DateFormat('dd/MM/yyyy').format(_toDate)}']);
    rows.add([]);

    rows.add(['LIABILITIES + EQUITY', 'AMOUNT', 'ASSETS', 'AMOUNT']);
    
    // Combine into rows
    final leftSide = [
      'LIABILITIES',
      ...data.liabilities.map((e) => '${e.name}: ${e.amount}'),
      'Profit & Loss A/c: ${data.profitLossAc}',
      'Total Liabilities: ${data.totalLiabilities}',
      'EQUITY',
      ...data.equity.map((e) => '${e.name}: ${e.amount}'),
      'Total Equity: ${data.totalEquity}',
    ];

    final rightSide = [
      'ASSETS',
      ...data.assets.map((e) => '${e.name}: ${e.amount}'),
      if (data.lossForPeriod > 0) 'Loss for the period: ${data.lossForPeriod}',
      if (data.diffInOpBal != 0) 'Diff in op bal.: ${data.diffInOpBal}',
      'Total Assets: ${data.totalAssets}',
    ];

    int maxLen = leftSide.length > rightSide.length ? leftSide.length : rightSide.length;
    for (int i = 0; i < maxLen; i++) {
      rows.add([
        i < leftSide.length ? leftSide[i] : '',
        '', // Placeholder for structure-like CSV
        i < rightSide.length ? rightSide[i] : '',
        '',
      ]);
    }

    rows.add([]);
    rows.add(['Total (Liabilities + Equity)', data.grandTotalLeft, 'Total Assets', data.grandTotalRight]);

    String csvData = const ListToCsvConverter().convert(rows);
    Printing.sharePdf(bytes: Uint8List.fromList(csvData.codeUnits), filename: 'balance_sheet.csv');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Column(
        children: [
          _buildHeader(),
          _buildFilters(),
          Expanded(child: _buildReport()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF1E3A8A),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.scale, color: Colors.white, size: 24),
          const SizedBox(width: 16),
          const Text(
            'BALANCE SHEET',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20, letterSpacing: 1),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(LucideIcons.fileSpreadsheet, color: Colors.greenAccent, size: 20),
            onPressed: () {
              final provider = context.read<FinancialProvider>();
              if (provider.balanceSheet != null) _exportCSV(provider.balanceSheet!);
            },
          ),
          IconButton(
            icon: const Icon(LucideIcons.printer, color: Colors.white, size: 20),
            onPressed: () {}, // TODO: Implement PDF Print
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
      child: Row(
        children: [
          _filterDate('DATE FROM', _fromDate, (d) => setState(() => _fromDate = d)),
          const SizedBox(width: 20),
          _filterDate('DATE TO', _toDate, (d) => setState(() => _toDate = d)),
          const Spacer(),
          _buildSearchButton(),
        ],
      ),
    );
  }

  Widget _filterDate(String label, DateTime date, Function(DateTime) onSelect) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.blueGrey, letterSpacing: 1)),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final d = await showDatePicker(context: context, initialDate: date, firstDate: DateTime(2000), lastDate: DateTime(2100));
            if (d != null) onSelect(d);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(color: Colors.blueGrey.shade50, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.blueGrey.shade200)),
            child: Row(
              children: [
                Text(DateFormat('dd MMMM yyyy').format(date), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(width: 12),
                const Icon(LucideIcons.calendar, size: 16, color: Colors.blue),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchButton() {
    final provider = context.watch<FinancialProvider>();
    return ElevatedButton.icon(
      onPressed: provider.isLoading ? null : _handleSearch,
      icon: provider.isLoading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(LucideIcons.search, size: 18),
      label: const Text('Generate Report', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.5)),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        shadowColor: Colors.blue.withOpacity(0.4),
      ),
    );
  }

  Widget _buildReport() {
    final provider = context.watch<FinancialProvider>();
    if (provider.isLoading) return const Center(child: CircularProgressIndicator());
    if (provider.balanceSheet == null) return const Center(child: Text('Generate Search to view Report'));

    final bs = provider.balanceSheet!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.blueGrey.shade200)),
              clipBehavior: Clip.antiAlias,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: _buildSection('LIABILITIES + EQUITY', bs.liabilities, bs.equity, bs.totalLiabilities, bs.totalEquity, bs.profitLossAc, true)),
                    Container(width: 1, color: Colors.blueGrey.shade300),
                    Expanded(child: _buildSection('ASSETS', bs.assets, [], 0, 0, 0, false, assetsTotal: bs.totalAssets, loss: bs.lossForPeriod, diff: bs.diffInOpBal)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildGrandTotalBar(bs),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<BalanceSection> primary, List<BalanceSection> secondary, double pTotal, double sTotal, double pl, bool isLeft, {double? assetsTotal, double? loss, double? diff}) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          color: Colors.blueGrey.shade50,
          child: Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Color(0xFF1E3A8A))),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              if (isLeft) ...[
                _subHeader('Liabilities'),
                ...primary.map((e) => _row(e.name, e.amount)),
                _row('Profit & Loss A/c', pl, isBold: true, color: Colors.blue.shade700),
                _totalRow('Total Liabilities', pTotal),
                _subHeader('Equity'),
                ...secondary.map((e) => _row(e.name, e.amount)),
                _totalRow('Total Equity', sTotal),
              ] else ...[
                _subHeader('Assets'),
                ...primary.map((e) => _row(e.name, e.amount)),
                if (loss! > 0) _row('Loss for the period', loss, color: Colors.red),
                if (diff! != 0) _row('Diff in op bal.', diff, isItalic: true, color: Colors.orange.shade800),
                const Spacer(), // Push totals to bottom
              ],
            ],
          ),
        ),
        if (!isLeft) _totalRow('Total Assets', assetsTotal!),
      ],
    );
  }

  Widget _subHeader(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.blueGrey.shade100.withOpacity(0.5),
      child: Text(text.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.blueGrey, letterSpacing: 1)),
    );
  }

  Widget _row(String name, double amount, {bool isBold = false, bool isItalic = false, Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.blueGrey.shade100, width: 0.5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: TextStyle(
            fontSize: 13, 
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
            color: color ?? Colors.blueGrey.shade800,
          )),
          Text(
            '₹${NumberFormat('#,##,##0.00').format(amount)}',
            style: TextStyle(
              fontSize: 13, 
              fontWeight: FontWeight.w900, 
              fontFamily: 'monospace',
              color: color ?? Colors.blueGrey.shade900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _totalRow(String label, double val) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.blueGrey.shade50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label.toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900)),
          Text('₹${NumberFormat('#,##,##0.00').format(val)}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _buildGrandTotalBar(BalanceSheetReport bs) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Expanded(child: _grandItem('TOTAL (LIABILITIES + EQUITY)', bs.grandTotalLeft)),
          Container(width: 2, height: 30, color: Colors.white24, margin: const EdgeInsets.symmetric(horizontal: 40)),
          Expanded(child: _grandItem('TOTAL ASSETS', bs.grandTotalRight)),
        ],
      ),
    );
  }

  Widget _grandItem(String label, double val) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white60, fontWeight: FontWeight.bold, fontSize: 12)),
        Text('₹${NumberFormat('#,##,##0.00').format(val)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)),
      ],
    );
  }
}
