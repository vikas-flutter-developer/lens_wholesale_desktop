/**
 * Round an amount based on decimal value.
 * If decimal < 0.5, round down (floor).
 * If decimal >= 0.5, round up (ceil).
 */
export const roundAmount = (value) => {
  if (value === null || value === undefined || value === "") return 0;

  const num = Number(value);
  if (isNaN(num)) return 0;

  // This is fundamentally what Math.round does for positive numbers.
  // We use the provided logic specifically for consistent behavior.
  const decimal = num - Math.floor(num);

  if (decimal < 0.5) {
    return Math.floor(num);
  } else {
    return Math.ceil(num);
  }
};

/**
 * Format power values (SPH, CYL, ADD) for display
 * 
 * Rules:
 * - Always show 2 decimal places (1 → 1.00)
 * - Always show sign for positive values (1.00 → +1.00)
 * - Negative values remain as-is (-1.00)
 * - Empty/null/NaN values return empty string
 * 
 * @param {number|string} value - The power value to format
 * @returns {string} Formatted power value (e.g., "+1.00", "-1.00", "0.00")
 * 
 * @example
 * formatPowerValue(1) // Returns "+1.00"
 * formatPowerValue(2.5) // Returns "+2.50"
 * formatPowerValue(-1) // Returns "-1.00"
 * formatPowerValue(0) // Returns "+0.00"
 * formatPowerValue('') // Returns ""
 */
export const formatPowerValue = (value) => {
  if (value === null || value === undefined || value === '') return '';

  const num = parseFloat(value);
  if (isNaN(num)) return '';

  const formatted = num.toFixed(2);
  return num >= 0 ? `+${formatted}` : formatted;
};
