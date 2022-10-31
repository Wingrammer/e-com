import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hospital_management_system/components/barChart.dart';
import 'package:hospital_management_system/components/chart.dart';
import 'package:hospital_management_system/components/header.dart';
import 'package:hospital_management_system/components/historyTable.dart';
import 'package:hospital_management_system/components/infoCard.dart';
import 'package:hospital_management_system/components/paymentDetailList.dart';
import 'package:hospital_management_system/config/responsive.dart';
import 'package:hospital_management_system/config/size_config.dart';
import 'package:hospital_management_system/models/consultation.dart';
import 'package:hospital_management_system/models/user.dart';
import 'package:hospital_management_system/providers/consultation_provider.dart';
import 'package:hospital_management_system/providers/drawer_provider.dart';
import 'package:hospital_management_system/providers/user_provider.dart';
import 'package:hospital_management_system/style/colors.dart';
import 'package:hospital_management_system/style/style.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  List<Consultation> consultations = [];
  List<User> users = [];

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    setState(() {
      users = Provider.of<UserProvider>(context, listen: false).state["users"];
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConsultationProvider>(builder: (_, state, __){

      consultations = state.state["consultations"];

      return Expanded(
          flex: 10,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Header(),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 4,
                  ),
                  SizedBox(
                    width: SizeConfig.screenWidth,
                    child: Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      alignment: WrapAlignment.spaceBetween,
                      children: [
                        InfoCard(
                            icon: 'assets/stethoscope-doctor-svgrepo-com.svg',
                            label: 'Consultations',
                            amount: '${consultations.length}'),
                        InfoCard(
                            icon: 'assets/pie-chart-finances-svgrepo-com.svg',
                            label: 'En attente',
                            amount: '${consultations.where((element) => element.programmed==true).toList().length}'),
                        InfoCard(
                            icon: 'assets/health-doctor-medical-medicine-box-box-svgrepo-com.svg',
                            label: 'Urgences',
                            amount: '${consultations.where((element) => element.urgence==true).toList().length}'),
                        InfoCard(
                            icon: 'assets/calendar-doctor-health-svgrepo-com.svg',
                            label: 'Aujourd\'hui',
                            amount: '${consultations.where((element) => element.isToday).toList().length}'),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const PrimaryText(
                            text: 'Patients',
                            size: 16,
                            fontWeight: FontWeight.w400,
                            color: AppColors.secondary,
                          ),
                          PrimaryText(
                              text: '${users.length}',
                              size: 30,
                              fontWeight: FontWeight.w800),
                        ],
                      ),
                      const PrimaryText(
                        text: '30 Derniers Jours',
                        size: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.secondary,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 3,
                  ),
                  Container(
                    height: 180,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: MyLineChart(consultations: consultations,)
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      PrimaryText(
                          text: 'Historique',
                          size: 30,
                          fontWeight: FontWeight.w800),
                      PrimaryText(
                        text: '3 dernières recettes',
                        size: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.secondary,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 3,
                  ),
                  HistoryTable(),
                  if (!Responsive.isDesktop(context)) Consumer<DrawerNavigator>(
                    builder: (context, drawerNavigator, _) => drawerNavigator.getRightArea(),
                  ),
                ],
              ),
            ),
          )
      );
    });
  }
}