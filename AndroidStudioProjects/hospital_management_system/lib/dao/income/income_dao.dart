
import 'package:hospital_management_system/dao/income/sql.dart';
import 'package:hospital_management_system/db.dart';
import 'package:hospital_management_system/models/income.dart';
import 'package:sqflite/sqflite.dart';

class IncomeDAO{

  final ConnectionSQLiteService _connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async {
    return await _connection.db;
  }

  Future<Income> insert(Income income) async {
    try {
      Database db = await _getDatabase();
      int id = await db.rawInsert(IncomesConnectionSQL.insertIncome(income));
      income.id = id;
      return income;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> insertMultiple(List<Income> incomes) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (Income income in incomes) { batch.rawInsert(IncomesConnectionSQL.insertIncome(income)); }
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
          results[ind] = await insert(incomes[ind]);
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

  Future<bool> update(Income income) async {
    try {
      Database db = await _getDatabase();
      int affectedRows =
      await db.rawUpdate(IncomesConnectionSQL.updateIncome(income));
      if (affectedRows > 0) {
        return true;
      }
      return false;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> updateMultiple(List<Income> incomes) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (Income income in incomes) { batch.rawUpdate(IncomesConnectionSQL.updateIncome(income)); }
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
          bool success = await update(incomes[ind]);
          if(success) results[ind] = incomes[ind];
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

  Future<Income> upsert(Income income) async {
    try {
      Database db = await _getDatabase();
      await db.execute(IncomesConnectionSQL.upsertIncome(income));
      return income;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> upsertMultiple(List<Income> incomes) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (Income income in incomes) { batch.execute(IncomesConnectionSQL.upsertIncome(income)); }
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
          await upsert(incomes[ind]);
          results[ind] = incomes[ind];
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

  Future<List<Income>> selectAll() async {
    try {
      Database db = await _getDatabase();
      List<Map> rows =
      await db.rawQuery(IncomesConnectionSQL.selectAllIncomes());
      List<Income> incomes = Income.fromSQLiteList(rows);
      return incomes;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<bool> delete(Income income) async {
    try {
      Database db = await _getDatabase();
      int affectedRows = await db.rawUpdate(IncomesConnectionSQL.deleteIncome(income));
      if (affectedRows > 0) {
        return true;
      }
      return false;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> deleteMultiple(List<Income> incomes) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (Income income in incomes) { batch.rawDelete(IncomesConnectionSQL.deleteIncome(income)); }
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
          bool success = await update(incomes[ind]);
          if(success) results[ind] = incomes[ind];
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