import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:firedart/auth/user_gateway.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hospital_management_system/components/header.dart';
import 'package:hospital_management_system/config/responsive.dart';
import 'package:hospital_management_system/export.dart';
import 'package:hospital_management_system/firebase_options.dart';
import 'package:hospital_management_system/forms/consultations.dart';
import 'package:hospital_management_system/forms/search.dart';
import 'package:hospital_management_system/models/consultation.dart';
import 'package:hospital_management_system/providers/auth_provider.dart';
import 'package:hospital_management_system/providers/consultation_provider.dart';
import 'package:hospital_management_system/providers/drawer_provider.dart';
import 'package:hospital_management_system/socketio.dart';
import 'package:hospital_management_system/style/colors.dart';
import 'package:hospital_management_system/style/style.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:path_provider/path_provider.dart';

class ConsultationTab extends StatefulWidget {
  const ConsultationTab({Key? key}) : super(key: key);

  @override
  State<ConsultationTab> createState() => _ConsultationTabState();
}

class _ConsultationTabState extends State<ConsultationTab> {

  List<Consultation> consultations = [];
  int? sortColumnIndex;
  bool isAscending = false;
  late List<Consultation> _consultations;
  late int size;
  late int maxPage;
  int currentPage = 1;
  String temperature = '';
  int start = 0;
  double rowHeight = 50;
  late List<bool> selectedPages = List<bool>.generate(maxPage, (index) => index==0 ? true : false);
  late List<bool?> selectedRows = List<bool?>.generate(_consultations.length, (index) => false);
  late List<bool> selectionList = List.generate(2, (_) => false);
  Consultation initialConsultation = Consultation.empty();
  final _searchKey = GlobalKey<SearchInputState>();
  final _addFormKey = GlobalKey<FormState>();
  final _consultationKey = GlobalKey<ConsultationFormState>();
  Firestore? _fs;

  //late Socket socket;
  final SocketClient _connexion = SocketClient.instance;

  Socket _getSocket() {
    return _connexion.socket;
  }

  @override
  void didChangeDependencies() {
    setState(() {
      consultations = Provider.of<ConsultationProvider>(context, listen: false).state['consultations'];
      _consultations = consultations;
      size = max((MediaQuery.of(context).size.height~/rowHeight), 6) - 5;
      maxPage = _consultations.length~/size + 1;
      selectedPages = List<bool>.generate(maxPage, (index) => index==0 ? true : false);
    });
    if(_fs == null){
      try{
        _fs = Firestore.initialize(DefaultFirebaseOptions.web.projectId);
      } catch(e){
        print('deja init');
      }
    }
    //socketio.connectToServer(context);
    super.didChangeDependencies();
  }

