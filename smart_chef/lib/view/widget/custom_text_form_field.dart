import 'package:flutter/material.dart';
import 'package:smart_chef/utils/colors.dart';


class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final Widget suffixIcon;
  final String hint;
  final IconData icon;
  final TextInputAction textInputAction;
  final FocusNode currentFocusNode;
  final FocusNode nextFocusNode;
  final bool obscureText;
  final TextInputType keyboardType;
  final FormFieldValidator<String> validator;
  final Color color;

  static const TextStyle _style = TextStyle(fontSize: 30, color: greyDEDEDE);

  const CustomTextFormField({
    Key key,
    this.controller,
    this.hint,
    this.icon,
    this.textInputAction,
    this.currentFocusNode,
    this.nextFocusNode,
    this.suffixIcon,
    this.validator,
    this.keyboardType,
    this.obscureText = false, this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return 
    TextFormField(
      controller: controller,
      focusNode: currentFocusNode,
      textAlign: TextAlign.center,
      textInputAction: textInputAction,
      obscureText: obscureText,
      validator: validator,
      keyboardType: keyboardType,
      style: _style,
      onEditingComplete: () {
        // if (nextFocusNode != null) {
        //   FocusScope.of(sl<NavigationService>().getContext())
        //       .requestFocus(nextFocusNode);
        // } else {
        //   FocusScope.of(sl<NavigationService>().getContext()).unfocus();
        // }
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: grey5B6163,
        hintText: hint,
        hintStyle: _style,
        suffixIcon: Icon(
          icon,
          color: greyDEDEDE,
          size: 30,
        ),
        prefixIcon: suffixIcon ??
            Icon(
              icon,
              color: Colors.transparent,
            ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(13),
          ),
        ),
      ),
    );
 
  }
}
