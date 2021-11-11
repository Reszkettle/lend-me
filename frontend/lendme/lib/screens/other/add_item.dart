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
  String item_name = '';
  String imageUrl =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1f/Blank_square.svg/2048px-Blank_square.svg.png';

  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      final _storage = FirebaseStorage.instance;
      final _picker = ImagePicker();
      PickedFile image;
      //Check Permissions
      await Permission.photos.request();

      var permissionStatus = await Permission.photos.status;

      if (permissionStatus.isGranted) {
        //Select Image
        XFile? image = await _picker.pickImage(source: ImageSource.gallery);
        var file = File(image!.path);
        //Upload to Firebase
        var snapshot = await _storage.ref().child('images/items/itemName').putFile(file);

        var downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          imageUrl = downloadUrl;
        });
      }
    }

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme:
            const InputDecorationTheme(border: OutlineInputBorder()),
      ),
      home: Scaffold(
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
                          item_name = text;
                        },
                        decoration: InputDecoration(labelText: 'Name'),
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
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        keyboardType: TextInputType.multiline,
                        minLines: 5,
                        maxLines: null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25.0),
                Row(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 3, // takes 30% of available width
                        child: Column(
                          children: [
                            Image.network(
                              imageUrl,
                              height: 150,
                              width: 350,
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
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold)),
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
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blueAccent,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              textStyle: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold)),
                          onPressed: () async {
                            await items.add({
                              'title': item_name,
                              'description': description,
                              'createdAt': FieldValue.serverTimestamp(),
                              'ownerId': firebaseAuth.currentUser!.uid,
                              'imageUrl': imageUrl
                            }).then((value) => print("Item added"));
                          },
                          child: const Text('Save Item'),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
