import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../data/providers/account_wise_price_provider.dart';
import '../../data/providers/power_group_pricing_provider.dart';
import '../../data/providers/account_provider.dart';
import '../../data/providers/inventory_providers.dart';
import '../../../masters/data/models/account_model.dart';

class CustomerSpecificPricingScreen extends StatefulWidget {
  const CustomerSpecificPricingScreen({super.key});

  @override
  State<CustomerSpecificPricingScreen> createState() => _CustomerSpecificPricingScreenState();
}

class _CustomerSpecificPricingScreenState extends State<CustomerSpecificPricingScreen> {
  bool _isLoading = false;
  
  List<AccountModel> _accounts = [];
  List<Map<String, dynamic>> _products = [];
  List<String> _categories = ["All Categories"];
  
  AccountModel? _selectedAccount;
  String _selectedCategory = "All Categories";
  
  Map<String, double> _customPrices = {}; 
  Map<String, double> _percentages = {}; 
  Map<String, Map<String, bool>> _selectedPGs = {}; 
  Map<String, Map<String, double>> _pgPricingData = {}; 

  String _accountSearch = "";
  String _productSearch = "";
  String _priceType = "Sale";
  String _productFilter = "All"; // All, Lenses, Items

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchInitialData();
    });
  }

  Future<void> _fetchInitialData() async {
    setState(() => _isLoading = true);
    try {
      final accountProvider = Provider.of<AccountProvider>(context, listen: false);
      final itemProvider = Provider.of<ItemMasterProvider>(context, listen: false);
      final lensProvider = Provider.of<LensGroupProvider>(context, listen: false);

      await accountProvider.fetchAllAccounts();
      await itemProvider.fetchItems();
      final lenses = await lensProvider.getAllLensPower();

      List<Map<String, dynamic>> allProds = [];
      Set<String> cats = {"All Categories"};

      for (var l in lenses) {
        l['isLens'] = true;
        l['id'] = l['_id'];
        l['name'] = l['productName'];
        allProds.add(l);
      }

      for (var i in itemProvider.items) {
        allProds.add({
          'isLens': false,
          'id': i.id,
          'name': i.itemName,
          'groupName': i.groupName,
          'salePrice': i.salePrice,
          'purchasePrice': i.purchasePrice,
        });
      }

      for (var acc in accountProvider.accounts) {
        if (acc.accountCategory != null && acc.accountCategory!.isNotEmpty) {
          cats.add(acc.accountCategory!);
        }
      }

      setState(() {
        _accounts = accountProvider.accounts;
        _products = allProds;
        _categories = cats.toList()..sort();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to load initial data.')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchAccountData(AccountModel acc) async {
    setState(() {
      _selectedAccount = acc;
      _customPrices.clear();
      _percentages.clear();
      _selectedPGs.clear();
      _pgPricingData.clear();
      _isLoading = true;
    });
    
    try {
      final priceProvider = Provider.of<AccountWisePriceProvider>(context, listen: false);
      final pgProvider = Provider.of<PowerGroupPricingProvider>(context, listen: false);

      final prices = await priceProvider.getAccountWisePrices(acc.id, type: _priceType);
      final pgPrices = await pgProvider.getPowerGroupPricing(acc.id, priceType: _priceType);

      setState(() {
        for (var p in prices) {
          final key = p['itemId'] ?? p['lensGroupId'];
          if (key != null) {
             _customPrices[key] = (p['customPrice'] ?? 0).toDouble();
             _percentages[key] = (p['percentage'] ?? 0).toDouble();
          }
        }

        for (var p in pgPrices) {
          final prodId = p['productId'];
          final pgId = p['powerGroupId'];
          if (prodId != null && pgId != null) {
             _pgPricingData.putIfAbsent(prodId, () => {})[pgId] = (p['customPrice'] ?? 0).toDouble();
             _selectedPGs.putIfAbsent(prodId, () => {})[pgId] = true;
          }
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error fetching account pricing.')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handlePriceChange(String productId, String value, double basePrice) {
    if (value.isEmpty) {
      setState(() {
        _customPrices.remove(productId);
        _percentages.remove(productId);
      });
      return;
    }
    
    final val = double.tryParse(value);
    if (val != null) {
      setState(() {
        _customPrices[productId] = val;
        if (basePrice > 0) {
           _percentages[productId] = ((basePrice - val) / basePrice) * 100;
        }
      });
    }
  }

  void _handlePercentageChange(String productId, String value, double basePrice) {
    if (value.isEmpty) {
      setState(() {
        _percentages.remove(productId);
        _customPrices.remove(productId);
      });
      return;
    }
    
    final percent = double.tryParse(value);
    if (percent != null) {
      setState(() {
        _percentages[productId] = percent;
        _customPrices[productId] = double.parse((basePrice - (basePrice * percent / 100)).toStringAsFixed(2));
      });
    }
  }

  Future<void> _handleSave() async {
    if (_selectedAccount == null) return;
    
    setState(() => _isLoading = true);
    try {
      List<Map<String, dynamic>> pricesToSave = [];
      _customPrices.forEach((productId, price) {
        final prod = _products.firstWhere((p) => p['id'] == productId, orElse: () => {});
        if (prod.isEmpty) return;
        
        pricesToSave.add({
          'accountId': _selectedAccount!.id,
          'itemId': prod['isLens'] == true ? null : productId,
          'lensGroupId': prod['isLens'] == true ? productId : null,
          'customPrice': price,
          'percentage': _percentages[productId] ?? 0,
          'type': _priceType,
        });
      });

      List<Map<String, dynamic>> pgPricesToSave = [];
      _selectedPGs.forEach((productId, pgs) {
        final rowPrice = _customPrices[productId];
        if (rowPrice == null) return;
        
        pgs.forEach((pgId, selected) {
          if (selected) {
            pgPricesToSave.add({
               'partyId': _selectedAccount!.id,
               'productId': productId,
               'powerGroupId': pgId,
               'customPrice': rowPrice,
               'priceType': _priceType
            });
          }
        });
      });
      
      final priceProvider = Provider.of<AccountWisePriceProvider>(context, listen: false);
      final pgProvider = Provider.of<PowerGroupPricingProvider>(context, listen: false);

      bool allSuccess = true;
      if (pricesToSave.isNotEmpty) {
         final res = await priceProvider.bulkUpsertAccountWisePrices(pricesToSave);
         if (res['success'] == false) allSuccess = false;
      }
      
      if (pgPricesToSave.isNotEmpty) {
         final res = await pgProvider.upsertPowerGroupPricing(pgPricesToSave);
         if (res['success'] == false) allSuccess = false;
      }
      
      if (allSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pricing saved successfully.')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to save some prices.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleApplyToCategory() async {
    if (_selectedAccount == null || _selectedCategory == "All Categories") {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a category and a target account to copy from.')));
       return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Apply to Category"),
        content: Text("Apply prices set for ${_selectedAccount!.name} to ALL accounts in the '$_selectedCategory' category?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Apply Bulk")),
        ],
      )
    );
    if (confirm != true) return;

    setState(() => _isLoading = true);
    try {
      final categoryAccounts = _accounts.where((a) => a.accountCategory == _selectedCategory).toList();
      final priceProvider = Provider.of<AccountWisePriceProvider>(context, listen: false);

      for (var acc in categoryAccounts) {
        if (acc.id == _selectedAccount!.id) continue;
        
        List<Map<String, dynamic>> pricesToSave = [];
        _customPrices.forEach((productId, price) {
          final prod = _products.firstWhere((p) => p['id'] == productId, orElse: () => {});
          pricesToSave.add({
            'accountId': acc.id,
            'itemId': prod['isLens'] == true ? null : productId,
            'lensGroupId': prod['isLens'] == true ? productId : null,
            'customPrice': price,
            'percentage': _percentages[productId] ?? 0,
            'type': _priceType,
          });
        });

        if (pricesToSave.isNotEmpty) {
           await priceProvider.bulkUpsertAccountWisePrices(pricesToSave);
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bulk category pricing applied!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error applying bulk pricing: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredAccounts = _accounts.where((a) {
      final matchesSearch = (a.name ?? '').toLowerCase().contains(_accountSearch.toLowerCase());
      final matchesCat = _selectedCategory == "All Categories" || a.accountCategory == _selectedCategory;
      return matchesSearch && matchesCat;
    }).toList();
      
    final filteredProducts = _products.where((p) {
      final matchesSearch = (p['name'] ?? '').toLowerCase().contains(_productSearch.toLowerCase());
      final isLens = p['isLens'] == true;
      final matchesFilter = _productFilter == "All" || 
                            (_productFilter == "Lenses" && isLens) ||
                            (_productFilter == "Items" && !isLens);
      return matchesSearch && matchesFilter;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Column(
        children: [
          // Header
          _buildHeader(),

          Expanded(
            child: Row(
              children: [
                // Side Pane: Parties
                _buildPartyPane(filteredAccounts),

                // Main Pane: Products
                Expanded(child: _buildProductPane(filteredProducts)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.indigo[900]!, Colors.indigo[700]!]),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Account Wise Pricing", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 4),
              Text("Assign B2B tier pricing and custom overrides", style: TextStyle(color: Colors.indigo[100], fontSize: 13)),
            ],
          ),
          Row(
            children: [
              _buildTypeToggle(),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: _isLoading || _selectedAccount == null ? null : _handleApplyToCategory,
                icon: const Icon(LucideIcons.layers, size: 18),
                label: const Text("Apply to Category"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.indigo[900], padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _isLoading || _selectedAccount == null ? null : _handleSave,
                icon: const Icon(LucideIcons.save, size: 18),
                label: const Text("Save Overrides"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green[500], foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14)),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTypeToggle() {
    return Container(
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          _buildToggleButton("Sale", _priceType == "Sale"),
          _buildToggleButton("Purchase", _priceType == "Purchase"),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() => _priceType = label);
        if (_selectedAccount != null) _fetchAccountData(_selectedAccount!);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(label, style: TextStyle(color: isSelected ? Colors.indigo[900] : Colors.white, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      ),
    );
  }

  Widget _buildPartyPane(List<AccountModel> accounts) {
    return Container(
      width: 320,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  onChanged: (val) => setState(() => _accountSearch = val),
                  decoration: InputDecoration(
                    hintText: "Search Party...",
                    prefixIcon: const Icon(LucideIcons.search, size: 18),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 13)))).toList(),
                  onChanged: (v) => setState(() => _selectedCategory = v!),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(LucideIcons.filter, size: 16),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              itemCount: accounts.length,
              separatorBuilder: (_, __) => const Divider(height: 1, indent: 64),
              itemBuilder: (context, index) {
                final acc = accounts[index];
                final isSelected = _selectedAccount?.id == acc.id;
                return ListTile(
                  selected: isSelected,
                  selectedTileColor: Colors.indigo[50],
                  onTap: () => _fetchAccountData(acc),
                  leading: CircleAvatar(
                    backgroundColor: isSelected ? Colors.indigo[100] : const Color(0xFFF1F5F9),
                    child: Text(acc.name.substring(0, 1).toUpperCase(), style: TextStyle(color: isSelected ? Colors.indigo[900] : Colors.blueGrey, fontWeight: FontWeight.bold)),
                  ),
                  title: Text(acc.name, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, fontSize: 13, color: isSelected ? Colors.indigo[900] : const Color(0xFF1E293B))),
                  subtitle: Text(acc.accountCategory ?? "No Category", style: const TextStyle(fontSize: 11, color: Colors.blueGrey)),
                  trailing: isSelected ? Icon(LucideIcons.chevronRight, size: 18, color: Colors.indigo[400]) : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductPane(List<Map<String, dynamic>> products) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 16, 16, 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Column(
        children: [
          _buildProductHeader(),
          const Divider(height: 1),
          Expanded(
            child: _selectedAccount == null 
              ? _buildEmptyState()
              : _isLoading ? const Center(child: CircularProgressIndicator()) : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: products.length,
                  itemBuilder: (context, index) => _buildProductRow(products[index]),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(LucideIcons.package, color: Colors.indigo[600]),
          const SizedBox(width: 12),
          Text(_selectedAccount != null ? "Overrides for ${_selectedAccount!.name}" : "Products List", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Spacer(),
          _buildFilterChip("All"),
          const SizedBox(width: 8),
          _buildFilterChip("Lenses"),
          const SizedBox(width: 8),
          _buildFilterChip("Items"),
          const SizedBox(width: 24),
          SizedBox(
            width: 300,
            child: TextField(
              onChanged: (val) => setState(() => _productSearch = val),
              decoration: InputDecoration(
                hintText: "Search items...",
                prefixIcon: const Icon(LucideIcons.search, size: 18),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _productFilter == label;
    return ChoiceChip(
      label: Text(label, style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : Colors.blueGrey)),
      selected: isSelected,
      onSelected: (v) => setState(() => _productFilter = label),
      selectedColor: Colors.indigo[600],
      backgroundColor: const Color(0xFFF1F5F9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: BorderSide.none,
    );
  }

  Widget _buildProductRow(Map<String, dynamic> p) {
    final pId = p['id'] as String;
    final isLens = p['isLens'] == true;
    final dynamic slPrice = isLens ? (p['salePrice'] != null ? p['salePrice']['default'] : 0) : p['salePrice'];
    final double basePrice = double.tryParse(slPrice.toString()) ?? 0.0;
    final bool hasCustom = _customPrices.containsKey(pId);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: hasCustom ? Colors.indigo.withOpacity(0.02) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: hasCustom ? Colors.indigo[200]! : const Color(0xFFE2E8F0)),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            _buildProductInfo(p, isLens),
            const VerticalDivider(width: 32),
            _buildPowerGroups(p, pId, isLens),
            const VerticalDivider(width: 32),
            _buildPricingInputs(pId, basePrice, hasCustom),
          ],
        ),
      ),
    );
  }

  Widget _buildProductInfo(Map<String, dynamic> p, bool isLens) {
    return Expanded(
      flex: 3,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: isLens ? Colors.purple[50] : Colors.orange[50], borderRadius: BorderRadius.circular(10)),
            child: Icon(isLens ? LucideIcons.layers : LucideIcons.box, color: isLens ? Colors.purple : Colors.orange, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(p['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 2),
                Text(p['groupName'] ?? '', style: TextStyle(fontSize: 12, color: Colors.blueGrey[400])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPowerGroups(Map<String, dynamic> p, String pId, bool isLens) {
    if (!isLens || p['powerGroups'] == null || (p['powerGroups'] as List).isEmpty) {
      return const Expanded(flex: 2, child: Center(child: Text("Standard Pricing", style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.blueGrey))));
    }

    final pgs = p['powerGroups'] as List;
    return Expanded(
      flex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: pgs.take(2).map((pg) {
          final pgId = pg['_id'] as String;
          final isSel = _selectedPGs[pId]?[pgId] ?? false;
          return Row(
            children: [
              SizedBox(width: 24, height: 24, child: Checkbox(value: isSel, activeColor: Colors.indigo, onChanged: (v) {
                setState(() => _selectedPGs.putIfAbsent(pId, () => {})[pgId] = v ?? false);
              })),
              Text(pg['label'] ?? '', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPricingInputs(String pId, double basePrice, bool hasCustom) {
    return Expanded(
      flex: 4,
      child: Row(
        children: [
          Expanded(child: _buildPriceDisplay("Base", basePrice)),
          const SizedBox(width: 16),
          Expanded(child: _buildInput(
            label: "% Disc",
            value: _percentages[pId]?.toString() ?? "",
            onChanged: (v) => _handlePercentageChange(pId, v, basePrice),
            suffix: "%",
          )),
          const SizedBox(width: 12),
          Expanded(child: _buildInput(
            label: "Custom",
            value: _customPrices[pId]?.toString() ?? "",
            onChanged: (v) => _handlePriceChange(pId, v, basePrice),
            prefix: "₹",
            highlight: hasCustom,
            key: Key("cp_${pId}"),
          )),
        ],
      ),
    );
  }

  Widget _buildPriceDisplay(String label, double price) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.blueGrey)),
        Text("₹$price", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }

  Widget _buildInput({required String label, required String value, required ValueChanged<String> onChanged, String? prefix, String? suffix, bool highlight = false, Key? key}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.blueGrey)),
        const SizedBox(height: 4),
        SizedBox(
          height: 36,
          child: TextFormField(
            key: key,
            initialValue: value,
            onChanged: onChanged,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              prefixText: prefix,
              suffixText: suffix,
              filled: highlight,
              fillColor: highlight ? Colors.indigo[50] : const Color(0xFFF8FAFC),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: highlight ? Colors.indigo[300]! : const Color(0xFFE2E8F0))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.indigo, width: 2)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.users, size: 60, color: Colors.indigo[100]),
          const SizedBox(height: 16),
          const Text("Select a Party to View Pricing", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          const SizedBox(height: 8),
          const Text("Choose an account from the left sidebar to assign custom price overrides.", textAlign: TextAlign.center, style: TextStyle(color: Colors.blueGrey)),
        ],
      ),
    );
  }
}
