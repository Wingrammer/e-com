import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hospital_management_system/models/consultation.dart';
import 'package:hospital_management_system/models/doctor.dart';
import 'package:hospital_management_system/models/user.dart';
import 'package:hospital_management_system/providers/consultation_provider.dart';
import 'package:hospital_management_system/providers/doctor_provider.dart';
import 'package:hospital_management_system/providers/user_provider.dart';
import 'package:hospital_management_system/style/colors.dart';
import 'package:hospital_management_system/style/style.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:provider/provider.dart';

class ConsultationForm extends StatefulWidget {
  final Consultation initialConsultation;
  const ConsultationForm({Key? key, required this.initialConsultation}) : super(key: key);

  @override
  State<ConsultationForm> createState() => ConsultationFormState();
}

class ConsultationFormState extends State<ConsultationForm> {

  final formKey = GlobalKey<FormState>();
  Consultation selected = Consultation.empty();
  List<User> users = [];
  List<Doctor> doctors = [];
  User? selectedUser;
  Doctor? selectedDoctor;
  bool urgence = false;
  bool programmed = false;

  final tensionController = TextEditingController();
  final temperatureController = TextEditingController();
  final poidsController = TextEditingController();
  final tailleController = TextEditingController();

  /*@override
  void initState() {
    TODO: implement initState
    super.initState();

  }*/

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    setState(() {
      selected = Provider.of<ConsultationProvider>(context, listen: false).state["selected"];
      doctors = Provider.of<DoctorProvider>(context, listen: false).state["doctors"];
      users = Provider.of<UserProvider>(context, listen: false).state["users"];
    });
    //urgence
    setUrgence(selected.urgence);
    //programmed
    setProgrammed(selected.programmed);
    if(selected.fid.isNotEmpty){
      setSelectedDoctor('${jsonDecode('${selected.doctor}')['nom']}');
      setSelectedUser(
          '${jsonDecode('${selected.patient}')['code']} ${jsonDecode('${selected.patient}')['displayName']}');
      tensionController.value = TextEditingValue(
        text: '${selected.tension}',
        selection: TextSelection.fromPosition(
          TextPosition(offset: selected.tension!.length ?? 0),
        ),
      );
      temperatureController.value = TextEditingValue(
        text: '${selected.temperature}',
        selection: TextSelection.fromPosition(
          TextPosition(offset: selected.temperature!.length ?? 0),
        ),
      );
      poidsController.value = TextEditingValue(
        text: '${selected.poids}',
        selection: TextSelection.fromPosition(
          TextPosition(offset: selected.poids!.length ?? 0),
        ),
      );
      tailleController.value = TextEditingValue(
        text: '${selected.taille}',
        selection: TextSelection.fromPosition(
          TextPosition(offset: selected.taille!.length ?? 0),
        ),
      );
    }
    super.didChangeDependencies();

  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

