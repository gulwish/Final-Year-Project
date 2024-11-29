import 'package:flutter/material.dart';

import 'package:velocity_x/velocity_x.dart';

class ProfileButton extends StatelessWidget {
  final String buttonText;
  final Color color;
  final Color textColor;
  final Function? onPressed;

  const ProfileButton({
    Key? key,
    required this.buttonText,
    required this.color,
    this.textColor = Colors.white,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      height: 40,
      color: color,
      elevation: 0,
      onPressed: onPressed as void Function()?,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            buttonText,
            style: TextStyle(color: textColor, fontSize: 17),
          ).py(8),
        ],
      ),
    ).px(16);
  }
}
