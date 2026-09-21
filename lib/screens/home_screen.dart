import 'package:flutter/material.dart';
import '../widgets/pdf_card.dart';
import '../theme.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text('Study Library')),
      body: GridView.count(
        crossAxisCount: 2, 
        childAspectRatio:  1.1,
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          PdfCard(
            fileName: "Chemistry", 
            progress: 1, 
            progressLabel: "spark completed", 
            onTap:() {},
          ),
          PdfCard(
            fileName: "Chemistry", 
            progress: 0.5, 
            progressLabel: "spark completed", 
            onTap:() {},
          ),
          PdfCard(
            fileName: "Chemistry", 
            progress: 0.7, 
            progressLabel: "spark completed", 
            onTap:() {},
          ),
          PdfCard(
            fileName: "Chemistry", 
            progress: 0.5, 
            progressLabel: "spark completed", 
            onTap:() {},
          ),
          PdfCard(
            fileName: "Chemistry", 
            progress: 0.45, 
            progressLabel: "spark completed", 
            onTap:() {},
          ),
          PdfCard(
            fileName: "Chemistry", 
            progress: 1, 
            progressLabel: "spark completed", 
            onTap:() {},
          ),
        ]
      )
    );
  }
}