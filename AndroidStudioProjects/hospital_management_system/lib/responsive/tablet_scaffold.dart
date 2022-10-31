import 'package:flutter/material.dart';
import 'package:hospital_management_system/constants.dart';
import 'package:hospital_management_system/util/my_box.dart';
import 'package:hospital_management_system/util/my_tile.dart';

class TabletScaffold extends StatefulWidget {
  const TabletScaffold({Key? key}) : super(key: key);

  @override
  State<TabletScaffold> createState() => _TabletScaffoldState();
}

class _TabletScaffoldState extends State<TabletScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: myDefaultBackground,
        appBar: myAppBar,
        drawer: myDrawer,
        body: Column(
          children: [
            // 4 box on the top
            AspectRatio(
              aspectRatio: 4,
              child: SizedBox(
                width: double.infinity,
                child: GridView.builder(
                    itemCount: 4,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
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
        ),
    );
  }
}
