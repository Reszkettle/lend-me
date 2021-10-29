import 'package:flutter/material.dart';
import 'package:lendme/components/base_tile.dart';

class Borrowed extends StatefulWidget {
  const Borrowed({Key? key}) : super(key: key);

  @override
  _BorrowedState createState() => _BorrowedState();
}

class _BorrowedState extends State<Borrowed> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Center(
          child: ListView.separated(
        padding: const EdgeInsets.all(9),
        itemCount: 15,
        itemBuilder: (context, index) {
          return const BaseTile(
              title: "Whatever",
              subtitle: "However",
              thirdLine: "Whenever",
              imageUrl:
                  "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg");
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 9);
        },
      ))
    ]);
  }
}
