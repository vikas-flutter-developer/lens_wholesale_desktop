import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_menus.dart';
import '../../../../core/auth/auth_provider.dart';
import '../../../../core/network/loading_provider.dart';
import '../../../../core/shortcuts/shortcut_manager.dart';

class SearchResult {
  final String label;
  final String link;
  final IconData icon;
  final String? parentLabel;
  SearchResult({required this.label, required this.link, required this.icon, this.parentLabel});
}

class AppLayout extends StatefulWidget {
  final Widget child;

  const AppLayout({super.key, required this.child});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  bool _isCollapsed = false;
  final Set<String> _expandedKeys = {};
  
  // Search State
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = "";
  List<SearchResult> _searchResults = [];
  bool _showSearchResults = false;
  final FocusNode _searchFocusNode = FocusNode();

  // Hover Flyout State
  MenuItem? _hoveredItem;
  String? _hoveredItemKey; // For visual highlighting
  Offset _flyoutPosition = Offset.zero;
  Timer? _flyoutTimer;
  bool _isFlipped = false;
  final ScrollController _sidebarScrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _sidebarScrollCtrl.addListener(() {
      if (_hoveredItem != null) {
        _handleMouseExit();
      }
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _searchFocusNode.dispose();
    _flyoutTimer?.cancel();
    _sidebarScrollCtrl.dispose();
    super.dispose();
  }

  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query;
      _searchResults = [];
      if (query.isEmpty) {
        _showSearchResults = false;
      } else {
        _showSearchResults = true;
        _performRecursiveSearch(appMenuItems, query.toLowerCase());
      }
    });
  }

  void _performRecursiveSearch(List<MenuItem> items, String query, [String? parentLabel]) {
    for (var item in items) {
      if (item.label.toLowerCase().contains(query) && item.link != null) {
        _searchResults.add(SearchResult(
          label: item.label,
          link: item.link!,
          icon: item.icon,
          parentLabel: parentLabel,
        ));
      }
      if (item.submenu != null) {
        _performRecursiveSearch(item.submenu!, query, item.label);
      }
    }
  }

  void _handleMouseEnter(MenuItem item, Offset position, {bool isFlipped = false}) {
    _flyoutTimer?.cancel();
    setState(() {
      _hoveredItem = item;
      _flyoutPosition = position;
      _hoveredItemKey = item.key;
      _isFlipped = isFlipped;
    });
  }

  void _handleMouseExit() {
    _flyoutTimer?.cancel();
    _flyoutTimer = Timer(const Duration(milliseconds: 250), () {
      if (mounted) {
        setState(() {
          _hoveredItem = null;
          _hoveredItemKey = null;
        });
      }
    });
  }


  // Find parent keys to auto-expand
  void _expandParentsForRoute(String location, List<MenuItem> items, [List<String> parents = const []]) {
    for (var item in items) {
      final currentParents = [...parents, item.key];
      if (item.link == location) {
        // Only setState if we actually have new keys to add
        bool needsUpdate = false;
        for (var p in parents) {
          if (!_expandedKeys.contains(p)) {
            needsUpdate = true;
            break;
          }
        }
        
        if (needsUpdate) {
          setState(() {
            _expandedKeys.addAll(parents);
          });
        }
        return;
      }
      if (item.submenu != null) {
        _expandParentsForRoute(location, item.submenu!, currentParents);
      }
    }
  }

  List<MenuItem> _getFilteredItems(bool isSuperAdmin) {
    if (isSuperAdmin) {
      return appMenuItems.where((item) => item.key == 'super-admin').toList();
    } else {
      return appMenuItems.where((item) => item.key != 'super-admin').toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isSuperAdmin = authProvider.user?['role'] == 'super_admin';
    final isImpersonated = authProvider.user?['isImpersonated'] == true;
    final location = GoRouterState.of(context).uri.toString();

    // Auto-expand parents for current route only on location change
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _expandParentsForRoute(location, appMenuItems);
      }
    });

    final filteredMenuItems = _getFilteredItems(isSuperAdmin);

    return GlobalShortcutManager(
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F5F9), // slate-100
        body: Column(
          children: [
            if (isImpersonated)
              Container(
                width: double.infinity,
                color: Colors.red.shade600,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.alertTriangle, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "You are currently impersonating ${authProvider.user?['name'] ?? 'another user'}",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () async {
                        final router = GoRouter.of(context);
                        await authProvider.stopImpersonating();
                        router.go('/');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.red.shade700,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                        minimumSize: const Size(100, 32),
                      ),
                      child: const Text("Exit"),
                    )
                  ],
                ),
              ),
            Expanded(
              child: Builder(
                builder: (stackContext) {
                  return Stack(
                    children: [
                      Row(
                        children: [
                          // Sidebar
                          AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        width: _isCollapsed ? 64 : 320,
                        decoration: const BoxDecoration(color: Color(0xFF000000)),
                        child: Column(
                          children: [
                            // Logo
                            Container(
                              height: 64,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: const BoxDecoration(color: Color(0xFF000000)),
                              child: Row(
                                mainAxisAlignment: _isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
                                children: [
                                  if (!_isCollapsed)
                                    const Expanded(
                                      child: Text("Optical Store", 
                                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis
                                      ),
                                    ),
                                  IconButton(
                                    icon: const Icon(LucideIcons.menu, color: Colors.white, size: 20),
                                    onPressed: () => setState(() => _isCollapsed = !_isCollapsed),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  )
                                ],
                              ),
                            ),

                            // Search Bar
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: _isCollapsed ? 8 : 16, vertical: 8),
                              child: _isCollapsed
                                ? IconButton(
                                    icon: const Icon(LucideIcons.search, color: Color(0xFF9CA3AF), size: 20),
                                    onPressed: () => setState(() => _isCollapsed = false),
                                  )
                                : Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1F2937),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: TextField(
                                      controller: _searchCtrl,
                                      focusNode: _searchFocusNode,
                                      onChanged: _handleSearch,
                                      style: const TextStyle(color: Colors.white, fontSize: 13),
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(LucideIcons.search, size: 16, color: Color(0xFF9CA3AF)),
                                        suffixIcon: _searchQuery.isNotEmpty 
                                          ? IconButton(
                                              icon: const Icon(LucideIcons.x, size: 14, color: Color(0xFF9CA3AF)),
                                              onPressed: () {
                                                _searchCtrl.clear();
                                                _handleSearch("");
                                              },
                                            )
                                          : null,
                                        hintText: "Search pages...",
                                        hintStyle: const TextStyle(color: Color(0xFF6B7280), fontSize: 13),
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                      ),
                                    ),
                                  ),
                            ),
                            
                            // Menu
                            Expanded(
                              child: ListView(
                                controller: _sidebarScrollCtrl,
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                children: filteredMenuItems.map((item) => _buildMenuItem(item, 0, location)).toList(),
                              ),
                            ),

                            // Bottom Profile
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: const BoxDecoration(color: Color(0xFF000000)),
                              child: _isCollapsed
                                  ? IconButton(
                                      icon: const Icon(LucideIcons.logOut, color: Color(0xFF9CA3AF)),
                                      onPressed: () => authProvider.logout(),
                                    )
                                    : SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        physics: const NeverScrollableScrollPhysics(),
                                        child: SizedBox(
                                          width: 288, // 320 - 32 padding
                                          child: Row(
                                            children: [
                                              const CircleAvatar(
                                                backgroundColor: Color(0xFF1F2937),
                                                child: Icon(LucideIcons.user, color: Colors.white, size: 20),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(authProvider.user?['name'] ?? 'User', 
                                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                                      overflow: TextOverflow.ellipsis
                                                    ),
                                                    Text(authProvider.user?['role']?.toUpperCase() ?? '', 
                                                      style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(LucideIcons.logOut, color: Color(0xFF9CA3AF), size: 18),
                                                onPressed: () => authProvider.logout(),
                                                tooltip: "Logout",
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                            )
                          ],
                        ),
                      ),

                      // Main Content
                      Expanded(
                        child: Listener(
                          behavior: HitTestBehavior.translucent,
                          onPointerDown: (_) {
                            if (!_isCollapsed) {
                              setState(() => _isCollapsed = true);
                            }
                          },
                          child: Stack(
                            children: [
                              widget.child,
                              // Global Loading Overlay matching React loadingSlice
                            if (context.watch<LoadingProvider>().isLoading)
                              Positioned.fill(
                                child: Container(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  child: const Center(
                                    child: CircularProgressIndicator(color: Color(0xFF2563EB)),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // Hover Flyout Menu (Collapsed Mode OR Depth > 0 Flyout)
                if (_hoveredItem != null && _hoveredItem!.submenu != null)
                  Builder(
                    builder: (flyoutCtx) {
                      final RenderBox? stackBox = context.findRenderObject() as RenderBox?;
                      final stackHeight = stackBox?.size.height ?? MediaQuery.of(context).size.height;
                      
                      return Positioned(
                        left: _isCollapsed ? 64 : 320,
                        top: _isFlipped ? null : _flyoutPosition.dy,
                        bottom: _isFlipped ? (stackHeight - _flyoutPosition.dy) : null,
                        child: MouseRegion(
                          onEnter: (_) {
                            _flyoutTimer?.cancel();
                            setState(() => _hoveredItemKey = _hoveredItem?.key);
                          },
                          onExit: (_) => _handleMouseExit(),
                          child: Material(
                            elevation: 12,
                            borderRadius: BorderRadius.circular(8),
                            color: const Color(0xFF111827),
                            child: Container(
                              width: 240,
                              constraints: BoxConstraints(
                                maxHeight: stackHeight - 40,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: const Color(0xFF374151).withValues(alpha: 0.5)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ..._hoveredItem!.submenu!.map((sub) => _buildFlyoutItem(sub)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                // Search Results Dropdown (Sidebar Placement - matching React)
                if (_showSearchResults && !_isCollapsed)
                  Positioned(
                    top: 112, // Logo(64) + Search Padding(8) + Search Height(40)
                    left: 16,
                    child: SizedBox(
                      width: 288,
                      child: Material(
                        elevation: 12,
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xFF111827),
                        child: Container(
                          constraints: const BoxConstraints(maxHeight: 400),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF374151)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: _searchResults.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text("No pages found matching \"$_searchQuery\"", 
                                  style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 13)
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: _searchResults.length,
                                itemBuilder: (context, index) {
                                  final res = _searchResults[index];
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        _showSearchResults = false;
                                        _searchCtrl.clear();
                                        _searchQuery = "";
                                        _isCollapsed = true; // Auto collapse on navigation
                                      });
                                      context.go(res.link);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(color: const Color(0xFF374151), width: index == _searchResults.length - 1 ? 0 : 1)),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(res.icon, size: 16, color: Colors.white70),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(res.label, style: const TextStyle(color: Colors.white, fontSize: 13)),
                                                if (res.parentLabel != null)
                                                  Text(res.parentLabel!, style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 11)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    ),
  ),
);
}


  Widget _buildMenuItem(MenuItem item, int depth, String currentLocation) {
    bool hasChildren = item.submenu != null && item.submenu!.isNotEmpty;
    bool isExpanded = _expandedKeys.contains(item.key);
    
    // Exact match or parent match
    bool isActive = item.link != null && currentLocation == item.link;
    bool isParentActive = _isParentOfActive(item, currentLocation);

    // React Logic: Level > 0 submenus should use flyout on desktop
    bool useFlyout = depth > 0;
    bool isHovered = _hoveredItemKey == item.key;

    if (_isCollapsed && depth == 0) {
      return Tooltip(
        message: item.label,
        child: Builder(
          builder: (itemCtx) => InkWell(
            onTap: () {
              if (item.link != null) {
                context.go(item.link!);
              } else {
                setState(() => _isCollapsed = false);
              }
            },
            child: MouseRegion(
              onEnter: (event) {
                final RenderBox itemBox = itemCtx.findRenderObject() as RenderBox;
                final RenderBox? stackBox = context.findRenderObject() as RenderBox?;
                if (stackBox == null) return;

                final itemPos = itemBox.localToGlobal(Offset.zero);
                final stackPos = stackBox.localToGlobal(Offset.zero);
                
                final relativeY = itemPos.dy - stackPos.dy;
                final viewportHeight = MediaQuery.of(context).size.height;
                // Calculate required height: ~40px per item + 8px padding
                final requiredHeight = (item.submenu?.length ?? 0) * 40 + 8;
                // Use a larger buffer (100px) or check if it exceeds bottom
                bool flipped = (viewportHeight - itemPos.dy) < (requiredHeight + 60);
                
                _handleMouseEnter(item, Offset(64, flipped ? relativeY + 48 : relativeY), isFlipped: flipped);
                setState(() => _hoveredItemKey = item.key);
              },
              onExit: (_) => _handleMouseExit(),
              child: Container(
                height: 48,
                alignment: Alignment.center,
                color: isActive 
                    ? const Color(0xFFB56965) 
                    : isParentActive 
                        ? const Color(0xFF8B4D49) 
                        : isHovered 
                            ? const Color(0xFF1F2937) 
                            : Colors.transparent,
                child: Icon(item.icon, 
                  color: (isActive || isParentActive) ? Colors.white : const Color(0xFF9CA3AF), 
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        Builder(
          builder: (itemCtx) => MouseRegion(
            onEnter: (event) {
              setState(() => _hoveredItemKey = item.key);
              if (useFlyout && hasChildren) {
                final RenderBox itemBox = itemCtx.findRenderObject() as RenderBox;
                final RenderBox? stackBox = context.findRenderObject() as RenderBox?;
                if (stackBox == null) return;

                final itemPos = itemBox.localToGlobal(Offset.zero);
                final stackPos = stackBox.localToGlobal(Offset.zero);
                
                final relativeY = itemPos.dy - stackPos.dy;
                final viewportHeight = MediaQuery.of(context).size.height;
                // Calculate required height: ~40px per item + 8px padding
                final requiredHeight = (item.submenu?.length ?? 0) * 40 + 8;
                // Use a larger buffer (60px) to ensure it flips earlier
                bool flipped = (viewportHeight - itemPos.dy) < (requiredHeight + 60);
                
                // Align with top (or bottom if flipped) of item in expanded mode
                // Expanded items are roughly 48px high with padding
                _handleMouseEnter(item, Offset(0, flipped ? relativeY + 48 : relativeY), isFlipped: flipped);
              }
            },
          onExit: (_) {
            if (useFlyout && hasChildren) {
              _handleMouseExit();
            } else {
              setState(() => _hoveredItemKey = null);
            }
          },
          child: InkWell(
            onTap: () {
              if (hasChildren && !useFlyout) {
                setState(() {
                  if (isExpanded) {
                    _expandedKeys.remove(item.key);
                  } else {
                    _expandedKeys.add(item.key);
                  }
                });
              } else if (item.link != null) {
                context.go(item.link!);
              }
            },
            child: Container(
              padding: EdgeInsets.only(left: 16 + (depth * 16.0), right: 16, top: 12, bottom: 12),
              color: isActive 
                  ? const Color(0xFFB56965) 
                  : isParentActive 
                      ? const Color(0xFF8B4D49) 
                      : isHovered 
                          ? (depth == 0 ? const Color(0xFF1F2937) : const Color(0xFF374151))
                          : Colors.transparent,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                child: SizedBox(
                  width: 288 - (depth * 16.0), // Adjust width based on indent
                  child: Row(
                    children: [
                      Icon(item.icon, 
                        color: (isActive || isParentActive) ? Colors.white : const Color(0xFF9CA3AF), 
                        size: 18),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item.label,
                          style: TextStyle(
                            color: (isActive || isParentActive) ? Colors.white : const Color(0xFFD1D5DB),
                            fontSize: 13,
                            fontWeight: (isActive || isParentActive) ? FontWeight.w600 : FontWeight.w400,
                          ),
                          softWrap: false,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      if (hasChildren)
                        Icon(
                          useFlyout ? LucideIcons.chevronRight : (isExpanded ? LucideIcons.chevronDown : LucideIcons.chevronRight),
                          color: const Color(0xFF9CA3AF),
                          size: 14,
                        )
                    ],
                  ),
                ),
              ),
            ), // Container
          ), // InkWell
        ), // MouseRegion
      ), // Builder
        if (hasChildren && isExpanded && !useFlyout && !_isCollapsed)
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: Column(
              children: item.submenu!.map((sub) => _buildMenuItem(sub, depth + 1, currentLocation)).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildFlyoutItem(MenuItem sub) {
    return StatefulBuilder(
      builder: (context, setStateFlyout) {
        bool isFlyoutHovered = _hoveredItemKey == sub.key;
        return MouseRegion(
          onEnter: (_) => setState(() => _hoveredItemKey = sub.key),
          onExit: (_) => setState(() => _hoveredItemKey = _hoveredItem?.key),
          child: InkWell(
            onTap: () {
              setState(() {
                _hoveredItem = null;
                _hoveredItemKey = null;
              });
              context.go(sub.link!);
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: isFlyoutHovered ? const Color(0xFFB56965) : Colors.transparent,
              child: Row(
                children: [
                  Icon(sub.icon, size: 16, color: isFlyoutHovered ? Colors.white : const Color(0xFF9CA3AF)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(sub.label, 
                      style: TextStyle(color: isFlyoutHovered ? Colors.white : const Color(0xFFD1D5DB), fontSize: 13)
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  bool _isParentOfActive(MenuItem item, String location) {
    if (item.submenu == null) return false;
    for (var sub in item.submenu!) {
      if (sub.link == location) return true;
      if (_isParentOfActive(sub, location)) return true;
    }
    return false;
  }
}
