import 'package:flutter/material.dart';

import '/style/styling.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final IconData? icon;
  final bool obscureText;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;

  const TextInputField({
    Key? key,
    this.controller,
    this.label,
    this.hintText,
    this.icon,
    this.obscureText = false,
    this.textInputType,
    this.textInputAction,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label!,
            style: Styling.labelStyle,
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: Styling.boxDecorationStyle,
          height: 43.0,
          child: TextFormField(
            controller: controller,
            keyboardType: textInputType,
            textInputAction: textInputAction,
            obscureText: obscureText,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(top: 8),
              border: InputBorder.none,
              prefixIcon: Icon(
                icon,
                size: 22,
                color: Theme.of(context).primaryColor,
              ),
              hintText: hintText,
              hintStyle: Styling.hintTextStyle,
            ),
          ),
        ),
      ],
    );
  }
}
