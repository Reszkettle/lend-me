import 'package:flutter/material.dart';


class Background extends StatelessWidget {
  const Background({required this.child,  Key? key}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Theme.of(context).canvasColor, BlendMode.darken),
            )
        ),
        child: child,
      );
  }
}
