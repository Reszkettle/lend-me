import 'package:flutter/material.dart';
import 'package:lendme/components/background.dart';
import 'package:lendme/components/loadable_area.dart';
import 'package:lendme/repositories/user_repository.dart';
import 'package:lendme/services/auth_service.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({Key? key}) : super(key: key);

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  final UserRepository _userRepository = UserRepository();

  bool _returnItemsVisible = false;
  final LoadableAreaController _loadableAreaController =
      LoadableAreaController();

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('Delete account'), elevation: 0.0),
        body: LoadableArea(
          controller: _loadableAreaController,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: _content(),
                  ),
                ),
              ),
              _deleteButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 16.0),
        Image.asset(
          'assets/images/delete.png',
          height: 150,
        ),
        const SizedBox(height: 16.0),
        const Text(
          "Are you sure, that you want to delete this account? This operation is irreversible.",
          style: TextStyle(
            fontSize: 17,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16.0),
        Visibility(
          visible: _returnItemsVisible,
          child: const Text(
            "You have borrowed items. You must return them before deleting account.",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Row _deleteButton() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 60,
            child: ElevatedButton(
                onPressed: _deleteAccount,
                child: const Text(
                  "Delete account",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                )),
          ),
        ),
      ],
    );
  }

  Future<void> _deleteAccount() async {
    _loadableAreaController.setState(LoadableAreaState.pending);
    try {
      final success = await _userRepository.deleteUser();
      if (success == true) {
        await _authService.signOut();
      } else {
        setState(() {
          _returnItemsVisible = true;
        });
      }
    } finally {
      _loadableAreaController.setState(LoadableAreaState.main);
    }
  }
}
