import 'dart:convert';

import 'package:firedart/generated/google/protobuf/timestamp.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:hospital_management_system/db.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class NotificationProvider with ChangeNotifier{
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late DateTime _lastRequest = dateFormat.parse("2021-01-01 00:00:00");
  List<Map<String, dynamic>> _notifications = [];
  bool _loading = false;
  String _error = '';

  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  Map<String, dynamic> get state {
    print(_notifications);
    return {
      'notifications': _notifications,
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
    print(_notifications.length);
    notifyListeners();
  }

  void failure(msg){
    _loading = true;
    _error = msg;
    print(msg);
    notifyListeners();
  }

  void incoming(not){
    request();
    _notifications.addAll([not, ..._notifications]);
    print(_notifications);
    success();
  }

}