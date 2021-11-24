import 'package:flutter/material.dart';
import 'package:lendme/components/base_tile.dart';
import 'package:lendme/models/item_rental.dart';
import 'package:lendme/utils/string_utils.dart';
import 'package:timeago/timeago.dart' as timeago;

class LentItemTile extends StatefulWidget {
  const LentItemTile({Key? key, required this.itemRental}) : super(key: key);
  final ItemRental itemRental;

  @override
  _LentItemTileState createState() => _LentItemTileState();
}

class _LentItemTileState extends State<LentItemTile> {
  @override
  Widget build(BuildContext context) {
    final String startDate =
        timeago.format(widget.itemRental.rental.startDate.toDate());
    return BaseTile(
        title: widget.itemRental.item.title,
        subtitle: "Lent by: " + widget.itemRental.rental.borrowerFullname!,
        thirdLine: capitalize(startDate),
        imageUrl: widget.itemRental.item.imageUrl);
  }
}
