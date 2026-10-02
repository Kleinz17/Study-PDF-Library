import 'package:flutter/material.dart';
import '../theme.dart';

class TaskListItem extends StatelessWidget {
  const TaskListItem({
    super.key,
    required this.title,
    this.pdfFileName,
    required this.status,
    required this.onStatusChanged,
    required this.onDelete,
    required this.onEdit,
  });

  final String title;
  final String? pdfFileName;
  final String status;
  final ValueChanged<String> onStatusChanged;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  static const statuses = ['To Study', 'In Progress', 'Revision', 'Completed'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, size: 20),
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                    const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
                  ],
                  onSelected: (value) {
                    if (value == 'edit') onEdit();
                    if (value == 'delete') onDelete();
                  },
                ),
              ],
            ),
            if (pdfFileName != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  const Icon(Icons.picture_as_pdf, size: 14, color: Colors.red),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      pdfFileName!,
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    status,
                    style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
                DropdownButton<String>(
                  value: statuses.contains(status) ? status : statuses.first,
                  isDense: true,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.arrow_drop_down, size: 18),
                  items: statuses.map((s) => DropdownMenuItem(value: s, child: Text(s, style: theme.textTheme.bodySmall))).toList(),
                  onChanged: (newStatus) {
                    if (newStatus != null && newStatus != status) {
                      onStatusChanged(newStatus);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

