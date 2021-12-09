import 'package:flutter/material.dart';

// Helper method to release from necessity of wrapping ConfirmDialog
// into showDialog every time
void showConfirmDialog({
  required BuildContext context,
  required String message,
  VoidCallback? yesCallback,
  VoidCallback? noCallback}
  ) {
  showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return ConfirmDialog(
          message: message,
          yesCallback: yesCallback,
          noCallback: noCallback,
        );
      });
}

// Dialog with message, yes and no buttons
class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({required this.message, this.yesCallback, this.noCallback, Key? key}) : super(key: key);

  final String message;
  final VoidCallback? yesCallback;
  final VoidCallback? noCallback;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Please Confirm'),
      content: Text(message),
      actions: [
        TextButton(
            onPressed: () {
              noCallback?.call();
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: const Text('No')),
        TextButton(
            onPressed: () {
              yesCallback?.call();
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: const Text('Yes'))
      ],
    );
  }
}



