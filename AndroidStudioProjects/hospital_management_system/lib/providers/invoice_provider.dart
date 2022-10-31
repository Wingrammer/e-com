
import 'dart:convert';

import 'package:firedart/generated/google/protobuf/timestamp.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:hospital_management_system/apiclient.dart';
import 'package:hospital_management_system/dao/invoice/invoice_dao.dart';
import 'package:hospital_management_system/db.dart';
import 'package:hospital_management_system/models/invoice.dart';
import 'package:hospital_management_system/models/invoice.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class InvoiceProvider with ChangeNotifier{
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late DateTime _lastRequest = dateFormat.parse("2021-01-01 00:00:00");
  List<Invoice> _invoices = [];
  Invoice _selected = Invoice.empty();
  bool _loading = false;
  String _error = '';
  final InvoiceDAO _invoiceDAO = InvoiceDAO();

  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  final ConnectionSQLiteService _connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async {
    return await _connection.db;
  }

  set selected(selectedInvoice){
    _selected = selectedInvoice;
    notifyListeners();
  }

  Map<String, dynamic> get state {
    return {
      'invoices': _invoices,
      'selected': _selected,
      'loading': _loading,
      'error': _error,
      'lastRequest': Timestamp.fromDateTime(_lastRequest)
    };
  }

  void request(){
    print('Ongoing request');
    _loading = true;
    _error = '';
    notifyListeners();
  }

  void success(){
    print('success');
    _loading = false;
    _error = '';
    updateLastRequest(DateTime.now());
    notifyListeners();
  }

  void failure(msg){
    _loading = true;
    _error = msg;
    print(msg);
    notifyListeners();
  }

  void updateLastRequest(date) async {
    final resolvedPrefs = await _prefs;
    String dateString = dateFormat.format(date);
    _lastRequest = dateFormat.parse(dateString);
    resolvedPrefs.setString('lastInvoiceRequest', dateString)
        .then((success){
      return success;
    });
  }

  Future<DateTime> getLastRequest() async {
    final resolvedPrefs = await _prefs;
    var dateString = resolvedPrefs.getString('lastInvoiceRequest');
    if(dateString!=null){
      _lastRequest = dateFormat.parse(dateString);
    }
    return _lastRequest;
  }

  Future<void> selectAllInvoices() async {
    print('fetching all invoices...');
    request();
    try {
      List<Invoice> result = await _invoiceDAO.selectAll();
      _invoices.clear();
      _invoices.addAll(result);
      success();
    } catch (error) {
      failure(error.toString());
    }
  }

  void insertInvoice(Invoice invoice) async {
    try {
      Invoice result = await _invoiceDAO.insert(invoice);
      invoice.id = result.id;
      success();
    } catch (error) {
      print(error);
      failure(error.toString());
    }
  }

  void updateInvoice(Invoice invoice) async {
    try {
      if (await _invoiceDAO.update(invoice)) {
        success();
        return;
      }
      failure('Aucune donnee modifiee');
    } catch (error) {
      print(error);
      failure(error.toString());
    }
  }

  void delete(Invoice invoice) async {
    try {
      if (invoice.id != null) {
        if (await _invoiceDAO.delete(invoice)) {
          success();
          return;
        }
        failure('Aucune donnee supprimer');
      }
      failure('Impossíble de supprimer une donnee');
    } catch (error) {
      print(error);
      failure(error.toString());
    }
  }

  Future<void> init() async {
    try {
      await getLastRequest();
      // get firebase data
      var firebaseData = await Client()
          .getCollection('invoices', from: dateFormat.format(_lastRequest));
      print(firebaseData.length);

      if(firebaseData.isNotEmpty){
        List<Invoice> deletable = [];
        List<Invoice> invoices = firebaseData.map((e) {
          print(e["createdAt"]["_seconds"] != e["deletedAt"]["_seconds"] && e["createdAt"]["_nanoseconds"] != e["deletedAt"]["_nanoseconds"]);
          print(e["createdAt"].toString() == e["deletedAt"].toString());
          if (e["createdAt"]["_seconds"] != e["deletedAt"]["_seconds"] && e["createdAt"]["_nanoseconds"] != e["deletedAt"]["_nanoseconds"]) {
            print('$e will be deleted');
            deletable.add(Invoice.fromFirebase(e));
          }
          return Invoice.fromFirebase(e);
        }).toList();
        print('Totally ${deletable.length} will e deleted');
        // store it in database
        request();
        await _invoiceDAO.upsertMultiple(invoices).then((value) => success());
        request();
        await _invoiceDAO.deleteMultiple(deletable).then((value) => success());
      }
    } catch(e){
      print('Les donnees ne sont pas synchronisees');
    }
    await selectAllInvoices();

  }

}