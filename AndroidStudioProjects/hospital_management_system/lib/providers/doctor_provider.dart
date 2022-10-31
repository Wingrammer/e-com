import 'package:firedart/generated/google/protobuf/timestamp.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:hospital_management_system/apiclient.dart';
import 'package:hospital_management_system/dao/doctor/doctor_dao.dart';
import 'package:hospital_management_system/db.dart';
import 'package:hospital_management_system/models/doctor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class DoctorProvider with ChangeNotifier{
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late DateTime _lastRequest = dateFormat.parse("2021-01-01 00:00:00");
  List<Doctor> _doctors = [];
  bool _loading = false;
  String _error = '';
  final DoctorDAO _doctorDAO = DoctorDAO();

  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  final ConnectionSQLiteService _connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async {
    return await _connection.db;
  }

  Map<String, dynamic> get state {
    return {
      'doctors': _doctors,
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
    resolvedPrefs.setString('lastDoctorRequest', dateString)
        .then((success){
      return success;
    });
  }

  Future<DateTime> getLastRequest() async {
    final resolvedPrefs = await _prefs;
    var dateString = resolvedPrefs.getString('lastDoctorRequest');
    if(dateString!=null){
      _lastRequest = dateFormat.parse(dateString);
    }
    return _lastRequest;
  }

  Future<void> selectAllDoctors() async {
    print('fetching all doctors...');
    request();
    try {
      List<Doctor> result = await _doctorDAO.selectAll();
      _doctors.clear();
      _doctors.addAll(result);
      success();
    } catch (error) {
      failure(error.toString());
    }
  }

  void insertDoctor(Doctor doctor) async {
    try {
      Doctor result = await _doctorDAO.insert(doctor);
      doctor.id = result.id;
      success();
    } catch (error) {
      print(error);
      failure(error.toString());
    }
  }

  void updateDoctor(Doctor doctor) async {
    try {
      if (await _doctorDAO.update(doctor)) {
        success();
        return;
      }
      failure('Aucune donnee modifiee');
    } catch (error) {
      print(error);
      failure(error.toString());
    }
  }

  void delete(Doctor doctor) async {
    try {
      if (doctor.id != null) {
        if (await _doctorDAO.delete(doctor)) {
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
          .getCollection('doctors', from: dateFormat.format(_lastRequest));
      print(firebaseData.length);

      if(firebaseData.isNotEmpty){
        List<Doctor> deletable = [];
        List<Doctor> doctors = firebaseData.map((e) {
          if (e["createdAt"].toString() != e["deletedAt"].toString()) {
            print('$e will be deleted');
            deletable.add(Doctor.fromFirebase(e));
          }
          return Doctor.fromFirebase(e);
        }).toList();
        print('Totally ${deletable.length} will e deleted');
        // store it in database
        request();
        await _doctorDAO.upsertMultiple(doctors).then((value) => success());
        request();
        await _doctorDAO.deleteMultiple(deletable).then((value) => success());
      }
    } catch(e){
      print('Les donnees ne sont pas synchronisees');
    }
    await selectAllDoctors();

  }

}