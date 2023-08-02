// ignore_for_file: depend_on_referenced_packages

import 'package:note/src/features/Note/data/entitis/note_model.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';

abstract class NoteLocalDataSource {
  Future<List<NoteModel>> getAllNote(String table, myWhere);
  Future<int> deleteNote(String table, String myWhere);
  Future<int> updateNote(
      String table, Map<String, Object?> value, String? myWhere);
  Future<int> addNote(String table, Map<String, Object?> value);
}

class NoteLocalDataSourceImpl implements NoteLocalDataSource {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await intialDb();
      return _db;
    } else {
      return _db;
    }
  }

  intialDb() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'note.db');
    Database mydb = await openDatabase(path,
        onCreate: _onCreate, version: 1, onUpgrade: _onUpgrade);
    return mydb;
  }

  _onUpgrade(Database db, int oldversion, int newversion) async {
    // await db.execute("ALTER TABLE notes ADD COLUMN  title text ");
    await db.execute("ALTER TABLE tasks ADD COLUMN  isComplete INTEGER  ");
    print("onUpgrade =====================================");
  }

  _onCreate(Database db, int version) async {
    Batch batch = db.batch();
    batch.execute('''
  CREATE TABLE "notes" (
    "id" INTEGER  NOT NULL PRIMARY KEY  AUTOINCREMENT, 
    "note" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "date" Datatime
  )
 ''');
    batch.execute('''
  CREATE TABLE "tasks" (
    "id" INTEGER  NOT NULL PRIMARY KEY  AUTOINCREMENT, 
    "task" TEXT NOT NULL,
    "date" Datatime
  )
 ''');

    await batch.commit();
    print(
        "===================  ================== onCreate ====================  =================");
  }

  deleteMyDatabase() async {
    String myDataBase = await getDatabasesPath();

    String path = join(myDataBase, 'note.db');
    await deleteDatabase(path);
    print('object');
  }

  @override
  Future<int> addNote(String table, Map<String, Object?> value) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, value);
    return response;
  }

  @override
  Future<int> deleteNote(String table, String myWhere) async {
    Database? mydb = await db;
    int response = await mydb!.delete(table, where: myWhere);
    return response;
  }

  @override
  Future<List<NoteModel>> getAllNote(String table, myWhere) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table, orderBy: 'id DESC');
    response[0]['id'];

    List<NoteModel> note = response.map((e) => NoteModel.fromMap(e)).toList();

    return note;
  }

  @override
  Future<int> updateNote(
      String table, Map<String, Object?> value, String? myWhere) async {
    Database? mydb = await db;
    int response = await mydb!.update(table, value, where: myWhere);
    return response;
  }

  // read(String table, myWhere) async {
  //   Database? mydb = await db;
  //   List<Map> response = await mydb!.query(table, orderBy: 'id DESC');
  //   return response;
  // }

  // insert(String table, Map<String, Object?> value) async {
  //   Database? mydb = await db;
  //   int response = await mydb!.insert(table, value);
  //   return response;
  // }

  // update(String table, Map<String, Object?> value, String? myWhere) async {
  //   Database? mydb = await db;
  //   int response = await mydb!.update(table, value, where: myWhere);
  //   return response;
  // }

  // delete(String table, String myWhere) async {
  //   Database? mydb = await db;
  //   int response = await mydb!.delete(table, where: myWhere);
  //   return response;

  // }
  /********************************** */
}
