# AI usage

## 1. How I used AI

**Overview:** In week 1 and the first half of week 2 I was coding and learning at the same time, and I underestimated how long the database and PDF viewing would take. After falling behind, I rushed the rest of the app and used AI for roughly 95% of that later implementation. I used two kinds of tools: Claude in the web chat, and Kimi-K3 running inside the Cline agent harness in my editor. The entries are in date order, and the commit links show where that shift happened.

### 2026-09-22 - Material 3 theme (`theme.dart`)
- **Tool:** Claude (web chat)
- **What I asked for:** A Material 3 theme matching my design system: color roles, spacing constants, and text themes.
- **What it gave back:** A generated `ThemeData` using `ColorScheme.fromSeed`, `AppSpacing` constants, and text styles.
- **What I kept, what I changed, and why:** The theme is AI-generated. When I ran the app, the app bar had no color, because the first theme had no `appBarTheme`. I wrote the fix myself: an `appBarTheme` so the app bar fills with the primary color (`0xFF31628D`), with a white foreground and a bold 18pt title.
- **Commit:** [e0580f9](https://github.com/Kleinz17/Study-PDF-Library/commit/e0580f9) (original theme), [14e7597](https://github.com/Kleinz17/Study-PDF-Library/commit/14e7597) (app bar fix)

### 2026-09-22 - PdfCard and HomeScreen structure
- **Tool:** Kimi-K3 through the Cline agent harness
- **What I asked for:** A `PdfCard` widget and a first `HomeScreen` using fake data.
- **What it gave back:** A `PdfCard` widget and a `HomeScreen` with a list of fake documents. I don't remember the exact output, but the commit shows what was added.
- **What I kept, what I changed, and why:** I kept the structure and later reworked the text layout on the card. I put the page number and percentage in a column, with the "completed" label below them, because that read better to me.
- **Commit:** [9a911e8](https://github.com/Kleinz17/Study-PDF-Library/commit/9a911e8) (generated), [8a05a3b](https://github.com/Kleinz17/Study-PDF-Library/commit/8a05a3b) (my text layout change)

### 2026-09-23 - Skeleton stubs for the remaining screens and widgets
- **Tool:** Kimi-K3 through the Cline agent harness
- **What I asked for:** Placeholder stubs for the remaining screens and widgets. I set this up as work for the next day and went to sleep.
- **What it gave back:** 12 stub files (Folders, Kanban, and Settings screens, plus bottom nav, FAB, app bar, button, and card widgets), about 145 lines.
- **What I kept, what I changed, and why:** I kept the stubs as the starting structure and filled them in later, so I could build each screen without starting from nothing.
- **Commit:** [aa7c01c](https://github.com/Kleinz17/Study-PDF-Library/commit/aa7c01c)

### 2026-09-23 to 09-25 - `pdfrx` PDF viewer
- **Tool:** Kimi-K3 through Cline, and Claude (web chat)
- **What I asked for:** Help adding the `pdfrx` dependency and showing a local PDF in a viewer screen.
- **What it gave back:** Cline added the dependency, but I think it was an incompatible version, so I asked Claude in the web chat what was wrong. I don't remember the exact error.
- **What I kept, what I changed, and why:** I kept what worked. I wrote the viewer screen myself, using AI to explain what I was doing wrong when it failed to compile or run.
- **Commit:** [2a37c16](https://github.com/Kleinz17/Study-PDF-Library/commit/2a37c16), [e154ba9](https://github.com/Kleinz17/Study-PDF-Library/commit/e154ba9), [0b32bc1](https://github.com/Kleinz17/Study-PDF-Library/commit/0b32bc1)

### 2026-09-23 to 09-28 - README, weekly report, and project documentation
- **Tool:** Kimi-K3 through the Cline agent harness
- **What I asked for:** A summary of what had been done so far, written up as the README, the week 1 report, and `REPORT.md`.
- **What it gave back:** Drafted documentation sections based on the project.
- **What I kept, what I changed, and why:** I read through the drafts and edited the parts it got wrong myself. I don't remember a specific example, but I corrected claims so they matched what the app actually does.
- **Commit:** [7bbc63b](https://github.com/Kleinz17/Study-PDF-Library/commit/7bbc63b), [dec3a72](https://github.com/Kleinz17/Study-PDF-Library/commit/dec3a72), [d21ea97](https://github.com/Kleinz17/Study-PDF-Library/commit/d21ea97)

### 2026-09-30 to 10-04 - Folders and bookmarks
- **Tool:** Claude (web chat) and Kimi-K3 through Cline
- **What I asked for:** Database changes for folders, the Folders and Folder Contents screens, and bookmark bug fixes, after I fell behind schedule.
- **What it gave back:** The folder schema changes, the two screens, and the bookmark fixes in the viewer.
- **What I kept, what I changed, and why:** Most of this is AI-generated, and I kept it because I was running out of time. Two things were missing that I wanted: bookmarks had no label, since pressing bookmark just saved the page, so I wanted bookmarks to be labelable; and I couldn't edit or delete a semester, so I wanted an option to edit the whole semester. I tried to build these myself first, but in the end the work was AI-assisted.
- **Commit:** [61fa6aa](https://github.com/Kleinz17/Study-PDF-Library/commit/61fa6aa), [ec98f30](https://github.com/Kleinz17/Study-PDF-Library/commit/ec98f30), [7265a45](https://github.com/Kleinz17/Study-PDF-Library/commit/7265a45) (bookmark labels), [88b3beb](https://github.com/Kleinz17/Study-PDF-Library/commit/88b3beb) (folder editing and deletion)

### 2026-10-03 to 10-04 - Kanban board, settings, and subject/semester dialog
- **Tool:** Kimi-K3 through the Cline agent harness
- **What I asked for:** The Kanban study board, a Settings screen with a dark mode toggle, and a multi-subject semester creation dialog.
- **What it gave back:** The Kanban screen and widgets, the Settings screen, a dark theme, and the dialog.
- **What I kept, what I changed, and why:** Mostly AI-generated. I tested it and fixed the bugs I found myself: the Kanban overflow and the dark mode header size (see Section 2).
- **Commit:** [97411e0](https://github.com/Kleinz17/Study-PDF-Library/commit/97411e0), [7a32130](https://github.com/Kleinz17/Study-PDF-Library/commit/7a32130), [a9a114a](https://github.com/Kleinz17/Study-PDF-Library/commit/a9a114a), [0455ae3](https://github.com/Kleinz17/Study-PDF-Library/commit/0455ae3)

## 2. Where the AI got it wrong

### Case 1 - Dark mode made the Settings header larger
- **What it gave me:** A dark theme whose AppBar title style used `fontSize: 20`, while my light theme uses 18.
- **What was wrong with it:** The two themes didn't match. When I toggled dark mode, the "Settings" header grew.
- **What I did instead:** I found the cause in `darkAppTheme` and changed the title `fontSize` from 20 to 18 myself.
- **Commit:** [29512ea](https://github.com/Kleinz17/Study-PDF-Library/commit/29512ea)

### Case 2 - Kanban board overflowed by 59 pixels
- **What it gave me:** A Kanban screen that rendered with a "bottom overflowed by 59 pixels" error.
- **What was wrong with it:** The dropdown fields and the PDF title text were wider than the space the layout gave them, so the screen overflowed.
- **What I did instead:** I fixed it myself by adding `isExpanded: true` to the dropdown fields and wrapping the PDF title text in a constrained `SizedBox` with `TextOverflow.ellipsis`, which removed the overflow completely.
- **Commit:** [97411e0](https://github.com/Kleinz17/Study-PDF-Library/commit/97411e0) 

### Case 3 - PdfCard layout didn't match my mockup
- **What it gave me:** A generated `PdfCard` whose text layout did not match my mockup.
- **What was wrong with it:** The progress text and the "completed" label were arranged differently from my design.
- **What I did instead:** I restructured the card's text into a column myself and moved the "completed" label below the progress text to match the mockup.
- **Commit:** [8a05a3b](https://github.com/Kleinz17/Study-PDF-Library/commit/8a05a3b)

## 3. Who wrote what

**Honest note:** Most of this app is AI-generated or AI-assisted. By my own estimate, the code I wrote myself is under 10% of the non-generated Dart code in `lib/`. The theme, the first `PdfCard` and `HomeScreen`, the skeleton stubs, and almost everything from the second half of week 2 onward came from Claude or Kimi-K3 through Cline.

### Written by me

#### `lib/database/app_database.dart` (Drift schema)
- **Commit:** [f3fc541](https://github.com/Kleinz17/Study-PDF-Library/commit/f3fc541)
- **What it does and why it is built this way:** This file defines the app's local database using Drift. Each class that `extends Table` creates a table, like the SQL classes I took last year, and each getter inside it is a column: `integer().autoIncrement()` is the primary key, `text().withLength(...)` limits a text field, and `.withDefault(...)` and `.nullable()` set defaults and optional values. There are tables for documents (title, file path, last page read, total pages, date added), folders, tasks, and bookmarks, and ID columns like `folderId` and `documentId` link them together like foreign keys. The `@DriftDatabase` annotation and `part 'app_database.g.dart'` tell Drift's code generator (`build_runner`) to generate the database class and query code. I first forgot to register the Bookmarks table in `@DriftDatabase`, and fixed that in [689fae1](https://github.com/Kleinz17/Study-PDF-Library/commit/689fae1). I used a local database so reading progress is saved on the device.

#### `lib/screens/home_screen.dart` (PDF import and loading documents)
- **Commit:** [a95312c](https://github.com/Kleinz17/Study-PDF-Library/commit/a95312c), [873fc22](https://github.com/Kleinz17/Study-PDF-Library/commit/873fc22)
- **What it does and why it is built this way:** The floating "Import PDF" button opens the file picker limited to `.pdf` files. At this point it only logs the chosen file, with a TODO to save it to the database, which I finished later. In the second commit I replaced six hard-coded `PdfCard` widgets with a `documents` list and `.map()`, so each card is built from data, and tapping a card uses `Navigator.push` to open `PdfViewerScreen` with that document's title. I did this so adding a document means adding data instead of copying a widget.

#### `lib/screens/pdf_viewer_screen.dart` (initial viewer)
- **Commit:** [e154ba9](https://github.com/Kleinz17/Study-PDF-Library/commit/e154ba9)
- **What it does and why it is built this way:** `PdfViewerScreen` is a stateless widget with a `Scaffold`, an app bar showing the document title, and `PdfViewer.asset('assets/dummy.pdf')` from the `pdfrx` package, which renders a bundled sample PDF. It was a spike to prove I could display a PDF before connecting real files. I wrote this with AI help for debugging errors, and the page tracking and bookmark features added later are AI-generated.

### The AI-written part I understand best

#### Kanban section expand/collapse
- **File:** `lib/widgets/kanban_status_section.dart`, used from `lib/screens/kanban_screen.dart`
- **Commit:** [97411e0](https://github.com/Kleinz17/Study-PDF-Library/commit/97411e0)
- **What it does and why I kept it:** `KanbanStatusSection` is a stateless widget that draws one Kanban column: a header with a color dot, the title, a task count, an add button, and an expand/collapse arrow. It doesn't remember whether it is open. The screen keeps a map, `_expanded`, with one true/false value per section, where "To Study" starts open and the other three start closed. Tapping the header calls `onToggleExpand`, which flips that section's value inside `setState`, and the screen rebuilds. The widget shows its body only `if (isExpanded)`, and when a section has no tasks it shows "No tasks in this section yet." I kept it because the open/closed state lives in one place, the screen, so the section widget stays simple and reusable.
