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
      builder: (BuildContext context, AsyncSnapshot<Rental?> rentalSnap) {
        final rental = rentalSnap.data;
        if(rental == null) {
          return const Text("Rental is null");
        }
        return _mainLayout(context, rental);
      },
    );
  }

  Column _mainLayout(BuildContext context, Rental rental) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(rental),
        _borrowTimes(rental),
        _currentItemOwner(rental),
        _buttons(context),
      ],
    );
  }

  Widget _borrowTimes(Rental rental) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
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

  Widget _currentItemOwner(Rental rental) {
    return Column(
      children: [
        const SizedBox(height: 16),
        UserView(userId: rental.ownerId),
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

  Widget _buttons(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Row(
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
        ),
      ],
    );
  }
}
