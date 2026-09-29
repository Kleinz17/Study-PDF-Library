import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import '../database/app_database.dart';
import '../theme.dart';
import 'folder_contents_screen.dart';
import '../widgets/folder_card.dart';
import '../widgets/primary_app_bar.dart';
import '../widgets/primary_button.dart';


class FoldersScreen extends StatelessWidget {
  const FoldersScreen({super.key, required this.db});

  final AppDatabase db;

  /// parentId == null creates a semester, otherwise a subject inside that semester.
  Future<void> _createFolder(BuildContext context, {int? parentId}) async {
    final isSemester = parentId == null;
    final name = await showDialog<String>(
      context: context,
      builder: (context) => _NewFolderDialog(
        title: isSemester ? 'New Semester' : 'New Subject',
        label: isSemester ? 'Semester name (e.g. Semester 1)' : 'Subject name (e.g. Math)',
      ),
    );
    if (name == null || name.trim().isEmpty) return;

    await db.into(db.folders).insert(
          FoldersCompanion(
            name: Value(name.trim()),
            color: const Value('#31628D'), // required column, no picker in the mockup
            parentId: Value(parentId),
          ),
        );
  }

  Widget _subjectGrid(BuildContext context, List<Folder> subjects, List<Document> docs) {
    if (subjects.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Text('No subjects yet. Tap + to add one.'),
      );
    }
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // the outer ListView does the scrolling
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 96,
      ),
      children: subjects.map((subject) {
        final count = docs.where((d) => d.folderId == subject.id).length;
        return FolderCard(
          name: subject.name,
          pdfCount: count,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FolderContentsScreen(
                  db: db,
                  folderId: subject.id,
                  folderName: subject.name,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: PrimaryAppBar(
        title: 'Courses / Folders',
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'New semester',
            onPressed: () => _createFolder(context),
          ),
        ],
      ),
      body: StreamBuilder<List<Folder>>(
        stream: db.select(db.folders).watch(),
        builder: (context, folderSnap) {
          if (!folderSnap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final all = folderSnap.data!;
          final semesters = all.where((f) => f.parentId == null).toList();

          // First-run prompt: the mini "tutorial"
          if (semesters.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('What semester are you in?', style: theme.textTheme.headlineSmall),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Create a semester first, then add your subjects inside it.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelSmall,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: 240,
                      child: PrimaryButton(
                        label: 'Create semester',
                        onPressed: () => _createFolder(context),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Second stream only to count PDFs per subject. Fine at this data size.
          return StreamBuilder<List<Document>>(
            stream: db.select(db.documents).watch(),
            builder: (context, docSnap) {
              final docs = docSnap.data ?? [];

              return ListView(
                padding: const EdgeInsets.all(AppSpacing.md),
                children: [
                  for (final semester in semesters) ...[
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            semester.name.toUpperCase(),
                            style: theme.textTheme.labelSmall,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          tooltip: 'Add subject',
                          onPressed: () => _createFolder(context, parentId: semester.id),
                        ),
                      ],
                    ),
                    _subjectGrid(
                      context,
                      all.where((f) => f.parentId == semester.id).toList(),
                      docs,
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _NewFolderDialog extends StatefulWidget {
  const _NewFolderDialog({required this.title, required this.label});

  final String title;
  final String label;

  @override
  State<_NewFolderDialog> createState() => _NewFolderDialogState();
}

class _NewFolderDialogState extends State<_NewFolderDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _controller,
              autofocus: true,
              maxLength: 100,
              decoration: InputDecoration(
                labelText: widget.label,
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (value) => Navigator.pop(context, value),
            ),
            const SizedBox(height: AppSpacing.md),
            PrimaryButton(
              label: 'Create',
              onPressed: () => Navigator.pop(context, _controller.text),
            ),
          ],
        ),
      ),
    );
  }
}