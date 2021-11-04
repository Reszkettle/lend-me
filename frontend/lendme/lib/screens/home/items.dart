import 'package:flutter/material.dart';

class Items extends StatefulWidget {
  const Items({Key? key}) : super(key: key);

  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  @override
  Widget build(BuildContext context) {
    return Stack(
        children: const [
          Placeholder(),
          Center(child:
            Text(
                "Items",
                style: TextStyle(fontSize: 40, color: Colors.grey, backgroundColor: Colors.white)
            )
          )
        ]
    );
  }
}