import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lendme/exceptions/exceptions.dart';
import 'package:lendme/models/request.dart';
import 'package:lendme/models/user.dart';
import 'package:lendme/repositories/request_repository.dart';

class AcceptRejectPanel extends StatefulWidget {
  AcceptRejectPanel({required this.request, required this.user, Key? key}):
        super(key: key);

  final Request request;
  final User user;

  final RequestRepository _requestRepository = RequestRepository();

  @override
  _AcceptRejectPanelState createState() => _AcceptRejectPanelState();
}

class _AcceptRejectPanelState extends State<AcceptRejectPanel> {

  bool _pendingOperation = false;
  TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return _pendingOperation ? _spinner() : _mainLayout();
  }

  Widget _mainLayout() {
    return Column(
      children: [
        _buttons(),
        const SizedBox(height: 12),
        _messageArea(),
      ],
    );
  }

  Widget _buttons() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 60,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.thumb_up_rounded),
              label: const Text('Accept'),
              style: ElevatedButton.styleFrom(
                  primary: Colors.green
              ),
              onPressed: () async => _performAccept(),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SizedBox(
            height: 60,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.thumb_down_rounded),
              label: const Text('Reject'),
              style: ElevatedButton.styleFrom(
                  primary: Colors.red
              ),
              onPressed: () async => _performReject(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _messageArea() {
    return Row(
      children: <Widget>[
        Flexible(
          child: TextFormField(
            controller: _messageController,
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2.0,
                  ),
                ),
                alignLabelWithHint: true,
                border: const OutlineInputBorder(),
                labelText: 'Justification'),
            keyboardType: TextInputType.multiline,
            minLines: 3,
            maxLines: null,
          ),
        ),
      ],
    );
  }

  Widget _spinner() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        SizedBox(
          height: 60,
          width: 60,
          child: CircularProgressIndicator(),
        ),
      ],
    );
  }

  Future _performAccept() async {
    try {
      setPending(true);
      await widget._requestRepository.acceptRequest(widget.request.id!, _getMessage());
    } on DomainException catch (e) {
      print("Error: ${e.message}");
    } finally {
      setPending(false);
    }
  }

  Future _performReject() async {
    try {
      setPending(true);
      await widget._requestRepository.rejectRequest(widget.request.id!, _getMessage());
    } on DomainException catch (e) {
      print("Error: ${e.message}");
    } finally {
      setPending(false);
    }
  }

  String? _getMessage() {
    final text = _messageController.text;
    return text.isEmpty ? null : text;
  }

  void setPending(bool pending) {
    setState(() {
      _pendingOperation = pending;
    });
  }

}
