import 'package:flutter/material.dart';
import 'package:lendme/components/loadable_area.dart';
import 'package:lendme/exceptions/exceptions.dart';
import 'package:lendme/services/auth_service.dart';
import 'package:lendme/utils/error_snackbar.dart';

class EmailSignIn extends StatefulWidget {
  const EmailSignIn({Key? key}) : super(key: key);

  @override
  _EmailSignInState createState() => _EmailSignInState();
}

class _EmailSignInState extends State<EmailSignIn> {

  final AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();
  final _loadableAreaController = LoadableAreaController();

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return LoadableArea(
      controller: _loadableAreaController,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20.0),
                TextFormField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email)
                  ),
                  validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                  onChanged: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Passowrd',
                      prefixIcon: Icon(Icons.password)
                  ),
                  validator: (val) => val!.length < 6 ? 'Enter a password min 6 characters long' : null,
                  onChanged: (val) {
                    password = val;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    child: const Text("Sign in"),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          _loadableAreaController.setState(LoadableAreaState.pending);
                          await Future.delayed(const Duration(seconds: 1));
                          await _auth.signInWithEmailAndPassword(email, password);
                        } on DomainException catch(e) {
                          _loadableAreaController.setState(LoadableAreaState.main);
                          showErrorSnackBar(context, e.message);
                        }
                      }
                    },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
