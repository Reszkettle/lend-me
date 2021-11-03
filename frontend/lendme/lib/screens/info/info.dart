import 'package:flutter/material.dart';
import 'package:lendme/exceptions/exception.dart';
import 'package:lendme/models/resource.dart';
import 'package:lendme/models/user.dart';
import 'package:lendme/models/user_info.dart';
import 'package:lendme/repositories/user_repository.dart';
import 'package:lendme/utils/ui/error_snackbar.dart';
import 'package:provider/provider.dart';

class Info extends StatefulWidget {
  const Info({Key? key}) : super(key: key);

  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {

  final UserRepository userRepository = UserRepository();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _userResource = Provider.of<Resource<User?>>(context);
    final user = _userResource.data!;

    _firstNameController.text = user.info.firstName ?? "";
    _lastNameController.text = user.info.lastName ?? "";
    _emailController.text = user.info.email ?? "";
    _phoneController.text = user.info.phone ?? "";

    return Scaffold(
      appBar: AppBar(
          title: const Text('Populate your profile'),
          elevation: 0.0
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20.0),
                firstNameField(),
                const SizedBox(height: 20.0),
                lastNameField(),
                const SizedBox(height: 20),
                emailField(),
                const SizedBox(height: 20),
                phoneField(),
                const SizedBox(height: 20),
                confirmButton(user.uid),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField firstNameField() {
    return TextFormField(
      controller: _firstNameController,
      decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'First name',
          prefixIcon: Icon(Icons.person_rounded)
      ),
      validator: (val) => val!.isEmpty ? 'Enter first name' : null,
    );
  }

  TextFormField lastNameField() {
    return TextFormField(
      controller: _lastNameController,
      decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Last name',
          prefixIcon: Icon(Icons.person_rounded)
      ),
      validator: (val) => val!.isEmpty ? 'Enter last name' : null,
    );
  }

  TextFormField emailField() {
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Email address',
          prefixIcon: Icon(Icons.email_rounded)
      ),
      validator: (val) => val!.isEmpty ? 'Enter email address' : null,
    );
  }

  TextFormField phoneField() {
    return TextFormField(
      controller: _phoneController,
      decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Phone number',
          prefixIcon: Icon(Icons.call_rounded)
      ),
      validator: (val) => val!.isEmpty ? 'Enter phone number' : null,
    );
  }

  ElevatedButton confirmButton(String userId) {
    return ElevatedButton(
      child: const Text("Confirm"),
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          final firstName = _firstNameController.text;
          final lastName = _lastNameController.text;
          final email = _emailController.text;
          final phone = _phoneController.text;

          final userInfo = UserInfo(
            firstName: firstName,
            lastName: lastName,
            email: email,
            phone: phone,
          );

          try {
            await userRepository.setUserInfo(userId, userInfo);
          } on DomainException catch(e) {
            showErrorSnackBar(context, "Failed to save profile. ${e.message}");
          }
        }
      },
    );
  }
}

