import 'package:flutter/material.dart';
import 'package:kaamsay/style/images.dart';
import 'package:lottie/lottie.dart';

class CircularProgress extends StatelessWidget {
  const CircularProgress({Key? key, this.color = Colors.white})
      : super(key: key);
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: LottieBuilder.asset(
      Images.loader,
      height: 50,
      width: 50,
    ));
  }
}
