import 'package:flutter/material.dart';
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
  String error = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Email'),
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
                    border: OutlineInputBorder(), hintText: 'Password'),
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
                    hintText: 'Repeated password'),
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
                    dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                    if(result == null) {
                      setState(() {
                        error = 'Unable to authenticate';
                      });
                    }
                  }
                },
              ),
              const SizedBox(height: 12.0,),
              Text(
                error,
                style: const TextStyle(color: Colors.red, fontSize: 14.0),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
