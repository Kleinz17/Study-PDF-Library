import 'package:flutter/material.dart';
import '../widgets/pdf_card.dart';
import '../theme.dart';
import 'pdf_viewer_screen.dart';

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
              //Navigate to PDF viewer (dummy pdf)
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => PdfViewerScreen(title: doc['name']),)
              );
            },
          );
        }).toList()
      ),
    );
  }
}