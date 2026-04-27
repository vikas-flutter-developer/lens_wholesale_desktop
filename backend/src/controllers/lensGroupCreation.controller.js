import LensGroup from "../models/LensGroup.js";
import Item from "../models/Item.js";
import PowerRangeLibrary from "../models/PowerRangeLibrary.js";
import LensPurchase from "../models/LensPurchase.js";
import mongoose from "mongoose";

const escapeRegex = (string) => {
  if (!string) return "";
  return string.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
};

// Helper to save range to library
const saveToRangeLibrary = async (req, range) => {
  try {
    const { sphMin, sphMax, cylMin, cylMax, addMin, addMax, axis, label } = range;
    const companyId = req.user?.companyId || null;
    const queryCompanyId = (companyId && mongoose.Types.ObjectId.isValid(companyId)) 
      ? new mongoose.Types.ObjectId(companyId) 
      : companyId;

    const rawGroupName = (req.body.groupName || req.query.groupName);
    const gName = rawGroupName ? rawGroupName.trim() : null;

    if (!gName) {
      console.log("[saveToRangeLibrary] SKIPPED: No groupName provided for isolation");
      return;
    }

    // Check if exactly this range exists for this SPECIFIC group and company
    const existing = await PowerRangeLibrary.findOne({
      companyId: queryCompanyId,
      groupName: gName,
      sphMin, sphMax,
      cylMin, cylMax,
      addMin, addMax,
      axis: axis || 0
    });

    if (!existing) {
      await PowerRangeLibrary.create({
        companyId: queryCompanyId,
        groupName: gName,
        sphMin, sphMax,
        cylMin, cylMax,
        addMin, addMax,
        axis: axis || 0,
        label
      });
      console.log(`[saveToRangeLibrary] SUCCESS: Created NEW isolated range library entry for "${label}" under group "${gName}"`);
    } else {
      console.log(`[saveToRangeLibrary] SKIPPED: Range already exists in library for group "${gName}"`);
    }
  } catch (err) {
    console.error("Error saving to PowerRangeLibrary:", err);
  }
};

async function syncLensGroupToItems(lensGroup) {
  if (!lensGroup || !lensGroup.addGroups) return;

  const ops = [];
  lensGroup.addGroups.forEach(ag => {
    (ag.combinations || []).forEach(comb => {
      if (comb.barcode) {
        // Fallback to group prices if combination-specific prices are 0 or missing
        const pPrice = (comb.pPrice && comb.pPrice !== 0) ? comb.pPrice : (lensGroup.purchasePrice || 0);
        const sPrice = (comb.sPrice && comb.sPrice !== 0) ? comb.sPrice : (lensGroup.salePrice?.default || 0);

        ops.push({
          updateOne: {
            filter: { barcode: comb.barcode },
            update: { $set: { purchasePrice: pPrice, salePrice: sPrice } }
          }
        });
      }
    });
  });

  if (ops.length > 0) {
    await Item.bulkWrite(ops);
  }
}

// safe number parser
const parseNum = (v) => {
  const n = parseFloat(v);
  return isNaN(n) ? 0 : n;
};

// Normalize eye value to handle all variations
const normalizeEyeValue = (eyeVal) => {
  let normalized = String(eyeVal || "").trim().toUpperCase();
  // Convert all dual-eye formats to single letter or "BOTH"
  if (normalized === "RL" || normalized === "R/L" || normalized === "BOTH_RL") {
    normalized = "BOTH";
  }
  if (normalized === "") {
    normalized = "BOTH";
  }
  // For comparisons, we need R, L individually
  // But normalize containers treat them specially
  return normalized;
};

// Check if eye values are equivalent (for deduplication)
const eyeValuesMatch = (eye1, eye2) => {
  const n1 = normalizeEyeValue(eye1);
  const n2 = normalizeEyeValue(eye2);
  
  // If either is BOTH (dual-eye), match with any individual eye
  if (n1 === "BOTH" || n2 === "BOTH") {
    return true; // BOTH matches any R or L
  }
  // Otherwise exact match
  return n1 === n2;
};

// RANGE GENERATOR
const createRange = (min, max, step) => {
  const list = [];
  min = parseNum(min);
  max = parseNum(max);
  step = parseNum(step);

  if (step === 0) return [parseFloat(min.toFixed(2))];

  let value = min;
  let safety = 0;

  // Ensure we include the max value even with floating point noise
  while (value <= (max + 0.000001) && safety < 2000) {
    list.push(parseFloat(value.toFixed(2)));
    value = parseFloat((value + step).toFixed(10));
    safety++;
  }

  return list;
};

