import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hospital_management_system/config/size_config.dart';
import 'package:hospital_management_system/style/colors.dart';
import "package:yaml/yaml.dart";


class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Container(
        width: double.infinity,
        height: SizeConfig.screenHeight,
        decoration: const BoxDecoration(color: AppColors.white),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 100,
                alignment: Alignment.topCenter,
                width: double.infinity,
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: 100,
                  height: 60,
                  child: SvgPicture.asset('assets/hospicon.svg'),
                ),
              ),
              DropdownButtonHideUnderline(
                  child: DropdownButton(
                    focusColor: Colors.brown,
                    hint: const Text('Dashboard'),
                    items: [
                      DropdownMenuItem(

                          child: Row(
                            children: const [
                              Icon(Icons.home_outlined, color: Colors.grey),
                              SizedBox(width: 10),
                              Text('Accueil'),
                            ],
                          )
                      ),
                      const DropdownMenuItem(

                          child: Text('pooo')
                      )
                    ],
                    onChanged: (value) => {
                      print('a')
                    }
                  )
              ),
              Column(
                children: [
                  IconButton(
                      iconSize: 20,
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      icon: SvgPicture.asset(
                        'assets/home.svg',
                        color: AppColors.iconGray,
                      ),
                      onPressed: () {}),
                  const Text('Accueil')
                ],
              ),

              IconButton(
                  iconSize: 20,
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  icon: SvgPicture.asset(
                    'assets/pie-chart.svg',
                    color: AppColors.iconGray,
                  ),
                  onPressed: () {}),
              IconButton(
                  iconSize: 20,
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  icon: SvgPicture.asset(
                    'assets/clipboard.svg',
                    color: AppColors.iconGray,
                  ),
                  onPressed: () {}),
              IconButton(
                  iconSize: 20,
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  icon: SvgPicture.asset(
                    'assets/credit-card.svg',
                    color: AppColors.iconGray,
                  ),
                  onPressed: () {}),
              IconButton(
                  iconSize: 20,
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  icon: SvgPicture.asset(
                    'assets/trophy.svg',
                    color: AppColors.iconGray,
                  ),
                  onPressed: () {}),
              IconButton(
                  iconSize: 20,
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  icon: SvgPicture.asset(
                    'assets/invoice.svg',
                    color: AppColors.iconGray,
                  ),
                  onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}