  @override
  void dispose(){
    //socketio.socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConsultationProvider>(
        builder: (context, state, child) {

          return
            Expanded(
                flex: 10,
                child: SafeArea(
                    child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Header(),
                              toolBar(),
                              DataTable(
                                onSelectAll: (allSelected){
                                  setState(() {
                                    selectedRows = List<bool?>.generate(_consultations.length, (index) => allSelected);
                                  });
                                },
                                dataRowHeight: rowHeight,
                                headingRowHeight: rowHeight,
                                sortAscending: isAscending,
                                sortColumnIndex: sortColumnIndex,
                                columns: [
                                  DataColumn(label: const Text('Date'), onSort: onSort),
                                  DataColumn(label: const Text('Docteur'), onSort: onSort),
                                  DataColumn(label: const Text('Patient'), onSort: onSort),
                                  DataColumn(label: const Text('En cours'), onSort: onSort),
                                  DataColumn(label: const Text('Urgence'), onSort: onSort),
                                ],
                                rows: List<DataRow>.generate(size, (index) {
                                  if(start+index<_consultations.length){
                                    var e = _consultations[start+index];
                                    String doc(){
                                      try{
                                        return jsonDecode('${e.doctor}')!['nom'];
                                      }catch(e){
                                        print(e.toString());
                                      }
                                      return "";
                                    }
                                    String pat(){
                                      try{
                                        return jsonDecode('${e.patient}')!['displayName'];
                                      }catch(e){
                                        print(e.toString());
                                      }
                                      return "";
                                    }
                                    return DataRow(
                                      onSelectChanged: (selected) {
                                        setState(() {
                                          selectedRows[start+index] = selected;
                                        });
                                        state.selected = selected==true ? _consultations[start+index] : Consultation.empty();
                                      },
                                      selected: selectedRows[start+index] as bool,
                                      cells: [
                                        DataCell(Text(e.getDate.toIso8601String().split('T')[0])),
                                        DataCell(Text(doc())),
                                        DataCell(Text(pat())),
                                        DataCell(SvgPicture.asset(e.programmed!?'assets/unchecked-svgrepo-com.svg':'assets/checked-svgrepo-com.svg', width:35)),
                                        DataCell(SvgPicture.asset(e.urgence!?'assets/unchecked-svgrepo-com.svg':'assets/health-doctor-medical-medicine-box-box-svgrepo-com.svg', width:35)),
                                      ],
                                    );
                                  }
                                  return const DataRow(
                                    cells: [
                                      DataCell(Text('')),
                                      DataCell(Text('')),
                                      DataCell(Text('')),
                                      DataCell(Text('')),
                                      DataCell(Text('')),
                                    ],
                                  );
                                }),
                              ),
                              Text('Affichage de ${-start + min(start + size, _consultations.length)} lignes sur ${_consultations.length} de ${start + 1} à ${min(start + size, _consultations.length)}'),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: currentPage==1 ? null : () {
                                      onPaginate(currentPage - 1);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      maximumSize: const Size(60, 40),
                                      minimumSize: const Size(60, 40),
                                      backgroundColor: Colors.green,
                                      disabledForegroundColor: Colors.white70,
                                    ),
                                    child: const Icon(Icons.chevron_left),
                                  ),
                                  ToggleButtons(
                                    selectedColor: Colors.green,
                                    constraints: const BoxConstraints(maxHeight: 30, maxWidth: 30, minHeight: 30, minWidth: 30),
                                    isSelected: selectedPages,
                                    onPressed: (selected) {
                                      onPaginate(selected+1);
                                      setSelectedPages(selected);
                                    },
                                    children: List<Widget>.generate(maxPage, (index) => Text('${index + 1}')),
                                  ),
                                  ElevatedButton(
                                    onPressed: currentPage==maxPage ? null : (){
                                      onPaginate(currentPage+1);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      maximumSize: const Size(60, 40),
                                      minimumSize: const Size(60, 40),
                                      backgroundColor: Colors.green,
                                      disabledForegroundColor: Colors.white70,
                                    ),
                                    child: const Icon(Icons.chevron_right),
                                  ),
                                ],
                              ),
                              if (!Responsive.isDesktop(context)) Consumer<DrawerNavigator>(
                                builder: (context, drawerNavigator, _) => drawerNavigator.getRightArea(),
                              ),

                            ]
                        )
                    )
                )
            );
        }
    );
  }



  void setSelectedPages(selected){
    setState(() {
      selectedPages = List<bool>.generate(maxPage, (index) => index==selected ? true : false);
    });
  }

  void onPaginate(int index) {
    setState(() {
      currentPage = index;
      start = size * (currentPage - 1);
    });
    setSelectedPages(index-1);
  }

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      _consultations.sort((consultation1, consultation2) =>
          compareDate(ascending, 'consultation1.tension', 'consultation2.tension'));
    } else if (columnIndex == 1) {
      _consultations.sort((consultation1, consultation2) =>
          compareString(ascending, 'consultation1.temperature', 'consultation2.temperature'));
    } else if (columnIndex == 2) {
      _consultations.sort((consultation1, consultation2) =>
          compareString(ascending, 'consultation1.poids', 'consultation2.poids'));
    } else if (columnIndex == 3) {
      _consultations.sort((consultation1, consultation2) =>
          compareInt(ascending, 'consultation1.taille', 'consultation2.taille'));
    }

    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  void setInitialConsultation(){
    var sel = _consultations[selectedRows.indexWhere((element) => element==true)];
    setState(() {
      initialConsultation = sel;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);

  int compareDate(bool ascending, String value1, String value2) =>
      ascending ? strToDate(value1).compareTo(strToDate(value2)) : strToDate(value2).compareTo(strToDate(value1));

  int compareInt(bool ascending, String value1, String value2) =>
      ascending ? int.parse(value1).compareTo(int.parse(value2)) : int.parse(value2).compareTo(int.parse(value1));

  DateTime strToDate(String st){
    String et = st.split('/').reversed.join('-');
    return DateTime.parse(et);
  }

  Widget toolBar(){
    return Row(
      children: [
        SearchInput(
          searchList: consultations,
          key: _searchKey,
          onChange: () {
            String keyword = _searchKey.currentState!.inputController.text.toLowerCase().trim();
            onPaginate(1);
            setState((){
              _consultations = keyword.isNotEmpty ? consultations.where((element) => element.allFields().contains(keyword)).toList() : consultations;
              maxPage = _consultations.length~/size + 1;
              selectedPages = List<bool>.generate(maxPage, (index) => index==0 ? true : false);
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.add_rounded),
          onPressed: (){
            showDialog(
              context: context,
              builder: (BuildContext context) => showFormAlert(context),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.edit_outlined),
          onPressed: selectedRows.where((element) => element==true).toList().length!=1 ? null : (){
            showDialog(
              context: context,
              builder: (BuildContext context) => showFormAlert(context),
            );
            setInitialConsultation();
          },
          disabledColor: Colors.grey,
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline_rounded),
          onPressed: selectedRows.where((element) => element==true).toList().length!=1 ? null : (){

            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Suppression'),
                icon: const Icon(Icons.delete_outline_rounded),
                content: const Text('Etes-vous surs de vouloir supprimer cet document?'),
                actions: [
                  TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: const Text('Annuler'),
                  ),
                  TextButton(
                    onPressed: (){
                      setInitialConsultation();
                      deleteAction(initialConsultation.fid);
                      Navigator.pop(context);
                    },
                    child: const Text('Oui'),
                  ),
                ],
              ),
            );


          },
          disabledColor: Colors.grey,
        ),
        IconButton(
          icon: const Icon(Icons.download_outlined),
          onPressed: ()async{
            Directory rootPath = Export.findRoot(await getApplicationDocumentsDirectory());
            String? path = await FilesystemPicker.openDialog(
              context: context,
              rootDirectory: rootPath,
              fsType: FilesystemType.folder,
            );
            Export.excelFile(consultations, path!);
          },
          disabledColor: Colors.grey,
        ),
        Responsive.isDesktop(context) ?
        IconButton(
          icon: const Icon(Icons.print),
          onPressed: selectedRows.where((element) => element==true).toList().length!=1 ? null : (){
            showDialog(
              context: context,
              builder: (BuildContext context) => showFormAlert(context),
            );
            setInitialConsultation();
          },
          disabledColor: Colors.grey,
        ):
        IconButton(
          icon: const Icon(Icons.visibility_outlined),
          onPressed: selectedRows.where((element) => element==true).toList().length!=1 ? null : (){
            setInitialConsultation();
          },
          disabledColor: Colors.grey,
        ),
      ],
    );
  }

  Widget showFormAlert(context){
    return AlertDialog(
      scrollable: true,
      title: const Text('Consultation'),
      content: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Form(
            key: _addFormKey,
            child: ConsultationForm(
              key: _consultationKey,
              initialConsultation: initialConsultation,
            ),
          )
      ),
      actions: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: (){
              if(_addFormKey.currentState!.validate()){
                if(initialConsultation.fid.isEmpty){
                  addAction();
                } else{
                  editAction(initialConsultation.fid);
                }
                Navigator.pop(context);
                setState(() {
                  initialConsultation = Consultation.empty();
                });
              }
            },
            borderRadius: BorderRadius.circular(16.0),
            child: Ink(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.green,
              ),
              child: Text(initialConsultation.fid.isEmpty?'Créer':'Modifier',
                style: ralewayStyle.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.whiteColor,
                  fontSize: 13.0,
                ),
              ),
            ),
          ),
        )
      ],
      backgroundColor: AppColors.primaryBg,
    );
  }

  /*Future<void> addAction() async {
    Socket socket = _getSocket();
    await Firestore.instance.collection('consultations').add(
        getMap()
    ).then((value) async{
      User user = User.fromMap(Provider.of<AuthProvider>(context, listen: false).currentUser);
      socket.emit(
        'consultation_upsert',
        {
          'uid': user.id,
          'displayName': user.displayName,
          'photoUrl': user.photoUrl,
          'payload': {
            'id': value.id,
            ...value.map
          }
        },
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(backgroundColor: Colors.green, content: Text('Crée avec succès')),
      );
    }).catchError((err){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.green, content: Text('$err'))
      );
      return null;
    });
  }*/

  DocumentReference doc(id){
    return Firestore.instance.collection('consultations').document(id);
  }

  void notify(id, Map<String, dynamic> result) {
    print(result);
    Socket socket = _getSocket();
    print(1);
    User user = User.fromMap(Provider.of<AuthProvider>(context, listen: false).currentUser);
    print(user.id);
    Map msg = {
      'uid': user.id,
      'displayName': user.displayName,
      'photoUrl': user.photoUrl,
      'payload': {
        'id': id
      }
    };
    socket.emit(
      'consultation_upsert',
      msg,
    );
    print(msg);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(backgroundColor: Colors.green, content: Text('Effectué avec succès')),
    );
  }

  Future<void> editAction(id) async {

    var docRef = doc(id);
    docRef.update(getMap()).then((value) {
      notify(id, initialConsultation.toMap());
    }).catchError((err){
      print(err);
      print(2);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.green, content: Text('$err')),
      );
      return null;
    });
  }

  Future<void> addAction() async {

    await Firestore.instance.collection('consultations').add(getMap()).then((value) {
      print(value.id);
      print(value.map);
      notify(value.id, value.map);
    }).catchError((err){
      print(err);
      print(2);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.green, content: Text('$err')),
      );
      return null;
    });
  }

  Future<void> deleteAction(id) async {
    Socket socket = _getSocket();
    var docRef = doc(id);
    print(id);
    print(getMap());
    docRef.update({...getMap(), 'deletedAt': DateTime.now(), 'updatedAt': DateTime.now()}).then((value) {
      User user = User.fromMap(Provider.of<AuthProvider>(context, listen: false).currentUser);
      socket.emit(
        'consultation_delete',
        {
          'uid': user.id,
          'displayName': user.displayName,
          'photoUrl': user.photoUrl,
          'payload': initialConsultation.toMap()
        },
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(backgroundColor: Colors.green, content: Text('Supprimé avec succès')),
      );
    }).catchError((err){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.green, content: Text('$err')),
      );
      return null;
    });
  }

  Map<String, dynamic> getMap(){
    print('o');
    Map<String, dynamic> m = {};
    //edit and add (form involved)
    if(_consultationKey.currentState!=null){
      print('hither');
      print(_consultationKey.currentState!.selectedUser!.fid != null);

      m = {
        'doctor': _consultationKey.currentState!.selectedDoctor!.fid,
        'tension': _consultationKey.currentState!.tensionController.text,
        'temperature': _consultationKey.currentState!.temperatureController.text,
        'poids': _consultationKey.currentState!.poidsController.text,
        'taille': _consultationKey.currentState!.tailleController.text,
        "programmed": _consultationKey.currentState!.programmed,
        'urgence': _consultationKey.currentState!.urgence,
        'updatedAt': DateTime.now(),
        'date': DateTime.now().toIso8601String(),
      };
      if(_consultationKey.currentState!.selectedUser!.fid != null){
        //m["patient"] = '/users/${_consultationKey.currentState!.selectedUser!.fid}';
        print(m["patient"]);
        m['patient'] = Firestore.instance.collection('users').document('${_consultationKey.currentState!.selectedUser!.fid}');
      }
    }
    else{
      print('thither');
      m = initialConsultation.toMap();
    }
    //In case of adding
    if(initialConsultation.fid.isEmpty){
      m["createdAt"] = DateTime.now();
      m["deletedAt"] = DateTime.now();
    }
    print(m);
    if(_consultationKey.currentState!=null){
      setState(() {
        temperature = _consultationKey.currentState!.temperatureController.text;
        initialConsultation = Consultation.fromSQLite({...m, 'patient': m['patient'].toString(), 'fid': ''});
      });
    }
    print('phiter');
    return m;
  }

}