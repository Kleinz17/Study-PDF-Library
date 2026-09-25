import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
part 'app_database.g.dart'; // Drift code generator will create this file!

// 1. Define the Documents table
class Documents extends Table {
  IntColumn get id => integer().autoIncrement()(); //Primary Key
  TextColumn get fileName => text().withLength(min:1, max: 100)();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get filePath => text()(); // File path or storage identifier
  IntColumn get lastPageRead => integer().withDefault(const Constant(1))();
  IntColumn get totalPages => integer().withDefault(const Constant(0))();
  DateTimeColumn get dateAdded => dateTime().withDefault(currentDateAndTime)();

  //foreign key link to folder
  IntColumn get folderId => integer().nullable()();
}

class Folders extends Table {
  IntColumn get id => integer().autoIncrement()(); //Primary Key
  TextColumn get name => text().withLength(min:1, max: 100)();
  TextColumn get color => text().withLength(min: 4, max: 9)(); 
}

class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()(); //Primary Key
  TextColumn get title => text().withLength(min:1, max: 100)();
  TextColumn get status => text().withLength(min:1, max: 100)();

  // Foreign Key link to documents
  IntColumn get documentId => integer().nullable()();
}

class Bookmarks extends Table {
  IntColumn get id => integer().autoIncrement()(); //Primary Key
  IntColumn get pageNumber => integer()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get dateAdded => dateTime().withDefault(currentDateAndTime)();

    IntColumn get documentId => integer()(); // Foreign Key link to documents
}

@DriftDatabase(tables: [Documents, Folders, Tasks])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
     // drift_flutter automatically uses native SQLite on Windows, macOS, Linux, Android, and iOS!
    return driftDatabase(name: 'study_pdf_library_db');
  }
}
