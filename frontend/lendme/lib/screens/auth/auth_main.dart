import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:lendme/exceptions/exception.dart';
import 'package:lendme/services/auth.dart';
import 'package:lendme/utils/ui/error_snackbar.dart';

class AuthMain extends StatefulWidget {
  const AuthMain({Key? key}) : super(key: key);

  @override
  _AuthMainState createState() => _AuthMainState();
}

class _AuthMainState extends State<AuthMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(elevation: 0.0, title: const Text('Sign in to Lend Me')),
        body: OrientationBuilder(builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return buildPortraitLayout();
          } else {
            return buildLandscapeLayout();
          }
        }));
  }

  Row buildLandscapeLayout() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Expanded(
          child: Logo(),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: AuthButtons(),
          ),
        ),
      ],
    );
  }

  Column buildPortraitLayout() {
    return Column(
      children: [
        const SizedBox(height: 30),
        const Logo(),
        Expanded(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: AuthButtons(),
        ))
      ],
    );
  }
}

class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Image(
          image: AssetImage("assets/images/logo.png"),
          height: 200,
        ),
        SizedBox(height: 10),
        Text("Lend Me",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class AuthButtons extends StatelessWidget {
  AuthButtons({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        emailButton(context),
        const SizedBox(height: 10),
        facebookButton(context),
        const SizedBox(height: 10),
        googleButton(context),
      ],
    );
  }

  SizedBox emailButton(BuildContext context) {
    return SizedBox(
      height: 50,
      child: SignInButton(
        Buttons.Email,
        elevation: 0,
        onPressed: () async {
          Navigator.of(context).pushNamed('/email');
        },
      ),
    );
  }

  SizedBox facebookButton(BuildContext context) {
    return SizedBox(
      height: 50,
      child: SignInButton(
        Buttons.Facebook,
        elevation: 0,
        onPressed: () async {
          try {
            await _auth.signInWithFacebook();
          } on DomainException catch(e) {
            showErrorSnackBar(context, e.message);
          }
        },
      ),
    );
  }

  SizedBox googleButton(BuildContext context) {
    return SizedBox(
      height: 50,
      child: SignInButton(
        Buttons.Google,
        elevation: 0,
        onPressed: () async {
          try {
            await _auth.signInWithGoogle();
          } on DomainException catch(e) {
            showErrorSnackBar(context, e.message);
          }
        },
      ),
    );
  }
}
