import 'dart:async';

import 'package:hospital_management_system/dao/consultation/sql.dart';
import 'package:hospital_management_system/dao/doctor/sql.dart';
import 'package:hospital_management_system/dao/income/sql.dart';
import 'package:hospital_management_system/dao/invoice/sql.dart';
import 'package:hospital_management_system/dao/other/sql.dart';
import 'package:hospital_management_system/dao/otherEntry/sql.dart';
import 'package:hospital_management_system/dao/otherOuting/sql.dart';
import 'package:hospital_management_system/dao/patientInvoiceItem/sql.dart';
import 'package:hospital_management_system/dao/product/sql.dart';
import 'package:hospital_management_system/dao/productEntry/sql.dart';
import 'package:hospital_management_system/dao/productOuting/sql.dart';
import 'package:hospital_management_system/dao/service/sql.dart';
import 'package:hospital_management_system/dao/test/sql.dart';
import 'package:hospital_management_system/dao/user/sql.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class ConnectionSQLiteService {
  ConnectionSQLiteService._();

  static ConnectionSQLiteService? _instance;

  static ConnectionSQLiteService get instance {
    _instance ??= ConnectionSQLiteService._();
    return _instance!;
  }

  /* ============================================= */

  static const databaseName = 'chcdb.db';
  static const databaseVersion = 1;
  Database? _db;

  Future<Database> get db => _openDatabase();

  Future<Database> _openDatabase() async {
    sqfliteFfiInit();
    print('db init...');
    String databasePath = await databaseFactoryFfi.getDatabasesPath();
    print(databasePath);
    String path = join(databasePath, databaseName);
    DatabaseFactory databaseFactory = databaseFactoryFfi;

    if(_db == null){
      print('creating db');
      _db = await databaseFactory.openDatabase(path,
          options: OpenDatabaseOptions(
              onCreate: _onCreate, version: databaseVersion
          )
      );
      print('success');
    }
    return _db!;
  }

  FutureOr<void> _onCreate(Database db, int version) {
    print('creating table');
    db.transaction((reference) async {
      print('I know it failed here');
      await reference.execute(UsersConnectionSQL.createTable).catchError((e) => print(e.toString()));
      await reference.execute(InvoicesConnectionSQL.createTable).catchError((e) => print(e.toString()));
      await reference.execute(IncomesConnectionSQL.createTable).catchError((e) => print(e.toString()));
      await reference.execute(ProductsConnectionSQL.createTable).catchError((e) => print(e.toString()));
      await reference.execute(ProductEntriesConnectionSQL.createTable).catchError((e) => print(e.toString()));
      await reference.execute(ProductOutingsConnectionSQL.createTable).catchError((e) => print(e.toString()));
      await reference.execute(OthersConnectionSQL.createTable).catchError((e) => print(e.toString()));
      await reference.execute(OtherEntriesConnectionSQL.createTable).catchError((e) => print(e.toString()));
      await reference.execute(OtherOutingsConnectionSQL.createTable).catchError((e) => print(e.toString()));
      await reference.execute(ServicesConnectionSQL.createTable).catchError((e) => print(e.toString()));
      await reference.execute(TestsConnectionSQL.createTable).catchError((e) => print(e.toString()));
      await reference.execute(DoctorsConnectionSQL.createTable).catchError((e) => print(e.toString()));
      await reference.execute(ConsultationsConnectionSQL.createTable).catchError((e) => print(e.toString()));
      await reference.execute(PatientInvoiceItemsConnectionSQL.createTable).catchError((e) => print(e.toString()));
    });
  }

  /*static Map stringToMap(String value){
    List pairs = value.split(",");
    for (var pair in pairs) {

    }
  }
   */

}