import 'package:flutter/material.dart';
import 'package:lendme/components/avatar.dart';
import 'package:lendme/models/user.dart';
import 'package:lendme/repositories/user_repository.dart';
import 'package:url_launcher/url_launcher.dart';


class UserView extends StatelessWidget {
  UserView({required this.userId, Key? key})
      : super(key: key);

  final String userId;
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
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Avatar(url: user?.avatarUrl, size: 60.0),
              Expanded(child: _rightColumn(user))
            ],
          ),
        ],
      ),
    );
  }

  Widget _rightColumn(User? user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 8),
        Text(
          '${user?.info.firstName ?? ''} ${user?.info.lastName ?? ''}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          )),
        const SizedBox(height: 2),
        _contactButtons(user),
      ],
    );
  }

  Row _contactButtons(User? user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
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
