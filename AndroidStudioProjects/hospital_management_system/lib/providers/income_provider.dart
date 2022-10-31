import 'dart:convert';

import 'package:firedart/generated/google/protobuf/timestamp.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:hospital_management_system/apiclient.dart';
import 'package:hospital_management_system/dao/income/income_dao.dart';
import 'package:hospital_management_system/db.dart';
import 'package:hospital_management_system/models/income.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class IncomeProvider with ChangeNotifier{
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late DateTime _lastRequest = dateFormat.parse("2021-01-01 00:00:00");
  List<Income> _incomes = [];
  bool _loading = false;
  String _error = '';
  final IncomeDAO _incomeDAO = IncomeDAO();

  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  final ConnectionSQLiteService _connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async {
    return await _connection.db;
  }

  Map<String, dynamic> get state {
    return {
      'incomes': _incomes,
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
    resolvedPrefs.setString('lastIncomeRequest', dateString)
        .then((success){
      return success;
    });
  }

  Future<DateTime> getLastRequest() async {
    final resolvedPrefs = await _prefs;
    var dateString = resolvedPrefs.getString('lastIncomeRequest');
    if(dateString!=null){
      _lastRequest = dateFormat.parse(dateString);
    }
    return _lastRequest;
  }

  Future<void> selectAllIncomes() async {
    print('fetching all incomes...');
    request();
    try {
      List<Income> result = await _incomeDAO.selectAll();
      _incomes.clear();
      _incomes.addAll(
          /*result.map((e){
        //Map pat = jsonDecode(e.patient);
        //e.patient = pat['code'];
        return e;
      })*/
      result);

      success();
    } catch (error) {
      failure(error.toString());
    }
  }

  void insertIncome(Income income) async {
    try {
      Income result = await _incomeDAO.insert(income);
      income.id = result.id;
      success();
    } catch (error) {
      print(error);
      failure(error.toString());
    }
  }

  void updateIncome(Income income) async {
    try {
      if (await _incomeDAO.update(income)) {
        success();
        return;
      }
      failure('Aucune donnee modifiee');
    } catch (error) {
      print(error);
      failure(error.toString());
    }
  }

  void delete(Income income) async {
    try {
      if (income.id != null) {
        if (await _incomeDAO.delete(income)) {
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
          .getCollection('incomes', from: dateFormat.format(_lastRequest));
      print(firebaseData.length);
      if(firebaseData.isNotEmpty)
      {
        List<Income> deletable = [];
        List<Income> incomes = firebaseData.map((e) {
          if (e["createdAt"].toString() != e["deletedAt"].toString()) {
            print('$e will be deleted');
            deletable.add(Income.fromFirebase(e));
          }
          return Income.fromFirebase(e);
        }).toList();
        print('Totally ${deletable.length} will e deleted');
        // store it in database
        request();
        await _incomeDAO.upsertMultiple(incomes).then((value) => success());
        request();
        await _incomeDAO.deleteMultiple(deletable).then((value) => success());
      }
    } catch(e){
      print('Les donnees ne sont pas synchronisees');
    }
    await selectAllIncomes();

  }

}