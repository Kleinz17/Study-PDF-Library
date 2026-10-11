import 'package:flutter/material.dart';
import '../database/app_database.dart';
import '../theme.dart';
import '../widgets/delete_documents.dart';
import '../widgets/pdf_card.dart';
import '../widgets/primary_app_bar.dart';
import 'pdf_viewer_screen.dart';

class FolderContentsScreen extends StatefulWidget {
  const FolderContentsScreen({
    super.key,
    required this.db,
    required this.folderId,
    required this.folderName,
  });

  final AppDatabase db;
  final int folderId;
  final String folderName;

  @override
  State<FolderContentsScreen> createState() => _FolderContentsScreenState();
}

class _FolderContentsScreenState extends State<FolderContentsScreen> {
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
    final deleted = await confirmAndDeleteDocuments(context, widget.db, toDelete);
    if (deleted && mounted) _clearSelection();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Document>>(
      // Same query as Home, just filtered down to this folder.
      stream: (widget.db.select(widget.db.documents)..where((d) => d.folderId.equals(widget.folderId))).watch(),
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
                : PrimaryAppBar(title: widget.folderName, onBack: () => Navigator.pop(context)),
            body: !snapshot.hasData
                ? const Center(child: CircularProgressIndicator())
                : docs.isEmpty
                    ? const Center(child: Text('No PDFs in this folder yet.'))
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
                                    db: widget.db,
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
          ),
        );
      },
    );
  }
}