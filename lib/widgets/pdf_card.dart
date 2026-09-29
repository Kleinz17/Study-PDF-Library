import 'package:flutter/material.dart';
import '../theme.dart';

class PdfCard extends StatelessWidget {
  const PdfCard({
    super.key,
    required this.fileName,
    required this.progress,
    required this.progressLabel,
    required this.onTap,
    this.onLongPress,
  });

  final String fileName;
  final double progress;
  final String progressLabel;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(color: theme.colorScheme.primaryContainer, borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Icon(Icons.description_outlined, color: theme.colorScheme.onPrimaryContainer),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(fileName, style: theme.textTheme.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
              SizedBox(height: AppSpacing.sm),
              Text(progressLabel, style: theme.textTheme.labelSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
              SizedBox(height: AppSpacing.sm),
              LinearProgressIndicator(value: progress),
            ],
          ),
        ),
      ),
    );
  }
}