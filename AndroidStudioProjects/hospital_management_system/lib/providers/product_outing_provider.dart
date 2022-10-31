import 'package:firedart/generated/google/protobuf/timestamp.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:hospital_management_system/apiclient.dart';
import 'package:hospital_management_system/dao/productOuting/product_outing_dao.dart';
import 'package:hospital_management_system/db.dart';
import 'package:hospital_management_system/models/productOuting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class ProductOutingProvider with ChangeNotifier{
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late DateTime _lastRequest = dateFormat.parse("2021-01-01 00:00:00");
  List<ProductOuting> _productOutings = [];
  bool _loading = false;
  String _error = '';
  final ProductOutingDAO _productOutingDAO = ProductOutingDAO();

  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  final ConnectionSQLiteService _connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async {
    return await _connection.db;
  }

  Map<String, dynamic> get state {
    return {
      'productOutings': _productOutings,
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
    resolvedPrefs.setString('lastProductOutingRequest', dateString)
        .then((success){
      return success;
    });
  }

  Future<DateTime> getLastRequest() async {
    final resolvedPrefs = await _prefs;
    var dateString = resolvedPrefs.getString('lastProductOutingRequest');
    if(dateString!=null){
      _lastRequest = dateFormat.parse(dateString);
    }
    return _lastRequest;
  }

  Future<void> selectAllProductOutings() async {
    print('fetching all productOutings...');
    request();
    try {
      List<ProductOuting> result = await _productOutingDAO.selectAll();
      _productOutings.clear();
      _productOutings.addAll(result);
      success();
    } catch (error) {
      failure(error.toString());
    }
  }

  void insertProductOuting(ProductOuting productOuting) async {
    try {
      ProductOuting result = await _productOutingDAO.insert(productOuting);
      productOuting.id = result.id;
      success();
    } catch (error) {
      print(error);
      failure(error.toString());
    }
  }

  void updateProductOuting(ProductOuting productOuting) async {
    try {
      if (await _productOutingDAO.update(productOuting)) {
        success();
        return;
      }
      failure('Aucune donnee modifiee');
    } catch (error) {
      print(error);
      failure(error.toString());
    }
  }

  void delete(ProductOuting productOuting) async {
    try {
      if (productOuting.id != null) {
        if (await _productOutingDAO.delete(productOuting)) {
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
          .getCollection('productsOutings', from: dateFormat.format(_lastRequest));
      print(firebaseData.length);

      if(firebaseData.isNotEmpty){
        List<ProductOuting> deletable = [];
        List<ProductOuting> productOutings = firebaseData.map((e) {
          if (e["createdAt"].toString() != e["deletedAt"].toString()) {
            print('$e will be deleted');
            deletable.add(ProductOuting.fromFirebase(e));
          }
          return ProductOuting.fromFirebase(e);
        }).toList();
        print('Totally ${deletable.length} will e deleted');
        // store it in database
        request();
        await _productOutingDAO
            .upsertMultiple(productOutings)
            .then((value) => success());
        request();
        await _productOutingDAO
            .deleteMultiple(deletable)
            .then((value) => success());
      }
    } catch(e){
      print('Les donnees ne sont pas synchronisees');
    }
    await selectAllProductOutings();

  }

}