      return
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text('Patient',
                    style: ralewayStyle.copyWith(
                      fontSize: 12.0,
                      color: Colors.green,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 6.0),
                Consumer<UserProvider>(builder: (_, state, __){
                  users = state.state['users'];
                  return Container(
                    height: 50.0,
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: AppColors.whiteColor,
                    ),
                    child: DropdownSearch<String>(
                      popupProps: const PopupProps.menu(
                          showSelectedItems: true,
                          showSearchBox: true
                      ),
                      items: users.map((e) => '${e.code} ${e.displayName}').toList(),
                      dropdownDecoratorProps: const DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(labelText: "Choisir le patient"),
                      ),

                      onChanged: (String? data) => setSelectedUser(data),
                      selectedItem: selectedUser == null ? '' : '${selectedUser!.code} ${selectedUser!.displayName}',
                    ),
                  );
                }),
                SizedBox(height: height * 0.014),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text('Docteur',
                    style: ralewayStyle.copyWith(
                      fontSize: 12.0,
                      color: Colors.green,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 6.0),
                Consumer<DoctorProvider>(builder: (_, state, __){
                  doctors = state.state['doctors'];
                  return Container(
                    height: 50.0,
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: AppColors.whiteColor,
                    ),
                    child: DropdownSearch<String>(
                      popupProps: const PopupProps.menu(
                          showSelectedItems: true,
                          showSearchBox: true
                      ),
                      items: doctors.map((e) => '${e.nom}').toList(),
                      dropdownDecoratorProps: const DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(labelText: "Choisir le médecin"),
                      ),

                      onChanged: (String? data) => setSelectedDoctor(data),
                      selectedItem: selectedDoctor == null ? '' : '${selectedDoctor!.nom}',
                    ),
                  );
                }),
                SizedBox(height: height * 0.014),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text('Tension',
                    style: ralewayStyle.copyWith(
                      fontSize: 12.0,
                      color: Colors.green,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 6.0),
                Container(
                  height: 50.0,
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: AppColors.whiteColor,
                  ),
                  child: TextFormField(

                    controller: tensionController,
                    style: ralewayStyle.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Colors.green,
                      fontSize: 15.0,
                    ),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.bloodtype),
                      contentPadding: const EdgeInsets.only(top: 16.0),
                      hintText: "Qu'indique le tensiomètre?",
                      hintStyle: ralewayStyle.copyWith(
                        fontWeight: FontWeight.w400,
                        color: Colors.green.withOpacity(0.7),
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: height * 0.014),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text('Température',
                    style: ralewayStyle.copyWith(
                      fontSize: 12.0,
                      color: Colors.green,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 6.0),
                Container(
                  height: 50.0,
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: AppColors.whiteColor,
                  ),
                  child: TextFormField(

                    controller: temperatureController,
                    style: ralewayStyle.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Colors.green,
                      fontSize: 15.0,
                    ),
                    keyboardType: TextInputType.text,
                    enabled: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.thermostat),
                      focusColor: Colors.green,
                      contentPadding: const EdgeInsets.only(top: 16.0),
                      hintText: 'Entrer la temperature',
                      hintStyle: ralewayStyle.copyWith(
                        fontWeight: FontWeight.w400,
                        color: Colors.green.withOpacity(0.7),
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: height * 0.014),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text('Poids',
                    style: ralewayStyle.copyWith(
                      fontSize: 12.0,
                      color: Colors.green,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 6.0),
                Container(
                  height: 50.0,
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: AppColors.whiteColor,
                  ),
                  child: TextFormField(

                    controller: poidsController,
                    style: ralewayStyle.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Colors.green,
                      fontSize: 15.0,
                    ),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.scale),
                      contentPadding: const EdgeInsets.only(top: 16.0),
                      hintText: 'Entrer le poids',
                      hintStyle: ralewayStyle.copyWith(
                        fontWeight: FontWeight.w400,
                        color: Colors.green.withOpacity(0.7),
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: height * 0.014),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text('Taille',
                    style: ralewayStyle.copyWith(
                      fontSize: 12.0,
                      color: Colors.green,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 6.0),
                Container(
                  height: 50.0,
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: AppColors.whiteColor,
                  ),
                  child: TextFormField(

                    controller: tailleController,
                    style: ralewayStyle.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Colors.green,
                      fontSize: 15.0,
                    ),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.height),
                      contentPadding: const EdgeInsets.only(top: 16.0),
                      hintText: 'Entrer la taille',
                      hintStyle: ralewayStyle.copyWith(
                        fontWeight: FontWeight.w400,
                        color: Colors.green.withOpacity(0.7),
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: height * 0.05),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Row(
                    children: [
                      Checkbox(value: urgence, onChanged: setUrgence),
                      Text('Urgence ?',
                        style: ralewayStyle.copyWith(
                          fontSize: 12.0,
                          color: Colors.green,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                    ],
                  )
                ),
                const SizedBox(height: 6.0),
              ]);
  }

  bool isItemDisabled(String s) {
    //return s.startsWith('I');

    if (s.startsWith('I')) {
      return true;
    } else {
      return false;
    }
  }

  void itemSelectionChanged(String? s) {
    print(s);
  }

  void setUrgence(bool? next){
    if(next is bool){
      setState(() {
        urgence = next;
      });
    }
  }

  void setProgrammed(bool? next){
    if(next is bool){
      setState(() {
        programmed = next;
      });
    }
  }

  void setSelectedUser(String? sel){
    String code = sel!.split(" ")[0];
    int ind = users.indexWhere((element) => code == element.code);
    setState(() {
      selectedUser = users[ind];
    });
  }

  void setSelectedDoctor(String? sel){
    int ind = doctors.indexWhere((element) => sel == element.nom);
    setState(() {
      selectedDoctor = doctors[ind];
    });
  }

}