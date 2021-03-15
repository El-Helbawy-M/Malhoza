import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

String tapleName = 'notes', trashTapleName = "trashes";

//=============================================================
//=============================================================

Future<Database> database() async => await openDatabase(
      join(await getDatabasesPath(), "note.db"),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE $tapleName(id INT ,title TEXT, subject TEXT, notecolor TEXT, textcolor TEXT, image TEXT)",
        );
      },
      version: 1,
    );

Future<Database> trashdatabase() async => await openDatabase(
      join(await getDatabasesPath(), "trashNote.db"),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE $trashTapleName(id INT ,title TEXT, subject TEXT, notecolor TEXT, textcolor TEXT, image TEXT)",
        );
      },
      version: 1,
    );

//=============================================================
//=============================================================

Future<void> insertNote(Map<String, dynamic> map) async {
  var db = await database();
  return await db.insert(tapleName, map,
      conflictAlgorithm: ConflictAlgorithm.replace);
}

Future<void> insertTrash(Map<String, dynamic> map) async {
  var db = await trashdatabase();
  return await db.insert(trashTapleName, map,
      conflictAlgorithm: ConflictAlgorithm.replace);
}

//=============================================================
//=============================================================

Future<List<Map<String, dynamic>>> notes() async {
  var db = await database();
  return await db.query(tapleName);
}

Future<List<Map<String, dynamic>>> trashes() async {
  var db = await trashdatabase();
  return await db.query(trashTapleName);
}

Future<List<Map<String, dynamic>>> trashess(int id) async {
  var db = await trashdatabase();
  return await db.query(trashTapleName, where: "id = ?", whereArgs: [id]);
}

//=============================================================
//=============================================================

Future<void> updateNote(Map<String, dynamic> map, int id) async {
  var db = await database();
  return await db.update(
    tapleName,
    map,
    where: "id = ?",
    whereArgs: [id],
  );
}

Future<void> updateTrash(Map<String, dynamic> map, int id) async {
  var db = await trashdatabase();
  return await db.update(
    trashTapleName,
    map,
    where: "id = ?",
    whereArgs: [id],
  );
}

//=============================================================
//=============================================================

Future<void> deleteNote(int id) async {
  var db = await database();
  return await db.delete(
    tapleName,
    where: "id = ?",
    whereArgs: [id],
  );
}

Future<void> deleteTrash(int id) async {
  var db = await trashdatabase();
  return await db.delete(
    trashTapleName,
    where: "id = ?",
    whereArgs: [id],
  );
}

//=============================================================
//=============================================================
