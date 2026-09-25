import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

class PdfViewerScreen extends StatelessWidget {
  final String title;
  final String filePath; // Add this

  const PdfViewerScreen({
    super.key, 
    required this.title,
    required this.filePath, // Require it in constructor
  });
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      // Use PdfViewer.file for local file paths on desktop/mobile
      body: PdfViewer.file(filePath), 
    );
  }
}