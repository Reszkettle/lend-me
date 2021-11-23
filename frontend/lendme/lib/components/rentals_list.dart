import 'package:flutter/material.dart';
import 'package:lendme/components/borrowed_item_tile.dart';
import 'package:lendme/components/lent_item_tile.dart';
import 'package:lendme/models/item_rental.dart';
import 'package:lendme/utils/ui/enums.dart';

class RentalsList extends StatefulWidget {
  const RentalsList(
      {Key? key, required this.rentalsStream, required this.rentalOrigin})
      : super(key: key);
  final Stream<List<ItemRental>> rentalsStream;
  final RentalOrigin rentalOrigin;

  @override
  _RentalsListState createState() => _RentalsListState();
}

class _RentalsListState extends State<RentalsList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ItemRental>>(
        stream: widget.rentalsStream,
        builder: (context, rentalSnapshots) {
          if (!rentalSnapshots.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.separated(
            padding: const EdgeInsets.all(9),
            itemBuilder: (context, index) {
              return widget.rentalOrigin == RentalOrigin.borrowed
                  ? BorrowedItemTile(itemRental: rentalSnapshots.data![index])
                  : LentItemTile(itemRental: rentalSnapshots.data![index]);
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 9);
            },
            itemCount: rentalSnapshots.data!.length,
          );
        });
  }
}
