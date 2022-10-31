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
import 'package:hospital_management_system/forms/invoices.dart';
import 'package:hospital_management_system/forms/search.dart';
import 'package:hospital_management_system/models/invoice.dart';
import 'package:hospital_management_system/providers/auth_provider.dart';
import 'package:hospital_management_system/providers/drawer_provider.dart';
import 'package:hospital_management_system/providers/invoice_provider.dart';
import 'package:hospital_management_system/socketio.dart';
import 'package:hospital_management_system/style/colors.dart';
import 'package:hospital_management_system/style/style.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:path_provider/path_provider.dart';

class CaisseDepenses extends StatefulWidget {
  const CaisseDepenses({Key? key}) : super(key: key);

  @override
  State<CaisseDepenses> createState() => _CaisseDepensesState();
}

class _CaisseDepensesState extends State<CaisseDepenses> {

  List<Invoice> invoices = [];
  int? sortColumnIndex;
  bool isAscending = false;
  late List<Invoice> _invoices;
  late int size;
  late int maxPage;
  int currentPage = 1;
  String reference = '';
  int start = 0;
  double rowHeight = 50;
  late List<bool> selectedPages = List<bool>.generate(maxPage, (index) => index==0 ? true : false);
  late List<bool?> selectedRows = List<bool?>.generate(_invoices.length, (index) => false);
  late List<bool> selectionList = List.generate(2, (_) => false);
  Invoice initialInvoice = Invoice.empty();
  final _searchKey = GlobalKey<SearchInputState>();
  final _addFormKey = GlobalKey<FormState>();
  final _invoiceKey = GlobalKey<InvoiceFormState>();
  Firestore? _fs;

  //late Socket socket;
  final SocketClient _connexion = SocketClient.instance;

  Socket _getSocket() {
    return _connexion.socket;
  }

