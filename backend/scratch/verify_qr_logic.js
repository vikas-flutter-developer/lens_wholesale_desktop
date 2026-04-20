import mongoose from 'mongoose';
import dotenv from 'dotenv';
import path from 'path';
import { fileURLToPath } from 'url';

// Mocking models for logic testing if needed, or connecting to DB
// Since we want to test the parsing and lookup logic flow, we can just simulate the function behavior.

const resolveModelMock = (orderType) => {
  switch ((orderType || "").toLowerCase()) {
    case "challan": return "LensSaleChallan";
    case "lens": return "LensSale";
    case "rx": return "RxSale";
    default: return null;
  }
};

const simulateLookup = async (qrData, orderType) => {
    console.log(`\n--- Simulating Lookup for: "${qrData}" (Type: ${orderType || 'None'}) ---`);
    
    // 1. Sanitization & JSON Parsing
    let processedQrData = (qrData || "").trim();
    let extractedIdFromJSON = null;
    let extractedTypeFromJSON = null;

    if (processedQrData.startsWith("{") && processedQrData.endsWith("}")) {
      try {
        const parsed = JSON.parse(processedQrData);
        if (parsed.orderId) extractedIdFromJSON = parsed.orderId;
        if (parsed.orderType) extractedTypeFromJSON = parsed.orderType;
        console.log("JSON Detected:", parsed);
      } catch (e) {
        console.warn("QR JSON Parse Error:", e.message);
      }
    }

    const effectiveLookupVal = extractedIdFromJSON || processedQrData;
    const isObjectId = mongoose.Types.ObjectId.isValid(effectiveLookupVal);
    const finalOrderType = extractedTypeFromJSON || orderType;

    console.log("Effective Lookup Value:", effectiveLookupVal);
    console.log("Is ObjectId:", isObjectId);
    console.log("Effective Order Type:", finalOrderType);

    const checkLogic = (modelName) => {
        console.log(`Checking in Model [${modelName}]:`);
        if (isObjectId) {
            console.log(`  - Direct ID Match check for: ${effectiveLookupVal}`);
        }
        console.log(`  - Raw billNo Match check for: ${effectiveLookupVal}`);
        
        if (effectiveLookupVal.includes("-")) {
            const lastHyphenIndex = effectiveLookupVal.lastIndexOf("-");
            const series = effectiveLookupVal.substring(0, lastHyphenIndex).trim();
            const no = effectiveLookupVal.substring(lastHyphenIndex + 1).trim();
            console.log(`  - Hyphen Split Match (lastIndexOf): series="${series}", no="${no}"`);
        }
    };

    if (finalOrderType) {
        const modelName = resolveModelMock(finalOrderType);
        if (modelName) checkLogic(modelName);
    } else {
        ["LensSaleChallan", "LensSale", "RxSale"].forEach(checkLogic);
    }
};

// Test Cases
async function runTests() {
    // 1. Raw Bill Number
    await simulateLookup("29");

    // 2. Combined Series-Number
    await simulateLookup("S-29");

    // 3. Complex Series (from user example)
    await simulateLookup("S(26-27)-29");

    // 4. JSON QR (Challan)
    await simulateLookup('{"orderId": "65f1a2b3c4d5e6f7a8b9c0d1", "orderType": "challan"}');

    // 5. JSON QR (Lens Invoice)
    await simulateLookup('{"orderId": "65f1a2b3c4d5e6f7a8b9c0d2", "orderType": "lens"}');
}

runTests();
