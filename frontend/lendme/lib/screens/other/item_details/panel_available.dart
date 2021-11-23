import 'package:flutter/material.dart';
import 'package:lendme/models/item.dart';

class PanelAvailable extends StatelessWidget {
  const PanelAvailable({required this.item, Key? key}) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text("Status: Available",
            style: TextStyle(
              fontSize: 16,
            )
        )
      ],
    );
  }
}