const addLensPower = async (req, res) => {
  try {
    const {
      sphMin,
      sphMax,
      sphStep,

      cylMin,
      cylMax,
      cylStep,

      addMin,
      addMax,
      addStep,

      axis,
      eye,
      generateBarcodes, // Optional flag to generate barcodes
    } = req.body;

    const productName = req.body.productName?.trim();
    const groupName = req.body.groupName?.trim();

    const sphMinNum = parseNum(sphMin);
    const sphMaxNum = parseNum(sphMax);
    const sphStepNum = sphStep === "" ? 0.25 : parseNum(sphStep);

    const cylMinNum = parseNum(cylMin);
    const cylMaxNum = parseNum(cylMax);
    const cylStepNum = cylStep === "" ? 0.25 : parseNum(cylStep);

    const addMinNum = parseNum(addMin);
    const addMaxNum = parseNum(addMax);
    const addStepNum = addStep === "" ? 0.25 : parseNum(addStep);

    const axisNum = parseNum(axis);

    // NORMALIZE eye value using helper function
    const normalizedEye = normalizeEyeValue(eye);
    console.log(`[addLensPower] Normalized eye: "${eye}" → "${normalizedEye}"`);

    // ---------------------------------------------
    // 0) VALIDATION
    // ---------------------------------------------
    if (!productName) {
        return res.status(400).json({ success: false, message: "Product name is required" });
    }

    // ---------------------------------------------
    // 1) CASE-INSENSITIVE PRODUCT NAME CHECK
    // ---------------------------------------------
    const companyId = req.user?.companyId || null;
    
    // Convert companyId to ObjectId if it's a string, to ensure query matches indexed type
    const queryCompanyId = (companyId && mongoose.Types.ObjectId.isValid(companyId)) 
      ? new mongoose.Types.ObjectId(companyId) 
      : companyId;

    let lensGroup = await LensGroup.findOne({
      $or: [
        { companyId: queryCompanyId },
        { companyId: null }
      ],
      productName: { $regex: `^${escapeRegex(productName)}$`, $options: "i" }
    });

    const isExisting = !!lensGroup;

    // ---------------------------------------------
    // 2) AUTO DETECT VISION TYPE
    // ---------------------------------------------
    const visionType =
      addMinNum === 0 && addMaxNum === 0 ? "single" : "bifocal";

    // Generate lists
    const sphList = createRange(sphMinNum, sphMaxNum, sphStepNum);
    const cylList = createRange(cylMinNum, cylMaxNum, cylStepNum);
    const addList = createRange(addMinNum, addMaxNum, addStepNum);

    // ---------------------------------------------
    // 3) SAFETY GUARDS
    // ---------------------------------------------
    // Prevent infinite loops or massive memory consumption if step is 0
    if (sphStepNum <= 0 || cylStepNum <= 0 || (addList.length > 1 && addStepNum <= 0)) {
        return res.status(400).json({ 
            success: false, 
            message: "Step values must be greater than zero." 
        });
    }

    // Estimate total combinations to prevent 16MB document size limit hits
    const totalNewCombs = sphList.length * cylList.length * addList.length * ((eye === "BOTH" || eye === "BOTH_RL") ? 2 : 1);
    const COMBINATION_LIMIT = 10000;
    
    if (totalNewCombs > COMBINATION_LIMIT) {
        return res.status(400).json({
            success: false,
            message: `Requested range results in ${totalNewCombs.toLocaleString()} combinations, which exceeds the safety limit of ${COMBINATION_LIMIT.toLocaleString()}. Please reduce the range or increase the step size.`
        });
    }

    // ---------------------------------------------
    // 4) GENERATE ADD GROUPS + COMBINATIONS
    // ---------------------------------------------
    const newAddGroups = [];

    // LOCAL UNIQUENESS SET for the current batch only.
    // Key = "add_sph_cyl_eye_axis" — prevents duplicates within this generation run.
    // Intentionally does NOT check against other power groups so each group is independent.
    const batchUniqueSet = new Set();

    const currentAddGroups = isExisting ? lensGroup.addGroups : [];

    // New power group record
    const newPowerGroupRecord = {
      sphMin: sphMinNum,
      sphMax: sphMaxNum,
      sphStep: sphStepNum,
      cylMin: cylMinNum,
      cylMax: cylMaxNum,
      cylStep: cylStepNum,
      addMin: addMinNum,
      addMax: addMaxNum,
      addStep: addStepNum,
      axis: axisNum,
      eye: eye,
      label: `SPH(${sphMinNum} to ${sphMaxNum}) CYL(${cylMinNum} to ${cylMaxNum}) ADD(${addMinNum} to ${addMaxNum}) AXIS(${axisNum})`
    };

    // AUTO SAVE TO LIBRARY
    await saveToRangeLibrary(req, newPowerGroupRecord);

    let combinationsAdded = 0;
    let barcodeSeq = 0; // Sequential part of barcode for this batch

    // Batch generate barcodes if needed
    // Using a combination of prefix + timestamp + sequence + random to ensure uniqueness 
    // across the batch and globally without individual DB checks for every combination.
    const getNextBatchBarcode = () => {
      const prefix = (productName || "LNS").substring(0, 3).toUpperCase();
      const ts = Date.now().toString().slice(-6); // Last 6 digits of timestamp
      const seq = (barcodeSeq++).toString().padStart(4, '0');
      const rnd = Math.floor(Math.random() * 1000).toString().padStart(3, '0');
      return `${prefix}${ts}${seq}${rnd}`;
    };

    // For tracking which combinations belong to this power range
    let powerGroupId = null;

    if (isExisting) {
      // BACKFILL: If existing combinations don't have powerGroupId, assign them to the FIRST power group
      // This ensures legacy data is properly organized
      if (lensGroup.powerGroups.length > 0) {
        const firstPowerGroupId = lensGroup.powerGroups[0]._id;
        let backfilledCount = 0;
        lensGroup.addGroups.forEach(addGroup => {
          (addGroup.combinations || []).forEach(comb => {
            if (!comb.powerGroupId) {
              comb.powerGroupId = firstPowerGroupId;
              backfilledCount++;
            }
          });
        });
        if (backfilledCount > 0) {
          console.log(`[addLensPower] BACKFILLED ${backfilledCount} combinations with powerGroupId from first power group`);
        }
      }

      // Check if power group already exists (same exact ranges)
      const existingPowerGroup = lensGroup.powerGroups.find(pg =>
        pg.sphMin === sphMinNum && pg.sphMax === sphMaxNum && pg.sphStep === sphStepNum &&
        pg.cylMin === cylMinNum && pg.cylMax === cylMaxNum && pg.cylStep === cylStepNum &&
        pg.addMin === addMinNum && pg.addMax === addMaxNum && pg.addStep === addStepNum &&
        pg.axis === axisNum && pg.eye === eye
      );

      if (!existingPowerGroup) {
        // Create new power group record and capture its _id
        const newPG = lensGroup.powerGroups.create(newPowerGroupRecord);
        lensGroup.powerGroups.push(newPG);
        powerGroupId = newPG._id;
        console.log(`[addLensPower] ✅ CREATED NEW power group with ID: ${powerGroupId}, AXIS: ${axisNum}`);
        console.log(`[addLensPower] Total power groups now: ${lensGroup.powerGroups.length}`);
      } else {
        powerGroupId = existingPowerGroup._id;
        console.log(`[addLensPower] ⚠️ REUSING existing power group with ID: ${powerGroupId}, AXIS: ${axisNum}`);
      }
    } else {
      // For new lens groups, create power group and capture _id before saving
      // This will be done after document creation
    }

    // VERIFY powerGroupId is set before creating combinations
    if (!powerGroupId && isExisting) {
      console.error(`[addLensPower] ❌ ERROR: powerGroupId is not set for isExisting=${isExisting}. This will cause mixing!`);
      return res.status(400).json({
        success: false,
        message: "Failed to assign power group ID"
      });
    }

    // Collect all SPH×CYL×EYE×AXIS combinations that ALREADY belong to the NEW powerGroupId
    // (i.e. only if reusing an existing power group). This prevents re-adding on a second call.
    const existingPGCombs = new Set();
    if (powerGroupId && isExisting) {
      currentAddGroups.forEach(ag => {
        (ag.combinations || []).forEach(c => {
          const pgIdStr = c.powerGroupId ? c.powerGroupId.toString() : null;
          if (pgIdStr === powerGroupId.toString()) {
            const addKey = parseFloat(ag.addValue).toFixed(2);
            const cSph = parseFloat(c.sph).toFixed(2);
            const cCyl = parseFloat(c.cyl).toFixed(2);
            const cAxis = parseFloat(c.axis || 0).toFixed(2);
            const cEye = String(c.eye || "").trim().toUpperCase();
            existingPGCombs.add(`${addKey}_${cSph}_${cCyl}_${cAxis}_${cEye}`);
          }
        });
      });
    }

    for (let add of addList) {
      // For existing documents: find or create the add group
      let group = isExisting ? currentAddGroups.find(g => Math.abs(g.addValue - add) < 0.01) : null;
      let isNewGroup = false;

      if (!group) {
        group = { addValue: add, combinations: [] };
        isNewGroup = true;
      }

      const addKeyFixed = parseFloat(add).toFixed(2);

      for (let sph of sphList) {
        for (let cyl of cylList) {
          // Use normalized eye value for consistent handling
          const eyeList = (normalizedEye === "BOTH") ? ["R", "L"] : [normalizedEye];
          for (const eyeItem of eyeList) {
            const sphFixed = parseFloat(sph).toFixed(2);
            const cylFixed = parseFloat(cyl).toFixed(2);
            const axisFixed = parseFloat(axisNum).toFixed(2);
            const eyeUpper = eyeItem.toUpperCase();

            // Uniqueness key: scoped to CURRENT BATCH only (per powerGroupId)
            const batchKey = `${addKeyFixed}_${sphFixed}_${cylFixed}_${axisFixed}_${eyeUpper}`;

            // Skip if already added in this batch
            if (batchUniqueSet.has(batchKey)) {
              console.log(`[addLensPower] SKIP DUPLICATE in batch: ${batchKey}`);
              continue;
            }

            // Skip if already exists for THIS power group in DB
            if (existingPGCombs.has(batchKey)) {
              console.log(`[addLensPower] SKIP EXISTING in PG: ${batchKey}`);
              continue;
            }

            batchUniqueSet.add(batchKey);

            let barcode = "";
            if (generateBarcodes) {
              barcode = getNextBatchBarcode();
            }

            // FIX Issue 2: Always initialize new combinations with 0 values — NEVER copy from other groups
            group.combinations.push({
              sph,
              cyl,
              axis: axisNum,
              eye: eyeItem,
              barcode,
              boxNo: "",
              alertQty: 0,
              pPrice: 0,
              sPrice: 0,
              initStock: 0,
              powerGroupId: powerGroupId || null,
            });
            combinationsAdded++;
          }
        }
      }

      if (isExisting) {
        if (isNewGroup) {
          lensGroup.addGroups.push(group);
        }
        // If not isNewGroup, the combinations was already pushed to group which is a reference to lensGroup.addGroups element
      } else {
        newAddGroups.push(group);
      }
    }

    if (isExisting) {

      // Update master bounding ranges to encompass ALL combinations
      let allSphs = [];
      let allCyls = [];
      let allAdds = [];
      lensGroup.addGroups.forEach(g => {
        allAdds.push(parseFloat(g.addValue));
        g.combinations.forEach(c => {
          allSphs.push(parseFloat(c.sph));
          allCyls.push(parseFloat(c.cyl));
        });
      });

      if (allSphs.length > 0) {
        lensGroup.sphMin = Math.min(...allSphs);
        lensGroup.sphMax = Math.max(...allSphs);
      }
      if (allCyls.length > 0) {
        lensGroup.cylMin = Math.min(...allCyls);
        lensGroup.cylMax = Math.max(...allCyls);
      }
      if (allAdds.length > 0) {
        lensGroup.addMin = Math.min(...allAdds);
        lensGroup.addMax = Math.max(...allAdds);
      }

      // Sync the eye configuration if it changed
      if (eye && eye !== lensGroup.eye) {
        lensGroup.eye = eye;
      }

      await lensGroup.save();

      console.log(`[addLensPower] SUCCESS: Added ${combinationsAdded} combinations for AXIS=${axisNum}, total power groups now: ${lensGroup.powerGroups.length}`);

      return res.status(200).json({
        success: true,
        message: combinationsAdded > 0 ? "Lens range added successfully!" : "Range already exists, power group record updated.",
        visionType: lensGroup.visionType,
        combinationsAdded,
        data: lensGroup,
      });
    } else {
      // NEW LENS GROUP - Need to create powerGroup first to get its _id
      // Create the document with temporary powerGroups array
      const newLensGroup = await LensGroup.create({
        companyId,
        groupName,
        productName,

        sphMin: sphMinNum,
        sphMax: sphMaxNum,
        sphStep: sphStepNum,

        cylMin: cylMinNum,
        cylMax: cylMaxNum,
        cylStep: cylStepNum,

        addMin: addMinNum,
        addMax: addMaxNum,
        addStep: addStepNum,

        axis: axisNum,
        eye,
        visionType,

        addGroups: newAddGroups,
        powerGroups: [newPowerGroupRecord],
      });

      // Now get the powerGroupId from the created document
      const createdPowerGroupId = newLensGroup.powerGroups[0]._id;

      // Update all combinations to reference the newly created power group
      newLensGroup.addGroups.forEach(group => {
        group.combinations.forEach(comb => {
          comb.powerGroupId = createdPowerGroupId;
        });
      });

      // Save the updated document
      await newLensGroup.save();

      // Re-fetch to ensure we have the latest data
      const savedLensGroup = await LensGroup.findById(newLensGroup._id);

      console.log(`[addLensPower] NEW PRODUCT: Created ${newAddGroups.reduce((acc, g) => acc + g.combinations.length, 0)} combinations for AXIS=${axisNum}, powerGroupId=${createdPowerGroupId}`);

      // ---------------------------------------------
      // 7) RESPONSE
      // ---------------------------------------------
      return res.status(200).json({
        success: true,
        message: "Lens group created successfully!",
        visionType,
        totalAddGroups: newAddGroups.length,
        totalCombinations: newAddGroups.reduce(
          (acc, g) => acc + g.combinations.length,
          0
        ),
        data: savedLensGroup,
      });
    }

  } catch (err) {
    console.error("[addLensPower] Error:", err);

    // Specific handling for common errors
    if (err.code === 11000) {
      const keyPattern = err.keyPattern || {};
      const fields = Object.keys(keyPattern);
      let message = `A product with the same unique properties already exists.`;

      if (fields.includes('productName')) {
        message = `A product with the name "${req.body.productName}" already exists.`;
      } else if (fields.includes('barcode')) {
        message = `One or more barcodes in this batch already exist.`;
      }

      return res.status(400).json({
        success: false,
        message: message,
        error: "Duplicate Key Error",
        details: err.message,
        keyPattern: keyPattern
      });
    }

    if (err.name === "ValidationError") {
      const messages = Object.values(err.errors).map(val => val.message);
      return res.status(400).json({
        success: false,
        message: "Invalid data provided.",
        details: messages
      });
    }

    if (err.name === "CastError") {
        return res.status(400).json({
            success: false,
            message: `Invalid ID format for field ${err.path}`,
            error: err.message
        });
    }

    return res.status(500).json({
      success: false,
      message: "An unexpected error occurred while creating/updating the product.",
      error: err.message,
      stack: process.env.NODE_ENV === 'development' ? err.stack : undefined
    });
  }
};

