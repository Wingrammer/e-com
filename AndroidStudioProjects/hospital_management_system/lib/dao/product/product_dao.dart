
import 'package:hospital_management_system/dao/product/sql.dart';
import 'package:hospital_management_system/db.dart';
import 'package:hospital_management_system/models/product.dart';
import 'package:sqflite/sqflite.dart';

class ProductDAO{

  final ConnectionSQLiteService _connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async {
    return await _connection.db;
  }

  Future<Product> insert(Product product) async {
    try {
      Database db = await _getDatabase();
      int id = await db.rawInsert(ProductsConnectionSQL.insertProduct(product));
      product.id = id;
      return product;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> insertMultiple(List<Product> products) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (Product product in products) { batch.rawInsert(ProductsConnectionSQL.insertProduct(product)); }
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
          results[ind] = await insert(products[ind]);
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

  Future<bool> update(Product product) async {
    try {
      Database db = await _getDatabase();
      int affectedRows =
      await db.rawUpdate(ProductsConnectionSQL.updateProduct(product));
      if (affectedRows > 0) {
        return true;
      }
      return false;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> updateMultiple(List<Product> products) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (Product product in products) { batch.rawUpdate(ProductsConnectionSQL.updateProduct(product)); }
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
          bool success = await update(products[ind]);
          if(success) results[ind] = products[ind];
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

  Future<Product> upsert(Product product) async {
    try {
      Database db = await _getDatabase();
      await db.execute(ProductsConnectionSQL.upsertProduct(product));
      return product;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> upsertMultiple(List<Product> products) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (Product product in products) { batch.execute(ProductsConnectionSQL.upsertProduct(product)); }
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
          await upsert(products[ind]);
          results[ind] = products[ind];
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

  Future<List<Product>> selectAll() async {
    try {
      Database db = await _getDatabase();
      List<Map> rows =
      await db.rawQuery(ProductsConnectionSQL.selectAllProducts());
      List<Product> products = Product.fromSQLiteList(rows);
      return products;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<bool> delete(Product product) async {
    try {
      Database db = await _getDatabase();
      int affectedRows = await db.rawUpdate(ProductsConnectionSQL.deleteProduct(product));
      if (affectedRows > 0) {
        return true;
      }
      return false;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> deleteMultiple(List<Product> products) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (Product product in products) { batch.rawDelete(ProductsConnectionSQL.deleteProduct(product)); }
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
          bool success = await update(products[ind]);
          if(success) results[ind] = products[ind];
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