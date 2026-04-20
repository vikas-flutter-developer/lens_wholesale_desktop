import ApiClient from "../ApiClient.js";

/**
 * Get barcode details to auto-fill order items
 * @param {string} barcode - Barcode to search for
 * @returns {Object} Product details with lens specifications
 */
export const getBarcodeDetails = async (barcode) => {
  try {
    if (!barcode || barcode.trim() === "") {
      return null;
    }

    const response = await ApiClient.get(`/barcodes/${barcode.trim()}`);
    
    if (response?.data?.success) {
      const lensData = response.data.lensData;
      const source = response.data.source || "unknown";
      
      return {
        itemName: lensData.productName || lensData.itemName || "",
        eye: lensData.eye || "R/L",
        sph: lensData.sph || "",
        cyl: lensData.cyl || "",
        axis: lensData.axis || 0,
        add: lensData.add || 0,
        purchasePrice: lensData.purchasePrice || 0,
        price: lensData.salePrice || 0,
        stock: lensData.stock || 0,
        sellPrice: lensData.salePrice || 0,
        source: source,
        hasPowerRange: lensData.hasPowerRange || false
      };
    }
    
    return null;
  } catch (error) {
    console.error("Error fetching barcode details:", error);
    throw error;
  }
};

/**
 * Format error message from barcode API response
 * @param {Error} error - Error object
 * @returns {string} Formatted error message
 */
export const getBarcodeErrorMessage = (error) => {
  if (error.response?.status === 404) {
    return "Product not found";
  }
  if (error.response?.data?.message) {
    return error.response.data.message;
  }
  return "Error fetching barcode details";
};

/**
 * Get lens pricing by power specification (for manual selection)
 * Used when user manually selects item + enters power values instead of barcode
 * @param {string} itemId - Item/LensGroup ID
 * @param {number} sph - Sphere power
 * @param {number} cyl - Cylinder power
 * @param {number} axis - Axis value
 * @param {number} add - Addition power
 * @returns {Object} Pricing data with purchasePrice, salePrice, and stock
 */
export const getLensPriceByPower = async (itemId, sph, cyl, axis, add) => {
  try {
    if (!itemId) {
      return null;
    }

    // Only fetch if we have valid power values (at least sph and cyl defined)
    const params = new URLSearchParams();
    params.append('itemId', itemId);
    if (sph !== null && sph !== undefined && sph !== "") params.append('sph', sph);
    if (cyl !== null && cyl !== undefined && cyl !== "") params.append('cyl', cyl);
    if (axis !== null && axis !== undefined && axis !== "") params.append('axis', axis);
    if (add !== null && add !== undefined && add !== "") params.append('add', add);

    const response = await ApiClient.get(`/lensGroup/get-price-by-power?${params.toString()}`);

    if (response?.data?.success) {
      const data = response.data;
      return {
        purchasePrice: data.purchasePrice || 0,
        salePrice: data.salePrice || 0,
        price: data.salePrice || 0, // Alias for salePrice
        stock: data.stock || 0,
        source: data.source || "unknown",
        hasPowerRange: data.hasPowerRange || false,
        productName: data.productName || "",
        found: data.found !== false
      };
    }

    return null;
  } catch (error) {
    console.error("Error fetching lens price by power:", error);
    // Silently fail - UI will use fallback values
    return null;
  }
};
