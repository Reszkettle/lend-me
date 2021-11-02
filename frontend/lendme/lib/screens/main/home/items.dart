import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lendme/components/base_tile.dart';
import 'package:lendme/repositories/item_repository.dart';
import 'package:timeago/timeago.dart' as timeago;

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
        body: StreamBuilder(
          stream: ItemRepository().getListOfCurrentUserItems(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView.separated(
                padding: const EdgeInsets.all(9),
                itemBuilder: (context, index) {
                  DocumentSnapshot itemDoc = snapshot.data!.docs[index];
                  return BaseTile(
                      title: itemDoc["title"],
                      subtitle: "Added: " +
                          timeago.format(
                              (itemDoc["createdAt"] as Timestamp).toDate()),
                      imageUrl: itemDoc["imageUrl"]);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 9);
                },
                itemCount: snapshot.data!.docs.length);
          },
        ));
  }
}
