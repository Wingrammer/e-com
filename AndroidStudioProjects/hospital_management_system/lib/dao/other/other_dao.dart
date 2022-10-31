
import 'package:hospital_management_system/dao/other/sql.dart';
import 'package:hospital_management_system/db.dart';
import 'package:hospital_management_system/models/other.dart';
import 'package:sqflite/sqflite.dart';

class OtherDAO{

  final ConnectionSQLiteService _connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async {
    return await _connection.db;
  }

  Future<Other> insert(Other other) async {
    try {
      Database db = await _getDatabase();
      int id = await db.rawInsert(OthersConnectionSQL.insertOther(other));
      other.id = id;
      return other;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> insertMultiple(List<Other> others) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (Other other in others) { batch.rawInsert(OthersConnectionSQL.insertOther(other)); }
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
          results[ind] = await insert(others[ind]);
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

  Future<bool> update(Other other) async {
    try {
      Database db = await _getDatabase();
      int affectedRows =
      await db.rawUpdate(OthersConnectionSQL.updateOther(other));
      if (affectedRows > 0) {
        return true;
      }
      return false;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> updateMultiple(List<Other> others) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (Other other in others) { batch.rawUpdate(OthersConnectionSQL.updateOther(other)); }
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
          bool success = await update(others[ind]);
          if(success) results[ind] = others[ind];
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

  Future<Other> upsert(Other other) async {
    try {
      Database db = await _getDatabase();
      await db.execute(OthersConnectionSQL.upsertOther(other));
      return other;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> upsertMultiple(List<Other> others) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (Other other in others) { batch.execute(OthersConnectionSQL.upsertOther(other)); }
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
          await upsert(others[ind]);
          results[ind] = others[ind];
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

  Future<List<Other>> selectAll() async {
    try {
      Database db = await _getDatabase();
      List<Map> rows =
      await db.rawQuery(OthersConnectionSQL.selectAllOthers());
      List<Other> others = Other.fromSQLiteList(rows);
      return others;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<bool> delete(Other other) async {
    try {
      Database db = await _getDatabase();
      int affectedRows = await db.rawUpdate(OthersConnectionSQL.deleteOther(other));
      if (affectedRows > 0) {
        return true;
      }
      return false;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> deleteMultiple(List<Other> others) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (Other other in others) { batch.rawDelete(OthersConnectionSQL.deleteOther(other)); }
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
          bool success = await update(others[ind]);
          if(success) results[ind] = others[ind];
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