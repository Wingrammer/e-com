
import 'package:hospital_management_system/dao/productOuting/sql.dart';
import 'package:hospital_management_system/db.dart';
import 'package:hospital_management_system/models/productOuting.dart';
import 'package:sqflite/sqflite.dart';

class ProductOutingDAO{

  final ConnectionSQLiteService _connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async {
    return await _connection.db;
  }

  Future<ProductOuting> insert(ProductOuting productOuting) async {
    try {
      Database db = await _getDatabase();
      int id = await db.rawInsert(ProductOutingsConnectionSQL.insertProductOuting(productOuting));
      productOuting.id = id;
      return productOuting;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> insertMultiple(List<ProductOuting> productOutings) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (ProductOuting productOuting in productOutings) { batch.rawInsert(ProductOutingsConnectionSQL.insertProductOuting(productOuting)); }
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
          results[ind] = await insert(productOutings[ind]);
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

  Future<bool> update(ProductOuting productOuting) async {
    try {
      Database db = await _getDatabase();
      int affectedRows =
      await db.rawUpdate(ProductOutingsConnectionSQL.updateProductOuting(productOuting));
      if (affectedRows > 0) {
        return true;
      }
      return false;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> updateMultiple(List<ProductOuting> productOutings) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (ProductOuting productOuting in productOutings) { batch.rawUpdate(ProductOutingsConnectionSQL.updateProductOuting(productOuting)); }
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
          bool success = await update(productOutings[ind]);
          if(success) results[ind] = productOutings[ind];
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

  Future<ProductOuting> upsert(ProductOuting productOuting) async {
    try {
      Database db = await _getDatabase();
      await db.execute(ProductOutingsConnectionSQL.upsertProductOuting(productOuting));
      return productOuting;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> upsertMultiple(List<ProductOuting> productOutings) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (ProductOuting productOuting in productOutings) { batch.execute(ProductOutingsConnectionSQL.upsertProductOuting(productOuting)); }
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
          await upsert(productOutings[ind]);
          results[ind] = productOutings[ind];
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

  Future<List<ProductOuting>> selectAll() async {
    try {
      Database db = await _getDatabase();
      List<Map> rows =
      await db.rawQuery(ProductOutingsConnectionSQL.selectAllProductOutings());
      List<ProductOuting> productOutings = ProductOuting.fromSQLiteList(rows);
      return productOutings;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<bool> delete(ProductOuting productOuting) async {
    try {
      Database db = await _getDatabase();
      int affectedRows = await db.rawUpdate(ProductOutingsConnectionSQL.deleteProductOuting(productOuting));
      if (affectedRows > 0) {
        return true;
      }
      return false;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> deleteMultiple(List<ProductOuting> productOutings) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (ProductOuting productOuting in productOutings) { batch.rawDelete(ProductOutingsConnectionSQL.deleteProductOuting(productOuting)); }
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
          bool success = await update(productOutings[ind]);
          if(success) results[ind] = productOutings[ind];
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