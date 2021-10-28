import 'package:flutter/material.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Edit profile'),
          elevation: 0.0
      ),
      body: Stack(
          children: const [
            Placeholder(),
            Center(child:
              Text(
                  "Edit profile",
                  style: TextStyle(fontSize: 40, color: Colors.grey, backgroundColor: Colors.white)
              ),
            ),
          ],
      ),
    );
  }
}
