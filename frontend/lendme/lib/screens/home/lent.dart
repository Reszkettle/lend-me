import 'package:flutter/material.dart';

class Lent extends StatefulWidget {
  const Lent({Key? key}) : super(key: key);

  @override
  _LentState createState() => _LentState();
}

class _LentState extends State<Lent> {
  @override
  Widget build(BuildContext context) {
    return Stack(
        children: const [
          Placeholder(),
          Center(child:
          Text(
              "Lent",
              style: TextStyle(fontSize: 40, color: Colors.grey, backgroundColor: Colors.white)
          )
          )
        ]
    );
  }
}
