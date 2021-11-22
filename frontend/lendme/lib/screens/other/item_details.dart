import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lendme/models/item.dart';
import 'package:lendme/models/user.dart';
import 'package:lendme/services/auth_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:lendme/repositories/item_repository.dart';
import 'package:lendme/exceptions/exceptions.dart';
import 'package:lendme/components/loadable_area.dart';
import 'package:lendme/utils/ui/error_snackbar.dart';
import 'package:provider/provider.dart';

enum ItemStatus {
  lentFromMe,
  borrowedByMe,
  myAvailableItem,
  notPermitted,
}

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
    if(user == null) {
      return Container();
    }

    ItemStatus? itemStatus;
    if(item != null) {
      itemStatus = getItemStatus(item, user);
    }

    return Scaffold(
      appBar: AppBar(
          title: Row(
            children: [
              const Text('Item: '),
              if(item != null)
                Text(item.title),
            ],
          ),
          elevation: 0.0
      ),
      body: LoadableArea(
          initialState: item == null ? LoadableAreaState.loading : LoadableAreaState.main,
          child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item?.title ?? '',
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    if(item?.imageUrl != null)
                      Column(
                        children: [
                          const SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CachedNetworkImage(
                                  imageUrl: item?.imageUrl ?? '',
                                  height: 200,
                                  fit: BoxFit.fitHeight,
                                  errorWidget: (context, url, error) =>
                                  const Icon(Icons.error, size: 45)
                              )
                            ],
                          ),
                        ],
                      ),
                    if(item?.description != null)
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16.0),
                              const Text(
                                'Description:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              Text(item?.description ?? ''),
                            ],
                          ),
                        ],
                      ),
                    const SizedBox(height: 32.0,),
                    if(itemStatus != null)
                      actionButtons(itemStatus)
                  ],
                ),
              ),
          )
      ),
    );
  }

  ItemStatus getItemStatus(Item item, User user) {
    if(item.lentById == user.uid) {
      return ItemStatus.borrowedByMe;
    } else if(item.lentById == null && item.ownerId == user.uid) {
      return ItemStatus.myAvailableItem;
    } else if(item.lentById != null && item.ownerId == user.uid) {
      return ItemStatus.lentFromMe;
    } else {
      return ItemStatus.notPermitted;
    }
  }

  Widget actionButtons(ItemStatus itemStatus) {
    if(itemStatus == ItemStatus.borrowedByMe) {
      return actionButtonsBorrowed();
    } else if(itemStatus == ItemStatus.lentFromMe) {
      return actionButtonsLent();
    } else if(itemStatus == ItemStatus.myAvailableItem) {
      return actionButtonsAvailable();
    } else {
      return Container();
    }
  }

  Widget actionButtonsAvailable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
            child: const Text('Lend'),
            onPressed: () {
              // TODO: Lent action
            },
        ),
        ElevatedButton(
            child: const Text('Show History'),
            onPressed: () {
              // TODO: Show history action
            },
        ),
        ElevatedButton(
            child: const Text('Delete'),
            style: ElevatedButton.styleFrom(
              primary: Colors.redAccent, // background
              onPrimary: Colors.white, // foreground
            ),
            onPressed: () {
              // TODO: Delete action
            },
        ),
      ],
    );
  }

  Widget actionButtonsLent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          child: const Text('Confirm Return'),
          onPressed: () {
            // TODO: Confirm return action
          },
        ),
      ],
    );
  }

  Widget actionButtonsBorrowed() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          child: const Text('Extend Time'),
          onPressed: () {
            // TODO: Extend time action
          },
        ),
        ElevatedButton(
          child: const Text('Transfer'),
          onPressed: () {
            // TODO: Transfer action
          },
        ),
      ],
    );
  }

}
