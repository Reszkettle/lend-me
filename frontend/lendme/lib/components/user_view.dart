import 'package:flutter/material.dart';
import 'package:lendme/components/avatar.dart';
import 'package:lendme/models/user.dart';
import 'package:lendme/repositories/user_repository.dart';
import 'package:url_launcher/url_launcher.dart';

// Horizontal widget representing particular user
// Contains avatar, name, surname, phone, email
// and optionally buttons to call and send email
class UserView extends StatelessWidget {
  UserView({required this.userId, this.showContactButtons = false, Key? key})
      : super(key: key);

  final String userId;
  final bool showContactButtons;
  final UserRepository _userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _userRepository.getUserStream(userId),
      builder: _buildFromUser,
    );
  }

  Widget _buildFromUser(BuildContext context, AsyncSnapshot<User?> rentalSnap) {
    final user = rentalSnap.data;

    return Column(
      children: [
        _userCard(user),
        if (showContactButtons)
          _contactButtons(user),
      ],
    );
  }

  Widget _userCard(User? user) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.white),
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Avatar(url: user?.avatarUrl),
              const SizedBox(width: 16),
              _userInfo(user)
            ],
          ),
        ],
      ),
    );
  }

  Widget _userInfo(User? user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              children: [
                TextSpan(text: user?.info.firstName ?? ''),
                const TextSpan(text: ' '),
                TextSpan(text: user?.info.lastName ?? '')
              ]),
        ),
        Text(user?.info.email ?? ''),
        const SizedBox(height: 2),
        Text(user?.info.phone ?? ''),
      ],
    );
  }

  Row _contactButtons(User? user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextButton.icon(
          label: const Text('Call'),
          icon: const Icon(Icons.call_rounded),
          style: TextButton.styleFrom(
            primary: Colors.white,
          ),
          onPressed: () {
            launch("tel://${user?.info.phone ?? ''}");
          },
        ),
        const SizedBox(width: 8),
        TextButton.icon(
          label: const Text('Write email'),
          icon: const Icon(Icons.alternate_email_rounded),
          style: TextButton.styleFrom(
            primary: Colors.white,
          ),
          onPressed: () {
            launch('mailto:${user?.info.email ?? ''}');
          },
        ),
      ],
    );
  }
}
