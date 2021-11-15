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

class AddItem extends StatefulWidget {
  const AddItem({Key? key}) : super(key: key);

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final ItemRepository itemRepository = ItemRepository();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final LoadableAreaController _loadableAreaController = LoadableAreaController();
  var imageUrl = null;
  var localImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Lend me'),
        ),
        body: LoadableArea(
          controller: _loadableAreaController,
          initialState: LoadableAreaState.main,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 15.0),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: TextFormField(
                          controller: _titleController,
                          onChanged: (val) => {_formKey.currentState!.validate()},
                          validator: validateTitle,
                          decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                // width: 0.0 produces a thin "hairline" border
                                borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                              ),
                              border: OutlineInputBorder(),
                              labelStyle: TextStyle(color: Colors.blueAccent),
                              labelText: 'Title'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: TextFormField(
                          controller: _descriptionController,
                          onChanged: (val) => {_formKey.currentState!.validate()},
                          validator: validateDescription,
                          decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                // width: 0.0 produces a thin "hairline" border
                                borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                              ),
                              alignLabelWithHint: true,
                              border: OutlineInputBorder(),
                              labelStyle: TextStyle(fontSize: 17.0, color: Colors.blueAccent),
                              labelText: 'Description'),
                          keyboardType: TextInputType.multiline,
                          minLines: 5,
                          maxLines: null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25.0),
                  Row(children: <Widget>[
                    Expanded(
                      flex: 3, // takes 30% of available width
                      child: Column(
                        children: [
                          localImage != null
                              ? Image.file(
                                  localImage,
                                  height: 150,
                                  width: 350,
                                )
                              : Container(
                                  decoration: BoxDecoration(color: Colors.blueGrey[200]),
                                  height: 150,
                                  width: 350,
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.grey[800],
                                  ),
                                ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3, // takes 70% of available width
                      child: Column(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blueAccent,
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                textStyle: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                            onPressed: () => getLocalImage(),
                            child: const Text('Add Image'),
                          ),
                        ],
                      ),
                    ),
                  ]),
                  const SizedBox(height: 130.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blueAccent,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                textStyle: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                saveImage();
                                _loadableAreaController.setState(LoadableAreaState.pending);
                                await Future.delayed(const Duration(seconds: 4));
                                _loadableAreaController.setState(LoadableAreaState.main);
                                saveItem();
                              }
                            },
                            child: const Text('Save Item'),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  String? validateTitle(String? name) {
    if (name!.isEmpty) {
      return 'Enter title';
    }
    return null;
  }

  String? validateDescription(String? name) {
    if (name!.isEmpty) {
      return 'Enter description';
    }
    return null;
  }

  Future getLocalImage() async {
    final picker = ImagePicker();
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      //Select Image
      final image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          localImage = File(image.path);
        });
      }
    }
  }

  Future saveImage() async {
    String? downloadUrl;
    if (localImage != null) {
      await ItemRepository().addImage(localImage).then((value){
        downloadUrl = value;
      });
      setState(() {
        imageUrl = downloadUrl;
      });
    }
  }

  void saveItem() async {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text;
      final description = _descriptionController.text;
      var ownerId = AuthService().getUid();
      final itemInfo = Item(
        title: title,
        description: description,
        ownerId: ownerId,
        createdAt: Timestamp.now(),
        imageUrl: imageUrl,
      );

      try {
        await itemRepository.addItem(itemInfo);
      } on DomainException catch (e) {
        showErrorSnackBar(context, "Failed to save Item. ${e.message}");
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Item saved"),
      ));
      Navigator.pop(context);
    }
  }
}
