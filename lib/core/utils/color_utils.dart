import 'package:flutter/material.dart';

class GroupColor {
  final Color background;
  final Color text;
  final Color border;

  const GroupColor({
    required this.background,
    required this.text,
    required this.border,
  });
}

GroupColor getGroupColor(String name) {
  if (name.isEmpty) {
    return const GroupColor(
      background: Color(0xFFF1F5F9),
      text: Color(0xFF64748B),
      border: Color(0xFFE2E8F0),
    );
  }

  final List<GroupColor> palette = [
    const GroupColor(background: Color(0xFFEEF2FF), text: Color(0xFF4F46E5), border: Color(0xFFE0E7FF)), // Indigo
    const GroupColor(background: Color(0xFFF0FDF4), text: Color(0xFF16A34A), border: Color(0xFFDCFCE7)), // Green
    const GroupColor(background: Color(0xFFFEF2F2), text: Color(0xFFDC2626), border: Color(0xFFFEE2E2)), // Red
    const GroupColor(background: Color(0xFFFFFBEB), text: Color(0xFFD97706), border: Color(0xFFFEF3C7)), // Amber
    const GroupColor(background: Color(0xFFF5F3FF), text: Color(0xFF7C3AED), border: Color(0xFFEDE9FE)), // Violet
    const GroupColor(background: Color(0xFFECFEFF), text: Color(0xFF0891B2), border: Color(0xFFCFFAFE)), // Cyan
    const GroupColor(background: Color(0xFFFFF1F2), text: Color(0xFFE11D48), border: Color(0xFFFFE4E6)), // Rose
    const GroupColor(background: Color(0xFFF0F9FF), text: Color(0xFF0284C7), border: Color(0xFFE0F2FE)), // Sky
    const GroupColor(background: Color(0xFFFDF4FF), text: Color(0xFFC026D3), border: Color(0xFFFAE8FF)), // Fuchsia
    const GroupColor(background: Color(0xFFF0FDFA), text: Color(0xFF0D9488), border: Color(0xFFCCFBF1)), // Teal
    const GroupColor(background: Color(0xFFFAF5FF), text: Color(0xFF9333EA), border: Color(0xFFF3E8FF)), // Purple
    const GroupColor(background: Color(0xFFFFF7ED), text: Color(0xFFEA580C), border: Color(0xFFFFEDD5)), // Orange
  ];

  // Simple deterministic hash
  int hash = 0;
  String upperName = name.toUpperCase();
  for (int i = 0; i < upperName.length; i++) {
    hash = upperName.codeUnitAt(i) + ((hash << 5) - hash);
  }
  
  final index = hash.abs() % palette.length;
  return palette[index];
}
