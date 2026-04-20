import React, { useState, useEffect, useMemo } from "react";
import { X, Save, RotateCcw, Filter, Search, FileDown } from "lucide-react";
import jsPDF from "jspdf";
import autoTable from "jspdf-autotable";

const ItemsMatrixViewModal = ({
    isOpen,
    onClose,
    title = "Items Matrix",
    pdfTitle,
    data = [],
    columns = [],
    onSave
}) => {
    const [items, setItems] = useState([]);
    const [loading, setLoading] = useState(false);
    const [matrixData, setMatrixData] = useState({});
    const [activeEye, setActiveEye] = useState("RL");

    useEffect(() => {
        if (isOpen) {
            const initialData = JSON.parse(JSON.stringify(data || []));
            setItems(initialData);

            const eyes = [...new Set(initialData.map(it => it.eye).filter(Boolean))];
            if (eyes.length > 0) setActiveEye(eyes[0]);
        }
    }, [isOpen, data]);

    const generateRange = (values) => {
        if (!values || values.length === 0) return [];
        const numericValues = [...new Set(values.map(v => parseFloat(v)).filter(v => !isNaN(v)))];
        if (numericValues.length === 0) return [];
        const zeroVal = numericValues.filter(v => v === 0);
        const negativeVals = numericValues.filter(v => v < 0).sort((a, b) => b - a);
        const positiveVals = numericValues.filter(v => v > 0).sort((a, b) => a - b);
        return [...zeroVal, ...negativeVals, ...positiveVals].map(v => v.toFixed(2));
    };

    const sphList = useMemo(() => generateRange(items.map(it => it.sph)), [items]);
    const cylList = useMemo(() => generateRange(items.map(it => it.cyl)), [items]);
    const addList = useMemo(() => generateRange(items.map(it => it.add || it.addValue || 0)), [items]);

    const hasActualAdd = useMemo(() => {
        return items.some(it => {
            const a = parseFloat(it.add || it.addValue || 0);
            return a !== 0;
        });
    }, [items]);

    useEffect(() => {
        const matrix = {};
        items.forEach(item => {
            const sphKey = parseFloat(item.sph || 0).toFixed(2);
            const cylKey = parseFloat(item.cyl || 0).toFixed(2);
            const addKey = parseFloat(item.add || item.addValue || 0).toFixed(2);
            const eye = item.eye || "RL";

            if (hasActualAdd) {
                const rowKey = `${eye}_${sphKey}_${cylKey}`;
                if (!matrix[rowKey]) {
                    matrix[rowKey] = {
                        sph: sphKey,
                        cyl: cylKey,
                        eye: eye,
                        axis: item.axis || "",
                        price: item.salePrice || item.purchasePrice || 0,
                        status: item.itemStatus || item.status || "Pending",
                        vendor: item.vendor || "",
                        adds: {},
                        itemRef: item
                    };
                }
                matrix[rowKey].adds[addKey] = {
                    qty: item.qty || 0,
                    _id: item._id
                };
            } else {
                const rowKey = `${eye}_${sphKey}`;
                if (!matrix[rowKey]) {
                    matrix[rowKey] = {
                        sph: sphKey,
                        eye: eye,
                        axis: item.axis || "",
                        price: item.salePrice || item.purchasePrice || 0,
                        status: item.itemStatus || item.status || "Pending",
                        vendor: item.vendor || "",
                        cyls: {},
                        itemRef: item
                    };
                }
                matrix[rowKey].cyls[cylKey] = {
                    qty: item.qty || 0,
                    _id: item._id
                };
            }
        });
        setMatrixData(matrix);
    }, [items, hasActualAdd]);

    const handleQtyChange = (sph, cyl, addOrCyl, val) => {
        const rowKey = hasActualAdd ? `${activeEye}_${sph}_${cyl}` : `${activeEye}_${sph}`;
        setMatrixData(prev => {
            const row = prev[rowKey] || (hasActualAdd ? { adds: {} } : { cyls: {} });
            if (hasActualAdd) {
                const newAdds = { ...row.adds, [addOrCyl]: { ...row.adds[addOrCyl], qty: val } };
                return { ...prev, [rowKey]: { ...row, adds: newAdds } };
            } else {
                const newCyls = { ...row.cyls, [addOrCyl]: { ...(row.cyls[addOrCyl] || {}), qty: val } };
                return { ...prev, [rowKey]: { ...row, cyls: newCyls } };
            }
        });
    };

    const handleRowPropChange = (sph, cyl, prop, val) => {
        const rowKey = hasActualAdd ? `${activeEye}_${sph}_${cyl}` : `${activeEye}_${sph}`;
        setMatrixData(prev => ({
            ...prev,
            [rowKey]: { ...(prev[rowKey] || {}), [prop]: val }
        }));
    };

    const handleMatrixKeyDown = (e, rowIdx, colIdx, rowCount) => {
        let targetRow = rowIdx;
        let targetCol = colIdx;
        const totalCols = (addList.length > 0 ? addList.length : 1) + 4; // sph, cyl, axis, price, status, adds

        if (e.key === "Enter") {
            e.preventDefault();
            targetRow++;
            if (targetRow >= rowCount) {
                targetRow = 0;
                targetCol++;
            }
        } else if (e.key === "ArrowDown") targetRow++;
        else if (e.key === "ArrowUp") targetRow--;
        else if (e.key === "ArrowRight") targetCol++;
        else if (e.key === "ArrowLeft") targetCol--;
        else return;

        const nextInput = document.querySelector(`[data-matrix-input][data-row="${targetRow}"][data-col="${targetCol}"]`);
        if (nextInput) {
            e.preventDefault();
            nextInput.focus();
            if (nextInput.select) nextInput.select();
        }
    };

    const handleSaveClick = async () => {
        setLoading(true);
        try {
            const updatedItems = [];
            Object.entries(matrixData).forEach(([rowKey, data]) => {
                const parts = rowKey.split("_");
                const eye = parts[0];
                const sph = parts[1];
                const cyl = hasActualAdd ? parts[2] : null;

                const valuesSource = hasActualAdd ? data.adds : data.cyls;

                Object.entries(valuesSource).forEach(([colVal, cellData]) => {
                    const qty = parseFloat(cellData.qty);
                    const currentCyl = hasActualAdd ? cyl : colVal;
                    const currentAdd = hasActualAdd ? colVal : "0.00";

                    const originalItem = items.find(it =>
                        it._id === cellData._id ||
                        (it.eye === eye && 
                         parseFloat(it.sph || 0).toFixed(2) === sph && 
                         parseFloat(it.cyl || 0).toFixed(2) === currentCyl && 
                         parseFloat(it.add || it.addValue || 0).toFixed(2) === currentAdd)
                    ) || data.itemRef;

                    updatedItems.push({
                        ...originalItem,
                        qty: qty,
                        axis: data.axis,
                        salePrice: data.price,
                        purchasePrice: data.price,
                        itemStatus: data.status,
                        status: data.status,
                        vendor: data.vendor,
                        totalAmount: parseFloat((qty * data.price).toFixed(2))
                    });
                });
            });
            await onSave(updatedItems);
            onClose();
        } catch (error) {
            console.error("Failed to save matrix", error);
        } finally {
            setLoading(false);
        }
    };

    const availableEyes = useMemo(() => [...new Set(items.map(it => it.eye).filter(Boolean))], [items]);
    const matrixRows = useMemo(() => {
        const rows = [];
        sphList.forEach(sph => {
            if (hasActualAdd) {
                cylList.forEach(cyl => {
                    const rowKey = `${activeEye}_${sph}_${cyl}`;
                    if (matrixData[rowKey]) rows.push({ sph, cyl });
                });
            } else {
                const rowKey = `${activeEye}_${sph}`;
                if (matrixData[rowKey]) rows.push({ sph });
            }
        });
        return rows;
    }, [sphList, cylList, activeEye, matrixData, hasActualAdd]);

    const summary = useMemo(() => {
        return Object.values(matrixData).reduce((acc, row) => {
            const cells = hasActualAdd ? Object.values(row.adds || {}) : Object.values(row.cyls || {});
            const rowQty = cells.reduce((sum, v) => sum + (parseFloat(v.qty) || 0), 0);
            const rowItems = cells.filter(v => (parseFloat(v.qty) || 0) > 0).length;
            
            return {
                items: acc.items + rowItems,
                qty: acc.qty + rowQty,
                value: acc.value + (rowQty * (parseFloat(row.price) || 0))
            };
        }, { items: 0, qty: 0, value: 0 });
    }, [matrixData, hasActualAdd]);

    const handleDownloadPDF = async () => {
        const doc = new jsPDF("l", "pt", "a4");
        const actualPdfTitle = pdfTitle || title;
        
        // Load and add Logo
        try {
            const img = new Image();
            img.src = "/sadguru_logo.svg";
            await new Promise((resolve, reject) => {
                img.onload = resolve;
                img.onerror = reject;
            });
            const imgW = img.width || 200;
            const imgH = img.height || 60;
            const canvas = document.createElement("canvas");
            canvas.width = imgW;
            canvas.height = imgH;
            const ctx = canvas.getContext("2d");
            ctx.drawImage(img, 0, 0, imgW, imgH);
            const pngDataUrl = canvas.toDataURL("image/png");
            
            doc.addImage(pngDataUrl, "PNG", 40, 35, 80, (imgH / imgW) * 80);
        } catch (e) {
            console.error("Could not add logo", e);
        }
        
        // Header
        doc.setFontSize(18);
        doc.setTextColor(40);
        doc.text(`${actualPdfTitle}`, 160, 40);
        
        doc.setFontSize(11);
        doc.setTextColor(100);
        doc.text(`Item Name: ${items[0]?.itemName || "N/A"}`, 160, 60);
        doc.text(`Eye: ${activeEye}`, 160, 75);
        doc.text(`Generated On: ${new Date().toLocaleString()}`, 160, 90);

        // Matrix Table
        const headers = ["EYE", "SPH"];
        if (hasActualAdd) headers.push("CYL");
        headers.push("AXIS");

        if (hasActualAdd) {
            addList.forEach(add => headers.push(`ADD ${add}`));
        } else {
            cylList.forEach(cyl => headers.push(cyl));
        }

        const tableRows = matrixRows.map(row => {
            const rowKey = hasActualAdd ? `${activeEye}_${row.sph}_${row.cyl}` : `${activeEye}_${row.sph}`;
            const rowData = matrixData[rowKey] || {};
            const tableRow = [activeEye, row.sph];
            if (hasActualAdd) tableRow.push(row.cyl);
            tableRow.push(rowData.axis || "-");

            if (hasActualAdd) {
                addList.forEach(add => {
                    const qty = rowData.adds?.[add]?.qty || 0;
                    tableRow.push(qty > 0 ? qty : "-");
                });
            } else {
                cylList.forEach(cyl => {
                    const qty = rowData.cyls?.[cyl]?.qty || 0;
                    tableRow.push(qty > 0 ? qty : "-");
                });
            }
            return tableRow;
        });

        autoTable(doc, {
            head: [headers],
            body: tableRows,
            startY: 140,
            styles: { fontSize: 8, cellPadding: 3, halign: 'center' },
            headStyles: { fillColor: [44, 62, 80], textColor: [255, 255, 255], fontStyle: 'bold' },
            alternateRowStyles: { fillColor: [245, 245, 245] },
            margin: { left: 40, right: 40 },
        });

        // Summary Footer
        const finalY = doc.lastAutoTable.finalY + 30;
        
        const summaryData = Object.values(matrixData).reduce((acc, row) => {
            const cells = hasActualAdd ? Object.values(row.adds || {}) : Object.values(row.cyls || {});
            const rowQty = cells.reduce((sum, v) => sum + (parseFloat(v.qty) || 0), 0);
            const rowItems = cells.filter(v => (parseFloat(v.qty) || 0) > 0).length;
            
            return {
                items: acc.items + rowItems,
                qty: acc.qty + rowQty,
                value: acc.value + (rowQty * (parseFloat(row.price) || 0))
            };
        }, { items: 0, qty: 0, value: 0 });

        const { items: totalItems, qty: totalQty } = summaryData;

        doc.setFontSize(10);
        doc.setTextColor(40);
        doc.setFont(undefined, 'bold');
        doc.text(`SUMMARY`, 40, finalY);
        doc.setFont(undefined, 'normal');
        doc.text(`Total Items: ${totalItems}`, 40, finalY + 15);
        doc.text(`Total Quantity: ${totalQty}`, 40, finalY + 30);

        doc.save(`${actualPdfTitle.replace(/ /g, "_")}_${activeEye}.pdf`);
    };

    if (!isOpen) return null;

    const renderStatusCell = (row, idx, colIdx) => {
        const rowKey = hasActualAdd ? `${activeEye}_${row.sph}_${row.cyl}` : `${activeEye}_${row.sph}`;
        const rowData = matrixData[rowKey];
        if (!rowData) return null;

        const colDef = columns.find(c => c.key === 'itemStatus' || c.key === 'status');

        if (colDef && colDef.render) {
            return colDef.render(
                { ...rowData.itemRef, itemStatus: rowData.status, status: rowData.status },
                (val) => handleRowPropChange(row.sph, row.cyl, "status", val)
            );
        }

        return (
            <select
                value={rowData.status}
                onChange={e => handleRowPropChange(row.sph, row.cyl, "status", e.target.value)}
                className="w-full h-8 text-center bg-transparent border border-transparent hover:border-slate-200 focus:bg-white focus:border-blue-400 rounded outline-none text-xs"
            >
                {["Pending", "Ordered", "Received", "Delivered", "Cancelled"].map(s => (
                    <option key={s} value={s}>{s}</option>
                ))}
            </select>
        );
    };

    return (
        <div className="fixed inset-0 bg-black/60 backdrop-blur-sm z-[100] flex items-center justify-center p-4">
            <div className="bg-white rounded-2xl shadow-2xl w-full max-w-7xl h-[90vh] flex flex-col overflow-hidden animate-in fade-in zoom-in-95 duration-200 text-slate-800">
                <div className="bg-slate-900 text-white px-6 py-4 flex justify-between items-center shrink-0">
                    <div>
                        <h2 className="text-xl font-bold flex items-center gap-2">
                            <Filter className="w-5 h-5 text-blue-400" />
                            {title}
                        </h2>
                        <p className="text-slate-400 text-xs mt-0.5">{items[0]?.itemName || "Lens Matrix"}</p>
                    </div>
                    <div className="flex items-center gap-3">
                        <button
                            onClick={handleDownloadPDF}
                            className="flex items-center gap-2 px-3 py-1.5 bg-blue-600 hover:bg-blue-700 text-white text-xs font-bold rounded-lg transition-all shadow-lg active:scale-95"
                            title="Download Matrix as PDF"
                        >
                            <FileDown className="w-4 h-4" />
                            Download PDF
                        </button>
                        <button onClick={onClose} className="p-2 hover:bg-white/10 rounded-full transition-colors"><X className="w-6 h-6" /></button>
                    </div>
                </div>

                <div className="p-4 bg-slate-50 border-b border-slate-200 shrink-0 flex items-center justify-between">
                    <div className="flex items-center gap-4">
                        <span className="text-[10px] font-bold text-slate-500 uppercase">Select Eye:</span>
                        <div className="flex bg-white border border-slate-200 rounded-lg p-0.5">
                            {(availableEyes.length ? availableEyes : ["RL"]).map(e => (
                                <button
                                    key={e}
                                    onClick={() => setActiveEye(e)}
                                    className={`px-4 py-1 text-xs font-bold rounded-md transition-all ${activeEye === e ? "bg-slate-800 text-white shadow-sm" : "text-slate-500 hover:bg-slate-100"}`}
                                >
                                    {e}
                                </button>
                            ))}
                        </div>
                    </div>
                    <div className="text-xs font-bold text-slate-500 uppercase">Matrix Grid View</div>
                </div>

                <div className="flex-1 overflow-auto bg-slate-100 p-4">
                    <div className="bg-white border border-slate-200 rounded-lg shadow-sm overflow-hidden min-w-fit">
                        <table className="w-full border-collapse text-sm">
                            <thead className="sticky top-0 z-20 bg-slate-50 text-slate-600 shadow-sm">
                                <tr>
                                    <th className="px-3 py-2 border-b border-r border-slate-200 w-20 text-center font-bold bg-slate-100">SPH</th>
                                    {hasActualAdd && <th className="px-3 py-2 border-b border-r border-slate-200 w-20 text-center font-bold bg-slate-100">CYL</th>}
                                    <th className="px-3 py-2 border-b border-r border-slate-200 w-24 text-center font-bold bg-slate-100">AXIS</th>
                                    <th className="px-3 py-2 border-b border-r border-slate-200 w-28 text-center font-bold bg-slate-100">PRICE</th>
                                    <th className="px-3 py-2 border-b border-r border-slate-200 w-32 text-center font-bold bg-slate-100">STATUS</th>
                                    {hasActualAdd ? addList.map(add => (
                                        <th key={add} className="px-3 py-2 border-b border-r border-slate-200 min-w-[80px] text-center font-bold">ADD {add}</th>
                                    )) : cylList.map(cyl => (
                                        <th key={cyl} className="px-3 py-2 border-b border-r border-slate-200 min-w-[80px] text-center font-bold">{cyl}</th>
                                    ))}
                                </tr>
                            </thead>
                            <tbody className="divide-y divide-slate-100">
                                {matrixRows.map((row, idx) => {
                                    const rowKey = hasActualAdd ? `${activeEye}_${row.sph}_${row.cyl}` : `${activeEye}_${row.sph}`;
                                    const rowData = matrixData[rowKey] || { axis: "", price: 0, status: "Pending", adds: {}, cyls: {} };
                                    
                                    const leftColBase = hasActualAdd ? 1 : 0;

                                    return (
                                        <tr key={rowKey} className="hover:bg-blue-50/30 transition-colors group">
                                            <td className="px-3 py-2 border-r border-slate-100 text-center font-bold text-slate-700 bg-slate-50/50">{row.sph}</td>
                                            {hasActualAdd && <td className="px-3 py-2 border-r border-slate-100 text-center font-bold text-slate-700 bg-slate-50/50">{row.cyl}</td>}
                                            <td className="p-1 border-r border-slate-100">
                                                <input
                                                    type="text"
                                                    value={rowData.axis}
                                                    onChange={e => handleRowPropChange(row.sph, row.cyl, "axis", e.target.value)}
                                                    onKeyDown={e => handleMatrixKeyDown(e, idx, leftColBase, matrixRows.length)}
                                                    data-matrix-input data-row={idx} data-col={leftColBase}
                                                    className="w-full h-8 text-center bg-transparent border border-transparent hover:border-slate-200 focus:bg-white focus:border-blue-400 rounded outline-none text-xs font-semibold"
                                                />
                                            </td>
                                            <td className="p-1 border-r border-slate-100">
                                                <input
                                                    type="number"
                                                    value={rowData.price}
                                                    onChange={e => handleRowPropChange(row.sph, row.cyl, "price", e.target.value)}
                                                    onKeyDown={e => handleMatrixKeyDown(e, idx, leftColBase + 1, matrixRows.length)}
                                                    data-matrix-input data-row={idx} data-col={leftColBase + 1}
                                                    className="w-full h-8 text-center bg-transparent border border-transparent hover:border-slate-200 focus:bg-white focus:border-blue-400 rounded outline-none text-xs font-semibold"
                                                />
                                            </td>
                                            <td className="p-1 border-r border-slate-100 text-center">{renderStatusCell(row, idx, leftColBase + 2)}</td>
                                            {hasActualAdd ? addList.map((add, addIdx) => {
                                                const addData = rowData.adds[add] || { qty: "" };
                                                return (
                                                    <td key={add} className="p-1 border-r border-slate-100">
                                                        <input
                                                            type="number" min="0" placeholder="-"
                                                            value={addData.qty || ""}
                                                            onChange={e => handleQtyChange(row.sph, row.cyl, add, e.target.value)}
                                                            onKeyDown={e => handleMatrixKeyDown(e, idx, leftColBase + 3 + addIdx, matrixRows.length)}
                                                            data-matrix-input data-row={idx} data-col={leftColBase + 3 + addIdx}
                                                            className={`w-full h-8 text-center text-xs font-bold outline-none rounded transition-all focus:ring-2 focus:ring-blue-500/20 ${addData.qty > 0 ? "bg-blue-100 text-blue-700" : "bg-transparent hover:bg-slate-50"}`}
                                                        />
                                                    </td>
                                                );
                                            }) : cylList.map((cyl, cylIdx) => {
                                                const cylData = rowData.cyls[cyl] || { qty: "" };
                                                return (
                                                    <td key={cyl} className="p-1 border-r border-slate-100">
                                                        <input
                                                            type="number" min="0" placeholder="-"
                                                            value={cylData.qty || ""}
                                                            onChange={e => handleQtyChange(row.sph, null, cyl, e.target.value)}
                                                            onKeyDown={e => handleMatrixKeyDown(e, idx, leftColBase + 3 + cylIdx, matrixRows.length)}
                                                            data-matrix-input data-row={idx} data-col={leftColBase + 3 + cylIdx}
                                                            className={`w-full h-8 text-center text-xs font-bold outline-none rounded transition-all focus:ring-2 focus:ring-blue-500/20 ${cylData.qty > 0 ? "bg-blue-100 text-blue-700" : "bg-transparent hover:bg-slate-50"}`}
                                                        />
                                                    </td>
                                                );
                                            })}
                                        </tr>
                                    );
                                })}
                            </tbody>
                        </table>
                    </div>
                </div>

                <div className="p-4 bg-white border-t border-slate-200 flex justify-between items-center shrink-0 shadow-lg">
                    <div className="flex gap-6 text-sm font-medium text-slate-600">
                        <div className="flex items-center gap-2"><span>Total Items:</span><span className="font-bold text-slate-900">{summary.items}</span></div>
                        <div className="flex items-center gap-2"><span>Total Qty:</span><span className="font-bold text-slate-900">{summary.qty}</span></div>
                        <div className="flex items-center gap-2"><span>Net Value:</span><span className="font-bold text-emerald-600">₹{summary.value.toFixed(2)}</span></div>
                    </div>
                    <div className="flex gap-3">
                        <button onClick={onClose} className="px-4 py-2 border border-slate-300 text-slate-700 rounded-lg hover:bg-slate-50 font-bold text-sm transition-all" disabled={loading}>Cancel</button>
                        <button onClick={handleSaveClick} className="px-6 py-2 bg-gradient-to-r from-blue-600 to-indigo-600 text-white rounded-lg shadow-lg hover:shadow-blue-500/30 flex items-center gap-2 font-bold text-sm tracking-wide active:scale-95 transition-all disabled:opacity-50" disabled={loading}>
                            <Save className="w-4 h-4" /> {loading ? "Saving..." : "Save Changes"}
                        </button>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default ItemsMatrixViewModal;
