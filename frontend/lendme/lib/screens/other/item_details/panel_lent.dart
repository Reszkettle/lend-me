import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lendme/components/confirm_dialog.dart';
import 'package:lendme/components/user_view.dart';
import 'package:lendme/exceptions/exceptions.dart';
import 'package:lendme/models/item.dart';
import 'package:lendme/models/rental.dart';
import 'package:lendme/repositories/rental_repository.dart';
import 'package:lendme/utils/constants.dart';
import 'package:lendme/utils/error_snackbar.dart';

class PanelLent extends StatelessWidget {
  PanelLent({required this.item, Key? key}) : super(key: key);

  final Item item;

  final RentalRepository _rentalRepository = RentalRepository();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _rentalRepository.getItemActiveRentalStream(item.id!),
      builder: (BuildContext context, AsyncSnapshot<Rental?> rentalSnap) {
        final rental = rentalSnap.data;
        if(rental == null) {
          return const Text("Item is lent, but any rental found");
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
        _lentTimes(rental),
        _user(rental),
        _buttons(context, rental),
      ],
    );
  }

  Widget _lentTimes(Rental rental) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SizedBox(height: 16),
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

  Widget _user(Rental rental) {
    return Column(
      children: [
        const SizedBox(height: 16),
        UserView(userId: rental.borrowerId),
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

  Widget _buttons(BuildContext context, Rental rental) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Row(
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
                  _showConfirmReturnEnsureDialog(context, rental);
                },
              )
            ],
          ),
      ],
    );
  }

  void _showConfirmReturnEnsureDialog(BuildContext context, Rental rental) {
    showConfirmDialog(
        context: context,
        message: 'Are you sure that this item was returned?',
        yesCallback: () => _confirmReturn(context, rental)
    );
  }

  void _confirmReturn(BuildContext context, Rental rental) async {
    try {
      await _rentalRepository.returnItemById(rental.id.toString());
    } on DomainException catch (e) {
      showErrorSnackBar(context,
          "Failed to confirm return item. ${e.message}  Rental id: ${rental.id
              .toString()}");
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Item return"),
    ));
    Navigator.pop(context);
    //}
  }
}

