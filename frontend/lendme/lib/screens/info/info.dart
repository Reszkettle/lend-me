import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  const Info({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Info'),
          elevation: 0.0
      ),
      body: Stack(
          children: const [
            Placeholder(),
            Center(child:
              Text(
                  "Info",
                  style: TextStyle(fontSize: 40, color: Colors.grey, backgroundColor: Colors.white)
              ),
            ),
          ],
      ),
    );
  }
}
