import 'package:flutter/material.dart';
import 'package:lendme/components/user_view.dart';
import 'package:lendme/models/item.dart';
import 'package:lendme/models/rental.dart';
import 'package:lendme/models/request.dart';
import 'package:lendme/models/request_type.dart';
import 'package:lendme/models/user.dart';
import 'package:lendme/repositories/rental_repository.dart';
import 'package:lendme/utils/constants.dart';

class RequestPanel extends StatelessWidget {
  const RequestPanel({required this.request, required this.user,
    required this.item, Key? key}) : super(key: key);

  final Request request;
  final User user;
  final Item? item;

  @override
  Widget build(BuildContext context) {
    return _mainLayout();
  }

  Widget _mainLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(),
        if(request.type == RequestType.transfer)
          _fromUser(),
        if(request.type == RequestType.extend && item != null)
          _FromTime(itemId: item!.id!),
        _toTime(),
        if(request.requestMessage != null && request.requestMessage!.isNotEmpty)
          _message()
      ],
    );
  }

  Widget _title() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              _titleContent(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  String _titleContent() {
    if(request.type == RequestType.borrow) {
      return 'Borrow item';
    } else if(request.type == RequestType.extend) {
      return 'Extend borrowing time';
    } else if(request.type == RequestType.transfer) {
      return 'Transfer item to me';
    } else {
      return '';
    }
  }

  Widget _toTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "To time:",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(dateTimeFormat.format(request.endDate.toDate())),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _fromUser() {
    final ownerId = item?.ownerId;
    if(ownerId == null) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "From user:",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        UserView(userId: ownerId),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _message() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Justification message:",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(request.requestMessage ?? ''),
      ],
    );
  }

}


class _FromTime extends StatelessWidget {
  _FromTime({required this.itemId, Key? key}) : super(key: key);

  final String itemId;
  final RentalRepository _rentalRepository = RentalRepository();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _rentalRepository.getItemActiveRentalStream(itemId),
      builder: (BuildContext context, AsyncSnapshot<Rental?> rentalSnap) {
        final rental = rentalSnap.data;
        if(rental == null) {
          return Container();
        }
        return _buildWithRental(context, rental);
      },
    );
  }

  Widget _buildWithRental(BuildContext context, Rental rental) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "From time:",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(dateTimeFormat.format(rental.startDate.toDate())),
        const SizedBox(height: 8),
      ],
    );
  }
}
