import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

late Database db;

class DBService {
  // init database
  Future<void> initDatabase() async {
    final path = await getDatabasePath('invoices_database');
    db = await openDatabase(path, version: 1, onCreate: onCreate, onConfigure: onConfigure);
    // log(db);
  }

  // database log
  static void databaseLog(String functionName, String sql, [List<Map<String, dynamic>>? selectQueryResult, int? insertAndUpdateQueryResult, List<dynamic>? params]) {
    log(functionName);
    log(sql);
    if (params != null) {
      log(params.toString());
    }
    if (selectQueryResult != null) {
      log(selectQueryResult.toString());
    } else if (insertAndUpdateQueryResult != null) {
      log(insertAndUpdateQueryResult.toString());
    }
  }

  // get database path
  Future<String> getDatabasePath(String dbName) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, dbName);
    log(path);

    //make sure the folder exists
    if (await Directory(dirname(path)).exists()) {
      // await FlutterSession().set('sid', '');
      // await deleteDatabase(path);
    } else {
      await Directory(dirname(path)).create(recursive: true);
      log('dir created');
    }
    return path;
  }

  // configure
  FutureOr onConfigure(Database db) async {
    // Add support for cascade delete
    await db.execute("PRAGMA foreign_keys = ON");
  }

  // on create
  Future<void> onCreate(Database db, int version) async {}

  Future<Map> getCompanyDetails() async {
    const sql = '''SELECT * FROM company_details''';
    final data = await db.rawQuery(sql);
    log(data[0].toString(), name: 'company details');
    return data[0];
  }
}
