import 'package:flutter/material.dart';
import 'package:lendme/components/rentals_list.dart';
import 'package:lendme/repositories/rental_repository.dart';
import 'package:lendme/services/auth_service.dart';
import 'package:lendme/utils/ui/enums.dart';

class Lent extends StatefulWidget {
  const Lent({Key? key}) : super(key: key);

  @override
  _LentState createState() => _LentState();
}

class _LentState extends State<Lent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: null,
        body: RentalsList(
            rentalsStream: RentalRepository()
                .getStreamOfLentItemsWithRentals(AuthService().getUid()!),
            rentalOrigin: RentalOrigin.lent));
  }
}
