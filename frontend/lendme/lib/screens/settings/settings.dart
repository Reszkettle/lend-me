import 'package:flutter/material.dart';
import 'package:lendme/components/background.dart';
import 'package:lendme/components/confirm_dialog.dart';
import 'package:lendme/services/auth_service.dart';

class Settings extends StatelessWidget {
  Settings({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();


  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Background(
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
              title: const Text('Settings'),
              elevation: 0.0
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                onPressed: () => {
                Navigator.of(context).pushNamed('/edit_profile'),
          },
              // padding: const EdgeInsets.all(0.0),
              child: Container(
                padding: const EdgeInsets.only(top: 20.0, bottom: 20 ),
                child:Row(
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(Icons.mode_edit)
                    ),
                    Container(
                        margin: const EdgeInsets.only( left: 10.0 ),
                        child: Text(
                          "Edit profile",
                          style: TextStyle( fontSize: 20.0),
                        )
                    )
                  ],
                ),
              ),
          ),

                const SizedBox(height: 16.0),
                ElevatedButton(
                    onPressed: () => {
                    Navigator.of(context).pushNamed('/change_theme'),
                    },
                    // padding: const EdgeInsets.all(0.0),
                    child: Container(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 20 ),
                      child:Row(
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(Icons.mode_night)
                          ),
                          Container(
                              margin: const EdgeInsets.only( left: 10.0 ),
                              child: Text(
                                "Change theme",
                                style: TextStyle( fontSize: 20.0),
                              )
                          )
                        ],
                      ),
                    ),
                ),
                const SizedBox(height: 16.0),

                ElevatedButton(
                    onPressed: () => {
                    Navigator.of(context).pushNamed('/credits'),
                    },
                    // padding: const EdgeInsets.all(0.0),
                    child: Container(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 20 ),
                      child:Row(
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(Icons.favorite)
                          ),
                          Container(
                              margin: const EdgeInsets.only( left: 10.0 ),
                              child: Text(
                                "Credits",
                                style: TextStyle( fontSize: 20.0),
                              )
                          )
                        ],
                      ),
                    ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                    onPressed: () => _showLogOutConfirmDialog(context),
                    // padding: const EdgeInsets.all(0.0),
                    child: Container(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 20 ),
                      child:Row(
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(Icons.logout)
                          ),
                          Container(
                              margin: const EdgeInsets.only( left: 10.0 ),
                              child: Text(
                                "Log out",
                                style: TextStyle( fontSize: 20.0),
                              )
                          )
                        ],
                      ),
                    ),
                ),
              ],
            ),
          ),
      ),
    );
  }

  void _showLogOutConfirmDialog(BuildContext context) {
    showConfirmDialog(
        context: context,
        message: 'Are you sure that you want to log out?',
        yesCallback: () => _auth.signOut()
    );
  }

}
