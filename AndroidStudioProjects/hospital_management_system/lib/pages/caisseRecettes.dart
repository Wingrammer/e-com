import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:firedart/auth/user_gateway.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:hospital_management_system/components/header.dart';
import 'package:hospital_management_system/config/responsive.dart';
import 'package:hospital_management_system/export.dart';
import 'package:hospital_management_system/firebase_options.dart';
import 'package:hospital_management_system/forms/incomes.dart';
import 'package:hospital_management_system/forms/search.dart';
import 'package:hospital_management_system/models/income.dart';
import 'package:hospital_management_system/providers/auth_provider.dart';
import 'package:hospital_management_system/providers/drawer_provider.dart';
import 'package:hospital_management_system/providers/income_provider.dart';
import 'package:hospital_management_system/style/colors.dart';
import 'package:hospital_management_system/style/style.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:path_provider/path_provider.dart';

class CaisseRecettes extends StatefulWidget {
  const CaisseRecettes({Key? key}) : super(key: key);

  @override
  State<CaisseRecettes> createState() => _CaisseRecettesState();
}

class _CaisseRecettesState extends State<CaisseRecettes> {

  List<Income> incomes = [];
  int? sortColumnIndex;
  bool isAscending = false;
  late List<Income> _incomes;
  late int size;
  late int maxPage;
  int currentPage = 1;
  String reference = '';
  int start = 0;
  double rowHeight = 50;
  late List<bool> selectedPages = List<bool>.generate(maxPage, (index) => index==0 ? true : false);
  late List<bool?> selectedRows = List<bool?>.generate(_incomes.length, (index) => false);
  late List<bool> selectionList = List.generate(2, (_) => false);
  Income initialIncome = Income.empty();
  final _searchKey = GlobalKey<SearchInputState>();
  final _addFormKey = GlobalKey<FormState>();
  final _incomeKey = GlobalKey<IncomeFormState>();
  Firestore? _fs;

  late Socket socket;

