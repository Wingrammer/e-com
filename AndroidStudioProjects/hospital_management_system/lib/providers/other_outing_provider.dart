import 'package:firedart/generated/google/protobuf/timestamp.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:hospital_management_system/apiclient.dart';
import 'package:hospital_management_system/dao/otherOuting/other_outing_dao.dart';
import 'package:hospital_management_system/db.dart';
import 'package:hospital_management_system/models/otherOuting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class OtherOutingProvider with ChangeNotifier{
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late DateTime _lastRequest = dateFormat.parse("2021-01-01 00:00:00");
  List<OtherOuting> _otherOutings = [];
  bool _loading = false;
  String _error = '';
  final OtherOutingDAO _otherOutingDAO = OtherOutingDAO();

  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  final ConnectionSQLiteService _connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async {
    return await _connection.db;
  }

  Map<String, dynamic> get state {
    return {
      'otherOutings': _otherOutings,
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
    resolvedPrefs.setString('lastOtherOutingRequest', dateString)
        .then((success){
      return success;
    });
  }

  Future<DateTime> getLastRequest() async {
    final resolvedPrefs = await _prefs;
    var dateString = resolvedPrefs.getString('lastOtherOutingRequest');
    if(dateString!=null){
      _lastRequest = dateFormat.parse(dateString);
    }
    return _lastRequest;
  }

  Future<void> selectAllOtherOutings() async {
    print('fetching all otherOutings...');
    request();
    try {
      List<OtherOuting> result = await _otherOutingDAO.selectAll();
      _otherOutings.clear();
      _otherOutings.addAll(result);
      success();
    } catch (error) {
      failure(error.toString());
    }
  }

  void insertOtherOuting(OtherOuting otherOuting) async {
    try {
      OtherOuting result = await _otherOutingDAO.insert(otherOuting);
      otherOuting.id = result.id;
      success();
    } catch (error) {
      print(error);
      failure(error.toString());
    }
  }

  void updateOtherOuting(OtherOuting otherOuting) async {
    try {
      if (await _otherOutingDAO.update(otherOuting)) {
        success();
        return;
      }
      failure('Aucune donnee modifiee');
    } catch (error) {
      print(error);
      failure(error.toString());
    }
  }

  void delete(OtherOuting otherOuting) async {
    try {
      if (otherOuting.id != null) {
        if (await _otherOutingDAO.delete(otherOuting)) {
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
          .getCollection('othersOutings', from: dateFormat.format(_lastRequest));
      print(firebaseData.length);

      if(firebaseData.isNotEmpty){
        List<OtherOuting> deletable = [];
        List<OtherOuting> otherOutings = firebaseData.map((e) {
          if (e["createdAt"].toString() != e["deletedAt"].toString()) {
            print('$e will be deleted');
            deletable.add(OtherOuting.fromFirebase(e));
          }
          return OtherOuting.fromFirebase(e);
        }).toList();
        print('Totally ${deletable.length} will e deleted');
        // store it in database
        request();
        await _otherOutingDAO
            .upsertMultiple(otherOutings)
            .then((value) => success());
        request();
        if(deletable.isNotEmpty){
          await _otherOutingDAO
              .deleteMultiple(deletable)
              .then((value) => success());
        }
      }
    } catch(e){
      print('Les donnees ne sont pas synchronisees');
    }
    await selectAllOtherOutings();

  }

}