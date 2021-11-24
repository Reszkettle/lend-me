import 'package:flutter/material.dart';
import 'package:lendme/models/item.dart';

class LentQr extends StatelessWidget {
  const LentQr({required this.item, Key? key}) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Lent item: ' + item.title),
          elevation: 0.0
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Text("QR code for item ${item.id}"),
      ),
    );
  }
}
