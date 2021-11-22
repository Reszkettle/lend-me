import 'dart:io';
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

  @override
  Widget build(BuildContext context) {

    print(widget.itemId);

    return Scaffold(
      appBar: AppBar(
          title: const Text('Item details'),
          elevation: 0.0
      ),
      body: LoadableArea(
        controller: _loadableAreaController,
        initialState: LoadableAreaState.loading,
        child: SingleChildScrollView(
          child: Text('Content')
        )
      ),
    );
  }
}
