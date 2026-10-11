import 'package:file_picker/file_picker.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import '../widgets/delete_documents.dart';
import '../widgets/pdf_card.dart';
import '../widgets/primary_app_bar.dart';
import '../theme.dart';
import 'pdf_viewer_screen.dart';
import '../database/app_database.dart';
import 'package:pdfrx/pdfrx.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.db});

  final AppDatabase db;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AppDatabase get db => widget.db;

  final Set<int> _selectedIds = {};

  bool get _selecting => _selectedIds.isNotEmpty;

  void _toggle(int id) {
    setState(() {
      if (!_selectedIds.remove(id)) _selectedIds.add(id);
    });
  }

  void _clearSelection() => setState(_selectedIds.clear);

  Future<void> _deleteSelected(List<Document> docs) async {
    final toDelete = docs.where((d) => _selectedIds.contains(d.id)).toList();
    final deleted = await confirmAndDeleteDocuments(context, db, toDelete);
    if (deleted && mounted) _clearSelection();
  }

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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Document>>(
      stream: db.select(db.documents).watch(),
      builder: (context, snapshot) {
        final docs = snapshot.data ?? const <Document>[];
        final allSelected = docs.isNotEmpty && docs.every((d) => _selectedIds.contains(d.id));

        return PopScope(
          canPop: !_selecting,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _clearSelection();
          },
          child: Scaffold(
            appBar: _selecting
                ? PrimaryAppBar(
                    title: '${_selectedIds.length} selected',
                    leading: IconButton(
                      icon: const Icon(Icons.close),
                      tooltip: 'Cancel selection',
                      onPressed: _clearSelection,
                    ),
                    actions: [
                      IconButton(
                        icon: Icon(allSelected ? Icons.deselect : Icons.select_all),
                        tooltip: allSelected ? 'Deselect all' : 'Select all',
                        onPressed: () => setState(() {
                          if (allSelected) {
                            _selectedIds.clear();
                          } else {
                            _selectedIds.addAll(docs.map((d) => d.id));
                          }
                        }),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        tooltip: 'Delete selected',
                        onPressed: () => _deleteSelected(docs),
                      ),
                    ],
                  )
                : PrimaryAppBar(
                    title: 'Study Library',
                    leading: IconButton(icon: const Icon(Icons.menu), tooltip: 'Menu', onPressed: () {}),
                    actions: [
                      IconButton(icon: const Icon(Icons.search), tooltip: 'Search', onPressed: () {}),
                    ],
                  ),
            body: !snapshot.hasData
                ? const Center(child: CircularProgressIndicator())
                : docs.isEmpty
                    ? const Center(child: Text('No PDFs imported yet. Tap + to add one'))
                    : GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 0.95,
                        padding: const EdgeInsets.all(AppSpacing.md),
                        children: docs.map((doc) {
                          double progress = doc.totalPages > 0 ? doc.lastPageRead / doc.totalPages : 0.0;
                          return PdfCard(
                            fileName: doc.fileName,
                            progress: progress,
                            progressLabel: 'Page ${doc.lastPageRead} of ${doc.totalPages}\n${(progress * 100).toInt()}% Completed',
                            selectionMode: _selecting,
                            selected: _selectedIds.contains(doc.id),
                            onTap: () {
                              if (_selecting) {
                                _toggle(doc.id);
                                return;
                              }
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
                            onLongPress: () => _toggle(doc.id),
                          );
                        }).toList(),
                      ),
          floatingActionButton: _selecting ? null : FloatingActionButton(
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

              final existing = await (db.select(db.documents)
                    ..where((d) => d.filePath.equals(file.path!)))
                  .get();

              if (existing.isNotEmpty) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('"${file.name}" is already in your library.')),
                );
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
          ),
        );
      },
    );
  }
}