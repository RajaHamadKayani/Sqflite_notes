import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'package:sqflite_tutorial/view_model/models/notes_model/notes_model.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  Database? _db;
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "notes.db");
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    db.execute(
        ''' CREATE TABLE notes (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, age INTEGER NOT NULL, email TEXT NOT NULL, description TEXT NOT NULL)''');
  }

  Future<NotesModel> insertData(NotesModel notesModel) async {
    var dbClient = await db;
    await dbClient!.insert("notes", notesModel.toMap());
    return notesModel;
  }

  Future<List<NotesModel>> getData() async {
    var dbClient = await db;
    final List<Map<String, Object?>> getData = await dbClient!.query("notes");
    return getData.map((e) => NotesModel.jsonMap(e)).toList();
  }

  Future<int> deleteNote(int id) async {
    var dbClient = await db;
    return await dbClient!.delete("notes", where: "id=?", whereArgs: [id]);
  }
}
