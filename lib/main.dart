import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'core/network/api_client.dart';
import 'core/network/loading_provider.dart';

import 'core/auth/auth_provider.dart';
import 'core/router/app_router.dart';
import 'features/super_admin/data/providers/company_provider.dart';
import 'features/super_admin/data/providers/user_provider.dart';
import 'features/super_admin/data/providers/plan_provider.dart';
import 'features/super_admin/data/providers/settings_provider.dart';
import 'features/super_admin/data/providers/payment_history_provider.dart';
import 'features/masters/data/providers/account_group_provider.dart';
import 'features/masters/data/providers/account_provider.dart';
import 'features/masters/data/providers/tax_category_provider.dart';
import 'features/masters/data/providers/inventory_providers.dart';
import 'features/masters/data/providers/account_wise_price_provider.dart';
import 'features/masters/data/providers/power_group_pricing_provider.dart';
import 'features/sales/data/providers/lens_sale_order_provider.dart';
import 'features/sales/data/providers/lens_sale_challan_provider.dart';
import 'features/sales/data/providers/lens_sale_invoice_provider.dart';
import 'features/sales/data/providers/contact_lens_sale_order_provider.dart';
import 'features/sales/data/providers/rx_sale_order_provider.dart';
import 'features/sales/data/providers/rx_sale_provider.dart';
import 'features/sales/data/providers/sale_return_provider.dart';
import 'features/purchases/data/providers/purchase_provider.dart';
import 'features/inventory/presentation/providers/inventory_provider.dart';
import 'features/inventory/presentation/providers/product_exchange_provider.dart';
import 'features/vouchers/presentation/providers/voucher_provider.dart';
import 'features/reports/data/providers/outstanding_provider.dart';
import 'features/reports/data/providers/ledger_provider.dart';
import 'features/reports/data/providers/financial_provider.dart';
import 'features/reports/data/providers/target_provider.dart';
import 'features/reports/data/providers/operational_report_provider.dart';
import 'features/reports/data/providers/inventory_report_provider.dart';
import 'features/audits/data/providers/audit_provider.dart';
import 'features/utilities/data/providers/utility_provider.dart';
import 'features/company/data/providers/automation_provider.dart';
import 'features/reports/data/providers/active_report_provider.dart';
import 'features/reports/data/providers/analytics_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize essential global providers
  final authProvider = AuthProvider();
  final loadingProvider = LoadingProvider();
  
  await authProvider.initialize();

  // Initialize Desktop Window Manager (Step 1 Enhancement)
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(1280, 800),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    title: "Lens Wholesale ERP - Desktop",
    titleBarStyle: TitleBarStyle.normal,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  // Link ApiClient with its dependencies (Step 2 finalization)
  apiClient.init(authProvider, loadingProvider);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider.value(value: loadingProvider),
        ChangeNotifierProvider(create: (_) => CompanyProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => PlanProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => PaymentHistoryProvider()),
        ChangeNotifierProvider(create: (_) => AccountGroupProvider()),
        ChangeNotifierProvider(create: (_) => AccountProvider()),
        ChangeNotifierProvider(create: (_) => TaxCategoryProvider()),
        ChangeNotifierProvider(create: (_) => ItemGroupProvider()),
        ChangeNotifierProvider(create: (_) => ItemMasterProvider()),
        ChangeNotifierProvider(create: (_) => LensGroupProvider()),
        ChangeNotifierProvider(create: (_) => AccountWisePriceProvider()),
        ChangeNotifierProvider(create: (_) => PowerGroupPricingProvider()),
        ChangeNotifierProvider(create: (_) => LensSaleOrderProvider()),
        ChangeNotifierProvider(create: (_) => LensSaleChallanProvider()),
        ChangeNotifierProvider(create: (_) => LensSaleInvoiceProvider()),
        ChangeNotifierProvider(create: (_) => ContactLensSaleOrderProvider()),
        ChangeNotifierProvider(create: (_) => RxSaleOrderProvider()),
        ChangeNotifierProvider(create: (_) => RxSaleProvider()),
        ChangeNotifierProvider(create: (_) => SaleReturnProvider()),
        ChangeNotifierProvider(create: (_) => PurchaseProvider()),
        ChangeNotifierProvider(create: (_) => InventoryProvider()),
        ChangeNotifierProvider(create: (_) => ProductExchangeProvider()),
        ChangeNotifierProvider(create: (_) => VoucherProvider()),
        ChangeNotifierProvider(create: (_) => OutstandingProvider()),
        ChangeNotifierProvider(create: (_) => LedgerProvider()),
        ChangeNotifierProvider(create: (_) => FinancialProvider()),
        ChangeNotifierProvider(create: (_) => TargetProvider()),
        ChangeNotifierProvider(create: (_) => OperationalReportProvider()),
        ChangeNotifierProvider(create: (_) => InventoryReportProvider()),
        ChangeNotifierProvider(create: (_) => AuditProvider()),
        ChangeNotifierProvider(create: (_) => UtilityProvider()),
        ChangeNotifierProvider(create: (_) => CompanyAutomationProvider()),
        ChangeNotifierProvider(create: (_) => ActiveReportProvider()),
        ChangeNotifierProvider(create: (_) => AnalyticsProvider()),
      ],
      child: LensWholesaleApp(authProvider: authProvider),
    ),
  );
}

class LensWholesaleApp extends StatefulWidget {
  final AuthProvider authProvider;
  const LensWholesaleApp({super.key, required this.authProvider});

  @override
  State<LensWholesaleApp> createState() => _LensWholesaleAppState();
}

class _LensWholesaleAppState extends State<LensWholesaleApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = createAppRouter(widget.authProvider);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Lens Wholesale ERP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        // Match Tailwind's Inter font style globally
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      routerConfig: _router,
    );
  }
}
