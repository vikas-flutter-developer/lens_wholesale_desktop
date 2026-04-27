import mongoose from "mongoose";

/**
 * Generates the next incremental bill number for a specific party and company.
 * @param {mongoose.Model} Model - The Mongoose model to query (e.g., LensSale, LensPurchase).
 * @param {string} partyAccount - The name of the party.
 * @param {string|mongoose.Types.ObjectId} companyId - The company ID for multi-tenancy.
 * @returns {Promise<string>} The next bill number as a string.
 */
export const generateNextBillNo = async (Model, partyAccount, companyId) => {
  if (!partyAccount || !companyId) return "1";

  try {
    // Ensure companyId is an ObjectId for aggregation
    const cid = mongoose.Types.ObjectId.isValid(companyId) 
      ? mongoose.Types.ObjectId(String(companyId)) 
      : null;

    if (!cid) return "1";

    const result = await Model.aggregate([
      { 
        $match: { 
          "partyData.partyAccount": partyAccount, 
          companyId: cid 
        } 
      },
      {
        $addFields: {
          // Attempt to convert billNo to integer. 
          // If it's empty or non-numeric, $toInt might fail, so we use $convert
          billNoInt: { 
            $convert: { 
              input: "$billData.billNo", 
              to: "int", 
              onError: 0, 
              onNull: 0 
            } 
          }
        }
      },
      {
        $group: {
          _id: null,
          maxBillNo: { $max: "$billNoInt" }
        }
      }
    ]);

    const maxBillNo = result.length > 0 ? result[0].maxBillNo : 0;
    return String(maxBillNo + 1);
  } catch (err) {
    console.error("Error generating next bill number using aggregation:", err);
    
    // Fallback: fetch all and find max manually if aggregation fails
    try {
      const docs = await Model.find({
        "partyData.partyAccount": partyAccount,
        companyId: companyId
      }, { "billData.billNo": 1 }).lean();

      const maxNo = docs.reduce((max, doc) => {
        const n = parseInt(doc.billData?.billNo) || 0;
        return n > max ? n : max;
      }, 0);

      return String(maxNo + 1);
    } catch (fallbackErr) {
      console.error("Fallback error in generateNextBillNo:", fallbackErr);
      return "1";
    }
  }
};
