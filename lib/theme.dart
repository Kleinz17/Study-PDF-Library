import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;

}

//Kanban status colors
class StatusColors {
  static const toStudy = Color(0xFF31628D);
  static const inProgress = Color(0xFF695779);
  static const revision = Color(0xFF526070);
  static const completed = Color(0xFF5D5E61);

}

final appTheme = ThemeData(
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF31628D), // colorScheme.primary
    foregroundColor: Colors.white,      // colorScheme.onPrimary — title/icon color
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  ),

  useMaterial3: true,
  fontFamily: GoogleFonts.inter().fontFamily,
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF31628D),
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFCFE5FF),
    onPrimaryContainer: Color(0xFF124A73),
    secondary: Color(0xFF526070),
    onSecondary: Colors.white,
    tertiary: Color(0xFF695779),
    onTertiary: Colors.white,
    surface: Colors.white,
    onSurface: Color(0xFF181C20),
    error: Color(0xFFBA1A1A),
    onError: Colors.white,
  ),

  scaffoldBackgroundColor: const Color(0xFFF7F9FF),
  textTheme: const TextTheme(
    headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    labelSmall: TextStyle(fontSize: 12, color: Color(0xFF526070), fontWeight: FontWeight.bold),
  ),

  cardTheme: const CardThemeData(
    margin: EdgeInsets.all(AppSpacing.sm),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),

  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
  ),

  
  navigationBarTheme: NavigationBarThemeData(
    indicatorColor: Colors.transparent,
    iconTheme: WidgetStateProperty.resolveWith((states) {
      return IconThemeData(
        color: states.contains(WidgetState.selected)
            ? const Color(0xFF31628D)  // primary
            : const Color(0xFF526070), // secondary — your muted/inactive color
      );
    }),
    labelTextStyle: WidgetStateProperty.resolveWith((states) {
      return TextStyle(
        fontSize: 12,
        color: states.contains(WidgetState.selected)
            ? const Color(0xFF31628D)
            : const Color(0xFF526070),
      );
    }),
  ),

);

final darkColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFF42A5F5), // same brand seed as the light scheme
  brightness: Brightness.dark,
);

final darkAppTheme = ThemeData(
  useMaterial3: true,
  fontFamily: GoogleFonts.inter().fontFamily,
  colorScheme: darkColorScheme,
  scaffoldBackgroundColor: darkColorScheme.surface,
  textTheme: TextTheme(
    headlineSmall: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    bodyMedium: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    labelSmall: TextStyle(fontSize: 12, color: darkColorScheme.onSurfaceVariant, fontWeight: FontWeight.bold),
  ),
  cardTheme: const CardThemeData(
    margin: EdgeInsets.all(AppSpacing.sm),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
  ),
  filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48))),
  appBarTheme: AppBarTheme(
    backgroundColor: darkColorScheme.primary,
    foregroundColor: darkColorScheme.onPrimary,
    titleTextStyle: TextStyle(color: darkColorScheme.onPrimary, fontSize: 18, fontWeight: FontWeight.bold),
  ),
  navigationBarTheme: NavigationBarThemeData(
    indicatorColor: Colors.transparent,
    iconTheme: WidgetStateProperty.resolveWith((states) => IconThemeData(
          color: states.contains(WidgetState.selected) ? darkColorScheme.primary : darkColorScheme.onSurfaceVariant,
        )),
    labelTextStyle: WidgetStateProperty.resolveWith((states) => TextStyle(
          fontSize: 12,
          color: states.contains(WidgetState.selected) ? darkColorScheme.primary : darkColorScheme.onSurfaceVariant,
        )),
  ),
);


