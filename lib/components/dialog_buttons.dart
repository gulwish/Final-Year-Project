import 'package:flutter/material.dart';

import '/style/styling.dart';

class DialogButton extends StatelessWidget {
  final IconData? _icon;
  final String _text;
  final Function _onTap;
  const DialogButton(
    this._icon,
    this._text,
    this._onTap, {
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onPressed: _onTap as void Function()?,
      elevation: 0,
      height: 40,
      color: Styling.blueGreyFontColor,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (_icon != null)
                ? Icon(
                    _icon,
                    color: Colors.white,
                    size: 15,
                  )
                : const SizedBox.shrink(),
            Expanded(
              child: Text(
                _text,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