const getLensPower = async (req, res) => {
  try {
    const { id, productName, groupName } = { ...req.body, ...req.query };
    console.log(`[getLensPower] Searching for: ID(${id}), ProductName(${productName}), GroupName(${groupName})`);
    const companyId = req.user?.companyId || null;

    // Convert companyId to ObjectId if it's a string
    const queryCompanyId = (companyId && mongoose.Types.ObjectId.isValid(companyId)) 
      ? new mongoose.Types.ObjectId(companyId) 
      : companyId;

    // -------------------------------------
    // 1) FETCH LENS GROUP
    // -------------------------------------
    let lens = null;

    if (id) {
      if (!mongoose.Types.ObjectId.isValid(id)) {
        console.log(`[getLensPower] Invalid ID provided: ${id}`);
        return res.status(400).json({ success: false, message: "Invalid Lens ID format" });
      }
      lens = await LensGroup.findOne({
        _id: id,
        $or: [{ companyId: queryCompanyId }, { companyId: null }]
      }).lean();
    } else {
      // -------------------------------------
      // 2) IF NO ID → FIND BY PRODUCT NAME OR GROUP NAME
      // -------------------------------------
      let query = {
        $or: [{ companyId: queryCompanyId }, { companyId: null }]
      };
      if (productName && productName.trim() !== "") {
        query.productName = { $regex: `^${escapeRegex(productName.trim())}$`, $options: "i" };
      }
      if (groupName && groupName.trim() !== "") {
        query.groupName = { $regex: `^${escapeRegex(groupName.trim())}$`, $options: "i" };
      }
      if (!query.productName && !query.groupName) {
        return res.status(400).json({ message: "Product name or Group name is required" });
      }

      lens = await LensGroup.findOne(query).lean();

      // Fallback: If both provided and not found, try productName alone
      if (!lens && productName && groupName) {
        console.log(`[getLensPower] Not found with both. Falling back to productName: ${productName}`);
        lens = await LensGroup.findOne({
          productName: { $regex: `^${escapeRegex(productName.trim())}$`, $options: "i" },
          $or: [{ companyId: queryCompanyId }, { companyId: null }]
        }).lean();
      }
    }

    if (!lens) {
      console.log(`[getLensPower] Initial lookup failed for ${productName}. Searching in Item collection...`);
      // check if it's at least an item
      const itm = await Item.findOne({ 
        itemName: { $regex: `^${escapeRegex(productName || "")}$`, $options: "i" },
        $or: [{ companyId }, { companyId: null }]
      }).lean();
      
      if (!itm) {
         return res.status(404).json({ success: false, message: "Lens not found in items" });
      }
      
      // It exists as an item! Create a synthetic LensGroup-like response
      lens = {
        _id: itm._id,
        productName: itm.itemName,
        groupName: itm.groupName,
        billItemName: itm.billItemName || "",
        vendorItemName: itm.vendorItemName || "",
        purchasePrice: itm.purchasePrice || 0,
        salePrice: { default: itm.salePrice || 0 },
        powerGroups: [],
        addGroups: [],
        barcode: itm.barcode || ""
      };
    }

    // -------------------------------------
    // 3) FETCH VENDOR MAP
    // -------------------------------------
    const purchases = await LensPurchase.aggregate([
      { $match: { "items.itemName": lens.productName } },
      { $unwind: "$items" },
      { $match: { "items.itemName": lens.productName } },
      {
         $group: {
           _id: { sph: "$items.sph", cyl: "$items.cyl", add: "$items.add", eye: "$items.eye" },
           vendors: { $addToSet: "$partyData.partyAccount" }
         }
      }
    ]);

    const vendorMap = {};
    purchases.forEach(p => {
       const sph = Number(p._id.sph) || 0;
       const cyl = Number(p._id.cyl) || 0;
       const add = Number(p._id.add) || 0;
       let eye = (p._id.eye || "RL").toString().trim().toUpperCase();
       if (eye === "R/L") eye = "RL"; // Standardize combined eye types to "RL"
       if (eye === "BOTH" || eye === "BOTH_RL") eye = eye; // Preserve BOTH or BOTH_RL as uppercase
       
       const key = `${sph}_${cyl}_${add}_${eye}`;
       vendorMap[key] = p.vendors.filter(v => v);
    });

    const resultObj = lens.toObject ? lens.toObject() : lens;
    
    // 3) FETCH LIBRARY RANGES (Strictly for this group) - DO NOT MERGE INTO powerGroups anymore
    // User requested only product-specific groups in the matrix filters.
    const gName = groupName || resultObj.groupName;
    let libraryRanges = [];
    if (gName) {
      libraryRanges = await PowerRangeLibrary.find({
        groupName: gName,
        companyId
      });
    }

    // Initialize powerGroups if it doesn't exist
    if (!resultObj.powerGroups) resultObj.powerGroups = [];

    // Store library ranges separately so they don't pollute item-specific filters
    resultObj.libraryRanges = libraryRanges;

    // Final fallback: If still empty, add full range
    if (resultObj.powerGroups.length === 0) {
      resultObj.powerGroups.push({
        _id: resultObj._id,
        sphMin: resultObj.sphMin || -99,
        sphMax: resultObj.sphMax || 99,
        cylMin: resultObj.cylMin || -99,
        cylMax: resultObj.cylMax || 99,
        addMin: resultObj.addMin || 0,
        addMax: resultObj.addMax || 99,
        label: "Full Range (Default)",
        purchasePrice: resultObj.purchasePrice || 0,
        salePrice: resultObj.salePrice?.default || 0
      });
    }

    // SPLIT LEGACY COMBINATIONS THAT HAVE "RL" INTO SEPARATE "R" and "L"
    const generateBarcodeFallback = () => {
      const prefix = (resultObj.productName || "LNS").substring(0, 3).toUpperCase();
      const timestamp = Date.now().toString().slice(-8);
      const random = Math.floor(Math.random() * 10000).toString().padStart(4, '0');
      return `${prefix}${timestamp}${random}`;
    };

    if (resultObj.addGroups && Array.isArray(resultObj.addGroups)) {
      resultObj.addGroups.forEach(group => {
        if (!group.combinations) return;
        
        const itemEyeConfig = (resultObj.eye || "").toUpperCase();
        const shouldSplit = ["BOTH", "BOTH_RL", "RL", "R/L"].includes(itemEyeConfig);

        if (shouldSplit) {
          const toRemove = new Set();
          const newCombs = [];
          const groupedBySphCylAxis = new Map();
          
          group.combinations.forEach(c => {
             const key = `${c.sph}_${c.cyl}_${c.axis || 0}`;
             if(!groupedBySphCylAxis.has(key)) groupedBySphCylAxis.set(key, []);
             groupedBySphCylAxis.get(key).push(c);
          });
  
          for (const [key, combs] of groupedBySphCylAxis.entries()) {
             const dualComb = combs.find(c => c.eye === "RL" || c.eye === "R/L" || c.eye === "BOTH" || c.eye === "BOTH_RL");
             const rComb = combs.find(c => c.eye === "R");
             const lComb = combs.find(c => c.eye === "L");
  
             if (dualComb && (!rComb || !lComb)) {
                toRemove.add(dualComb);
                if (!rComb) {
                    const bc = dualComb.barcode ? (lComb ? generateBarcodeFallback() : dualComb.barcode) : "";
                    newCombs.push({...dualComb, eye: "R", barcode: bc});
                }
                if (!lComb) {
                    const bc = dualComb.barcode ? (rComb ? generateBarcodeFallback() : generateBarcodeFallback()) : "";
                    newCombs.push({...dualComb, eye: "L", barcode: bc});
                }
             } else if (dualComb && rComb && lComb) {
                toRemove.add(dualComb);
             }
          }
          
          group.combinations = group.combinations.filter(c => !toRemove.has(c)).concat(newCombs);
        }
      });
    }

    resultObj.vendorMap = vendorMap;

    // -------------------------------------
    // 4) RETURN LENS GROUP WITH VENDORS
    // -------------------------------------
    return res.json(resultObj);

  } catch (err) {
    console.log(err);
    return res.status(500).json({ message: "Server Error" });
  }
};

