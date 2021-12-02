
import 'package:flutter/material.dart';
import 'package:lendme/components/circle_image.dart';

// Widget that shows user avatar in circle with border
// Url param may be network address (prefixed with http) or path to file in local storage
class Avatar extends StatelessWidget {
  const Avatar({required this.url, this.size=50.0, Key? key}) : super(key: key);

  final String? url;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CircleImage(
        url: url,
        defaultImage: "assets/images/user_default.png",
        size: size
    );
  }
}
