import 'package:flutter/material.dart';
import '../widgets/primary_app_bar.dart';

class KanbanScreen extends StatelessWidget {
  const KanbanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PrimaryAppBar(
        title: 'Kanban Board',
        // '+' action to create a task is wired in Phase 4.
      ),
      body: const Center(child: Text('Kanban Screen')),
    );
  }
}