const getPowerGroupsForProduct = async (req, res) => {
  try {
    const { productName } = req.query;
    const companyId = req.user?.companyId || null;

    if (!productName || productName.trim() === '') {
      return res.status(400).json({ success: false, message: 'Product name is required' });
    }

    const lensGroup = await LensGroup.findOne({
            productName: { $regex: `^${escapeRegex(productName.trim())}$`, $options: 'i' },

      $or: [{ companyId }, { companyId: null }]
    }).select('powerGroups productName').lean();

    if (!lensGroup) {
      return res.status(200).json({ success: true, data: [] });
    }

    const pgs = lensGroup.powerGroups || [];
    if (pgs.length === 0) {
      pgs.push({
        _id: lensGroup._id,
        sphMin: -99, sphMax: 99,
        cylMin: -99, cylMax: 99,
        addMin: 0, addMax: 99,
        label: "Full Range (Legacy)"
      });
    }

    return res.status(200).json({ success: true, data: pgs });
  } catch (err) {
    console.error('[getPowerGroupsForProduct] Error:', err);
    return res.status(500).json({ success: false, message: 'Server Error' });
  }
};


const getAllLensPower = async (req, res) => {
  try {
    const companyId = req.user?.companyId || null;
    
    // 1) Fetch all LensGroups
    const lensPowers = await LensGroup.find({
      $or: [{ companyId }, { companyId: null }]
    }).lean();

    // 2) Fetch all regular Items
    const items = await Item.find({
      $or: [{ companyId }, { companyId: null }]
    }).lean();

    // 3) Map Item collection items to LensGroup structure to avoid frontend breakages
    const lensPowerProductNames = new Set(lensPowers.map(lp => (lp.productName || "").toLowerCase()));
    
    const mappedItems = items
      .filter(itm => itm.itemName && !lensPowerProductNames.has(itm.itemName.toLowerCase()))
      .map(itm => ({
        _id: itm._id,
        productName: itm.itemName,
        groupName: itm.groupName,
        visionType: itm.forLensProduct ? "single" : "item",
        purchasePrice: itm.purchasePrice || 0,
        salePrice: { 
          default: itm.salePrice || 0 
        },
        billItemName: itm.billItemName || "",
        vendorItemName: itm.vendorItemName || "",
        powerGroups: [],
        addGroups: [],
        barcode: itm.barcode || "",
        gst: itm.gst || 0,
        isItemOnly: true
      }));

    const itemGstMap = {};
    items.forEach(itm => {
      if (itm.itemName) {
        itemGstMap[itm.itemName.toLowerCase()] = itm.gst || 0;
      }
    });

    const mappedLensPowers = lensPowers.map(lp => ({
      ...lp,
      gst: itemGstMap[(lp.productName || "").toLowerCase()] || 0
    }));

    const allData = [...mappedLensPowers, ...mappedItems];

    if (allData.length === 0) {
      return res.status(200).json({
        success: true,
        data: [],
        message: "No items found",
      });
    }

    return res.status(200).json({
      success: true,
      data: allData,
      message: "Items fetched successfully",
    });
  } catch (err) {
    console.error("Error fetching lens powers:", err);
    return res.status(500).json({
      success: false,
      error: { message: "Server error while fetching items" },
    });
  }
};

