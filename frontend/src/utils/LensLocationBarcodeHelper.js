/**
 * LensLocationBarcodeHelper.js
 * Optimized for Thermal Barcode Printers (100mm x 100mm)
 * Version: Balanced Layout with Top Clearance
 */
import QRCode from 'qrcode';

export const printLensLocationBarcodes = async (formData, matrix, matrixData, locationMap) => {
  // 1. Group data by Box Number
  const boxGroups = {};

  matrix.rows.forEach(row => {
    matrix.addValues.forEach(add => {
      const cellKey = `${row.sph}_${row.cyl}_${row.eye}_${add}`;
      const qty = matrixData[cellKey];
      const locations = locationMap[cellKey] || [];

      if (qty && Number(qty) > 0 && locations.length > 0) {
        locations.forEach(loc => {
          const boxNo = loc.box || "-";
          if (boxNo === "-" || boxNo === "undefined") return;

          if (!boxGroups[boxNo]) {
            boxGroups[boxNo] = {
              boxNo: boxNo,
              items: []
            };
          }

          boxGroups[boxNo].items.push({
            eye: row.eye,
            sph: row.sph.toFixed(2),
            cyl: row.cyl.toFixed(2),
            axis: formData.axis || "0",
            add: `+${add.toFixed(2)}`,
            qty: qty
          });
        });
      }
    });
  });

  const boxes = Object.values(boxGroups);

  if (boxes.length === 0) {
    return { success: false, message: "No boxes found with quantities to print." };
  }

  // 2. Pre-generate QR Data URLs for all boxes
  const boxDataWithQR = await Promise.all(boxes.map(async (box) => {
    // FORMAT VERIFICATION: Ensure data types match expected fetch logic (Numbers where required)
    const qrPayload = JSON.stringify({
      item: formData.productName,
      group: formData.groupName,
      boxNo: box.boxNo,
      lenses: box.items.map(it => ({
        eye: it.eye,
        sph: parseFloat(it.sph),
        cyl: parseFloat(it.cyl),
        axis: parseInt(it.axis) || 0,
        add: parseFloat(it.add.replace("+", ""))
      }))
    });

    try {
      const qrDataUrl = await QRCode.toDataURL(qrPayload, {
        margin: 1,
        width: 200, // Slightly larger for better scannability
        errorCorrectionLevel: 'H' // High error correction for thermal printer noise
      });
      return { ...box, qrDataUrl };
    } catch (err) {
      console.error("QR Generation Error:", err);
      return { ...box, qrDataUrl: "" };
    }
  }));

  const printWindow = window.open("", "_blank");
  const currentDate = new Date().toLocaleDateString("en-GB");

  printWindow.document.write(`
    <html>
      <head>
        <title>Box Barcodes - ${formData.productName}</title>
        <style>
          @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap');
          
          @page {
            size: 100mm 100mm;
            margin: 0;
          }
          
          * {
            box-sizing: border-box;
          }

          body {
            margin: 0;
            padding: 0;
            font-family: 'Inter', sans-serif;
            background: white;
            -webkit-print-color-adjust: exact;
          }

          .sticker {
            width: 100mm;
            height: 100mm;
            padding: 10mm 6mm 6mm 6mm; /* LEAVE SPACE FROM TOP (10mm) */
            position: relative;
            page-break-after: always;
            overflow: hidden;
            display: flex;
            flex-direction: column;
          }

          /* Header Styles */
          .header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 5mm;
          }
          
          .header-info {
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 3mm;
          }
          
          .header-row {
            display: flex;
            gap: 6mm;
            align-items: baseline;
          }
          
          .field {
            display: flex;
            gap: 1.5mm;
            align-items: baseline;
          }
          
          .label {
            font-weight: 700;
            color: #444;
            font-size: 11px;
          }
          
          .value {
            font-weight: 600;
            color: #000;
            font-size: 12px;
          }

          .item-name {
            font-size: 16px;
            font-weight: 800;
            letter-spacing: -0.3px;
          }

          .qr-container {
            width: 35mm;
            height: 35mm;
            display: flex;
            justify-content: flex-end;
            margin-top: -3mm; /* Pull up slightly to align with item name */
          }
          
          .qr-image {
            width: 35mm;
            height: 35mm;
            object-fit: contain;
          }

          /* Table Styles */
          .table-container {
            width: 100%;
            flex: 1;
            margin-top: 2mm;
          }
          
          table {
            width: 100%;
            border-collapse: collapse;
          }
          
          th {
            border: 1.5pt solid black;
            padding: 5px;
            background: #f0f0f0;
            font-weight: 800;
            font-size: 11px;
            text-transform: uppercase;
          }
          
          td {
            border: 1pt solid black;
            padding: 8px 5px;
            text-align: center;
            font-weight: 600;
            font-size: 12px;
          }

          .box-no-cell {
            font-weight: 800;
            font-size: 14px;
            background: #fafafa;
          }

          /* Footer Styles */
          .footer {
            margin-top: 4mm;
            border-top: 2pt solid black;
            padding-top: 3mm;
            display: flex;
            justify-content: flex-end;
          }
          
          .box-id-footer {
            font-weight: 800;
            font-size: 15px;
            color: #000;
          }
        </style>
      </head>
      <body>
        ${boxDataWithQR.map(box => `
          <div class="sticker">
            <div class="header">
              <div class="header-info">
                <!-- Row 1: Item Only -->
                <div class="header-row">
                  <div class="field">
                    <span class="label">Item:</span>
                    <span class="value item-name">${formData.productName}</span>
                  </div>
                </div>
                <!-- Row 2: Date -->
                <div class="header-row">
                  <div class="field">
                    <span class="label">Date:</span>
                    <span class="value">${currentDate}</span>
                  </div>
                </div>
              </div>
              <div class="qr-container">
                ${box.qrDataUrl ? `<img src="${box.qrDataUrl}" class="qr-image" />` : '<div style="font-size:8px">QR Error</div>'}
              </div>
            </div>

            <div class="table-container">
              <table>
                <thead>
                  <tr>
                    <th>EYE</th>
                    <th>SPH</th>
                    <th>CYL</th>
                    <th>AXIS</th>
                    <th>ADD</th>
                    <th>BOX NO</th>
                  </tr>
                </thead>
                <tbody>
                  ${box.items.slice(0, 15).map(it => `
                    <tr>
                      <td>${it.eye}</td>
                      <td>${it.sph}</td>
                      <td>${it.cyl}</td>
                      <td>${it.axis}</td>
                      <td>${it.add}</td>
                      <td class="box-no-cell">${box.boxNo}</td>
                    </tr>
                  `).join("")}
                </tbody>
              </table>
            </div>

            <div class="footer">
              <div class="box-id-footer">Box ID: ${box.boxNo}</div>
            </div>
          </div>
        `).join("")}

        <script>
          window.onload = function() {
            setTimeout(() => {
              window.print();
            }, 500);
          };
        </script>
      </body>
    </html>
  `);
  
  printWindow.document.close();
  return { success: true };
};
