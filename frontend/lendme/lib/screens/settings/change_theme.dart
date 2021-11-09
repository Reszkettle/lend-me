import 'package:flutter/material.dart';

class ChangeTheme extends StatelessWidget {
  const ChangeTheme({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Change theme'),
          elevation: 0.0
      ),
      body: Stack(
        children: const [
          Placeholder(),
          Center(child:
          Text(
              "Change theme",
              style: TextStyle(fontSize: 40, color: Colors.grey, backgroundColor: Colors.white)
          ),
          ),
        ],
      ),
    );
  }
}
