import 'package:flutter/material.dart';
import 'package:hospital_management_system/components/notificationTile.dart';
import 'package:hospital_management_system/config/responsive.dart';
import 'package:hospital_management_system/providers/notification_provider.dart';
import 'package:provider/provider.dart';

class Notifications extends StatefulWidget {
  final bool visible;
  const Notifications({Key? key, this.visible=false}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  @override
  Widget build(BuildContext context) {
    return /*ChangeNotifierProvider<NotificationProvider>(
      create: (_) => NotificationProvider(),
      child:*/ Consumer<NotificationProvider>(builder: (_, state, __){
        List<Map<String, dynamic>> notifications = state.state["notifications"];
        print(state.state);
        return !widget.visible?
        const SizedBox(width: 0,):
        !Responsive.isDesktop(context)?
        Positioned.fill(
          right: 0,
          top: Responsive.isDesktop(context) ? 75:0,
          child: Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: ListView.separated(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return NotificationTiles(
                    title: '${notifications[index]["title"]}',
                    subtitle: '${notifications[index]["title"]}'
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            ),
          ),
        ):
        Positioned(
          right: 0,
          top: Responsive.isDesktop(context) ? 75:0,
          width: 350,
          height: 350,
          child: Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: ListView.separated(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return NotificationTiles(
                    title: '${notifications[index]["title"]}',
                    subtitle: '${notifications[index]["subtitle"]}'
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            ),
          ),

        );
      });
    //);
  }
}
/*
!widget.visible?
const SizedBox(width: 0,):
!Responsive.isDesktop(context)?
Positioned.fill(
right: 0,
top: Responsive.isDesktop(context) ? 75:0,
child: Container(
decoration: const BoxDecoration(color: Colors.white),
child: ListView.separated(
physics: const ClampingScrollPhysics(),
padding: EdgeInsets.zero,
itemCount: notifications.length,
itemBuilder: (context, index) {
return NotificationTiles(
title: '${notifications[index]["title"]}',
subtitle: '${notifications[index]["title"]}'
);
},
separatorBuilder: (context, index) {
return const Divider();
},
),
),
):
Positioned(
right: 0,
top: Responsive.isDesktop(context) ? 75:0,
width: 350,
height: 350,
child: Container(
decoration: const BoxDecoration(color: Colors.white),
child: ListView.separated(
physics: const ClampingScrollPhysics(),
padding: EdgeInsets.zero,
itemCount: notifications.length,
itemBuilder: (context, index) {
return NotificationTiles(
title: '${notifications[index]["title"]}',
subtitle: '${notifications[index]["title"]}'
);
},
separatorBuilder: (context, index) {
return const Divider();
},
),
),

)*/