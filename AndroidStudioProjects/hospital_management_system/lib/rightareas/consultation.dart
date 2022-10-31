import 'dart:convert';

import 'package:firedart/auth/user_gateway.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:hospital_management_system/components/PricedListTile.dart';
import 'package:hospital_management_system/config/size_config.dart';
import 'package:hospital_management_system/data.dart';
import 'package:hospital_management_system/firebase_options.dart';
import 'package:hospital_management_system/models/consultation.dart';
import 'package:hospital_management_system/models/doctor.dart';
import 'package:hospital_management_system/models/invoice.dart';
import 'package:hospital_management_system/models/patientInvoiceItem.dart';
import 'package:hospital_management_system/models/product.dart';
import 'package:hospital_management_system/models/productEntry.dart';
import 'package:hospital_management_system/providers/auth_provider.dart';
import 'package:hospital_management_system/providers/consultation_provider.dart';
import 'package:hospital_management_system/providers/doctor_provider.dart';
import 'package:hospital_management_system/providers/drawer_provider.dart';
import 'package:hospital_management_system/providers/invoice_provider.dart';
import 'package:hospital_management_system/providers/patient_invoice_item_provider.dart';
import 'package:hospital_management_system/providers/product_entry_provider.dart';
import 'package:hospital_management_system/providers/product_provider.dart';
import 'package:hospital_management_system/socketio.dart';
import 'package:hospital_management_system/style/colors.dart';
import 'package:hospital_management_system/style/style.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ConsultationRightArea extends StatefulWidget {
  const ConsultationRightArea({
    Key? key,
  }) : super(key: key);

  @override
  State<ConsultationRightArea> createState() => _ConsultationRightAreaState();
}

class _ConsultationRightAreaState extends State<ConsultationRightArea> {
  Consultation? selected;
  User? user;
  DocumentReference? consultationRef;
  List<PatientInvoiceItem> items = [];
  List<Doctor> doctors = [];
  Map doctor = {};
  Firestore? _fs;

  final SocketClient _connexion = SocketClient.instance;

