import 'package:file_picker/file_picker.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import '../widgets/pdf_card.dart';
import '../widgets/primary_app_bar.dart';
import '../theme.dart';
import 'pdf_viewer_screen.dart';
import '../database/app_database.dart';
import 'package:pdfrx/pdfrx.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.db});

  final AppDatabase db;

  /// Shows semesters as headers with their subjects as choices, plus a
  /// "no folder" option. Returns the chosen folderId, or null for no folder.
  Future<int?> _pickFolder(BuildContext context) async {
    final folders = await db.select(db.folders).get();
    final semesters = folders.where((f) => f.parentId == null).toList();

    if (semesters.isEmpty) {
      // No folders exist yet, so there's nothing to choose from.
      return null;
    }

    if (!context.mounted) return null;

    return showDialog<int?>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Add to folder'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('No folder (just the Library)'),
          ),
          for (final semester in semesters) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(semester.name.toUpperCase(), style: Theme.of(context).textTheme.labelSmall),
            ),
            for (final subject in folders.where((f) => f.parentId == semester.id))
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, subject.id),
                child: Text(subject.name),
              ),
          ],
        ],
      ),
    );
  }

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
      appBar: PrimaryAppBar(
        title: 'Study Library',
        leading: IconButton(icon: const Icon(Icons.menu), tooltip: 'Menu', onPressed: () {}),
        actions: [
          IconButton(icon: const Icon(Icons.search), tooltip: 'Search', onPressed: () {}),
        ],
      ),
      body: StreamBuilder<List<Document>>(
        stream: db.select(db.documents).watch(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!;

          if (docs.isEmpty) {
            return const Center(child: Text('No PDFs imported yet. Tap + to add one'));
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
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () async {
          final files = await FilePicker.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['pdf'],
          );

          if (files.isEmpty) return;

          final file = files.first;
          debugPrint('Picked file: ${file.name}');

          if (file.path == null) {
            debugPrint('Could not get file path.');
            return;
          }

          final pdfDoc = await PdfDocument.openFile(file.path!);
          final totalPages = pdfDoc.pages.length;
          await pdfDoc.dispose();

          if (!context.mounted) return;
          final folderId = await _pickFolder(context);

          final document = DocumentsCompanion(
            fileName: Value(file.name),
            title: Value(file.name),
            filePath: Value(file.path!),
            totalPages: Value(totalPages),
            folderId: Value(folderId),
          );

          await db.into(db.documents).insert(document);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}