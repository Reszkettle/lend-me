import 'package:flutter/material.dart';
import 'package:lendme/screens/auth/email.dart';

import 'authenticate.dart';

Map<String, WidgetBuilder> routes = {
  '/': (context) => const Authenticate(),
  '/email': (context) => const Email(),
};
