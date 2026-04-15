import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/auth/auth_provider.dart';
import '../../features/auth/presentation/pages/auth_page.dart';
import '../../features/layout/presentation/pages/app_layout.dart';
import '../../features/dashboard/presentation/pages/home_page.dart';
import '../../features/super_admin/presentation/pages/sa_dashboard_page.dart';
import '../../features/super_admin/presentation/pages/sa_companies_page.dart';
import '../../features/super_admin/presentation/pages/sa_users_page.dart';
import '../../features/super_admin/presentation/pages/sa_plans_page.dart';
import '../../features/super_admin/presentation/pages/sa_settings_page.dart';
import '../../features/super_admin/presentation/pages/sa_payment_history_page.dart';
import '../../features/masters/presentation/pages/account_group_list_page.dart';
import '../../features/masters/presentation/pages/account_list_page.dart';
import '../../features/masters/presentation/pages/add_account_page.dart';
import '../../features/masters/presentation/pages/tax_category_list_page.dart';
import '../../features/masters/presentation/pages/add_tax_category_page.dart';
import '../../features/masters/presentation/pages/add_item_group_page.dart';
import '../../features/masters/presentation/pages/add_item_page.dart';
import '../../features/masters/presentation/pages/add_lens_group_page.dart';
import '../../features/masters/presentation/pages/inventory_master_page.dart';
import '../../features/masters/presentation/pages/lens_price_screen.dart';
import '../../features/masters/presentation/pages/customer_specific_pricing_screen.dart';
import '../../features/sales/presentation/pages/lens_sale_order_page.dart';
import '../../features/sales/presentation/pages/add_lens_sale_order_page.dart';
import '../../features/sales/presentation/pages/add_lens_sale_challan_page.dart';
import '../../features/sales/presentation/pages/lens_sale_invoice_page.dart';
import '../../features/sales/presentation/pages/add_lens_sale_invoice_page.dart';
import '../../features/sales/presentation/pages/add_contact_lens_sale_order_page.dart';
import '../../features/sales/presentation/pages/add_rx_order_page.dart';
import '../../features/sales/presentation/pages/add_rx_sale_page.dart';
import '../../features/sales/presentation/pages/sale_return_list_page.dart';
import '../../features/sales/presentation/pages/add_sale_return_page.dart';
import '../../features/sales/presentation/pages/add_rx_sale_return_page.dart';
import '../../features/sales/presentation/pages/lens_sale_challan_list_page.dart';
import '../../features/sales/presentation/pages/rx_sale_list_page.dart';
import '../../features/purchases/presentation/pages/purchase_order_list_page.dart';
import '../../features/purchases/presentation/pages/add_purchase_order_page.dart';
import '../../features/purchases/presentation/pages/purchase_challan_list_page.dart';
import '../../features/purchases/presentation/pages/add_purchase_challan_page.dart';
import '../../features/purchases/presentation/pages/purchase_invoice_list_page.dart';
import '../../features/purchases/presentation/pages/add_purchase_invoice_page.dart';
import '../../features/purchases/data/models/purchase_model.dart';
import '../../features/reports/data/models/inventory_report_models.dart';
import '../../features/purchases/presentation/pages/rx_purchase_list_page.dart';
import '../../features/purchases/presentation/pages/add_rx_purchase_page.dart';
import '../../features/purchases/presentation/pages/add_rx_purchase_invoice_page.dart';
import '../../features/purchases/presentation/pages/add_rx_purchase_return_page.dart';
import '../../features/purchases/presentation/pages/contact_lens_purchase_list_page.dart';
import '../../features/purchases/presentation/pages/add_contact_lens_purchase_page.dart';
import '../../features/inventory/presentation/pages/lens_stock_report_page.dart';
import '../../features/inventory/presentation/pages/barcode_management_page.dart';
import '../../features/inventory/presentation/pages/lens_location_page.dart';
import '../../features/inventory/presentation/pages/add_damage_entry_page.dart';
import '../../features/inventory/presentation/pages/damage_and_shrinkage_page.dart';
import '../../features/inventory/presentation/pages/add_product_exchange_page.dart';
import '../../features/inventory/presentation/pages/product_exchange_list_page.dart';
import '../../features/vouchers/presentation/pages/voucher_list_page.dart';
import '../../features/vouchers/presentation/pages/add_voucher_page.dart';
import '../../features/reports/presentation/pages/outstanding_page.dart';
import '../../features/reports/presentation/pages/account_ledger_page.dart';
import '../../features/reports/presentation/pages/account_ledger_details_page.dart';
import '../../features/reports/presentation/pages/day_book_page.dart';
import '../../features/reports/presentation/pages/cash_bank_book_page.dart';
import '../../features/reports/presentation/pages/balance_sheet_page.dart';
import '../../features/reports/presentation/pages/profit_loss_page.dart';
import '../../features/reports/presentation/pages/collection_report_page.dart';
import '../../features/reports/presentation/pages/sale_target_report_page.dart';
import '../../features/reports/presentation/pages/order_to_challan_time_page.dart';
import '../../features/reports/presentation/pages/cancelled_order_ratio_page.dart';
import '../../features/reports/presentation/pages/lens_movement_report_page.dart';
import '../../features/reports/presentation/pages/power_movement_report_page.dart';
import '../../features/reports/presentation/pages/party_wise_item_report_page.dart';
import '../../features/reports/presentation/pages/stock_reorder_report_page.dart';
import '../../features/audits/presentation/pages/verify_lens_stock_page.dart';
import '../../features/audits/presentation/pages/verify_billing_page.dart';
import '../../features/audits/presentation/pages/verify_bank_statement_page.dart';
import '../../features/utilities/presentation/pages/backup_restore_page.dart';
import '../../features/utilities/presentation/pages/bulk_update_page.dart';
import '../../features/utilities/presentation/pages/offers_page.dart';
import '../../features/inventory/presentation/pages/barcode_management_page.dart';
import '../../features/utilities/presentation/pages/shortcut_settings_page.dart';
import '../../features/company/presentation/pages/modify_company_page.dart';
import '../../features/reports/presentation/pages/active_dashboard_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createAppRouter(AuthProvider authProvider) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/auth',
    refreshListenable: authProvider,
    redirect: (BuildContext context, GoRouterState state) {
      final isLoggedIn = authProvider.isAuthenticated;
      final isSuperAdmin = authProvider.user?['role'] == 'super_admin';
      final isOnAuthPage = state.matchedLocation == '/auth';

      // Not logged in → go to auth
      if (!isLoggedIn && !isOnAuthPage) return '/auth';

      // Logged in but on auth page → redirect to correct home
      if (isLoggedIn && isOnAuthPage) {
        return isSuperAdmin ? '/super-admin/dashboard' : '/';
      }

      // Super admin trying to access non-super-admin routes → redirect
      if (isLoggedIn && isSuperAdmin && !state.matchedLocation.startsWith('/super-admin')) {
        return '/super-admin/dashboard';
      }

      return null; // no redirect
    },
  routes: [
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthPage(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => AppLayout(child: child),
      routes: [
        // Main Dashboard
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/active',
          builder: (context, state) => const ActiveDashboardPage(),
        ),
        // Super Admin
        GoRoute(
          path: '/super-admin/dashboard',
          builder: (context, state) => const SADashboardPage(),
        ),
        GoRoute(
          path: '/super-admin/companies',
          builder: (context, state) => const SACompaniesPage(),
        ),
        GoRoute(
          path: '/super-admin/users',
          builder: (context, state) => const SAUsersPage(),
        ),
        GoRoute(
          path: '/super-admin/plans',
          builder: (context, state) => const SAPlansPage(),
        ),
        GoRoute(
          path: '/super-admin/settings',
          builder: (context, state) => const SASettingsPage(),
        ),
        GoRoute(
          path: '/super-admin/payment-history',
          builder: (context, state) => const SAPaymentHistoryPage(),
        ),
        // Company
        GoRoute(
          path: '/company/modifycompany',
          builder: (context, state) => const ModifyCompanyPage(),
        ),
        // Masters
        GoRoute(
          path: '/masters/accountmaster/accountgroupmaster',
          builder: (context, state) => const AccountGroupListPage(),
        ),
        GoRoute(
          path: '/masters/accountmaster/accountmaster',
          builder: (context, state) => const AccountListPage(),
        ),
        GoRoute(
          path: '/add/accountmaster',
          builder: (context, state) => const AddAccountPage(),
        ),
        GoRoute(
          path: '/masters/billandothermaster/taxcategory',
          builder: (context, state) => const TaxCategoryListPage(),
        ),
        GoRoute(
          path: '/masters/billandothermaster/addtaxcategory',
          builder: (context, state) => const AddTaxCategoryPage(),
        ),
        GoRoute(
          path: '/masters/inventorymaster',
          builder: (context, state) => const InventoryMasterPage(),
        ),
        GoRoute(
          path: '/masters/inventorymaster/itemgroupmaster',
          builder: (context, state) => const AddItemGroupPage(),
        ),
        GoRoute(
          path: '/masters/inventorymaster/itemmaster',
          builder: (context, state) => const AddItemPage(),
        ),
        GoRoute(
          path: '/masters/inventorymaster/lensgroupcreation',
          builder: (context, state) {
            final id = state.uri.queryParameters['id'];
            return AddLensGroupPage(id: id);
          },
        ),
        GoRoute(
          path: '/masters/inventorymaster/lensprice',
          builder: (context, state) => const LensPriceScreen(),
        ),
        GoRoute(
          path: '/masters/inventorymaster/productpriceaccountcategorywise',
          builder: (context, state) => const CustomerSpecificPricingScreen(),
        ),
        // Sales
        GoRoute(
          path: '/sales/lens-sale-order',
          builder: (context, state) => const LensSaleOrderPage(),
        ),
        GoRoute(
          path: '/sales/add-lens-sale-order',
          builder: (context, state) {
            final id = state.uri.queryParameters['id'];
            return AddLensSaleOrderPage(orderId: id);
          },
        ),
        GoRoute(
          path: '/sales/lens-sale-challan',
          builder: (context, state) => const LensSaleChallanListPage(),
        ),
        GoRoute(
          path: '/sales/add-lens-sale-challan',
          builder: (context, state) {
            final id = state.uri.queryParameters['id'];
            return AddLensSaleChallanPage(challanId: id);
          },
        ),
        GoRoute(
          path: '/sales/lens-sale-invoice',
          builder: (context, state) {
            final id = state.uri.queryParameters['id'];
            return AddLensSaleInvoicePage(invoiceId: id);
          },
        ),
        // React Alias for Sale Invoice
        GoRoute(
          path: '/lenstransaction/sale/saleinvoice',
          builder: (context, state) => const LensSaleInvoicePage(),
        ),
        GoRoute(
          path: '/lenstransaction/sale/saleorder',
          builder: (context, state) => const LensSaleOrderPage(),
        ),
        GoRoute(
          path: '/lenstransaction/sale/salechallan',
          builder: (context, state) => const LensSaleChallanListPage(),
        ),
        GoRoute(
          path: '/sales/add-lens-sale-invoice',
          builder: (context, state) {
            final id = state.uri.queryParameters['id'];
            return AddLensSaleInvoicePage(invoiceId: id);
          },
        ),
        GoRoute(
          path: '/sales/add-contact-lens-sale-order',
          builder: (context, state) {
            final id = state.uri.queryParameters['id'];
            return AddContactLensSaleOrderPage(orderId: id);
          },
        ),
        GoRoute(
          path: '/sales/add-rx-order',
          builder: (context, state) {
            final id = state.uri.queryParameters['id'];
            return AddRxOrderPage(orderId: id);
          },
        ),
        GoRoute(
          path: '/sales/add-rx-sale',
          builder: (context, state) {
            final id = state.uri.queryParameters['id'];
            return AddRxSalePage(saleId: id);
          },
        ),
        GoRoute(
          path: '/sales/rx-sale-list',
          builder: (context, state) => const RxSaleListPage(),
        ),
        GoRoute(
          path: '/sales/sale-returns',
          builder: (context, state) => const SaleReturnListPage(),
        ),
        // React Alias for Sale Return
        GoRoute(
          path: '/lenstransaction/salereturn',
          builder: (context, state) => const SaleReturnListPage(),
        ),
        GoRoute(
          path: '/sales/add-sale-return',
          builder: (context, state) {
            final id = state.uri.queryParameters['id'];
            return AddSaleReturnPage(returnId: id);
          },
        ),
        GoRoute(
          path: '/sales/add-rx-sale-return',
          builder: (context, state) {
            final id = state.uri.queryParameters['id'];
            return AddRxSaleReturnPage(returnId: id);
          },
        ),
        // Inventory & Barcodes
        GoRoute(
          path: '/lenstransaction/lensstockreport',
          builder: (context, state) => const LensStockReportPage(),
        ),
        GoRoute(
          path: '/inventory/barcode-management',
          builder: (context, state) => const BarcodeManagementPage(),
        ),
        GoRoute(
          path: '/inventory/lens-location',
          builder: (context, state) => const LensLocationPage(),
        ),
        GoRoute(
          path: '/lenstransaction/damageandshrinkage',
          builder: (context, state) => const DamageAndShrinkagePage(),
        ),
        GoRoute(
          path: '/lenstransaction/add-damage-entry',
          builder: (context, state) {
            final id = state.uri.queryParameters['id'];
            return AddDamageEntryPage(editId: id);
          },
        ),
        GoRoute(
          path: '/lenstransaction/add-product-exchange',
          builder: (context, state) {
            final id = state.uri.queryParameters['id'];
            return AddProductExchangePage(editId: id);
          },
        ),
        GoRoute(
          path: '/lenstransaction/productexchange',
          builder: (context, state) => const ProductExchangeListPage(),
        ),
        // Vouchers
        GoRoute(
          path: '/transaction/vouchers',
          builder: (context, state) => const VoucherListPage(),
        ),
        // React Aliases for Vouchers
        GoRoute(
          path: '/transaction/payrecptumicntr/addvoucher',
          builder: (context, state) => const VoucherListPage(),
        ),
        GoRoute(
          path: '/transaction/payrecptumicntr/voucherentry',
          builder: (context, state) {
             final id = state.uri.queryParameters['id'];
             return AddVoucherPage(editId: id);
          },
        ),
        GoRoute(
          path: '/transaction/add-voucher',
          builder: (context, state) {
            final id = state.uri.queryParameters['id'];
            return AddVoucherPage(editId: id);
          },
        ),
        // Purchases
        GoRoute(
          path: '/purchases/purchase-order',
          builder: (context, state) => const PurchaseOrderListPage(),
        ),
        GoRoute(
          path: '/purchases/add-purchase-order',
          builder: (context, state) {
            final id = state.uri.queryParameters['id'];
            return AddPurchaseOrderPage(orderId: id);
          },
        ),
        GoRoute(
          path: '/purchases/purchase-challan',
          builder: (context, state) => const PurchaseChallanListPage(),
        ),
        GoRoute(
          path: '/purchases/add-purchase-challan',
          builder: (context, state) {
            final id = state.uri.queryParameters['id'];
            return AddPurchaseChallanPage(challanId: id);
          },
        ),
        GoRoute(
          path: '/purchases/purchase-invoice',
          builder: (context, state) => const PurchaseInvoiceListPage(),
        ),
        // React Aliases for Purchases
        GoRoute(
          path: '/lenstransaction/purchase/purchaseinvoice',
          builder: (context, state) => const PurchaseInvoiceListPage(),
        ),
        GoRoute(
          path: '/lenstransaction/purchase/purchaseorder',
          builder: (context, state) => const PurchaseOrderListPage(),
        ),
        GoRoute(
          path: '/lenstransaction/purchase/purchasechallan',
          builder: (context, state) => const PurchaseChallanListPage(),
        ),
        // Add React-style aliases for adding/editing
        GoRoute(
          path: '/lenstransaction/purchase/AddLensPurchaseOrder/:id',
          builder: (context, state) => AddPurchaseOrderPage(orderId: state.pathParameters['id']),
        ),
        GoRoute(
          path: '/lenstransaction/purchase/AddLensPurchaseChallan/:id',
          builder: (context, state) => AddPurchaseChallanPage(challanId: state.pathParameters['id']),
        ),
        GoRoute(
          path: '/lenstransaction/purchase/AddLensPurchase/:id',
          builder: (context, state) => AddPurchaseInvoicePage(invoiceId: state.pathParameters['id']),
        ),
        GoRoute(
          path: '/lenstransaction/sale/AddLensSaleOrder/:id',
          builder: (context, state) => AddLensSaleOrderPage(orderId: state.pathParameters['id']),
        ),
        GoRoute(
          path: '/lenstransaction/sale/AddLensSaleChallan/:id',
          builder: (context, state) => AddLensSaleChallanPage(challanId: state.pathParameters['id']),
        ),
        GoRoute(
          path: '/lenstransaction/sale/AddLensSale/:id',
          builder: (context, state) => AddLensSaleInvoicePage(invoiceId: state.pathParameters['id']),
        ),
        GoRoute(
          path: '/purchases/add-purchase-invoice',
          builder: (context, state) {
            final id = state.uri.queryParameters['id'];
            final initialItem = state.extra as StockReorderItem?;
            return AddPurchaseInvoicePage(invoiceId: id, initialItem: initialItem);
          },
        ),
        // Rx Purchases
        GoRoute(
          path: '/purchases/rx/dashboard',
          builder: (context, state) => const RxPurchaseListPage(),
        ),
        GoRoute(
          path: '/purchases/rx/add-order',
          builder: (context, state) {
            final initial = state.extra as PurchaseModel?;
            return AddRxPurchasePage(initialData: initial);
          },
        ),
        GoRoute(
          path: '/purchases/rx/add-invoice',
          builder: (context, state) {
            final initial = state.extra as PurchaseModel?;
            return AddRxPurchaseInvoicePage(initialData: initial);
          },
        ),
        GoRoute(
          path: '/purchases/rx/add-return',
          builder: (context, state) {
            final initial = state.extra as PurchaseModel?;
            return AddRxPurchaseReturnPage(initialData: initial);
          },
        ),
        // Contact Lens Purchases
        GoRoute(
          path: '/purchases/cl/dashboard',
          builder: (context, state) => const ContactLensPurchaseListPage(),
        ),
        GoRoute(
          path: '/purchases/cl/add',
          builder: (context, state) {
            final initial = state.extra as PurchaseModel?;
            return AddContactLensPurchasePage(initialData: initial);
          },
        ),
        // Reports
        GoRoute(
          path: '/reports/financial/daybook',
          builder: (context, state) => const DayBookPage(),
        ),
        // React Alias for Day Book
        GoRoute(
          path: '/reports/books/daybook',
          builder: (context, state) => const DayBookPage(),
        ),
        GoRoute(
          path: '/reports/financial/cashbank',
          builder: (context, state) => const CashBankBookPage(),
        ),
        // React Alias for Cash Bank
        GoRoute(
          path: '/reports/books/cashbankbook',
          builder: (context, state) => const CashBankBookPage(),
        ),
        GoRoute(
          path: '/reports/outstanding',
          builder: (context, state) => const OutstandingPage(),
        ),
        // React Alias for Outstanding
        GoRoute(
          path: '/reports/ledger/outstanding',
          builder: (context, state) => const OutstandingPage(),
        ),
        GoRoute(
          path: '/reports/ledger/accountledger',
          builder: (context, state) {
            final account = state.uri.queryParameters['account'];
            final fromDate = state.uri.queryParameters['fromDate'];
            final toDate = state.uri.queryParameters['toDate'];
            return AccountLedgerPage(
              initialAccount: account,
              initialFromDate: fromDate,
              initialToDate: toDate,
            );
          },
        ),
        GoRoute(
          path: '/reports/ledger/accountledgerdetails',
          builder: (context, state) => const AccountLedgerDetailsPage(),
        ),
        GoRoute(
          path: '/reports/financial/balancesheet',
          builder: (context, state) => const BalanceSheetPage(),
        ),
        GoRoute(
          path: '/reports/financial/profitloss',
          builder: (context, state) {
            final index = int.tryParse(state.uri.queryParameters['index'] ?? '0') ?? 0;
            return ProfitLossPage(initialIndex: index);
          },
        ),
        GoRoute(
          path: '/reports/books/collectionreport',
          builder: (context, state) => const CollectionReportPage(),
        ),
        GoRoute(
          path: '/reports/targets/performance',
          builder: (context, state) => const SaleTargetReportPage(),
        ),
        GoRoute(
          path: '/reports/operational/order-to-challan',
          builder: (context, state) => const OrderToChallanTimePage(),
        ),
        GoRoute(
          path: '/reports/operational/cancelled-ratio',
          builder: (context, state) => const CancelledOrderRatioPage(),
        ),
        GoRoute(
          path: '/reports/movement/lens',
          builder: (context, state) => const LensMovementReportPage(),
        ),
        GoRoute(
          path: '/reports/movement/power',
          builder: (context, state) => const PowerMovementReportPage(),
        ),
        GoRoute(
          path: '/reports/inventory/party-wise-item',
          builder: (context, state) => const PartyWiseItemReportPage(),
        ),
        GoRoute(
          path: '/reports/inventory/stock-reorder',
          builder: (context, state) => const StockReorderReportPage(),
        ),
        // Audits
        GoRoute(
          path: '/audits/verify-lens-stock',
          builder: (context, state) => const VerifyLensStockPage(),
        ),
        GoRoute(
          path: '/audits/verify-billing',
          builder: (context, state) => const VerifyBillingPage(),
        ),
        GoRoute(
          path: '/audits/verify-bank-statement',
          builder: (context, state) => const VerifyBankStatementPage(),
        ),
        // Utilities & Polish (Step 37)
        GoRoute(
          path: '/utilities/databasebackuprestore/backupandrestore',
          builder: (context, state) => const BackupRestorePage(),
        ),
        GoRoute(
          path: '/utilities/bulk-update',
          builder: (context, state) => const ProductListForUpdatePage(),
        ),
        GoRoute(
          path: '/utilities/offers',
          builder: (context, state) => const OffersManagementPage(),
        ),
        GoRoute(
          path: '/inventory/barcode-management',
          builder: (context, state) => const BarcodeManagementPage(),
        ),
        GoRoute(
          path: '/utilities/shortcutkeys',
          builder: (context, state) => const ShortcutSettingsPage(),
        ),
      ],
    ),
  ],
  );
}
