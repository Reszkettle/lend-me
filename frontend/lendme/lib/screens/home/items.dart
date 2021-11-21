import 'package:flutter/material.dart';
import 'package:lendme/components/items_list.dart';
import 'package:lendme/repositories/item_repository.dart';
import 'package:lendme/utils/ui/enums.dart';

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
        body: ItemsList(
            itemsStream: ItemRepository().getStreamOfCurrentUserItems(),
            rentalOrigin: RentalOrigin.my));
  }
}
