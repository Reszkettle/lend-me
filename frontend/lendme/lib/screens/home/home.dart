import 'package:flutter/material.dart';
import 'package:lendme/screens/home/profile.dart';
import 'package:lendme/services/auth.dart';

import 'borrowed.dart';
import 'items.dart';
import 'lent.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  int _selectedIndex = 0;

  static const List<Widget> _tabsContent = <Widget>[
    Items(),
    Borrowed(),
    Lent(),
    Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Lend me'),
            elevation: 0.0,
            actions: <Widget>[
              TextButton.icon(
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  'logout',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  await _auth.signOut();
                },
              ),
            ]),
        body: Center(
          child: _tabsContent[_selectedIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.blue,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Items',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Borrowed',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Lent',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          onTap: _onItemTapped,
        ));
  }
}
