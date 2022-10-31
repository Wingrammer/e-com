
import 'package:hospital_management_system/dao/invoice/sql.dart';
import 'package:hospital_management_system/db.dart';
import 'package:hospital_management_system/models/invoice.dart';
import 'package:sqflite/sqflite.dart';

class InvoiceDAO{

  final ConnectionSQLiteService _connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async {
    return await _connection.db;
  }

  Future<Invoice> insert(Invoice invoice) async {
    try {
      Database db = await _getDatabase();
      int id = await db.rawInsert(InvoicesConnectionSQL.insertInvoice(invoice));
      invoice.id = id;
      return invoice;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> insertMultiple(List<Invoice> invoices) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (Invoice invoice in invoices) { batch.rawInsert(InvoicesConnectionSQL.insertInvoice(invoice)); }
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
          results[ind] = await insert(invoices[ind]);
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

  Future<bool> update(Invoice invoice) async {
    try {
      Database db = await _getDatabase();
      int affectedRows =
      await db.rawUpdate(InvoicesConnectionSQL.updateInvoice(invoice));
      if (affectedRows > 0) {
        return true;
      }
      return false;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> updateMultiple(List<Invoice> invoices) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (Invoice invoice in invoices) { batch.rawUpdate(InvoicesConnectionSQL.updateInvoice(invoice)); }
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
          bool success = await update(invoices[ind]);
          if(success) results[ind] = invoices[ind];
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

  Future<Invoice> upsert(Invoice invoice) async {
    try {
      Database db = await _getDatabase();
      await db.execute(InvoicesConnectionSQL.upsertInvoice(invoice));
      return invoice;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> upsertMultiple(List<Invoice> invoices) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (Invoice invoice in invoices) { batch.execute(InvoicesConnectionSQL.upsertInvoice(invoice)); }
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
          await upsert(invoices[ind]);
          results[ind] = invoices[ind];
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

  Future<List<Invoice>> selectAll() async {
    try {
      Database db = await _getDatabase();
      List<Map> rows =
      await db.rawQuery(InvoicesConnectionSQL.selectAllInvoices());
      List<Invoice> invoices = Invoice.fromSQLiteList(rows);
      return invoices;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<bool> delete(Invoice invoice) async {
    try {
      Database db = await _getDatabase();
      int affectedRows = await db.rawUpdate(InvoicesConnectionSQL.deleteInvoice(invoice));
      if (affectedRows > 0) {
        return true;
      }
      return false;
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  Future<List> deleteMultiple(List<Invoice> invoices) async {
    try {
      Database db = await _getDatabase();
      var batch = db.batch();
      for (Invoice invoice in invoices) { batch.rawDelete(InvoicesConnectionSQL.deleteInvoice(invoice)); }
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
          bool success = await update(invoices[ind]);
          if(success) results[ind] = invoices[ind];
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