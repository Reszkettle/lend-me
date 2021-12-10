import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lendme/models/item.dart';
import 'package:lendme/models/request.dart';
import 'package:lendme/models/request_status.dart';
import 'package:lendme/models/request_type.dart';
import 'package:lendme/repositories/request_repository.dart';
import 'package:lendme/services/auth_service.dart';
import 'package:lendme/utils/error_snackbar.dart';

Widget ExtendDialog(Item item, BuildContext context) {
  TextEditingController dateController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  Timestamp? timestamp;
  return AlertDialog(
    title: const Text('Extend Time'),

    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: dateController,
          decoration: const InputDecoration(
            labelText: "Extend till date:",
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
        const SizedBox(height: 32),
        TextFormField(
          controller: messageController,
          decoration: const InputDecoration(
            labelText: "Message:",
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

              _extendTime(item, timestamp!, messageController.text);
              Navigator.of(context, rootNavigator: true).pop();
            }
          },
          child: const Text('Confirm'))
    ],
  );
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