const editLensPower = async (req, res) => {
  try {
    const {
      id,
      sphMin,
      sphMax,
      sphStep,

      cylMin,
      cylMax,
      cylStep,

      addMin,
      addMax,
      addStep,

      axis,
      eye,
      addGroups, // Accept addGroups from frontend
      powerGroups, // Added powerGroups
    } = req.body;

    const groupName = req.body.groupName?.trim();
    const productName = req.body.productName?.trim();

    console.log("Editing Lens Power ID:", id);

    if (!id) {
      return res.status(400).json({
        success: false,
        message: "Lens ID required",
      });
    }

    const companyId = req.user?.companyId || null;
    // -------- FETCH EXISTING LENS --------
    const existingLens = await LensGroup.findOne({
      _id: id,
      $or: [{ companyId }, { companyId: null }]
    });
    if (!existingLens) {
      return res.status(404).json({
        success: false,
        message: "Lens not found",
      });
    }

    // -------- SAFE PARSER --------
    const addMinNum = parseNum(addMin);
    const addMaxNum = parseNum(addMax);
    const addStepNum = parseNum(addStep);

    // Check if range definitions changed (requires thorough regeneration)
    const rangeChanged =
      existingLens.sphMin != sphMin ||
      existingLens.sphMax != sphMax ||
      existingLens.sphStep != sphStep ||
      existingLens.cylMin != cylMin ||
      existingLens.cylMax != cylMax ||
      existingLens.cylStep != cylStep ||
      existingLens.addMin != addMinNum ||
      existingLens.addMax != addMaxNum ||
      existingLens.addStep != addStepNum ||
      existingLens.eye != eye;

    // Detect price change
    if (req.body.salePrice && req.body.salePrice.default !== undefined) {
      if (existingLens.salePrice?.default !== parseFloat(req.body.salePrice.default)) {
        existingLens.isPriceUpdated = true;
      }
    }

    if (req.body.resetPriceHighlight) {
       existingLens.isPriceUpdated = false;
    }

    // -------- UPDATE BASIC FIELDS ALWAYS --------
    existingLens.groupName = groupName || existingLens.groupName;
    existingLens.productName = productName || existingLens.productName;
    existingLens.axis = axis !== undefined ? axis : existingLens.axis;
    existingLens.eye = eye || existingLens.eye;

    // Update prices if provided
    if (req.body.salePrice) existingLens.salePrice = req.body.salePrice;
    if (req.body.purchasePrice !== undefined) existingLens.purchasePrice = req.body.purchasePrice;

    // Always update powerGroups if provided
    if (powerGroups) {
      existingLens.powerGroups = powerGroups;
      existingLens.markModified("powerGroups");

      // AUTO SAVE NEW POWER GROUPS TO LIBRARY
      for (const pg of powerGroups) {
        if (!pg.label) {
          pg.label = `SPH(${pg.sphMin} to ${pg.sphMax}) CYL(${pg.cylMin} to ${pg.cylMax}) ADD(${pg.addMin} to ${pg.addMax})`;
        }
        await saveToRangeLibrary(req, pg);
      }
    }

    // Refresh bounding ranges from powerGroups
    if (existingLens.powerGroups && existingLens.powerGroups.length > 0) {
      try {
        const pgs = existingLens.powerGroups;
        const validNum = (v) => !isNaN(parseFloat(v)) ? parseFloat(v) : null;

        const sphMins = pgs.map(p => validNum(p.sphMin)).filter(v => v !== null);
        const sphMaxs = pgs.map(p => validNum(p.sphMax)).filter(v => v !== null);
        const cylMins = pgs.map(p => validNum(p.cylMin)).filter(v => v !== null);
        const cylMaxs = pgs.map(p => validNum(p.cylMax)).filter(v => v !== null);
        const addMins = pgs.map(p => validNum(p.addMin)).filter(v => v !== null);
        const addMaxs = pgs.map(p => validNum(p.addMax)).filter(v => v !== null);

        if (sphMins.length) existingLens.sphMin = Math.min(...sphMins);
        if (sphMaxs.length) existingLens.sphMax = Math.max(...sphMaxs);
        if (cylMins.length) existingLens.cylMin = Math.min(...cylMins);
        if (cylMaxs.length) existingLens.cylMax = Math.max(...cylMaxs);
        if (addMins.length) existingLens.addMin = Math.min(...addMins);
        if (addMaxs.length) existingLens.addMax = Math.max(...addMaxs);
      } catch (rangeErr) {
        console.warn("Could not recalculate bounding ranges:", rangeErr.message);
      }
    }

    // -------- IF RANGE DID NOT CHANGE → UPDATE addGroups IF PROVIDED --------
    if (!rangeChanged) {
      console.log("No range change detected, updating combinations...");
      if (addGroups && Array.isArray(addGroups) && addGroups.length > 0) {

        // ── ISOLATION FIX ──
        // If the frontend sends editingPowerGroupId, do a SELECTIVE merge:
        // only update combinations belonging to that power group.
        // All other power groups' combinations are preserved unchanged from DB.
        const editingPowerGroupId = req.body.editingPowerGroupId
          ? req.body.editingPowerGroupId.toString()
          : null;

        if (editingPowerGroupId) {
          console.log(`[editLensPower] SELECTIVE update for powerGroupId: ${editingPowerGroupId}`);

          // Build lookup: addValue (fixed 2dp) → frontendCombinations[]
          const frontendAGMap = new Map();
          addGroups.forEach(ag => {
            const addKey = parseFloat(ag.addValue).toFixed(2);
            frontendAGMap.set(addKey, ag.combinations || []);
          });

          existingLens.addGroups = existingLens.addGroups.map(existingAG => {
            const addKey = parseFloat(existingAG.addValue).toFixed(2);
            const frontendCombs = frontendAGMap.get(addKey);

            // addGroup not in payload → leave completely unchanged
            if (!frontendCombs) return existingAG;

            const updatedCombinations = (existingAG.combinations || []).map(existingComb => {
              const cPgId = existingComb.powerGroupId
                ? existingComb.powerGroupId.toString()
                : null;

              // ✅ DIFFERENT power group → PRESERVE UNCHANGED
              if (cPgId && cPgId !== editingPowerGroupId) {
                return existingComb;
              }

              // Find matching combination in frontend payload by sph+cyl+axis+eye
              const cSph  = parseFloat(existingComb.sph).toFixed(2);
              const cCyl  = parseFloat(existingComb.cyl).toFixed(2);
              const cAxis = parseFloat(existingComb.axis || 0).toFixed(2);
              const cEye  = String(existingComb.eye || "").trim().toUpperCase();

              const matchingFC = frontendCombs.find(fc =>
                parseFloat(fc.sph).toFixed(2)      === cSph  &&
                parseFloat(fc.cyl).toFixed(2)      === cCyl  &&
                parseFloat(fc.axis || 0).toFixed(2) === cAxis &&
                String(fc.eye || "").trim().toUpperCase() === cEye
              );

              // No match → preserve existing
              if (!matchingFC) return existingComb;

              // ✅ SAME power group → apply updated values
              return {
                ...existingComb,
                barcode:          matchingFC.barcode          ?? existingComb.barcode ?? "",
                boxNo:            matchingFC.boxNo            ?? existingComb.boxNo ?? "",
                alertQty:         Number(matchingFC.alertQty)  || 0,
                pPrice:           Number(matchingFC.pPrice)    || 0,
                sPrice:           Number(matchingFC.sPrice)    || 0,
                initStock:        (matchingFC.initStock !== undefined && matchingFC.initStock !== null)
                                    ? Number(matchingFC.initStock)
                                    : (existingComb.initStock || 0),
                totalSoldQty:     Number(matchingFC.totalSoldQty)    || existingComb.totalSoldQty    || 0,
                totalSaleAmount:  Number(matchingFC.totalSaleAmount) || existingComb.totalSaleAmount || 0,
                salesHistory:     matchingFC.salesHistory     || existingComb.salesHistory || [],
                locations:        matchingFC.locations         || existingComb.locations || [],
                isVerified:       matchingFC.isVerified        ?? existingComb.isVerified ?? false,
                lastVerifiedDate: matchingFC.lastVerifiedDate  ?? existingComb.lastVerifiedDate ?? null,
                verifiedQty:      matchingFC.verifiedQty       ?? existingComb.verifiedQty ?? 0,
                powerGroupId:     existingComb.powerGroupId,  // ALWAYS preserve original powerGroupId
              };
            });

            return { ...existingAG, combinations: updatedCombinations };
          });

        } else {
          // LEGACY / BULK EDIT (no editingPowerGroupId) → original behavior
          console.log("[editLensPower] BULK update (no editingPowerGroupId)");
          existingLens.addGroups = addGroups.map((ag) => ({
            addValue: ag.addValue,
            combinations: (ag.combinations || []).map((c) => ({
              sph: c.sph,
              cyl: c.cyl,
              axis: c.axis,
              eye: c.eye,
              barcode: c.barcode || "",
              boxNo: c.boxNo || "",
              alertQty: Number(c.alertQty) || 0,
              pPrice: Number(c.pPrice) || 0,
              sPrice: Number(c.sPrice) || 0,
              initStock: (c.initStock !== undefined && c.initStock !== null) ? Number(c.initStock) : 0,
              totalSoldQty: Number(c.totalSoldQty) || 0,
              totalSaleAmount: Number(c.totalSaleAmount) || 0,
              salesHistory: c.salesHistory || [],
              locations: c.locations || [],
              isVerified: c.isVerified || false,
              lastVerifiedDate: c.lastVerifiedDate || null,
              verifiedQty: c.verifiedQty || 0,
              powerGroupId: c.powerGroupId || null,
            })),
          }));
        }

        existingLens.markModified("addGroups");
      }

      await existingLens.save();
      await syncLensGroupToItems(existingLens);

      return res.json({
        success: true,
        message: "Lens updated successfully (meta/alerts updated).",
        data: existingLens,
      });
    }


    // ---------------------------------------------------
    // MERGE & REGENERATE IF RANGE CHANGED
    // ---------------------------------------------------
    console.log("Range changed, regenerating combinations...");
    const sphList = createRange(sphMin, sphMax, sphStep);
    const cylList = createRange(cylMin, cylMax, cylStep);
    const addListNum = createRange(addMinNum, addMaxNum, addStepNum);

    const mergedGroupsMap = new Map();

    if (addGroups && Array.isArray(addGroups)) {
      addGroups.forEach(g => {
        const key = parseFloat(g.addValue).toFixed(2);
        mergedGroupsMap.set(key, {
          addValue: g.addValue,
          combinations: [...(g.combinations || [])]
        });
      });
    }

    for (let add of addListNum) {
      const addKey = parseFloat(add).toFixed(2);
      if (!mergedGroupsMap.has(addKey)) {
        mergedGroupsMap.set(addKey, { addValue: add, combinations: [] });
      }
      const group = mergedGroupsMap.get(addKey);

      for (let sph of sphList) {
        for (let cyl of cylList) {
          const eyeList = (eye === "BOTH" || eye === "BOTH_RL") ? ["R", "L"] : [eye];
          for (const eyeItem of eyeList) {
            const exists = group.combinations.some(c =>
              Math.abs(parseFloat(c.sph) - parseFloat(sph)) < 0.01 &&
              Math.abs(parseFloat(c.cyl) - parseFloat(cyl)) < 0.01 &&
              c.eye === eyeItem
            );

            if (!exists) {
              group.combinations.push({
                sph,
                cyl,
                axis: axis || 0,
                eye: eyeItem,
                barcode: "",
                boxNo: "",
                alertQty: 0,
                pPrice: 0,
                sPrice: 0,
                initStock: 0,
              });
            }
          }
        }
      }
    }

    const finalAddGroups = Array.from(mergedGroupsMap.values());
    existingLens.addGroups = finalAddGroups;
    existingLens.markModified("addGroups");

    // Recalculate ranges for storage
    let allSphs = [], allCyls = [], allAdds = [];
    finalAddGroups.forEach(g => {
      allAdds.push(parseFloat(g.addValue));
      g.combinations.forEach(c => {
        allSphs.push(parseFloat(c.sph));
        allCyls.push(parseFloat(c.cyl));
      });
    });

    if (allSphs.length) {
      existingLens.sphMin = Math.min(...allSphs);
      existingLens.sphMax = Math.max(...allSphs);
    }
    if (allCyls.length) {
      existingLens.cylMin = Math.min(...allCyls);
      existingLens.cylMax = Math.max(...allCyls);
    }
    if (allAdds.length) {
      existingLens.addMin = Math.min(...allAdds);
      existingLens.addMax = Math.max(...allAdds);
    }

    existingLens.visionType = (existingLens.addMin === 0 && existingLens.addMax === 0) ? "single" : "bifocal";

    await existingLens.save();
    await syncLensGroupToItems(existingLens);

    return res.json({
      success: true,
      message: "Lens ranges regenerated and updated successfully!",
      totalAddGroups: finalAddGroups.length,
      data: existingLens,
    });

  } catch (err) {
    console.error("Error in editLensPower:", err);
    return res.status(500).json({
      success: false,
      message: "Server error during lens update",
      error: err.message,
      stack: process.env.NODE_ENV === 'development' ? err.stack : undefined
    });
  }
};

