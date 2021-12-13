import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lendme/models/request.dart';
import 'package:lendme/models/request_status.dart';

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
        textColor: Colors.black,
        backgroundColor: getBackgroundColor(),
        title: widget.request.title == null ? "Unknown" : widget.request.title!,
        subtitle: widget.request.subtitle == null
            ? "Unknown"
            : widget.request.subtitle!,
        icon: const Icon(Icons.notifications, size: 45),
        onTap: _onItemTap);
  }

  Color getBackgroundColor() {
    switch (widget.request.status) {
      case RequestStatus.accepted:
        return Theme.of(context).highlightColor;
      case RequestStatus.pending:
        return Theme.of(context).dividerColor;
      default:
        return Theme.of(context).errorColor;
    }
  }

  void showNotification(String id) {
    Navigator.of(context).pushNamed('/request', arguments: id);
  }

  void _onItemTap() {
    final String requestId = widget.request.id!;
    showNotification(requestId);
  }
}
