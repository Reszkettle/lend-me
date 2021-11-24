import 'package:flutter/material.dart';
import 'package:lendme/models/item.dart';

class History extends StatelessWidget {
  const History({required this.item, Key? key}) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Item history'),
          elevation: 0.0
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Text("History of item ${item.id}"),
      ),
    );
  }
}
