import 'package:flutter/material.dart';
import 'package:lendme/models/item.dart';
import 'package:lendme/utils/ui/string_utils.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'base_tile.dart';

class LentItemTile extends StatefulWidget {
  const LentItemTile({Key? key, required this.item}) : super(key: key);
  final Item item;

  @override
  _LentItemTileState createState() => _LentItemTileState();
}

class _LentItemTileState extends State<LentItemTile> {
  @override
  Widget build(BuildContext context) {
    final String timeAdded = timeago.format(widget.item.createdAt!.toDate());
    return BaseTile(
        title: widget.item.title,
        subtitle: "Lent by: " + widget.item.lentById!,
        thirdLine: capitalize(timeAdded),
        imageUrl: widget.item.imageUrl);
  }
}