const removeLensPower = async (req, res) => {
  try {
    const { id, productName } = req.body;
    const companyId = req.user?.companyId || null;

    // --- DELETE BY ID ---
    if (id) {
      const deletedLens = await LensGroup.findOneAndDelete({
        _id: id,
        $or: [{ companyId }, { companyId: null }]
      });

      if (!deletedLens) {
        return res.status(404).json({ message: "Lens not found" });
      }

      return res.status(200).json({
        message: "Lens deleted successfully",
        deletedLens,
      });
    }

    // --- DELETE BY UNIQUE PRODUCT NAME ---
    if (!productName) {
      return res
        .status(400)
        .json({ message: "productName is required for deletion" });
    }

    const deletedLens = await LensGroup.findOneAndDelete({
      productName,
      $or: [{ companyId }, { companyId: null }]
    });

    if (!deletedLens) {
      return res.status(404).json({ message: "Lens not found" });
    }

    return res.status(200).json({
      message: "Lens deleted successfully",
      deletedLens,
    });
  } catch (err) {
    console.error("Error deleting lens:", err);
    return res.status(500).json({
      message: "Internal server error",
      error: err.message,
    });
  }
};

// Check if barcode exists in any combination
const checkBarcodeExists = async (req, res) => {
  try {
    const { barcode, excludeLensId } = req.body;

    if (!barcode || barcode.trim() === "") {
      return res.status(400).json({
        success: false,
        message: "Barcode is required",
      });
    }

    // Build query to find barcode in any combination
    const query = {
      "addGroups.combinations.barcode": barcode.trim(),
    };

    // Exclude current lens if provided
    if (excludeLensId) {
      query._id = { $ne: excludeLensId };
    }

    const existing = await LensGroup.findOne(query);

    return res.status(200).json({
      success: true,
      exists: !!existing,
      message: existing ? "Barcode already exists" : "Barcode is available",
    });
  } catch (err) {
    console.error("Error checking barcode:", err);
    return res.status(500).json({
      success: false,
      message: "Server error while checking barcode",
      error: err.message,
    });
  }
};

