import 'package:flutter/material.dart';
import 'package:lendme/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return either Home or Authenticate widget
    return const Home();
  }
}
