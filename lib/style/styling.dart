import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styling {
  Styling._();

  static const Color ksOrange = Color(0xFFFC7924);
  static const Color navyBlue = Color(0xFF49638E);
  static const Color lightBlue = Color(0xff489FB5);
  static const blueGreyFontColor = Color(0xff8A93A8);

  static final appTheme = ThemeData(
    primaryColor: const Color(0xFFFC7924),
    fontFamily: GoogleFonts.openSans().fontFamily,
    appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        iconTheme: IconThemeData(color: Colors.white)),
    colorScheme: const ColorScheme(
      primary: Color(0xFFFC7924),
      secondary: Colors.blueGrey,
      surface: Colors.white,
      background: Colors.white,
      error: Color(0xffE52D42),
      onPrimary: Colors.blueGrey,
      onSecondary: Color(0xFFFC7924),
      onSurface: Color(0xff333333),
      onBackground: Color(0xff333333),
      onError: Colors.white,
      brightness: Brightness.light,
    ).copyWith(background: Colors.white),
  );

  static const hintTextStyle = TextStyle(
    color: blueGreyFontColor,
    fontSize: 13,
  );

  static const labelStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  static final boxDecorationStyle = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8.0),
    boxShadow: const [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 1.0,
        offset: Offset(0, 2),
      )
    ],
  );
}
