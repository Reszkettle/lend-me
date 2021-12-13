import 'package:flutter/material.dart';
import 'package:lendme/utils/enums.dart';

class EmptyState extends StatefulWidget {
  const EmptyState({Key? key, required this.placement}) : super(key: key);

  final EmptyStatePlacement placement;

  @override
  _EmptyStateState createState() => _EmptyStateState();
}

class _EmptyStateState extends State<EmptyState> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          const SizedBox(height: 50),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor,
                ),
                child: ClipOval(
                    child: SizedBox(
                  width: 250,
                  height: 250,
                  child: Padding(
                    padding: const EdgeInsets.all(50),
                    child: properImage(),
                  ),
                )))
          ]),
          const SizedBox(height: 30),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [properText()])
        ]));
  }

  Image properImage() {
    final Map<EmptyStatePlacement, String> imageUriMap = {
      EmptyStatePlacement.borrowedItems: 'assets/images/empty_state_borrow.png',
      EmptyStatePlacement.lentItems: 'assets/images/empty_state_lend.png',
      EmptyStatePlacement.myItems: 'assets/images/empty_state_lend.png',
      EmptyStatePlacement.notifications:
          'assets/images/empty_state_notifications.png',
      EmptyStatePlacement.history:
      'assets/images/empty_state_history.png',
      EmptyStatePlacement.scanValue: 'assets/images/empty_state_scanValue.png',
    };

    return Image.asset(imageUriMap[widget.placement]!,
        fit: BoxFit.contain, color: Colors.white);
  }

  Text properText() {
    final Map<EmptyStatePlacement, String> textMap = {
      EmptyStatePlacement.borrowedItems: "You don't have any borrowed items",
      EmptyStatePlacement.lentItems: "You don't have any lent items",
      EmptyStatePlacement.myItems: "You don't have any items",
      EmptyStatePlacement.notifications: "You don't have any requests",
      EmptyStatePlacement.history: "You didn't borrow this item",
      EmptyStatePlacement.scanValue: "There is no this item in database"
    };

    return Text(textMap[widget.placement]!,
        style: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey));
  }
}
