import 'package:flutter/material.dart';
import '../widgets/primary_app_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.onGoHome});

  /// Mockup shows a home icon here (not a back arrow) that jumps
  /// straight to the Home tab, distinct from normal "go back" behavior.
  final VoidCallback onGoHome;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        title: 'Settings',
        leading: IconButton(
          icon: const Icon(Icons.home_outlined),
          tooltip: 'Home',
          onPressed: onGoHome,
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(Icons.settings),
          ),
        ],
      ),
      // Settings rows (Dark Mode, Study Reminders, etc.) are Phase 5.
      body: const Center(child: Text('Settings Screen')),
    );
  }
}
