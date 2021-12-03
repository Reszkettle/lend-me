import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CircleImage extends StatelessWidget {
  const CircleImage({required this.url, required this.defaultImage, this.size=50.0, Key? key}) : super(key: key);

  final String? url;
  final double size;
  final String defaultImage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
          child: ClipOval(
            child: SizedBox(
              width: size,
              height: size,
              child: properImage(),
            ),
          ),
        ),
      ],
    );
  }

  Widget properImage() {
    final fUrl = url;
    if(fUrl == null) {
      return placeholderImage();
    } else if(fUrl.startsWith("http")) {
      return networkImage(fUrl);
    } else {
      return fileImage(fUrl);
    }
  }

  Widget fileImage(String url) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: FileImage(File(url)),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget networkImage(String url) {
    return CachedNetworkImage(
        imageUrl: url,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        placeholder: (context, url) {
          return Stack(
            children: [
              placeholderImage(),
              const Positioned(
                left: 10,
                right: 10,
                top: 10,
                bottom: 10,
                child: CircularProgressIndicator(),
              ),
            ],
          );
        },
        errorWidget: (context, url, error) =>
        const Icon(Icons.error, size: 45)
    );
  }

  Widget placeholderImage() {
    return Image.asset(
      defaultImage,
      fit: BoxFit.cover,
    );
  }
}
