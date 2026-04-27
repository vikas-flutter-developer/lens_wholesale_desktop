import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SearchableMultiSelect<T> extends StatefulWidget {
  final String label;
  final String placeholder;
  final List<SearchableMultiSelectItem<T>> options;
  final List<T> selectedValues;
  final Function(List<T>) onChanged;
  final bool isLoading;

  const SearchableMultiSelect({
    super.key,
    required this.label,
    required this.placeholder,
    required this.options,
    required this.selectedValues,
    required this.onChanged,
    this.isLoading = false,
  });

  @override
  State<SearchableMultiSelect<T>> createState() => _SearchableMultiSelectState<T>();
}

class _SearchableMultiSelectState<T> extends State<SearchableMultiSelect<T>> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  String _searchTerm = '';
  late List<T> _localSelectedValues;

  @override
  void initState() {
    super.initState();
    _localSelectedValues = List<T>.from(widget.selectedValues);
  }

  @override
  void didUpdateWidget(SearchableMultiSelect<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedValues != oldWidget.selectedValues) {
      _localSelectedValues = List<T>.from(widget.selectedValues);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _overlayEntry?.markNeedsBuild();
      });
    }
  }

  void _toggleDropdown() {
    if (widget.isLoading) return;
    if (_isOpen) {
      _closeDropdown();
    } else {
      _showDropdown();
    }
  }

  void _showDropdown() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = _createOverlayEntry(size);
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _isOpen = false;
      _searchTerm = '';
    });
  }

  OverlayEntry _createOverlayEntry(Size size) {
    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: _closeDropdown,
            behavior: HitTestBehavior.translucent,
            child: Container(
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          ),
          CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, size.height + 5),
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(12),
              clipBehavior: Clip.antiAlias,
              child: StatefulBuilder(
                builder: (context, setOverlayState) {
                  return Container(
                    width: size.width,
                    constraints: const BoxConstraints(maxHeight: 350),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _DropdownContent<T>(
                      options: widget.options,
                      selectedValues: _localSelectedValues,
                      searchTerm: _searchTerm,
                      onSearchChanged: (val) {
                        setOverlayState(() => _searchTerm = val);
                        setState(() => _searchTerm = val); // Keep parent in sync
                      },
                      onToggle: (value) {
                        setState(() {
                          if (_localSelectedValues.contains(value)) {
                            _localSelectedValues.remove(value);
                          } else {
                            _localSelectedValues.add(value);
                          }
                        });
                        widget.onChanged(List<T>.from(_localSelectedValues));
                        setOverlayState(() {}); // Force rebuild of the overlay content
                      },
                      onSelectAll: () {
                        setState(() {
                          if (_localSelectedValues.length == widget.options.length) {
                            _localSelectedValues.clear();
                          } else {
                            _localSelectedValues = widget.options.map((o) => o.value).toList();
                          }
                        });
                        widget.onChanged(List<T>.from(_localSelectedValues));
                        setOverlayState(() {});
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF64748B),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          InkWell(
            onTap: _toggleDropdown,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: _isOpen ? const Color(0xFF3B82F6) : const Color(0xFFCBD5E1),
                  width: _isOpen ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: _isOpen
                    ? [BoxShadow(color: const Color(0xFF3B82F6).withOpacity(0.1), blurRadius: 4, spreadRadius: 1)]
                    : null,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: widget.isLoading
                        ? const Text("Loading...", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13))
                        : _localSelectedValues.isEmpty
                            ? Text(widget.placeholder, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13))
                            : _localSelectedValues.length == widget.options.length
                                ? const Text("All Selected", style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, fontSize: 13))
                                : Text(
                                    "${_localSelectedValues.length} items selected",
                                    style: const TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.w600, fontSize: 13),
                                  ),
                  ),
                  Icon(
                    _isOpen ? LucideIcons.chevronUp : LucideIcons.chevronDown,
                    size: 16,
                    color: const Color(0xFF94A3B8),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DropdownContent<T> extends StatefulWidget {
  final List<SearchableMultiSelectItem<T>> options;
  final List<T> selectedValues;
  final String searchTerm;
  final Function(String) onSearchChanged;
  final Function(T) onToggle;
  final VoidCallback onSelectAll;

  const _DropdownContent({
    required this.options,
    required this.selectedValues,
    required this.searchTerm,
    required this.onSearchChanged,
    required this.onToggle,
    required this.onSelectAll,
  });

  @override
  State<_DropdownContent<T>> createState() => _DropdownContentState<T>();
}

class _DropdownContentState<T> extends State<_DropdownContent<T>> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.searchTerm);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredOptions = widget.options
        .where((opt) => opt.label.toLowerCase().contains(widget.searchTerm.toLowerCase()))
        .toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: Color(0xFFF8FAFC),
            border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
          ),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                onChanged: widget.onSearchChanged,
                decoration: InputDecoration(
                  hintText: "Search...",
                  prefixIcon: const Icon(LucideIcons.search, size: 16, color: Color(0xFF94A3B8)),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF3B82F6))),
                  fillColor: Colors.white,
                  filled: true,
                ),
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: widget.onSelectAll,
                    child: Text(
                      widget.selectedValues.length == widget.options.length ? "UNSELECT ALL" : "SELECT ALL",
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF2563EB)),
                    ),
                  ),
                  Text(
                    "${filteredOptions.length} options",
                    style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
        ),
        Flexible(
          child: filteredOptions.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text("No matches found", style: TextStyle(fontStyle: FontStyle.italic, color: Color(0xFF94A3B8), fontSize: 13)),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredOptions.length,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  itemBuilder: (context, index) {
                    final opt = filteredOptions[index];
                    final isSelected = widget.selectedValues.contains(opt.value);

                    return InkWell(
                      onTap: () => widget.onToggle(opt.value),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                opt.label,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isSelected ? const Color(0xFF1D4ED8) : const Color(0xFF475569),
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                ),
                              ),
                            ),
                            Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
                                border: Border.all(color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFCBD5E1)),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: isSelected ? const Icon(LucideIcons.check, size: 12, color: Colors.white) : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class SearchableMultiSelectItem<T> {
  final String label;
  final T value;
  final String? group;

  SearchableMultiSelectItem({
    required this.label,
    required this.value,
    this.group,
  });
}
