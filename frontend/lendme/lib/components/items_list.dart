import 'package:flutter/material.dart';
import 'package:lendme/components/my_item_tile.dart';
import 'package:lendme/models/item.dart';
import 'package:lendme/utils/ui/enums.dart';

class ItemsList extends StatefulWidget {
  const ItemsList(
      {Key? key, required this.itemsStream, required this.itemsOrigin})
      : super(key: key);
  final Stream<List<Item?>> itemsStream;
  final ItemsOrigin itemsOrigin;

  @override
  _ItemsListState createState() => _ItemsListState();
}

class _ItemsListState extends State<ItemsList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Item?>>(
        stream: widget.itemsStream,
        builder: (context, itemSnapshots) {
          if (!itemSnapshots.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.separated(
            padding: const EdgeInsets.all(9),
            itemBuilder: (context, index) {
              if (widget.itemsOrigin == ItemsOrigin.my) {
                return MyItemTile(item: itemSnapshots.data![index]!);
              }
              // TODO Implement different tiles for 'lent' and 'borrowed' items
              return widget.itemsOrigin == ItemsOrigin.borrowed
                  ? MyItemTile(item: itemSnapshots.data![index]!)
                  : MyItemTile(item: itemSnapshots.data![index]!);
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 9);
            },
            itemCount: itemSnapshots.data!.length,
          );
        });
  }
}
