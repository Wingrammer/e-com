import 'package:firedart/generated/google/protobuf/timestamp.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:hospital_management_system/apiclient.dart';
import 'package:hospital_management_system/dao/service/service_dao.dart';
import 'package:hospital_management_system/db.dart';
import 'package:hospital_management_system/models/service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class ServiceProvider with ChangeNotifier{
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late DateTime _lastRequest = dateFormat.parse("2021-01-01 00:00:00");
  List<Service> _services = [];
  bool _loading = false;
  String _error = '';
  final ServiceDAO _serviceDAO = ServiceDAO();

  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  final ConnectionSQLiteService _connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async {
    return await _connection.db;
  }

  Map<String, dynamic> get state {
    return {
      'services': _services,
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
    resolvedPrefs.setString('lastServiceRequest', dateString)
        .then((success){
      return success;
    });
  }

  Future<DateTime> getLastRequest() async {
    final resolvedPrefs = await _prefs;
    var dateString = resolvedPrefs.getString('lastServiceRequest');
    if(dateString!=null){
      _lastRequest = dateFormat.parse(dateString);
    }
    return _lastRequest;
  }

  Future<void> selectAllServices() async {
    print('fetching all services...');
    request();
    try {
      List<Service> result = await _serviceDAO.selectAll();
      _services.clear();
      _services.addAll(result);
      success();
    } catch (error) {
      failure(error.toString());
    }
  }

  void insertService(Service service) async {
    try {
      Service result = await _serviceDAO.insert(service);
      service.id = result.id;
      success();
    } catch (error) {
      print(error);
      failure(error.toString());
    }
  }

  void updateService(Service service) async {
    try {
      if (await _serviceDAO.update(service)) {
        success();
        return;
      }
      failure('Aucune donnee modifiee');
    } catch (error) {
      print(error);
      failure(error.toString());
    }
  }

  void delete(Service service) async {
    try {
      if (service.id != null) {
        if (await _serviceDAO.delete(service)) {
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
          .getCollection('services', from: dateFormat.format(_lastRequest));
      print(firebaseData.length);

      if(firebaseData.isNotEmpty){
        List<Service> deletable = [];
        List<Service> services = firebaseData.map((e) {
          if (e["createdAt"].toString() != e["deletedAt"].toString()) {
            print('$e will be deleted');
            deletable.add(Service.fromFirebase(e));
          }
          return Service.fromFirebase(e);
        }).toList();
        print('Totally ${deletable.length} will e deleted');
        // store it in database
        request();
        await _serviceDAO.upsertMultiple(services).then((value) => success());
        request();
        await _serviceDAO.deleteMultiple(deletable).then((value) => success());
      }
    } catch(e){
      print('Les donnees ne sont pas synchronisees');
    }
    await selectAllServices();

  }

}