import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hospital_management_system/style/colors.dart';
import 'package:hospital_management_system/style/style.dart';

class IconedListTile extends StatelessWidget {
  final String department;
  final String label;
  final String sublabel;
  final String amount;

  const IconedListTile({
    Key? key, this.department='', this.label='', this.amount='', this.sublabel = ''
  }):super(key: key);

  IconData departmentIcon(){
    switch(department){
      case "Pharmacie":
        return Icons.local_pharmacy;
      case "Laboratoire":
        return Icons.biotech;
      case "Hospitalisation":
        return Icons.bed;
      case "Maternité":
        return Icons.pregnant_woman;
      case "Maternite":
        return Icons.pregnant_woman;
      case "Infirmerie":
        return Icons.health_and_safety;
      case "Consultation":
        return Icons.assessment;
    }
    return Icons.question_mark;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 0, right: 20),
      visualDensity: VisualDensity.standard,
      leading: Container(
          width: 50,
          padding: const EdgeInsets.symmetric(
              vertical: 15, horizontal: 10),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(departmentIcon()),
      ),
      title: PrimaryText(
          text: label,
          size: 14,
          fontWeight: FontWeight.w500),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PrimaryText(
            text: sublabel,
            size: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.secondary,
          ),
          PrimaryText(
              text: amount,
              size: 16,
              fontWeight: FontWeight.w600),
        ],
      ),
      onTap: () {

      },
      selected: true,
    );
  }
}