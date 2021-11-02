import 'package:flutter/material.dart';
import 'package:lendme/exceptions/exception.dart';
import 'package:lendme/services/auth.dart';

class EmailSignUp extends StatefulWidget {
  const EmailSignUp({Key? key}) : super(key: key);

  @override
  _EmailSignUpState createState() => _EmailSignUpState();
}

class _EmailSignUpState extends State<EmailSignUp> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String repeatedPassword = '';

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
                    border: OutlineInputBorder(),
                    hintText: 'Password',
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
                    border: OutlineInputBorder(),
                    hintText: 'Repeated password',
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
                      await _auth.registerWithEmailAndPassword(email, password);
                    } on DomainException catch(e) {
                      _showErrorSnackBar(context, e.message);
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

  void _showErrorSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(text),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
