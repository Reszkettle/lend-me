import 'package:flutter/material.dart';
import 'package:lendme/models/item_rental.dart';
import 'package:lendme/utils/ui/string_utils.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'base_tile.dart';

class BorrowedItemTile extends StatefulWidget {
  const BorrowedItemTile({Key? key, required this.itemRental})
      : super(key: key);
  final ItemRental itemRental;

  @override
  _BorrowedItemTileState createState() => _BorrowedItemTileState();
}

class _BorrowedItemTileState extends State<BorrowedItemTile> {
  @override
  Widget build(BuildContext context) {
    final String startDate =
        timeago.format(widget.itemRental.rental.startDate.toDate());
    return BaseTile(
        title: widget.itemRental.item.title,
        subtitle: "Borrowed from: " + widget.itemRental.rental.ownerFullname!,
        thirdLine: capitalize(startDate),
        imageUrl: widget.itemRental.item.imageUrl);
  }
}
