import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();

  static final DBHelper getInstance = DBHelper._();
  static final String tableName = "note";
  static final String columnSNo = "s_no";
  static final String columnTitle = "title";
  static final String columnDescription = "desc";
  static final String columnMonth = "month";
  static final String columnDay = "day";

  Database? myDB;

  Future<Database> getDB() async {
    myDB = myDB ?? await openDB();
    return myDB!;
  }

  Future<Database> openDB() async {
    Directory appPath = await getApplicationDocumentsDirectory();
    String dbPath = join(appPath.path, "note.db");
    return await openDatabase(dbPath, onCreate: (db, version) {
      db.execute(
          "create table $tableName ($columnSNo integer primary key autoincrement, $columnTitle text, $columnDescription text, $columnMonth text, $columnDay text)");
    }, version: 1);
  }

  Future<bool> addNotes({String? mTitle, required String mDesc, String? mMonth, String? mDay}) async {
    var db = await getDB();
    int rowsEffected = await db.insert(tableName, {
      columnTitle: mTitle!,
      columnDescription: mDesc,
      columnMonth: mMonth,
      columnDay: mDay,
    });
    return rowsEffected > 0;
  }

  Future<List<Map<String, dynamic>>> getALlNotes() async {
    var db = await getDB();
    List<Map<String, dynamic>> mData = await db.query(tableName);
    return mData;
  }

  Future<bool> deleteNote({required int sno}) async {
    var db = await getDB();

    int rowsAffected = await db.delete(tableName, where: "$columnSNo = $sno");
    return rowsAffected > 0;
  }

  Future<bool> updateNote({required String utitle, required String uDescription, required int uSNO}) async {
    var db = await getDB();

    int rowsAffected = await db.update(
      tableName,
      {columnTitle: utitle, columnDescription: uDescription},
      where: "$columnSNo = ?",
      whereArgs: [uSNO],
    );
    return rowsAffected > 0;
  }
}
