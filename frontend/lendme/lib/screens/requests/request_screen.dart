import 'package:flutter/material.dart';
import 'package:lendme/components/item_view.dart';
import 'package:lendme/components/user_view.dart';
import 'package:lendme/models/item.dart';
import 'package:lendme/models/request.dart';
import 'package:lendme/models/request_type.dart';
import 'package:lendme/models/user.dart';
import 'package:lendme/repositories/item_repository.dart';
import 'package:lendme/repositories/request_repository.dart';
import 'package:lendme/screens/requests/decision_panel.dart';
import 'package:lendme/screens/requests/request_panel.dart';
import 'package:provider/provider.dart';

class RequestScreen extends StatelessWidget {
  RequestScreen({required this.requestId, Key? key}) : super(key: key);

  final String requestId;
  final RequestRepository _requestRepository = RequestRepository();
  final ItemRepository _itemRepository = ItemRepository();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _requestRepository.getRequestStream(requestId),
      builder: (BuildContext context, AsyncSnapshot<Request?> requestSnap) {
        final request = requestSnap.data;
        final user = Provider.of<User?>(context);
        if(request == null || user == null) {
          return Container();
        }
        else {
          return StreamBuilder(
            stream: _itemRepository.getItemStream(request.itemId),
            builder: (BuildContext context, AsyncSnapshot<Item?> itemSnap) {
              final item = itemSnap.data;
              return buildFromData(context, request, user, item);
            },
          );
        }
      },
    );
  }

  Widget buildFromData(BuildContext context, Request request, User user, Item? item) {
    return Scaffold(
      appBar: AppBar(
          title: Text(_titleText(request)),
          elevation: 0.0
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: _mainLayout(context, request, user, item),
        ),
      ),
    );
  }

  Column _mainLayout(BuildContext context, Request request, User user, Item? item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _userPanel(context, request, user),
        _itemPanel(context, request),
        _requestPanel(context, request, user, item),
        if(item != null)
          _decisionPanel(context, request, user, item),
      ],
    );
  }
  
  String _titleText(Request request) {
    if(request.type == RequestType.borrow) {
      return 'Borrow request';
    } else if(request.type == RequestType.extend) {
      return 'Time extend request';
    } else {
      return 'Item transfer request';
    }
  }

  Widget _userPanel(BuildContext context, Request request, User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Requesting user",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          padding: const EdgeInsets.all(16),
          child: _userPanelContent(context, request, user),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _userPanelContent(BuildContext context, Request request, User user) {
    final requestedBeMe = request.issuerId == user.uid;
    if(requestedBeMe) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'You',
            style: TextStyle(
              fontSize: 40,
            ),
          ),
        ],
      );
    }
    else {
      return UserView(userId: request.issuerId);
    }
  }

  Widget _itemPanel(BuildContext context, Request request) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Item of interest",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          padding: const EdgeInsets.all(16),
          child: ItemView(itemId: request.itemId),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _requestPanel(BuildContext context, Request request, User user,
      Item? item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Request",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          padding: const EdgeInsets.all(16),
          child: RequestPanel(
            request: request,
            user: user,
            item: item,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _decisionPanel(BuildContext context, Request request, User user,
      Item item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Decision",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        RequestDecisionPanel(
          request: request,
          user: user,
          item: item,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

}
