import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hospital_management_system/config/responsive.dart';
import 'package:hospital_management_system/config/size_config.dart';
import 'package:hospital_management_system/data.dart';
import 'package:hospital_management_system/models/income.dart';
import 'package:hospital_management_system/providers/income_provider.dart';
import 'package:hospital_management_system/style/colors.dart';
import 'package:hospital_management_system/style/style.dart';
import 'package:provider/provider.dart';

class HistoryTable extends StatelessWidget {
  HistoryTable({
    Key? key,
  }) : super(key: key);

  List<Income> incomes = [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Responsive.isDesktop(context) ? Axis.vertical : Axis.horizontal,
      child: SizedBox(
        width: Responsive.isDesktop(context) ? double.infinity : SizeConfig.screenWidth,
        child: Consumer<IncomeProvider>(builder: (_, state, __){
          incomes = state.state["incomes"];
          incomes.sort((a, b) => DateTime.parse(b.date!.split('/').reversed.join('-')).compareTo(DateTime.parse(a.date!.split('/').reversed.join('-'))));
          return Table(
            defaultVerticalAlignment:
            TableCellVerticalAlignment.middle,
            children: List.generate(
              min(3, incomes.length), (index) => TableRow(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 20.0),
                    child: const CircleAvatar(
                      radius: 17,
                      backgroundImage: NetworkImage('https://png.pngtree.com/element_our/20190529/ourmid/pngtree-user-icon-image_1187018.jpg' ?? 'https://png.pngtree.com/element_our/20190529/ourmid/pngtree-user-icon-image_1187018.jpg'),
                    ),
                  ),
                  PrimaryText(
                    text: jsonDecode('${incomes[index].patient}')["displayName"] ?? '',
                    size: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondary,
                  ),
                  PrimaryText(
                    text: incomes[index].date ?? '',
                    size: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondary,
                  ),
                  PrimaryText(
                    text: incomes[index].total ?? '',
                    size: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondary,
                  ),
                  PrimaryText(
                    text: incomes[index].fid ?? '',
                    size: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondary,
                  ),
                ],
              ),
            ),
          );
        })
      ),
    );
  }
}