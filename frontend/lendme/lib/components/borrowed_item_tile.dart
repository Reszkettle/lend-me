import 'package:flutter/material.dart';
import 'package:lendme/models/item.dart';
import 'package:lendme/models/user.dart';
import 'package:lendme/repositories/rental_repository.dart';
import 'package:lendme/repositories/user_repository.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'base_tile.dart';

class BorrowedItemTile extends StatefulWidget {
  const BorrowedItemTile({Key? key, required this.item}) : super(key: key);
  final Item item;

  @override
  _BorrowedItemTileState createState() => _BorrowedItemTileState();
}

class _BorrowedItemTileState extends State<BorrowedItemTile> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([
          UserRepository().getUser(widget.item.ownerId!),
          RentalRepository().getActiveBorrowStartDateForItem(widget.item.id!)
        ]),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            User user = snapshot.data![0];
            DateTime startDate = snapshot.data![1];
            return BaseTile(
                title: widget.item.title,
                subtitle: "Borrowed from: " + user.info.fullName,
                thirdLine: timeago.format(startDate),
                imageUrl: widget.item.imageUrl);
          }
          return CircularProgressIndicator();
        });
  }
}
