
import 'package:hospital_management_system/dao/otherOuting/sql.dart';
import 'package:hospital_management_system/db.dart';
import 'package:hospital_management_system/models/otherOuting.dart';
import 'package:sqflite/sqflite.dart';

class OtherOutingDAO{

  final ConnectionSQLiteService _connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async {
    return await _connection.db;
  }

  Future<OtherOuting> insert(OtherOuting otherOuting) async {
    try {
      Database db = await _getDatabase();
      int id = await db.rawInsert(OtherOutingsConnectionSQL.insertOtherOuting(otherOuting));
      otherOuting.id = id;
      return otherOuting;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> insertMultiple(List<OtherOuting> otherOutings) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (OtherOuting otherOuting in otherOutings) { batch.rawInsert(OtherOutingsConnectionSQL.insertOtherOuting(otherOuting)); }
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
          results[ind] = await insert(otherOutings[ind]);
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

  Future<bool> update(OtherOuting otherOuting) async {
    try {
      Database db = await _getDatabase();
      int affectedRows =
      await db.rawUpdate(OtherOutingsConnectionSQL.updateOtherOuting(otherOuting));
      if (affectedRows > 0) {
        return true;
      }
      return false;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> updateMultiple(List<OtherOuting> otherOutings) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (OtherOuting otherOuting in otherOutings) { batch.rawUpdate(OtherOutingsConnectionSQL.updateOtherOuting(otherOuting)); }
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
          bool success = await update(otherOutings[ind]);
          if(success) results[ind] = otherOutings[ind];
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

  Future<OtherOuting> upsert(OtherOuting otherOuting) async {
    try {
      Database db = await _getDatabase();
      await db.execute(OtherOutingsConnectionSQL.upsertOtherOuting(otherOuting));
      return otherOuting;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> upsertMultiple(List<OtherOuting> otherOutings) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (OtherOuting otherOuting in otherOutings) { batch.execute(OtherOutingsConnectionSQL.upsertOtherOuting(otherOuting)); }
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
          await upsert(otherOutings[ind]);
          results[ind] = otherOutings[ind];
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

  Future<List<OtherOuting>> selectAll() async {
    try {
      Database db = await _getDatabase();
      List<Map> rows =
      await db.rawQuery(OtherOutingsConnectionSQL.selectAllOtherOutings());
      List<OtherOuting> otherOutings = OtherOuting.fromSQLiteList(rows);
      return otherOutings;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<bool> delete(OtherOuting otherOuting) async {
    try {
      Database db = await _getDatabase();
      int affectedRows = await db.rawUpdate(OtherOutingsConnectionSQL.deleteOtherOuting(otherOuting));
      if (affectedRows > 0) {
        return true;
      }
      return false;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> deleteMultiple(List<OtherOuting> otherOutings) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (OtherOuting otherOuting in otherOutings) { batch.rawDelete(OtherOutingsConnectionSQL.deleteOtherOuting(otherOuting)); }
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
          bool success = await update(otherOutings[ind]);
          if(success) results[ind] = otherOutings[ind];
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