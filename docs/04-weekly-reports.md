# Weekly reports

One entry per week, newest at the top.

---

## Week 2 (Sep 24 to Oct 9, 2026)

**Done this week**
- Drift (SQLite) database: `Documents` table first, then `Bookmarks`, then `Folders` and `Tasks` (schema version 2) (`lib/database/app_database.dart`)
- PDF import with `file_picker` from the home screen FAB, and `pdfrx` viewer that saves the last page read
- Fixed progress bars stuck at 0%: set `totalPages` on import, wrote the page back from the viewer, and shared one `AppDatabase` instance from `AppShell`
- Screen navigation between all screens, plus the Folders and Folder Contents screens, with edit and delete for folders and a multi-subject semester dialog
- Bookmarks with labels, Kanban board, Settings screen with dark mode toggle
- README with screenshots, `REPORT.md`, and `AI-USAGE.md`

**In progress**
- Final documentation in `docs/` (demo video, security and privacy checklist)

**Blocked or stuck on**
- Progress and last page never updating: three bugs stacked (page count never set, viewer never saved the page, two separate database instances so Drift's live stream didn't refresh)
- Nullable file path from `file_picker` vs a required column, and stale generated code after schema changes (fixed with `build_runner build --delete-conflicting-outputs`)
- Settings header grew in dark mode because the dark theme's title size didn't match the light theme
- Ran behind on the database and PDF viewer, so I rushed later screens and relied heavily on AI for them (details in `AI-USAGE.md`)

**Decisions made, and why**
- One shared `AppDatabase` passed into every screen, so live streams see writes from other screens
- Dropped web database testing and kept the local Drift database, to keep the MVP on the platform I'm building for
- Added bookmark labels and folder editing myself as requirements, because a bookmark with no label and a semester I couldn't edit weren't usable

**Hours spent, roughly:** 20hrs

**Next week I will:**
- Finish the docs and the demo video
- Run the security checklist and do a final repo check before submitting

---

## Week 1 (Sep 19 to Sep 23, 2026)

**Done this week**
- Flutter project scaffolding with `device_preview`, and the Material 3 theme from the design system (`lib/theme.dart`)
- `PdfCard` and a `HomeScreen` with fake data, then refactored to a dynamic list
- `pdfrx` PDF viewer spike with a local sample PDF
- Stub files for the remaining screens and widgets
- First weekly report and README

**In progress**
- Drift database schema and PDF import with `file_picker`

**Blocked or stuck on**
- `pdfrx` web worker assets returned 404 (fixed with a full Hot Restart)
- Browser CORS blocked loading a PDF from a web URL (fixed by bundling a local PDF and using `PdfViewer.asset`)
- YAML indentation error in `pubspec.yaml` when adding the assets section

**Decisions made, and why**
- Test PDF rendering first, because it was my biggest technical risk
- Load PDFs from a local asset instead of a URL, to avoid CORS
- Dynamic list mapping instead of duplicated hardcoded cards, so one widget serves every document

**Hours spent, roughly:** 15hrs

**Next week I will:**
- Set up the Drift database and file import
- Build the remaining screens to match the mockup

---