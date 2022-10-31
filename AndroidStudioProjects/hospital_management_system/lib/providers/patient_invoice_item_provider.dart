import 'package:firedart/generated/google/protobuf/timestamp.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:hospital_management_system/apiclient.dart';
import 'package:hospital_management_system/dao/patientInvoiceItem/patient_invoice_item_dao.dart';
import 'package:hospital_management_system/db.dart';
import 'package:hospital_management_system/models/patientInvoiceItem.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class PatientInvoiceItemProvider with ChangeNotifier{
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late DateTime _lastRequest = dateFormat.parse("2021-01-01 00:00:00");
  List<PatientInvoiceItem> _patientInvoiceItems = [];
  bool _loading = false;
  String _error = '';
  final PatientInvoiceItemDAO _patientInvoiceItemDAO = PatientInvoiceItemDAO();

  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  final ConnectionSQLiteService _connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async {
    return await _connection.db;
  }

  Map<String, dynamic> get state {
    return {
      'patientInvoiceItems': _patientInvoiceItems,
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
    resolvedPrefs.setString('lastPatientInvoiceItemRequest', dateString)
        .then((success){
      return success;
    });
  }

  Future<DateTime> getLastRequest() async {
    final resolvedPrefs = await _prefs;
    var dateString = resolvedPrefs.getString('lastPatientInvoiceItemRequest');
    if(dateString!=null){
      _lastRequest = dateFormat.parse(dateString);
    }
    return _lastRequest;
  }

  Future<void> selectAllPatientInvoiceItems() async {
    print('fetching all patientInvoiceItems...');
    request();
    try {
      List<PatientInvoiceItem> result = await _patientInvoiceItemDAO.selectAll();
      _patientInvoiceItems.clear();
      _patientInvoiceItems.addAll(result);
      success();
    } catch (error) {
      failure(error.toString());
    }
  }

  void insertPatientInvoiceItem(PatientInvoiceItem patientInvoiceItem) async {
    try {
      PatientInvoiceItem result = await _patientInvoiceItemDAO.insert(patientInvoiceItem);
      patientInvoiceItem.id = result.id;
      success();
    } catch (error) {
      print(error);
      failure(error.toString());
    }
  }

  void updatePatientInvoiceItem(PatientInvoiceItem patientInvoiceItem) async {
    try {
      if (await _patientInvoiceItemDAO.update(patientInvoiceItem)) {
        success();
        return;
      }
      failure('Aucune donnee modifiee');
    } catch (error) {
      print(error);
      failure(error.toString());
    }
  }

  void delete(PatientInvoiceItem patientInvoiceItem) async {
    try {
      if (patientInvoiceItem.id != null) {
        if (await _patientInvoiceItemDAO.delete(patientInvoiceItem)) {
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
          .getCollection('patientInvoiceItems', from: dateFormat.format(_lastRequest));
      print(firebaseData.length);

      if(firebaseData.isNotEmpty){
        List<PatientInvoiceItem> deletable = [];
        List<PatientInvoiceItem> patientInvoiceItems = firebaseData.map((e) {
          if (e["createdAt"].toString() != e["deletedAt"].toString()) {
            print('$e will be deleted');
            deletable.add(PatientInvoiceItem.fromFirebase(e));
          }
          return PatientInvoiceItem.fromFirebase(e);
        }).toList();
        print('Totally ${deletable.length} will e deleted');
        // store it in database
        request();
        await _patientInvoiceItemDAO
            .upsertMultiple(patientInvoiceItems)
            .then((value) => success());
        request();
        await _patientInvoiceItemDAO
            .deleteMultiple(deletable)
            .then((value) => success());
      }
    } catch(e){
      print('Les donnees ne sont pas synchronisees');
    }
    await selectAllPatientInvoiceItems();

  }

}
