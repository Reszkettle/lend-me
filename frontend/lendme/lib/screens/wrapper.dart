import 'package:flutter/material.dart';
import 'package:lendme/models/user.dart';
import 'package:lendme/screens/authenticate/authenticate.dart';
import 'package:lendme/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserModel?>(context);
    print(user);

    if(user == null) {
      return const Authenticate();
    } else {
      return Home();
    }
  }
}
