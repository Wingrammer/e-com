
import 'package:hospital_management_system/dao/service/sql.dart';
import 'package:hospital_management_system/db.dart';
import 'package:hospital_management_system/models/service.dart';
import 'package:sqflite/sqflite.dart';

class ServiceDAO{

  final ConnectionSQLiteService _connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async {
    return await _connection.db;
  }

  Future<Service> insert(Service service) async {
    try {
      Database db = await _getDatabase();
      int id = await db.rawInsert(ServicesConnectionSQL.insertService(service));
      service.id = id;
      return service;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> insertMultiple(List<Service> services) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (Service service in services) { batch.rawInsert(ServicesConnectionSQL.insertService(service)); }
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
          results[ind] = await insert(services[ind]);
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

  Future<bool> update(Service service) async {
    try {
      Database db = await _getDatabase();
      int affectedRows =
      await db.rawUpdate(ServicesConnectionSQL.updateService(service));
      if (affectedRows > 0) {
        return true;
      }
      return false;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> updateMultiple(List<Service> services) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (Service service in services) { batch.rawUpdate(ServicesConnectionSQL.updateService(service)); }
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
          bool success = await update(services[ind]);
          if(success) results[ind] = services[ind];
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

  Future<Service> upsert(Service service) async {
    try {
      Database db = await _getDatabase();
      await db.execute(ServicesConnectionSQL.upsertService(service));
      return service;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> upsertMultiple(List<Service> services) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (Service service in services) { batch.execute(ServicesConnectionSQL.upsertService(service)); }
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
          await upsert(services[ind]);
          results[ind] = services[ind];
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

  Future<List<Service>> selectAll() async {
    try {
      Database db = await _getDatabase();
      List<Map> rows =
      await db.rawQuery(ServicesConnectionSQL.selectAllServices());
      List<Service> services = Service.fromSQLiteList(rows);
      return services;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<bool> delete(Service service) async {
    try {
      Database db = await _getDatabase();
      int affectedRows = await db.rawUpdate(ServicesConnectionSQL.deleteService(service));
      if (affectedRows > 0) {
        return true;
      }
      return false;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> deleteMultiple(List<Service> services) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (Service service in services) { batch.rawDelete(ServicesConnectionSQL.deleteService(service)); }
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
          bool success = await update(services[ind]);
          if(success) results[ind] = services[ind];
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