import 'package:flutter/material.dart';

class History extends StatelessWidget {
  const History({required this.itemId, Key? key}) : super(key: key);

  final String itemId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Item history'),
          elevation: 0.0
      ),
      body: Container(),
    );
  }
}
