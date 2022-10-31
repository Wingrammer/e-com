import 'package:firedart/generated/google/protobuf/timestamp.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:hospital_management_system/apiclient.dart';
import 'package:hospital_management_system/dao/consultation/consultation_dao.dart';
import 'package:hospital_management_system/db.dart';
import 'package:hospital_management_system/models/consultation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class ConsultationProvider with ChangeNotifier{
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late DateTime _lastRequest = dateFormat.parse("2021-01-01 00:00:00");
  List<Consultation> _consultations = [];
  Consultation _selected = Consultation.empty();
  bool _loading = false;
  String _error = '';
  final ConsultationDAO _consultationDAO = ConsultationDAO();

  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  final ConnectionSQLiteService _connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async {
    return await _connection.db;
  }

  set selected(selectedInvoice){
    _selected = selectedInvoice;
    notifyListeners();
  }
  
  Map<String, dynamic> get state {
    return {
      'consultations': _consultations,
      'selected': _selected,
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
    updateLastRequest();
    notifyListeners();
  }

  void failure(msg){
    _loading = true;
    _error = msg;
    print(msg);
    notifyListeners();
  }

  void updateLastRequest() async {
    final resolvedPrefs = await _prefs;
    String dateString = dateFormat.format(DateTime.now());
    _lastRequest = dateFormat.parse(dateString);
    resolvedPrefs.setString('lastConsultationRequest', dateString)
        .then((success){
      return success;
    });
  }

  Future<DateTime> getLastRequest() async {
    final resolvedPrefs = await _prefs;
    var dateString = resolvedPrefs.getString('lastConsultationRequest');
    if(dateString!=null){
      _lastRequest = dateFormat.parse(dateString);
    }
    return _lastRequest;
  }

  Future<void> selectAllConsultation() async {
    print('fetching all consultations...');
    request();
    try {
      List<Consultation> result = await _consultationDAO.selectAll();
      _consultations.clear();
      _consultations.addAll(result);
      success();
    } catch (error) {
      failure(error.toString());
    }
  }

  void insertConsultation(Consultation consultation) async {
    try {
      Consultation result = await _consultationDAO.insert(consultation);
      consultation.id = result.id;
      success();
    } catch (error) {
      print(error);
      failure(error.toString());
    }
  }

  void updateConsultation(Consultation consultation) async {
    try {
      if (await _consultationDAO.update(consultation)) {
        success();
        return;
      }
      failure('Aucune donnee modifiee');
    } catch (error) {
      print(error);
      failure(error.toString());
    }
  }

  void delete(Consultation consultation) async {
    try {
      if (consultation.id != null) {
        if (await _consultationDAO.delete(consultation)) {
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

  DateTime timestampToDate(Map timestamp){
    print(timestamp);
    return DateTime.fromMillisecondsSinceEpoch(timestamp["_seconds"]*1000);
  }

  Future<void> init(context) async {
    try {
      await getLastRequest();
      // get firebase data
      var firebaseData = await Client()
          .getCollection('consultations', from: dateFormat.format(_lastRequest));
      print('${firebaseData.length} consultation');

      if(firebaseData.isNotEmpty){
        List<Consultation> deletable = [];
        List<Consultation> consultations = firebaseData.map((e) {
          if (timestampToDate(e["createdAt"]).compareTo(timestampToDate(e["deletedAt"])) != 0) {
            //print('$e will be deleted');
            deletable.add(Consultation.fromFirebase(e));
          }
          return Consultation.fromFirebase(e, context:context);
        }).toList();
        print('Totally ${deletable.length} will e deleted');
        // store it in database
        request();
        await _consultationDAO
            .upsertMultiple(consultations)
            .then((value) => success());
        request();
        await _consultationDAO
            .deleteMultiple(deletable)
            .then((value) => success());
      }
    } catch(e){
      print('Les donnees ne sont pas synchronisees');
      print(e.toString());
    }
    await selectAllConsultation();

  }

}