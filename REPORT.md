# Weekly Increment Report

## Week of: September 16 – September 23, 2026 (Week 1)

## What changed this week

- **Project Setup & Architecture Review:** I reviewed the project proposal, UI mockups, and design system specifications to align my implementation plan.
- **Theme & UI Foundation:** I configured the Material 3 theme roles, spacing constants, and typography hierarchies in lib/theme.dart.
- **HomeScreen Dynamic Refactor:** I refactored the HomeScreen from hardcoded duplicate UI cards to dynamic list mapping using a structured mock list of study documents with progress indicators (lib/screens/home_screen.dart).
- **PDF Viewer Spike & Integration:** I added the pdfrx package dependency to pubspec.yaml, created lib/screens/pdf_viewer_screen.dart, and wired up navigation from the home screen.
- **WASM & CORS Troubleshooting (Flutter Web):** I resolved pdfium client asset bundling issues via Flutter Hot Restart and overcame Chrome CORS network fetch restrictions by switching to local asset loading (assets/dummy.pdf).
- **AI Usage Documentation:** I structured and updated AI-USAGE.md to transparently disclose AI pair-programming and documentation assistance for course requirements.

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
