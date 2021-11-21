import 'package:flutter/material.dart';
import 'package:lendme/components/base_tile.dart';
import 'package:lendme/models/item_rental.dart';
import 'package:lendme/models/user.dart';
import 'package:lendme/repositories/user_repository.dart';
import 'package:lendme/utils/ui/string_utils.dart';
import 'package:timeago/timeago.dart' as timeago;

class LentItemTile extends StatefulWidget {
  const LentItemTile(
      {Key? key, required this.itemRental, required this.currentUser})
      : super(key: key);
  final ItemRental itemRental;
  final User currentUser;

  @override
  _LentItemTileState createState() => _LentItemTileState();
}

class _LentItemTileState extends State<LentItemTile> {
  @override
  Widget build(BuildContext context) {
    final String timeAdded =
        timeago.format(widget.itemRental.rental.startDate.toDate());
    return BaseTile(
        title: widget.itemRental.item.title,
        subtitle: "Lent by: " + widget.currentUser.info.fullName,
        thirdLine: capitalize(timeAdded),
        imageUrl: widget.itemRental.item.imageUrl);
  }
}
