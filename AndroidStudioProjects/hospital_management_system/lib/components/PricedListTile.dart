import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hospital_management_system/style/colors.dart';
import 'package:hospital_management_system/style/style.dart';

class PricedListTile extends StatelessWidget {
  final String quantity;
  final String label;
  final String spec;
  final String amount;

  const PricedListTile({
    Key? key, this.quantity='', this.label='', this.amount='', this.spec=''
  }):super(key: key);

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
          child: Text(quantity, textAlign: TextAlign.center,)
      ),
      title: PrimaryText(
          text: label,
          size: 14,
          fontWeight: FontWeight.w500),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PrimaryText(
            text: spec,
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