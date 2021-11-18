import 'package:flutter/material.dart';
import 'package:lendme/components/items_list.dart';
import 'package:lendme/repositories/item_repository.dart';
import 'package:lendme/utils/ui/enums.dart';

class Lent extends StatefulWidget {
  const Lent({Key? key}) : super(key: key);

  @override
  _LentState createState() => _LentState();
}

class _LentState extends State<Lent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: null,
        body: ItemsList(
            itemsStream: ItemRepository().getStreamOfLentItems(),
            itemsOrigin: ItemsOrigin.lent));
  }
}
