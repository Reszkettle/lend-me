import 'package:flutter/material.dart';
import 'package:lendme/services/theme_service.dart';

class ChangeTheme extends StatelessWidget {
  const ChangeTheme({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Change theme'), elevation: 0.0),
      body: Column(
        children: [
          const SizedBox(height: 15.0),
          Center(
            child: ElevatedButton(
              child: const Text(
                'Change Theme to Dark Mode',
              ),
              onPressed: ThemeService().switchToDark,
            ),
          ),
          Center(
            child: ElevatedButton(
              child: const Text(
                'Change Theme to Light Mode',
              ),
              onPressed: ThemeService().switchToLight,
            ),
          ),
        ],
      ),
    );
  }
}
