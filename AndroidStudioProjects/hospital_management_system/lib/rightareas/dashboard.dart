import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hospital_management_system/components/iconedListTile.dart';
import 'package:hospital_management_system/components/paymentListTile.dart';
import 'package:hospital_management_system/config/size_config.dart';
import 'package:hospital_management_system/data.dart';
import 'package:hospital_management_system/models/patientInvoiceItem.dart';
import 'package:hospital_management_system/providers/drawer_provider.dart';
import 'package:hospital_management_system/providers/patient_invoice_item_provider.dart';
import 'package:hospital_management_system/style/colors.dart';
import 'package:hospital_management_system/style/style.dart';
import 'package:provider/provider.dart';

class DashboardRightArea extends StatefulWidget {
  const DashboardRightArea({
    Key? key,
  }) : super(key: key);

  @override
  State<DashboardRightArea> createState() => _DashboardRightAreaState();
}

class _DashboardRightAreaState extends State<DashboardRightArea> {
  List<PatientInvoiceItem> tasks = [];

  @override
  Widget build(BuildContext context) {
    return
        Consumer<PatientInvoiceItemProvider>(builder: (_, state, __){
          tasks = state.state["patientInvoiceItems"];

          List<PatientInvoiceItem> done = tasks.where((element) => element.status == "Terminé").toList();
          List<PatientInvoiceItem> progress = tasks.where((element) => element.status == "En cours").toList();
          List<PatientInvoiceItem> pending = tasks.where((element) => element.status == "En attente").toList();

          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PrimaryText(
                    text: 'Soins terminés', size: 18, fontWeight: FontWeight.w800),
                TextButton(
                  onPressed: (){print("p");},
                  child: const PrimaryText(
                    text: 'Voir plus',
                    size: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondary,
                  ),
                )
              ],
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 2,
            ),
            Column(
              children: List.generate(
                min(done.length, 3),
                    (index) => IconedListTile(
                      department: jsonDecode('${done[index].service}')["Departement"] ?? '',
                      label: '${done[index].quantite!} ${jsonDecode("${done[index].service}")["Nom"]}' ?? '',
                      amount: jsonDecode('${done[index].service}')["Prix"] ?? '',
                      sublabel: done[index].receipt!.isNotEmpty ? "Payé(${done[index].receipt})" : "Non Payé",
                    ),
              ),
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 5,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PrimaryText(
                    text: 'Soins en cours', size: 18, fontWeight: FontWeight.w800),
                TextButton(
                  onPressed: (){print("p");},
                  child: const PrimaryText(
                    text: 'Voir plus',
                    size: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 2,
            ),
            Column(
              children: List.generate(
                min(progress.length, 3),
                    (index) => IconedListTile(
                      department: jsonDecode('${progress[index].service}')["Departement"] ?? '',
                      label: '${progress[index].quantite!} ${jsonDecode("${progress[index].service}")["Nom"]}' ?? '',
                      amount: jsonDecode('${progress[index].service}')["Prix"] ?? '',
                      sublabel: progress[index].receipt!.isNotEmpty ? "Payé(${progress[index].receipt})" : "Non Payé",
                    ),
              ),
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 5,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PrimaryText(
                    text: 'Soins en attente', size: 18, fontWeight: FontWeight.w800),
                TextButton(
                  onPressed: (){print("p");},
                  child: const PrimaryText(
                    text: 'Voir plus',
                    size: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 2,
            ),
            Column(
              children: List.generate(
                min(pending.length, 3),
                    (index) => IconedListTile(
                      department: jsonDecode('${pending[index].service}')["Departement"] ?? '',
                      label: '${pending[index].quantite!} ${jsonDecode("${pending[index].service}")["Nom"]}' ?? '',
                      amount: jsonDecode('${pending[index].service}')["Prix"] ?? '',
                      sublabel: pending[index].receipt!.isNotEmpty ? "Payé(${pending[index].receipt})" : "Non Payé",
                    ),
              ),
            ),
          ]);
        });

  }
}