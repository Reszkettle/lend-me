import 'package:flutter/material.dart';
import 'package:lendme/components/loadable_area.dart';
import 'package:lendme/exceptions/exceptions.dart';
import 'package:lendme/services/auth_service.dart';

class EmailSignUp extends StatefulWidget {
  const EmailSignUp({Key? key}) : super(key: key);

  @override
  _EmailSignUpState createState() => _EmailSignUpState();
}

class _EmailSignUpState extends State<EmailSignUp> {
  final AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();
  final _loadableAreaController = LoadableAreaController();

  String email = '';
  String password = '';
  String repeatedPassword = '';

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
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email)),
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
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.password)),
                  validator: (val) => val!.length < 6 ? 'Enter a password min 6 characters long' : null,
                  onChanged: (val) {
                    password = val;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                      labelText: 'Repeated password',
                      prefixIcon: Icon(Icons.password)),
                  validator: (val) => val != password ? "Passwords are not the same" : null,
                  onChanged: (val) {
                    repeatedPassword = val;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  child: const Text("Sign up"),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        _loadableAreaController.setState(LoadableAreaState.pending);
                        await Future.delayed(const Duration(seconds: 1));
                        await _auth.registerWithEmailAndPassword(email, password);
                      } on DomainException catch(e) {
                        _loadableAreaController.setState(LoadableAreaState.main);
                        _showErrorSnackBar(context, e.message);
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

  void _showErrorSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(text),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
