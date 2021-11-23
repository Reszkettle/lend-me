import 'package:flutter/material.dart';
import 'package:lendme/models/item.dart';
import 'package:lendme/models/rental.dart';
import 'package:lendme/repositories/rental_repository.dart';

class PanelBorrowed extends StatelessWidget {
  PanelBorrowed({required this.item, Key? key}) : super(key: key);

  final Item item;

  final RentalRepository _rentalRepository = RentalRepository();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _rentalRepository.getItemActiveRentalStream(item.id!),
      builder: _buildFromRental,
    );
  }

  Widget _buildFromRental(BuildContext context, AsyncSnapshot<Rental?> rentalSnap) {
    final rental = rentalSnap.data;

    return Column(
      children: const [
        Text("Status: Borrowed",
            style: TextStyle(
              fontSize: 16,
            )
        )
      ],
    );
  }
}
