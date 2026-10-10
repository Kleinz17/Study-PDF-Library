# Design system

[Design system (PDF)](assets/design-system.pdf)

Study PDF Library uses a clean, minimalist interface that helps students organize and access their study materials without unnecessary visual distractions. The design focuses on readability, consistency and ease of navigation, using light blue accents, rounded components, spacious layouts and Material Design principles. The app is designed primarily for **Light Mode**, while remaining adaptable for a future Dark Mode.

## Palette

The palette is a `ColorScheme` seeded with `ColorScheme.fromSeed` using the brand color from Figma, **`#42A5F5`**, generated with Google's Material Theme Builder (exported from the Figma plugin, not hand-approximated). The algorithm outputs a full role set and computes each "on" color to guarantee contrast.

| Role | Hex | Used for |
|---|---|---|
| `primary` | `#31628D` | App bar, floating action button, active nav state, primary buttons, progress fill |
| `onPrimary` | `#FFFFFF` | Text and icons on primary (6.44:1) |
| `primaryContainer` | `#CFE5FF` | Light tint for icon badges and PDF thumbnail background. **Not** used as a fill against the page background: it measures only 1.22:1 against it and would disappear |
| `onPrimaryContainer` | `#124A73` | Icon color on `primaryContainer` (7.24:1) |
| `secondary` | `#526070` | Muted text/icons: captions, inactive bottom-nav labels, folder counts (6.11:1 on background) |
| `tertiary` | `#695779` | Third distinct accent, Kanban "In Progress" only |
| `background` | `#F7F9FF` | Main screen background |
| `surface` (card) | `#FFFFFF` | PDF cards, folder cards, dialogs. Kept as pure white (Material's `surfaceContainerLowest`) rather than the flat `surface` token, which the generator sets equal to background and would erase the card-vs-page distinction the app relies on |
| `onSurface` / text | `#181C20` | Titles, labels, body text (16.3:1) |
| `error` | `#BA1A1A` | Validation and destructive actions **only**, never reused for status or decoration |
| `onError` | `#FFFFFF` | Text/icons on error (6.46:1) |

**Contrast checks**

- Body text: `#181C20` on `#F7F9FF` → 16.3:1, passes
- White text on primary: `#FFFFFF` on `#31628D` → 6.44:1, passes (4.5:1 required)

### Kanban status colors

The four statuses reuse roles already in the generated scheme, plus one neutral tone from the same palette. Nothing here is a brand-new color decision.

| Status | Color | Hex | Contrast (white text/icon) |
|---|---|---|---|
| To Study | `primary` | `#31628D` | 6.44:1 |
| In Progress | `tertiary` | `#695779` | 6.48:1 |
| Revision | `secondary` | `#526070` | 6.43:1 |
| Completed | neutral (tone 40) | `#5D5E61` | 6.48:1 |

**Theme:** light only for the MVP. Dark mode stays a stretch goal. Until then, the one rule is: never hardcode a color outside this file.

## Type scale

Mapped onto `TextTheme` slots. Font family is **Roboto** (Flutter's Material default).

| Role | `TextTheme` slot | Size / weight | Used for |
|---|---|---|---|
| Heading | `headlineSmall` | 24px, Bold | Screen titles |
| Body | `bodyMedium` | 16px, Regular | PDF/folder names, body text |
| Caption | `labelSmall` | 12px, Regular | Progress, hints, page numbers |

Examples: "Study Library" (heading), "Calculus.pdf" (body), "Page 12 of 17 • 70%" (caption).

Styles are always used by name, e.g. `Theme.of(context).textTheme.headlineSmall`, never a literal `fontSize:` in a widget.

## Spacing

Defined as constants in `AppSpacing` (`lib/theme.dart`).

| Token | Value | Used for |
|---|---|---|
| `xs` | 4px | Icon-to-label gaps (bottom nav, status dots) |
| `sm` | 8px | Tight spacing, inside cards |
| `md` | 16px | Standard spacing, gap between cards/list items |
| `lg` | 24px | Screen edge padding, gap between sections |

## Components

Every piece that repeats across the wireframes and mockup, matched to a real file and constructor. Each takes data and callbacks only, with no internal `setState`.

| Component | File | Constructor parameters | Appears on |
|---|---|---|---|
| `PdfCard` | `lib/widgets/pdf_card.dart` | `String fileName`, `double progress`, `String progressLabel`, `VoidCallback onTap` | Home Library, Folders (filtered view) |
| `FolderCard` | `lib/widgets/folder_card.dart` | `String name`, `int pdfCount`, `VoidCallback onTap` | Courses / Folders |
| `PrimaryAppBar` | `lib/widgets/primary_app_bar.dart` | `String title`, `VoidCallback? onBack`, `List<Widget>? actions` | All 5 screens |
| `AppBottomNav` | `lib/widgets/app_bottom_nav.dart` | `int currentIndex`, `ValueChanged<int> onTap` | Home, Folders, Kanban, Settings (not PDF View) |
| `PrimaryFab` | `lib/widgets/primary_fab.dart` | `VoidCallback onPressed`, `IconData icon` | Home Library only (corrected from v1, see below) |
| `KanbanStatusSection` | `lib/widgets/kanban_status_section.dart` | `String label`, `Color dotColor`, `int count`, `bool expanded`, `List<Widget> children`, `VoidCallback onToggle` | Kanban Board (×4 per screen) |
| `TaskListItem` | `lib/widgets/task_list_item.dart` | `String taskTitle`, `String linkedFileName`, `VoidCallback onTap` | Kanban Board (repeated within sections) |
| `SettingsListItem` | `lib/widgets/settings_list_item.dart` | `String label`, `IconData icon`, `Widget trailing` | Settings (repeated per row) |
| `PrimaryButton` | `lib/widgets/primary_button.dart` | `String label`, `VoidCallback? onPressed` | New Folder dialog, New Task dialog |
| `EmptyState` | `lib/widgets/empty_state.dart` | `String message`, `IconData icon` | Home Library, Folders (before any import) |

## Theme file

Values verified via Google's Material Theme Builder, seed `#42A5F5`.

```dart
// lib/theme.dart
import 'package:flutter/material.dart';

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
}

// Kanban status colors — reuse existing scheme roles, nothing invented
class StatusColors {
  static const toStudy = Color(0xFF31628D);    // = colorScheme.primary
  static const inProgress = Color(0xFF695779); // = colorScheme.tertiary
  static const revision = Color(0xFF526070);   // = colorScheme.secondary
  static const completed = Color(0xFF5D5E61);  // neutral tone 40
}

final appTheme = ThemeData(
  useMaterial3: true,
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
    bodyMedium: TextStyle(fontSize: 16),
    labelSmall: TextStyle(fontSize: 12, color: Color(0xFF526070)),
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
);
```

## Changes since the last version

| Element | Prelim said | Now says | Why it changed |
|---|---|---|---|
| Primary color | `#42A5F5`, used directly for the app bar, FAB and primary buttons, implying white icons/text on top (the standard Material pattern) | Ran the color through Google's Material Theme Builder (via the Figma plugin, exported as JSON) instead of hand-picking a fix. It generated primary `#31628D`, verified to pass white-text contrast at 6.44:1 | The prelim picked a color that looked right but was never contrast-checked. This pass required checking it, and it failed until I used the real current tool instead of an approximation |
| Kanban status colors | Not defined. The wireframe was plain text, so no color decision existed yet | Painting the actual mockup showed four status colors are needed, and my first attempt invented three new hex values by hand. Replaced with roles the seed algorithm already generated (primary, secondary, tertiary) plus one neutral tone, so every status color traces back to the single brand seed | A gap that only showed up once real screens were painted. The fix is more defensible sourced from the same generator than invented per color |
| Secondary / accent role | `#90CAF9`, a light pastel blue used for "highlights, selected items, progress indicators" | The generated secondary (`#526070`) is a muted slate, not a light highlight. Reassigned it to muted text/captions/inactive icons (where it measures 6.11:1 and works well), and moved progress-bar fill to reuse primary directly | Swapping the hex without checking what the role actually looked like would have quietly broken every progress bar in the app |
| Type & spacing | Stated as a values table (24/16/12, 8/16/24) with no Flutter object behind it | Mapped directly onto `TextTheme` slots (`headlineSmall`/`bodyMedium`/`labelSmall`) and an `AppSpacing` constants class, the same pattern required in m4a3. Added `xs = 4` for icon-to-label gaps (bottom nav, status dots) that came up while building the mockup and had no defined value before | The values didn't change much, but now they're something a widget can reference by name instead of a hardcoded number |
| `PrimaryFab` placement | (v1) | Home Library only | Corrected from v1 |
