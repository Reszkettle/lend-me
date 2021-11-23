import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lendme/components/user_view.dart';
import 'package:lendme/models/item.dart';
import 'package:lendme/models/rental.dart';
import 'package:lendme/repositories/rental_repository.dart';

class PanelLent extends StatelessWidget {
  PanelLent({required this.item, Key? key}) : super(key: key);

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

    if(rental == null) {
      return Container();
    } else {
      return _mainLayout(rental);
    }
  }

  Column _mainLayout(Rental rental) {
    return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _header(rental),
      const SizedBox(height: 16),
      _LentTimes(rental),
      const SizedBox(height: 16),
      UserView(userId: rental.borrowerId, showContactButtons: true),
      const SizedBox(height: 16),
      _buttons(),
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
              const TextSpan(text: 'Status: Lent to '),
              TextSpan(text: rental.borrowerFullname)
            ]
          ),
        ),
      ],
    );
  }

  Row _buttons() {
    return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton.icon(
            label: const Text('Confirm return'),
            icon: const Icon(Icons.done_rounded),
            style: OutlinedButton.styleFrom(
              primary: Colors.white,
              side: const BorderSide(width: 1.0, color: Colors.white)
            ),
            onPressed: () {
              // TODO: Confirm return
            },
          )
        ],
      );
  }
}

class _LentTimes extends StatelessWidget {
  _LentTimes(this.rental, {Key? key}) : super(key: key);

  final Rental rental;
  final DateFormat format = DateFormat('yyyy/MM/dd kk:mm');

  @override
  Widget build(BuildContext context) {
    String start = format.format(rental.startDate.toDate());
    String end = format.format(rental.endDate.toDate());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SizedBox(
              width: 100,
              child: Text('Lent from: '),
            ),
            Text(start),
          ],
        ),
        Row(
          children: [
            const SizedBox(
              width: 100,
              child: Text('Lent to: '),
            ),
            Text(end),
          ],
        ),
      ],
    );
  }
}
