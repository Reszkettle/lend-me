import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Error'),
          elevation: 0.0
      ),
      body: Stack(
          children: const [
            Placeholder(),
            Center(child:
              Text(
                  "Error",
                  style: TextStyle(fontSize: 40, color: Colors.grey, backgroundColor: Colors.white)
              ),
            ),
          ],
      ),
    );
  }
}
