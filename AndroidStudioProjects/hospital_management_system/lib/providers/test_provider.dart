import 'package:firedart/generated/google/protobuf/timestamp.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:hospital_management_system/apiclient.dart';
import 'package:hospital_management_system/dao/test/test_dao.dart';
import 'package:hospital_management_system/db.dart';
import 'package:hospital_management_system/models/test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class TestProvider with ChangeNotifier{
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late DateTime _lastRequest = dateFormat.parse("2021-01-01 00:00:00");
  List<Test> _tests = [];
  bool _loading = false;
  String _error = '';
  final TestDAO _testDAO = TestDAO();

  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  final ConnectionSQLiteService _connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async {
    return await _connection.db;
  }

  Map<String, dynamic> get state {
    return {
      'tests': _tests,
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
    resolvedPrefs.setString('lastTestRequest', dateString)
        .then((success){
      return success;
    });
  }

  Future<DateTime> getLastRequest() async {
    final resolvedPrefs = await _prefs;
    var dateString = resolvedPrefs.getString('lastTestRequest');
    if(dateString!=null){
      _lastRequest = dateFormat.parse(dateString);
    }
    return _lastRequest;
  }

  Future<void> selectAllTests() async {
    print('fetching all tests...');
    request();
    try {
      List<Test> result = await _testDAO.selectAll();
      _tests.clear();
      _tests.addAll(result);
      success();
    } catch (error) {
      failure(error.toString());
    }
  }

  void insertTest(Test test) async {
    try {
      Test result = await _testDAO.insert(test);
      test.id = result.id;
      success();
    } catch (error) {
      print(error);
      failure(error.toString());
    }
  }

  void updateTest(Test test) async {
    try {
      if (await _testDAO.update(test)) {
        success();
        return;
      }
      failure('Aucune donnee modifiee');
    } catch (error) {
      print(error);
      failure(error.toString());
    }
  }

  void delete(Test test) async {
    try {
      if (test.id != null) {
        if (await _testDAO.delete(test)) {
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
          .getCollection('tests', from: dateFormat.format(_lastRequest));
      print('${firebaseData.length} tests from firebase');

      if(firebaseData.isNotEmpty){
        List<Test> deletable = [];
        List<Test> tests = firebaseData.map((e) {
          if (e["createdAt"].toString() != e["deletedAt"].toString()) {
            print('$e will be deleted');
            deletable.add(Test.fromFirebase(e));
          }
          return Test.fromFirebase(e);
        }).toList();
        print('Totally ${deletable.length} test will be deleted');
        print('${tests.length} tests objects created');
        // store it in database
        request();
        await _testDAO.upsertMultiple(tests).then((value) => success());
        request();
        await _testDAO.deleteMultiple(deletable).then((value) => success());
      }
    } catch(e){
      print('Les donnees ne sont pas synchronisees');
    }
    await selectAllTests();

  }

}