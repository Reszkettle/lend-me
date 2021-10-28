import 'package:flutter/material.dart';
import 'package:lendme/screens/main/home/notifications.dart';

import 'borrowed.dart';
import 'items.dart';
import 'lent.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _selectedIndex = 0;

  static const List<Widget> _tabsContent = <Widget>[
    Items(),
    Lent(),
    Borrowed(),
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
              IconButton(
                icon: const Icon(Icons.settings_rounded, color: Colors.white),
                onPressed: () async {
                  Navigator.pushNamed(context, '/settings');
                },
              ),
            ]),
        body: Center(
          child: _tabsContent[_selectedIndex],
        ),
        floatingActionButton: _floatingActionButton(),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.blue,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.category_rounded),
              label: 'Items',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.file_upload_rounded),
              label: 'Lent',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.download_rounded),
              label: 'Borrowed',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_rounded),
              label: 'Notifications',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          onTap: _onItemTapped,
        ),);
  }

  Widget? _floatingActionButton() {
    if(_selectedIndex == 0) {
      return FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/add_item');
        }
      );
    }
    else if(_selectedIndex == 2) {
      return FloatingActionButton(
          child: const Icon(Icons.qr_code_scanner_rounded),
          onPressed: () {

          }
      );
    }
    else {
      return null;
    }
  }
}
