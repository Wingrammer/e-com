import 'package:flutter/material.dart';

class UnknownRoute extends StatelessWidget {
  const UnknownRoute({Key? key, this.route=''}) : super(key: key);
  final String route;
  @override
  Widget build(BuildContext context) {

    return Center(child: Text(route, textAlign: TextAlign.center,));
  }
}