  @override
  void didChangeDependencies() {
    setState(() {
      invoices = Provider.of<InvoiceProvider>(context, listen: false).state['invoices'];
      _invoices = invoices;
      size = max((MediaQuery.of(context).size.height~/rowHeight), 6) - 5;
      maxPage = _invoices.length~/size + 1;
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
    return Consumer<InvoiceProvider>(
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
                                selectedRows = List<bool?>.generate(_invoices.length, (index) => allSelected);
                              });
                            },
                            dataRowHeight: rowHeight,
                            headingRowHeight: rowHeight,
                            sortAscending: isAscending,
                            sortColumnIndex: sortColumnIndex,
                            columns: [
                              DataColumn(label: const Text('Date'), onSort: onSort),
                              DataColumn(label: const Text('Reference'), onSort: onSort),
                              DataColumn(label: const Text('Vendeur'), onSort: onSort),
                              DataColumn(label: const Text('Total'), numeric: true, onSort: onSort),
                            ],
                            rows: List<DataRow>.generate(size, (index) {
                              if(start+index<_invoices.length){
                                var e = _invoices[start+index];
                                return DataRow(
                                  onSelectChanged: (selected) {
                                    setState(() {
                                      selectedRows[start+index] = selected;
                                    });
                                    state.selected = selected==true ? _invoices[start+index] : Invoice.empty();
                                  },
                                  selected: selectedRows[start+index] as bool,
                                  cells: [
                                    DataCell(Text(e.date)),
                                    DataCell(Text(e.reference)),
                                    DataCell(Text(e.vendeur)),
                                    DataCell(Text(e.total)),
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
                          Text('Affichage de ${-start + min(start + size, _invoices.length)} lignes sur ${_invoices.length} de ${start + 1} à ${min(start + size, _invoices.length)}'),
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
      _invoices.sort((invoice1, invoice2) =>
          compareDate(ascending, invoice1.date, invoice2.date));
    } else if (columnIndex == 1) {
      _invoices.sort((invoice1, invoice2) =>
          compareString(ascending, invoice1.reference, invoice2.reference));
    } else if (columnIndex == 2) {
      _invoices.sort((invoice1, invoice2) =>
          compareString(ascending, invoice1.vendeur, invoice2.vendeur));
    } else if (columnIndex == 3) {
      _invoices.sort((invoice1, invoice2) =>
          compareInt(ascending, invoice1.total, invoice2.total));
    }

    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  void setInitialInvoice(){
    var sel = _invoices[selectedRows.indexWhere((element) => element==true)];
    setState(() {
      initialInvoice = sel;
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
          searchList: invoices,
          key: _searchKey,
          onChange: () {
            String keyword = _searchKey.currentState!.inputController.text.toLowerCase().trim();
            onPaginate(1);
            setState((){
              _invoices = keyword.isNotEmpty ? invoices.where((element) => element.allFields().contains(keyword)).toList() : invoices;
              maxPage = _invoices.length~/size + 1;
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
            setInitialInvoice();
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
                      setInitialInvoice();
                      deleteAction(initialInvoice.fid);
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
            Export.excelFile(invoices, path!);
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
            setInitialInvoice();
          },
          disabledColor: Colors.grey,
        ):
        IconButton(
          icon: const Icon(Icons.visibility_outlined),
          onPressed: selectedRows.where((element) => element==true).toList().length!=1 ? null : (){
            setInitialInvoice();
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
            child: InvoiceForm(
              key: _invoiceKey,
              initialInvoice: initialInvoice,
            ),
          )
      ),
      actions: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: (){
              if(_addFormKey.currentState!.validate()){
                if(initialInvoice.fid.isEmpty){
                  editAction(_invoiceKey.currentState!.referenceController.text);
                } else{
                  editAction(initialInvoice.fid);
                }
                Navigator.pop(context);
                setState(() {
                  initialInvoice = Invoice.empty();
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
              child: Text(initialInvoice.fid.isEmpty?'Créer':'Modifier',
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
    Socket socket = _getSocket();
    await Firestore.instance.collection('invoices').add(
        getMap()
    ).then((value) async{
      User user = User.fromMap(Provider.of<AuthProvider>(context, listen: false).currentUser);
      socket.emit(
        'invoice_upsert',
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
    return Firestore.instance.collection('invoices').document(id);
  }

  Future<void> editAction(id) async {
    Socket socket = _getSocket();
    var docRef = doc(id);
    docRef.update(getMap()).then((value) {
      print(1);
      User user = User.fromMap(Provider.of<AuthProvider>(context, listen: false).currentUser);
      print(user.id);
      socket.emit(
        'invoice_upsert',
        {
          'uid': user.id,
          'displayName': user.displayName,
          'photoUrl': user.photoUrl,
          'payload': {
            'id': id,
            ...initialInvoice.toMap()
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
    Socket socket = _getSocket();
    var docRef = doc(id);
    print(id);
    print(getMap());
    docRef.update({...getMap(), 'deletedAt': DateTime.now(), 'updatedAt': DateTime.now()}).then((value) {
      User user = User.fromMap(Provider.of<AuthProvider>(context, listen: false).currentUser);
      socket.emit(
        'invoice_delete',
        {
          'uid': user.id,
          'displayName': user.displayName,
          'photoUrl': user.photoUrl,
          'payload': initialInvoice.toMap()
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
    if(_invoiceKey.currentState!=null){
      print('hither');
      m = {
        'date': _invoiceKey.currentState!.dateController.text,
        'reference': _invoiceKey.currentState!.referenceController.text,
        'vendeur': _invoiceKey.currentState!.vendeurController.text,
        'total': _invoiceKey.currentState!.totalController.text,
        'updatedAt': DateTime.now()
      };
    }
    else{
      print('thither');
      m = initialInvoice.toMap();
    }
    //In case of adding
    if(initialInvoice.fid.isEmpty){
      m["createdAt"] = DateTime.now();
      m["deletedAt"] = DateTime.now();
    }
    print(m);
    /*if(_invoiceKey.currentState!=null){
      setState(() {
        reference = _invoiceKey.currentState!.referenceController.text;
        initialInvoice = Invoice.fromSQLite({...m, 'fid': ''});
      });
    }*/
    print('phiter');
    return m;
  }

}