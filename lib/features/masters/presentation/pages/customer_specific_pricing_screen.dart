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
      backgroundColor: const Color(0xFFF8FAFC), // bg-slate-50
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Customer Specific Pricing", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: Color(0xFF0F172A), letterSpacing: -0.5)),
                      const SizedBox(height: 4),
                      Text("Assign custom prices to individual parties for products and lenses", style: TextStyle(color: const Color(0xFF64748B), fontSize: 14, fontStyle: FontStyle.italic, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))],
                        ),
                        child: Row(
                          children: [
                            _buildToggleBtn("Sale", _priceType == "Sale"),
                            _buildToggleBtn("Purchase", _priceType == "Purchase"),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [BoxShadow(color: const Color(0xFF059669).withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: _isLoading || _selectedAccount == null ? null : _handleSave,
                          icon: const Icon(LucideIcons.save, size: 20),
                          label: const Text("Save Prices"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF059669),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: const Color(0xFF059669).withOpacity(0.5),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    ],
                  )
                ]
              )
            ),

            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Side Pane: Parties
                  Container(
                    width: 320,
                    margin: const EdgeInsets.only(right: 32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [BoxShadow(color: const Color(0xFFE2E8F0).withOpacity(0.5), blurRadius: 16, offset: const Offset(0, 4))],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                            border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
                          ),
                          child: TextField(
                            onChanged: (val) => setState(() => _accountSearch = val),
                             decoration: InputDecoration(
                               hintText: "Search Party...",
                               hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                               prefixIcon: const Icon(LucideIcons.search, size: 16, color: Color(0xFF94A3B8)),
                               filled: true,
                               fillColor: Colors.white,
                               border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                               enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                               focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Color(0xFF3B82F6), width: 2)),
                               contentPadding: const EdgeInsets.symmetric(vertical: 0),
                             ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: filteredAccounts.length,
                            itemBuilder: (context, index) {
                               final acc = filteredAccounts[index];
                               final isSelected = _selectedAccount?.id == acc.id;
                               return Container(
                                 margin: const EdgeInsets.only(bottom: 4),
                                 decoration: BoxDecoration(
                                   color: isSelected ? const Color(0xFFEFF6FF) : Colors.transparent,
                                   borderRadius: BorderRadius.circular(12),
                                   border: isSelected ? Border.all(color: const Color(0xFFDBEAFE)) : Border.all(color: Colors.transparent),
                                 ),
                                 child: InkWell(
                                   borderRadius: BorderRadius.circular(12),
                                   onTap: () => _fetchAccountData(acc),
                                   hoverColor: const Color(0xFFF8FAFC),
                                   child: Padding(
                                     padding: const EdgeInsets.all(12),
                                     child: Row(
                                       children: [
                                         Container(
                                           padding: const EdgeInsets.all(8),
                                           decoration: BoxDecoration(
                                             color: isSelected ? const Color(0xFFDBEAFE) : const Color(0xFFF1F5F9),
                                             borderRadius: BorderRadius.circular(8),
                                           ),
                                           child: Icon(LucideIcons.user, size: 16, color: isSelected ? const Color(0xFF1D4ED8) : const Color(0xFF64748B)),
                                         ),
                                         const SizedBox(width: 12),
                                         Expanded(
                                           child: Column(
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                                                Text(acc.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isSelected ? const Color(0xFF1D4ED8) : const Color(0xFF475569))),
                                                const SizedBox(height: 2),
                                                Text(acc.accountCategory ?? "1001", style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
                                             ],
                                           ),
                                         ),
                                         if (isSelected) const Icon(LucideIcons.chevronRight, size: 16, color: Color(0xFF3B82F6)),
                                       ]
                                     )
                                   )
                                 )
                               );
                            }
                          )
                        )
                      ]
                    )
                  ),

                  // Main Pane: Products
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [BoxShadow(color: const Color(0xFFE2E8F0).withOpacity(0.5), blurRadius: 16, offset: const Offset(0, 4))],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                              border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
                            ),
                            child: Row(
                              children: [
                                 const Icon(LucideIcons.package, color: Color(0xFF2563EB), size: 24),
                                 const SizedBox(width: 12),
                                 Text(_selectedAccount != null ? "Pricing for: ${_selectedAccount!.name}" : "Products List", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
                                 const Spacer(),
                                 SizedBox(
                                   width: 300,
                                   child: TextField(
                                     onChanged: (val) => setState(() => _productSearch = val),
                                     decoration: InputDecoration(
                                       hintText: "Search Product or Group...",
                                       hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                                       prefixIcon: const Icon(LucideIcons.search, size: 16, color: Color(0xFF94A3B8)),
                                       filled: true,
                                       fillColor: Colors.white,
                                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                                       enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                                       focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2)),
                                       contentPadding: const EdgeInsets.symmetric(vertical: 0),
                                     )
                                   )
                                 )
                              ]
                            )
                          ),
                          
                          // The Headers Row
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0)))),
                            child: Row(
                              children: [
                                 _colHeader("Sr.", flex: 1),
                                 _colHeader("Product Info", flex: 4),
                                 _colHeader("Power Group", flex: 3),
                                 _colHeader("Default Price", flex: 2, center: true),
                                 _colHeader("Percentage (%)", flex: 2, center: true),
                                 _colHeader("Custom Price", flex: 2, center: true),
                                 _colHeader("Status", flex: 2, center: true),
                              ]
                            )
                          ),
                          
                          // Content
                          Expanded(
                            child: _selectedAccount == null
                               ? _buildReactEmptyState()
                               : ListView.separated(
                                   padding: EdgeInsets.zero,
                                   separatorBuilder: (c, i) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
                                   itemCount: filteredProducts.length,
                                   itemBuilder: (context, index) => _buildReactProductRow(filteredProducts[index], index + 1),
                               )
                          ),

                          // Footer (if selected)
                          if (_selectedAccount != null) ...[
                              const Divider(height: 1, color: Color(0xFFE2E8F0)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                decoration: const BoxDecoration(color: Color(0xFFF8FAFC), borderRadius: BorderRadius.vertical(bottom: Radius.circular(16))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                     Row(
                                       children: [
                                          const Text("TOTAL PRODUCTS: ", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1, color: Color(0xFF64748B))),
                                          Text("${filteredProducts.length}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                                       ]
                                     ),
                                     TextButton(
                                       onPressed: () {
                                          setState(() {
                                            _customPrices.clear();
                                            _percentages.clear();
                                            _selectedPGs.clear();
                                          });
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cleared all un-saved changes')));
                                       },
                                       style: TextButton.styleFrom(foregroundColor: const Color(0xFFE11D48)),
                                       child: const Text("CLEAR ALL CHANGES", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1))
                                     )
                                  ]
                                )
                              )
                          ]
                        ]
                      )
                    )
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleBtn(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() => _priceType = label);
        if (_selectedAccount != null) _fetchAccountData(_selectedAccount!);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected ? [BoxShadow(color: const Color(0xFFBFDBFE), blurRadius: 4, offset: const Offset(0, 2))] : null,
        ),
        child: Text(label, style: TextStyle(color: isSelected ? Colors.white : const Color(0xFF475569), fontWeight: isSelected ? FontWeight.bold : FontWeight.w600, fontSize: 13)),
      ),
    );
  }

  Widget _buildReactProductRow(Map<String, dynamic> p, int index) {
      final pId = p['id'] as String;
      final isLens = p['isLens'] == true;
      final priceKey = _priceType == "Sale" ? 'salePrice' : 'purchasePrice';
      final dynamic slPrice = isLens ? (p[priceKey] != null ? p[priceKey]['default'] : 0) : p[priceKey];
      final double basePrice = double.tryParse(slPrice.toString()) ?? 0.0;
      final bool hasCustom = _customPrices.containsKey(pId);
      
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             // Sr
             Expanded(flex: 1, child: Text("$index", style: const TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.w600, fontSize: 13))),
             
             // Info
             Expanded(flex: 4, child: Row(
               children: [
                 Container(
                   padding: const EdgeInsets.all(8),
                   decoration: BoxDecoration(color: isLens ? const Color(0xFFFAF5FF) : const Color(0xFFFFF7ED), borderRadius: BorderRadius.circular(8)),
                   child: Icon(isLens ? LucideIcons.layers : LucideIcons.package, size: 16, color: isLens ? const Color(0xFF9333EA) : const Color(0xFFEA580C)),
                 ),
                 const SizedBox(width: 12),
                 Expanded(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(p['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
                       const SizedBox(height: 2),
                       Row(
                         children: [
                           Text(p['groupName'] ?? '', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
                           Container(margin: const EdgeInsets.symmetric(horizontal: 6), width: 4, height: 4, decoration: const BoxDecoration(color: Color(0xFFCBD5E1), shape: BoxShape.circle)),
                           Text(isLens ? "Lens" : "Item", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
                         ]
                       )
                     ]
                   )
                 )
               ]
             )),
             
             // Power Group
             Expanded(flex: 3, child: _buildReactPowerGroups(p, pId, isLens)),
             
             // Default Price
             Expanded(flex: 2, child: Center(
               child: Container(
                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                 decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
                 child: Text("₹$basePrice", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF475569)))
               )
             )),

             // Percentage
             Expanded(flex: 2, child: Center(
                 child: SizedBox(
                   width: 70, 
                   child: TextFormField(
                      key: Key("pc_${pId}_$_priceType"),
                      initialValue: _percentages[pId]?.toString() ?? "",
                      onChanged: (v) => _handlePercentageChange(pId, v, basePrice),
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF334155)),
                      decoration: InputDecoration(
                        suffixText: "%",
                        suffixStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                        isDense: true,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFF1F5F9), width: 2)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFF1F5F9), width: 2)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF60A5FA), width: 2)),
                      )
                   )
                 )
             )),

             // Custom Price
             Expanded(flex: 2, child: Center(
                 child: SizedBox(
                   width: 100, 
                   child: TextFormField(
                      key: Key("cp_${pId}_$_priceType"),
                      initialValue: _customPrices[pId]?.toString() ?? "",
                      onChanged: (v) => _handlePriceChange(pId, v, basePrice),
                      textAlign: TextAlign.right,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: hasCustom ? const Color(0xFF1D4ED8) : const Color(0xFF334155)),
                      decoration: InputDecoration(
                        prefixText: "₹",
                        prefixStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: hasCustom ? const Color(0xFF3B82F6) : const Color(0xFF94A3B8)),
                        hintText: basePrice.toString(),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                        isDense: true,
                        filled: true,
                        fillColor: hasCustom ? const Color(0xFFEFF6FF) : Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: hasCustom ? const Color(0xFFBFDBFE) : const Color(0xFFF1F5F9), width: 2)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: hasCustom ? const Color(0xFFBFDBFE) : const Color(0xFFF1F5F9), width: 2)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2)),
                      )
                   )
                 )
             )),

             // Status
             Expanded(flex: 2, child: Center(
                child: hasCustom
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFD1FAE5), borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                           Container(width: 6, height: 6, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF10B981))),
                           const SizedBox(width: 6),
                           const Text("CUSTOM SET", style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFF047857), letterSpacing: 0.5)),
                        ]
                      )
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(20)),
                      child: const Text("DEFAULT", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 0.5))
                    )
             )),

          ]
        )
      );
  }

  Widget _colHeader(String title, {required int flex, bool center = false}) {
     return Expanded(
       flex: flex,
       child: Text(title.toUpperCase(), textAlign: center ? TextAlign.center : TextAlign.left, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1, color: Color(0xFF64748B))),
     );
  }

  Widget _buildReactPowerGroups(Map<String, dynamic> p, String pId, bool isLens) {
     List<dynamic> pgs = [];
     if (isLens && p['powerGroups'] != null) {
        if (p['powerGroups'] is Map) {
           pgs = [p['powerGroups']];
        } else if (p['powerGroups'] is List) {
           pgs = p['powerGroups'] as List;
        }
     }
     
     if (!isLens || pgs.isEmpty) {
        return Row(
          children: const [
             Icon(LucideIcons.rotateCcw, size: 12, color: Color(0xFFCBD5E1)),
             SizedBox(width: 6),
             Text("No Power Groups", style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, fontWeight: FontWeight.w500, color: Color(0xFF94A3B8))),
          ]
        );
     }
     return Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       mainAxisAlignment: MainAxisAlignment.center,
       children: pgs.map((pg) {
         final pgId = (pg['_id'] ?? pg['id'] ?? '').toString();
         if (pgId.isEmpty) return const SizedBox.shrink(); // Safety fallback
         final isSel = _selectedPGs[pId]?[pgId] ?? false;
         final currentPrice = _pgPricingData[pId]?[pgId];
         return Row(
           crossAxisAlignment: CrossAxisAlignment.center,
           children: [
              SizedBox(width: 20, height: 20, child: Checkbox(value: isSel, activeColor: const Color(0xFF2563EB), side: const BorderSide(color: Color(0xFFCBD5E1)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)), onChanged: (v) {
                setState(() => _selectedPGs.putIfAbsent(pId, () => {})[pgId] = v ?? false);
              })),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pg['label']?.toString() ?? '', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF334155)), overflow: TextOverflow.ellipsis, maxLines: 1),
                    if (currentPrice != null)
                      Text("Current Party: ₹$currentPrice", style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFF059669), letterSpacing: -0.5), overflow: TextOverflow.ellipsis, maxLines: 1)
                  ],
                ),
              )
           ]
         );
       }).toList()
     );
  }

  Widget _buildReactEmptyState() {
     return Center(
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
            Container(
              width: 80, height: 80, 
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFF8FAFC)),
              alignment: Alignment.center,
              child: const Icon(LucideIcons.user, size: 40, color: Color(0xFFE2E8F0)),
            ),
            const SizedBox(height: 16),
            const Text("Selection Required", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            const SizedBox(height: 4),
            const Text("Please select a customer from the left to manage prices", style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
         ]
       )
     );
  }
}
