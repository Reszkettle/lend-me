import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lendme/models/item.dart';
import 'package:lendme/services/auth_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:lendme/repositories/item_repository.dart';
import 'package:lendme/exceptions/exceptions.dart';
import 'package:lendme/components/loadable_area.dart';
import 'package:lendme/utils/ui/error_snackbar.dart';

class ItemDetails extends StatefulWidget {
  const ItemDetails({required this.itemId, Key? key}) : super(key: key);

  final String itemId;

  @override
  _ItemDetailsState createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {

  final LoadableAreaController _loadableAreaController = LoadableAreaController();
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
                      )
                  ],
                ),
              ),
          )
      ),
    );
  }
}
