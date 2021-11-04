import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lendme/repositories/user_repository.dart';
import 'package:lendme/screens/proxy.dart';
import 'package:lendme/services/auth_service.dart';
import 'package:lendme/services/emulators_service.dart';
import 'package:provider/provider.dart';
import 'package:stream_transform/stream_transform.dart';

import 'exceptions/exceptions.dart';
import 'models/resource.dart';
import 'models/user.dart';

const useEmulators = true;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (useEmulators) {
    await EmulatorsService().setupEmulators();
  }

  runApp(LentMeApp());
}

class LentMeApp extends StatelessWidget {
  LentMeApp({Key? key}) : super(key: key);

  // Stream of currently logged user
  final Stream<Resource<User>> userStream = AuthService().uid.switchMap((uid) {
      return uid != null ? UserRepository().getUserStream(uid) :
      Stream.value(Resource.error(ResourceNotFoundException()));
    });

  @override
  Widget build(BuildContext context) {
    // StreamProvided provides currently logged user to all widgets bellow
    return StreamProvider<Resource<User>>.value(
      value: userStream,
      initialData: Resource.loading(),
      child: MaterialApp(
        title: 'Lend Me',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: Proxy(),
      )
    );
  }

}