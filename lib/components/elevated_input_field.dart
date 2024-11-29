import 'package:flutter/material.dart';

class ElevatedInputField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final bool? autofocus;
  final IconData? icon;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;

  const ElevatedInputField({
    Key? key,
    this.hintText,
    this.controller,
    this.autofocus,
    this.icon,
    this.textInputType,
    this.textInputAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        alignment: Alignment.centerLeft,
        child: TextFormField(
          controller: controller,
          keyboardType: textInputType,
          textInputAction: textInputAction,
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding:
                const EdgeInsets.only(left: 12, right: 12, top: 14, bottom: 14),
            border: InputBorder.none,
            prefixIcon: Icon(
              icon,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
