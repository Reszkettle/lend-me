import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lendme/components/user_view.dart';
import 'package:lendme/models/item.dart';
import 'package:lendme/models/rental.dart';
import 'package:lendme/repositories/rental_repository.dart';
import 'package:lendme/repositories/request_repository.dart';
import 'package:lendme/utils/constants.dart';
import 'package:lendme/utils/error_snackbar.dart';
import 'package:lendme/services/auth_service.dart';
import 'package:lendme/models/request.dart';
import 'package:lendme/models/request_type.dart';
import 'package:lendme/models/request_status.dart';
import 'package:lendme/exceptions/exceptions.dart';

import 'extend_dialog.dart';

class PanelBorrowed extends StatelessWidget {
  PanelBorrowed({required this.item, Key? key}) : super(key: key);

  final Item item;

  final RentalRepository _rentalRepository = RentalRepository();
  final RequestRepository _requestRepository = RequestRepository();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _rentalRepository.getItemActiveRentalStream(item.id!),
      builder: (BuildContext context, AsyncSnapshot<Rental?> rentalSnap) {
        final rental = rentalSnap.data;
        if (rental == null) {
          return const Text("Rental is null");
        }
        return StreamBuilder(
          stream: _requestRepository.userHasPendingRequestsForThisItemStream(rental.itemId),
          builder: (BuildContext context, AsyncSnapshot<bool> hasPendingRequestsSnap) {
            final hasPendingRequests = hasPendingRequestsSnap.data;
            if (hasPendingRequests == null) {
              return const Text("hasPendingRequests is null");
            }
            return _mainLayout(context, rental, hasPendingRequests);
          },
        );
      },
    );
  }

  Column _mainLayout(BuildContext context, Rental rental, bool hasPendingRequests) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(rental),
        _borrowTimes(rental),
        _currentItemOwner(rental),
        _buttonsOrNot(context, hasPendingRequests),
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
              children: [const TextSpan(text: 'Status: Borrowed from '), TextSpan(text: rental.ownerFullname)]),
        ),
      ],
    );
  }

  Widget _buttonsOrNot(BuildContext context, bool hasPendingRequests) {
    if (!hasPendingRequests) {
      return _buttons(context);
    } else {
      return _notButtons();
    }
  }

  Widget _buttons(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: OutlinedButton.icon(
                label: const Text('Extend time'),
                icon: const Icon(Icons.more_time),
                style: OutlinedButton.styleFrom(primary: Colors.white, side: const BorderSide(width: 1.0, color: Colors.white)),
                onPressed: () {
                  _showExtendDialog(item, context);
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton.icon(
                label: const Text('Transfer loan'),
                icon: const Icon(Icons.local_shipping),
                style: OutlinedButton.styleFrom(primary: Colors.white, side: const BorderSide(width: 1.0, color: Colors.white)),
                onPressed: () {
                  Navigator.of(context).pushNamed('/lent_qr', arguments: item);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showExtendDialog(Item item, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return ExtendDialog(item, context);
        });
  }

  Widget _notButtons() {
    return Column(
      children: [
        const SizedBox(height: 32),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "You have pending request about this item",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Wait for decision before requesting again",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
