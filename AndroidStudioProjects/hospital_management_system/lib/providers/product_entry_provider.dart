import 'package:firedart/generated/google/protobuf/timestamp.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:hospital_management_system/apiclient.dart';
import 'package:hospital_management_system/dao/productEntry/product_entry_dao.dart';
import 'package:hospital_management_system/db.dart';
import 'package:hospital_management_system/models/productEntry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class ProductEntryProvider with ChangeNotifier{
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late DateTime _lastRequest = dateFormat.parse("2021-01-01 00:00:00");
  List<ProductEntry> _productEntries = [];
  bool _loading = false;
  String _error = '';
  final ProductEntryDAO _productEntryDAO = ProductEntryDAO();

  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  final ConnectionSQLiteService _connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async {
    return await _connection.db;
  }

  Map<String, dynamic> get state {
    return {
      'productEntries': _productEntries,
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
    resolvedPrefs.setString('lastProductEntryRequest', dateString)
        .then((success){
      return success;
    });
  }

  Future<DateTime> getLastRequest() async {
    final resolvedPrefs = await _prefs;
    var dateString = resolvedPrefs.getString('lastProductEntryRequest');
    if(dateString!=null){
      _lastRequest = dateFormat.parse(dateString);
    }
    return _lastRequest;
  }

  Future<void> selectAllProductEntrys() async {
    print('fetching all productEntries...');
    request();
    try {
      List<ProductEntry> result = await _productEntryDAO.selectAll();
      _productEntries.clear();
      _productEntries.addAll(result);
      success();
    } catch (error) {
      failure(error.toString());
    }
  }

  void insertProductEntry(ProductEntry productEntry) async {
    try {
      ProductEntry result = await _productEntryDAO.insert(productEntry);
      productEntry.id = result.id;
      success();
    } catch (error) {
      print(error);
      failure(error.toString());
    }
  }

  void updateProductEntry(ProductEntry productEntry) async {
    try {
      if (await _productEntryDAO.update(productEntry)) {
        success();
        return;
      }
      failure('Aucune donnee modifiee');
    } catch (error) {
      print(error);
      failure(error.toString());
    }
  }

  void delete(ProductEntry productEntry) async {
    try {
      if (productEntry.id != null) {
        if (await _productEntryDAO.delete(productEntry)) {
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
          .getCollection('productsEntries', from: dateFormat.format(_lastRequest));
      print(firebaseData.length);

      if(firebaseData.isNotEmpty){
        List<ProductEntry> deletable = [];
        List<ProductEntry> productEntries = firebaseData.map((e) {
          if (e["createdAt"].toString() != e["deletedAt"].toString()) {
            print('$e will be deleted');
            deletable.add(ProductEntry.fromFirebase(e));
          }
          return ProductEntry.fromFirebase(e);
        }).toList();
        print('Totally ${deletable.length} will e deleted');
        // store it in database
        request();
        await _productEntryDAO
            .upsertMultiple(productEntries)
            .then((value) => success());
        request();
        await _productEntryDAO
            .deleteMultiple(deletable)
            .then((value) => success());
      }
    } catch(e){
      print('Les donnees ne sont pas synchronisees');
    }
    await selectAllProductEntrys();

  }

}