  Socket _getSocket() {
    return _connexion.socket;
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if(_fs == null){
      try{
        _fs = Firestore.initialize(DefaultFirebaseOptions.web.projectId);
      } catch(e){
        print('deja init');
      }
    }
    setState(() {
      items = Provider.of<PatientInvoiceItemProvider>(context, listen: false).state["patientInvoiceItems"];
      user = User.fromMap(Provider.of<AuthProvider>(context, listen: false).currentUser);
      doctors = Provider.of<DoctorProvider>(context, listen: false).state["doctors"];
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConsultationProvider>(builder: (_, state, __) {

      Map doc(){
        try{
          return jsonDecode('${selected!.doctor}');
        }catch(e){
          print(e.toString());
        }
        return {"Nom":"", "Department":"", "Prix":""};
      }
      selected = state.state["selected"];
      if(selected!.fid.isNotEmpty){
        consultationRef = Firestore.instance.collection('consultations').document(selected!.fid);
        doctor = doc();
      }
      Map patient(){
        try{
          return jsonDecode('${selected!.patient}');
        }catch(e){
          print(e.toString());
        }
        return {"Nom":"", "Department":"", "Prix":""};
      }
      Map consultation(){
        try{
          return jsonDecode('${selected!.patient}');
        }catch(e){
          print(e.toString());
        }
        return {"Nom":"", "Department":"", "Prix":""};
      }
      List<PatientInvoiceItem> selectedItems = items.where((element) => consultation()["id"]==selected!.fid).toList();
      return selected!.fid.isNotEmpty ? Column(
        children: [
          SizedBox(
            height: SizeConfig.blockSizeVertical * 5,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              selected!.patient!.isNotEmpty ? PrimaryText(
                text: '${patient()["displayName"]} ${patient()["code"]}' ?? '',
                size: 18,
                fontWeight: FontWeight.w800,
              ) : const Text(''),
              PrimaryText(
                text: selected!.date ?? '',
                size: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.secondary,
              ),
              PrimaryText(
                text: selected!.fid ?? '',
                size: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.secondary,
              ),
              const SizedBox(height: 20,),
              Row(
                children: [
                  const Tooltip(message: 'Taille',child: Icon(Icons.height),),
                  Text(selected!.taille!.isNotEmpty?'${selected!.taille}':'N/A'),
                  const Padding(padding: EdgeInsets.fromLTRB(0, 0, 10, 0)),
                  const Tooltip(message: 'Poids', child: Icon(Icons.scale)),
                  Text(selected!.poids!.isNotEmpty?'${selected!.poids}':'N/A'),
                  const Padding(padding: EdgeInsets.fromLTRB(0, 0, 10, 0)),
                  const Tooltip(message: 'Temperature', child: Icon(Icons.thermostat)),
                  Text(selected!.temperature!.isNotEmpty?'${selected!.temperature}':'N/A'),
                  const Padding(padding: EdgeInsets.fromLTRB(0, 0, 10, 0)),
                  const Tooltip(message: 'Urgent', child: Icon(Icons.medical_services)),
                  Text(selected!.urgence!?'Oui':'Non'),
                  const Padding(padding: EdgeInsets.fromLTRB(0, 0, 10, 0)),
                  const Tooltip(message: 'Tension', child: Icon(Icons.bloodtype)),
                  Text(selected!.tension!.isNotEmpty?'${selected!.tension}':'N/A'),
                ],
              ),
              const SizedBox(height: 20,),
              Row(
                children: [
                  const PrimaryText(text: 'Traitement en cours',),
                  Switch(value: !(selected!.programmed??true), onChanged: (programmed) => !isUserADoctor()?null:setProgrammed(programmed, doctor) )
                ],
              )
            ],
          ),
          SizedBox(
            height: SizeConfig.blockSizeVertical * 2,
          ),
          Column(
            children: List.generate(
              selectedItems.length, (index) {
                Map service(){
                  try{
                    return jsonDecode('${selectedItems[index].service}');
                  }catch(e){
                    print(e.toString());
                  }
                  return {"Nom":"", "Department":"", "Prix":""};
                }

                return PricedListTile(
                    quantity: selectedItems[index].quantite ?? '',
                    label: service()["Nom"],
                    spec: service()["Departement"],
                    amount: service()["Prix"]
                );
              },
            ),
          ),
        ],
      ): const PrimaryText(text: 'Aucune donnée selectionée',);
    });
  }

  bool isUserTheDoctor(doctor) => user!.id == doctor['fid'];
  bool isUserADoctor() => doctors.indexWhere((element) => element.fid == user!.id)!=-1;

  void setProgrammed(bool programmed, doctor){
    print(programmed);
    print(user!.id);
    print(doctor["fid"]);
    print(programmed&&!isUserTheDoctor(doctor));
    if(programmed&&!isUserTheDoctor(doctor)){

      return;
    }
    consultationRef!.update({
      'programmed': programmed,
      'doctor': user!.id,
      'updatedAt': DateTime.now(),
    }).then((value) => notify());
  }

  void notify() {
    Socket socket = _getSocket();
    Map msg = {
      'uid': user!.id,
      'displayName': user!.displayName,
      'photoUrl': user!.photoUrl,
      'payload': {
        'id': selected!.fid
      }
    };
    socket.emit(
      'consultation_upsert',
      msg,
    );
    print(msg);
  }

  String getItemName(String? id){
    List<PatientInvoiceItem> selectedItem = items.where((element) => element.fid==id).toList();
    if(selectedItem.isNotEmpty){
      try{
        return jsonDecode('${selectedItem[0].service}')["Nom"];
      }catch(e){
        print(e.toString());
      }
    }
    return "";
  }

}