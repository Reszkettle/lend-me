import 'package:flutter/material.dart';
import 'package:lendme/models/item_rental.dart';
import 'package:lendme/models/user.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'base_tile.dart';

class BorrowedItemTile extends StatefulWidget {
  const BorrowedItemTile(
      {Key? key, required this.itemRental, required this.currentUser})
      : super(key: key);
  final ItemRental itemRental;
  final User currentUser;

  @override
  _BorrowedItemTileState createState() => _BorrowedItemTileState();
}

class _BorrowedItemTileState extends State<BorrowedItemTile> {
  @override
  Widget build(BuildContext context) {
    return BaseTile(
        title: widget.itemRental.item.title,
        subtitle: "Borrowed from: " + widget.currentUser.info.fullName,
        thirdLine: timeago.format(widget.itemRental.rental.startDate.toDate()),
        imageUrl: widget.itemRental.item.imageUrl);
  }
}
