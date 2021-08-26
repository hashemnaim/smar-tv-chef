import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final Color color;
  final Color backgroundColor;
  final double value;
  final double stroke;
  final double height;
  final double width;
  final EdgeInsets margin;

  const LoadingIndicator({
    Key key,
    this.color,
    this.value,
    this.backgroundColor,
    this.stroke,
    this.width,
    this.height,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: height ?? 18,
        width: width ?? 18,
        margin: margin ?? EdgeInsets.all(16),
        child: CircularProgressIndicator(
          value: value,
          strokeWidth: stroke ?? 5,
          valueColor: AlwaysStoppedAnimation<Color>(color ?? Colors.white),
          backgroundColor: backgroundColor,
        ),
      ),
    );
  }
}
