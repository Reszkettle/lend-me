import 'package:flutter/material.dart';
import 'package:lendme/models/item.dart';

class PanelAvailable extends StatelessWidget {
  const PanelAvailable({required this.item, Key? key}) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return _mainLayout(context);
  }

  Column _mainLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(),
        _buttons(context),
      ],
    );
  }

  Widget _header() {
    return Row(
      children: const [
        Text("Status: Available",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            )),
      ],
    );
  }

  Widget _buttons(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              child: OutlinedButton.icon(
                label: const Text('Lend'),
                icon: const Icon(Icons.qr_code_rounded),
                style: OutlinedButton.styleFrom(
                    primary: Colors.white,
                    side: const BorderSide(width: 1.0, color: Colors.white)),
                onPressed: () {
                  Navigator.of(context).pushNamed('/lent_qr', arguments: item);
                },
              ),
            )
          ],
        ),
      ],
    );
  }

}
