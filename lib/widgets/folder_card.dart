import 'package:flutter/material.dart';
import '../theme.dart';

class FolderCard extends StatelessWidget {
  const FolderCard({
    super.key,
    required this.name,
    required this.pdfCount,
    required this.onTap,
  });

  final String name;
  final int pdfCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Icon(Icons.folder_outlined, color: theme.colorScheme.onPrimaryContainer),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: theme.textTheme.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(pdfCount == 1 ? '1 PDF' : '$pdfCount PDFs', style: theme.textTheme.labelSmall),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}