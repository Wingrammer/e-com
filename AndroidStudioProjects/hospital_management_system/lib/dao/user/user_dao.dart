
import 'package:hospital_management_system/dao/user/sql.dart';
import 'package:hospital_management_system/db.dart';
import 'package:hospital_management_system/models/user.dart';
import 'package:sqflite/sqflite.dart';

class UserDAO{

  final ConnectionSQLiteService _connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async {
    return await _connection.db;
  }

  Future<User> insert(User user) async {
    try {
      Database db = await _getDatabase();
      int id = await db.rawInsert(UsersConnectionSQL.insertUser(user));
      user.id = id;
      return user;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> insertMultiple(List<User> users) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (User user in users) { batch.rawInsert(UsersConnectionSQL.insertUser(user)); }
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
          results[ind] = await insert(users[ind]);
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

  Future<bool> update(User user) async {
    try {
      Database db = await _getDatabase();
      int affectedRows =
      await db.rawUpdate(UsersConnectionSQL.updateUser(user));
      if (affectedRows > 0) {
        return true;
      }
      return false;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> updateMultiple(List<User> users) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (User user in users) { batch.rawUpdate(UsersConnectionSQL.updateUser(user)); }
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
          bool success = await update(users[ind]);
          if(success) results[ind] = users[ind];
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

  Future<User> upsert(User user) async {
    try {
      Database db = await _getDatabase();
      await db.execute(UsersConnectionSQL.upsertUser(user));
      return user;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> upsertMultiple(List<User> users) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (User user in users) { batch.execute(UsersConnectionSQL.upsertUser(user)); }
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
          await upsert(users[ind]);
          results[ind] = users[ind];
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

  Future<List<User>> selectAll() async {
    try {
      Database db = await _getDatabase();
      List<Map> rows =
      await db.rawQuery(UsersConnectionSQL.selectAllUsers());
      List<User> users = User.fromSQLiteList(rows);
      return users;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<bool> delete(User user) async {
    try {
      Database db = await _getDatabase();
      int affectedRows = await db.rawUpdate(UsersConnectionSQL.deleteUser(user));
      if (affectedRows > 0) {
        return true;
      }
      return false;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> deleteMultiple(List<User> users) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (User user in users) { batch.rawDelete(UsersConnectionSQL.deleteUser(user)); }
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
          bool success = await update(users[ind]);
          if(success) results[ind] = users[ind];
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