# Study PDF Library

**Live demo:** https://github.com/your-username/Study-PDF-Library  
**Course:** Applications Development and Emerging Technologies (6ADET), Holy Angel University  
**Author:** Kleinz17 

---

## 1. Overview

Study PDF Library is a mobile-responsive Flutter study pdf reader app designed for students and self-learners to organize course review materials, track reading progress, and read PDF review documents seamlessly. It provides a clean, minimalist interface and simplistic design principles with custom theme roles and progress indicators.

---

## 2. Setup and installation

Follow these steps to get the app running from scratch:

- **Flutter & Dart Versions:** Built with Flutter 3.44.8 (Dart 3.12.2).
- **Clone the repository:**
  ```bash
  git clone https://github.com/your-username/Study-PDF-Library.git
  cd Study-PDF-Library
  ```
- **Install dependencies:**
  ```bash
  flutter pub get
  ```
- **Configuration:**
  This project reads configuration from a `.env` file (if required for backend or API extensions). Copy `.env.example` to `.env` and fill in any placeholder values:
  ```bash
  cp .env.example .env
  ```
  *(Placeholder example: `EXAMPLE_API_KEY=your_api_key_here` — never commit real secrets).*

---

## 3. How to run it

Run the app using the following command:

```bash
flutter run -d chrome
```
or

```bash
flutter run -d chrome --web-port 8080
```

When running successfully, you should see the `device_preview` phone frame wrapping the **Study Library Home Screen**, displaying reviewer cards with progress indicators, which you can tap to open the PDF Viewer.

---

## 4. Features and usage

Walk through the primary user flow, screen by screen:

1. **Home Screen (Library):**
   - Displays a grid of study PDF review cards (e.g., Organic Chemistry, Data Structures, Integral Calculus).
   - Each card shows the file title, status badge, progress percentage, and a `LinearProgressIndicator`.
   - Tapping any card navigates to the PDF Viewer.
2. **PDF Viewer Screen:**
   - Renders the selected PDF document utilizing the `pdfrx` package (`PdfViewer.asset`).
   - Allows users to read and navigate study materials directly within the app.
3. **Additional Screens & Components (Stubs / Navigation):**
   - Folders Screen, Kanban Study Task Board, and Settings Screen stubs are wired up with M3 design components (`AppBottomNav`, `PrimaryAppBar`, `PrimaryFab`, etc.).

---

## 5. Project structure

A short map of the `lib/` directory and key files:

```text
lib/
├── main.dart                  # App entry point with DevicePreview configuration
├── theme.dart                 # Material 3 theme, AppSpacing, and StatusColors definitions
├── screens/
│   ├── home_screen.dart       # Main library grid view with document cards
│   ├── pdf_viewer_screen.dart # PDF document reader screen using pdfrx
│   ├── folders_screen.dart    # Folders management screen stub
│   ├── kanban_screen.dart     # Study task kanban board screen stub
│   └── settings_screen.dart   # App settings screen stub
└── widgets/
    ├── pdf_card.dart          # Reusable card widget for study documents
    ├── folder_card.dart       # Folder item component stub
    ├── primary_app_bar.dart   # Standardized M3 app bar component stub
    ├── app_bottom_nav.dart    # Bottom navigation bar component stub
    ├── primary_fab.dart       # Floating action button component stub
    ├── kanban_status_section.dart # Kanban section column component stub
    ├── task_list_item.dart    # Kanban task list item component stub
    ├── settings_list_item.dart# Settings row component stub
    ├── primary_button.dart    # Standardized filled button stub
    └── empty_state.dart       # Empty state display component stub
```

---

## 6. Screenshots

| Home Screen (Library) | PDF Viewer Screen |
| --- | --- |
| ![Home Screen](docs/assets/screen-home.png) | ![PDF Viewer](docs/assets/screen-viewer.png) |

---

## 7. Known issues and next steps

- **Current Limitations:** The app currently uses a static list of predefined reviewers and sample PDF assets (`assets/dummy.pdf`). Local file picking and cloud synchronization are planned next steps.
- **Next Steps:**
  - Implement file picker (`file_picker` package) to allow users to import local PDF files.
  - Integrate local SQLite / Hive or Supabase storage for persistent reading progress and bookmarking.
  - Complete the Kanban task management screen for study planning.

---

## AI Usage

- AI tools (Claude / ChatGPT /Agents) were used as coding assistants for structuring Material 3 themes, wiring navigation, and drafting documentation. See `AI-USAGE.md` for full details.


