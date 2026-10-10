# Proposal

## The problem, in one sentence

Most students have multiple PDFs for study materials that end up
unorganized and scattered across different places, making it hard to
keep track of which file is which and find what they need when they sit
down to study.

## Who it is for

**Target users:** High school and college students juggling multiple
subjects and courses, each with its own set of PDF readings, lecture
slides, and scanned notes.

**What they do instead:** Rely on a general-purpose PDF reader, Google
Drive folders, their phone's default file/downloads app, or physical
printouts.

## Core features

The minimum viable product (MVP) includes these five features:

1.  **Import PDF** --- Import PDF files from the device using a file
    picker and save their document records.
2.  **View PDF** --- Open and read PDFs, with page navigation and zoom
    controls.
3.  **Bookmark and track progress** --- Bookmark pages and save each
    document's reading progress so users can return to where they
    stopped.
4.  **Organize into folders and sections** --- Create folders for
    subjects or courses and organize documents within them.
5.  **Study Task Board** --- Manage study tasks and change their status
    between `To Study`, `In Progress`, `Revision`, and `Completed`.

### Stretch goals

These features may be added if the MVP is completed with enough time
remaining:

-   Color customization, including dark mode and other themes.
-   In-PDF text highlighting and other annotation features.
-   Advanced PDF organization or study features.
-   One-tap AI PDF summarization using the Gemini API.

AI summarization is a stretch goal, not a requirement for the app's core
functionality. If implemented, it will require internet access to the
Gemini API. If a real API request is unavailable in a browser
demonstration, the Summary button may display a sample summary instead.
The API key will be kept server-side and outside the public repository.

## Out of scope, and why

-   **Online synchronization and shared libraries:** Each user has their
    own personal study library. Users do not need to see or synchronize
    one another's documents, folders, bookmarks, reading progress, or
    tasks through an online server.
-   **AI summarization as a required feature:** The app's main purpose
    is organizing and reading study materials. AI summarization will
    only be attempted after the MVP is completed, so it does not put the
    core project at risk.
-   **Advanced annotation and organization features:** Text
    highlighting, additional annotation tools, and advanced study
    features are stretch goals because the core library, PDF viewer,
    organization, progress tracking, and task board take priority.

## Data the app remembers, and where it is saved

The app uses **Drift (SQLite)** for local data storage. Each user has a
separate study library stored locally; the MVP does not require an
online server for synchronization.

Drift was chosen because the app stores several types of structured data
that are related to one another. Documents, folders, bookmarks, reading
progress, and study tasks need to be queried and updated individually.
Drift supports related tables and queries more suitably than a simple
key-value store such as `shared_preferences`, although it requires
additional setup and database code.

| Data | Fields | Where it is saved |
| --- | --- | --- |
| Document | `id`, `fileName`, `filePath`, `folderId`, `dateAdded`, `lastPageRead` | Document table |
| Folder | `id`, `name` | Folder table |
| Bookmark | `id`, `documentId`, `pageNumber`, `dateCreated` | Bookmark table |
| Task | `id`, `title`, `status` | Task table |

The estimated amount of data is around **30--100 records in a typical
week**, depending on how many subjects and study materials a student
uses.

A one-hour Drift spike was completed: a minimal table was code-generated
and queried successfully in under a minute. The test also revealed that
the Windows development machine did not yet have a working Android
emulator, so emulator setup and database testing need to be addressed
early in implementation.

The project will be kept in a public GitHub repository. The MVP does not
require API keys or personal data. If Gemini summarization is
implemented, its API key will be kept server-side and outside the public
repository.

## Risks

### 1. PDF viewer and reading progress

**Risk:** The PDF viewer may not render pages correctly or perform
smoothly. Page navigation, zoom, scrolling, and saving or restoring
reading progress have not yet been tested in the actual app.

**First step:** Test the selected PDF viewer package with sample PDFs
and implement basic page navigation and zoom before building the
remaining PDF-related features.

**When:** Week 1 of implementation.

### 2. Development environment and Drift

**Risk:** The Windows development machine does not currently have a
working Android emulator. This may slow down Android testing. Drift
behavior and database integration also need to be tested in the app.

**First step:** Set up and test a working Android emulator, research
Drift's behavior, and test the database integration.

**When:** Weeks 1--2 of implementation.

### 3. Study Task Board implementation

**Risk:** The Study Task Board has the highest estimated implementation
time among the five MVP features, at eight hours. Its list, task
details, and status-changing interactions may take longer than expected.

**First step:** Break the feature into smaller parts, beginning with
displaying tasks and then adding task creation and status changes.

**When:** During MVP implementation, after the initial environment
setup.

## Changes since the last version

-   **Core features:** Kept the same five MVP
    features after reviewing the Flutter components and skills covered
    in M4/M5. Added implementation estimates and identified the Study
    Task Board as the feature with the highest estimated workload.
-   **Data storage:** Defined specific fields for
    Documents, Folders, Bookmarks, and Tasks, using IDs to connect
    related records. Selected Drift (SQLite) to support structured data,
    relationships, and queries.
-   **Stretch goals:** Added one-tap AI PDF
    summarization using the Gemini API, along with advanced organization
    and study features. Kept these outside the MVP so they would not put
    the core project at risk.
-   **Risks:** Kept PDF rendering and reading
    progress as a major risk. Added development-environment and Drift
    testing risks after discovering that the Windows machine did not
    have a working Android emulator.
