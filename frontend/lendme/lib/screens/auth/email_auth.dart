import 'package:flutter/material.dart';
import 'package:lendme/screens/auth/email_sign_in.dart';
import 'package:lendme/screens/auth/email_sign_up.dart';

class EmailAuth extends StatelessWidget {
  const EmailAuth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Sign in with email'),
            bottom: const TabBar(
                tabs: [
                  Tab(
                    text: 'Sign in',
                  ),
                  Tab(
                    text: 'Sign up',
                  ),
                ],
            )
          ),
          body: const TabBarView(
            children: [
              EmailSignIn(),
              EmailSignUp()
            ],
          ),
        ),
    );
  }
}
