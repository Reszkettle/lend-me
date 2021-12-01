import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lendme/utils/constants.dart';

class BaseTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final String? thirdLine;
  final String? imageUrl;
  final Icon? icon;
  final GestureTapCallback? onTap;

  const BaseTile(
      {Key? key,
      required this.title,
      required this.subtitle,
      this.thirdLine,
      this.imageUrl,
      this.icon,
      this.onTap})
      : super(key: key);

  @override
  _BaseTileState createState() => _BaseTileState();
}

class _BaseTileState extends State<BaseTile> {

  final Color textColor = tileTextColor;
  final Color borderColor = tileBorderColor;
  final String fontFamily = 'Roboto';
  final BorderRadius tileBorderRadius = BorderRadius.circular(6);
  final BorderRadius imageBorderRadius = BorderRadius.circular(12);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        splashColor: darkPrimaryColor,
        onTap: () {},
        child: ListTile(
            shape: RoundedRectangleBorder(
                side: BorderSide(color: borderColor),
                borderRadius: tileBorderRadius),
            leading: ClipRRect(
                borderRadius: imageBorderRadius,
                child: widget.imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: widget.imageUrl!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.fitHeight,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error, size: 45))
                    : widget.icon),
            title: Text(widget.title,
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: fontFamily,
                    fontWeight: FontWeight.bold)),
            subtitle: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Wrap(direction: Axis.vertical, spacing: 5, children: [
                  Text(widget.subtitle,
                      style: TextStyle(
                          fontSize: widget.thirdLine != null ? 11 : 14,
                          fontFamily: fontFamily)),
                  if (widget.thirdLine != null)
                    Text(widget.thirdLine!,
                        style: TextStyle(fontSize: 11, fontFamily: fontFamily))
                ])),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            horizontalTitleGap: 13,
            onTap: widget.onTap));
  }
}
