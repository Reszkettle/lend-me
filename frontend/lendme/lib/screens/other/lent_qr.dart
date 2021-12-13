import 'package:flutter/material.dart';
import 'package:lendme/components/background.dart';
import 'package:lendme/models/item.dart';

//qr flutter
import 'package:qr_flutter/qr_flutter.dart';


class LentQr extends StatelessWidget {
  const LentQr({required this.item, Key? key}) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            title: Text('Lent item: ' + item.title),
            elevation: 0.0
        ),
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: //Text("QR code for item ${item.id}"),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("${item.title}"),
              QrImage(
                backgroundColor: Colors.white,
                data: "${item.id}",
              ),
            ],
          ),
        ),
      ),
    );
  }
}


