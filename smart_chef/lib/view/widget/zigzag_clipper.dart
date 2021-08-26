import 'package:flutter/material.dart';

class ZigZag extends StatelessWidget {
  final Widget child;
  final bool isMaxHeight;

  const ZigZag({Key key, this.isMaxHeight, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ZigZagClipper(isMaxHeight),
      child: child,
    );
  }
}

class ZigZagClipper extends CustomClipper<Path> {
  bool isMaxHeight;

  ZigZagClipper(this.isMaxHeight);

  @override
  Path getClip(Size size) {
    Path path = Path();
    createPointedTriangle(size, path);

    path.close();
    return path;
  }

  createPointedTriangle(Size size, Path path) {
    path.lineTo(0, size.height);

    var curXPos = 0.0;
    var curYPos = size.height;
    var increment = size.width / 25;
    while (curXPos < size.width) {
      curXPos += increment;
      curYPos = curYPos == size.height ? size.height - 20 : size.height;
      path.lineTo(curXPos, isMaxHeight ? curYPos : size.height);
    }
    path.lineTo(size.width, 0);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
