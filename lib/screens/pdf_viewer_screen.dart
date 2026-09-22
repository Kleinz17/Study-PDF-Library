import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

class PdfViewerScreen extends StatelessWidget {
  final String title;

  const PdfViewerScreen({super.key, required this.title});
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      //pdfViewer.url loads pdf from network URL
      body: PdfViewer.asset('assets/dummy.pdf'),
    );
  }
}