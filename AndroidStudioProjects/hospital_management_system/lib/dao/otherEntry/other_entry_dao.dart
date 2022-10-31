import 'package:hospital_management_system/dao/otherEntry/sql.dart';
import 'package:hospital_management_system/db.dart';
import 'package:hospital_management_system/models/otherEntry.dart';
import 'package:sqflite/sqflite.dart';

class OtherEntryDAO{

  final ConnectionSQLiteService _connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async {
    return await _connection.db;
  }

  Future<OtherEntry> insert(OtherEntry otherEntry) async {
    try {
      Database db = await _getDatabase();
      int id = await db.rawInsert(OtherEntriesConnectionSQL.insertOtherEntry(otherEntry));
      otherEntry.id = id;
      return otherEntry;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> insertMultiple(List<OtherEntry> otherEntries) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (OtherEntry otherEntry in otherEntries) { batch.rawInsert(OtherEntriesConnectionSQL.insertOtherEntry(otherEntry)); }
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

  Future<bool> update(OtherEntry otherEntry) async {
    try {
      Database db = await _getDatabase();
      int affectedRows =
      await db.rawUpdate(OtherEntriesConnectionSQL.updateOtherEntry(otherEntry));
      if (affectedRows > 0) {
        return true;
      }
      return false;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> updateMultiple(List<OtherEntry> otherEntries) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (OtherEntry otherEntry in otherEntries) { batch.rawUpdate(OtherEntriesConnectionSQL.updateOtherEntry(otherEntry)); }
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

  Future<OtherEntry> upsert(OtherEntry otherEntry) async {
    try {
      Database db = await _getDatabase();
      await db.execute(OtherEntriesConnectionSQL.upsertOtherEntry(otherEntry));
      return otherEntry;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> upsertMultiple(List<OtherEntry> otherEntries) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (OtherEntry otherEntry in otherEntries) { batch.execute(OtherEntriesConnectionSQL.upsertOtherEntry(otherEntry)); }
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

  Future<List<OtherEntry>> selectAll() async {
    try {
      Database db = await _getDatabase();
      List<Map> rows =
      await db.rawQuery(OtherEntriesConnectionSQL.selectAllOtherEntries());
      List<OtherEntry> otherEntries = OtherEntry.fromSQLiteList(rows);
      return otherEntries;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<bool> delete(OtherEntry otherEntry) async {
    try {
      Database db = await _getDatabase();
      int affectedRows = await db.rawUpdate(OtherEntriesConnectionSQL.deleteOtherEntry(otherEntry));
      if (affectedRows > 0) {
        return true;
      }
      return false;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> deleteMultiple(List<OtherEntry> otherEntries) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (OtherEntry otherEntry in otherEntries) { batch.rawDelete(OtherEntriesConnectionSQL.deleteOtherEntry(otherEntry)); }
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