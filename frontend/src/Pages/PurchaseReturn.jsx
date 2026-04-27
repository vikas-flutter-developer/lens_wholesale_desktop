import React, { useState, useMemo, useEffect } from "react";
import { printBarcodeStickers } from "../utils/BarcodeStickerHelper";
import { printAuthenticityCard } from "../utils/AuthenticityCardHelper";
import * as XLSX from "xlsx";
import {
  Plus,
  Printer,
  FileSpreadsheet,
  Pencil,
  Trash,
  Search,
  RotateCcw,
  Menu,
  Truck,
  File,
  Barcode,
  CreditCard,
  Info,
} from "lucide-react";
import {
  getAllLensPurchaseReturn,
  removeLensPurchaseReturn,
  updateReturnQuantities,
  updateReturnStatus as updateLensStatus,
} from '../controllers/PurchaseReturn.controller'
import {
  getAllRxPurchaseReturn,
  removeRxPurchaseReturn,
  updateRxPurchaseReturnFields,
  updateReturnStatus as updateRxStatus,
} from "../controllers/RxPurchaseReturn.controller"
import { useNavigate } from "react-router-dom";
import { toast, Toaster } from 'react-hot-toast'
import { roundAmount } from "../utils/amountUtils";
import { numberToWords } from "../utils/numberToWords";
import { generateBulkPrint, handleExportToExcel } from "../utils/PrintUtils";
import { getAllLensPower } from "../controllers/LensGroupCreationController";
import { getAllItems } from "../controllers/itemcontroller";

