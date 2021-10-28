import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
