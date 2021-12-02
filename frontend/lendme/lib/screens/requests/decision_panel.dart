import 'package:flutter/material.dart';
import 'package:lendme/models/item.dart';
import 'package:lendme/models/request.dart';
import 'package:lendme/models/request_status.dart';
import 'package:lendme/models/user.dart';
import 'package:lendme/screens/requests/accept_reject_panel.dart';

class RequestDecisionPanel extends StatelessWidget {
  const RequestDecisionPanel({required this.request, required this.user,
    required this.item, Key? key}) : super(key: key);

  final Request request;
  final User user;
  final Item item;

  @override
  Widget build(BuildContext context) {
    return _showProperView();
  }

  Widget _showProperView() {
    if(request.status == RequestStatus.pending) {
      final isDecisivePerson = user.uid == item.ownerId;
      return isDecisivePerson ? _pendingDecisiveState() : _pendingView();
    } else if (request.status == RequestStatus.accepted) {
      return _acceptedView();
    } else {
      return _rejectedView();
    }
  }

  Widget _pendingView() {
    return _genericView(
        text: "Pending",
        backgroundColor: Colors.grey,
        textColor: Colors.black,
        message: null,
    );
  }

  Widget _acceptedView() {
    return _genericView(
        text: "Accepted",
        backgroundColor: Colors.green,
        textColor: Colors.black,
        message: request.responseMessage,
    );
  }

  Widget _rejectedView() {
    return _genericView(
        text: "Rejected",
        backgroundColor: Colors.red,
        textColor: Colors.black,
        message: request.responseMessage,
    );
  }

  Widget _genericView({required String text, required Color backgroundColor,
    required Color textColor, String? message}) {
    return Container(
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                )
              ),
            ],
          ),
          if(message != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const Text(
                  "Justification message:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(message),
              ],
            )
        ],
      ),
    );
  }

  Widget _responseMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Justification message:",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(request.responseMessage ?? ''),
      ],
    );
  }

  Widget _pendingDecisiveState() {
    return AcceptRejectPanel(
      request: request,
      user: user,
    );
  }

}
