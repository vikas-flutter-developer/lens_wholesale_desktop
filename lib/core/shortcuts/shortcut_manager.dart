import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:lens_wholesale_desktop/features/utilities/data/providers/utility_provider.dart';
import 'package:lens_wholesale_desktop/features/utilities/data/models/utility_models.dart';
import '../presentation/widgets/command_palette_widget.dart';

class GlobalShortcutManager extends StatefulWidget {
  final Widget child;

  const GlobalShortcutManager({super.key, required this.child});

  @override
  State<GlobalShortcutManager> createState() => _GlobalShortcutManagerState();
}

class _GlobalShortcutManagerState extends State<GlobalShortcutManager> {
  bool _handleKeyEvent(BuildContext context, KeyEvent event, List<KeyBinding> shortcuts) {
    if (event is! KeyDownEvent) return false;

    // 1. Detect if user is typing in a TextField
    final primaryFocus = FocusManager.instance.primaryFocus;
    final isEditable = primaryFocus?.context?.widget is EditableText || 
                       primaryFocus?.debugLabel?.contains('EditableText') == true;
    
    final bool isCtrl = HardwareKeyboard.instance.isControlPressed;
    final bool isAlt = HardwareKeyboard.instance.isAltPressed;
    final bool isShift = HardwareKeyboard.instance.isShiftPressed;

    // If typing and no modifiers (Ctrl/Alt), ignore the shortcut
    if (isEditable && !isCtrl && !isAlt) return false;

    final pressedKeys = <String>[];
    if (isCtrl) pressedKeys.add('Ctrl');
    if (isAlt) pressedKeys.add('Alt');
    if (isShift) pressedKeys.add('Shift');

    // Ignore if only modifiers are pressed
    if (event.logicalKey == LogicalKeyboardKey.controlLeft ||
        event.logicalKey == LogicalKeyboardKey.controlRight ||
        event.logicalKey == LogicalKeyboardKey.altLeft ||
        event.logicalKey == LogicalKeyboardKey.altRight ||
        event.logicalKey == LogicalKeyboardKey.shiftLeft ||
        event.logicalKey == LogicalKeyboardKey.shiftRight) {
      return false;
    }

    // Determine the main key character
    String mainKey = event.logicalKey.keyLabel.toUpperCase();
    if (mainKey == ' ') mainKey = 'Space';

    final combo = [...pressedKeys, mainKey].join('+');

    // Special Case: Ctrl + K (Global Search)
    if (isCtrl && mainKey == 'K') {
       showDialog(
         context: context, 
         builder: (context) => const CommandPalette(),
       );
       return true;
    }

    try {
      final match = shortcuts.firstWhere(
        (s) => s.status == 'Enabled' && s.keyCombination.toLowerCase() == combo.toLowerCase(),
      );
      
      // Match found
      final url = match.url;
      final pageName = match.action;
      
      if (url == null || url.isEmpty) return false;

      // Show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Navigating to $pageName via Shortcut ($combo)"),
          backgroundColor: const Color(0xFF1E293B),
          duration: const Duration(milliseconds: 1000),
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Navigate
      context.go(url);
      
      return true; // Stop propagation
    } catch (_) {
      // No match found
    }

    return false; // Let other widgets handle it
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UtilityProvider>(
      builder: (context, provider, _) {
        return Focus(
          autofocus: true,
          debugLabel: 'GlobalShortcutScope',
          onKeyEvent: (node, event) {
            final handled = _handleKeyEvent(context, event, provider.keyBindings);
            return handled ? KeyEventResult.handled : KeyEventResult.ignored;
          },
          child: widget.child,
        );
      },
    );
  }
}
