import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lendme/components/background.dart';
import 'package:lendme/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'borrowed.dart';
import 'items.dart';
import 'lent.dart';
import 'package:lendme/screens/other/scanner/scanner.dart';
import 'package:lendme/services/notification_service.dart';

import 'notifications.dart';


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
    Notifications(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future config() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  Future initNotifications() async {
    await NotificationService.init();
  }

  @override
  void initState() {
    super.initState();

    initNotifications();

    // Killed
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if(message != null) {
        _handleMessage(message);
      }
    });

    // Background
    FirebaseMessaging.onMessageOpenedApp.forEach((message) {
      _handleMessage(message);
    });
  }

  void _handleMessage(RemoteMessage message) {
    final requestId = message.data['requestId'] as String?;
    if(requestId == null) {
      return;
    }
    print("Message received: $message");
    print("requestId: $requestId");
    Navigator.of(context).pushNamed('/request', arguments: requestId);
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
              title: const Text('Lend me'),
              elevation: 0.0,
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.settings_rounded, color: Colors.white),
                  onPressed: () async {
                    Navigator.of(context).pushNamed('/settings');
                  },
                ),
              ]),
          body: Center(
            child: _tabsContent[_selectedIndex],
          ),
          floatingActionButton: _floatingActionButton(),
          bottomNavigationBar: BottomNavigationBar(
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
          ),),
    );
  }

  Widget? _floatingActionButton() {
    if(_selectedIndex == 0) {
      return FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed('/add_item');
        }
      );
    }
    else if(_selectedIndex == 2) {
      return FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.qr_code_scanner_rounded),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const QRViewScreen(),
            ));
          }
      );
    }
    else {
      return null;
    }
  }
}
