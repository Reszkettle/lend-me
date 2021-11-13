import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddItem extends StatefulWidget {
  const AddItem({Key? key}) : super(key: key);

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  CollectionReference items = FirebaseFirestore.instance.collection('items');
  String description = '';
  String itemName = '';
  var imageUrl = null;
  var localImage;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      final storage = FirebaseStorage.instance;
      File imagePath;
      final picker = ImagePicker();
      //Check Permissions
      await Permission.photos.request();
      var permissionStatus = await Permission.photos.status;
      if (permissionStatus.isGranted) {
        //Select Image
        final image = await picker.pickImage(source: ImageSource.gallery);

        setState(() {
          isLoading = true;
        });
        if (image != null) {
          imagePath = File(image.path);
        } else {
          isLoading = false;
          return;
        }
        //Upload to Firebase
        var snapshot =
            await storage.ref().child('images/items/itemName').putFile(imagePath);

        var downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          localImage = File(image.path);
          imageUrl = downloadUrl;
          isLoading = false;
        });
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Lend me'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 15.0),
              Row(
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      onChanged: (text) {
                        itemName = text;
                      },
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            // width: 0.0 produces a thin "hairline" border
                            borderSide: BorderSide(
                                color: Colors.blueAccent, width: 2.0),
                          ),
                          border: OutlineInputBorder(),
                          labelStyle: TextStyle(color: Colors.blueAccent),
                          labelText: 'Name'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15.0),
              Row(
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      onChanged: (text) {
                        description = text;
                      },
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            // width: 0.0 produces a thin "hairline" border
                            borderSide: BorderSide(
                                color: Colors.blueAccent, width: 2.0),
                          ),
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(),
                          labelStyle: TextStyle(
                              fontSize: 17.0, color: Colors.blueAccent),
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
                              decoration:
                                  BoxDecoration(color: Colors.blueGrey[200]),
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            textStyle: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold)),
                        onPressed: () => getImage(),
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
                      isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blueAccent,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  textStyle: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold)),
                              onPressed: () async {
                                save();
                              },
                              child: const Text('Save Item'),
                            ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ));
  }

  void save() async {
    if (imageUrl == null || itemName.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Title, description and picture are required!"),
      ));
    } else {
      await items.add({
        'title': itemName,
        'description': description,
        'createdAt': FieldValue.serverTimestamp(),
        'ownerId': firebaseAuth.currentUser!.uid,
        'imageUrl': imageUrl
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Item saved"),
      ));
      Navigator.pop(context);
    }
  }
}
