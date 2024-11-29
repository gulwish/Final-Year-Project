import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String buttonName;
  final Color color;
  final Color? textColor;
  final Function()? onPressed;

  const AuthButton({
    Key? key,
    required this.buttonName,
    this.color = Colors.white,
    this.textColor,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      width: double.infinity,
      child: MaterialButton(
        disabledColor: Colors.white54,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        elevation: 2.0,
        onPressed: onPressed,
        padding: const EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60),
        ),
        color: color,
        child: Text(
          buttonName,
          style: TextStyle(
            color:
                textColor ?? Theme.of(context).primaryColor,
            letterSpacing: 1.5,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }
}
