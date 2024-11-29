import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class DrawerrButton extends StatelessWidget {
  const DrawerrButton({this.icon, this.onTap, this.text, Key? key})
      : super(key: key);

  //IconData icon, String text, Function onTap
  final IconData? icon;
  final String? text;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
            height: 35,
            width: 35,
            child: Icon(
              icon,
              color: Colors.white,
            ).p(7)),
        MaterialButton(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          onPressed: onTap as void Function()?,
          child: Text(text!, style: dashboardButtonText),
        ),
      ],
    );
  }
}

TextStyle dashboardButtonText =
    const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white);
