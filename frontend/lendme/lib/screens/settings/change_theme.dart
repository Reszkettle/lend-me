import 'package:flutter/material.dart';
import 'package:lendme/components/background.dart';
import 'package:lendme/services/theme_service.dart';

class ChangeTheme extends StatelessWidget {
  const ChangeTheme({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('Change theme'), elevation: 0.0),
        body: Column(
          children: [
            const SizedBox(height: 35.0),
            Center(child: ColorFiltered(
              colorFilter: const ColorFilter.matrix(<double>[
                0.1, 0.7, 0.07, 0, 0,
                0.1, 0.7, 0.07, 0, 0,
                0.1, 0.7, 0.07, 0, 0,
                0,      0,      0,      1, 0,
              ]),
                child: Image.asset('assets/images/theme_moon.png',
                  height: 150,
                  width: 120,))
            ),
            Center(
              child: ElevatedButton(
                child: const Text(
                  'Dark Mode',
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: ThemeService().switchToDark,
              ),
            ),

            const SizedBox(height: 35.0),
            Center(
                    child: Image.asset('assets/images/theme_sun.png',
                  height: 150,
                    width: 140,),
                ),
            Center(
              child: ElevatedButton(
                child: const Text(
                  'Light Mode',
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: ThemeService().switchToLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
