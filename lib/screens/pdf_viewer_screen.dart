import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:drift/drift.dart' hide Column;
import '../database/app_database.dart';

class PdfViewerScreen extends StatefulWidget {
  const PdfViewerScreen({
    super.key,
    required this.db,
    required this.documentId,
    required this.title,
    required this.filePath,
    this.initialPage = 1,
  });

  final AppDatabase db;
  final int documentId;
  final String title;
  final String filePath;
  final int initialPage;

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  final _controller = PdfViewerController();
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
  }

  void _onPageChanged(int? pageNumber) {
    if (pageNumber == null) return;
    setState(() => _currentPage = pageNumber);
    (widget.db.update(widget.db.documents)
          ..where((d) => d.id.equals(widget.documentId)))
        .write(DocumentsCompanion(lastPageRead: Value(pageNumber)));
  }

  Future<void> _toggleBookmark(List<Bookmark> bookmarks) async {
    final existing = bookmarks.where((b) => b.pageNumber == _currentPage);

    if (existing.isNotEmpty) {
      // Already bookmarked — tapping again just removes it, no label needed.
      await (widget.db.delete(widget.db.bookmarks)..where((b) => b.id.equals(existing.first.id))).go();
      return;
    }

    final label = await showDialog<String>(
      context: context,
      builder: (context) => _BookmarkLabelDialog(pageNumber: _currentPage),
    );
    if (label == null) return; // cancelled

    await widget.db.into(widget.db.bookmarks).insert(
          BookmarksCompanion(
            pageNumber: Value(_currentPage),
            documentId: Value(widget.documentId),
            note: Value(label.trim().isEmpty ? null : label.trim()),
          ),
        );
  }

  void _showBookmarksSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        // Own stream, so a delete here updates the sheet immediately
        // instead of waiting for it to be reopened.
        return StreamBuilder<List<Bookmark>>(
          stream: (widget.db.select(widget.db.bookmarks)..where((b) => b.documentId.equals(widget.documentId))).watch(),
          builder: (context, snapshot) {
            final bookmarks = snapshot.data ?? [];
            if (bookmarks.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(24),
                child: Text('No bookmarks yet. Tap the bookmark icon while reading to save a page.'),
              );
            }
            final sorted = [...bookmarks]..sort((a, b) => a.pageNumber.compareTo(b.pageNumber));
            return ListView(
              shrinkWrap: true,
              children: sorted.map((b) {
                return ListTile(
                  leading: const Icon(Icons.bookmark),
                  title: Text(b.note?.isNotEmpty == true ? b.note! : 'Page ${b.pageNumber}'),
                  subtitle: b.note?.isNotEmpty == true ? Text('Page ${b.pageNumber}') : null,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async {
                      await (widget.db.delete(widget.db.bookmarks)..where((row) => row.id.equals(b.id))).go();
                    },
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _controller.goToPage(pageNumber: b.pageNumber);
                  },
                );
              }).toList(),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Bookmark>>(
      stream: (widget.db.select(widget.db.bookmarks)..where((b) => b.documentId.equals(widget.documentId))).watch(),
      builder: (context, snapshot) {
        final bookmarks = snapshot.data ?? [];
        final isBookmarked = bookmarks.any((b) => b.pageNumber == _currentPage);

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            actions: [
              IconButton(
                icon: const Icon(Icons.list),
                tooltip: 'Bookmarks',
                onPressed: _showBookmarksSheet,
              ),
              IconButton(
                icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
                tooltip: isBookmarked ? 'Remove bookmark' : 'Bookmark this page',
                onPressed: () => _toggleBookmark(bookmarks),
              ),
            ],
          ),
          body: PdfViewer.file(
            widget.filePath,
            controller: _controller,
            initialPageNumber: widget.initialPage,
            params: PdfViewerParams(onPageChanged: _onPageChanged),
          ),
        );
      },
    );
  }
}

class _BookmarkLabelDialog extends StatefulWidget {
  const _BookmarkLabelDialog({required this.pageNumber});

  final int pageNumber;

  @override
  State<_BookmarkLabelDialog> createState() => _BookmarkLabelDialogState();
}

class _BookmarkLabelDialogState extends State<_BookmarkLabelDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Bookmark page ${widget.pageNumber}'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        maxLength: 60,
        decoration: const InputDecoration(labelText: 'Label (optional)', hintText: 'e.g. Chain Rule'),
        onSubmitted: (value) => Navigator.pop(context, value),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        TextButton(onPressed: () => Navigator.pop(context, _controller.text), child: const Text('Save')),
      ],
    );
  }
}