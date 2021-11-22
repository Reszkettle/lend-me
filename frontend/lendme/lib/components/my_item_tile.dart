import 'package:flutter/material.dart';
import 'package:lendme/models/item.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'base_tile.dart';

class MyItemTile extends StatefulWidget {
  const MyItemTile({Key? key, required this.item}) : super(key: key);
  final Item item;

  @override
  _MyItemTileState createState() => _MyItemTileState();
}

class _MyItemTileState extends State<MyItemTile> {
  @override
  Widget build(BuildContext context) {
    final String timeAdded = timeago.format(widget.item.createdAt!.toDate());
    return BaseTile(
        title: widget.item.title,
        subtitle: "Added: " + timeAdded,
        imageUrl: widget.item.imageUrl,
        onTap: _onItemTap,
    );
  }

  void _onItemTap() {
    Navigator.of(context).pushNamed('/item_details', arguments: 'item_id');
  }
}
