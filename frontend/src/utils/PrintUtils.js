import { roundAmount } from "./amountUtils";

export const generateBulkPrint = (title, items, visibleColumns, ALL_COLUMNS) => {
  const printWindow = window.open("", "_blank");
  
  const formatDate = (dateString) => {
    if (!dateString) return "-";
    const date = new Date(dateString);
    if (isNaN(date.getTime())) return "-";
    return date.toLocaleDateString("en-GB");
  };

  const getLabel = (id) => {
    const col = ALL_COLUMNS.find(c => c.id === id);
    return col ? col.label : id;
  };

  const activeCols = Object.keys(visibleColumns).filter(id => visibleColumns[id]);

  const tableHeader = activeCols
    .map(id => `<th style="background-color: #f1f5f9; border: 1px solid #94a3b8; padding: 8px; text-align: center; font-size: 11px; font-weight: bold; text-transform: uppercase;">${getLabel(id)}</th>`)
    .join("");

  const tableRows = items.map((item, index) => {
    let rowHtml = "<tr>";
    activeCols.forEach(id => {
      let val = item[id] || "-";
      let style = "border: 1px solid #94a3b8; padding: 6px; font-size: 11px;";
      let align = "center";

      if (id === "srNo" || id === "Sr") val = index + 1;
      if (id === "billDate" || id === "date") val = formatDate(val);
      if (id === "netAmt" || id === "netAmount") {
        val = `₹${roundAmount(val)}`;
        align = "right";
      }
      if (id === "partyName") align = "left";

      rowHtml += `<td style="${style} text-align: ${align};">${val}</td>`;
    });
    rowHtml += "</tr>";
    return rowHtml;
  }).join("");

  printWindow.document.write(`
    <html>
      <head>
        <title>${title}</title>
        <style>
          body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; padding: 20px; color: #1e293b; }
          h1 { text-align: center; color: #0f172a; margin-bottom: 20px; font-size: 24px; font-weight: 800; text-transform: uppercase; letter-spacing: 1px; }
          table { width: 100%; border-collapse: collapse; margin-top: 10px; }
          th, td { border: 1px solid #94a3b8; padding: 8px; }
          tr:nth-child(even) { background-color: #f8fafc; }
          @media print {
            @page { margin: 1cm; }
            body { padding: 0; }
            h1 { margin-top: 0; }
          }
        </style>
      </head>
      <body>
        <h1>${title}</h1>
        <table>
          <thead>
            <tr>${tableHeader}</tr>
          </thead>
          <tbody>
            ${tableRows}
          </tbody>
        </table>
        <div style="margin-top: 20px; text-align: right; font-size: 12px; color: #64748b;">
          Printed on: ${new Date().toLocaleString("en-GB")}
        </div>
      </body>
    </html>
  `);
  printWindow.document.close();
  setTimeout(() => {
    printWindow.print();
  }, 500);
};

export const handleExportToExcel = (XLSX, fileName, items, visibleColumns, ALL_COLUMNS) => {
    const formatDate = (dateString) => {
        if (!dateString) return "-";
        const date = new Date(dateString);
        if (isNaN(date.getTime())) return "-";
        return date.toLocaleDateString("en-GB");
    };

    const getLabel = (id) => {
        const col = ALL_COLUMNS.find(c => c.id === id);
        return col ? col.label : id;
    };

    const activeCols = Object.keys(visibleColumns).filter(id => visibleColumns[id]);

    const exportData = items.map((item, index) => {
        const row = {};
        activeCols.forEach(id => {
            let val = item[id] || "-";
            if (id === "srNo" || id === "Sr") val = index + 1;
            if (id === "billDate" || id === "date") val = formatDate(val);
            if (id === "netAmt" || id === "netAmount") val = roundAmount(val);
            row[getLabel(id)] = val;
        });
        return row;
    });

    const worksheet = XLSX.utils.json_to_sheet(exportData);
    const workbook = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(workbook, worksheet, "Sheet1");
    XLSX.writeFile(workbook, `${fileName}.xlsx`);
};
