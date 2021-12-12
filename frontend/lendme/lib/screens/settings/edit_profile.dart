import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lendme/components/avatar.dart';
import 'package:lendme/components/loadable_area.dart';
import 'package:lendme/exceptions/exceptions.dart';
import 'package:lendme/models/user.dart';
import 'package:lendme/models/user_info.dart';
import 'package:lendme/repositories/user_repository.dart';
import 'package:lendme/services/auth_service.dart';
import 'package:lendme/utils/error_snackbar.dart';
import 'package:permission_handler/permission_handler.dart';
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

  File? _pendingAvatar;
  bool _isAvatarPending = false;
  bool _userSet = false;


  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    if(user == null) {
      return Container();
    }

    if(!_userSet) {
      setState(() {
        _firstNameController.text = user.info.firstName ?? "";
        _lastNameController.text = user.info.lastName ?? "";
        _emailController.text = user.info.email ?? "";
        _phoneController.text = user.info.phone ?? "";
        _userSet = true;
      });
    }

    Future.delayed(const Duration(milliseconds: 10), () => _formKey.currentState!.validate());

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
                  Avatar(
                    url: _isAvatarPending ? _pendingAvatar?.path : user.avatarUrl,
                    size: 200,
                  ),
                  const SizedBox(height: 10),
                  avatarButtons(user),
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

  Row avatarButtons(User user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: changeImageClicked,
            label: const Text("Change image"),
            icon: const Icon(Icons.image_rounded),
          ),
        ),
        const SizedBox(width: 8),
        Visibility(
          visible: _isAvatarPending,
          child: Expanded(
            child: ElevatedButton.icon(
              onPressed: resetImageClicked,
              label: const Text("Rollback image"),
              icon: const Icon(Icons.restart_alt_rounded),
            ),
          ),
        ),
        Visibility(
          visible: !_isAvatarPending && user.avatarUrl != null,
          child: Expanded(
            child: ElevatedButton.icon(
              onPressed: removeImageClicked,
              label: const Text("Remove image"),
              icon: const Icon(Icons.clear_rounded),
            ),
          ),
        ),
      ],
    );
  }

  void changeImageClicked() async {
    final picker = ImagePicker();
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        String selectedPath = image.path;
        File? croppedFile = await ImageCropper.cropImage(
            sourcePath: selectedPath,
            aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
            cropStyle: CropStyle.circle,
            androidUiSettings: const AndroidUiSettings(
                toolbarTitle: 'Crop avatar image',
                toolbarColor: Colors.blueAccent,
                toolbarWidgetColor: Colors.white),
        );
        if(croppedFile != null) {
          setState(() {
            _pendingAvatar = croppedFile;
            _isAvatarPending = true;
          });
        }
      }
    }
  }

  void removeImageClicked() {
    setState(() {
      _pendingAvatar = null;
      _isAvatarPending = true;
    });
  }

  void resetImageClicked() {
    setState(() {
      _pendingAvatar = null;
      _isAvatarPending = false;
    });
  }

  TextFormField firstNameField() {
    return TextFormField(
      controller: _firstNameController,
      onChanged: (val) => { _formKey.currentState!.validate() },
      inputFormatters: [
        LengthLimitingTextInputFormatter(EditProfile.maxFirstNameLength),
      ],
      decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'First name',
          labelText: 'First name',
          prefixIcon: Icon(Icons.person_rounded)
      ),
      validator: validateFirstName,
    );
  }

  TextFormField lastNameField() {
    return TextFormField(
      controller: _lastNameController,
      onChanged: (val) => { _formKey.currentState!.validate() },
      inputFormatters: [
        LengthLimitingTextInputFormatter(EditProfile.maxLastNameLength),
      ],
      decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Last name',
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
      onChanged: (val) => { _formKey.currentState!.validate() },
      inputFormatters: [
        LengthLimitingTextInputFormatter(EditProfile.maxEmailLength),
      ],
      decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Email address',
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
      onChanged: (val) => { _formKey.currentState!.validate() },
      inputFormatters: [
        LengthLimitingTextInputFormatter(EditProfile.maxPhoneLength),
      ],
      decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Phone number',
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
    return phone!.isEmpty ? 'Enter phone number' : null;
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
            // delayed just to show pending animation for 1 second :)
            await Future.delayed(const Duration(seconds: 1));
            // update info
            await _userRepository.setUserInfo(userId, userInfo);
            // update avatar
            final fIsAvatarPending = _isAvatarPending;
            if(fIsAvatarPending) {
              await _userRepository.setUserAvatar(_pendingAvatar);
            }

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

