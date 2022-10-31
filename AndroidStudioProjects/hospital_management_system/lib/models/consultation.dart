
import 'dart:convert';

import 'package:firedart/firedart.dart';
import 'package:firedart/firestore/firestore_gateway.dart';
import 'package:flutter/material.dart';
import 'package:hospital_management_system/firebase_options.dart';
import 'package:hospital_management_system/models/doctor.dart';
import 'package:hospital_management_system/models/user.dart';
import 'package:hospital_management_system/providers/database.dart';
import 'package:hospital_management_system/providers/doctor_provider.dart';
import 'package:hospital_management_system/providers/token_preferences.dart';
import 'package:hospital_management_system/providers/user_provider.dart';
import 'package:provider/provider.dart';

class Consultation {

  int? id;
  String fid;
  String? date;
  String? doctor;
  String? patient;
  String? poids;
  bool? programmed;
  String? taille;
  String? temperature;
  String? tension;
  bool? urgence;

  Consultation(
    {
      this.id,
      required this.fid,
      this.date,
      this.doctor,
      this.patient,
      this.poids,
      this.programmed,
      this.taille,
      this.temperature,
      this.tension,
      this.urgence,
    }
  );

  DateTime get getDate{
    List months = ["Jan", "Fev", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    List<String> spacedDate = date!.split(" ");
    
    if(spacedDate.length==7){
      int month = months.indexOf(spacedDate[1]);
      int day = int.parse(spacedDate[2]);
      int year = int.parse(spacedDate[3]);
      return DateTime(year, month, day);
    }
    if(spacedDate.length==1){
      List<String> teedDate = spacedDate[0].split('T');
      if(teedDate.length==2){
        List<String> dashedDate = teedDate[0].split("-");
        return DateTime(int.parse(dashedDate[0]), int.parse(dashedDate[1]), int.parse(dashedDate[2]));
      }
    }
    return DateTime.now();
  }

  bool get isToday{
    DateTime now = DateTime.now();
    return now.year == getDate.year && now.month == getDate.month && now.day == getDate.day;
  }

  bool isDate(DateTime date){
    return date.year == getDate.year && date.month == getDate.month && date.day == getDate.day;
  }

  factory Consultation.fromFirebase(Map<String, dynamic> map, {BuildContext? context}){
    //print(map);
    String doctor = map['doctor'].toString();
    String patient = map['patient']!['_path']!['segments']![1];
    //String patient = map['patient'].toString().split('/').isNotEmpty&&map['patient'].toString().split('/').length==2?map['patient'].toString().split('/')[1]:map['patient'].toString();
    if(context != null) {
      List<Doctor> doctors = Provider
          .of<DoctorProvider>(context!, listen: false)
          .state['doctors'];
      List<User> patients = Provider
          .of<UserProvider>(context!, listen: false)
          .state['users'];
      int docInd = doctors.indexWhere((element) => element.fid == doctor);
      int patInd = patients.indexWhere((element) => element.fid == patient);
      if (docInd != 1) {
        doctor = jsonEncode(doctors[docInd].toMap());
      }
      if (patInd != 1) {
        patient = jsonEncode(patients[patInd].toMap());
      }
    }

    return Consultation(
        fid: map["id"],
        date: map["date"],
        doctor: doctor.replaceAll("'", "''"),
        patient: patient.replaceAll("'", "''"),
        poids: map["poids"],
        programmed: map["programmed"] ?? map["programmé"] ,
        taille: map["taille"],
        temperature: map["temperature"],
        tension: map["tension"],
        urgence: map["urgence"],
    );
  }

  factory Consultation.fromSQLite(Map map){
    return Consultation(
        id: map["id"],
        fid: map["fid"],
        date: map["date"],
        doctor: map["doctor"],
        patient: map["patient"],
        poids: map["poids"],
        programmed: map["programmed"] == 'true',
        taille: map["taille"],
        temperature: map["temperature"],
        tension: map["tension"],
        urgence: map["urgence"] == 'true',
    );
  }

  factory Consultation.empty(){
    return Consultation(
        fid: "",
        date: "",
        doctor: "",
        patient: "",
        poids: "",
        programmed: false,
        taille: "",
        temperature: "",
        tension: "",
        urgence: false
    );
  }

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'fid': fid,
      'date': date,
      'doctor': doctor,
      'patient': patient,
      'poids': poids,
      'programmed': programmed,
      'taille': taille,
      'temperature': temperature,
      'tension': tension,
      'urgence': urgence
    };
  }

  String allFields() {
    return toMap().values.join('').toLowerCase().trim();
  }

  static List<Consultation> fromSQLiteList(List<Map> listMap) {
    List<Consultation> consultations = [];
    for (Map item in listMap) {
      consultations.add(Consultation.fromSQLite(item));
    }
    return consultations;
  }

}