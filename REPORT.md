# Weekly Increment Report

## Week of: September 16 – September 23, 2026 (Week 1)

## What changed this week

- **Project Setup & Architecture Review:** I reviewed the project proposal, UI mockups, and design system specifications to align my implementation plan.
- **Theme & UI Foundation:** I configured the Material 3 theme roles, spacing constants, and typography hierarchies in lib/theme.dart.
- **HomeScreen Dynamic Refactor:** I refactored the HomeScreen from hardcoded duplicate UI cards to dynamic list mapping using a structured mock list of study documents with progress indicators (lib/screens/home_screen.dart).
- **PDF Viewer Spike & Integration:** I added the pdfrx package dependency to pubspec.yaml, created lib/screens/pdf_viewer_screen.dart, and wired up navigation from the home screen.
- **WASM & CORS Troubleshooting (Flutter Web):** I resolved pdfium client asset bundling issues via Flutter Hot Restart and overcame Chrome CORS network fetch restrictions by switching to local asset loading (assets/dummy.pdf).

## Why

- These changes established my foundational MVP flow and successfully solved my highest technical risk of rendering local PDFs with pdfrx on Flutter Web, early in the development cycle before implementing database.

## What broke or what I got stuck on

- **Flutter Web Asset Loading (404):** Initially, pdfrx threw missing asset errors for pdfium client web workers in the browser dev console because the local dev server had not bundled them yet. *Fix:* I performed a full Flutter Hot Restart.
- **CORS Network Fetch Error:** Attempting to load an external web PDF URL caused browser CORS security blocks. *Fix:* I bundled a local sample PDF (assets/dummy.pdf) and utilized PdfViewer.asset instead of remote URIs.
- **YAML Syntax Error:** I encountered block mapping errors in pubspec.yaml when adding the assets section. *Fix:* I corrected indentation and list dash placement under flutter.

## What is left

- Set up Drift (SQLite) database schema and tables (Document, Folder, Task).
- Implement the file_picker package to allow users to import local PDF files from their device.
- Build out core custom widgets and polish screen layouts to match the design system mockup before the deadline.

---

## Week of: September 24 – September 27, 2026 (Week 2)

## What changed this week

- **Drift (SQLite) Database Implementation:** Created the persistent relational database schema (`lib/database/app_database.dart`) with the `Documents` table to store metadata such as file title, file path, total pages, and last read page.
- **Native File Picker Integration:** Integrated the `file_picker` package into `HomeScreen` floating action button (`+`) enabling users to import any local `.pdf` file from their device directly into the local SQLite database.
- **Persistent Reading Progress Tracking:** Updated `PdfViewerScreen` and `AppShell` session state management to track and save current page numbers back to the Drift database in real time as the user reads.
- **Code Generation & Clean Build:** Ran `build_runner` to generate Drift boilerplate (`app_database.g.dart`) and verified the entire codebase with `flutter analyze` ensuring zero linter warnings.

## Why

- These updates completed the core functional requirements of the app, transforming it from a static mockup viewer into a fully interactive, persistent study library where users can import and read their own PDF materials while tracking progress.

## What broke or what I got stuck on
- **Progress bar not updating / last viewed page not saving:** Cards on the home screen always showed 0% and never changed, no matter how far I read in the PDF.
  - *Cause:* Three separate problems stacked together:
    - `totalPages` was never set on import, so it stayed at the default of 0 and the progress ratio was always 0.
    - `PdfViewerScreen` never wrote the current page back to the database.
    - `HomeScreen` and `PdfViewerScreen` each created their own `AppDatabase()` instance. Drift's live streams only react to writes made through the same instance, so the home screen didn't refresh when I returned from the viewer. It only updated after switching tabs, because that rebuilt the screen.
  - *Fix:* Read the real page count with `PdfDocument.openFile` during import and saved it as `totalPages`. Also added `_onPageChanged(int? pageNumber)` in `PdfViewerScreen` (via pdfrx's `onPageChanged`) to write `lastPageRead` to the database then created a single shared `AppDatabase` in `AppShell` and passed it into both screens, so the stream on the home screen sees the viewer's writes immediately.


- **Database Schema Updates & Nullability:** Initially encountered type mismatch issues between nullable file paths and required database columns when selecting files via `file_picker`. 
  - *Fix:* Added strict null checks (`if (file.path == null) return;`) and handled companion values correctly in Drift.
- **Build Runner Outdated Generated Code:** When modifying the database table schema, type bindings became out of sync. 
  - *Fix:* Executed `flutter pub run build_runner build --delete-conflicting-outputs` to regenerate fresh serialization code.

## What is left

- Final polish of additional screen stubs (Folders and Kanban boards) if required for extended functionality.
- Final documentation and repository check prior to submission.

