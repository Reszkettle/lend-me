import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lendme/components/user_view.dart';
import 'package:lendme/models/item.dart';
import 'package:lendme/models/rental.dart';
import 'package:lendme/repositories/rental_repository.dart';
import 'package:lendme/utils/constants.dart';

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

  Widget _buildFromRental(
      BuildContext context, AsyncSnapshot<Rental?> rentalSnap) {
    final rental = rentalSnap.data;

    if (rental == null) {
      return Container();
    } else {
      return _mainLayout(context, rental);
    }
  }

  Column _mainLayout(BuildContext context, Rental rental) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(rental),
        const SizedBox(height: 16),
        _borrowTimes(rental),
        const SizedBox(height: 16),
        UserView(userId: rental.ownerId),
        const SizedBox(height: 16),
        _buttons(context),
      ],
    );
  }

  Widget _borrowTimes(Rental rental) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SizedBox(
              width: 60,
              child: Text('From: '),
            ),
            Text(dateTimeFormat.format(rental.startDate.toDate())),
          ],
        ),
        Row(
          children: [
            const SizedBox(
              width: 60,
              child: Text('To: '),
            ),
            Text(dateTimeFormat.format(rental.endDate.toDate())),
          ],
        ),
      ],
    );
  }

  Widget _header(Rental rental) {
    return Row(
      children: [
        RichText(
          text: TextSpan(
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              children: [
                const TextSpan(text: 'Status: Borrowed from '),
                TextSpan(text: rental.ownerFullname)
              ]),
        ),
      ],
    );
  }

  Row _buttons(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton.icon(
          label: const Text('Extend time'),
          icon: const Icon(Icons.more_time),
          style: OutlinedButton.styleFrom(
              primary: Colors.white,
              side: const BorderSide(width: 1.0, color: Colors.white)),
          onPressed: () {
            // TODO: Extend time
          },
        ),
        const SizedBox(width: 16),
        OutlinedButton.icon(
          label: const Text('Transfer loan'),
          icon: const Icon(Icons.local_shipping),
          style: OutlinedButton.styleFrom(
              primary: Colors.white,
              side: const BorderSide(width: 1.0, color: Colors.white)),
          onPressed: () {
            Navigator.of(context).pushNamed('/lent_qr', arguments: item);
          },
        ),
      ],
    );
  }
}
