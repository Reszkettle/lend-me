import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Stack(
        children: const [
          Placeholder(),
          Center(child:
          Text(
              "Notifications",
              style: TextStyle(fontSize: 40, color: Colors.grey, backgroundColor: Colors.white)
          )
          )
        ]
    );
  }
}
