import 'package:flutter/material.dart';

class KanbanScreen extends StatelessWidget {
  const KanbanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kanban Study Tasks')),
      body: const Center(child: Text('Kanban Screen')),
    );
  }
}
