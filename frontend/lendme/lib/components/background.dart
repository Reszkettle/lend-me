import 'package:flutter/material.dart';


class Background extends StatelessWidget {
  const Background({required this.child,  Key? key}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
            )
        ),
        child: child,
      );
  }
}
