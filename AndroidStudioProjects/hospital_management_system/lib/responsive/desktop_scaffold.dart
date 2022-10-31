import 'package:flutter/material.dart';
import 'package:hospital_management_system/constants.dart';
import 'package:hospital_management_system/util/my_box.dart';
import 'package:hospital_management_system/util/my_tile.dart';

class DesktopScaffold extends StatefulWidget {
  const DesktopScaffold({Key? key}) : super(key: key);

  @override
  State<DesktopScaffold> createState() => _DesktopScaffoldState();
}

class _DesktopScaffoldState extends State<DesktopScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myDefaultBackground,
      appBar: myAppBar,
      body: Row(children: [
        // open drawer
        myDrawer,

        // rest of body
        Expanded(
            flex: 2,
            child: Column(
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
            )
        ),
        Expanded(
          child: Column(
            children: [
              Expanded(child: Container(color: Colors.pink))
            ],
          ),
        )
      ],),
    );
  }
}