// Generate unique barcode
const generateUniqueBarcode = async (req, res) => {
  try {
    const { prefix, excludeLensId } = req.body;

    // Generate barcode with prefix + timestamp + random number
    const timestamp = Date.now().toString().slice(-8); // Last 8 digits of timestamp
    const random = Math.floor(Math.random() * 10000).toString().padStart(4, '0');
    let barcode = prefix ? `${prefix}${timestamp}${random}` : `${timestamp}${random}`;

    // Ensure uniqueness
    let attempts = 0;
    const maxAttempts = 100;

    while (attempts < maxAttempts) {
      const query = {
        "addGroups.combinations.barcode": barcode,
      };

      if (excludeLensId) {
        query._id = { $ne: excludeLensId };
      }

      const exists = await LensGroup.findOne(query);

      if (!exists) {
        return res.status(200).json({
          success: true,
          barcode,
          message: "Unique barcode generated",
        });
      }

      // Regenerate if exists
      const newRandom = Math.floor(Math.random() * 10000).toString().padStart(4, '0');
      barcode = prefix ? `${prefix}${timestamp}${newRandom}` : `${timestamp}${newRandom}`;
      attempts++;
    }

    return res.status(500).json({
      success: false,
      message: "Failed to generate unique barcode after multiple attempts",
    });
  } catch (err) {
    console.error("Error generating barcode:", err);
    return res.status(500).json({
      success: false,
      message: "Server error while generating barcode",
      error: err.message,
    });
  }
};

const verifyLensStock = async (req, res) => {
  try {
    const { verifications } = req.body; // Array of { barcode, receivedQty }

    if (!verifications || !Array.isArray(verifications)) {
      return res.status(400).json({
        success: false,
        message: "Verifications array is required",
      });
    }

    const verificationDate = new Date();
    const results = [];

    for (const v of verifications) {
      const { barcode, receivedQty } = v;

      // Find the lens group and combination containing this barcode
      const lensGroup = await LensGroup.findOne({
        "addGroups.combinations.barcode": barcode,
      });

      if (lensGroup) {
        let updated = false;
        // Update the specific combination
        for (let ag of lensGroup.addGroups) {
          for (let comb of ag.combinations) {
            if (comb.barcode === barcode) {
              comb.isVerified = true;
              comb.lastVerifiedDate = verificationDate;
              comb.verifiedQty = receivedQty;
              updated = true;
              break;
            }
          }
          if (updated) break;
        }

        if (updated) {
          await lensGroup.save();
          results.push({ barcode, status: "success" });
        } else {
          results.push({ barcode, status: "failed", message: "Combination not found" });
        }
      } else {
        results.push({ barcode, status: "failed", message: "Barcode not found" });
      }
    }

    return res.status(200).json({
      success: true,
      message: "Stock verification completed",
      data: results,
      verificationDate
    });
  } catch (err) {
    console.error("Error verifying lens stock:", err);
    return res.status(500).json({
      success: false,
      message: "Server error during stock verification",
      error: err.message,
    });
  }
};

const getMissingLenses = async (req, res) => {
  try {
    const { barcodes: barcodesStr } = req.query;
    if (!barcodesStr) {
      return res.status(200).json({ success: true, data: [] });
    }

    const barcodes = barcodesStr.split(',');
    const results = [];

    for (const barcode of barcodes) {
      if (!barcode) continue;

      const lensGroup = await LensGroup.findOne({
        "addGroups.combinations.barcode": barcode,
      });

      if (lensGroup) {
        let found = false;
        for (let ag of lensGroup.addGroups) {
          for (let comb of ag.combinations) {
            if (comb.barcode === barcode) {
              const item = await Item.findOne({ barcode: barcode });
              results.push({
                barcode,
                itemName: lensGroup.productName,
                unit: item?.unit || "PCS",
                eye: comb.eye || "",
                sph: comb.sph ?? 0,
                cyl: comb.cyl ?? 0,
                axis: comb.axis || 0,
                add: ag.addValue ?? 0,
                dia: item?.dia || "",
                price: comb.pPrice || lensGroup.purchasePrice || 0,
                stock: (comb.initStock || 0) - (comb.totalSoldQty || 0),
              });
              found = true;
              break;
            }
          }
          if (found) break;
        }
      }
    }

    return res.status(200).json({
      success: true,
      data: results
    });
  } catch (err) {
    console.error("Error fetching missing lenses:", err);
    return res.status(500).json({
      success: false,
      message: "Server error while fetching missing lenses",
      error: err.message,
    });
  }
};

const getPowerRangeLibrary = async (req, res) => {
  try {
    const companyId = req.user?.companyId || null;
    
    // Explicitly handle and decode groupName. If missing, return empty as per "STRICTLY group-specific" requirement.
    const rawGroupName = req.query.groupName || "";
    let gName = "";
    try {
        gName = decodeURIComponent(rawGroupName).trim();
    } catch (e) {
        gName = rawGroupName.trim();
    }

    if (!gName) {
      console.log(`[getPowerRangeLibrary] companyId: ${companyId}, NO groupName provided. Returning empty.`);
      return res.status(200).json({ success: true, data: [] });
    }

    // Case-insensitive exact match on both groupName (new) and groupNames (legacy array).
    const escapedGName = gName.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
    const regex = new RegExp(`^${escapedGName}$`, "i");

    // Use $and to combine companyId filter with group filter (prevents $or collision).
    // companyId null fallback catches data saved before auth was configured.
    // groupNames (plural) fallback catches legacy documents saved by older code.
    const strictQuery = {
      $and: [
        { $or: [{ companyId }, { companyId: null }] },
        { $or: [{ groupName: { $regex: regex } }, { groupNames: { $regex: regex } }] }
      ]
    };

    console.log(`[getPowerRangeLibrary] Fetching library — companyId: ${companyId}, groupName: "${gName}"`);

    // FETCH DATA — group-specific, backward compatible with legacy groupNames field
    const ranges = await PowerRangeLibrary.find(strictQuery).sort({ createdAt: -1 });

    res.status(200).json({
      success: true,
      data: ranges,
      count: ranges.length,
      groupName: gName
    });
  } catch (error) {
    console.error("Error fetching PowerRangeLibrary:", error);
    res.status(500).json({
      success: false,
      message: "Internal Server Error"
    });
  }
};

const resetAllLensPriceHighlights = async (req, res) => {
  try {
    const companyId = req.user?.companyId || null;
    await LensGroup.updateMany(
      { $or: [{ companyId }, { companyId: null }], isPriceUpdated: true },
      { $set: { isPriceUpdated: false } }
    );
    return res.status(200).json({ success: true, message: "All price highlights reset" });
  } catch (err) {
     console.error("Error in resetAllLensPriceHighlights:", err);
     return res.status(500).json({ success: false, message: "Server Error" });
  }
}

