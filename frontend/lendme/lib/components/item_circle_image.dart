import 'package:flutter/material.dart';

import 'circle_image.dart';

class ItemCricleImage extends StatelessWidget {
  const ItemCricleImage({required this.url, this.size=50.0, Key? key}) : super(key: key);

  final String? url;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CircleImage(
        url: url,
        defaultImage: "assets/images/item_default.jpg",
        size: size
    );
  }
}
