
import 'package:flutter/material.dart';
import 'package:hospital_management_system/auth.dart';
import 'package:hospital_management_system/entry.dart';
import 'package:hospital_management_system/init.dart';
import 'package:hospital_management_system/providers/auth_provider.dart';
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
import 'package:hospital_management_system/splash.dart';
import 'package:hospital_management_system/style/colors.dart';
import 'package:provider/provider.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider<DrawerNavigator>(create: (_) => DrawerNavigator()),
      ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
      ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
      ChangeNotifierProvider<InvoiceProvider>(create: (_) => InvoiceProvider()),
      ChangeNotifierProvider<TestProvider>(create: (_) => TestProvider()),
      ChangeNotifierProvider<ServiceProvider>(create: (_) => ServiceProvider()),
      ChangeNotifierProvider<ProductProvider>(create: (_) => ProductProvider()),
      ChangeNotifierProvider<OtherProvider>(create: (_) => OtherProvider()),
      ChangeNotifierProvider<ProductEntryProvider>(create: (_) => ProductEntryProvider()),
      ChangeNotifierProvider<ProductOutingProvider>(create: (_) => ProductOutingProvider()),
      ChangeNotifierProvider<OtherOutingProvider>(create: (_) => OtherOutingProvider()),
      ChangeNotifierProvider<OtherEntryProvider>(create: (_) => OtherEntryProvider()),
      ChangeNotifierProvider<PatientInvoiceItemProvider>(create: (_) => PatientInvoiceItemProvider()),
      ChangeNotifierProvider<IncomeProvider>(create: (_) => IncomeProvider()),
      ChangeNotifierProvider<ConsultationProvider>(create: (_) => ConsultationProvider()),
      ChangeNotifierProvider<DoctorProvider>(create: (_) => DoctorProvider()),
      ChangeNotifierProvider<NotificationProvider>(create: (_) => NotificationProvider()),
    ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context){

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hospital Management System',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: AppColors.primaryBg
      ),
      home: Consumer<AuthProvider>(builder: (context, auth, child){
        if(!auth.isSignedIn){
          return const AuthScreen();
        } else {
          return FutureBuilder(

            future: Init.initialize(context),
            builder: (context, snapshot){
              if(snapshot.connectionState==ConnectionState.done){
                return const Entry();
              } else {
                return const SplashScreen();
              }
            },
          );
        }
      })
      );
  }
}