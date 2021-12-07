import 'package:flutter/material.dart';
import 'package:lendme/components/my_item_tile.dart';
import 'package:lendme/models/item.dart';
import 'package:lendme/utils/enums.dart';

import 'empty_state.dart';

class ItemsList extends StatefulWidget {
  const ItemsList({Key? key, required this.itemsStream}) : super(key: key);
  final Stream<List<Item?>> itemsStream;

  @override
  _ItemsListState createState() => _ItemsListState();
}

class _ItemsListState extends State<ItemsList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Item?>>(
        stream: widget.itemsStream,
        builder: (context, itemSnapshots) {
          if (!itemSnapshots.hasData || itemSnapshots.data!.isEmpty) {
            return const EmptyState(placement: EmptyStatePlacement.myItems);
          }
          return ListView.separated(
            padding: const EdgeInsets.all(9),
            itemBuilder: (context, index) {
              return MyItemTile(item: itemSnapshots.data![index]!);
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 9);
            },
            itemCount: itemSnapshots.data!.length,
          );
        });
  }
}
