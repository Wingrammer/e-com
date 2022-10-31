import 'package:hospital_management_system/dao/otherEntry/sql.dart';
import 'package:hospital_management_system/dao/productEntry/sql.dart';
import 'package:hospital_management_system/db.dart';
import 'package:hospital_management_system/models/otherEntry.dart';
import 'package:hospital_management_system/models/productEntry.dart';
import 'package:sqflite/sqflite.dart';

class ProductEntryDAO{

  final ConnectionSQLiteService _connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async {
    return await _connection.db;
  }

  Future<ProductEntry> insert(ProductEntry otherEntry) async {
    try {
      Database db = await _getDatabase();
      int id = await db.rawInsert(ProductEntriesConnectionSQL.insertProductEntry(otherEntry));
      otherEntry.id = id;
      return otherEntry;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> insertMultiple(List<ProductEntry> otherEntries) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (ProductEntry otherEntry in otherEntries) { batch.rawInsert(ProductEntriesConnectionSQL.insertProductEntry(otherEntry)); }
      List results = await batch.commit(noResult: false, continueOnError: true);
      int ind = -1;
      List<int> retrials = [];
      for (var e in results) {
        ind++;
        if(e==DatabaseException){
          print('Element at index $ind failed in batch commit');
          retrials.add(ind);
        }
      }
      if(retrials.isNotEmpty){
        print('${retrials.length} failed in batch commit');
        for (int ind in retrials) {
          print('Retrying the transaction at position $ind individually');
          results[ind] = await insert(otherEntries[ind]);
        }
        return results;
      }
      print("The batch commit has been run without error");
      return results;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<bool> update(ProductEntry otherEntry) async {
    try {
      Database db = await _getDatabase();
      int affectedRows =
      await db.rawUpdate(ProductEntriesConnectionSQL.updateProductEntry(otherEntry));
      if (affectedRows > 0) {
        return true;
      }
      return false;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> updateMultiple(List<ProductEntry> otherEntries) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (ProductEntry otherEntry in otherEntries) { batch.rawUpdate(ProductEntriesConnectionSQL.updateProductEntry(otherEntry)); }
      List results = await batch.commit(noResult: false, continueOnError: true);
      int ind = -1;
      List<int> retrials = [];
      for (var e in results) {
        ind++;
        if(e==DatabaseException){
          print('Element at index $ind failed in batch commit');
          retrials.add(ind);
        }
      }
      if(retrials.isNotEmpty){
        print('${retrials.length} failed in batch commit');
        for (int ind in retrials) {
          print('Retrying the transaction at position $ind individually');
          bool success = await update(otherEntries[ind]);
          if(success) results[ind] = otherEntries[ind];
        }
        return results;
      }
      print("The batch commit has been run without error");
      return results;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<ProductEntry> upsert(ProductEntry otherEntry) async {
    try {
      Database db = await _getDatabase();
      await db.execute(ProductEntriesConnectionSQL.upsertProductEntry(otherEntry));
      return otherEntry;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> upsertMultiple(List<ProductEntry> otherEntries) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (ProductEntry otherEntry in otherEntries) { batch.execute(ProductEntriesConnectionSQL.upsertProductEntry(otherEntry)); }
      List results = await batch.commit(noResult: false, continueOnError: true);
      int ind = -1;
      List<int> retrials = [];
      for (var e in results) {
        ind++;
        if(e==DatabaseException){
          print('Element at index $ind failed in batch commit');
          retrials.add(ind);
        }
      }
      if(retrials.isNotEmpty){
        print('${retrials.length} failed in batch commit');
        for (int ind in retrials) {
          print('Retrying the transaction at position $ind individually');
          await upsert(otherEntries[ind]);
          results[ind] = otherEntries[ind];
        }
        return results;
      }
      print("The batch commit has been run without error");
      return results;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List<ProductEntry>> selectAll() async {
    try {
      Database db = await _getDatabase();
      List<Map> rows =
      await db.rawQuery(ProductEntriesConnectionSQL.selectAllProductEntries());
      List<ProductEntry> otherEntries = ProductEntry.fromSQLiteList(rows);
      return otherEntries;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<bool> delete(ProductEntry otherEntry) async {
    try {
      Database db = await _getDatabase();
      int affectedRows = await db.rawUpdate(ProductEntriesConnectionSQL.deleteProductEntry(otherEntry));
      if (affectedRows > 0) {
        return true;
      }
      return false;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> deleteMultiple(List<ProductEntry> otherEntries) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (ProductEntry otherEntry in otherEntries) { batch.rawDelete(ProductEntriesConnectionSQL.deleteProductEntry(otherEntry)); }
      List results = await batch.commit(noResult: false, continueOnError: true);
      int ind = -1;
      List<int> retrials = [];
      for (var e in results) {
        ind++;
        if(e==DatabaseException){
          print('Element at index $ind failed in batch commit');
          retrials.add(ind);
        }
      }
      if(retrials.isNotEmpty){
        print('${retrials.length} failed in batch commit');
        for (int ind in retrials) {
          print('Retrying the transaction at position $ind individually');
          bool success = await update(otherEntries[ind]);
          if(success) results[ind] = otherEntries[ind];
        }
        return results;
      }
      print("The batch commit has been run without error");
      return results;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

}