import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hospital_management_system/components/appBarActionItems.dart';
import 'package:hospital_management_system/components/calendar.dart';
import 'package:hospital_management_system/components/drawer.dart';
import 'package:hospital_management_system/components/notificationList.dart';
import 'package:hospital_management_system/components/paymentDetailList.dart';
import 'package:hospital_management_system/config/responsive.dart';
import 'package:hospital_management_system/config/size_config.dart';
import 'package:hospital_management_system/providers/consultation_provider.dart';
import 'package:hospital_management_system/providers/doctor_provider.dart';
import 'package:hospital_management_system/providers/drawer_provider.dart';
import 'package:hospital_management_system/providers/income_provider.dart';
import 'package:hospital_management_system/providers/invoice_provider.dart';
import 'package:hospital_management_system/providers/notification_provider.dart';
import 'package:hospital_management_system/providers/other_entry_provider.dart';
import 'package:hospital_management_system/providers/other_outing_provider.dart';
import 'package:hospital_management_system/providers/other_provider.dart';
import 'package:hospital_management_system/providers/patient_invoice_item_provider.dart';
import 'package:hospital_management_system/providers/product_entry_provider.dart';
import 'package:hospital_management_system/providers/product_outing_provider.dart';
import 'package:hospital_management_system/providers/product_provider.dart';
import 'package:hospital_management_system/providers/service_provider.dart';
import 'package:hospital_management_system/providers/test_provider.dart';
import 'package:hospital_management_system/providers/user_provider.dart';
import 'package:hospital_management_system/socketio.dart';
import 'package:hospital_management_system/style/colors.dart';
import 'package:hospital_management_system/style/style.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
//import 'package:socket_io_client/socket_io_client.dart' as IO;

class Entry extends StatefulWidget {
  const Entry({Key? key}) : super(key: key);

  @override
  State<Entry> createState() => _EntryState();
}


