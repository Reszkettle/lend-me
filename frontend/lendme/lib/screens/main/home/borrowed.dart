import 'package:flutter/material.dart';

class Borrowed extends StatefulWidget {
  const Borrowed({Key? key}) : super(key: key);

  @override
  _BorrowedState createState() => _BorrowedState();
}

class _BorrowedState extends State<Borrowed> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Borrowed"),
    );
  }
}
