import 'package:flutter/material.dart';


class NotificationTiles extends StatelessWidget {
  final String title, subtitle;
  const NotificationTiles({
    Key? key, this.title='', this.subtitle=''
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(

      title: Text(title, style: const TextStyle(color: Colors.grey)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey),),
      onTap: () => print('ok'),
      enabled: true,
    );
  }
}