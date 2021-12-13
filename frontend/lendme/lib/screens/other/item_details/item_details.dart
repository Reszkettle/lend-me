
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lendme/components/background.dart';
import 'package:lendme/components/confirm_dialog.dart';
import 'package:lendme/models/item.dart';
import 'package:lendme/models/user.dart';
import 'package:lendme/repositories/item_repository.dart';
import 'package:lendme/screens/other/item_details/panel_available.dart';
import 'package:lendme/screens/other/item_details/panel_borrowed.dart';
import 'package:lendme/screens/other/item_details/panel_lent.dart';
import 'package:lendme/utils/constants.dart';
import 'package:lendme/utils/enums.dart';
import 'package:provider/provider.dart';

class ItemDetails extends StatelessWidget {
  ItemDetails({required this.itemId, Key? key}) : super(key: key);

  final String itemId;
  final ItemRepository _itemRepository = ItemRepository();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _itemRepository.getItemStream(itemId),
      builder: (BuildContext context, AsyncSnapshot<Item?> itemSnap) {
        final item = itemSnap.data;
        final user = Provider.of<User?>(context);
        if(item == null || user == null) {
          return Container();
        }
        return _buildFromData(context, item, user);
      },
    );
  }

  Widget _buildFromData(BuildContext context, Item item, User user) {
    final relationToItem = getItemStatus(item, user);
    return Background(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            title: Row(
              children: [
                const Text('Item: '),
                Text(item.title),
              ],
            ),
            elevation: 0.0),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16.0, right: 16.0, top: 0, bottom: 16.0),
            child: _mainLayout(context, item, relationToItem),
          ),
        ),
      ),
    );
  }

  Widget _mainLayout(BuildContext context, Item item, RelationToItem relationToItem) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(relationToItem == RelationToItem.available || relationToItem == RelationToItem.lent)
          _topRow(context, item, relationToItem),
        _itemImage(context, item),
        _title(item),
        if (item.description != null)
          _description(context, item),
        if(relationToItem != RelationToItem.neutral)
          _statusPanel(context, item, relationToItem),
        if(relationToItem == RelationToItem.available || relationToItem == RelationToItem.lent)
          _historyButton(context, item),
      ],
    );
  }

  Widget _topRow(BuildContext context, Item item, RelationToItem relationToItem) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _timeWhenAdded(item),
        const Spacer(),
        if (relationToItem == RelationToItem.available)
          _deleteButton(context, item),
      ],
    );
  }

  Widget _timeWhenAdded(Item item) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Text(
          'Added: ' + dateTimeFormat.format(item.createdAt!.toDate()),
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _deleteButton(BuildContext context, Item item) {
    return TextButton.icon(
      icon: const Icon(
        Icons.delete,
        color: Colors.red,
      ),
      label: const Text('Delete'),
      style: TextButton.styleFrom(
        primary: Colors.red,
      ),
      // splashRadius: 25,
      onPressed: () {
        _showDeleteConfirmDialog(context, item);
      },
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, Item item) {
    showConfirmDialog(
      context: context,
      message: 'Are you sure that you want to delete this item?',
      yesCallback: () {
        _deleteItem(item);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Item deleted"),
        ));
      }
    );
  }

  void _deleteItem(Item item) {
    _itemRepository.deleteItem(item.id);
  }

  Widget _itemImage(BuildContext context, Item item) {
    return Column(
      children: [
        const SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 3,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: item.imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: item.imageUrl ?? '',
                          height: 200,
                          fit: BoxFit.fitHeight,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error, size: 45))
                      : Image.asset(
                          'assets/images/item_default.jpg',
                          height: 200,
                        )),
            )
          ],
        ),
      ],
    );
  }

  Widget _title(Item item) {
    return Column(
      children: [
        const SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              item.title,
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _description(BuildContext context, Item item) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: ExpansionTile(
            title: const Text('Description'),
            textColor: Colors.black,
            iconColor: Colors.black,
            collapsedIconColor: Colors.black,
            childrenPadding: const EdgeInsets.all(0),
            children: <Widget>[
              ListTile(title: Text(item.description ?? '')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statusPanel(BuildContext context, Item item, RelationToItem relationToItem) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16.0),
        Container(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          padding: const EdgeInsets.all(16),
          child: _getProperStatusPanel(item, relationToItem),
        ),
      ],
    );
  }

  Widget _getProperStatusPanel(Item item, RelationToItem relationToItem) {
    if (relationToItem == RelationToItem.available) {
      return PanelAvailable(item: item);
    } else if (relationToItem == RelationToItem.lent) {
      return PanelLent(item: item);
    } else if (relationToItem == RelationToItem.borrowed) {
      return PanelBorrowed(item: item);
    } else {
      return Container();
    }
  }

  Widget _historyButton(BuildContext context, Item item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16.0),
        ElevatedButton.icon(
          label: const Text('Show Item History'),
          icon: const Icon(Icons.history_rounded),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
          onPressed: () {
            Navigator.of(context).pushNamed('/history', arguments: item);
          },
        ),
      ],
    );
  }

  RelationToItem getItemStatus(Item item, User user) {
    if (item.ownerId == user.uid && item.lentById == null) {
      return RelationToItem.available;
    } else if (item.ownerId == user.uid && item.lentById != null) {
      return RelationToItem.lent;
    } else if (item.lentById == user.uid) {
      return RelationToItem.borrowed;
    } else {
      return RelationToItem.neutral;
    }
  }
}