class _EntryState extends State<Entry> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final _calendarKey = GlobalKey<CalendarState>();
  bool visibleCalendar = false;

  bool visibleNotifications = false;

  final SocketClient _connexion = SocketClient.instance;

  Socket _getSocket() {
    return _connexion.socket;
  }

  void notify(target, data, context, enable){
    Provider.of<NotificationProvider>(context, listen: false).incoming({
      "title": "Nouvelle facture",
      "subtitle": data["subtitle"],
      "id": data["id"],
      "enable": enable,
      "target": target
    });
    print('Hello');
  }

  void connectToServer(context) {
    try {
      /*Configure socket transports must be sepecified
      socket = io('http://127.0.0.1:5001', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });*/
      // Connect to websocket
      //socket.connect();
      // Handle socket events
      Socket socket = _getSocket();
      socket.on('connect', (dyn){
        print('socket connected');
      });
      socket.on('greeting-from-server', (dyn){
        print(dyn);
      });
      socket.on('disconnect', (dyn){
        print('socket disconnected');
      });
      socket.on('sync_invoice_upsert', (data)async{
        //selectedRows = List<bool?>.generate(_invoices.length, (index) => false);
        notify("invoice", data, context, true);
        await Provider.of<InvoiceProvider>(context, listen: false).init();
      });
      socket.on('sync_invoice_delete', (data)async{
        //selectedRows = List<bool?>.generate(_invoices.length, (index) => false);
        notify("invoice", data, context, false);
        await Provider.of<InvoiceProvider>(context, listen: false).init();
      });
      socket.on('sync_income_upsert', (data)async{
        //selectedRows = List<bool?>.generate(_incomes.length, (index) => false);
        notify("income", data, context, true);
        await Provider.of<IncomeProvider>(context, listen: false).init();
      });
      socket.on('sync_income_delete', (data)async{
        //selectedRows = List<bool?>.generate(_incomes.length, (index) => false);
        notify("income", data, context, false);
        await Provider.of<IncomeProvider>(context, listen: false).init();
      });
      socket.on('sync_consultation_upsert', (data)async{
        //selectedRows = List<bool?>.generate(_consultations.length, (index) => false);
        notify("consultation", data, context, true);
        await Provider.of<ConsultationProvider>(context, listen: false).init(context);
      });
      socket.on('sync_consultation_delete', (data)async{
        //selectedRows = List<bool?>.generate(_consultations.length, (index) => false);
        notify("consultation", data, context, false);
        await Provider.of<ConsultationProvider>(context, listen: false).init(context);
      });
      socket.on('sync_doctor_upsert', (data)async{
        //selectedRows = List<bool?>.generate(_doctors.length, (index) => false);
        notify("doctor", data, context, true);
        await Provider.of<DoctorProvider>(context, listen: false).init();
      });
      socket.on('sync_doctor_delete', (data)async{
        //selectedRows = List<bool?>.generate(_doctors.length, (index) => false);
        notify("doctor", data, context, false);
        await Provider.of<DoctorProvider>(context, listen: false).init();
      });
      socket.on('sync_other_upsert', (data)async{
        //selectedRows = List<bool?>.generate(_others.length, (index) => false);
        notify("other", data, context, true);
        await Provider.of<OtherProvider>(context, listen: false).init();
      });
      socket.on('sync_other_delete', (data)async{
        //selectedRows = List<bool?>.generate(_others.length, (index) => false);
        notify("other", data, context, false);
        await Provider.of<OtherProvider>(context, listen: false).init();
      });
      socket.on('sync_product_upsert', (data)async{
        //selectedRows = List<bool?>.generate(_products.length, (index) => false);
        notify("product", data, context, true);
        await Provider.of<ProductProvider>(context, listen: false).init();
      });
      socket.on('sync_product_delete', (data)async{
        //selectedRows = List<bool?>.generate(_products.length, (index) => false);
        notify("product", data, context, false);
        await Provider.of<ProductProvider>(context, listen: false).init();
      });
      socket.on('sync_patientInvoiceItem_upsert', (data)async{
        //selectedRows = List<bool?>.generate(_patientInvoiceItems.length, (index) => false);
        notify("patientInvoiceItem", data, context, true);
        await Provider.of<PatientInvoiceItemProvider>(context, listen: false).init();
      });
      socket.on('sync_patientInvoiceItem_delete', (data)async{
        //selectedRows = List<bool?>.generate(_patientInvoiceItems.length, (index) => false);
        notify("patientInvoiceItem", data, context, false);
        await Provider.of<PatientInvoiceItemProvider>(context, listen: false).init();
      });
      socket.on('sync_service_upsert', (data)async{
        //selectedRows = List<bool?>.generate(_services.length, (index) => false);
        notify("service", data, context, true);
        await Provider.of<ServiceProvider>(context, listen: false).init();
      });
      socket.on('sync_service_delete', (data)async{
        //selectedRows = List<bool?>.generate(_services.length, (index) => false);
        notify("service", data, context, false);
        await Provider.of<ServiceProvider>(context, listen: false).init();
      });
      socket.on('sync_test_upsert', (data)async{
        //selectedRows = List<bool?>.generate(_tests.length, (index) => false);
        notify("test", data, context, true);
        await Provider.of<TestProvider>(context, listen: false).init();
      });
      socket.on('sync_test_delete', (data)async{
        //selectedRows = List<bool?>.generate(_tests.length, (index) => false);
        notify("test", data, context, false);
        await Provider.of<TestProvider>(context, listen: false).init();
      });
      socket.on('sync_user_upsert', (data)async{
        //selectedRows = List<bool?>.generate(_users.length, (index) => false);
        notify("user", data, context, true);
        await Provider.of<UserProvider>(context, listen: false).init();
      });
      socket.on('sync_user_delete', (data)async{
        //selectedRows = List<bool?>.generate(_users.length, (index) => false);
        notify("user", data, context, false);
        await Provider.of<UserProvider>(context, listen: false).init();
      });
      socket.on('sync_otherEntry_upsert', (data)async{
        //selectedRows = List<bool?>.generate(_otherEntrys.length, (index) => false);
        notify("otherEntry", data, context, true);
        await Provider.of<OtherEntryProvider>(context, listen: false).init();
      });
      socket.on('sync_otherEntry_delete', (data)async{
        //selectedRows = List<bool?>.generate(_otherEntrys.length, (index) => false);
        notify("otherEntry", data, context, false);
        await Provider.of<OtherEntryProvider>(context, listen: false).init();
      });
      socket.on('sync_otherOuting_upsert', (data)async{
        //selectedRows = List<bool?>.generate(_otherOutings.length, (index) => false);
        notify("otherOuting", data, context, true);
        await Provider.of<OtherOutingProvider>(context, listen: false).init();
      });
      socket.on('sync_otherOuting_delete', (data)async{
        //selectedRows = List<bool?>.generate(_otherOutings.length, (index) => false);
        notify("otherOuting", data, context, false);
        await Provider.of<OtherOutingProvider>(context, listen: false).init();
      });
      socket.on('sync_productEntry_upsert', (data)async{
        //selectedRows = List<bool?>.generate(_productEntrys.length, (index) => false);
        notify("productEntry", data, context, true);
        await Provider.of<ProductEntryProvider>(context, listen: false).init();
      });
      socket.on('sync_productEntry_delete', (data)async{
        //selectedRows = List<bool?>.generate(_productEntrys.length, (index) => false);
        notify("productEntry", data, context, false);
        await Provider.of<ProductEntryProvider>(context, listen: false).init();
      });
      socket.on('sync_productOuting_upsert', (data)async{
        //selectedRows = List<bool?>.generate(_productOutings.length, (index) => false);
        notify("productOuting", data, context, true);
        await Provider.of<ProductOutingProvider>(context, listen: false).init();
      });
      socket.on('sync_productOuting_delete', (data)async{
        //selectedRows = List<bool?>.generate(_productOutings.length, (index) => false);
        notify("productOuting", data, context, false);
        await Provider.of<ProductOutingProvider>(context, listen: false).init();
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void didChangeDependencies() {
    connectToServer(context);
    super.didChangeDependencies();
  }

  /*@override
  void dispose(){
    Socket socket = _getSocket();
    socket.disconnect();
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: _drawerKey,
      drawer: const ComplexDrawer(),
      appBar: !Responsive.isDesktop(context)
          ? AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        leading: IconButton(
            onPressed: () {
              _drawerKey.currentState?.openDrawer();
            },
            icon: const Icon(Icons.menu, color: AppColors.black)
        ),
        title: Consumer<DrawerNavigator>(
            builder: (context, drawerNavigator, _) => PrimaryText(
              text: drawerNavigator.currentRoute.split('/')[0],
              size: 15,
              fontWeight: FontWeight.w800,
            ),
        ),
        actions: [
          appBarRow(),
        ],
      )
          : const PreferredSize(
        preferredSize: Size.zero,
        child: SizedBox(),
      ),
      body: SafeArea(
        child: Stack(

          children: [

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (Responsive.isDesktop(context))
                  const Expanded(
                    flex: 2,
                    child: ComplexDrawer(),
                  ),
                Consumer<DrawerNavigator>(
                    builder: (context, drawerNavigator, _) => drawerNavigator.getPage()
                ),
                if (Responsive.isDesktop(context))
                  Expanded(
                    flex: 4,
                    child: SafeArea(
                      child: Container(
                        width: double.infinity,
                        height: SizeConfig.screenHeight,
                        decoration: const BoxDecoration(color: AppColors.secondaryBg),
                        child: SingleChildScrollView(
                          padding:
                          const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                          child: Column(
                            children: [
                              appBarRow(),
                              Consumer<DrawerNavigator>(
                                builder: (context, drawerNavigator, _) => drawerNavigator.getRightArea(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Notifications(visible: visibleNotifications,),
            Calendar(key: _calendarKey,),
          ]
        )
      ),
    );
  }

  Widget appBarRow(){
    int notLength = Provider.of<NotificationProvider>(context).state['notifications'].length;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
            icon: SvgPicture.asset(
              'assets/calendar.svg',
              width: 20,
            ),
            onPressed: () {
              setState(() {
                visibleCalendar=!visibleCalendar;
              });
              final controlledState = _calendarKey.currentState;
              controlledState?.changeVisibleState(visibleCalendar);
            }),
        const SizedBox(width: 10),
        Badge(
          badgeContent: Text("$notLength"),
          badgeColor: Colors.green,
          showBadge: notLength > 0 ? true : false,
          child: IconButton(
            icon: SvgPicture.asset('assets/ring.svg', width: 20.0),
            onPressed: () {
              setState(() {
                visibleNotifications=!visibleNotifications;
              });
            },
          ),
        ),
        const AppBarActionItems(),
      ],
    );
  }
}