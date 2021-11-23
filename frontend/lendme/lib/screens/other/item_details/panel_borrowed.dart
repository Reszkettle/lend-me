import 'package:flutter/material.dart';

class PanelBorrowed extends StatelessWidget {
  const PanelBorrowed({required this.itemId, Key? key}) : super(key: key);

  final String itemId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text("Status: Borrowed",
            style: TextStyle(
              fontSize: 16,
            )
        )
      ],
    );
  }
}
