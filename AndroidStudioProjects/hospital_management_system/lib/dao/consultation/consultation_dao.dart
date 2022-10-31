import 'package:hospital_management_system/dao/consultation/sql.dart';
import 'package:hospital_management_system/db.dart';
import 'package:hospital_management_system/models/consultation.dart';
import 'package:sqflite/sqflite.dart';

class ConsultationDAO{

  final ConnectionSQLiteService _connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async {
    return await _connection.db;
  }

  Future<Consultation> insert(Consultation consultation) async {
    try {
      Database db = await _getDatabase();
      int id = await db.rawInsert(ConsultationsConnectionSQL.insertConsultation(consultation));
      consultation.id = id;
      return consultation;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> insertMultiple(List<Consultation> consultations) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (Consultation consultation in consultations) { batch.rawInsert(ConsultationsConnectionSQL.insertConsultation(consultation)); }
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
          results[ind] = await insert(consultations[ind]);
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

  Future<bool> update(Consultation consultation) async {
    try {
      Database db = await _getDatabase();
      int affectedRows =
      await db.rawUpdate(ConsultationsConnectionSQL.updateConsultation(consultation));
      if (affectedRows > 0) {
        return true;
      }
      return false;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> updateMultiple(List<Consultation> consultations) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (Consultation consultation in consultations) { batch.rawUpdate(ConsultationsConnectionSQL.updateConsultation(consultation)); }
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
          bool success = await update(consultations[ind]);
          if(success) results[ind] = consultations[ind];
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

  Future<Consultation> upsert(Consultation consultation) async {
    try {
      Database db = await _getDatabase();
      await db.execute(ConsultationsConnectionSQL.upsertConsultation(consultation));
      return consultation;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> upsertMultiple(List<Consultation> consultations) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (Consultation consultation in consultations) { batch.execute(ConsultationsConnectionSQL.upsertConsultation(consultation)); }
      List results = await batch.commit(noResult: false, continueOnError: false);
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
          await upsert(consultations[ind]);
          results[ind] = consultations[ind];
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

  Future<List<Consultation>> selectAll() async {
    try {
      Database db = await _getDatabase();
      List<Map> rows =
      await db.rawQuery(ConsultationsConnectionSQL.selectAllConsultations());
      List<Consultation> consultations = Consultation.fromSQLiteList(rows);
      return consultations;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<bool> delete(Consultation consultation) async {
    try {
      Database db = await _getDatabase();
      int affectedRows = await db.rawUpdate(ConsultationsConnectionSQL.deleteConsultation(consultation));
      if (affectedRows > 0) {
        return true;
      }
      return false;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> deleteMultiple(List<Consultation> consultations) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (Consultation consultation in consultations) { batch.rawDelete(ConsultationsConnectionSQL.deleteConsultation(consultation)); }
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
          bool success = await update(consultations[ind]);
          if(success) results[ind] = consultations[ind];
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