import 'package:flutter/material.dart';
import 'package:lendme/exceptions/exception.dart';
import 'package:lendme/services/auth.dart';
import 'package:lendme/utils/ui/error_snackbar.dart';

class EmailSignIn extends StatefulWidget {
  const EmailSignIn({Key? key}) : super(key: key);

  @override
  _EmailSignInState createState() => _EmailSignInState();
}

class _EmailSignInState extends State<EmailSignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                    hintText: 'Email',
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
                    hintText: 'Password',
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
                        await _auth.signInWithEmailAndPassword(email, password);
                      } on DomainException catch(e) {
                        showErrorSnackBar(context, e.message);
                      }
                    }
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
