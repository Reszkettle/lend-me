import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lendme/exceptions/general.dart';
import 'package:lendme/repositories/user_repository.dart';
import 'package:lendme/screens/proxy.dart';
import 'package:lendme/services/auth.dart';
import 'package:lendme/services/emulators.dart';
import 'package:provider/provider.dart';
import 'package:stream_transform/stream_transform.dart';

import 'models/resource.dart';
import 'models/user.dart';

const useEmulators = true;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (useEmulators) {
    await EmulatorsService().setupEmulators();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return StreamProvider<Resource<User?>>.value(
      value: getUserStream(),
      initialData: Resource.loading(),
      child: MaterialApp(
        title: 'Lend Me',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const Proxy(),
      )
    );
  }

  Stream<Resource<User>> getUserStream() {
    return AuthService().uid.switchMap((uid) {
      if(uid != null) {
        return UserRepository().getUserStream(uid);
      }
      else {
        return Stream.value(Resource.error(UserNotAuthenticatedException()));
      }
    });
  }
}

