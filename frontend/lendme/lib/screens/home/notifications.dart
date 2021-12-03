import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text("Sample requests:"),
          const SizedBox(height: 16,),
          ElevatedButton(
              onPressed: () => showNotification("borrow"),
              child: const Text('Borrow request')
          ),
          ElevatedButton(
              onPressed: () => showNotification("transfer"),
              child: const Text('Transfer request')
          ),
          ElevatedButton(
              onPressed: () => showNotification("extend"),
              child: const Text('Extend request')
          ),
        ],
      ),
    );
  }

  void showNotification(String id) {
    Navigator.of(context).pushNamed('/request', arguments: id);
  }

}
