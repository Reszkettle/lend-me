import 'package:flutter/material.dart';

class Borrowed extends StatefulWidget {
  const Borrowed({Key? key}) : super(key: key);

  @override
  _BorrowedState createState() => _BorrowedState();
}

class _BorrowedState extends State<Borrowed> {
  @override
  Widget build(BuildContext context) {
    return Stack(
        children: const [
          Placeholder(),
          Center(child:
          Text(
              "Borrowed",
              style: TextStyle(fontSize: 40, color: Colors.grey, backgroundColor: Colors.white)
          )
          )
        ]
    );
  }
}
