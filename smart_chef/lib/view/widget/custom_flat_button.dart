import 'package:flutter/material.dart';

class CustomFlatButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Color color;

  const CustomFlatButton({
    Key key,
    this.onPressed,
    this.color,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: 50,
      child: FlatButton(
        child: child,
        onPressed: onPressed,
        color: color ?? Colors.red,
        disabledColor: Colors.grey[300],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(37),
          ),
        ),
      ),
    );
  }
}
