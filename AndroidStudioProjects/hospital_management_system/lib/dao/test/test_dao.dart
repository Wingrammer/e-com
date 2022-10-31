
import 'package:hospital_management_system/dao/test/sql.dart';
import 'package:hospital_management_system/db.dart';
import 'package:hospital_management_system/models/test.dart';
import 'package:sqflite/sqflite.dart';

class TestDAO{

  final ConnectionSQLiteService _connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async {
    return await _connection.db;
  }

  Future<Test> insert(Test test) async {
    try {
      Database db = await _getDatabase();
      int id = await db.rawInsert(TestsConnectionSQL.insertTest(test));
      test.id = id;
      return test;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> insertMultiple(List<Test> tests) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (Test test in tests) { batch.rawInsert(TestsConnectionSQL.insertTest(test)); }
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
          results[ind] = await insert(tests[ind]);
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

  Future<bool> update(Test test) async {
    try {
      Database db = await _getDatabase();
      int affectedRows =
      await db.rawUpdate(TestsConnectionSQL.updateTest(test));
      if (affectedRows > 0) {
        return true;
      }
      return false;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> updateMultiple(List<Test> tests) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (Test test in tests) { batch.rawUpdate(TestsConnectionSQL.updateTest(test)); }
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
          bool success = await update(tests[ind]);
          if(success) results[ind] = tests[ind];
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

  Future<Test> upsert(Test test) async {
    try {
      Database db = await _getDatabase();
      await db.execute(TestsConnectionSQL.upsertTest(test));
      return test;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> upsertMultiple(List<Test> tests) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (Test test in tests) { batch.execute(TestsConnectionSQL.upsertTest(test)); }
      List results = await batch.commit(noResult: false, continueOnError: true);
      print('${results.length} results from batch run');
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
          await upsert(tests[ind]);
          results[ind] = tests[ind];
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

  Future<List<Test>> selectAll() async {
    try {
      Database db = await _getDatabase();
      List<Map> rows =
      await db.rawQuery(TestsConnectionSQL.selectAllTests());
      List<Test> tests = Test.fromSQLiteList(rows);
      return tests;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<bool> delete(Test test) async {
    try {
      Database db = await _getDatabase();
      int affectedRows = await db.rawUpdate(TestsConnectionSQL.deleteTest(test));
      if (affectedRows > 0) {
        return true;
      }
      return false;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> deleteMultiple(List<Test> tests) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (Test test in tests) { batch.rawDelete(TestsConnectionSQL.deleteTest(test)); }
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
          bool success = await update(tests[ind]);
          if(success) results[ind] = tests[ind];
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