import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import '../providers/voucher_provider.dart';
import '../../../masters/data/providers/account_provider.dart';
import '../../../masters/data/models/account_model.dart';
import '../../data/models/voucher_model.dart';

class AddVoucherPage extends StatefulWidget {
  final String? editId;
  const AddVoucherPage({super.key, this.editId});

  @override
  State<AddVoucherPage> createState() => _AddVoucherPageState();
}

class _AddVoucherPageState extends State<AddVoucherPage> {
  // Header state
  String _recordType = 'Payment';
  String _billSeries = 'P(25-26)';
  String _billNo = '';
  DateTime _date = DateTime.now();

  // Grid state
  List<Map<String, dynamic>> _rows = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _rows = [_emptyRow(1)];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountProvider>().fetchAllAccounts();
      if (widget.editId != null) {
        _loadExistingVoucher();
      } else {
        _fetchNextBillNo();
      }
    });
  }

  Map<String, dynamic> _emptyRow(int sn) => {
        'sn': sn,
        'account': '',
        'accountId': '',
        'balance': 0.0,
        'balanceType': 'Dr',
        'debit': 0.0,
        'credit': 0.0,
        'modeOfPayment': 'Cash',
        'chqDocNo': '',
        'chqDocDate': null as DateTime?,
        'remark': '',
        'showSuggestions': false,
      };

  List<String> _getBillSeriesOptions(String type) {
    if (type == 'Payment') return ['P(25-26)', 'PUR_26', 'BPAY_25'];
    if (type == 'Receipt') return ['S(25-26)', 'SAL_26', 'BRCPT_25'];
    if (type == 'Journal') return ['JRNL_25-26'];
    if (type == 'Contra') return ['CONTRA_25-26'];
    if (type == 'Debit') return ['DR_NOTE_25'];
    if (type == 'Credit') return ['CR_NOTE_25'];
    return ['GEN_25'];
  }

  Future<void> _fetchNextBillNo() async {
    final provider = context.read<VoucherProvider>();
    final nextNo = await provider.fetchNextBillNo(_recordType, _billSeries);
    if (nextNo != null && mounted) {
      setState(() => _billNo = nextNo);
    }
  }

  Future<void> _loadExistingVoucher() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    final res = await context.read<VoucherProvider>().getVoucherById(widget.editId!);
    if (res['success'] == true && res['data'] != null && mounted) {
      final voucher = VoucherModel.fromJson(res['data']);
      setState(() {
        _recordType = voucher.recordType;
        _billSeries = voucher.billSeries;
        _billNo = voucher.billNo.toString();
        _date = (voucher.date != null && voucher.date!.isNotEmpty)
            ? (DateTime.tryParse(voucher.date!) ?? DateTime.now())
            : DateTime.now();
        if (voucher.rows.isNotEmpty) {
          _rows = voucher.rows.asMap().entries.map((e) {
            final r = e.value;
            DateTime? chqDt;
            if (r.chqDocDate != null && r.chqDocDate!.isNotEmpty) {
              chqDt = DateTime.tryParse(r.chqDocDate!);
            }
            return {
              'sn': e.key + 1,
              'account': r.account,
              'accountId': r.accountId,
              'balance': r.balance,
              'balanceType': 'Dr',
              'debit': r.debit,
              'credit': r.credit,
              'modeOfPayment': r.modeOfPayment.isEmpty ? 'Cash' : r.modeOfPayment,
              'chqDocNo': r.chqDocNo ?? '',
              'chqDocDate': chqDt,
              'remark': r.remark ?? '',
              'showSuggestions': false,
            };
          }).toList();
        }
      });
    }
    if (mounted) setState(() => _isLoading = false);
  }

  void _updateRow(int index, String field, dynamic value) {
    setState(() {
      _rows[index][field] = value;
      if (field == 'debit' && (value as double) > 0) _rows[index]['credit'] = 0.0;
      if (field == 'credit' && (value as double) > 0) _rows[index]['debit'] = 0.0;
    });
  }

  void _addRow() {
    setState(() => _rows.add(_emptyRow(_rows.length + 1)));
  }

  void _removeRow(int index) {
    if (_rows.length <= 1) return;
    setState(() {
      _rows.removeAt(index);
      for (int i = 0; i < _rows.length; i++) {
        _rows[i]['sn'] = i + 1;
      }
    });
  }

  double get _totalDebit => _rows.fold(0.0, (s, r) => s + (r['debit'] as double));
  double get _totalCredit => _rows.fold(0.0, (s, r) => s + (r['credit'] as double));
  bool get _isBalanced => _totalDebit == _totalCredit;

  Future<void> _handleSave() async {
    if (_billNo.isEmpty || _billSeries.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all mandatory header fields')));
      return;
    }

    final validRows = _rows.where((r) =>
        (r['account'] as String).isNotEmpty &&
        ((r['debit'] as double) > 0 || (r['credit'] as double) > 0)).toList();

    if (validRows.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one valid row with an Amount and Account')));
      return;
    }

    setState(() => _isLoading = true);
    final payload = {
      'recordType': _recordType,
      'billSeries': _billSeries,
      'billNo': _billNo,
      'date': _date.toIso8601String(),
      'rows': validRows.map((r) => {
        'dc': (r['debit'] as double) > 0 ? 'D' : 'C',
        'account': r['account'],
        'accountId': r['accountId'],
        'balance': r['balance'],
        'debit': r['debit'],
        'credit': r['credit'],
        'modeOfPayment': r['modeOfPayment'],
        'chqDocNo': r['chqDocNo'],
        'chqDocDate': (r['chqDocDate'] as DateTime?)?.toIso8601String() ?? '',
        'remark': r['remark'],
      }).toList(),
      'totalDebit': _totalDebit,
      'totalCredit': _totalCredit,
    };

    final provider = context.read<VoucherProvider>();
    final res = widget.editId != null
        ? await provider.updateVoucher(widget.editId!, payload)
        : await provider.saveVoucher(payload);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (res['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(widget.editId != null ? 'Voucher updated successfully' : 'Voucher created successfully')));
      context.go('/transaction/vouchers');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['error'] ?? 'Failed to save voucher')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && widget.editId != null && _rows.length == 1 && _rows[0]['account'] == '') {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6), // bg-gray-100
      body: SizedBox.expand(
        child: Column(
          children: [
            // Top Bar - blue-600
            Container(
              color: const Color(0xFF2563EB),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Text(
                    widget.editId != null ? 'Edit Voucher' : 'Add Vouchers',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  if (_isLoading)
                    const SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                ],
              ),
            ),

            // Main scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    // White card container
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFD1D5DB)),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeaderSection(),
                          _buildParticularBar(),
                          _buildTableSection(),
                          _buildFooterTotals(),
                        ],
                      ),
                    ),

                    // Action Buttons
                    const SizedBox(height: 12),
                    _buildActionButtons(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Header: 4-column grid matching React's grid-cols-4
  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFFF0F7FF), // blue-50/30
        border: Border(bottom: BorderSide(color: Color(0xFFD1D5DB))),
      ),
      child: Row(
        children: [
          // Record Type
          Expanded(child: _headerField('Record Type :', _buildRecordTypeDropdown())),
          const SizedBox(width: 16),
          // Bill Series
          Expanded(child: _headerField('Bill Series :', _buildBillSeriesDropdown())),
          const SizedBox(width: 16),
          // Bill No
          Expanded(child: _headerField('Bill No. :', _buildBillNoInput())),
          const SizedBox(width: 16),
          // Date
          Expanded(child: _headerField('Date :', _buildDateInput())),
        ],
      ),
    );
  }

  Widget _headerField(String label, Widget input) {
    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(label,
              style: const TextStyle(fontSize: 13, color: Color(0xFF374151), fontWeight: FontWeight.w500)),
        ),
        Expanded(child: input),
      ],
    );
  }

  Widget _buildRecordTypeDropdown() {
    final options = ['Payment', 'Receipt', 'Journal', 'Contra', 'Debit', 'Credit'];
    return _styledDropdown(_recordType, options, (v) {
      if (v == null) return;
      setState(() {
        _recordType = v;
        _billSeries = _getBillSeriesOptions(v)[0];
      });
      _fetchNextBillNo();
    });
  }

  Widget _buildBillSeriesDropdown() {
    final options = _getBillSeriesOptions(_recordType);
    final safeVal = options.contains(_billSeries) ? _billSeries : options.first;
    return _styledDropdown(safeVal, options, (v) {
      if (v == null) return;
      setState(() => _billSeries = v);
      _fetchNextBillNo();
    });
  }

  Widget _buildBillNoInput() {
    return Container(
      height: 30,
      width: 96,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD1D5DB)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextFormField(
        initialValue: _billNo,
        onChanged: (v) => _billNo = v,
        style: const TextStyle(fontSize: 13),
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildDateInput() {
    return InkWell(
      onTap: () async {
        final d = await showDatePicker(
          context: context,
          initialDate: _date,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (d != null && mounted) setState(() => _date = d);
      },
      child: Container(
        height: 30,
        width: 144,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFD1D5DB)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(DateFormat('dd-MM-yyyy').format(_date),
                  style: const TextStyle(fontSize: 13)),
            ),
            const Icon(LucideIcons.calendar, size: 14, color: Color(0xFF6B7280)),
          ],
        ),
      ),
    );
  }

  Widget _styledDropdown(String value, List<String> options, Function(String?) onChanged) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD1D5DB)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          isExpanded: true,
          style: const TextStyle(fontSize: 13, color: Color(0xFF1F2937)),
          items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // "Particular" sub-header
  Widget _buildParticularBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: const BoxDecoration(
        color: Color(0xFFF9FAFB),
        border: Border(bottom: BorderSide(color: Color(0xFFD1D5DB))),
      ),
      child: Row(
        children: const [
          Text('Particular', style: TextStyle(fontSize: 13, color: Color(0xFF1F2937), fontWeight: FontWeight.w500)),
          SizedBox(width: 8),
          Text('(Press alt+2 for add acc)', style: TextStyle(fontSize: 12, color: Color(0xFFDC2626))),
        ],
      ),
    );
  }

  // Main table section
  Widget _buildTableSection() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 24),
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {
            0: FixedColumnWidth(40),   // SN
            1: FixedColumnWidth(240),  // Account
            2: FixedColumnWidth(112),  // Balance
            3: FixedColumnWidth(128),  // Debit
            4: FixedColumnWidth(128),  // Credit
            5: FixedColumnWidth(128),  // Mode of Payment
            6: FixedColumnWidth(128),  // Chq/Doc No
            7: FixedColumnWidth(130),  // Chq/Doc Dt
            8: FlexColumnWidth(),      // Remark
            9: FixedColumnWidth(48),   // Delete
          },
          children: [
            _buildTableHeader(),
            ..._rows.asMap().entries.map((e) => _buildTableRow(e.key, e.value)),
            // Filler rows (React shows min 5 rows)
            ...List.generate(
              (5 - _rows.length).clamp(0, 5),
              (i) => _buildFillerRow(),
            ),
            _buildTableFooter(),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableHeader() {
    const headerStyle = TextStyle(
        fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF374151));
    const blueHeaderStyle = TextStyle(
        fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF1E40AF));

    Widget hCell(String text, {TextAlign align = TextAlign.left, TextStyle? style}) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: const BoxDecoration(
          border: Border(right: BorderSide(color: Colors.white)),
        ),
        child: Text(text, textAlign: align, style: style ?? headerStyle),
      );
    }

    return TableRow(
      decoration: const BoxDecoration(
        color: Color(0xFFE8F0FE),
        border: Border(bottom: BorderSide(color: Color(0xFFBFDBFE))),
      ),
      children: [
        hCell('SN.', align: TextAlign.left),
        hCell('Account', style: blueHeaderStyle),
        hCell('Balance', align: TextAlign.right),
        hCell('Debit', align: TextAlign.right, style: blueHeaderStyle),
        hCell('Credit', align: TextAlign.right),
        hCell('Mode of Payment', align: TextAlign.center),
        hCell('Chq/Doc No'),
        hCell('Chq/Doc Dt'),
        hCell('Remark'),
        hCell('Dlt', align: TextAlign.center),
      ],
    );
  }

  TableRow _buildTableRow(int index, Map<String, dynamic> row) {
    final accounts = context.read<AccountProvider>().accounts;
    final filtered = accounts.where((a) =>
        (a.name ?? '').toLowerCase().contains((row['account'] as String).toLowerCase())).toList();

    return TableRow(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      children: [
        // SN
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Text((index + 1).toString(),
              style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280), fontWeight: FontWeight.w500),
              textAlign: TextAlign.center),
        ),

        // Account with suggestion dropdown
        _buildAccountCell(index, row, filtered),

        // Balance (read-only)
        Container(
          color: const Color(0xFAFAFAFF),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Text(
            row['balance'] != 0
                ? '${(row['balance'] as double).toStringAsFixed(0)} ${row['balanceType'] ?? 'Dr'}'
                : '0 Dr',
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
          ),
        ),

        // Debit
        _buildNumberCell(index, 'debit', row['debit'] as double),

        // Credit
        _buildNumberCell(index, 'credit', row['credit'] as double),

        // Mode of Payment
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: row['modeOfPayment'] as String,
              isDense: true,
              isExpanded: true,
              style: const TextStyle(fontSize: 12, color: Color(0xFF1F2937)),
              items: ['Cash', 'Bank', 'Cheque']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e, textAlign: TextAlign.center)))
                  .toList(),
              onChanged: (v) => _updateRow(index, 'modeOfPayment', v ?? 'Cash'),
            ),
          ),
        ),

        // Chq/Doc No
        _buildTextCell(index, 'chqDocNo', row['chqDocNo'] as String),

        // Chq/Doc Dt - date picker
        _buildDateCell(index, row['chqDocDate'] as DateTime?),

        // Remark
        _buildTextCell(index, 'remark', row['remark'] as String, hint: 'Enter remark...'),

        // Delete X button
        Center(
          child: InkWell(
            onTap: () => _removeRow(index),
            child: Container(
              width: 24, height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFFADD8E6),
                borderRadius: BorderRadius.circular(4),
              ),
              alignment: Alignment.center,
              child: const Text('X',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF004E6B))),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountCell(int index, Map<String, dynamic> row, List<AccountModel> filtered) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(right: BorderSide(color: Colors.grey.shade200)),
          ),
          child: TextFormField(
            initialValue: row['account'] as String,
            onChanged: (v) {
              setState(() {
                _rows[index]['account'] = v;
                _rows[index]['showSuggestions'] = v.isNotEmpty;
              });
            },
            onTap: () => setState(() => _rows[index]['showSuggestions'] = true),
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1F2937)),
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              border: InputBorder.none,
            ),
          ),
        ),
        if ((row['showSuggestions'] as bool) && filtered.isNotEmpty)
          Positioned(
            top: 36,
            left: 0,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(4),
              child: Container(
                width: 400,
                constraints: const BoxConstraints(maxHeight: 240),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF60A5FA)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Blue header like React
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      color: const Color(0xFF3B82F6),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text('Text Suggestion',
                                style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                          InkWell(
                            onTap: () => setState(() => _rows[index]['showSuggestions'] = false),
                            child: const Icon(LucideIcons.x, size: 12, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(4),
                        itemCount: filtered.length,
                        itemBuilder: (ctx, i) {
                          final acc = filtered[i];
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _rows[index]['account'] = acc.name ?? '';
                                _rows[index]['accountId'] = acc.id ?? '';
                                _rows[index]['balance'] = acc.openingBalance?.balance ?? 0.0;
                                _rows[index]['balanceType'] = 'Dr';
                                _rows[index]['showSuggestions'] = false;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
                              ),
                              child: Text(acc.name ?? '',
                                  style: const TextStyle(fontSize: 13)),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNumberCell(int index, String field, double value) {
    return Container(
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey.shade200)),
      ),
      child: TextFormField(
        key: ValueKey('${index}_${field}_$value'),
        initialValue: value == 0 ? '' : value.toStringAsFixed(0),
        onChanged: (v) => _updateRow(index, field, double.tryParse(v) ?? 0.0),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textAlign: TextAlign.right,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1F2937)),
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildTextCell(int index, String field, String value, {String? hint}) {
    return Container(
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey.shade200)),
      ),
      child: TextFormField(
        key: ValueKey('${index}_${field}_$value'),
        initialValue: value,
        onChanged: (v) => setState(() => _rows[index][field] = v),
        style: const TextStyle(fontSize: 12, color: Color(0xFF1F2937)),
        decoration: InputDecoration(
          isDense: true,
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildDateCell(int index, DateTime? date) {
    return InkWell(
      onTap: () async {
        final d = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (d != null) setState(() => _rows[index]['chqDocDate'] = d);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          border: Border(right: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Text(
          date != null ? DateFormat('dd-MM-yy').format(date) : '',
          style: const TextStyle(fontSize: 12, color: Color(0xFF1F2937)),
        ),
      ),
    );
  }

  TableRow _buildFillerRow() {
    return TableRow(
      decoration: BoxDecoration(
        color: const Color(0xFAFAFAFF),
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      children: List.generate(10, (_) => const SizedBox(height: 36)),
    );
  }

  // tfoot-style footer row
  TableRow _buildTableFooter() {
    return TableRow(
      decoration: const BoxDecoration(
        color: Color(0xFFF9FAFB),
        border: Border(top: BorderSide(color: Color(0xFFD1D5DB), width: 2)),
      ),
      children: [
        const SizedBox(height: 36), // SN
        const SizedBox(),           // Account (colspan 3 effect via empty cells)
        const SizedBox(),           // Balance
        // Debit total (col 3)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Text(_totalDebit.toStringAsFixed(2),
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
        ),
        // Credit total (col 4)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Text(_totalCredit.toStringAsFixed(2),
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
        ),
        const SizedBox(), // Mode
        const SizedBox(), // ChqNo
        const SizedBox(), // ChqDt
        // Unbalanced warning
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          alignment: Alignment.centerRight,
          child: !_isBalanced
              ? const Text('Warning: Unbalanced',
                  style: TextStyle(color: Colors.red, fontSize: 11, fontStyle: FontStyle.italic))
              : const SizedBox.shrink(),
        ),
        // Add Row (+) button
        Center(
          child: InkWell(
            onTap: _addRow,
            child: Container(
              width: 24, height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFFADD8E6),
                borderRadius: BorderRadius.circular(4),
              ),
              alignment: Alignment.center,
              child: const Text('+',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF004E6B))),
            ),
          ),
        ),
      ],
    );
  }

  // Compact footer: Total Amount
  Widget _buildFooterTotals() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFF9FAFB),
        border: Border(top: BorderSide(color: Color(0xFFD1D5DB))),
      ),
      child: Row(
        children: [
          Text(
            'Total Amount: ₹${_totalDebit.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
          ),
        ],
      ),
    );
  }

  // Action buttons
  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: _isLoading ? null : _handleSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD94838),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            elevation: 2,
          ),
          child: _isLoading
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Text('Save', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () => context.go('/transaction/vouchers'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD94838),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            elevation: 2,
          ),
          child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        ),
      ],
    );
  }
}