const updateLensGroupLocations = async (req, res) => {
  try {
     const { productName, locationsToSave } = req.body;
     const companyId = req.user?.companyId || null;

     if (!productName || !locationsToSave) {
        return res.status(400).json({ success: false, message: "Missing required fields" });
     }

     const lensGroup = await LensGroup.findOne({
        productName: { $regex: `^${productName.trim()}$`, $options: 'i' },
        $or: [{ companyId }, { companyId: null }]
     });

     if (!lensGroup) {
        return res.status(404).json({ success: false, message: "Lens group not found" });
     }

     for (const update of locationsToSave) {
        const { sph, cyl, eye, add, locations, locationQty } = update;
        const targetAdd = Number(add);
        const targetSph = Number(sph);
        const targetCyl = Number(cyl);

        const addGroup = (lensGroup.addGroups || []).find(ag => Math.abs(ag.addValue - targetAdd) < 0.001);
        if (addGroup) {
           const combo = (addGroup.combinations || []).find(c => 
              Math.abs(c.sph - targetSph) < 0.001 &&
              Math.abs(c.cyl - targetCyl) < 0.001 &&
              c.eye === eye
           );
           if (combo) {
              if (locations !== undefined) {
                 combo.locations = locations || [];
              }
              if (locationQty !== undefined) {
                 combo.locationQty = locationQty;
              }
           }
        }
     }

     lensGroup.markModified("addGroups");
     await lensGroup.save();

     return res.status(200).json({ success: true, message: "Locations updated successfully" });

  } catch (err) {
     console.error("Error in updateLensGroupLocations:", err);
     return res.status(500).json({ success: false, message: "Server Error" });
  }
};

/**
 * GET /api/lensGroup/getCombinationStock
 * Body: { productName, sph, cyl, add, eye }
 */
const getCombinationStock = async (req, res) => {
  try {
     const { productName, sph, cyl, add, eye } = req.body;
     const companyId = req.user?.companyId || null;

     if (!productName) return res.status(400).json({ success: false, message: "Product name required" });

     const targetAdd = Number(add);
     const targetSph = Number(sph);
     const targetCyl = Number(cyl);
     const targetEye = String(eye || "").toUpperCase().trim();
     const targetAxis = Number(req.body.axis || 0);
     const targetEyes = (["RL", "R/L", "BOTH", "BOTH EYE", "PAIR"].includes(targetEye)) 
        ? ["RL", "R/L", "BOTH", "BOTH EYE", "PAIR", "R", "L", ""] 
        : [targetEye];

     const lensGroups = await LensGroup.find({
        productName: { $regex: new RegExp(`^${productName.trim()}$`, "i") },
        $or: [{ companyId }, { companyId: null }]
     });

     let stock = 0;
     let barcode = "";
     let sPrice;
     let pPrice;

     for (const lg of lensGroups) {
        const ag = (lg.addGroups || []).find(g => Math.abs(Number(g.addValue) - targetAdd) < 0.001);
        if (ag) {
           const matchingCombs = (ag.combinations || []).filter(c => 
              Math.abs(Number(c.sph) - targetSph) < 0.001 &&
              Math.abs(Number(c.cyl) - targetCyl) < 0.001 &&
              Math.abs(Number(c.axis || 0) - targetAxis) < 0.001 &&
              targetEyes.includes(String(c.eye || "").toUpperCase().trim())
           );
           stock += matchingCombs.reduce((sum, c) => sum + Number(c.initStock || 0), 0);
           if (!barcode && matchingCombs.length > 0) {
              barcode = matchingCombs[0].barcode || "";
           }
           if (sPrice === undefined && matchingCombs.length > 0 && matchingCombs[0].sPrice !== undefined) {
              sPrice = matchingCombs[0].sPrice;
           }
           if (pPrice === undefined && matchingCombs.length > 0 && matchingCombs[0].pPrice !== undefined) {
              pPrice = matchingCombs[0].pPrice;
           }
        }
     }

     return res.status(200).json({ success: true, stock, barcode, sPrice, pPrice });

  } catch (err) {
     console.error("Error in getCombinationStock:", err);
     return res.status(500).json({ success: false, message: "Server Error" });
  }
};

/**
 * GET /api/lensGroup/get-price-by-power
 * Fetch Lens Group pricing by power specifications (for manual selection)
 * Query params: { itemId, sph, cyl, axis, add }
 */
const getLensPriceByPower = async (req, res) => {
  try {
    const { itemId, sph, cyl, axis, add } = req.query;
    const companyId = req.user?.companyId || null;

    if (!itemId) {
      return res.status(400).json({ success: false, message: "Item ID is required" });
    }

    // Parse power values
    const targetAdd = Number(add) || 0;
    const targetSph = Number(sph) || 0;
    const targetCyl = Number(cyl) || 0;
    const targetAxis = Number(axis) || 0;

    // Find LensGroup by itemId (product ID)
    const lensGroup = await LensGroup.findOne({
      _id: itemId,
      $or: [{ companyId }, { companyId: null }]
    }).lean();

    if (!lensGroup) {
      // Fallback: Check if it's a standalone Item
      const item = await Item.findOne({
        _id: itemId,
        $or: [{ companyId }, { companyId: null }]
      }).lean();

      if (item) {
        return res.status(200).json({
          success: true,
          source: "item_master",
          hasPowerRange: false,
          purchasePrice: item.purchasePrice || 0,
          salePrice: item.salePrice || 0,
          stock: item.openingStockQty || 0,
          productName: item.itemName,
          billItemName: item.billItemName || ""
        });
      }

      return res.status(404).json({ success: false, message: "Item not found" });
    }

    // Search for matching combination in LensGroup
    let matchingComb = null;
    let matchingAdd = null;

    for (const ag of lensGroup.addGroups) {
      if (Math.abs(ag.addValue - targetAdd) < 0.001) {
        matchingAdd = ag;
        const comb = ag.combinations.find(c =>
          Math.abs(c.sph - targetSph) < 0.001 &&
          Math.abs(c.cyl - targetCyl) < 0.001 &&
          Math.abs((c.axis || 0) - targetAxis) < 0.01
        );
        if (comb) {
          matchingComb = comb;
          break;
        }
      }
    }

    if (matchingComb) {
      // Return combination-specific prices with fallback to group prices
      return res.status(200).json({
        success: true,
        source: "lens_group_combination",
        hasPowerRange: true,
        purchasePrice: matchingComb.pPrice || lensGroup.purchasePrice || 0,
        salePrice: matchingComb.sPrice || lensGroup.salePrice?.default || 0,
        stock: matchingComb.initStock || 0,
        productName: lensGroup.productName,
        billItemName: lensGroup.billItemName || "",
        found: true
      });
    } else {
      // Combination not found, return group-level prices
      return res.status(200).json({
        success: true,
        source: "lens_group_default",
        hasPowerRange: true,
        purchasePrice: lensGroup.purchasePrice || 0,
        salePrice: lensGroup.salePrice?.default || 0,
        stock: 0,
        productName: lensGroup.productName,
        billItemName: lensGroup.billItemName || "",
        found: false,
        message: "Using group-level pricing (combination not found)"
      });
    }
  } catch (err) {
    console.error("[getLensPriceByPower] Error:", err);
    return res.status(500).json({ success: false, message: "Server Error", error: err.message });
  }
};

export {
  addLensPower,
  getLensPower,
  getAllLensPower,
  removeLensPower,
  editLensPower,
  checkBarcodeExists,
  generateUniqueBarcode,
  verifyLensStock,
  getMissingLenses,
  getPowerRangeLibrary,
  getPowerGroupsForProduct,
  resetAllLensPriceHighlights,
  updateLensGroupLocations,
  getCombinationStock,
  getLensPriceByPower,
};

