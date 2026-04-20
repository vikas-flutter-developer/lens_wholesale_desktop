/**
 * Reusable Dropdown Keyboard Navigation Handler
 * Supports: ArrowDown, ArrowUp, Enter, Escape
 * 
 * Features:
 * - Opens dropdown on ArrowDown if closed
 * - Navigates through options with ArrowUp/Down
 * - Selects option on Enter
 * - Closes on Escape
 * - Auto-scrolls to highlighted option
 */

/**
 * Main keyboard handler function
 * @param {Event} e - The keyboard event
 * @param {Object} state - State object containing:
 *   - isOpen: boolean
 *   - highlightedIndex: number (-1 means none)
 *   - options: array of options
 *   - setHighlightedIndex: function to update highlighted index
 *   - setIsOpen: function to update open state
 *   - onSelect: function to call when option is selected
 *   - canOpenDropdown: boolean (default: true) - whether dropdown can open on ArrowDown
 *   - shouldPreventDefault: boolean (default: true) - whether to prevent default browser behavior
 */
export const handleDropdownKeyDown = (e, state) => {
  const {
    isOpen,
    highlightedIndex,
    options,
    setHighlightedIndex,
    setIsOpen,
    onSelect,
    canOpenDropdown = true,
    shouldPreventDefault = true,
  } = state;

  if (!options || options.length === 0) {
    if (e.key === "Escape" && isOpen) {
      if (shouldPreventDefault) e.preventDefault();
      setIsOpen(false);
    }
    return;
  }

  switch (e.key) {
    case "ArrowDown":
      if (shouldPreventDefault) e.preventDefault();

      if (!isOpen && canOpenDropdown) {
        setIsOpen(true);
        setHighlightedIndex(0);
      } else if (isOpen) {
        setHighlightedIndex((prev) =>
          prev < options.length - 1 ? prev + 1 : prev
        );
      }
      break;

    case "ArrowUp":
      if (shouldPreventDefault) e.preventDefault();

      if (isOpen) {
        setHighlightedIndex((prev) => (prev > 0 ? prev - 1 : 0));
      }
      break;

    case "Enter":
      if (shouldPreventDefault) e.preventDefault();

      if (isOpen && highlightedIndex >= 0 && highlightedIndex < options.length) {
        onSelect(options[highlightedIndex]);
        setIsOpen(false);
        setHighlightedIndex(-1);
      }
      break;

    case "Escape":
      if (shouldPreventDefault) e.preventDefault();

      if (isOpen) {
        setIsOpen(false);
        setHighlightedIndex(-1);
      }
      break;

    default:
      break;
  }
};

/**
 * Auto-scroll highlighted option into view
 * @param {string} highlightedSelector - CSS selector for highlighted element
 * @param {string} containerSelector - CSS selector for container (optional)
 */
export const autoScrollToHighlighted = (
  highlightedSelector = ".active-option",
  containerSelector = null
) => {
  const activeEl = document.querySelector(highlightedSelector);
  if (activeEl) {
    const container = containerSelector
      ? document.querySelector(containerSelector)
      : activeEl.parentElement;

    if (container) {
      activeEl.scrollIntoView({ block: "nearest", behavior: "smooth" });
    }
  }
};

/**
 * Simplified keyboard handler for autocomplete inputs
 * Handles: ArrowDown (open), ArrowUp, Enter, Escape
 * Used for search inputs with suggestions list
 */
export const handleAutocompleteKeyDown = (e, state) => {
  const {
    showSuggestions,
    activeIndex,
    filteredOptions,
    setActiveIndex,
    setShowSuggestions,
    onSelect,
    shouldPreventDefault = true,
  } = state;

  if (!showSuggestions || !filteredOptions || filteredOptions.length === 0) {
    if (e.key === "Escape") {
      if (shouldPreventDefault) e.preventDefault();
      setShowSuggestions(false);
      setActiveIndex(-1);
    }
    return;
  }

  switch (e.key) {
    case "ArrowDown":
      if (shouldPreventDefault) e.preventDefault();
      setActiveIndex((prev) =>
        Math.min(prev + 1, filteredOptions.length - 1)
      );
      break;

    case "ArrowUp":
      if (shouldPreventDefault) e.preventDefault();
      setActiveIndex((prev) => Math.max(prev - 1, 0));
      break;

    case "Enter":
      if (shouldPreventDefault) e.preventDefault();
      if (activeIndex >= 0 && activeIndex < filteredOptions.length) {
        onSelect(filteredOptions[activeIndex]);
        setShowSuggestions(false);
        setActiveIndex(-1);
      }
      break;

    case "Escape":
      if (shouldPreventDefault) e.preventDefault();
      setShowSuggestions(false);
      setActiveIndex(-1);
      break;

    default:
      break;
  }
};
