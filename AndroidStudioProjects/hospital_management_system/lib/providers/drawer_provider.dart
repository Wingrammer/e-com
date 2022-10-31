import 'package:flutter/material.dart';
import 'package:hospital_management_system/pages/caisse.dart';
import 'package:hospital_management_system/pages/caisseDepenses.dart';
import 'package:hospital_management_system/pages/caisseRecettes.dart';
import 'package:hospital_management_system/pages/consultation.dart';
import 'package:hospital_management_system/pages/dashboard.dart';
import 'package:hospital_management_system/pages/hospitalisation.dart';
import 'package:hospital_management_system/pages/infirmary.dart';
import 'package:hospital_management_system/pages/laboratory.dart';
import 'package:hospital_management_system/pages/maternity.dart';
import 'package:hospital_management_system/pages/pharmacy.dart';
import 'package:hospital_management_system/pages/store.dart';
import 'package:hospital_management_system/pages/unknown_route.dart';
import 'package:hospital_management_system/rightareas/caisse.dart';
import 'package:hospital_management_system/rightareas/caisseDepenses.dart';
import 'package:hospital_management_system/rightareas/consultation.dart';
import 'package:hospital_management_system/rightareas/dashboard.dart';
import 'package:hospital_management_system/rightareas/hospitalisation.dart';
import 'package:hospital_management_system/rightareas/infirmary.dart';
import 'package:hospital_management_system/rightareas/laboratory.dart';
import 'package:hospital_management_system/rightareas/maternity.dart';
import 'package:hospital_management_system/rightareas/pharmacy.dart';
import 'package:hospital_management_system/rightareas/store.dart';

class DrawerNavigator with ChangeNotifier{
  String _currentRoute = 'Dashboard/';

  String get currentRoute => _currentRoute;

  void navigate(route) {
    _currentRoute = route;
    notifyListeners();
  }

  Widget getPage(){
    switch(_currentRoute) {
      case 'Dashboard/':
        return const Dashboard();
      case 'Caisse/':
        return const Caisse();
      case 'Caisse/Depenses':
        return const CaisseDepenses();
      case 'Caisse/Recettes':
        return const CaisseRecettes();
      /*case 'Caisse/Factures':
        return const Caisse();
      case 'Caisse/Magasin':
        return const Caisse();
      case 'Caisse/Clinique':
        return const Caisse();*/
      case 'Pharmacie/':
        return const Pharmacy();
      /*case 'Pharmacie/Entrees':
        return const Caisse();
      case 'Pharmacie/Sorties':
        return const Caisse();
      case 'Pharmacie/Pharmacie':
        return const Caisse();*/
      case 'Laboratoire/':
        return const Laboratory();
      case 'Hospitalisation/':
        return const Hospitalisation();
      case 'Maternité/':
        return const Maternity();
      case 'Infirmerie/':
        return const Infirmary();
      case 'Consultation/':
        return const ConsultationTab();
      case 'Magasin/':
        return const Store();

      default:
        return UnknownRoute(route: _currentRoute,);
    }
  }

  Widget getRightArea(){
    switch(_currentRoute) {
      case 'Dashboard/':
        return const DashboardRightArea();
      case 'Caisse/':
        return const CaisseRightArea();
      case 'Caisse/Depenses':
        return const CaisseDepenseRightArea();
    /*case 'Caisse/Recettes':
        return const CaisseRightArea();
      case 'Caisse/Factures':
        return const CaisseRightArea();
      case 'Caisse/Magasin':
        return const CaisseRightArea();
      case 'Caisse/Clinique':
        return const CaisseRightArea();*/
      case 'Pharmacie/':
        return const PharmacyRightArea();
    /*case 'Pharmacie/Entrees':
        return const CaisseRightArea();
      case 'Pharmacie/Sorties':
        return const CaisseRightArea();
      case 'Pharmacie/Pharmacie':
        return const CaisseRightArea();*/
      case 'Laboratoire/':
        return const LaboratoryRightArea();
      case 'Hospitalisation/':
        return const HospitalisationRightArea();
      case 'Maternité/':
        return const MaternityRightArea();
      case 'Infirmerie/':
        return const InfirmaryRightArea();
      case 'Consultation/':
        return const ConsultationRightArea();
      case 'Magasin/':
        return const StoreRightArea();

      default:
        return UnknownRoute(route: _currentRoute,);
    }
  }

}