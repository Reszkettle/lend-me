import 'package:flutter/material.dart';
import 'package:lendme/components/items_list.dart';
import 'package:lendme/repositories/item_repository.dart';
import 'package:lendme/utils/ui/enums.dart';

class Borrowed extends StatefulWidget {
  const Borrowed({Key? key}) : super(key: key);

  @override
  _BorrowedState createState() => _BorrowedState();
}

class _BorrowedState extends State<Borrowed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: null,
        body: ItemsList(
            itemsStream: ItemRepository().getStreamOfBorrowedItems(),
            itemsOrigin: ItemsOrigin.borrowed));
  }
}
