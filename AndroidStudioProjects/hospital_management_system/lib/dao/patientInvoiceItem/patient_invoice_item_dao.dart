import 'package:hospital_management_system/dao/patientInvoiceItem/sql.dart';
import 'package:hospital_management_system/db.dart';
import 'package:hospital_management_system/models/patientInvoiceItem.dart';
import 'package:sqflite/sqflite.dart';

class PatientInvoiceItemDAO{

  final ConnectionSQLiteService _connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async {
    return await _connection.db;
  }

  Future<PatientInvoiceItem> insert(PatientInvoiceItem patientInvoiceItem) async {
    try {
      Database db = await _getDatabase();
      int id = await db.rawInsert(PatientInvoiceItemsConnectionSQL.insertPatientInvoiceItem(patientInvoiceItem));
      patientInvoiceItem.id = id;
      return patientInvoiceItem;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> insertMultiple(List<PatientInvoiceItem> patientInvoiceItems) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (PatientInvoiceItem patientInvoiceItem in patientInvoiceItems) { batch.rawInsert(PatientInvoiceItemsConnectionSQL.insertPatientInvoiceItem(patientInvoiceItem)); }
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
          results[ind] = await insert(patientInvoiceItems[ind]);
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

  Future<bool> update(PatientInvoiceItem patientInvoiceItem) async {
    try {
      Database db = await _getDatabase();
      int affectedRows =
      await db.rawUpdate(PatientInvoiceItemsConnectionSQL.updatePatientInvoiceItem(patientInvoiceItem));
      if (affectedRows > 0) {
        return true;
      }
      return false;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> updateMultiple(List<PatientInvoiceItem> patientInvoiceItems) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (PatientInvoiceItem patientInvoiceItem in patientInvoiceItems) { batch.rawUpdate(PatientInvoiceItemsConnectionSQL.updatePatientInvoiceItem(patientInvoiceItem)); }
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
          bool success = await update(patientInvoiceItems[ind]);
          if(success) results[ind] = patientInvoiceItems[ind];
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

  Future<PatientInvoiceItem> upsert(PatientInvoiceItem patientInvoiceItem) async {
    try {
      Database db = await _getDatabase();
      await db.execute(PatientInvoiceItemsConnectionSQL.upsertPatientInvoiceItem(patientInvoiceItem));
      return patientInvoiceItem;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> upsertMultiple(List<PatientInvoiceItem> patientInvoiceItems) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (PatientInvoiceItem patientInvoiceItem in patientInvoiceItems) { batch.execute(PatientInvoiceItemsConnectionSQL.upsertPatientInvoiceItem(patientInvoiceItem)); }
      List results = await batch.commit(noResult: false, continueOnError: true);
      print(results.length);
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
          await upsert(patientInvoiceItems[ind]);
          results[ind] = patientInvoiceItems[ind];
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

  Future<List<PatientInvoiceItem>> selectAll() async {
    try {
      Database db = await _getDatabase();
      List<Map> rows =
      await db.rawQuery(PatientInvoiceItemsConnectionSQL.selectAllPatientInvoiceItems());
      List<PatientInvoiceItem> patientInvoiceItems = PatientInvoiceItem.fromSQLiteList(rows);
      return patientInvoiceItems;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<bool> delete(PatientInvoiceItem patientInvoiceItem) async {
    try {
      Database db = await _getDatabase();
      int affectedRows = await db.rawUpdate(PatientInvoiceItemsConnectionSQL.deletePatientInvoiceItem(patientInvoiceItem));
      if (affectedRows > 0) {
        return true;
      }
      return false;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> deleteMultiple(List<PatientInvoiceItem> patientInvoiceItems) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (PatientInvoiceItem patientInvoiceItem in patientInvoiceItems) { batch.rawDelete(PatientInvoiceItemsConnectionSQL.deletePatientInvoiceItem(patientInvoiceItem)); }
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
          bool success = await update(patientInvoiceItems[ind]);
          if(success) results[ind] = patientInvoiceItems[ind];
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