  void connectToServer() {
    try {
      // Configure socket transports must be specified
      socket = io('http://127.0.0.1:5001', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });
      // Connect to websocket
      socket.connect();
      // Handle socket events
      socket.on('connect', (dyn){
        print('socket connected');
      });
      socket.on('disconnect', (dyn){
        print('socket disconnected');
      });
      socket.on('sync_income_upsert', (data){
        print('sync_income_upsert');
      });
      socket.on('income_delete', (data){
        print('sync_income_delete');
      });
      socket.emit('greeting-from-client', 'po');
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void didChangeDependencies() {
    setState(() {
      incomes = Provider.of<IncomeProvider>(context, listen: false).state['incomes'];
      _incomes = incomes;
      size = max((MediaQuery.of(context).size.height~/rowHeight), 6) - 5;
      maxPage = _incomes.length~/size + 1;
      selectedPages = List<bool>.generate(maxPage, (index) => index==0 ? true : false);
    });
    if(_fs == null){
      try{
        _fs = Firestore.initialize(DefaultFirebaseOptions.web.projectId);
      } catch(e){
        print('deja init');
      }
    }
    connectToServer();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<IncomeProvider>(
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
                                    selectedRows = List<bool?>.generate(_incomes.length, (index) => allSelected);
                                  });
                                },
                                dataRowHeight: rowHeight,
                                headingRowHeight: rowHeight,
                                sortAscending: isAscending,
                                sortColumnIndex: sortColumnIndex,
                                columns: [
                                  DataColumn(label: const Text('Date'), onSort: onSort),
                                  DataColumn(label: const Text('Reference'), onSort: onSort),
                                  DataColumn(label: const Text('Patient'), onSort: onSort),
                                  DataColumn(label: const Text('Total'), numeric: true, onSort: onSort),
                                ],
                                rows: List<DataRow>.generate(size, (index) {
                                  if(start+index<_incomes.length){
                                    var e = _incomes[start+index];
                                    return DataRow(
                                      onSelectChanged: (selected) {
                                        setState(() {
                                          selectedRows[start+index] = selected;
                                        });
                                      },
                                      selected: selectedRows[start+index] as bool,
                                      cells: [
                                        DataCell(Text('${e.date}')),
                                        DataCell(Text('${e.reference}')),
                                        DataCell(Text(jsonDecode('${e.patient}')['code'])),
                                        DataCell(Text('${e.total}')),
                                      ],
                                    );
                                  }
                                  return const DataRow(
                                    cells: [
                                      DataCell(Text('')),
                                      DataCell(Text('')),
                                      DataCell(Text('')),
                                      DataCell(Text('')),
                                    ],
                                  );
                                }),
                              ),
                              Text('Affichage de ${-start + min(start + size, _incomes.length)} lignes sur ${_incomes.length} de ${start + 1} à ${min(start + size, _incomes.length)}'),
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
      _incomes.sort((income1, income2) =>
          compareDate(ascending, '${income1.date}', '${income2.date}'));
    } else if (columnIndex == 1) {
      _incomes.sort((income1, income2) =>
          compareString(ascending, '${income1.reference}', '${income2.reference}'));
    } else if (columnIndex == 2) {
      _incomes.sort((income1, income2) =>
          compareString(ascending, '${income1.patient}', '${income2.patient}'));
    } else if (columnIndex == 3) {
      _incomes.sort((income1, income2) =>
          compareInt(ascending, '${income1.total}', '${income2.total}'));
    }

    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  void setInitialIncome(){
    setState(() {
      initialIncome = _incomes[selectedRows.indexWhere((element) => element==true)];
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
          searchList: incomes,
          key: _searchKey,
          onChange: () {
            String keyword = _searchKey.currentState!.inputController.text.toLowerCase().trim();
            onPaginate(1);
            setState((){
              _incomes = keyword.isNotEmpty ? incomes.where((element) => element.allFields().contains(keyword)).toList() : incomes;
              maxPage = _incomes.length~/size + 1;
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
            setInitialIncome();
          },
          disabledColor: Colors.grey,
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline_rounded),
          onPressed: selectedRows.where((element) => element==true).toList().length!=1 ? null : (){
            setInitialIncome();
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Suppression'),
                icon: const Icon(Icons.delete_outline_rounded),
                content: const Text('Etes-vous surs de vouloir supprimer cet document?'),
                actions: [
                  TextButton(
                    onPressed: (){
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Document non supprimé'))
                      );
                      Navigator.pop(context);
                      setState(() {
                        initialIncome = Income.empty();
                      });
                    },
                    child: const Text('Annuler'),
                  ),
                  TextButton(
                    onPressed: (){
                      deleteAction(initialIncome.fid);
                      Navigator.pop(context);
                      setState(() {
                        initialIncome = Income.empty();
                      });
                    },
                    child: const Text('Annuler'),
                  ),
                ],
              ),
            );

          },
          disabledColor: Colors.grey,
        ),
        IconButton(
          icon: const Icon(Icons.download_outlined),
          onPressed: selectedRows.where((element) => element==true).toList().isEmpty ? null : ()async{
            Directory rootPath = Export.findRoot(await getApplicationDocumentsDirectory());
            String? path = await FilesystemPicker.openDialog(
              context: context,
              rootDirectory: rootPath,
              fsType: FilesystemType.folder,
            );
            Export.excelFile(incomes, path!);
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
            setInitialIncome();
          },
          disabledColor: Colors.grey,
        ):
        IconButton(
          icon: const Icon(Icons.visibility_outlined),
          onPressed: selectedRows.where((element) => element==true).toList().length!=1 ? null : (){
            showDialog(
              context: context,
              builder: (BuildContext context) => showFormAlert(context),
            );
            setInitialIncome();
          },
          disabledColor: Colors.grey,
        ),
      ],
    );
  }

  Widget showFormAlert(context){
    return AlertDialog(
      scrollable: true,
      title: const Text('Nouvelle Facture'),
      content: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Form(
            key: _addFormKey,
            child: IncomeForm(
              key: _incomeKey,
              initialIncome: initialIncome,
            ),
          )
      ),
      actions: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: (){
              if(_addFormKey.currentState!.validate()){
                if(initialIncome.fid.isEmpty){
                  editAction(_incomeKey.currentState!.referenceController.text);
                } else{
                  editAction(initialIncome.fid);
                }
                Navigator.pop(context);
                setState(() {
                  initialIncome = Income.empty();
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
              child: Text(initialIncome.fid.isEmpty?'Créer':'Modifier',
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

  Future<void> addAction() async {

    await Firestore.instance.collection('incomes').add(
        getMap()
    ).then((value) async{
      User user = User.fromMap(Provider.of<AuthProvider>(context, listen: false).currentUser);
      socket.emit(
        'income_upsert',
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
  }

  DocumentReference doc(id){
    return Firestore.instance.collection('incomes').document(id);
  }

  Future<void> editAction(id) async {
    var docRef = doc(id);
    docRef.update(getMap()).then((value) {
      print(1);
      User user = User.fromMap(Provider.of<AuthProvider>(context, listen: false).currentUser);
      print(user.id);
      socket.emit(
        'income_upsert',
        {
          'uid': user.id,
          'displayName': user.displayName,
          'photoUrl': user.photoUrl,
          'payload': {
            'id': id,
            ...initialIncome.toMap()
          }
        },
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(backgroundColor: Colors.green, content: Text('Effectué avec succès')),
      );
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
    var docRef = doc(id);
    docRef.update({...getMap(), 'deletedAt': DateTime.now()}).then((value) {
      User user = User.fromMap(Provider.of<AuthProvider>(context).currentUser);
      socket.emit(
        'income_delete',
        {
          'uid': user.id,
          'displayName': user.displayName,
          'photoUrl': user.photoUrl,
          'payload': initialIncome.toMap()
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

    var m = {
      'date': _incomeKey.currentState!.dateController.text,
      'reference': _incomeKey.currentState!.referenceController.text,
      'vendeur': _incomeKey.currentState!.vendeurController.text,
      'total': _incomeKey.currentState!.totalController.text,
      'updatedAt': DateTime.now()
    };
    if(initialIncome.fid.isEmpty){
      m["createdAt"] = DateTime.now();
      m["deletedAt"] = DateTime.now();
    }
    setState(() {
      reference = _incomeKey.currentState!.referenceController.text;
      initialIncome = Income.fromSQLite({...m, 'fid':''});
    });
    return m;
  }

}