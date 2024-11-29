import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/style/styling.dart';

class PrimaryButton extends StatelessWidget {
  final String buttonText;
  final Color? color;
  final Color textColor;
  final Function()? onPressed;

  const PrimaryButton({
    Key? key,
    required this.buttonText,
    this.color = Styling.blueGreyFontColor,
    this.textColor = Colors.white,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      color: color,
      borderRadius: BorderRadius.circular(8),
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      child: Center(
        child: Text(
          buttonText,
          style: TextStyle(
            color: textColor,
          ),
        ),
      ),
    );
  }
}

class GlowingElevatedButton extends StatelessWidget {
  const GlowingElevatedButton(
      {Key? key, required this.buttonText, required this.onPressed})
      : super(key: key);

  final String buttonText;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: (onPressed == null)
                  ? [Colors.grey, Colors.grey.shade400]
                  : [
                      Colors.orange,
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor,
                    ]),
          borderRadius: BorderRadius.circular(12),
          boxShadow: onPressed == null
              ? null
              : [
                  BoxShadow(
                    offset: const Offset(3, 3),
                    color: (onPressed == null)
                        ? Colors.grey
                        : Theme.of(context).primaryColor.withOpacity(0.4),
                    blurRadius: 8,
                    spreadRadius: 0.5,
                  )
                ]),
      child: MaterialButton(
          splashColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          onPressed: onPressed,
          child: Text(buttonText,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18))),
    );
  }
}
