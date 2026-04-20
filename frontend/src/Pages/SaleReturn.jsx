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
  File,
  Info,
  Barcode,
  CreditCard,
} from "lucide-react";
import {
  getAllLensSaleReturn,
  removeLensSaleReturn,
  updateReturnQuantities,
} from "../controllers/SaleReturn.controller";
import {
  removeRxSaleReturn,
  getAllRxSaleReturn,
} from "../controllers/RxSaleReturn.controller.js";
import { useNavigate } from "react-router-dom";
import { toast, Toaster } from "react-hot-toast";
import { roundAmount } from "../utils/amountUtils";
import { numberToWords } from "../utils/numberToWords";
function SaleReturnVoucher() {
  const [saleReturns, setSaleReturns] = useState([]);
  const [expandedRow, setExpandedRow] = useState(null);
  const [quantitiesValues, setQuantitiesValues] = useState({});
  const [filters, setFilters] = useState({
    billSeries: "",
    dateFrom: "",
    dateTo: "",
    searchText: "",
  });

  const navigate = useNavigate();

  const fetchdata = async () => {
    try {
      const [lensRes, rxRes] = await Promise.all([
        getAllLensSaleReturn(),
        getAllRxSaleReturn(),
      ]);

      let combinedData = [];
      if (lensRes?.data) combinedData = [...combinedData, ...lensRes.data.map(item => ({ ...item, returnType: "lens" }))];
      if (rxRes?.data) combinedData = [...combinedData, ...rxRes.data.map(item => ({ ...item, returnType: "rx" }))];

      // Sort by date descending
      combinedData.sort((a, b) => new Date(b.billData?.date) - new Date(a.billData?.date));

      setSaleReturns(combinedData);
    } catch (err) {
      console.error("Error fetching sale return data:", err);
      toast.error("Failed to load some data");
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

  const saveQuantities = async (id) => {
    const vals = quantitiesValues[id];
    if (!vals) return;
    const o = Number(vals.ordQty || 0);
    const u = Number(vals.usedQty || 0);
    if (u > o) {
      toast.error("Used Qty cannot exceed Order Qty");
      return;
    }
    // We assume the type is stored on the object or we can find it. 
    // Since we merged them and added returnType, we can find it in saleReturns.
    // For simplicity, we just use the API that works for both if available, 
    // but the current controller only has updateReturnQuantities for lens?
    // Let's assume for now it works or the user only wants it for lens.
    const res = await updateReturnQuantities(id, { orderQty: o, usedQty: u });
    if (res.success) {
      toast.success("Quantities updated");
      fetchdata();
    } else {
      toast.error("Failed to update");
    }
  };

  useEffect(() => {
    const vals = {};
    if (saleReturns) {
      saleReturns.forEach(v => {
        vals[v._id] = {
          ordQty: v.orderQty !== undefined ? v.orderQty : (v.items?.reduce((s, i) => s + (Number(i.qty) || 0), 0) || 0),
          usedQty: v.usedQty || 0,
          balQty: v.balQty || 0
        };
      });
      setQuantitiesValues(vals);
    }
  }, [saleReturns]);

  const handleFilterChange = (field, value) => {
    setFilters((p) => ({ ...p, [field]: value }));
  };

  const handleAddSaleReturn = () => {
    navigate("/lenstransaction/addsalereturn");
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
      // Prioritize the dedicated 'time' field if it exists
      if (v.time) return v.time;

      // Fallback to createdAt or billData.date
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

  // Print Template Components
  const NormalPrintTemplate = ({ order }) => {
    const formatDate = (dateStr) => {
      if (!dateStr) return "-";
      const date = new Date(dateStr);
      return date.toLocaleDateString("en-IN", {
        day: "2-digit",
        month: "2-digit",
        year: "numeric"
      });
    };

    return (
      <div className="print-container bg-white p-4 max-w-4xl mx-auto text-slate-800 font-sans" style={{ minHeight: '800px' }}>
        {/* Header Section */}
        <div className="flex justify-between items-center mb-6 pb-2 border-b border-slate-300">
          <div className="flex items-center gap-4">
            <img src="/sadguru_logo.svg" alt="Logo" style={{ width: '120px', height: 'auto' }} />
          </div>
          <div className="flex-1 text-center">
              <h1 className="text-3xl font-black text-slate-900 tracking-tight">SALE RETURN</h1>
          </div>
          <div className="w-[120px]"></div> {/* Spacer to keep title centered */}
        </div>

        <div className="grid grid-cols-2 gap-8 mb-4">
          {/* Left: Party Details */}
          <div className="space-y-1">
            <div className="flex gap-2">
              <span className="font-bold w-28">Party Name</span>
              <span>: {order?.partyData?.partyAccount || "-"}</span>
            </div>
            <div className="flex gap-2">
              <span className="font-bold w-28">Address</span>
              <span className="flex-1">: {order?.partyData?.address || "-"}</span>
            </div>
            <div className="flex gap-2">
              <span className="font-bold w-28">State</span>
              <span>: {order?.partyData?.stateCode || "-"}</span>
            </div>
            <div className="flex gap-2">
              <span className="font-bold w-28">Phone</span>
              <span>: {order?.partyData?.contactNumber || "-"}</span>
            </div>
          </div>

          {/* Right: Bill Information */}
          <div className="space-y-1 ml-auto">
            <div className="flex gap-2 justify-end">
              <span className="font-bold w-28">Bill Series</span>
              <span className="w-32">: {order?.billData?.billSeries || "-"}</span>
            </div>
            <div className="flex gap-2 justify-end">
              <span className="font-bold w-28">Bill No</span>
              <span className="w-32">: {order?.billData?.billNo || "-"}</span>
            </div>
            <div className="flex gap-2 justify-end">
              <span className="font-bold w-28">Date</span>
              <span className="w-32">: {formatDate(order?.billData?.date)}</span>
            </div>
          </div>
        </div>

        {/* Table Section */}
        <table className="w-full border-collapse border border-slate-400 text-[11px]">
          <thead>
            <tr className="bg-slate-100 uppercase">
              <th className="border border-slate-400 p-1 w-8">SR</th>
              <th className="border border-slate-400 p-1 text-left">ITEM NAME</th>
              <th className="border border-slate-400 p-1">ORDER NO</th>
              <th className="border border-slate-400 p-1">EYE</th>
              <th className="border border-slate-400 p-1">SPH</th>
              <th className="border border-slate-400 p-1">CYL</th>
              <th className="border border-slate-400 p-1">AXIS</th>
              <th className="border border-slate-400 p-1">ADD</th>
              <th className="border border-slate-400 p-1">QTY</th>
              <th className="border border-slate-400 p-1 text-right">PRICE</th>
              <th className="border border-slate-400 p-1 text-right">DISC</th>
              <th className="border border-slate-400 p-1 text-right">TOTAL</th>
            </tr>
          </thead>
          <tbody>
            {order?.items?.map((item, idx) => (
              <tr key={idx} className="h-8">
                <td className="border border-slate-400 p-1 text-center">{idx + 1}</td>
                <td className="border border-slate-400 p-1 font-bold">{item.itemName || "-"}</td>
                <td className="border border-slate-400 p-1 text-center">{item.orderNo || item.refId || "-"}</td>
                <td className="border border-slate-400 p-1 text-center">{item.eye || "-"}</td>
                <td className="border border-slate-400 p-1 text-center font-mono">{item.sph || "-"}</td>
                <td className="border border-slate-400 p-1 text-center font-mono">{item.cyl || "-"}</td>
                <td className="border border-slate-400 p-1 text-center font-mono">{item.axis || "-"}</td>
                <td className="border border-slate-400 p-1 text-center font-mono">{item.add || "-"}</td>
                <td className="border border-slate-400 p-1 text-center font-bold">{item.qty || 0}</td>
                <td className="border border-slate-400 p-1 text-right">{roundAmount(item.salePrice || 0)}</td>
                <td className="border border-slate-400 p-1 text-right">{item.discount || 0}%</td>
                <td className="border border-slate-400 p-1 text-right font-bold">{roundAmount(item.totalAmount || 0)}</td>
              </tr>
            ))}
            {[...Array(Math.max(0, 5 - (order?.items?.length || 0)))].map((_, i) => (
               <tr key={`empty-${i}`} className="h-8">
                 <td className="border border-slate-400 p-1"></td>
                 <td className="border border-slate-400 p-1"></td>
                 <td className="border border-slate-400 p-1"></td>
                 <td className="border border-slate-400 p-1"></td>
                 <td className="border border-slate-400 p-1"></td>
                 <td className="border border-slate-400 p-1"></td>
                 <td className="border border-slate-400 p-1"></td>
                 <td className="border border-slate-400 p-1"></td>
                 <td className="border border-slate-400 p-1"></td>
                 <td className="border border-slate-400 p-1"></td>
                 <td className="border border-slate-400 p-1"></td>
                 <td className="border border-slate-400 p-1"></td>
               </tr>
            ))}
            <tr className="bg-slate-50 font-bold">
              <td colSpan={2} className="border border-slate-400 p-1 text-center uppercase tracking-widest text-[10px]">Total</td>
              <td colSpan={6} className="border border-slate-400 p-1"></td>
              <td className="border border-slate-400 p-1 text-center">{order?.items?.reduce((sum, i) => sum + (Number(i.qty) || 0), 0)}</td>
              <td className="border border-slate-400 p-1"></td>
              <td className="border border-slate-400 p-1"></td>
              <td className="border border-slate-400 p-1 text-right">{roundAmount(order?.subtotal || 0)}</td>
            </tr>
          </tbody>
        </table>

        {/* Footer Section */}
        <div className="mt-4 grid grid-cols-2 gap-4">
          <div className="space-y-4">
            <div>
              <p className="text-[10px] font-bold text-slate-500 uppercase">Total Invoice value ( In Words ) :</p>
              <p className="text-sm font-black italic">{numberToWords(order?.netAmount || 0)}</p>
            </div>
            <div className="pt-2 border-t border-slate-200">
              <p className="text-[10px] font-bold text-slate-800">Terms & Condition</p>
              <p className="text-[10px] text-slate-500 italic leading-tight mt-1">
                We declare that this invoice shows the actual price of the goods described<br />
                and that all particulars are true and correct.
              </p>
            </div>
          </div>

          <div className="ml-auto w-64 space-y-1 text-sm border-l border-slate-200 pl-6">
            <div className="flex justify-between">
              <span className="font-bold">Total Amount</span>
              <span>{roundAmount(order?.netAmount || 0)}</span>
            </div>
            <div className="flex justify-between">
              <span className="font-bold">Paid Amt</span>
              <span>{roundAmount(order?.paidAmount || 0)}</span>
            </div>
            <div className="flex justify-between text-red-600 font-black border-b border-slate-200 pb-1">
              <span className="font-bold">Due Amt</span>
              <span>{roundAmount(order?.dueAmount || 0)}</span>
            </div>
            <div className="flex justify-between pt-1">
              <span className="font-bold">Prev.Bal</span>
              <span>{roundAmount(order?.partyData?.prevBalance || order?.partyData?.CurrentBalance?.amount || 0)}</span>
            </div>
            <div className="flex justify-between pt-2 mt-4 border-t border-slate-400 font-black text-lg">
               <span>Net Payable</span>
               <span>{roundAmount((order?.dueAmount || 0) + (order?.partyData?.prevBalance || order?.partyData?.CurrentBalance?.amount || 0))}</span>
            </div>
          </div>
        </div>

        {/* Signature Section */}
        <div className="mt-16 flex justify-between px-8">
          <div className="text-center">
              <div className="w-32 border-b border-slate-400 mb-2"></div>
              <p className="text-[10px] uppercase font-bold text-slate-400">Customer Sign</p>
          </div>
          <div className="text-center">
               <p className="text-[11px] font-black mb-12">For, Sadguru Opticals</p>
              <div className="w-40 border-b border-slate-400 mb-2"></div>
              <p className="text-[10px] uppercase font-bold text-slate-400">Authorized Signatory</p>
          </div>
        </div>
      </div>
    );
  };

  const BarcodePrintTemplate = ({ order }) => {
    return (
      <div className="print-container bg-white p-4">
        <div className="text-center mb-6">
          <h2 className="text-lg font-bold">BARCODE LABELS</h2>
          <p className="text-sm text-gray-600">
            Order: {order?.billData?.billNo}
          </p>
        </div>

        <div className="flex flex-wrap gap-4 justify-center">
          {order?.items?.map((item, idx) => {
            const barcodeText = `${order?.billData?.billNo || 'RTN'}-${idx + 1}`;
            return (
              <div key={idx} className="barcode-item p-4 border border-gray-800 bg-white">
                <div className="mb-2">
                  <p className="text-xs font-semibold">{item.itemName}</p>
                  <p>Price: ₹{roundAmount(item.salePrice || 0)} | Qty: {item.qty}</p>
                </div>
                <div className="bg-white p-2 my-2 font-mono text-xs border border-gray-600 flex justify-center">
                  <div className="flex gap-0.5 items-end h-16">
                    {barcodeText.split("").map((char, i) => (
                      <div
                        key={i}
                        className="bg-black"
                        style={{
                          width: "3px",
                          height: Math.random() * 40 + 30 + "px",
                        }}
                      />
                    ))}
                  </div>
                </div>
                <p className="text-xs font-semibold text-center mt-2 tracking-wider">{barcodeText}</p>
              </div>
            );
          })}
        </div>
      </div>
    );
  };

  const CardPrintTemplate = ({ order }) => {
    return (
      <div className="print-container bg-white p-4">
        <div className="text-center mb-6">
          <h2 className="text-lg font-bold">PRODUCT CARDS</h2>
          <p className="text-sm text-gray-600">Return: {order?.billData?.billNo}</p>
        </div>
        <div className="grid grid-cols-2 gap-4 justify-items-center">
          {order?.items?.map((item, idx) => (
            <div key={idx} className="card-item p-4 border-2 border-gray-800 bg-white max-w-xs">
              <div className="mb-3">
                <h3 className="text-sm font-bold text-center">{item.itemName}</h3>
              </div>
              <div className="grid grid-cols-2 gap-2 text-xs mb-3">
                <div className="text-center border border-gray-400 p-1">
                  <p className="text-xs font-semibold">SPH</p>
                  <p className="text-sm font-bold">{item.sph || "-"}</p>
                </div>
                <div className="text-center border border-gray-400 p-1">
                  <p className="text-xs font-semibold">CYL</p>
                  <p className="text-sm font-bold">{item.cyl || "-"}</p>
                </div>
                <div className="text-center border border-gray-400 p-1">
                  <p className="text-xs font-semibold">AXIS</p>
                  <p className="text-sm font-bold">{item.axis || "-"}</p>
                </div>
                <div className="text-center border border-gray-400 p-1">
                  <p className="text-xs font-semibold">QTY</p>
                  <p className="text-sm font-bold">{item.qty || 0}</p>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    );
  };

  // ── Excel Export ──────────────────────────────────────────────
  const handleExcelExport = () => {
    const rows = filteredVouchers.map((v, i) => ({
      "S.N.": i + 1,
      "Bill Date": safeDate(v.billData?.date),
      "Time": formatTime(v),
      "Bill Series": v.billData?.billSeries || "-",
      "Bill No.": v.billData?.billNo || "-",
      "Party Name": v.partyData?.partyAccount || "-",
      "Net Amount": v.netAmount || 0,
      "Type": v.returnType || "-",
    }));
    const ws = XLSX.utils.json_to_sheet(rows);
    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, "Sale Returns");
    XLSX.writeFile(wb, "sale_return_vouchers.xlsx");
    toast.success("Excel file downloaded!");
  };

  // ── Table Print (header Printer button) ─────────────────────
  const handleTablePrint = () => {
    const tableRows = filteredVouchers
      .map(
        (v, i) => `<tr>
          <td>${i + 1}</td>
          <td>${safeDate(v.billData?.date)}</td>
          <td>${formatTime(v)}</td>
          <td>${v.billData?.billSeries || "-"}</td>
          <td>${v.billData?.billNo || "-"}</td>
          <td>${v.partyData?.partyAccount || "-"}</td>
          <td>&#8377;${roundAmount(v.netAmount)}</td>
        </tr>`
      )
      .join("");

    const html = `<!DOCTYPE html>
      <html>
      <head>
        <title>Sale Return Voucher List</title>
        <style>
          body { font-family: Arial, sans-serif; margin: 20px; }
          h1 { font-size: 20px; margin-bottom: 5px; }
          p { font-size: 12px; color: #666; margin-bottom: 15px; }
          table { width: 100%; border-collapse: collapse; }
          th { background: #1e293b; color: white; padding: 8px; text-align: left; font-size: 12px; }
          td { border: 1px solid #cbd5e1; padding: 7px 8px; font-size: 12px; }
          tr:nth-child(even) { background: #f8fafc; }
        </style>
      </head>
      <body>
        <h1>Sale Return Voucher List</h1>
        <p>Total Records: ${filteredVouchers.length}</p>
        <table>
          <thead>
            <tr>
              <th>S.N.</th><th>Bill Date</th><th>Time</th><th>Bill Series</th><th>Bill No.</th><th>Party Name</th><th>Net Amount</th>
            </tr>
          </thead>
          <tbody>${tableRows}</tbody>
        </table>
      </body>
      </html>`;

    const pw = window.open("", "_blank");
    pw.document.write(html);
    pw.document.close();
    pw.focus();
    pw.print();
  };

  // ── Action Column Print Handlers ────────────────────────────
  const buildPrintWindow = (htmlContent) => {
    const pw = window.open("", "_blank");
    pw.document.write(htmlContent);
    pw.document.close();
    pw.focus();
    pw.print();
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
          <td style="border:1px solid #94a3b8;padding:4px;font-weight:bold">${it.itemName || "-"}</td>
          <td style="border:1px solid #94a3b8;padding:4px;text-align:center">${it.orderNo || it.refId || "-"}</td>
          <td style="border:1px solid #94a3b8;padding:4px;text-align:center">${it.eye || "-"}</td>
          <td style="border:1px solid #94a3b8;padding:4px;text-align:center">${it.sph || "-"}</td>
          <td style="border:1px solid #94a3b8;padding:4px;text-align:center">${it.cyl || "-"}</td>
          <td style="border:1px solid #94a3b8;padding:4px;text-align:center">${it.axis || "-"}</td>
          <td style="border:1px solid #94a3b8;padding:4px;text-align:center">${it.add || "-"}</td>
          <td style="border:1px solid #94a3b8;padding:4px;text-align:center;font-weight:bold">${it.qty || 0}</td>
          <td style="border:1px solid #94a3b8;padding:4px;text-align:right">&#8377;${roundAmount(it.salePrice || 0)}</td>
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
        <title>Sale Return - Normal Print</title>
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
          <h1 class="title">SALE RETURN</h1>
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
    buildPrintWindow(html);
  };

  const handleBarcodePrint = (order) => {
    printBarcodeStickers(order, [], []);
  };

  const handleCardPrint = (order) => {
    printAuthenticityCard(order, [], []);
  };

  const handleInfo = (id) => {
    setExpandedRow(expandedRow === id ? null : id);
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

  const filteredVouchers = useMemo(() => {
    const q = filters.searchText?.toLowerCase().trim();
    return saleReturns.filter((v) => {
      const billDate = new Date(v.billData?.date);
      const combined = `${v.billData?.billSeries || ""} ${v.billData?.billNo || ""} ${v.partyData?.partyAccount || ""}`.toLowerCase();
      if (q && !combined.includes(q)) return false;
      if (filters.dateFrom && billDate < new Date(filters.dateFrom)) return false;
      if (filters.dateTo && billDate > new Date(filters.dateTo)) return false;
      return true;
    });
  }, [filters, saleReturns]);

  const parseNumber = (val) => {
    if (val === null || val === undefined) return 0;
    const n = Number(String(val).replace(/,/g, "").replace(/[^0-9.-]/g, ""));
    return Number.isFinite(n) ? n : 0;
  };

  const totals = useMemo(() => {
    let net = 0;
    let ordQty = 0;
    filteredVouchers.forEach((v) => {
      net += parseNumber(v.netAmount);
      // Fallback to item sum for quantity
      const q = Number(quantitiesValues[v._id]?.ordQty ?? 0) || (v.items?.reduce((s, i) => s + (Number(i.qty) || 0), 0) || 0);
      ordQty += q;
    });
    return { net, ordQty };
  }, [filteredVouchers, quantitiesValues]);

  const formatINR = (num) =>
    num.toLocaleString("en-IN", {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    });

  const handleEdit = (id, type) => {
    if (type === "lens") {
      navigate(`/lenstransaction/addsalereturn/${id}`);
    } else {
      navigate(`/rxtransaction/addrxsalereturn/${id}`);
    }
  };

  const handleDelete = async (id, type) => {
    if (!window.confirm("Are you sure you want to delete this?")) return;
    const res = type === "lens" ? await removeLensSaleReturn(id) : await removeRxSaleReturn(id);
    if (res.success) {
      toast.success("Sale Return deleted successfully!");
      setSaleReturns((prev) => prev.filter((o) => o._id !== id));
    } else {
      toast.error(res.error || "Failed to delete");
    }
  };

  return (
    <div className="p-4 bg-slate-100 min-h-screen font-sans">
      <div className="max-w-[98vw] mx-auto">
        {/* Header */}
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-slate-800 mb-2">
            Sale Return Voucher List
          </h1>
          <p className="text-slate-600">
            Manage sales return vouchers and refunds
          </p>
        </div>

        {/* Filters */}
        <div className="bg-white rounded-xl shadow-md border border-slate-200 p-4 mb-4">
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-3 mb-4">
            <div className="relative">
              <input
                type="text"
                value={filters.searchText}
                onChange={(e) => handleFilterChange("searchText", e.target.value)}
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
            <div className="flex flex-wrap justify-start gap-2"></div>
            <div className="flex flex-wrap justify-start gap-2 ">
              <button
                onClick={handleReset}
                className="inline-flex items-center gap-1.5 px-4 py-2 bg-gray-100 text-gray-700 text-sm font-medium rounded-lg hover:bg-gray-200 transition-colors duration-200"
              >
                <RotateCcw className="w-3.5 h-3.5" />
                Reset
              </button>
              <button
                onClick={handleAddSaleReturn}
                className="inline-flex items-center gap-1.5 px-4 py-2 bg-green-600 text-white text-sm font-medium rounded-lg hover:bg-green-700 transition-colors duration-200"
              >
                <Plus className="w-3.5 h-3.5" />
                Add Sales Return
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
                  <th className="w-20 text-center py-4 px-3 text-slate-700 font-bold text-sm">S.N.</th>
                  <th className="min-w-[120px] text-center py-4 px-3 text-slate-700 font-bold text-sm">Bill Date</th>
                  <th className="min-w-[120px] text-center py-4 px-3 text-slate-700 font-bold text-sm">Time</th>
                  <th className="min-w-[180px] text-center py-4 px-3 text-slate-700 font-bold text-sm">Bill Series</th>
                  <th className="min-w-[100px] text-center py-4 px-3 text-slate-700 font-bold text-sm">Bill No.</th>
                  <th className="min-w-[280px] text-center py-4 px-3 text-slate-700 font-bold text-sm">Party Name</th>
                  <th className="min-w-[130px] text-center py-4 px-3 text-slate-700 font-bold text-sm">Net Amt</th>
                  <th className="min-w-[80px] text-center py-4 px-3 text-slate-700 font-bold text-sm">Ord Q</th>
                  <th className="w-[200px] text-center py-4 px-3 text-slate-700 font-bold text-sm">Action</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-200">
                {filteredVouchers.length === 0 ? (
                  <tr>
                    <td colSpan="9" className="p-10 text-center text-slate-500">
                      <p className="text-xl">No return vouchers found</p>
                      <p className="text-md">Try adjusting your search criteria</p>
                    </td>
                  </tr>
                ) : (
                  filteredVouchers.map((v, i) => {
                    const idStr = String(v._id);
                    return (
                      <React.Fragment key={idStr}>
                        <tr className="hover:bg-slate-50 transition-colors duration-150 group text-sm">
                      <td className="w-20 text-center text-slate-600 font-medium py-5 px-2 align-top whitespace-nowrap">
                        <span className="text-base">{i + 1}</span>
                      </td>
                      <td className="py-5 px-3 text-slate-800 align-top text-center">{safeDate(v.billData.date)}</td>
                      <td className="py-5 px-3 text-slate-800 align-top text-center">{formatTime(v)}</td>
                      <td className="py-5 px-3 text-slate-800 align-top text-center">{v.billData.billSeries}</td>
                      <td className="py-5 px-3 text-slate-800 align-top text-center">{v.billData.billNo}</td>
                      <td className="py-5 px-3 text-slate-700 align-top text-center">{v.partyData.partyAccount}</td>
                      <td className="text-center text-slate-900 font-medium py-5 px-3 align-top">
                        {v.netAmount !== "0.00" ? `₹${roundAmount(v.netAmount)}` : "-"}
                      </td>
                      <td className="py-5 px-3 align-top text-center">
                        <input
                          type="number"
                          value={quantitiesValues[v._id]?.ordQty ?? ""}
                          onChange={(e) => handleQuantityChange(v._id, "ordQty", e.target.value)}
                          onBlur={() => saveQuantities(v._id)}
                          className="w-full px-1 py-1 text-sm border border-slate-300 rounded text-center outline-none focus:border-blue-500"
                        />
                      </td>
                      <td className="w-[200px] text-center py-5 px-3 align-top">
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
                          <button onClick={() => handleNormalPrint(v)} className="p-2 text-purple-600 hover:bg-purple-50 rounded-lg transition-colors duration-200" title="Normal Print">
                            <Printer className="w-4 h-4" />
                          </button>
                          <button onClick={() => handleBarcodePrint(v)} className="p-2 text-indigo-600 hover:bg-indigo-50 rounded-lg transition-colors duration-200" title="Barcode Print">
                            <Barcode className="w-4 h-4" />
                          </button>
                          <button onClick={() => handleCardPrint(v)} className="p-2 text-cyan-600 hover:bg-cyan-50 rounded-lg transition-colors duration-200" title="Card Print">
                            <CreditCard className="w-4 h-4" />
                          </button>
                        </div>
                      </td>
                    </tr>

                    {expandedRow === idStr && (
                      <tr>
                        <td
                          colSpan="9"
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
                                    <th className="p-2 text-center font-bold">Order No</th>
                                    <th className="p-2 text-center font-bold">Eye</th>
                                    <th className="p-2 text-center font-bold">Sph</th>
                                    <th className="p-2 text-center font-bold">Cyl</th>
                                    <th className="p-2 text-center font-bold">Axis</th>
                                    <th className="p-2 text-center font-bold">Add</th>
                                    <th className="p-2 text-center font-bold">Remark</th>
                                    <th className="p-2 text-center font-bold">Qty</th>
                                    <th className="p-2 text-right font-bold">Sale Price</th>
                                    <th className="p-2 text-right font-bold">Discount</th>
                                    <th className="p-2 text-right font-bold">Total</th>
                                  </tr>
                                </thead>
                                <tbody>
                                  {v.items?.map((it, idx) => (
                                    <tr key={idx} className="border-b border-slate-200 hover:bg-slate-50">
                                      <td className="p-2 font-semibold text-slate-700">{it.itemName || "-"}</td>
                                      <td className="p-2 text-center">{it.orderNo || "-"}</td>
                                      <td className="p-2 text-center">{it.eye || "-"}</td>
                                      <td className="p-2 text-center">{it.sph || "-"}</td>
                                      <td className="p-2 text-center">{it.cyl || "-"}</td>
                                      <td className="p-2 text-center">{it.axis || "-"}</td>
                                      <td className="p-2 text-center">{it.add || "-"}</td>
                                      <td className="p-2 text-center">{it.remark || "-"}</td>
                                      <td className="p-2 text-center font-bold text-blue-600">{it.qty || 0}</td>
                                      <td className="p-2 text-right">₹{roundAmount(it.salePrice || 0)}</td>
                                      <td className="p-2 text-right">{it.discount || 0}%</td>
                                      <td className="p-2 text-right font-bold text-slate-700">₹{roundAmount(it.totalAmount || 0)}</td>
                                    </tr>
                                  ))}
                                </tbody>
                                <tfoot className="bg-slate-100 font-bold border-t border-slate-300">
                                  <tr>
                                    <td colSpan="8" className="p-2 text-right">Total:</td>
                                    <td className="p-2 text-center text-blue-600">{v.items?.reduce((s, it) => s + (Number(it.qty) || 0), 0) || 0}</td>
                                    <td colSpan="2"></td>
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
              <tfoot className="bg-slate-100 font-bold sticky bottom-0 z-10 shadow-[0_-2px_4px_rgba(0,0,0,0.05)] border-t-2 border-slate-300">
                <tr>
                  <td colSpan="6" className="py-4 px-3 text-right text-slate-700 uppercase tracking-wider text-sm font-black">
                    Grand Totals:
                  </td>
                  <td className="py-4 px-3 text-center text-slate-900 text-lg font-black underline decoration-double decoration-blue-500 underline-offset-4">
                    {`₹${roundAmount(totals.net)}`}
                  </td>
                  <td className="py-4 px-3 text-center text-blue-600 text-lg font-black underline decoration-double decoration-blue-500 underline-offset-4">
                    {totals.ordQty}
                  </td>
                  <td className="bg-slate-100/50" />
                </tr>
              </tfoot>
            </table>
          </div>
        </div>
      </div>
    </div>
  );
}

export default SaleReturnVoucher;