function PurchaseReturnVoucher() {
  const [purchaseReturns, setPurchaseReturns] = useState([])
  const [allLenses, setAllLenses] = useState([]);
  const [allItems, setAllItems] = useState([]);
  const [expandedRow, setExpandedRow] = useState(null);
  const [quantitiesValues, setQuantitiesValues] = useState({});
  const [filters, setFilters] = useState({
    billSeries: "",
    dateFrom: "",
    dateTo: "",
    searchText: "",
  });
  const [dcIds, setDcIds] = useState({});
  const ALL_COLUMNS_RETURN = [
    { id: "srNo", label: "Sr" },
    { id: "billDate", label: "Bill Date" },
    { id: "time", label: "Time" },
    { id: "billSeries", label: "Bill Series" },
    { id: "billNo", label: "Bill No." },
    { id: "partyName", label: "Party Name" },
    { id: "dcId", label: "DC ID" },
    { id: "netAmt", label: "Net Amt" },
    { id: "ordQty", label: "Ord Q" },
  ];

  const [selectedReturns, setSelectedReturns] = useState([]);

  const handleSelectReturn = (id) => {
    const idStr = String(id);
    setSelectedReturns(prev =>
      prev.includes(idStr) ? prev.filter(i => i !== idStr) : [...prev, idStr]
    );
  };

  const handleSelectAll = (e) => {
    if (e.target.checked) {
      setSelectedReturns(filteredVouchers.map(v => String(v._id)));
    } else {
      setSelectedReturns([]);
    }
  };

  const navigate = useNavigate();

  const fetchdata = async () => {
    try {
      const [lensRes, rxRes] = await Promise.all([
        getAllLensPurchaseReturn(),
        getAllRxPurchaseReturn(),
      ]);

      let combinedData = [];
      if (lensRes?.data) combinedData = [...combinedData, ...lensRes.data.map(item => ({ ...item, returnType: "lens" }))];
      if (rxRes?.data) combinedData = [...combinedData, ...rxRes.data.map(item => ({ ...item, returnType: "rx" }))];

      // Sort by date descending
      combinedData.sort((a, b) => new Date(b.billData?.date) - new Date(a.billData?.date));

      setPurchaseReturns(combinedData);
      
      const [lenses, items] = await Promise.all([
        getAllLensPower(),
        getAllItems()
      ]);
      setAllLenses(lenses?.data || []);
      setAllItems(items?.items || items?.data || []);
    } catch (err) {
      console.error("Error fetching purchase return data:", err);
      toast.error("Failed to load data");
    }
  };

  useEffect(() => {
    fetchdata();
  }, []);

  const handleQuantityChange = (id, field, value) => {
    if (value === "") {
      setQuantitiesValues(prev => ({ ...prev, [id]: { ...prev[id], [field]: "" } }));
      return;
    }
    const numVal = Number(value);
    if (isNaN(numVal) || numVal < 0) return;

    setQuantitiesValues((prev) => {
      const current = prev[id] || {};
      const newVals = { ...current, [field]: numVal };
      const o = field === "ordQty" ? numVal : Number(current.ordQty || 0);
      const u = field === "usedQty" ? numVal : Number(current.usedQty || 0);
      newVals.balQty = Math.max(0, o - u);
      return { ...prev, [id]: newVals };
    });
  };

  const handleDcIdChange = (id, value) => {
    setDcIds(prev => ({ ...prev, [id]: value }));
  };

  const handleDcIdBlur = async (id, returnType) => {
    const dcId = dcIds[id];
    let res;
    if (returnType === "lens") {
      res = await updateReturnQuantities(id, { dcId });
    } else {
      res = await updateRxPurchaseReturnFields(id, { dcId });
    }
  };

  const handleStatusChange = async (id, returnType, status) => {
    try {
      let res;
      if (returnType === "lens") {
        res = await updateLensStatus(id, status);
      } else {
        res = await updateRxStatus(id, status);
      }

      if (res.success) {
        toast.success("Status updated");
        setPurchaseReturns(prev => prev.map(v => v._id === id ? { ...v, status } : v));
      } else {
        toast.error(res.error || "Failed to update status");
      }
    } catch (err) {
      toast.error("Error updating status");
    }
  };

  const saveQuantities = async (id, returnType) => {
    const vals = quantitiesValues[id];
    if (!vals) return;
    const o = Number(vals.ordQty || 0);
    const u = Number(vals.usedQty || 0);
    if (u > o) {
      toast.error("Used Qty cannot exceed Order Qty");
      return;
    }

    let res;
    if (returnType === "lens") {
      res = await updateReturnQuantities(id, { orderQty: o, usedQty: u });
    } else {
      res = await updateRxPurchaseReturnFields(id, { orderQty: o, usedQty: u });
    }

    if (res.success) {
      toast.success("Quantities updated");
      setPurchaseReturns(prev => prev.map(v => v._id === id ? { ...v, orderQty: o, usedQty: u, balQty: Math.max(0, o - u) } : v));
    } else {
      toast.error("Failed to update");
    }
  };

  useEffect(() => {
    const vals = {};
    const dcs = {};
    if (purchaseReturns) {
      purchaseReturns.forEach(v => {
        vals[v._id] = {
          ordQty: v.orderQty !== undefined ? v.orderQty : (v.items?.reduce((s, i) => s + (Number(i.qty) || 0), 0) || 0),
          usedQty: v.usedQty || 0,
          balQty: v.balQty || 0
        };
        dcs[v._id] = v.dcId || "";
      });
      setQuantitiesValues(vals);
      setDcIds(dcs);
    }
  }, [purchaseReturns]);

  const handleFilterChange = (field, value) => {
    setFilters((p) => ({ ...p, [field]: value }));
  };

  const handleAddPurchaseReturn = () => {
    navigate("/lenstransaction/addpurchasereturn");
  };

  const handleReset = () =>
    setFilters({
      billSeries: "",
      dateFrom: "",
      dateTo: "",
      searchText: "",
    });

  const formatTime = (v) => {
    try {
      if (v.time) return v.time;
      const d = v.createdAt || v.billData?.date;
      if (!d) return "-";
      const dt = new Date(d);
      if (isNaN(dt.getTime())) return "-";
      return dt.toLocaleTimeString("en-IN", {
        hour: "2-digit",
        minute: "2-digit",
        hour12: true,
      });
    } catch {
      return "-";
    }
  };

  const safeDate = (d) => {
    try {
      if (!d) return new Date().toISOString().split("T")[0];
      const dt = new Date(d);
      if (isNaN(dt.getTime())) return new Date().toISOString().split("T")[0];
      return dt.toISOString().split("T")[0];
    } catch {
      return new Date().toISOString().split("T")[0];
    }
  };

  // ── Excel Export ──────────────────────────────────────────────
  const handleExcelExport = () => {
    const itemsToExport = selectedReturns.length > 0
      ? filteredVouchers.filter(v => selectedReturns.includes(String(v._id)))
      : filteredVouchers;

    const data = itemsToExport.map(v => ({
      ...v,
      billDate: v.billData?.date,
      time: formatTime(v),
      billSeries: v.billData?.billSeries,
      billNo: v.billData?.billNo,
      partyName: v.partyData?.partyAccount,
      netAmt: v.netAmount,
      ordQty: quantitiesValues[v._id]?.ordQty ?? (v.items?.reduce((s, i) => s + (Number(i.qty) || 0), 0) || 0)
    }));

    handleExportToExcel(XLSX, "PurchaseReturns", data, { srNo: true, billDate: true, time: true, billSeries: true, billNo: true, partyName: true, dcId: true, netAmt: true, ordQty: true }, ALL_COLUMNS_RETURN);
  };

  // ── Table Print (header Printer button) ─────────────────────
  const handleTablePrint = () => {
    const itemsToPrint = selectedReturns.length > 0
      ? filteredVouchers.filter(v => selectedReturns.includes(String(v._id)))
      : filteredVouchers;

    const data = itemsToPrint.map(v => ({
      ...v,
      billDate: v.billData?.date,
      time: formatTime(v),
      billSeries: v.billData?.billSeries,
      billNo: v.billData?.billNo,
      partyName: v.partyData?.partyAccount,
      netAmt: v.netAmount,
      ordQty: quantitiesValues[v._id]?.ordQty ?? (v.items?.reduce((s, i) => s + (Number(i.qty) || 0), 0) || 0)
    }));

    generateBulkPrint("Purchase Return Voucher List", data, { srNo: true, billDate: true, time: true, billSeries: true, billNo: true, partyName: true, dcId: true, netAmt: true, ordQty: true }, ALL_COLUMNS_RETURN);
  };

  const filteredVouchers = useMemo(() => {
    const q = filters.searchText?.toLowerCase().trim();

    return purchaseReturns.filter((v) => {
      const billDate = new Date(v.billData?.date);

      // ⭐ Combined search string
      const combined = `${v.billData?.billSeries || ""} ${v.billData?.billNo || ""} ${v.partyData?.partyAccount || ""}`.toLowerCase();

      // ⭐ Single search filter
      if (q && !combined.includes(q)) return false;

      // ⭐ Date From Filter
      if (filters.dateFrom && billDate < new Date(filters.dateFrom)) return false;

      // ⭐ Date To Filter
      if (filters.dateTo && billDate > new Date(filters.dateTo)) return false;

      return true;
    });
  }, [filters, purchaseReturns]);



  // helper: parse numeric string (handles commas) to number
  const parseNumber = (val) => {
    if (val === null || val === undefined) return 0;
    const n = Number(String(val).replace(/,/g, "").replace(/[^0-9.-]/g, ""));
    return Number.isFinite(n) ? n : 0;
  };

  // totals for the currently filtered vouchers
  const totals = useMemo(() => {
    let net = 0;
    let ordQty = 0;
    let usedQty = 0;
    let balQty = 0;
    filteredVouchers.forEach((v) => {
      net += parseNumber(v.netAmount);
      const q = Number(quantitiesValues[v._id]?.ordQty ?? 0) || (v.orderQty !== undefined ? v.orderQty : (v.items?.reduce((s, i) => s + (Number(i.qty) || 0), 0) || 0));
      const u = Number(quantitiesValues[v._id]?.usedQty ?? 0) || (v.usedQty || 0);
      const b = Math.max(0, q - u);
      ordQty += q;
      usedQty += u;
      balQty += b;
    });
    return { net, ordQty, usedQty, balQty };
  }, [filteredVouchers, quantitiesValues]);

  const formatINR = (num) =>
    num.toLocaleString("en-IN", { minimumFractionDigits: 2, maximumFractionDigits: 2 });

  const handleEdit = (id, type) => {
    if (type === "lens") {
      navigate(`/lenstransaction/addpurchasereturn/${id}`);
    } else {
      navigate(`/rxtransaction/addrxpurchasereturn/${id}`);
    }
  };

  const handleDelete = async (id, type) => {
    if (!window.confirm("Are you sure you want to delete this?")) return;

    const res =
      type === "lens"
        ? await removeLensPurchaseReturn(id)
        : await removeRxPurchaseReturn(id);

    if (res.success) {
      toast.success("Purchase Return deleted successfully!");
      setPurchaseReturns((prev) => prev.filter((o) => o._id !== id));
    } else {
      toast.error(res.error || "Failed to delete");
    }
  };

  const handleInfo = (id) => {
    setExpandedRow(expandedRow === id ? null : id);
  };

  const getPrintItemName = (item) => {
    if (item.billItemName && item.billItemName.trim() !== "") return item.billItemName;
    const target = (item.itemName || "").trim().toLowerCase();
    if (!target) return item.itemName || "-";

    const foundLens = (allLenses || []).find(l => 
      (l.productName || "").trim().toLowerCase() === target
    );
    if (foundLens?.billItemName) return foundLens.billItemName;

    const foundItem = (allItems || []).find(i => 
      (i.itemName || "").trim().toLowerCase() === target
    );
    if (foundItem?.billItemName) return foundItem.billItemName;

    return item.itemName || "-";
  };

  const handleNormalPrint = (order) => {
    const formatDate = (dateStr) => {
      if (!dateStr) return "-";
      const date = new Date(dateStr);
      return date.toLocaleDateString("en-IN", {
        day: "2-digit",
        month: "2-digit",
        year: "numeric"
      });
    };

    const items = order?.items || [];
    const itemRows = items
      .map(
        (it, idx) => `<tr>
          <td style="border:1px solid #94a3b8;padding:4px;text-align:center">${idx + 1}</td>
          <td style="border: 1px solid #ddd; padding: 8px;">${getPrintItemName(it)}</td>
          <td style="border:1px solid #94a3b8;padding:4px;text-align:center">${it.orderNo || it.refId || "-"}</td>
          <td style="border:1px solid #94a3b8;padding:4px;text-align:center">${it.eye || "-"}</td>
          <td style="border:1px solid #94a3b8;padding:4px;text-align:center">${it.sph || "-"}</td>
          <td style="border:1px solid #94a3b8;padding:4px;text-align:center">${it.cyl || "-"}</td>
          <td style="border:1px solid #94a3b8;padding:4px;text-align:center">${it.axis || "-"}</td>
          <td style="border:1px solid #94a3b8;padding:4px;text-align:center">${it.add || "-"}</td>
          <td style="border:1px solid #94a3b8;padding:4px;text-align:center;font-weight:bold">${it.qty || 0}</td>
          <td style="border:1px solid #94a3b8;padding:4px;text-align:right">&#8377;${roundAmount(it.purchasePrice || 0)}</td>
          <td style="border:1px solid #94a3b8;padding:4px;text-align:right">${it.discount || 0}%</td>
          <td style="border:1px solid #94a3b8;padding:4px;text-align:right;font-weight:bold">&#8377;${roundAmount(it.totalAmount || 0)}</td>
        </tr>`
      )
      .join("");

    const emptyRows = Array.from({ length: Math.max(0, 5 - items.length) })
      .map(() => `<tr>
          ${Array(12).fill('<td style="border:1px solid #94a3b8;padding:4px;height:24px"></td>').join('')}
        </tr>`)
      .join("");

    const totalQty = items.reduce((sum, it) => sum + (Number(it.qty) || 0), 0);
    const prevBal = order?.partyData?.prevBalance || order?.partyData?.CurrentBalance?.amount || 0;
    const netPayable = (order?.dueAmount || 0) + prevBal;

    const html = `<!DOCTYPE html>
      <html>
      <head>
        <title>Purchase Return - Normal Print</title>
        <style>
          @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;900&display=swap');
          body { font-family: 'Inter', sans-serif; margin: 0; padding: 20px; color: #1e293b; background: white; }
          .header { display: flex; align-items: center; border-bottom: 1px solid #cbd5e1; padding-bottom: 10px; margin-bottom: 20px; }
          .logo { width: 120px; }
          .title { flex: 1; text-align: center; font-size: 28px; font-weight: 900; letter-spacing: -0.025em; margin: 0; }
          .info-grid { display: grid; grid-template-columns: 1.2fr 1fr; gap: 40px; margin-bottom: 20px; font-size: 12px; }
          .party-details div, .bill-info div { display: flex; margin-bottom: 4px; }
          .label { font-weight: 700; width: 100px; }
          table { width: 100%; border-collapse: collapse; margin-bottom: 20px; font-size: 11px; }
          th { background: #f1f5f9; border: 1px solid #94a3b8; padding: 6px; text-transform: uppercase; }
          .summary-section { display: grid; grid-template-columns: 1.2fr 1fr; gap: 40px; margin-top: 10px; }
          .summary-table { width: 100%; border-left: 1px solid #e2e8f0; padding-left: 20px; font-size: 13px; }
          .summary-row { display: flex; justify-content: space-between; margin-bottom: 4px; }
          .net-pay { font-size: 18px; font-weight: 900; border-top: 2px solid #475569; padding-top: 8px; margin-top: 12px; }
          .signatures { display: flex; justify-content: space-between; margin-top: 60px; padding: 0 40px; }
          .sig-box { text-align: center; }
          .sig-line { width: 150px; border-top: 1px solid #475569; margin-bottom: 4px; }
          .sig-label { font-size: 10px; font-weight: 700; color: #94a3b8; text-transform: uppercase; }
          @media print { margin: 0; }
        </style>
      </head>
      <body>
        <div class="header">
          <img src="/sadguru_logo.svg" class="logo" />
          <h1 class="title">PURCHASE RETURN</h1>
          <div style="width:120px"></div>
        </div>

        <div class="info-grid">
          <div class="party-details">
            <div><span class="label">Party Name</span><span>: ${order?.partyData?.partyAccount || "-"}</span></div>
            <div><span class="label">Address</span><span>: ${order?.partyData?.address || "-"}</span></div>
            <div><span class="label">State</span><span>: ${order?.partyData?.stateCode || "-"}</span></div>
            <div><span class="label">Phone</span><span>: ${order?.partyData?.contactNumber || "-"}</span></div>
          </div>
          <div class="bill-info" style="margin-left: auto">
            <div style="justify-content: flex-end"><span class="label">Bill Series</span><span style="width:120px">: ${order?.billData?.billSeries || "-"}</span></div>
            <div style="justify-content: flex-end"><span class="label">Bill No</span><span style="width:120px">: ${order?.billData?.billNo || "-"}</span></div>
            <div style="justify-content: flex-end"><span class="label">Date</span><span style="width:120px">: ${formatDate(order?.billData?.date)}</span></div>
          </div>
        </div>

        <table>
          <thead>
            <tr>
              <th>SR</th><th>Item Name</th><th>Order No</th><th>Eye</th><th>Sph</th><th>Cyl</th><th>Axis</th><th>Add</th><th>Qty</th><th>Price</th><th>Disc</th><th>Total</th>
            </tr>
          </thead>
          <tbody>
            ${itemRows}
            ${emptyRows}
            <tr style="background:#f8fafc;font-weight:700">
              <td colspan="2" style="border:1px solid #94a3b8;padding:6px;text-align:center;text-transform:uppercase;letter-spacing:2px">Total</td>
              <td colspan="6" style="border:1px solid #94a3b8;padding:6px"></td>
              <td style="border:1px solid #94a3b8;padding:6px;text-align:center">${totalQty}</td>
              <td colspan="2" style="border:1px solid #94a3b8;padding:6px"></td>
              <td style="border:1px solid #94a3b8;padding:6px;text-align:right">&#8377;${roundAmount(order?.subtotal || 0)}</td>
            </tr>
          </tbody>
        </table>

        <div class="summary-section">
          <div style="display:flex;flex-direction:column;justify-content:space-between">
            <div>
              <p style="font-size:10px;font-weight:700;color:#64748b;text-transform:uppercase;margin:0">Total Invoice value ( In Words ) :</p>
              <p style="font-size:14px;font-weight:900;font-style:italic;margin:4px 0">${numberToWords(order?.netAmount || 0)}</p>
            </div>
            <div style="border-top:1px solid #e2e8f0;padding-top:10px">
              <p style="font-size:10px;font-weight:700;margin:0">Terms & Condition</p>
              <p style="font-size:10px;color:#64748b;font-style:italic;margin:4px 0;line-height:1.2">
                We declare that this invoice shows the actual price of the goods described<br/>
                and that all particulars are true and correct.
              </p>
            </div>
          </div>
          <div class="summary-table">
            <div class="summary-row"><span style="font-weight:700">Total Amount</span><span>&#8377;${roundAmount(order?.netAmount || 0)}</span></div>
            <div class="summary-row"><span style="font-weight:700">Paid Amt</span><span>&#8377;${roundAmount(order?.paidAmount || 0)}</span></div>
            <div class="summary-row" style="color:#dc2626;font-weight:900;border-bottom:1px solid #e2e8f0;padding-bottom:4px">
              <span style="font-weight:700">Due Amt</span><span>&#8377;${roundAmount(order?.dueAmount || 0)}</span>
            </div>
            <div class="summary-row" style="padding-top:4px"><span style="font-weight:700">Prev.Bal</span><span>&#8377;${roundAmount(prevBal)}</span></div>
            <div class="summary-row net-pay"><span>Net Payable</span><span>&#8377;${roundAmount(netPayable)}</span></div>
          </div>
        </div>

        <div class="signatures">
          <div class="sig-box">
            <div class="sig-line"></div>
            <span class="sig-label">Customer Sign</span>
          </div>
          <div class="sig-box">
             <p style="font-size:11px;font-weight:900;margin-bottom:40px">For, Sadguru Opticals</p>
            <div class="sig-line" style="width:180px"></div>
            <span class="sig-label">Authorized Signatory</span>
          </div>
        </div>
      </body>
      </html>`;
    const pw = window.open("", "_blank");
    pw.document.write(html);
    pw.document.close();
    pw.focus();
    pw.print();
  };

  const generateBarcodePrint = (v) => {
    printBarcodeStickers(v, allLenses, allItems, true);
  };

  const generateCardPrint = (v) => {
    printAuthenticityCard(v, allLenses, allItems);
  };

  return (
    <div className="p-4 bg-slate-100 min-h-screen font-sans">

      <div className="max-w-[98vw] mx-auto">
        {/* Header */}
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-slate-800 mb-2">
            Purchase Return Voucher List
          </h1>
          <p className="text-slate-600">
            Manage Purchases return vouchers and refunds
          </p>
        </div>



        {/* Filters */}
        <div className="bg-white rounded-xl shadow-md border border-slate-200 p-4 mb-4">
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-3 mb-4">
            <div className="relative">
              <input
                type="text"
                value={filters.searchText}
                onChange={(e) =>
                  handleFilterChange("searchText", e.target.value)
                }
                placeholder="Search..."
                className="peer w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-0 focus:border-blue-500 transition-all duration-200 outline-none text-sm"
              />
              <label className="absolute left-2 -top-2 text-xs font-medium bg-white px-1 text-gray-500">
                Search
              </label>
            </div>

            <div className="relative">
              <input
                type="date"
                value={filters.dateFrom}
                onChange={(e) => handleFilterChange("dateFrom", e.target.value)}
                className="peer w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-0 focus:border-blue-500 transition-all duration-200 outline-none text-sm"
              />
              <label className="absolute left-2 -top-2 text-xs font-medium bg-white px-1 text-gray-500">
                From Date
              </label>
            </div>

            <div className="relative">
              <input
                type="date"
                value={filters.dateTo}
                onChange={(e) => handleFilterChange("dateTo", e.target.value)}
                className="peer w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-0 focus:border-blue-500 transition-all duration-200 outline-none text-sm"
              />
              <label className="absolute left-2 -top-2 text-xs font-medium bg-white px-1 text-gray-500">
                To Date
              </label>
            </div>


          </div>

          <div className="flex flex-wrap justify-between gap-2">
            <div className="flex flex-wrap justify-start gap-2">
            </div>
            <div className="flex flex-wrap justify-start gap-2 ">
              <button
                onClick={handleReset}
                className="inline-flex items-center gap-1.5 px-4 py-2 bg-gray-100 text-gray-700 text-sm font-medium rounded-lg hover:bg-gray-200 transition-colors duration-200"
              >
                <RotateCcw className="w-3.5 h-3.5" />
                Reset
              </button>
              <button onClick={handleAddPurchaseReturn} className="inline-flex items-center gap-1.5 px-4 py-2 bg-green-600 text-white text-sm font-medium rounded-lg hover:bg-green-700 transition-colors duration-200">
                <Plus className="w-3.5 h-3.5" />
                Add Purchase Return
              </button>
              <button
                onClick={handleExcelExport}
                className="p-2 bg-emerald-100 text-emerald-700 rounded-lg hover:bg-emerald-200 transition-colors duration-200 hover:shadow-sm"
                title="Download Excel (.xlsx)"
              >
                <FileSpreadsheet className="w-4 h-4" />
              </button>
              <button
                onClick={handleTablePrint}
                className="p-2 bg-blue-100 text-blue-700 rounded-lg hover:bg-blue-200 transition-colors duration-200 hover:shadow-sm"
                title="Print Voucher List"
              >
                <Printer className="w-4 h-4" />
              </button>

            </div>
          </div>
        </div>

        {/* Table */}
        <div className="bg-white rounded-2xl shadow-lg border border-slate-200 overflow-hidden">
          <div className="overflow-x-auto">
            <table className="min-w-full table-fixed divide-y divide-slate-200">
              <thead className="bg-gradient-to-r from-blue-50 to-slate-50 border-b border-slate-200">
                <tr>
                  <th className="w-20 text-center py-4 px-3 text-slate-700 font-bold text-sm">
                    <div className="flex items-center justify-center gap-2">
                       <input 
                        type="checkbox" 
                        className="w-4 h-4 rounded border-slate-300 text-blue-600 focus:ring-blue-500 cursor-pointer"
                        checked={selectedReturns.length === filteredVouchers.length && filteredVouchers.length > 0}
                        onChange={handleSelectAll}
                      />
                      <span>Sr</span>
                    </div>
                  </th>
                  <th className="min-w-[120px] text-center py-4 px-3 text-slate-700 font-bold text-sm">
                    Bill Date
                  </th>
                  <th className="min-w-[120px] text-center py-4 px-3 text-slate-700 font-bold text-sm">
                    Time
                  </th>
                  <th className="min-w-[180px] text-center py-4 px-3 text-slate-700 font-bold text-sm">
                    Bill Series
                  </th>
                  <th className="min-w-[100px] text-center py-4 px-3 text-slate-700 font-bold text-sm">
                    Bill No.
                  </th>
                  <th className="min-w-[280px] text-center py-4 px-3 text-slate-700 font-bold text-sm">
                    Party Name
                  </th>
                  <th className="min-w-[150px] text-center py-4 px-3 text-slate-700 font-bold text-sm">
                    DC ID
                  </th>
                   <th className="min-w-[130px] text-center py-4 px-3 text-slate-700 font-bold text-sm">Net Amt</th>
                   <th className="min-w-[120px] text-center py-4 px-3 text-slate-700 font-bold text-sm">Status</th>
                   <th className="w-[100px] text-center py-4 px-3 text-slate-700 font-bold text-sm">Ord Q</th>
                   <th className="w-[100px] text-center py-4 px-3 text-slate-700 font-bold text-sm">Used Q</th>
                   <th className="w-[100px] text-center py-4 px-3 text-slate-700 font-bold text-sm">Bal Q</th>
                   <th className="w-[200px] text-center py-4 px-3 text-slate-700 font-bold text-sm">Action</th>
                </tr>
              </thead>

              <tbody className="divide-y divide-slate-200">
                {filteredVouchers.length === 0 ? (
                  <tr>
                    <td colSpan="13" className="p-10 text-center text-slate-500">
                      <p className="text-xl">No return vouchers found</p>
                      <p className="text-md">
                        Try adjusting your search criteria
                      </p>
                    </td>
                  </tr>
                ) : (
                  filteredVouchers.map((v, i) => {
                    const idStr = String(v._id);
                    return (
                      <React.Fragment key={idStr}>
                       <tr
                          key={v.id}
                          className={`hover:bg-slate-50 transition-colors duration-150 group text-sm ${selectedReturns.includes(idStr) ? "bg-blue-50" : ""}`}
                        >
                      <td className="w-20 text-center text-slate-600 font-medium py-5 px-2 align-top whitespace-nowrap">
                        <div className="flex items-center justify-center gap-2">
                          <input
                            type="checkbox"
                            className="w-4 h-4 rounded border-slate-300 text-blue-600 focus:ring-blue-500 cursor-pointer"
                            checked={selectedReturns.includes(idStr)}
                            onChange={() => handleSelectReturn(v._id)}
                          />
                          {i + 1}
                        </div>
                      </td>
                      <td className="py-5 px-3 text-slate-800 align-top text-center">
                        {safeDate(v.billData.date)}
                      </td>
                      <td className="py-5 px-3 text-slate-800 align-top text-center">
                        {formatTime(v)}
                      </td>
                      <td className="py-5 px-3 text-slate-800 align-top text-center">
                        {v.billData.billSeries}
                      </td>
                      <td className="py-5 px-3 text-slate-800 align-top text-center">
                        {v.billData.billNo}
                      </td>
                      <td className="py-5 px-3 text-slate-700 align-top">
                        <div className="whitespace-normal text-center break-words">
                          {v.partyData.partyAccount}
                        </div>
                      </td>
                      <td className="py-2 px-2 align-top text-center border-r border-gray-100">
                        <textarea
                          className="w-full min-h-[38px] border border-slate-200 rounded p-2 text-sm resize-y focus:outline-none focus:ring-1 focus:ring-blue-500 overflow-hidden break-words text-center"
                          value={dcIds[v._id] || ""}
                          onChange={(e) => {
                            handleDcIdChange(v._id, e.target.value);
                            e.target.style.height = 'auto';
                            e.target.style.height = e.target.scrollHeight + 'px';
                          }}
                          onBlur={() => handleDcIdBlur(v._id, v.returnType)}
                          placeholder="DC ID"
                          rows={1}
                        />
                      </td>
                      <td className="text-center text-slate-900 font-medium py-5 px-3 align-top">
                        {v.netAmount !== "0.00" ? `₹${roundAmount(v.netAmount)}` : "-"}
                      </td>
                      <td className="py-5 px-3 align-top text-center">
                        <select
                          value={v.status || "Pending"}
                          onChange={(e) => handleStatusChange(v._id, v.returnType, e.target.value)}
                          className={`px-2 py-1 text-xs font-bold rounded border ${
                            v.status === "Done" 
                              ? "bg-green-100 text-green-700 border-green-200" 
                              : "bg-yellow-100 text-yellow-700 border-yellow-200"
                          } outline-none focus:ring-1 focus:ring-blue-500`}
                        >
                          <option value="Pending">Pending</option>
                          <option value="Done">Done</option>
                        </select>
                      </td>
                      <td className="py-5 px-3 align-top text-center">
                        <input
                          type="number"
                          value={quantitiesValues[v._id]?.ordQty ?? v.orderQty ?? ""}
                          onChange={(e) => handleQuantityChange(v._id, "ordQty", e.target.value)}
                          onBlur={() => saveQuantities(v._id, v.returnType)}
                          style={{ width: `${Math.max(4, String(quantitiesValues[v._id]?.ordQty ?? v.orderQty ?? "").length) + 3}ch` }}
                          className="px-1 py-1 text-sm border border-slate-300 rounded text-center outline-none focus:border-blue-500 [appearance:textfield] [&::-webkit-outer-spin-button]:appearance-none [&::-webkit-inner-spin-button]:appearance-none"
                        />
                      </td>
                      <td className="py-5 px-3 align-top text-center">
                        <input
                          type="number"
                          value={quantitiesValues[v._id]?.usedQty ?? v.usedQty ?? ""}
                          onChange={(e) => handleQuantityChange(v._id, "usedQty", e.target.value)}
                          onBlur={() => saveQuantities(v._id, v.returnType)}
                          style={{ width: `${Math.max(4, String(quantitiesValues[v._id]?.usedQty ?? v.usedQty ?? "").length) + 3}ch` }}
                          className="px-1 py-1 text-sm border border-slate-300 rounded text-center outline-none focus:border-blue-500 [appearance:textfield] [&::-webkit-outer-spin-button]:appearance-none [&::-webkit-inner-spin-button]:appearance-none"
                        />
                      </td>
                      <td className="py-5 px-3 align-top text-center font-bold text-slate-700">
                        {quantitiesValues[v._id]?.balQty ?? (v.balQty || 0)}
                      </td>
                      <td className="py-5 px-2 align-top text-center">
                        <div className="flex items-center justify-center gap-2">
                          <button onClick={() => handleInfo(idStr)} className="p-2 text-yellow-600 hover:bg-yellow-50 rounded-lg transition-colors duration-200" title="Details">
                            <Info className="w-4 h-4" />
                          </button>
                          <button onClick={() => handleEdit(v._id, v.returnType)} className="p-2 text-blue-600 hover:bg-blue-50 rounded-lg transition-colors duration-200" title="Edit">
                            <Pencil className="w-4 h-4" />
                          </button>
                          <button onClick={() => handleDelete(v._id, v.returnType)} className="p-2 text-red-600 hover:bg-red-50 rounded-lg transition-colors duration-200" title="Delete">
                            <Trash className="w-4 h-4" />
                          </button>
                          <button onClick={() => handleNormalPrint(v)} className="p-2 text-blue-600 hover:bg-blue-50 rounded-lg transition-colors duration-200" title="Print Invoice">
                            <Printer className="w-4 h-4" />
                          </button>
                          <button onClick={() => generateBarcodePrint(v)} className="p-2 text-purple-600 hover:bg-purple-50 rounded-lg transition-colors duration-200" title="Print Barcode">
                            <Barcode className="w-4 h-4" />
                          </button>
                          <button onClick={() => generateCardPrint(v)} className="p-2 text-emerald-600 hover:bg-emerald-50 rounded-lg transition-colors duration-200" title="Print PVC Card">
                            <CreditCard className="w-4 h-4" />
                          </button>
                        </div>
                      </td>
                    </tr>

                    {expandedRow === idStr && (
                      <tr>
                        <td
                          colSpan="13"
                          className="bg-blue-50 p-6 border-b-2 border-t-2 border-blue-300 shadow-lg"
                        >
                          <div className="bg-white rounded-lg p-4 border border-blue-200">
                            <h4 className="font-bold text-slate-700 uppercase text-sm tracking-wider mb-3">
                              📦 Items Details ({v.items?.length || 0} items)
                            </h4>
                            <div className="overflow-x-auto">
                              <table className="w-full text-xs border-collapse">
                                <thead className="bg-gradient-to-r from-slate-300 to-slate-200">
                                  <tr className="border-b-2 border-slate-400">
                                    <th className="p-2 text-left font-bold">Item Name</th>
                                    <th className="p-2 text-center font-bold">Eye</th>
                                    <th className="p-2 text-center font-bold">Sph</th>
                                    <th className="p-2 text-center font-bold">Cyl</th>
                                    <th className="p-2 text-center font-bold">Axis</th>
                                    <th className="p-2 text-center font-bold">Add</th>
                                    <th className="p-2 text-center font-bold">Remark</th>
                                    <th className="p-2 text-center font-bold">Qty</th>
                                    <th className="p-2 text-right font-bold">Purchase Price</th>
                                    <th className="p-2 text-right font-bold">Total</th>
                                  </tr>
                                </thead>
                                <tbody>
                                  {v.items?.map((it, idx) => (
                                    <tr key={idx} className="border-b border-slate-200 hover:bg-slate-50">
                                      <td className="p-2 font-semibold text-slate-700">{it.itemName || it.productName || "-"}</td>
                                      <td className="p-2 text-center">{it.eye || "-"}</td>
                                      <td className="p-2 text-center">{it.sph || "-"}</td>
                                      <td className="p-2 text-center">{it.cyl || "-"}</td>
                                      <td className="p-2 text-center">{it.axis || "-"}</td>
                                      <td className="p-2 text-center">{it.add || "-"}</td>
                                      <td className="p-2 text-center">{it.remark || "-"}</td>
                                      <td className="p-2 text-center font-bold text-blue-600">{it.qty || 0}</td>
                                      <td className="p-2 text-right">₹{roundAmount(it.purchasePrice || 0)}</td>
                                      <td className="p-2 text-right font-bold text-slate-700">₹{roundAmount(it.totalAmount || 0)}</td>
                                    </tr>
                                  ))}
                                </tbody>
                                <tfoot className="bg-slate-100 font-bold border-t border-slate-300">
                                  <tr>
                                    <td colSpan="7" className="p-2 text-right">Total:</td>
                                    <td className="p-2 text-center text-blue-600">{v.items?.reduce((s, it) => s + (Number(it.qty) || 0), 0) || 0}</td>
                                    <td colSpan="1"></td>
                                    <td className="p-2 text-right text-slate-900 font-bold tracking-tight">₹{roundAmount(v.subtotal || 0)}</td>
                                  </tr>
                                </tfoot>
                              </table>
                            </div>
                          </div>
                        </td>
                      </tr>
                    )}
                  </React.Fragment>
                );
              })
                )}
              </tbody>

              {/* Totals footer */}
              {filteredVouchers.length > 0 && (
                <tfoot className="bg-slate-100 font-bold sticky bottom-0 z-10 shadow-[0_-2px_4px_rgba(0,0,0,0.05)] border-t-2 border-slate-300">
                  <tr>
                    <td colSpan="7" className="py-4 px-3 text-right text-slate-700 uppercase tracking-wider text-sm font-black">
                      Grand Totals:
                    </td>
                    <td className="py-4 px-3 text-center text-slate-900 text-lg font-black underline decoration-double decoration-blue-500 underline-offset-4">
                      {`₹${roundAmount(totals.net)}`}
                    </td>
                    <td className="bg-slate-100/50" /> {/* Status Column */}
                    <td className="py-4 px-3 text-center text-blue-600 text-lg font-black underline decoration-double decoration-blue-500 underline-offset-4">
                      {totals.ordQty}
                    </td>
                    <td className="py-4 px-3 text-center text-orange-600 text-lg font-black underline decoration-double decoration-blue-500 underline-offset-4">
                      {totals.usedQty}
                    </td>
                    <td className="py-4 px-3 text-center text-green-600 text-lg font-black underline decoration-double decoration-blue-500 underline-offset-4">
                      {totals.balQty}
                    </td>
                    <td className="bg-slate-100/50" />
                  </tr>
                </tfoot>
              )}
            </table>
          </div>
        </div>
      </div>
    </div>
  );
}

export default PurchaseReturnVoucher;
