import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/folders_screen.dart';
import 'screens/kanban_screen.dart';
import 'screens/settings_screen.dart';
import 'widgets/app_bottom_nav.dart';

/// Owns the selected tab and swaps between the 4 main screens.
/// The PDF Viewer is pushed on top of this (via Navigator.push from
/// HomeScreen), so it isn't one of the tabs and has no bottom nav.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  void _goToTab(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    // IndexedStack keeps each screen's state alive when switching tabs
    // (e.g. Folders' scroll position isn't lost when you check Settings).
    final screens = [
      HomeScreen(),
      const FoldersScreen(),
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
