import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import '../database/app_database.dart';
import '../theme.dart';
import '../widgets/kanban_status_section.dart';
import '../widgets/primary_app_bar.dart';
import '../widgets/primary_button.dart';
import '../widgets/task_list_item.dart';

class KanbanScreen extends StatefulWidget {
  const KanbanScreen({super.key, required this.db});
  final AppDatabase db;

  @override
  State<KanbanScreen> createState() => _KanbanScreenState();
}

class _KanbanScreenState extends State<KanbanScreen> {
  final Map<String, bool> _expanded = {'To Study': true, 'In Progress': false, 'Revision': false, 'Completed': false};

  Future<void> _showTaskDialog(BuildContext context, {Task? task, String? defaultStatus}) async {
    final controller = TextEditingController(text: task?.title ?? '');
    String status = task?.status ?? defaultStatus ?? 'To Study';
    int? docId = task?.documentId;
    final docs = await widget.db.select(widget.db.documents).get();

    if (!context.mounted) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setD) => AlertDialog(
          title: Text(task == null ? 'New Task' : 'Edit Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: controller, autofocus: true, decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder())),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<String>(
                initialValue: status,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
                items: ['To Study', 'In Progress', 'Revision', 'Completed'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => v != null ? setD(() => status = v) : null,
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<int?>(
                initialValue: docId,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'PDF (Optional)', border: OutlineInputBorder()),
                items: [
                  const DropdownMenuItem(value: null, child: Text('None')),
                  ...docs.map((d) => DropdownMenuItem(
                        value: d.id,
                        child: SizedBox(
                          width: 220,
                          child: Text(d.title, overflow: TextOverflow.ellipsis),
                        ),
                      )),
                ],
                onChanged: (v) => setD(() => docId = v),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
            PrimaryButton(label: task == null ? 'Create' : 'Save', onPressed: () => Navigator.pop(context, true)),
          ],
        ),
      ),
    );

    if (ok == true && controller.text.trim().isNotEmpty) {
      if (task == null) {
        await widget.db.into(widget.db.tasks).insert(TasksCompanion(title: Value(controller.text.trim()), status: Value(status), documentId: Value(docId)));
      } else {
        await (widget.db.update(widget.db.tasks)..where((t) => t.id.equals(task.id))).write(TasksCompanion(title: Value(controller.text.trim()), status: Value(status), documentId: Value(docId)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        title: 'Kanban Board',
        actions: [IconButton(icon: const Icon(Icons.add), tooltip: 'New task', onPressed: () => _showTaskDialog(context))],
      ),
      body: StreamBuilder<List<Task>>(
        stream: widget.db.select(widget.db.tasks).watch(),
        builder: (context, taskSnap) {
          if (!taskSnap.hasData) return const Center(child: CircularProgressIndicator());
          return StreamBuilder<List<Document>>(
            stream: widget.db.select(widget.db.documents).watch(),
            builder: (context, docSnap) {
              final tasks = taskSnap.data!;
              final docMap = {for (var d in (docSnap.data ?? [])) d.id: d.fileName};
              final sections = [
                {'title': 'To Study', 'color': Colors.blue},
                {'title': 'In Progress', 'color': Colors.purple},
                {'title': 'Revision', 'color': Colors.orange},
                {'title': 'Completed', 'color': Colors.green},
              ];

              return ListView(
                padding: const EdgeInsets.all(AppSpacing.md),
                children: sections.map((sec) {
                  final title = sec['title'] as String;
                  final color = sec['color'] as Color;
                  final stasks = tasks.where((t) => t.status == title).toList();
                  final expanded = _expanded[title] ?? true;

                  return KanbanStatusSection(
                    title: title,
                    color: color,
                    count: stasks.length,
                    isExpanded: expanded,
                    onToggleExpand: () => setState(() => _expanded[title] = !expanded),
                    onAddTask: () => _showTaskDialog(context, defaultStatus: title),
                    children: stasks.map((t) => TaskListItem(
                      title: t.title,
                      pdfFileName: t.documentId != null ? docMap[t.documentId] : null,
                      status: t.status,
                      onStatusChanged: (s) => widget.db.update(widget.db.tasks).replace(t.copyWith(status: s)),
                      onEdit: () => _showTaskDialog(context, task: t),
                      onDelete: () => (widget.db.delete(widget.db.tasks)..where((x) => x.id.equals(t.id))).go(),
                    )).toList(),
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }
}

