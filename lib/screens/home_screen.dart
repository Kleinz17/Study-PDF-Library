import 'package:file_picker/file_picker.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import '../widgets/pdf_card.dart';
import '../theme.dart';
import 'pdf_viewer_screen.dart';
import '../database/app_database.dart';

class HomeScreen extends StatelessWidget{
  HomeScreen({super.key});

  final db = AppDatabase();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text('Study Library')),
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
                progressLabel: '${(progress * 100).toInt()}% Completed',
                onTap:(){
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => PdfViewerScreen(title: doc.title, filePath: doc.filePath),)
                  );
                },
              );
            }).toList(),
          );
        }
      ),
      floatingActionButton: FloatingActionButton.extended(
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
            final document = DocumentsCompanion(
              fileName: Value(file.name),
              title: Value(file.name),
              filePath: Value(file.path!),
            );

          await db.into(db.documents).insert(document);
        },
        icon: const Icon(Icons.add),
        label: const Text('Import PDF'),
      ),
    );
  }
}
