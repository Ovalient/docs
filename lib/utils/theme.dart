import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle listTitleDefaultTextStyle =
    TextStyle(color: Colors.white70, fontSize: 20.0);
TextStyle listTitleEmailTextStyle =
    TextStyle(color: Colors.white70, fontSize: 13.0);
TextStyle listTitleSelectedTextStyle =
    TextStyle(color: Colors.white, fontSize: 20.0);

Color selectedColor = Color(0xFF4AC8EA);
Color drawerBackgroundColor = Color(0xFF272D34);

final mainTheme = ThemeData(
  textTheme: GoogleFonts.notoSansTextTheme(),
  primarySwatch: Colors.blueGrey,
  backgroundColor: Colors.white,
  cardColor: Colors.blueGrey[50],
  primaryTextTheme: TextTheme(
    button: TextStyle(
      color: Colors.blueGrey,
      decorationColor: Colors.blueGrey[300],
    ),
    subtitle2: TextStyle(
      color: Colors.blueGrey[900],
    ),
    subtitle1: TextStyle(
      color: Colors.black,
    ),
    headline1: TextStyle(color: Colors.blueGrey[800]),
  ),
  appBarTheme: AppBarTheme(backgroundColor: Color(0xF2404B60)),
  bottomAppBarColor: Colors.blueGrey[900],
  iconTheme: IconThemeData(color: Colors.blueGrey),
);
