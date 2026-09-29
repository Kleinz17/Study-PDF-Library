import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/folders_screen.dart';
import 'screens/kanban_screen.dart';
import 'screens/settings_screen.dart';
import 'widgets/app_bottom_nav.dart';
import 'database/app_database.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;
  final db = AppDatabase();   // ← ADD: one instance for the whole app session

  void _goToTab(int index) => setState(() => _currentIndex = index);

  @override
  void dispose() {            // ← ADD: this whole method
    db.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(db: db),                          // ← CHANGE: was HomeScreen()
      FoldersScreen(db: db),
      const KanbanScreen(),
      SettingsScreen(onGoHome: () => _goToTab(0)),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onTap: _goToTab,
      ),
    );
  }
}