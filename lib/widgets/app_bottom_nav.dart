import 'package:flutter/material.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      destinations: const [
        NavigationDestination(icon: Icon(Icons.library_books), label: 'Library'),
        NavigationDestination(icon: Icon(Icons.folder), label: 'Folders'),
        NavigationDestination(icon: Icon(Icons.task), label: 'Kanban'),
        NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
      ],
    );
  }
}
