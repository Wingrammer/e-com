import 'package:hospital_management_system/providers/consultation_provider.dart';
import 'package:hospital_management_system/providers/doctor_provider.dart';
import 'package:hospital_management_system/providers/income_provider.dart';
import 'package:hospital_management_system/providers/invoice_provider.dart';
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
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Init {

  // obtain shared preferences
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static Future initialize(context) async {
    await _registerServices(context);
    //await _loadSettings();
  }

  static _registerServices(context) async {
    //TODO register services
    print("starting registering services");

    await Provider.of<UserProvider>(context, listen: false).init();
    await Provider.of<DoctorProvider>(context, listen: false).init();
    await Provider.of<InvoiceProvider>(context, listen: false).init();
    await Provider.of<IncomeProvider>(context, listen: false).init();
    await Provider.of<OtherProvider>(context, listen: false).init();
    await Provider.of<OtherEntryProvider>(context, listen: false).init();
    await Provider.of<OtherOutingProvider>(context, listen: false).init();
    await Provider.of<ProductProvider>(context, listen: false).init();
    await Provider.of<ProductEntryProvider>(context, listen: false).init();
    await Provider.of<ProductOutingProvider>(context, listen: false).init();
    await Provider.of<ConsultationProvider>(context, listen: false).init(context);
    await Provider.of<TestProvider>(context, listen: false).init();
    await Provider.of<ServiceProvider>(context, listen: false).init();
    await Provider.of<PatientInvoiceItemProvider>(context, listen: false).init();

    print("finished registering services");
  }

  static _loadSettings() async {
    //TODO load settings
    print("starting loading settings");
    await Future.delayed(const Duration(seconds: 1));
    //await Future.doWhile(() => true);
    print("finished loading settings");
  }
}