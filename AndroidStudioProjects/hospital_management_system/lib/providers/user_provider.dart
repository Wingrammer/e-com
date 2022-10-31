
import 'dart:convert';

import 'package:firedart/generated/google/protobuf/timestamp.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:hospital_management_system/apiclient.dart';
import 'package:hospital_management_system/dao/user/user_dao.dart';
import 'package:hospital_management_system/db.dart';
import 'package:hospital_management_system/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class UserProvider with ChangeNotifier{
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late DateTime _lastRequest = dateFormat.parse("2021-01-01 00:00:00");
  List<User> _users = [];
  bool _loading = false;
  String _error = '';
  final UserDAO _userDAO = UserDAO();

  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  final ConnectionSQLiteService _connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async {
    return await _connection.db;
  }

  Map<String, dynamic> get state {
    return {
      'users': _users,
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
    resolvedPrefs.setString('lastUserRequest', dateString)
        .then((success){
          return success;
        });
  }

  Future<DateTime> getLastRequest() async {
    final resolvedPrefs = await _prefs;
    var dateString = resolvedPrefs.getString('lastUserRequest');
    if(dateString!=null){
      _lastRequest = dateFormat.parse(dateString);
    }
    return _lastRequest;
  }

  void selectAllUsers() async {
    print('fetching all users...');
    request();
    try {
      List<User> result = await _userDAO.selectAll();
      _users.clear();
      _users.addAll(result);
      success();
    } catch (error) {
      failure(error.toString());
    }
  }

  void insertUser(User user) async {
    try {
      User result = await _userDAO.insert(user);
      user.id = result.id;
      success();
    } catch (error) {
      print(error);
      failure(error.toString());
    }
  }

  void updateUser(User user) async {
    try {
      if (await _userDAO.update(user)) {
        success();
        return;
      }
      failure('Aucune donnee modifiee');
    } catch (error) {
      print(error);
      failure(error.toString());
    }
  }

  void delete(User user) async {
    try {
      if (user.id != null) {
        if (await _userDAO.delete(user)) {
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
    await getLastRequest();
    // get firebase data
    var firebaseData = await Client().getCollection('users', from:dateFormat.format(_lastRequest));
    print(firebaseData.length);

    if(firebaseData.isNotEmpty){
      List<User> deletable = [];
      List<User> users = firebaseData.map((e) {
        if (e["createdAt"].toString() != e["deletedAt"].toString()) {
          print('$e will be deleted');
          deletable.add(User.fromFirebase(e));
        }
        return User.fromFirebase(e);
      }).toList();
      print('Totally ${deletable.length} will e deleted');
      // store it in database
      request();
      await _userDAO.upsertMultiple(users).then((value) => success());
      request();
      await _userDAO.deleteMultiple(deletable).then((value) => success());
    }
    // fetch db data
    selectAllUsers();

  }

}