import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../widgets/pdf_card.dart';
import '../theme.dart';
import 'pdf_viewer_screen.dart';
import '../database/app_database.dart';

class HomeScreen extends StatelessWidget{
  HomeScreen({super.key});

  final List<Map<String, dynamic>> documents = [
    {
      'name': 'Organic Chemistry Prelim Reviewer',
      'progress': 1.0,
      'label': 'Completed',
    },
    {
      'name': 'Data Structure and Algorithms Prelim Reviewer',
      'progress': 0.34,
      'label': '34% Completed',
    },
    {
      'name': 'Integral Calculus Prelim Reviewer',
      'progress': 0.99,
      'label': '99% Completed',
    }
  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text('Study Library')),
      body: GridView.count(
        crossAxisCount: 2, 
        childAspectRatio:  1.1,
        padding: const EdgeInsets.all(AppSpacing.md),
        children: documents.map((doc) {
          return PdfCard(
            fileName: doc['name'],
            progress: doc['progress'],
            progressLabel: doc['label'],
            onTap:(){
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => PdfViewerScreen(title: doc['name']),)
              );
            },
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Pick PDF files using file_picker v13 API
          List<PlatformFile> files = await FilePicker.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['pdf'],
          );

          if (files.isNotEmpty) {
            PlatformFile file = files.first;
            debugPrint('Picked file: ');

            // TODO: Save this file into Drift database!
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Import PDF'),
      ),
    );
  }
}
