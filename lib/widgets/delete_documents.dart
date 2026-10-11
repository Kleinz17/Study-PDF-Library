import 'package:flutter/material.dart';
import '../database/app_database.dart';

/// Asks for confirmation, then removes [docs] from the library in one query.
/// Returns true if they were deleted. The original PDF files on the device
/// are never touched, only the library entries.
Future<bool> confirmAndDeleteDocuments(
  BuildContext context,
  AppDatabase db,
  List<Document> docs,
) async {
  if (docs.isEmpty) return false;

  final single = docs.length == 1;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(single ? 'Remove PDF?' : 'Remove ${docs.length} PDFs?'),
      content: Text(
        single
            ? '"${docs.first.fileName}" will be removed from your library. The original file on your device is not affected.'
            : '${docs.length} PDFs will be removed from your library. The original files on your device are not affected.',
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Remove')),
      ],
    ),
  );

  if (confirmed != true) return false;

  final ids = docs.map((d) => d.id).toList();
  await (db.delete(db.documents)..where((d) => d.id.isIn(ids))).go();
  return true;
}
