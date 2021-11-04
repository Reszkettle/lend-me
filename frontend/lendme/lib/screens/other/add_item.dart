import 'package:flutter/material.dart';

class AddItem extends StatelessWidget {
  const AddItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Add item'),
          elevation: 0.0
      ),
      body: Stack(
          children: const [
            Placeholder(),
            Center(child:
              Text(
                  "Add item",
                  style: TextStyle(fontSize: 40, color: Colors.grey, backgroundColor: Colors.white)
              ),
            ),
          ],
      ),
    );
  }
}
