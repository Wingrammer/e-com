import 'package:flutter/material.dart';
import 'package:hospital_management_system/config/responsive.dart';
import 'package:hospital_management_system/config/size_config.dart';
import 'package:hospital_management_system/data.dart';
import 'package:hospital_management_system/style/colors.dart';
import 'package:hospital_management_system/style/style.dart';

class HistoryTable extends StatelessWidget {
  const HistoryTable({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Responsive.isDesktop(context) ? Axis.vertical : Axis.horizontal,
      child: SizedBox(
        width: Responsive.isDesktop(context) ? double.infinity : SizeConfig.screenWidth,
        child: Table(
          defaultVerticalAlignment:
          TableCellVerticalAlignment.middle,
          children: List.generate(
            transactionHistory.length,
                (index) => TableRow(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 20.0),
                  child: CircleAvatar(
                    radius: 17,
                    backgroundImage: NetworkImage(transactionHistory[index]["avatar"] ?? ''),
                  ),
                ),
                PrimaryText(
                  text: transactionHistory[index]["label"] ?? '',
                  size: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondary,
                ),
                PrimaryText(
                  text: transactionHistory[index]["time"] ?? '',
                  size: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondary,
                ),
                PrimaryText(
                  text: transactionHistory[index]["amount"] ?? '',
                  size: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondary,
                ),
                PrimaryText(
                  text: transactionHistory[index]["status"] ?? '',
                  size: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}