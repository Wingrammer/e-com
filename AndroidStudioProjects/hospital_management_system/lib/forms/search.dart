import 'package:flutter/material.dart';
import 'package:hospital_management_system/config/responsive.dart';
import 'package:hospital_management_system/style/colors.dart';

class SearchInput extends StatefulWidget {
  final List searchList;
  final VoidCallback onChange;
  const SearchInput({Key? key, required this.searchList, required this.onChange}) : super(key: key);

  @override
  State<SearchInput> createState() => SearchInputState();
}

class SearchInputState extends State<SearchInput> {

  List result = [];
  final inputController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      result = widget.searchList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: Responsive.isDesktop(context) ? 1 : 50,
      child: TextField(
        controller: inputController,
        onChanged: (s){
          widget.onChange();
        },
        decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.white,
            contentPadding:
            const EdgeInsets.only(left: 40.0, right: 5),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: AppColors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: AppColors.white),
            ),
            prefixIcon: const Icon(Icons.search, color: AppColors.black),
            hintText: 'Recherche',
            hintStyle: const TextStyle(color: AppColors.secondary, fontSize: 14)
        ),
      ),
    );
  }
}
