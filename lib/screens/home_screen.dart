import 'package:file_picker/file_picker.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import '../widgets/pdf_card.dart';
import '../widgets/primary_app_bar.dart';
import '../theme.dart';
import 'pdf_viewer_screen.dart';
import '../database/app_database.dart';
import 'package:pdfrx/pdfrx.dart';

class HomeScreen extends StatelessWidget{
  HomeScreen({super.key});

  final db = AppDatabase();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: PrimaryAppBar(
        title: 'Study Library',
        //this is a placeholder until one exists.
        leading: IconButton(
          icon: const Icon(Icons.menu),
          tooltip: 'Menu',
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            // Search placeholder
            onPressed: () {},
          ),
        ],
      ),
      
      body: StreamBuilder<List<Document>>(
        stream: db.select(db.documents).watch(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!;

          if (docs.isEmpty) {
            return const Center(child: Text('No PDFs imported yet. Tap + to add one'));
          }

          return GridView.count(
            crossAxisCount: 2, 
            childAspectRatio:  1.1,
            padding: const EdgeInsets.all(AppSpacing.md),
            children: docs.map((doc) {
              double progress = doc.totalPages > 0 ? doc.lastPageRead / doc.totalPages : 0.0;
              return PdfCard(
                fileName: doc.fileName,
                progress: progress,
                progressLabel: 'P ${doc.lastPageRead} of ${doc.totalPages} · ${(progress * 100).toInt()}% \nCompleted',
                onTap:(){
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => PdfViewerScreen(documentId: doc.id, title: doc.title, filePath: doc.filePath),)
                  );
                },
              );
            }).toList(),
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () async {
          final files = await FilePicker.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['pdf'],
          );

          if (files.isEmpty){
            return;
          }

          final file = files.first;

          debugPrint('Picked file: ${file.name}');

          if (file.path == null) {
            debugPrint('Could not get file path.');
            return;
          }

          final pdfDoc = await PdfDocument.openFile(file.path!);
          final totalPages = pdfDoc.pages.length;
          await pdfDoc.dispose();

          final document = DocumentsCompanion(
            fileName: Value(file.name),
            title: Value(file.name),
            filePath: Value(file.path!),
            totalPages: Value(totalPages),   // ← new
          );

          await db.into(db.documents).insert(document);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}