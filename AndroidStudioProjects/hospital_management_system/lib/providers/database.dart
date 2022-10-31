import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    WidgetsFlutterBinding.ensureInitialized();
    _database = await _initDB();
    _database!.execute(
        """
            CREATE TABLE IF NOT EXISTS consultations (
              id INTEGER PRIMARY KEY,
              _id TEXT NOT NULL, 
              createdAt TEXT NOT NULL,
              updatedAt TEXT NOT NULL,
              deletedAt TEXT NOT NULL,
              date TEXT NOT NULL,
              doctor TEXT,
              patient TEXT NOT NULL,
              poids TEXT,
              programmé BOOLEAN,
              taille TEXT,
              temperature TEXT,
              tension TEXT,
              urgence BOOLEAN
            )""");
    _database!.execute(
        """
            CREATE TABLE IF NOT EXISTS assets (
              id INTEGER PRIMARY KEY,
              _id TEXT NOT NULL, 
              createdAt TEXT NOT NULL,
              updatedAt TEXT NOT NULL,
              deletedAt TEXT NOT NULL,
              etat TEXT,
              note TEXT,
              debutTEXT,
              fin TEXT
            )""");
    _database!.execute(
        """
            CREATE TABLE IF NOT EXISTS doctors (
              id INTEGER PRIMARY KEY,
              _id TEXT NOT NULL, 
              createdAt TEXT NOT NULL,
              updatedAt TEXT NOT NULL,
              deletedAt TEXT NOT NULL,
              nom TEXT,
              residence TEXT, 
              speciality TEXT
            )""");
    _database!.execute(
        """
            CREATE TABLE IF NOT EXISTS incomes (
              id INTEGER PRIMARY KEY,
              _id TEXT NOT NULL, 
              createdAt TEXT NOT NULL,
              updatedAt TEXT NOT NULL,
              deletedAt TEXT NOT NULL,
              patient TEXT NOT NULL,
              date TEXT NOT NULL,
              reference TEXT NOT NULL, 
              total TEXT NOT NULL
            )""");
    _database!.execute(
        """
            CREATE TABLE IF NOT EXISTS invoices (
              id INTEGER PRIMARY KEY,
              _id TEXT NOT NULL, 
              createdAt TEXT NOT NULL,
              updatedAt TEXT NOT NULL,
              deletedAt TEXT NOT NULL,
              date TEXT NOT NULL,
              vendeur TEXT NOT NULL,
              reference TEXT NOT NULL, 
              total TEXT NOT NULL
            )""");
    _database!.execute(
        """
            CREATE TABLE IF NOT EXISTS others (
              id INTEGER PRIMARY KEY,
              _id TEXT NOT NULL, 
              createdAt TEXT NOT NULL,
              updatedAt TEXT NOT NULL,
              deletedAt TEXT NOT NULL,
              nom TEXT NOT NULL,
              fabricant TEXT, 
              category TEXT,
              voie TEXT
            )""");
    _database!.execute(
        """
            CREATE TABLE IF NOT EXISTS products (
              id INTEGER PRIMARY KEY,
              _id TEXT NOT NULL, 
              createdAt TEXT NOT NULL,
              updatedAt TEXT NOT NULL,
              deletedAt TEXT NOT NULL,
              nom TEXT NOT NULL,
              fabricant TEXT, 
              category TEXT,
              voie TEXT
            )""");
    _database!.execute(
        """
            CREATE TABLE IF NOT EXISTS otherentries (
              id INTEGER PRIMARY KEY,
              _id TEXT NOT NULL, 
              createdAt TEXT NOT NULL,
              updatedAt TEXT NOT NULL,
              deletedAt TEXT NOT NULL,
              produit TEXT NOT NULL,
              quantite TEXT NOT NULL, 
              expirationDate TEXT NOT NULL,
              sellingPrice TEXT,
              buyingPrice TEXT NOT NULL,
              facture TEXT NOT NULL
            )""");
    _database!.execute(
        """
            CREATE TABLE IF NOT EXISTS productentries (
              id INTEGER PRIMARY KEY,
              _id TEXT NOT NULL, 
              createdAt TEXT NOT NULL,
              updatedAt TEXT NOT NULL,
              deletedAt TEXT NOT NULL,
              produit TEXT NOT NULL,
              quantite TEXT NOT NULL, 
              expirationDate TEXT NOT NULL,
              sellingPrice TEXT,
              buyingPrice TEXT NOT NULL,
              facture TEXT NOT NULL
            )""");
    _database!.execute(
        """
            CREATE TABLE IF NOT EXISTS otheroutings (
              id INTEGER PRIMARY KEY,
              _id TEXT NOT NULL, 
              createdAt TEXT NOT NULL,
              updatedAt TEXT NOT NULL,
              deletedAt TEXT NOT NULL,
              recu TEXT,
              produit TEXT NOT NULL, 
              quantite TEXT NOT NULL
            )""");
    _database!.execute(
        """
            CREATE TABLE IF NOT EXISTS productoutings (
              id INTEGER PRIMARY KEY,
              _id TEXT NOT NULL, 
              createdAt TEXT NOT NULL,
              updatedAt TEXT NOT NULL,
              deletedAt TEXT NOT NULL,
              recu TEXT,
              produit TEXT NOT NULL, 
              quantite TEXT NOT NULL
            )""");
    _database!.execute(
        """
            CREATE TABLE IF NOT EXISTS patients (
              id INTEGER PRIMARY KEY,
              _id TEXT NOT NULL, 
              createdAt TEXT NOT NULL,
              updatedAt TEXT NOT NULL,
              deletedAt TEXT NOT NULL,
              nom TEXT NOT NULL,
              provenance TEXT NOT NULL, 
              matricule TEXT NOT NULL
            )""");
    _database!.execute(
        """
            CREATE TABLE IF NOT EXISTS patientinvoiceitems (
              id INTEGER PRIMARY KEY,
              _id TEXT NOT NULL, 
              createdAt TEXT NOT NULL,
              updatedAt TEXT NOT NULL,
              deletedAt TEXT NOT NULL,
              conclusion TEXT,
              consultation TEXT NOT NULL, 
              note TEXT,
              receipt TEXT NOT NULL,
              status TEXT,
              result TEXT,
              quantite TEXT NOT NULL,
              service TEXT NOT NULL,
              paid TEXT NOT NULL
            )""");
    _database!.execute(
        """
            CREATE TABLE IF NOT EXISTS services (
              id INTEGER PRIMARY KEY,
              _id TEXT NOT NULL, 
              createdAt TEXT NOT NULL,
              updatedAt TEXT NOT NULL,
              deletedAt TEXT NOT NULL,
              department TEXT NOT NULL,
              nom TEXT NOT NULL, 
              prix TEXT NOT NULL
            )""");
    _database!.execute(
        """
            CREATE TABLE IF NOT EXISTS tests (
              id INTEGER PRIMARY KEY,
              _id TEXT NOT NULL,
              createdAt TEXT NOT NULL,
              updatedAt TEXT NOT NULL,
              deletedAt TEXT NOT NULL, 
              recu TEXT NOT NULL,
              service TEXT NOT NULL
            )""");
    _database!.execute(
        """
            CREATE TABLE IF NOT EXISTS users (
              id INTEGER PRIMARY KEY,
              _id TEXT NOT NULL,
              birthDate TEXT,
              code TEXT, 
              displayName TEXT,
              email TEXT,
              password TEXT,
              genre TEXT,
              phoneNumber TEXT,
              vip BOOLEAN
            )
          """);
    return _database!;
  }


  Future<Database> _initDB() async {
    sqfliteFfiInit();
    var databaseFactory = databaseFactoryFfi;
    print('The path is $inMemoryDatabasePath');
    return await databaseFactory.openDatabase(
      join(inMemoryDatabasePath, 'chc.db'));
  }

  Future<void> insert(table, model) async {
    final db = await instance.database;
    await db.insert(table, model.toMap(), conflictAlgorithm: ConflictAlgorithm.replace)
    .then((value){
      print(value);
      return value;
    });
  }

  Future<int> update(table, model) async {
    final db = await instance.database;
    int result = await db.update(
      table,
      model.toMap(),
      where: "id = ?",
      whereArgs: [model.id],
    );
    return result;
  }



  Future<List> retrieve(table, model) async {
    print("About to retrieve $table");
    final db = await instance.database;
    final List<Map<String, dynamic>> queryResult = await db.query(table);
    print(queryResult.length);
    List payload = [];
    queryResult.forEach((e){
      print("po");
      payload.add(model.fromMap(e));
    });
    return payload;
  }

  Future<void> delete(table, String id) async {
    final db = await instance.database;
    await db.delete(
      table,
      where: "id = ?",
      whereArgs: [id],
    );
  }

}