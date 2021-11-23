import 'package:flutter/material.dart';

class PanelLent extends StatelessWidget {
  const PanelLent({required this.itemId, Key? key}) : super(key: key);

  final String itemId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text("Status: Lent",
            style: TextStyle(
              fontSize: 16,
            )
        )
      ],
    );
  }
}
