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
    this.selectionMode = false,
    this.selected = false,
  });

  final String fileName;
  final double progress;
  final String progressLabel;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  /// When true, a checkbox is shown on the card.
  final bool selectionMode;

  /// Whether this card is currently selected (only shown in selection mode).
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final highlighted = selectionMode && selected;

    return Card(
      clipBehavior: Clip.antiAlias,
      color: highlighted ? theme.colorScheme.secondaryContainer : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: highlighted ? theme.colorScheme.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Stack(
          children: [
            Padding(
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
            if (selectionMode)
              Positioned(
                top: AppSpacing.sm,
                right: AppSpacing.sm,
                child: Icon(
                  selected ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: selected ? theme.colorScheme.primary : theme.colorScheme.outline,
                ),
              ),
          ],
        ),
      ),
    );
  }
}