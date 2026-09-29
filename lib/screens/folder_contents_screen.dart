import 'package:flutter/material.dart';
import '../database/app_database.dart';
import '../theme.dart';
import '../widgets/pdf_card.dart';
import '../widgets/primary_app_bar.dart';
import 'pdf_viewer_screen.dart';

class FolderContentsScreen extends StatelessWidget {
  const FolderContentsScreen({
    super.key,
    required this.db,
    required this.folderId,
    required this.folderName,
  });

  final AppDatabase db;
  final int folderId;
  final String folderName;

  Future<void> _confirmDelete(BuildContext context, Document doc) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove PDF?'),
        content: Text('"${doc.fileName}" will be removed from your library. The original file on your computer is not affected.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Remove')),
        ],
      ),
    );

    if (confirmed == true) {
      await (db.delete(db.documents)..where((d) => d.id.equals(doc.id))).go();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(title: folderName, onBack: () => Navigator.pop(context)),
      body: StreamBuilder<List<Document>>(
        // Same query as Home, just filtered down to this folder.
        stream: (db.select(db.documents)..where((d) => d.folderId.equals(folderId))).watch(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!;

          if (docs.isEmpty) {
            return const Center(child: Text('No PDFs in this folder yet.'));
          }

          return GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 0.95,
            padding: const EdgeInsets.all(AppSpacing.md),
            children: docs.map((doc) {
              double progress = doc.totalPages > 0 ? doc.lastPageRead / doc.totalPages : 0.0;
              return PdfCard(
                fileName: doc.fileName,
                progress: progress,
                progressLabel: 'Page ${doc.lastPageRead} of ${doc.totalPages}\n${(progress * 100).toInt()}% Completed',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PdfViewerScreen(
                        db: db,
                        documentId: doc.id,
                        title: doc.title,
                        filePath: doc.filePath,
                        initialPage: doc.lastPageRead,
                      ),
                    ),
                  );
                },
                onLongPress: () => _confirmDelete(context, doc),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}