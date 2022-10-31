import 'package:firedart/generated/google/protobuf/timestamp.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:hospital_management_system/apiclient.dart';
import 'package:hospital_management_system/dao/otherEntry/other_entry_dao.dart';
import 'package:hospital_management_system/db.dart';
import 'package:hospital_management_system/models/otherEntry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class OtherEntryProvider with ChangeNotifier{
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late DateTime _lastRequest = dateFormat.parse("2021-01-01 00:00:00");
  List<OtherEntry> _otherEntries = [];
  bool _loading = false;
  String _error = '';
  final OtherEntryDAO _otherEntryDAO = OtherEntryDAO();

  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  final ConnectionSQLiteService _connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async {
    return await _connection.db;
  }

  Map<String, dynamic> get state {
    return {
      'otherEntries': _otherEntries,
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
    resolvedPrefs.setString('lastOtherEntryRequest', dateString)
        .then((success){
      return success;
    });
  }

  Future<DateTime> getLastRequest() async {
    final resolvedPrefs = await _prefs;
    var dateString = resolvedPrefs.getString('lastOtherEntryRequest');
    if(dateString!=null){
      _lastRequest = dateFormat.parse(dateString);
    }
    return _lastRequest;
  }

  Future<void> selectAllOtherEntries() async {
    print('fetching all otherEntries...');
    request();
    try {
      List<OtherEntry> result = await _otherEntryDAO.selectAll();
      _otherEntries.clear();
      _otherEntries.addAll(result);
      success();
    } catch (error) {
      failure(error.toString());
    }
  }

  void insertOtherEntry(OtherEntry otherEntry) async {
    try {
      OtherEntry result = await _otherEntryDAO.insert(otherEntry);
      otherEntry.id = result.id;
      success();
    } catch (error) {
      print(error);
      failure(error.toString());
    }
  }

  void updateOtherEntry(OtherEntry otherEntry) async {
    try {
      if (await _otherEntryDAO.update(otherEntry)) {
        success();
        return;
      }
      failure('Aucune donnee modifiee');
    } catch (error) {
      print(error);
      failure(error.toString());
    }
  }

  void delete(OtherEntry otherEntry) async {
    try {
      if (otherEntry.id != null) {
        if (await _otherEntryDAO.delete(otherEntry)) {
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
          .getCollection('othersEntries', from: dateFormat.format(_lastRequest));
      print(firebaseData.length);

      if(firebaseData.isNotEmpty){
        List<OtherEntry> deletable = [];
        List<OtherEntry> otherEntries = firebaseData.map((e) {
          if (e["createdAt"].toString() != e["deletedAt"].toString()) {
            print('$e will be deleted');
            deletable.add(OtherEntry.fromFirebase(e));
          }
          return OtherEntry.fromFirebase(e);
        }).toList();
        print('Totally ${deletable.length} will e deleted');
        // store it in database
        request();
        await _otherEntryDAO
            .upsertMultiple(otherEntries)
            .then((value) => success());
        request();
        await _otherEntryDAO
            .deleteMultiple(deletable)
            .then((value) => success());
      }
    } catch(e){
      print('Les donnees ne sont pas synchronisees');
    }
    await selectAllOtherEntries();

  }

}