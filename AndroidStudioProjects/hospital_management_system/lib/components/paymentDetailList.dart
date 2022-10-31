import 'package:flutter/material.dart';
import 'package:hospital_management_system/components/paymentListTile.dart';
import 'package:hospital_management_system/config/size_config.dart';
import 'package:hospital_management_system/data.dart';
import 'package:hospital_management_system/providers/drawer_provider.dart';
import 'package:hospital_management_system/style/colors.dart';
import 'package:hospital_management_system/style/style.dart';
import 'package:provider/provider.dart';

class PaymentDetailList extends StatelessWidget {
  const PaymentDetailList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DrawerNavigator>(
        builder: (context, drawerNavigator, _) => drawerNavigator.currentRoute=='Dashboard/'?
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: SizeConfig.blockSizeVertical * 5,
          ),
          Container(
            decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(30), boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 15.0,
                offset: Offset(
                  10.0,
                  15.0,
                ),
              )
            ]),
            child: Image.asset('assets/card.png'),
          ),
          SizedBox(
            height: SizeConfig.blockSizeVertical * 5,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              PrimaryText(
                  text: 'Recent Activities', size: 18, fontWeight: FontWeight.w800),
              PrimaryText(
                text: '02 Mar 2021',
                size: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.secondary,
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.blockSizeVertical * 2,
          ),
          Column(
            children: List.generate(
              recentActivities.length,
                  (index) => PaymentListTile(
                  icon: recentActivities[index]["icon"] ?? '',
                  label: recentActivities[index]["label"] ?? '',
                  amount: recentActivities[index]["amount"] ?? ''
              ),
            ),
          ),
          SizedBox(
            height: SizeConfig.blockSizeVertical * 5,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              PrimaryText(
                  text: 'Upcoming Payments', size: 18, fontWeight: FontWeight.w800),
              PrimaryText(
                text: '02 Mar 2021',
                size: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.secondary,
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.blockSizeVertical * 2,
          ),
          Column(
            children: List.generate(
              upcomingPayments.length,
                  (index) => PaymentListTile(
                  icon: upcomingPayments[index]["icon"] ?? '',
                  label: upcomingPayments[index]["label"] ?? '',
                  amount: upcomingPayments[index]["amount"] ?? ''
              ),
            ),
          ),
        ]):
        const SizedBox(width: 0,)
    );

  }
}