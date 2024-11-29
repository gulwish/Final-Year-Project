import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';

class ClayInputFieldDigitsOnly extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;

  const ClayInputFieldDigitsOnly({
    Key? key,
    this.controller,
    this.label,
    this.hintText,
    this.textInputType,
    this.textInputAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label!,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        8.heightBox,
        Container(
          height: 38,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey, width: 0.3)),
          child: Center(
            child: TextFormField(
              controller: controller,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: textInputType,
              textInputAction: textInputAction,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.all(8),
                hintText: hintText,
                hintStyle: const TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
