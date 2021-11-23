import 'package:flutter/material.dart';
import 'package:lendme/components/rentals_list.dart';
import 'package:lendme/repositories/rental_repository.dart';
import 'package:lendme/services/auth_service.dart';
import 'package:lendme/utils/ui/enums.dart';

class Borrowed extends StatefulWidget {
  const Borrowed({Key? key}) : super(key: key);

  @override
  _BorrowedState createState() => _BorrowedState();
}

class _BorrowedState extends State<Borrowed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: null,
        body: RentalsList(
            rentalsStream: RentalRepository()
                .getStreamOfBorrowedItemsWithRentals(AuthService().getUid()!),
            rentalOrigin: RentalOrigin.borrowed));
  }
}
