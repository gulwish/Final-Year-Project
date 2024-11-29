import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kaamsay/style/images.dart';
import 'package:velocity_x/velocity_x.dart';

class Logo extends StatelessWidget {
  const Logo({
    Key? key,
    required this.height,
    this.backgroundColor,
    this.padding,
    this.margin,
    this.borderRadius,
  }) : super(key: key);

  final double height;
  final Color? backgroundColor;
  final double? padding;
  final double? margin;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: margin ?? 16),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(borderRadius ?? 16),
        boxShadow: kElevationToShadow[1],
      ),

      // height: 50,
      child: SvgPicture.asset(
        Images.logoVectorB,
        height: height,
      ).p(padding ?? 12),
    );
  }
}
