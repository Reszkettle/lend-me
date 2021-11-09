import 'package:flutter/material.dart';
import 'package:lendme/components/my_item_tile.dart';
import 'package:lendme/models/item.dart';
import 'package:lendme/repositories/item_repository.dart';

class Items extends StatefulWidget {
  const Items({Key? key}) : super(key: key);

  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: null,
        body: StreamBuilder<List<Item?>>(
          stream: ItemRepository().getStreamOfCurrentUserItems(),
          builder: (context, itemSnapshots) {
            if (!itemSnapshots.hasData) {
              return const Center(child: CircularProgressIndicator());
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
          },
        ));
  }
}
