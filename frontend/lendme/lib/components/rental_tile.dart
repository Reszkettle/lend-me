import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lendme/models/item.dart';
import 'package:lendme/models/rental.dart';
import 'base_tile.dart';

class RentalTile extends StatefulWidget {
  final Rental rental;
  final Item item;
  const RentalTile({Key? key, required this.rental, required this.item}) : super(key: key);

  @override
  _RentalTileState createState() => _RentalTileState();
}

class _RentalTileState extends State<RentalTile> {


  @override
  Widget build(BuildContext context) {
    return BaseTile(
        backgroundColor: getBackgroundColor(),
        title: widget.rental.borrowerFullname  == null ? "Unknown" : widget.rental.borrowerFullname !,
        subtitle: widget.rental.startDate == null
            ? "Unknown"
            : "From: " + widget.rental.startDate.toDate().day.toString()+"/" + widget.rental.startDate.toDate().month.toString()+"/"+widget.rental.startDate.toDate().year.toString(),
        thirdLine: widget.rental.endDate == null
            ? "Unknown"
            : "Till: " + widget.rental.endDate.toDate().day.toString()+"/" + widget.rental.endDate.toDate().month.toString()+"/"+widget.rental.endDate.toDate().year.toString(),
        imageUrl: widget.item.imageUrl);
  }

  Color getBackgroundColor() {
    switch (widget.rental.status) {
      case "pending" :
        return Colors.white;
      default:
        return Colors.black12;
    }
  }

}