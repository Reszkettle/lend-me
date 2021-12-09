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
            OutlinedButton.icon(
              label: const Text('Extend time'),
              icon: const Icon(Icons.more_time),
              style: OutlinedButton.styleFrom(primary: Colors.white, side: const BorderSide(width: 1.0, color: Colors.white)),
              onPressed: () {
                _showExtendDialog(item, context);
              },
            ),
            const SizedBox(width: 16),
            OutlinedButton.icon(
              label: const Text('Transfer loan'),
              icon: const Icon(Icons.local_shipping),
              style: OutlinedButton.styleFrom(primary: Colors.white, side: const BorderSide(width: 1.0, color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pushNamed('/lent_qr', arguments: item);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _ExtendDialog(Item item, BuildContext context) {
    TextEditingController dateController = TextEditingController();
    TextEditingController messageController = TextEditingController();
    late Timestamp timestamp;
    return AlertDialog(
      title: const Text('Choose Date'),
      content: Column(
        children: [
          TextFormField(
            controller: dateController,
            decoration: const InputDecoration(
              labelText: "Extend till",
            ),
            onTap: () async {
              DateTime? date = DateTime.now();
              FocusScope.of(context).requestFocus(FocusNode());

              date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2100));
              if (date != null) {
                timestamp = Timestamp.fromDate(date);
                dateController.text = DateFormat('dd-MM-yyyy').format(date);
              }
            },
          ),
          TextFormField(
            controller: messageController,
            decoration: const InputDecoration(
              labelText: "Message",
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: const Text('Cancel')),
        TextButton(
            onPressed: () {
              if (timestamp == null) {
                showErrorSnackBar(context, "Date cannot be empty");
                Navigator.of(context, rootNavigator: true).pop();
              } else {

                _extendTime(item, timestamp, messageController.text);
                Navigator.of(context, rootNavigator: true).pop();
              }
            },
            child: const Text('Confirm'))
      ],
    );
  }

  void _showExtendDialog(Item item, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return _ExtendDialog(item, context);
        });
  }

  void _extendTime(Item item, Timestamp timestamp, String requestMessage) async {

    await createExtendRequest(item, timestamp, requestMessage);

  }

  Future<void> createExtendRequest(Item item, Timestamp endDate, String? requestMessage) async {
    final request = Request(
        endDate: endDate,
        issuerId: AuthService().getUid()!,
        itemId: item.id!,
        status: RequestStatus.pending,
        type: RequestType.extend,
        requestMessage: requestMessage);

    await RequestRepository().addRequest(request);
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
