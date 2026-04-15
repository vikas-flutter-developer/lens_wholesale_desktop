import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../data/providers/utility_provider.dart';
import '../../data/models/utility_models.dart';

class BackupRestorePage extends StatefulWidget {
  const BackupRestorePage({super.key});

  @override
  State<BackupRestorePage> createState() => _BackupRestorePageState();
}

class _BackupRestorePageState extends State<BackupRestorePage> {
  final ScrollController _horizontalScrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UtilityProvider>().fetchBackups();
    });
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  String _formatSize(int bytes) {
    if (bytes <= 0) return 'Pending...';
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(2)} ${suffixes[i]}';
  }

  String _getDuration(BackupLog backup) {
    final start = backup.createdAt;
    final end = (backup.status == 'completed' || backup.status == 'failed') ? backup.updatedAt : DateTime.now();
    final diff = end.difference(start);

    if (backup.status == 'pending') {
      return "Est. ~1-2 mins";
    }

    if (diff.inMinutes == 0) return "${diff.inSeconds}s";
    return "${diff.inMinutes}m ${diff.inSeconds % 60}s";
  }

  void _confirmRestore(String id) {
    final TextEditingController confirmController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(LucideIcons.alertTriangle, color: Colors.red),
            SizedBox(width: 8),
            Text('Confirm System Restore'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'WARNING: This action will overwrite all current system data with the selected backup.',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(height: 16),
            const Text('To proceed, please type "RESTORE" in the box below:'),
            const SizedBox(height: 8),
            TextField(
              controller: confirmController,
              decoration: const InputDecoration(
                hintText: 'RESTORE',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ValueListenableBuilder(
            valueListenable: confirmController,
            builder: (context, value, child) {
              return ElevatedButton(
                onPressed: value.text == 'RESTORE'
                    ? () async {
                        final provider = context.read<UtilityProvider>();
                        final messenger = ScaffoldMessenger.of(context);
                        Navigator.pop(context);
                        final success = await provider.restoreBackup(id);
                        if (mounted) {
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(success ? 'System restored successfully' : 'Restoration failed'),
                              backgroundColor: success ? Colors.green : Colors.red,
                            ),
                          );
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                child: const Text('Execute Restore'),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Consumer<UtilityProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (provider.error != null)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 24),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFFCA5A5))),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.alertCircle, color: Color(0xFFDC2626), size: 20),
                        const SizedBox(width: 12),
                        Expanded(child: Text(provider.error!, style: const TextStyle(color: Color(0xFF991B1B), fontSize: 13))),
                        IconButton(onPressed: provider.fetchBackups, icon: const Icon(LucideIcons.refreshCcw, size: 16, color: Color(0xFFDC2626))),
                      ],
                    ),
                  ),
                _buildHeader(provider),
                const SizedBox(height: 32),
                _buildFilterBar(provider),
                const SizedBox(height: 24),
                _buildBackupTable(provider),
                const SizedBox(height: 32),
                _buildFooterInfo(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(UtilityProvider provider) {
    final completedBackups = provider.backups.where((b) => b.status == 'completed').toList();
    final lastBackup = completedBackups.isNotEmpty ? completedBackups.first.createdAt : null;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: const Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(12)),
                        child: const Icon(LucideIcons.database, color: Color(0xFF2563EB), size: 28),
                      ),
                      const SizedBox(width: 16),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Database Backup & Restore', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                          Text('Automated system backups, cloud storage, and one-click recovery.', style: TextStyle(fontSize: 14, color: Color(0xFF64748B))),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: provider.isActionLoading ? null : () => provider.createBackup('manual'),
                        icon: provider.isActionLoading
                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Icon(LucideIcons.play, size: 14),
                        label: const Text('Run Manual Backup'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        onPressed: provider.fetchBackups,
                        icon: const Icon(LucideIcons.refreshCcw, size: 20, color: Color(0xFF64748B)),
                        style: IconButton.styleFrom(
                          padding: const EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: Colors.grey.shade300)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 3.2,
                children: [
                  _statsCard('LAST BACKUP', lastBackup != null ? DateFormat('dd/MM/yyyy').format(lastBackup) : 'Never', LucideIcons.clock),
                  _statsCard('LOCAL STORAGE', 'Active', LucideIcons.hardDrive),
                  _statsCard('CLOUD STORAGE', 'Secure', LucideIcons.cloud, isSpecial: true),
                  _statsCard('BACKUP COUNT', '${provider.backups.length} Files', LucideIcons.fileArchive),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statsCard(String title, String value, IconData icon, {bool isSpecial = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFF1F5F9))),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(icon, size: 14, color: const Color(0xFF64748B)),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5)),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                if (isSpecial) ...[
                  const Icon(LucideIcons.shieldCheck, size: 18, color: Color(0xFF10B981)),
                  const SizedBox(width: 8),
                ],
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isSpecial ? const Color(0xFF10B981) : const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBar(UtilityProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
          child: Row(
            children: ['All', 'Daily', 'Weekly', 'Monthly', 'Manual'].map((type) {
              final isSelected = provider.currentFilter == type;
              return GestureDetector(
                onTap: () => provider.setFilter(type),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: isSelected ? [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)] : null,
                  ),
                  child: Text(
                    type,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: isSelected ? Colors.white : const Color(0xFF64748B)),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const Text(
          'Retention: 7 Daily, 4 Weekly, 12 Monthly',
          style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  Widget _buildBackupTable(UtilityProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  controller: _horizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                      dataRowMinHeight: 60,
                      dataRowMaxHeight: 60,
                      columnSpacing: 24,
                      columns: const [
                        DataColumn(label: Text('BACKUP NAME', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B)))),
                        DataColumn(label: Text('TYPE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B)))),
                        DataColumn(label: Text('SIZE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B)))),
                        DataColumn(label: Text('DURATION', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B)))),
                        DataColumn(label: Text('STATUS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B)))),
                        DataColumn(label: Text('LOCATION', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B)))),
                        DataColumn(label: Text('CREATED AT', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B)))),
                        DataColumn(label: Align(alignment: Alignment.centerRight, child: Text('ACTIONS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B))))),
                      ],
                      rows: provider.backups.map((backup) {
                        return DataRow(
                          cells: [
                            DataCell(Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
                                  child: const Icon(LucideIcons.fileArchive, size: 16, color: Color(0xFF64748B)),
                                ),
                                const SizedBox(width: 12),
                                Text(backup.name, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E293B), fontSize: 14)),
                              ],
                            )),
                            DataCell(_typeBadge(backup.type)),
                            DataCell(Text(_formatSize(backup.size), style: const TextStyle(fontSize: 14, color: Color(0xFF475569)))),
                            DataCell(Text(_getDuration(backup), style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)))),
                            DataCell(_statusBadge(backup.status)),
                            DataCell(_storageIcons(backup)),
                            DataCell(Text(DateFormat('dd/MM/yyyy, HH:mm:ss').format(backup.createdAt), style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)))),
                            DataCell(Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                _actionIcon(LucideIcons.download, const Color(0xFF64748B), () => provider.downloadBackup(backup.id, backup.name)),
                                const SizedBox(width: 8),
                                _actionIcon(LucideIcons.refreshCcw, const Color(0xFF2563EB), () => _confirmRestore(backup.id)),
                                const SizedBox(width: 8),
                                _actionIcon(LucideIcons.trash2, const Color(0xFFEF4444), () => provider.deleteBackup(backup.id)),
                              ],
                            )),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
            if (provider.backups.isEmpty)
              Padding(
                padding: const EdgeInsets.all(64),
                child: Column(
                  children: [
                    const Icon(LucideIcons.alertTriangle, size: 48, color: Color(0xFFE2E8F0)),
                    const SizedBox(height: 16),
                    const Text('No backups found.', style: TextStyle(fontSize: 18, color: Color(0xFF64748B))),
                    TextButton(onPressed: () => provider.createBackup('manual'), child: const Text('Start your first backup now')),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _typeBadge(String type) {
    Color bg = const Color(0xFFF1F5F9);
    Color text = const Color(0xFF64748B);
    if (type == 'daily') {
      bg = const Color(0xFFEFF6FF);
      text = const Color(0xFF2563EB);
    } else if (type == 'weekly') {
      bg = const Color(0xFFFAF5FF);
      text = const Color(0xFF9333EA);
    } else if (type == 'monthly') {
      bg = const Color(0xFFECFDF5);
      text = const Color(0xFF059669);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(100), border: Border.all(color: text.withValues(alpha: 0.1))),
      child: Text(type.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: text, letterSpacing: 0.5)),
    );
  }

  Widget _statusBadge(String status) {
    if (status == 'completed') {
      return Row(children: [const Icon(LucideIcons.checkCircle, size: 14, color: Color(0xFF10B981)), const SizedBox(width: 6), const Text('SUCCESS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF059669)))]);
    } else if (status == 'failed') {
      return Row(children: [const Icon(LucideIcons.xCircle, size: 14, color: Color(0xFFEF4444)), const SizedBox(width: 6), const Text('FAILED', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFDC2626)))]);
    }
    return Row(children: [const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF2563EB))), const SizedBox(width: 6), const Text('IN PROGRESS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)))]);
  }

  Widget _storageIcons(BackupLog backup) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(LucideIcons.hardDrive, size: 14, color: backup.localPath != null ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0)),
        const SizedBox(width: 8),
        Icon(LucideIcons.cloud, size: 14, color: backup.cloudPath != null ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0)),
      ],
    );
  }

  Widget _actionIcon(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }

  Widget _buildFooterInfo() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFDBEAFE))),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(LucideIcons.shieldCheck, color: Color(0xFF2563EB), size: 24),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Backup Protection Active', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))),
                SizedBox(height: 4),
                Text(
                  'Your database is protected by automated daily, weekly, and monthly cycles. Backups are encrypted at rest and replicated to off-site cloud storage. Restoring a backup will override current data; always ensure you have a manual export of your current state before proceeding with a full restoration.',
                  style: TextStyle(fontSize: 13, color: Color(0xFF1E40AF), height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
