import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

Flushbar showFailureDialog(BuildContext context, String errorText) {
  return Flushbar(
    titleText: const Text(
      'ERROR',
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    messageText: Text(
      errorText,
      style: const TextStyle(color: Colors.white),
    ),
    duration: const Duration(seconds: 3),
    flushbarPosition: FlushbarPosition.TOP,
    flushbarStyle: FlushbarStyle.FLOATING,
    reverseAnimationCurve: Curves.decelerate,
    forwardAnimationCurve: Curves.elasticOut,
    backgroundColor: Colors.red.shade400,
    margin: const EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(12),
    boxShadows: const [
      BoxShadow(
          color: Colors.black26, offset: Offset(2.0, 2.0), blurRadius: 3.0)
    ],
    backgroundGradient: LinearGradient(colors: [Colors.red, Colors.red[500]!]),
    icon: const Icon(
      Icons.error,
      color: Colors.white,
    ),
  );
}

Flushbar showSuccessDialog(BuildContext context, String successText) {
  return Flushbar(
    titleText: const Text(
      'SUCCESS',
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    messageText: Text(
      successText,
      style: const TextStyle(color: Colors.white),
    ),
    duration: const Duration(seconds: 3),
    flushbarPosition: FlushbarPosition.TOP,
    flushbarStyle: FlushbarStyle.FLOATING,
    reverseAnimationCurve: Curves.decelerate,
    forwardAnimationCurve: Curves.elasticOut,
    backgroundColor: Colors.green,
    margin: const EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(12),
    boxShadows: const [
      BoxShadow(
          color: Colors.black26, offset: Offset(2.0, 2.0), blurRadius: 3.0)
    ],
    backgroundGradient:
        LinearGradient(colors: [Colors.green, Colors.green[500]!]),
    icon: const Icon(
      Icons.error,
      color: Colors.white,
    ),
  );
}
