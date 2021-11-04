import 'package:flutter/material.dart';
import 'package:lendme/screens/auth/auth_main.dart';
import 'package:lendme/screens/auth/email_auth.dart';

Route? authRoutes(settings) {
  if(settings.name == '/') {
    return MaterialPageRoute(builder: (context) {return const AuthMain();});
  }
  if(settings.name == '/email') {
    return MaterialPageRoute(builder: (context) {return const EmailAuth();});
  }
}
