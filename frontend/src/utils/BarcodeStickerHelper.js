/**
 * Standardized Barcode Sticker Helper
 * Generates HTML for 70mm x 35mm barcode stickers
 */

export const generateStandardBarcodeStickerHTML = (transaction, allLenses = [], allItems = [], isPurchase = false) => {
  const partyName = (transaction?.partyData?.partyAccount || "Unknown Party").toUpperCase();
  const orderNo = transaction?.billData?.billNo || "-";
  
  // Format Date to DDMMYY (for purchase stickers)
  const formatDateDDMMYY = (dateStr) => {
    if (!dateStr) return "-";
    const date = new Date(dateStr);
    if (isNaN(date.getTime())) return "-";
    const day = String(date.getDate()).padStart(2, '0');
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const year = String(date.getFullYear()).slice(-2);
    return `${day}${month}${year}`;
  };

  // Standard Format Date to DD-MM-YYYY
  const formatDate = (dateStr) => {
    if (!dateStr) return "-";
    const date = new Date(dateStr);
    if (isNaN(date.getTime())) return "-";
    const day = String(date.getDate()).padStart(2, '0');
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const year = date.getFullYear();
    return `${day}-${month}-${year}`;
  };

  const orderDate = formatDate(transaction?.billData?.date || transaction?.createdAt);

  const getPrintItemName = (item) => {
    if (item.billItemName && item.billItemName.trim() !== "") return item.billItemName;
    const foundLens = (allLenses || []).find(l =>
      String(l.productName || "").toLowerCase() === String(item.itemName || "").toLowerCase()
    );
    if (foundLens?.billItemName) return foundLens.billItemName;
    const foundItem = (allItems || []).find(i =>
      String(i.itemName || "").toLowerCase() === String(item.itemName || "").toLowerCase()
    );
    if (foundItem?.billItemName) return foundItem.billItemName;
    return item.itemName || "-";
  };

  const stickersHTML = (transaction.items || [])
    .filter(item => (Number(item.qty) || 0) > 0)
    .map((item, i) => {
      const itemName = getPrintItemName(item);
      const barcodeNo = item.barcode || "0000000";
      const eyeValue = item.eye || "";
      const qrData = isPurchase ? barcodeNo : (item.barcode || itemName);
      const partyNameHTML = isPurchase ? "" : `<div class="party-name">${partyName}</div>`;
      
      const purchaseFooter = `
        <div class="footer-row" style="justify-content: center; gap: 8mm;">
          <div>${orderNo}</div>
          <div>${formatDateDDMMYY(transaction?.billData?.date || transaction?.createdAt)}</div>
        </div>
      `;

      const standardFooter = `
        <div class="footer-row">
          <div class="order-no">Order : ${orderNo}</div>
          <div class="date-val">Date : ${orderDate}</div>
        </div>
      `;

      return `
        <div class="sticker-container">
          <!-- Left Section: Eye, QR, Barcode No -->
          <div class="left-section">
            <div class="qr-container" style="margin-top: 4mm;">
              <img src="https://api.qrserver.com/v1/create-qr-code/?data=${encodeURIComponent(qrData)}&size=80x80" alt="QR" />
            </div>
            <div class="barcode-no">${barcodeNo}</div>
          </div>
          
          <!-- Right Section: Party, Item, Power, Footer -->
          <div class="right-section ${isPurchase ? 'purchase-mode' : ''}">
            ${partyNameHTML}
            <div class="item-name">${itemName}</div>
            <table class="power-table">
              <thead>
                <tr>
                  <th>EYE</th>
                  <th>SPH</th>
                  <th>CYL</th>
                  <th>AXIS</th>
                  <th>ADD</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>${eyeValue}</td>
                  <td>${item.sph || "0.00"}</td>
                  <td>${item.cyl || "0.00"}</td>
                  <td>${item.axis || "0"}</td>
                  <td>${item.add || "0.00"}</td>
                </tr>
              </tbody>
            </table>
            ${isPurchase ? purchaseFooter : standardFooter}
          </div>
        </div>
      `;
    })
    .join("");

  return `
    <html>
      <head>
        <title>Barcode stickers (70x35mm)</title>
        <style>
          @page {
            size: 70mm 35mm;
            margin: 0;
          }
          body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #fff;
          }
          .sticker-container {
            width: 70mm;
            height: 35mm;
            padding: 2.5mm 3.5mm; /* Increased padding */
            box-sizing: border-box;
            display: flex;
            page-break-after: always;
            position: relative;
            overflow: hidden;
          }
          .left-section {
            width: 20mm;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: space-between;
            padding-right: 2mm;
            border-right: 0.1mm solid #ddd;
          }
          .qr-container {
            width: 17mm;
            height: 17mm;
            display: flex;
            align-items: center;
            justify-content: center;
          }
          .qr-container img {
            width: 16mm;
            height: 16mm;
          }
          .barcode-no {
            font-size: 7.5pt;
            font-weight: 800;
            text-align: center;
            overflow: hidden;
            white-space: nowrap;
            margin-bottom: 2mm;
          }
          .right-section {
            flex: 1;
            padding-left: 3.5mm;
            display: flex;
            flex-direction: column;
            justify-content: flex-start; /* Start from top to avoid clipping */
            gap: 1.5mm; /* Consistent spacing */
          }
          .party-name {
            font-size: 9.5pt;
            font-weight: 900;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            color: #000;
            line-height: 1.3;
          }
          .item-name {
            font-size: 10pt;
            font-weight: 700;
            line-height: 1.2;
            color: #222;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
          }
          .power-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1mm;
          }
          .power-table th {
            background: #000;
            color: white;
            font-weight: 900;
            padding: 0.8mm 0.5mm;
            text-align: center;
            font-size: 6.5pt;
            border: 0.2mm solid #000;
          }
          .power-table td {
            border: 0.2mm solid #000;
            text-align: center;
            font-weight: 950;
            padding: 1.2mm 0.5mm;
            color: #000;
            font-size: 8.5pt;
          }
          .footer-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 8pt;
            font-weight: 800;
            margin-top: auto; /* Push to bottom */
            border-top: 0.2mm solid #ccc;
            padding-top: 1.5mm;
          }
          
          /* Purchase Mode Adjustments */
          .purchase-mode {
            padding-top: 0.5mm;
          }
        </style>
      </head>
      <body>
        ${stickersHTML}
        <script>
          window.onload = function() {
            setTimeout(() => {
              window.print();
              window.close();
            }, 500);
          };
        </script>
      </body>
    </html>
  `;
};

export const printBarcodeStickers = (transaction, allLenses = [], allItems = [], isPurchase = false) => {
  const html = generateStandardBarcodeStickerHTML(transaction, allLenses, allItems, isPurchase);
  const printWindow = window.open("", "_blank", "width=800,height=600");
  if (printWindow) {
    printWindow.document.write(html);
    printWindow.document.close();
  }
};
