import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:lendme/screens/home/home.dart';
import 'package:provider/provider.dart';
import 'package:lendme/services/auth_service.dart';
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
  final RequestRepository _requestRepository = RequestRepository();

  String date = "";
  DateTime selectedDate = DateTime.now();
  String value = "";

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
    return Column(children: [
      const SizedBox(height: 16.0),
      _itemImage(context, item),
      const SizedBox(height: 16.0),
      _title(item),
      if (item?.description != null) _description(context, item),
      const SizedBox(height: 30.0),
      _borrow(context, item)
    ]);
  }

  Widget _borrow(BuildContext context, Item? item) {
    return Container(
        margin: const EdgeInsets.all(5.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.blue,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text("Borrow"),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _selectDate(context);
                  },
                  child: const Text("Choose Date"),
                ),
                Text(
                    "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"),
              ],
            ),

            TextField(
              onChanged: (text) {
                value = text;
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'Enter message to owner of item',
                hintText: value,
              ),
            ),
            //Text(value),
            _borrowButton(item),
          ],
        ));
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
      });
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
    showConfirmDialog(
        context: context,
        message:
            'Are you sure that you want to borrow ${item.title} from ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} to ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}?',
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

  void _borrowItem(Item item) async {
    var issuerId = AuthService().getUid();
    final requestInfo = Request(
        endDate: Timestamp.fromDate(selectedDate),
        issuerId: issuerId.toString(),
        itemId: widget.itemId,
        requestMessage: value,
        status: RequestStatus.pending,
        type: RequestType.borrow);

    try {
      await _requestRepository.addRequest(requestInfo);
    } on DomainException catch (e) {
      showErrorSnackBar(context, "Failed to send request ${e.message}");
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Send request to owner"),
    ));

    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }
}
