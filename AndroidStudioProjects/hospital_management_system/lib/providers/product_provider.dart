import 'package:firedart/generated/google/protobuf/timestamp.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:hospital_management_system/apiclient.dart';
import 'package:hospital_management_system/dao/product/product_dao.dart';
import 'package:hospital_management_system/db.dart';
import 'package:hospital_management_system/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class ProductProvider with ChangeNotifier{
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late DateTime _lastRequest = dateFormat.parse("2021-01-01 00:00:00");
  List<Product> _products = [];
  bool _loading = false;
  String _error = '';
  final ProductDAO _productDAO = ProductDAO();

  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  final ConnectionSQLiteService _connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async {
    return await _connection.db;
  }

  Map<String, dynamic> get state {
    return {
      'products': _products,
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
    resolvedPrefs.setString('lastProductRequest', dateString)
        .then((success){
      return success;
    });
  }

  Future<DateTime> getLastRequest() async {
    final resolvedPrefs = await _prefs;
    var dateString = resolvedPrefs.getString('lastProductRequest');
    if(dateString!=null){
      _lastRequest = dateFormat.parse(dateString);
    }
    return _lastRequest;
  }

  Future<void> selectAllProducts() async {
    print('fetching all products...');
    request();
    try {
      List<Product> result = await _productDAO.selectAll();
      _products.clear();
      _products.addAll(result);
      success();
    } catch (error) {
      failure(error.toString());
    }
  }

  void insertProduct(Product product) async {
    try {
      Product result = await _productDAO.insert(product);
      product.id = result.id;
      success();
    } catch (error) {
      print(error);
      failure(error.toString());
    }
  }

  void updateProduct(Product product) async {
    try {
      if (await _productDAO.update(product)) {
        success();
        return;
      }
      failure('Aucune donnee modifiee');
    } catch (error) {
      print(error);
      failure(error.toString());
    }
  }

  void delete(Product product) async {
    try {
      if (product.id != null) {
        if (await _productDAO.delete(product)) {
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
          .getCollection('products', from: dateFormat.format(_lastRequest));
      print(firebaseData.length);

      if(firebaseData.isNotEmpty){
        List<Product> deletable = [];
        List<Product> products = firebaseData.map((e) {
          if (e["createdAt"].toString() != e["deletedAt"].toString()) {
            print('$e will be deleted');
            deletable.add(Product.fromFirebase(e));
          }
          return Product.fromFirebase(e);
        }).toList();
        print('Totally ${deletable.length} will e deleted');
        // store it in database
        request();
        await _productDAO.upsertMultiple(products).then((value) => success());
        request();
        await _productDAO.deleteMultiple(deletable).then((value) => success());
      }
    } catch(e){
      print('Les donnees ne sont pas synchronisees');
    }
    await selectAllProducts();

  }

}