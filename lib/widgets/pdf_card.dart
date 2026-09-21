import 'package:flutter/material.dart';
import '../theme.dart';

class PdfCard extends StatelessWidget {
  const PdfCard(
    {
      super.key,
      required this.fileName,
      required this.progress,
      required this.progressLabel,
      required this.onTap,
    }
  );

  final String fileName;
  final double progress;
  final String progressLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context){
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //icon badge
              Container(
                decoration: BoxDecoration(color: theme.colorScheme.primaryContainer, borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Icon(Icons.description_outlined, color: theme.colorScheme.onPrimaryContainer),
              ),
              SizedBox(height: AppSpacing.sm), //spacing
              //file name
              Text(fileName, style: theme.textTheme.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
              SizedBox(height: AppSpacing.sm), //spacing
              //progress label
              Text(progressLabel, style: theme.textTheme.labelSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
              SizedBox(height: AppSpacing.sm), //spacing
              //progress bar
              LinearProgressIndicator(value: progress),
            ]          
          )
        )
      ),
    );
  }
}