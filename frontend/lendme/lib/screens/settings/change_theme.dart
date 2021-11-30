import 'package:flutter/material.dart';
import 'package:lendme/services/theme_service.dart';
import 'package:get/get.dart';

class ChangeTheme extends StatelessWidget {
  const ChangeTheme({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Change theme'), elevation: 0.0),
      body: Center(
        child: ElevatedButton(
          child: const Text(
            'Change Theme',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: ThemeService().switchTheme,
        ),
      ),
    );
  }
}
