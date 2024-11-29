import 'package:flutter/material.dart';

import 'package:velocity_x/velocity_x.dart';

Widget buildAuthScreenButton({required String text, Color? color, Function? onPressed}) {
  return RawMaterialButton(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    onPressed: onPressed as void Function()?,
    constraints: const BoxConstraints.tightFor(height: 55),
    fillColor: color,
    elevation: 5,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
        )
      ],
    ),
  ).px(24);
}
