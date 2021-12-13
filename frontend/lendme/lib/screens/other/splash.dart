import 'package:flutter/material.dart';
import 'package:lendme/components/background.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Background(child: Scaffold(
      backgroundColor: Colors.transparent,
    ));
  }
}
