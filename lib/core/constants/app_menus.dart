import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MenuItem {
  final String key;
  final String label;
  final IconData icon;
  final String? link;
  final List<MenuItem>? submenu;
  final bool isSuperAdminOnly;

  const MenuItem({
    required this.key,
    required this.label,
    required this.icon,
    this.link,
    this.submenu,
    this.isSuperAdminOnly = false,
  });
}

const List<MenuItem> appMenuItems = [
  MenuItem(
    key: "dashboard",
    label: "Dashboard",
    icon: LucideIcons.home,
    link: "/",
  ),
  MenuItem(
    key: "company",
    label: "Company",
    icon: LucideIcons.building2,
    submenu: [
      MenuItem(
        key: "modify-company",
        label: "Modify Company",
        icon: LucideIcons.settings,
        link: "/company/modifycompany",
      ),
      MenuItem(
        key: "close-company",
        label: "Close Company",
        icon: LucideIcons.archive,
        link: "/company/closecompany",
      ),
    ],
  ),
  MenuItem(
    key: "active",
    label: "Active",
    icon: LucideIcons.trendingUp,
    link: "/active",
  ),
  MenuItem(
    key: "masters",
    label: "Masters",
    icon: LucideIcons.settings,
    submenu: [
      MenuItem(
        key: "account-master",
        label: "Account Master",
        icon: LucideIcons.users,
        submenu: [
          MenuItem(
            key: "account-group-master",
            label: "Account Group Master",
            icon: LucideIcons.users,
            link: "/masters/accountmaster/accountgroupmaster",
          ),
          MenuItem(
            key: "account-master-sub",
            label: "Account Master",
            icon: LucideIcons.userCheck,
            link: "/masters/accountmaster/accountmaster",
          ),
          MenuItem(
            key: "transporter",
            label: "Transporter",
            icon: LucideIcons.users,
            link: "/masters/accountmaster/transporter",
          ),
        ],
      ),
      MenuItem(
        key: "inventory-master",
        label: "Inventory Master",
        icon: LucideIcons.package,
        submenu: [
          MenuItem(
            key: "inventory-creation",
            label: "Group, Item & Lens Creation",
            icon: LucideIcons.plusCircle,
            link: "/masters/inventorymaster",
          ),
          MenuItem(
            key: "lens-price",
            label: "Lens Price",
            icon: LucideIcons.dollarSign,
            link: "/masters/inventorymaster/lensprice",
          ),
          MenuItem(
            key: "product-price-account",
            label: "Product Price Account Category Wise",
            icon: LucideIcons.dollarSign,
            link: "/masters/inventorymaster/productpriceaccountcategorywise",
          ),
        ],
      ),
      MenuItem(
        key: "tax-category",
        label: "Tax Category",
        icon: LucideIcons.calculator,
        link: "/masters/billandothermaster/taxcategory",
      ),
    ],
  ),
  MenuItem(
    key: "add-voucher",
    label: "Add Voucher",
    icon: LucideIcons.fileText,
    link: "/transaction/payrecptumicntr/addvoucher",
  ),
  MenuItem(
    key: "lens-transaction",
    label: "Lens Transaction",
    icon: LucideIcons.eye,
    submenu: [
      MenuItem(
        key: "sale",
        label: "Sale",
        icon: LucideIcons.trendingUp,
        submenu: [
          MenuItem(
            key: "sale-invoice",
            label: "Sale Invoice",
            icon: LucideIcons.receipt,
            link: "/lenstransaction/sale/saleinvoice",
          ),
          MenuItem(
            key: "sale-order",
            label: "Sale Order",
            icon: LucideIcons.shoppingCart,
            link: "/lenstransaction/sale/saleorder",
          ),
          MenuItem(
            key: "sale-challan",
            label: "Sale Challan",
            icon: LucideIcons.fileText,
            link: "/lenstransaction/sale/salechallan",
          ),
        ],
      ),
      MenuItem(
        key: "sale-return",
        label: "Sale Return",
        icon: LucideIcons.refreshCw,
        link: "/lenstransaction/salereturn",
      ),
      MenuItem(
        key: "purchase",
        label: "Purchase",
        icon: LucideIcons.shoppingCart,
        submenu: [
          MenuItem(
            key: "purchase-invoice",
            label: "Purchase Invoice",
            icon: LucideIcons.receipt,
            link: "/lenstransaction/purchase/purchaseinvoice",
          ),
          MenuItem(
            key: "purchase-order",
            label: "Purchase Order",
            icon: LucideIcons.shoppingCart,
            link: "/lenstransaction/purchase/purchaseorder",
          ),
          MenuItem(
            key: "purchase-challan",
            label: "Purchase Challan",
            icon: LucideIcons.fileText,
            link: "/lenstransaction/purchase/purchasechallan",
          ),
        ],
      ),
      MenuItem(
        key: "lens-stock-report",
        label: "Lens Stock Report",
        icon: LucideIcons.barChart3,
        link: "/lenstransaction/lensstockreport",
      ),
      MenuItem(
        key: "damage-shrinkage",
        label: "Damage and Shrinkage",
        icon: LucideIcons.archive,
        link: "/lenstransaction/damageandshrinkage",
      ),
      MenuItem(
        key: "product-exchange",
        label: "Product Exchange",
        icon: LucideIcons.refreshCw,
        link: "/lenstransaction/productexchange",
      ),
    ],
  ),
  MenuItem(
    key: "reports",
    label: "Reports",
    icon: LucideIcons.fileBarChart,
    submenu: [
      MenuItem(
        key: "transaction-details",
        label: "Transaction Details",
        icon: LucideIcons.fileText,
        submenu: [
          MenuItem(
            key: "transaction-summary",
            label: "Transaction Summary",
            icon: LucideIcons.pieChart,
            link: "/reports/transactiondetails/transactionsummary",
          ),
          MenuItem(
            key: "transaction-detail",
            label: "Transaction Detail",
            icon: LucideIcons.fileText,
            link: "/reports/transactiondetails/transactiondetail",
          ),
          MenuItem(
            key: "sale-summary-formats",
            label: "Sale Summary Formats",
            icon: LucideIcons.fileBarChart,
            link: "/reports/transactiondetails/salesummaryformats",
          ),
        ],
      ),
      MenuItem(
        key: "books",
        label: "Books",
        icon: LucideIcons.fileText,
        submenu: [
          MenuItem(
            key: "day-book",
            label: "Day Book",
            icon: LucideIcons.fileText,
            link: "/reports/books/daybook",
          ),
          MenuItem(
            key: "profit-loss-item",
            label: "Profit and Loss (Item)",
            icon: LucideIcons.fileText,
            link: "/reports/financial/profitloss?index=1",
          ),
          MenuItem(
            key: "collection-report",
            label: "Collection Report",
            icon: LucideIcons.fileText,
            link: "/reports/books/collectionreport",
          ),
        ],
      ),
      MenuItem(
        key: "ledger",
        label: "Ledger",
        icon: LucideIcons.fileText,
        submenu: [
          MenuItem(
            key: "account-ledger",
            label: "Account Ledger",
            icon: LucideIcons.fileText,
            link: "/reports/ledger/accountledger",
          ),
          MenuItem(
            key: "account-ledger-details",
            label: "Account Ledger Details",
            icon: LucideIcons.fileText,
            link: "/reports/ledger/accountledgerdetails",
          ),
          MenuItem(
            key: "outstanding",
            label: "Outstanding",
            icon: LucideIcons.clock,
            link: "/reports/ledger/outstanding",
          ),
        ],
      ),
      MenuItem(
        key: "item-stock-reorder",
        label: "Item Stock Reorder",
        icon: LucideIcons.fileText,
        link: "/reports/stockandinventory/itemstockreorder",
      ),
      MenuItem(
        key: "gst-reports",
        label: "GST Reports",
        icon: LucideIcons.calculator,
        submenu: [
          MenuItem(
            key: "gst-summary",
            label: "GST Summary",
            icon: LucideIcons.pieChart,
            link: "/reports/gstreports/gstsummary",
          ),
          MenuItem(
            key: "gst-r1",
            label: "GST R1",
            icon: LucideIcons.fileText,
            link: "/reports/gstreports/gstr1",
          ),
          MenuItem(
            key: "gst-r2",
            label: "GST R2",
            icon: LucideIcons.fileText,
            link: "/reports/gstreports/gstr2",
          ),
          MenuItem(
            key: "gst-r38",
            label: "GST R38",
            icon: LucideIcons.fileText,
            link: "/reports/gstreports/gstr38",
          ),
          MenuItem(
            key: "gst-sundry-charge",
            label: "GST Sundry Charge",
            icon: LucideIcons.calculator,
            link: "/reports/gstreports/gstsundrycharge",
          ),
        ],
      ),
      MenuItem(
        key: "sale-item-group-wise",
        label: "Sale Item Group Wise Report",
        icon: LucideIcons.barChart3,
        link: "/reports/othersaleorderreports/saleitemgroupwisereport",
      ),
      MenuItem(
        key: "other-reports",
        label: "Other Reports",
        icon: LucideIcons.fileBarChart,
        submenu: [
          MenuItem(
            key: "booked-by-report",
            label: "Booked By Report",
            icon: LucideIcons.users,
            link: "/reports/otherreports/bookedbyreport",
          ),
          MenuItem(
            key: "customer-analysis",
            label: "Customer Analysis",
            icon: LucideIcons.users,
            link: "/reports/otherreports/customeranalysis",
          ),
          MenuItem(
            key: "deleted-data-report",
            label: "Deleted Data Report",
            icon: LucideIcons.archive,
            link: "/reports/otherreports/deleteddatareport",
          ),
          MenuItem(
            key: "user-activity-report",
            label: "Delivery Person Activity Report",
            icon: LucideIcons.clock,
            link: "/reports/otherreports/useractivityreport",
          ),
          MenuItem(
            key: "power-movement-report",
            label: "Power Movement Report",
            icon: LucideIcons.zap,
            link: "/reports/otherreports/powermovementreport",
          ),
          MenuItem(
            key: "sale-return-ratio-report",
            label: "Sale Return Ratio Report",
            icon: LucideIcons.trendingUp,
            link: "/reports/otherreports/salereturnratioreport",
          ),
          MenuItem(
            key: "sale-target-report",
            label: "Sale Target Report",
            icon: LucideIcons.target,
            link: "/reports/otherreports/saletargetreport",
          ),
          MenuItem(
            key: "collection-target-report",
            label: "Customer/Vendor Collection Report",
            icon: LucideIcons.wallet,
            link: "/reports/otherreports/collectiontargetreport",
          ),
          MenuItem(
            key: "cancelled-order-ratio-report",
            label: "Cancelled Order Ratio Report",
            icon: LucideIcons.activity,
            link: "/reports/otherreports/cancelledorderratioreport",
          ),
          MenuItem(
            key: "order-to-challan-time-report",
            label: "Order to Challan Time Report",
            icon: LucideIcons.clock,
            link: "/reports/otherreports/ordertochallantimereport",
          ),
          MenuItem(
            key: "sales-growth-comparison-report",
            label: "Sales Growth Comparison Report",
            icon: LucideIcons.trendingUp,
            link: "/reports/otherreports/salesgrowthcomparisonreport",
          ),
        ],
      ),
    ],
  ),

  MenuItem(
    key: "utilities",
    label: "Utilities",
    icon: LucideIcons.wrench,
    submenu: [
      MenuItem(
        key: "backup-restore",
        label: "BackUp And Restore",
        icon: LucideIcons.database,
        link: "/utilities/databasebackuprestore/backupandrestore",
      ),
      MenuItem(
        key: "bulk-update",
        label: "Product List for Update",
        icon: LucideIcons.layers,
        link: "/utilities/bulk-update",
      ),
      MenuItem(
        key: "offers",
        label: "Offers & Promotions",
        icon: LucideIcons.megaphone,
        link: "/utilities/offers",
      ),
      MenuItem(
        key: "shortcut-keys",
        label: "Shortcut Keys",
        icon: LucideIcons.keyboard,
        link: "/utilities/shortcutkeys",
      ),
    ],
  ),
  MenuItem(
    key: "super-admin",
    label: "Super Admin",
    icon: LucideIcons.shieldCheck,
    isSuperAdminOnly: true,
    submenu: [
      MenuItem(
        key: "sa-dashboard",
        label: "SA Dashboard",
        icon: LucideIcons.barChart3,
        link: "/super-admin/dashboard",
      ),
      MenuItem(
        key: "sa-companies",
        label: "Manage Companies",
        icon: LucideIcons.building2,
        link: "/super-admin/companies",
      ),
      MenuItem(
        key: "sa-users",
        label: "Global Users",
        icon: LucideIcons.users,
        link: "/super-admin/users",
      ),
      MenuItem(
        key: "sa-plans",
        label: "SaaS Plans",
        icon: LucideIcons.zap,
        link: "/super-admin/plans",
      ),
      MenuItem(
        key: "sa-settings",
        label: "System Settings",
        icon: LucideIcons.settings2,
        link: "/super-admin/settings",
      ),
      MenuItem(
        key: "sa-payment-history",
        label: "Payment History",
        icon: LucideIcons.creditCard,
        link: "/super-admin/payment-history",
      ),
    ],
  ),
];
