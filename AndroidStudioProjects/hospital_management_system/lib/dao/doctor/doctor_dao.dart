import 'package:hospital_management_system/dao/doctor/sql.dart';
import 'package:hospital_management_system/db.dart';
import 'package:hospital_management_system/models/doctor.dart';
import 'package:sqflite/sqflite.dart';

class DoctorDAO{

  final ConnectionSQLiteService _connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async {
    return await _connection.db;
  }

  Future<Doctor> insert(Doctor doctor) async {
    try {
      Database db = await _getDatabase();
      int id = await db.rawInsert(DoctorsConnectionSQL.insertDoctor(doctor));
      doctor.id = id;
      return doctor;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> insertMultiple(List<Doctor> doctors) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (Doctor doctor in doctors) { batch.rawInsert(DoctorsConnectionSQL.insertDoctor(doctor)); }
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
          results[ind] = await insert(doctors[ind]);
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

  Future<bool> update(Doctor doctor) async {
    try {
      Database db = await _getDatabase();
      int affectedRows =
      await db.rawUpdate(DoctorsConnectionSQL.updateDoctor(doctor));
      if (affectedRows > 0) {
        return true;
      }
      return false;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> updateMultiple(List<Doctor> doctors) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (Doctor doctor in doctors) { batch.rawUpdate(DoctorsConnectionSQL.updateDoctor(doctor)); }
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
          bool success = await update(doctors[ind]);
          if(success) results[ind] = doctors[ind];
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

  Future<Doctor> upsert(Doctor doctor) async {
    try {
      Database db = await _getDatabase();
      await db.execute(DoctorsConnectionSQL.upsertDoctor(doctor));
      return doctor;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> upsertMultiple(List<Doctor> doctors) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (Doctor doctor in doctors) { batch.execute(DoctorsConnectionSQL.upsertDoctor(doctor)); }
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
          await upsert(doctors[ind]);
          results[ind] = doctors[ind];
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

  Future<List<Doctor>> selectAll() async {
    try {
      Database db = await _getDatabase();
      List<Map> rows =
      await db.rawQuery(DoctorsConnectionSQL.selectAllDoctors());
      List<Doctor> doctors = Doctor.fromSQLiteList(rows);
      return doctors;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<bool> delete(Doctor doctor) async {
    try {
      Database db = await _getDatabase();
      int affectedRows = await db.rawUpdate(DoctorsConnectionSQL.deleteDoctor(doctor));
      if (affectedRows > 0) {
        return true;
      }
      return false;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> deleteMultiple(List<Doctor> doctors) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (Doctor doctor in doctors) { batch.rawDelete(DoctorsConnectionSQL.deleteDoctor(doctor)); }
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
          bool success = await update(doctors[ind]);
          if(success) results[ind] = doctors[ind];
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