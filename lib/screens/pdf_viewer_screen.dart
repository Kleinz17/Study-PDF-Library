import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:drift/drift.dart';
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


  void _onPageChanged(int? pageNumber) {
    if (pageNumber == null) return;
    (widget.db.update(widget.db.documents)     
          ..where((d) => d.id.equals(widget.documentId)))
        .write(DocumentsCompanion(lastPageRead: Value(pageNumber)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: PdfViewer.file(
        widget.filePath,
        initialPageNumber: widget.initialPage,
        params: PdfViewerParams(onPageChanged: _onPageChanged),
      ),
    );
  }
}