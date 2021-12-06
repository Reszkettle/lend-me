import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lendme/models/request.dart';

import 'base_tile.dart';

class NotificationTile extends StatefulWidget {
  final Request request;

  const NotificationTile({Key? key, required this.request}) : super(key: key);

  @override
  _NotificationTileState createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  @override
  Widget build(BuildContext context) {
    return BaseTile(
        title: widget.request.title == null ? "Unknown" : widget.request.title!,
        subtitle: widget.request.subtitle == null
            ? "Unknown"
            : widget.request.subtitle!,
        icon: const Icon(Icons.notifications, size: 45),
        onTap: _onItemTap);
  }

  void showNotification(String id) {
    Navigator.of(context).pushNamed('/request', arguments: id);
  }

  void _onItemTap() {
    final String requestId = widget.request.id!;
    showNotification(requestId);
  }
}
