import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lendme/repositories/user_repository.dart';
import 'package:lendme/screens/proxy.dart';
import 'package:lendme/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:lendme/services/theme_service.dart';
import 'package:lendme/utils/themes.dart';
import 'models/user.dart';


class LentMeApp extends StatefulWidget {
  const LentMeApp({Key? key}) : super(key: key);

  @override
  State<LentMeApp> createState() => _LentMeAppState();
}

class _LentMeAppState extends State<LentMeApp> {

  final AuthService _authService = AuthService();
  final UserRepository _userRepository = UserRepository();

  late Stream<String?> _uidStream;
  late Stream<User?> _userStream;


  @override
  void initState() {
    super.initState();
    _uidStream = _authService.uidStream;
    _userStream = _uidStream.switchMap((uid) {
      return uid != null ? _userRepository.getUserStream(uid) : Stream.value(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    // StreamProvider provides currently logged user to all widgets bellow
    return StreamProvider<User?>.value(
        value: _userStream,
        initialData: null,
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Lend Me',
          theme: Themes.light,
          darkTheme: Themes.dark,
          themeMode: ThemeService().theme,
          home: const Proxy(),
        )
    );
  }
}