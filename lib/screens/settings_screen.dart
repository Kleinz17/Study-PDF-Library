import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/primary_app_bar.dart';
import '../widgets/settings_list_item.dart';
import '../theme.dart';
import '../theme_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.onGoHome});

  final VoidCallback onGoHome;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _remindersOn = false; // local only — no real scheduling behind this yet

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        title: 'Settings',
        leading: IconButton(icon: const Icon(Icons.home_outlined), tooltip: 'Home', onPressed: widget.onGoHome),
      ),
      body: ValueListenableBuilder<ThemeMode>(
        valueListenable: themeModeNotifier,
        builder: (context, mode, _) {
          return ListView(
            children: [
              SettingsListItem(
                label: 'Dark Mode',
                icon: Icons.dark_mode_outlined,
                trailing: Switch(
                  value: mode == ThemeMode.dark,
                  onChanged: _setDarkMode,
                ),
              ),
              SettingsListItem(
                label: 'Study Reminders',
                icon: Icons.notifications_outlined,
                trailing: Switch(
                  value: _remindersOn,
                  onChanged: (on) => setState(() => _remindersOn = on),
                ),
              ),
              SettingsListItem(
                label: 'About',
                icon: Icons.info_outline,
                trailing: const Icon(Icons.chevron_right),
                onTap: () => showAboutDialog(
                  context: context,
                  applicationName: 'Study PDF Library',
                  applicationVersion: '1.0.0',
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _setDarkMode(bool enabled) async {
    final mode = enabled ? ThemeMode.dark : ThemeMode.light;

    try {
      final saved = await ThemePreferences.saveThemeMode(mode);
      if (!mounted) return;

      if (!saved) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not save the theme preference.')),
        );
        return;
      }

      themeModeNotifier.value = mode;
    } on PlatformException catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not save the theme preference: ${error.message ?? error.code}',
          ),
        ),
      );
    }
  }
}
