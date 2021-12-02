import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lendme/exceptions/exceptions.dart';
import 'package:lendme/models/request.dart';
import 'package:lendme/models/user.dart';
import 'package:lendme/screens/requests/handlers.dart';

class AcceptRejectPanel extends StatefulWidget {
  AcceptRejectPanel({required this.request, required this.user, Key? key}):
        super(key: key);

  final Request request;
  final User user;

  final RequestHandlers handlers = RequestHandlers();

  @override
  _AcceptRejectPanelState createState() => _AcceptRejectPanelState();
}

class _AcceptRejectPanelState extends State<AcceptRejectPanel> {

  bool _pendingOperation = false;

  @override
  Widget build(BuildContext context) {
    return _pendingOperation ? _spinner() : _buttons();
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
      await widget.handlers.accept(widget.request, widget.user);
      Navigator.of(context).pop();
    } catch (e) {
      // Do nothing, no time to implement
    } finally {
      setPending(false);
    }
  }

  Future _performReject() async {
    try {
      setPending(true);
      await widget.handlers.reject(widget.request, widget.user);
      Navigator.of(context).pop();
    } catch (e) {
      // Do nothing, no time to implement
    } finally {
      setPending(false);
    }
  }

  void setPending(bool pending) {
    setState(() {
      _pendingOperation = pending;
    });
  }

}
