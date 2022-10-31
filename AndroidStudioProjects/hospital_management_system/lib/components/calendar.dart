import 'package:flutter/material.dart';
import 'package:hospital_management_system/config/responsive.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  bool _visible = false;
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';

  void changeVisibleState(bool newState){
    setState(() {
      _visible = newState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return !_visible?
    const SizedBox(width: 0,):
    !Responsive.isDesktop(context)?
    Positioned.fill(
      right: 0,
      top: Responsive.isDesktop(context) ? 75:0,
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: SfDateRangePicker(),
      ),
    ):
    Positioned(
      right: 0,
      top: Responsive.isDesktop(context) ? 75:0,
      width: 350,
      height: 350,
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: SfDateRangePicker(),
      ),
    );
  }
}

