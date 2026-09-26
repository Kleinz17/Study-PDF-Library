import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; 
import 'theme.dart';
import 'app_shell.dart';
import 'package:pdfrx/pdfrx.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
    pdfrxFlutterInitialize();
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const StudyLibraryApp(),
    ),
  );
}

class StudyLibraryApp extends StatelessWidget {
  const StudyLibraryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Library',
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: appTheme,
      home: const AppShell(),
    );
  }
}