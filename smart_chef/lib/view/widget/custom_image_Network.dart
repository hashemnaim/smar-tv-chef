
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomerImageNetwork extends StatelessWidget {
  final String urlImage;
  final double widthNumber;
  final double heigthNumber;
  final double borderRadius;
  final bool circle;
  final Color borderColor;
  CustomerImageNetwork(
      this.urlImage, this.heigthNumber, this.widthNumber, this.borderRadius,
      {this.circle = true, this.borderColor = Colors.amber});
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: urlImage,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          // border: Border.all(color: borderColor),
        ),
        child: circle
            ? CircleAvatar(
                backgroundImage:
                    CachedNetworkImageProvider( urlImage),
                maxRadius: borderRadius,
              )
            : Container(
                width: widthNumber,
                height: heigthNumber,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
      ),
      placeholder: (context, url) => Center(
          child: circle
              ? CircleAvatar(
                  backgroundImage: ExactAssetImage("assets/logo.png"),
                  maxRadius: borderRadius,
                )
              : Container(
                  width: widthNumber,
                  height: heigthNumber,
                  child: Image.asset("assets/logo.png"))),
      errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
    );
  }
}
