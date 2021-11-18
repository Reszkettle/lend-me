import 'package:flutter/material.dart';
import 'package:lendme/components/base_tile.dart';
import 'package:lendme/models/item.dart';
import 'package:lendme/models/user.dart';
import 'package:lendme/repositories/user_repository.dart';
import 'package:lendme/utils/ui/string_utils.dart';
import 'package:timeago/timeago.dart' as timeago;

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
    return FutureBuilder<User>(
        future: UserRepository().getUser(widget.item.lentById!),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (snapshot.hasData) {
            User user = snapshot.data!;
            return BaseTile(
                title: widget.item.title,
                subtitle: "Lent by: " + user.info.fullName,
                thirdLine: capitalize(timeAdded),
                imageUrl: widget.item.imageUrl);
          }
          return CircularProgressIndicator();
        });
  }
}
