import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lendme/components/confirm_dialog.dart';
import 'package:lendme/components/loadable_area.dart';
import 'package:lendme/models/item.dart';
import 'package:lendme/models/request.dart';
import 'package:lendme/models/request_status.dart';
import 'package:lendme/models/request_type.dart';
import 'package:lendme/models/user.dart';
import 'package:lendme/repositories/item_repository.dart';
import 'package:lendme/repositories/request_repository.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lendme/models/rental.dart';
import 'package:lendme/services/auth_service.dart';
import 'package:lendme/repositories/rental_repository.dart';
import 'package:lendme/repositories/user_repository.dart';
import 'package:lendme/exceptions/exceptions.dart';
import 'package:lendme/utils/error_snackbar.dart';

class ItemDetails extends StatefulWidget {
  const ItemDetails({Key? key, required this.itemId}) : super(key: key);

  final String itemId;

  @override
  _ItemDetailsState createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  final ItemRepository _itemRepository = ItemRepository();
  final RentalRepository _rentalRepository = RentalRepository();
  final UserRepository _userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _itemRepository.getItemStream(widget.itemId),
      builder: _buildFromItem,
    );
  }

  Widget _buildFromItem(BuildContext context, AsyncSnapshot<Item?> itemSnap) {
    final item = itemSnap.data;

    final user = Provider.of<User?>(context);
    if (user == null) {
      return Container();
    }

    return Scaffold(
      appBar: AppBar(
          title: Row(
            children: [
              const Text('Item: '),
              if (item != null) Text(item.title),
            ],
          ),
          elevation: 0.0),
      body: LoadableArea(
          initialState:
              item == null ? LoadableAreaState.loading : LoadableAreaState.main,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16.0, top: 0, bottom: 16.0),
              child: _mainLayout(context, item),
            ),
          )),
    );
  }

  Widget _mainLayout(BuildContext context, Item? item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _itemImage(context, item),
        const SizedBox(height: 16.0),
        _title(item),
        if (item?.description != null) _description(context, item),
        const SizedBox(height: 16.0),
        _borrowButton(item),
      ],
    );
  }

  Widget _itemImage(BuildContext context, Item? item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 3,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: item?.imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: item?.imageUrl ?? '',
                      height: 200,
                      fit: BoxFit.fitHeight,
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error, size: 45))
                  : Image.asset(
                      'assets/images/item_default.jpg',
                      height: 200,
                    )),
        )
      ],
    );
  }

  Widget _title(Item? item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          item?.title ?? '',
          style: const TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _description(BuildContext context, Item? item) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: ExpansionTile(
            title: const Text('Description'),
            textColor: Colors.black,
            iconColor: Colors.black,
            collapsedIconColor: Colors.black,
            childrenPadding: const EdgeInsets.all(0),
            children: <Widget>[
              ListTile(title: Text(item?.description ?? '')),
            ],
          ),
        ),
      ],
    );
  }

  void _showBorrowDialog(Item item) {
    //_borrowItem(item);
    showConfirmDialog(
        context: context,
        message: 'Are you sure that you want to borrow this item?',
        yesCallback: () => _borrowItem(item));
  }

  Widget _borrowButton(Item? item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
          onPressed: () {
            if (item != null) {
              _showBorrowDialog(item);
            }
          },
          child: const Text('Borrow'),
        ),
      ],
    );
  }

  Future<void> createTransferRequest(
      Item item, Timestamp endDate, String? requestMessage) async {
    final request = Request(
        endDate: endDate,
        issuerId: AuthService().getUid()!,
        itemId: item.id!,
        status: RequestStatus.pending,
        type: RequestType.transfer,
        requestMessage: requestMessage);

    await RequestRepository().addRequest(request);
  }

  void _borrowItem(Item item) async {
    var today = DateTime.now();
    final String borrowerId = AuthService().getUid()!;

    var end = today.add(const Duration(days: 30));

    const String requestMessage = "To be populated from modal";

    // Checking whether item is already on loan
    if (item.lentById != null) {
      await createTransferRequest(
          item, Timestamp.fromDate(end), requestMessage);
    }

    await _itemRepository.setLentById(widget.itemId, borrowerId.toString());

    final itemInfo = Rental(
        borrowerId: borrowerId.toString(),
        ownerId: item.ownerId.toString(),
        itemId: widget.itemId,
        startDate: Timestamp.fromDate(today),
        endDate: Timestamp.fromDate(end),
        status: "pending");

    try {
      await _rentalRepository.addBorrow(itemInfo);
    } on DomainException catch (e) {
      showErrorSnackBar(context, "Failed to borrow Item. ${e.message}");
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Item borrowed"),
    ));
    Navigator.pop(context);
    //}
  }
}
