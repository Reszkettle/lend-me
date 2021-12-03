import 'package:flutter/material.dart';
import 'package:lendme/components/avatar.dart';
import 'package:lendme/components/item_circle_image.dart';
import 'package:lendme/models/item.dart';
import 'package:lendme/models/user.dart';
import 'package:lendme/repositories/item_repository.dart';
import 'package:lendme/repositories/user_repository.dart';
import 'package:url_launcher/url_launcher.dart';


class ItemView extends StatelessWidget {
  ItemView({required this.itemId, Key? key})
      : super(key: key);

  final String itemId;
  final ItemRepository _itemsRepository = ItemRepository();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _itemsRepository.getItemStream(itemId),
      builder: _buildFromUser,
    );
  }

  Widget _buildFromUser(BuildContext context, AsyncSnapshot<Item?> itemSnap) {
    final item = itemSnap.data;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.white),
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ItemCricleImage(url: item?.imageUrl, size: 60.0),
              Expanded(child: _rightColumn(context, item))
            ],
          ),
        ],
      ),
    );
  }

  Widget _rightColumn(BuildContext context, Item? item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 8),
        Text(
            item?.title ?? '',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )
        ),
        const SizedBox(height: 2),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
              'Description: ' + (item?.description ?? 'No description'),
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black,
              ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        _button(context, item),
      ],
    );
  }

  Row _button(BuildContext context, Item? item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton.icon(
          label: const Text('Show this item'),
          icon: const Icon(Icons.category_rounded),
          style: TextButton.styleFrom(
            primary: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pushNamed('/item_details', arguments: itemId);
          },
        ),
      ],
    );
  }

}
