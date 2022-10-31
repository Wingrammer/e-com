import 'package:flutter/material.dart';
import 'package:hospital_management_system/config/responsive.dart';
import 'package:hospital_management_system/providers/drawer_provider.dart';
import 'package:hospital_management_system/style/colors.dart';
import 'package:hospital_management_system/style/style.dart';
import 'package:provider/provider.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            child: Responsive.isDesktop(context)?
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  PrimaryText(
                      text: Provider.of<DrawerNavigator>(context, listen: false).currentRoute.split('/')[0],
                      size: 30,
                      fontWeight: FontWeight.w800
                  ),
                  PrimaryText(
                    text: Provider.of<DrawerNavigator>(context, listen: false).currentRoute.split('/').length != 1 ? Provider.of<DrawerNavigator>(context, listen: false).currentRoute.split('/')[1] : '',
                    size: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondary,
                  )
                ]
            ):const SizedBox(width: 0, height: 0,),
          ),
          const Spacer(
            flex: 1,
          ),
        ]);
  }
}