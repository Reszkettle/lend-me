import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lendme/components/loadable_area.dart';
import 'package:lendme/models/item.dart';
import 'package:lendme/models/user.dart';
import 'package:lendme/repositories/item_repository.dart';
import 'package:lendme/screens/other/item_details/panel_available.dart';
import 'package:lendme/screens/other/item_details/panel_borrowed.dart';
import 'package:lendme/screens/other/item_details/panel_lent.dart';
import 'package:lendme/utils/constants.dart';
import 'package:lendme/utils/enums.dart';
import 'package:provider/provider.dart';
import 'dart:developer';

class ItemDetails extends StatefulWidget {
  const ItemDetails({required this.itemId, Key? key}) : super(key: key);

  final String itemId;

  @override
  _ItemDetailsState createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  final ItemRepository _itemRepository = ItemRepository();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _itemRepository.getItemStream(widget.itemId),
      builder: _buildFromItem,
    );
  }

  Widget _buildFromItem(BuildContext context, AsyncSnapshot<Item?> itemSnap) {
    final item = itemSnap.data;

    final user = Provider.of<User?>(context);
    if (user == null) {
      return Container();
    }

    ItemStatus? itemStatus;
    if (item != null) {
      itemStatus = getItemStatus(item, user);
    }

    return Scaffold(
      appBar: AppBar(
          title: Row(
            children: [
              const Text('Item: '),
              if (item != null) Text(item.title),
            ],
          ),
          elevation: 0.0),
      body: LoadableArea(
          initialState:
              item == null ? LoadableAreaState.loading : LoadableAreaState.main,
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, top: 0, bottom: 16.0),
              child: _mainLayout(context, item, itemStatus),
            ),
          )),
    );
  }

  Widget _mainLayout(BuildContext context, Item? item, ItemStatus? itemStatus) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _topRow(item, itemStatus),
        const SizedBox(height: 16.0),
        _itemImage(context, item),
        const SizedBox(height: 16.0),
        _title(item),
        if (item?.description != null) _description(context, item),
        const SizedBox(height: 16.0),
        _statusPanel(item, itemStatus),
        const SizedBox(height: 16.0),
        if(itemStatus != ItemStatus.borrowed)
          _historyButton(item),
      ],
    );
  }

  Widget _topRow(Item? item, ItemStatus? itemStatus) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _timeWhenAdded(item),
        const Spacer(),
        if (itemStatus == ItemStatus.available) _deleteButton(),
      ],
    );
  }

  Widget _timeWhenAdded(Item? item) {
    if(item == null) {
      return Container();
    }
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

  Widget _deleteButton() {
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
        // TODO: Delete item
      },
    );
  }

  Widget _itemImage(BuildContext context, Item? item) {
    return Row(
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
              child: item?.imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: item?.imageUrl ?? '',
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
    );
  }

  Widget _title(Item? item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          item?.title ?? '',
          style: const TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _description(BuildContext context, Item? item) {
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
              ListTile(title: Text(item?.description ?? '')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statusPanel(Item? item, ItemStatus? itemStatus) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          padding: const EdgeInsets.all(16),
          child: _getProperStatusPanel(item, itemStatus),
        ),
      ],
    );
  }

  Widget _getProperStatusPanel(Item? item, ItemStatus? itemStatus) {
    if (item == null || itemStatus == null) {
      return Container();
    }
    if (itemStatus == ItemStatus.available) {
      return PanelAvailable(item: item);
    } else if (itemStatus == ItemStatus.lent) {
      return PanelLent(item: item);
    } else if (itemStatus == ItemStatus.borrowed) {
      return PanelBorrowed(item: item);
    } else {
      return Container();
    }
  }

  Widget _historyButton(Item? item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          label: const Text('Show Item History'),
          icon: const Icon(Icons.history_rounded),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
          onPressed: () {
            if(item != null) {
              Navigator.of(context).pushNamed('/history', arguments: item.id!);
            }
          },
        ),
      ],
    );
  }

  ItemStatus getItemStatus(Item item, User user) {
    if (item.lentById == user.uid) {
      return ItemStatus.borrowed;
    } else if (item.lentById == null && item.ownerId == user.uid) {
      return ItemStatus.available;
    } else if (item.lentById != null && item.ownerId == user.uid) {
      return ItemStatus.lent;
    } else {
      log('Inconsistent database state! unable to conclude item ${item.id} status!');
      return ItemStatus.available;  // Shouldn't happen, but lets say it's available!
    }
  }
}


class _TimeWhenAdded extends StatelessWidget {
  const _TimeWhenAdded({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
