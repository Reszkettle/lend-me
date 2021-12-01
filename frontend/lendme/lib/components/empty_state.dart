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
    return Image.asset(
        widget.placement == EmptyStatePlacement.borrowedItems
            ? 'assets/images/empty_state_borrow.png'
            : 'assets/images/empty_state_lend.png',
        fit: BoxFit.contain,
        color: Colors.white);
  }

  Text properText() {
    const String noBorrowedItems = "You don't have any borrowed items";
    const String noLentItems = "You don't have any lent items";
    const String noItems = "You don't have any items";
    const TextStyle textStyle = TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey);

    if (widget.placement == EmptyStatePlacement.borrowedItems) {
      return const Text(
        noBorrowedItems,
        style: textStyle,
      );
    }

    return widget.placement == EmptyStatePlacement.lentItems
        ? const Text(
            noLentItems,
            style: textStyle,
          )
        : const Text(
            noItems,
            style: textStyle,
          );
  }
}
