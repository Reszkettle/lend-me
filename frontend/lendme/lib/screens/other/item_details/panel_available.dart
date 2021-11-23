import 'package:flutter/material.dart';

class PanelAvailable extends StatelessWidget {
  const PanelAvailable({required this.itemId, Key? key}) : super(key: key);

  final String itemId;

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
