import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lendme/components/loadable_area.dart';
import 'package:lendme/exceptions/exception.dart';
import 'package:lendme/models/resource.dart';
import 'package:lendme/models/user.dart';
import 'package:lendme/models/user_info.dart';
import 'package:lendme/repositories/user_repository.dart';
import 'package:lendme/services/auth.dart';
import 'package:lendme/utils/ui/error_snackbar.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({this.afterLoginVariant = false, Key? key}) : super(key: key);

  static const int maxFirstNameLength = 30;
  static const int maxLastNameLength = 30;
  static const int maxEmailLength = 40;
  static const int maxPhoneLength = 15;

  final bool afterLoginVariant;

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  final UserRepository _userRepository = UserRepository();
  final AuthService _authService = AuthService();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final LoadableAreaController _loadableAreaController = LoadableAreaController();

  @override
  Widget build(BuildContext context) {
    final userResource = Provider.of<Resource<User>>(context);
    final user = userResource.data;

    if(user == null) {
      return Container();
    }

    _firstNameController.text = user.info.firstName ?? "";
    _lastNameController.text = user.info.lastName ?? "";
    _emailController.text = user.info.email ?? "";
    _phoneController.text = user.info.phone ?? "";

    return Scaffold(
      appBar: AppBar(
          title: Text(widget.afterLoginVariant ? 'Populate your profile' : 'Edit profile'),
          elevation: 0.0
      ),
      body: LoadableArea(
        controller: _loadableAreaController,
        initialState: LoadableAreaState.main,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                      image: DecorationImage(
                          image: NetworkImage(user.avatarUrl ?? ""),
                          fit: BoxFit.contain,
                      ),
                      border: Border.all(
                        color: Colors.blueAccent,
                        width: 3,
                      ),
                    ),
                  ),
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
                  if(widget.afterLoginVariant)
                    signOutButton()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField firstNameField() {
    return TextFormField(
      controller: _firstNameController,
      inputFormatters: [
        LengthLimitingTextInputFormatter(EditProfile.maxFirstNameLength),
      ],
      decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'First name',
          prefixIcon: Icon(Icons.person_rounded)
      ),
      validator: validateFirstName,
    );
  }

  TextFormField lastNameField() {
    return TextFormField(
      controller: _lastNameController,
      inputFormatters: [
        LengthLimitingTextInputFormatter(EditProfile.maxLastNameLength),
      ],
      decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Last name',
          prefixIcon: Icon(Icons.person_rounded)
      ),
      validator: validateLastName,
    );
  }

  TextFormField emailField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: _emailController,
      inputFormatters: [
        LengthLimitingTextInputFormatter(EditProfile.maxEmailLength),
      ],
      decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Email address',
          prefixIcon: Icon(Icons.email_rounded)
      ),
      validator: validateEmail,
    );
  }

  TextFormField phoneField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      controller: _phoneController,
      inputFormatters: [
        LengthLimitingTextInputFormatter(EditProfile.maxPhoneLength),
      ],
      decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Phone number',
          prefixIcon: Icon(Icons.call_rounded)
      ),
      validator: validatePhone,
    );
  }

  String? validateFirstName(String? name) {
    if(name!.isEmpty) {
      return 'Enter first name';
    }
    return null;
  }

  String? validateLastName(String? name) {
    if(name!.isEmpty) {
      return 'Enter last name';
    }
    return null;
  }

  String? validateEmail(String? email) {
      if(email!.isEmpty) {
        return 'Enter email address';
      }
      String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = RegExp(pattern);
      if (!regex.hasMatch(email)) {
        return 'Enter valid email';
      } else {
        return null;
      }
    }

  String? validatePhone(String? phone) {
    phone!.isEmpty ? 'Enter phone number' : null;
  }

  ElevatedButton confirmButton(String? userId) {
    return ElevatedButton(
      child: const Text("Confirm"),
      onPressed: () async {
        if(userId == null) {
          return;
        }

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
            _loadableAreaController.setState(LoadableAreaState.pending);
            await Future.delayed(const Duration(seconds: 1));
            await _userRepository.setUserInfo(userId, userInfo);
            if(!widget.afterLoginVariant) {
              Navigator.of(context).pop();
            }
          } on DomainException catch(e) {
            showErrorSnackBar(context, "Failed to save profile. ${e.message}");
          } finally {
            _loadableAreaController.setState(LoadableAreaState.main);
          }
        }
      },
    );
  }

  ElevatedButton signOutButton() {
    return ElevatedButton(
      onPressed: () async {
        _authService.signOut();
      },
      child: const Text("Sign out"),
      style: ElevatedButton.styleFrom(
          primary: Colors.redAccent
      ),
    );
  }
}

