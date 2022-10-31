import 'package:flutter/material.dart';
import 'package:hospital_management_system/constants.dart';
import 'package:hospital_management_system/util/my_box.dart';
import 'package:hospital_management_system/util/my_tile.dart';

class MobileScaffold extends StatefulWidget {
  const MobileScaffold({Key? key}) : super(key: key);

  @override
  State<MobileScaffold> createState() => _MobileScaffoldState();
}

class _MobileScaffoldState extends State<MobileScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar,
      backgroundColor: myDefaultBackground,
      drawer: myDrawer,
      body: Column(
        children: [
          // 4 box on the top
          AspectRatio(
            aspectRatio: 1,
            child: SizedBox(
              width: double.infinity,
              child: GridView.builder(
                  itemCount: 4,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    return const MyBox();
                  }
              ),
            ),
          ),

          // 4 tiles below
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index){
                return const MyTile();
              },
            )
          )
        ],
      )
    );
  }
}
