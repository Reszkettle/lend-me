import 'package:flutter/material.dart';

class Credits extends StatelessWidget {
  const Credits({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Credits'),
          elevation: 0.0
      ),
      body: Stack(
          children: const [
            Placeholder(),
            Center(child:
              Text(
                  "Credits",
                  style: TextStyle(fontSize: 40, color: Colors.grey, backgroundColor: Colors.white)
              ),
            ),
          ],
      ),
    );
  }
}
