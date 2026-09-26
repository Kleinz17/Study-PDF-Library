import 'package:flutter/material.dart';
import '../widgets/primary_app_bar.dart';

class FoldersScreen extends StatelessWidget {
  const FoldersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PrimaryAppBar(
        title: 'Folders',
        // '+' action to create a folder is wired in Phase 3.
      ),
      body: const Center(child: Text('Folders Screen')),
    );
  }
}
