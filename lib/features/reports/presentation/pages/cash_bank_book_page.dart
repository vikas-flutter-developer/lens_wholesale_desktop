import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:csv/csv.dart';
import 'package:printing/printing.dart';
import 'dart:typed_data';

import '../../data/providers/financial_provider.dart';
import '../../data/models/financial_models.dart';

class CashBankBookPage extends StatefulWidget {
  const CashBankBookPage({super.key});

  @override
  State<CashBankBookPage> createState() => _CashBankBookPageState();
}

class _CashBankBookPageState extends State<CashBankBookPage> {
  final _firmController = TextEditingController();
  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _handleSearch());
  }

  Future<void> _handleSearch() async {
    final provider = context.read<FinancialProvider>();
    await provider.fetchCashBankBook({
      'firmName': _firmController.text,
      'dateFrom': DateFormat('yyyy-MM-dd').format(_fromDate),
      'dateTo': DateFormat('yyyy-MM-dd').format(_toDate),
    });
  }

  void _exportCSV(CashBankReport data) {
    List<List<dynamic>> rows = [];
    rows.add(['CASH / BANK BOOK REPORT']);
    rows.add(['Period:', '${DateFormat('dd/MM/yyyy').format(_fromDate)} to ${DateFormat('dd/MM/yyyy').format(_toDate)}']);
    rows.add([]);

    rows.add(['SALE TRANSACTIONS (INFLOWS)']);
    rows.add(['Date', 'Vch No', 'Account', 'Cash', 'Bank']);
    for (var t in data.saleTransactions) {
      rows.add([t.date, t.vchNo ?? '', t.account, t.cash, t.bank]);
    }
    rows.add(['', '', 'TOTAL INFLOWS', data.saleTotalCash, data.saleTotalBank]);
    rows.add([]);

    rows.add(['PURCHASE TRANSACTIONS (OUTFLOWS)']);
    rows.add(['Date', 'Vch No', 'Account', 'Cash', 'Bank']);
    for (var t in data.purchaseTransactions) {
      rows.add([t.date, t.vchNo ?? '', t.account, t.cash, t.bank]);
    }
    rows.add(['', '', 'TOTAL OUTFLOWS', data.purchaseTotalCash, data.purchaseTotalBank]);
    rows.add([]);

    rows.add(['SUMMARY']);
    rows.add(['Opening Amount', data.openingAmount]);
    rows.add(['Closing Amount', data.closingAmount]);

    String csvData = const ListToCsvConverter().convert(rows);
    Printing.sharePdf(bytes: Uint8List.fromList(csvData.codeUnits), filename: 'cash_bank_book.csv');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildHeader(),
          _buildFilters(),
          _buildSummaryBar(),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)]),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.wallet, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          const Text(
            'CASH / BANK BOOK',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(LucideIcons.fileSpreadsheet, color: Colors.greenAccent, size: 20),
            onPressed: () {
              final provider = context.read<FinancialProvider>();
              if (provider.cashBank != null) _exportCSV(provider.cashBank!);
            },
          ),
          IconButton(
            icon: const Icon(LucideIcons.printer, color: Colors.white, size: 20),
            onPressed: () {}, // TODO: Implement PDF Print
          ),
          IconButton(
            icon: const Icon(LucideIcons.rotateCcw, color: Colors.white, size: 20),
            onPressed: () {
              _firmController.clear();
              setState(() {
                _fromDate = DateTime.now();
                _toDate = DateTime.now();
              });
              _handleSearch();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: _buildInputField('Firm Name', _firmController, 'Enter firm name (optional)'),
          ),
          const SizedBox(width: 12),
          _buildDatePicker('Date From', _fromDate, (d) => setState(() => _fromDate = d)),
          const SizedBox(width: 12),
          _buildDatePicker('Date To', _toDate, (d) => setState(() => _toDate = d)),
          const SizedBox(width: 12),
          _buildSearchButton(),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController ctrl, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildDatePicker(String label, DateTime date, Function(DateTime) onSelect) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 6),
        InkWell(
          onTap: () async {
            final d = await showDatePicker(context: context, initialDate: date, firstDate: DateTime(2000), lastDate: DateTime(2100));
            if (d != null) onSelect(d);
          },
          child: Container(
            width: 140,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                Text(DateFormat('dd/MM/yyyy').format(date), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                const Spacer(),
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
      icon: provider.isLoading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(LucideIcons.search, size: 16),
      label: const Text('Search', style: TextStyle(fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildSummaryBar() {
    final provider = context.watch<FinancialProvider>();
    final s = provider.cashBank;
    if (s == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _summaryCard('Opening', s.openingAmount, Colors.green),
          const SizedBox(width: 16),
          _summaryCard('Closing', s.closingAmount, Colors.blue),
        ],
      ),
    );
  }

  Widget _summaryCard(String label, double amount, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: color.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.1))),
      child: Row(
        children: [
          Icon(label == 'Opening' ? LucideIcons.trendingUp : LucideIcons.trendingDown, size: 16, color: color),
          const SizedBox(width: 8),
          Text('$label: ', style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
          Text('₹${amount.toStringAsFixed(2)}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: color)),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final provider = context.watch<FinancialProvider>();
    if (provider.isLoading) return const Center(child: CircularProgressIndicator());
    if (provider.cashBank == null) return const Center(child: Text('Search to generate Cash/Bank Book'));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionTable(
          'Sale Transactions (Inflows)',
          provider.cashBank!.saleTransactions,
          provider.cashBank!.saleTotalCash,
          provider.cashBank!.saleTotalBank,
          [Colors.green.shade600, Colors.green.shade700],
        ),
        const SizedBox(height: 24),
        _buildSectionTable(
          'Purchase Transactions (Outflows)',
          provider.cashBank!.purchaseTransactions,
          provider.cashBank!.purchaseTotalCash,
          provider.cashBank!.purchaseTotalBank,
          [Colors.orange.shade600, Colors.orange.shade700],
        ),
      ],
    );
  }

  Widget _buildSectionTable(String title, List<CashBankTransaction> data, double totalCash, double totalBank, List<Color> gradient) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Text(title.toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                const Spacer(),
                Text('${data.length} Records', style: const TextStyle(color: Colors.white70, fontSize: 11)),
              ],
            ),
          ),
          DataTable(
            headingRowHeight: 40,
            columnSpacing: 24,
            headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.blueGrey),
            columns: const [
              DataColumn(label: Text('Date')),
              DataColumn(label: Text('Vch/Bill No')),
              DataColumn(label: Text('Account / Party Name')),
              DataColumn(label: Text('Cash', textAlign: TextAlign.right), numeric: true),
              DataColumn(label: Text('Bank', textAlign: TextAlign.right), numeric: true),
            ],
            rows: data.map((t) => DataRow(cells: [
              DataCell(Text(DateFormat('dd/MM/yyyy').format(DateTime.parse(t.date)))),
              DataCell(Text(t.vchNo ?? '-', style: const TextStyle(fontFamily: 'monospace'))),
              DataCell(Text(t.account, style: const TextStyle(fontWeight: FontWeight.bold))),
              DataCell(Text(t.cash > 0 ? t.cash.toStringAsFixed(2) : '-', style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.bold))),
              DataCell(Text(t.bank > 0 ? t.bank.toStringAsFixed(2) : '-', style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold))),
            ])).toList(),
          ),
          if (data.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(color: gradient[0].withOpacity(0.05), border: Border(top: BorderSide(color: Colors.grey.shade100))),
              child: Row(
                children: [
                  const Text('TOTALS:', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
                  const Spacer(),
                  const SizedBox(width: 200), // Alignment padding
                  Text('₹${totalCash.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.w900, color: gradient[1], fontSize: 13)),
                  const SizedBox(width: 80),
                  Text('₹${totalBank.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.blue.shade700, fontSize: 13)),
                  const SizedBox(width: 40),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
