import 'package:flutter/material.dart';

final appThemeData = ThemeData(
  //***    Main Colors    ***//
  primaryColor: Color.fromRGBO(229, 40, 40, 1),
  primaryColorLight: const Color(0xE84848),
  scaffoldBackgroundColor: const Color(0xFFFFFFFF),
  canvasColor: Color.fromRGBO(235, 66, 66, 0.6),

  //***    Text    ***//
  textTheme: TextTheme(
    //  default [Buttons] && salon's [name] in card
    bodyText2: TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w500,
      fontSize: 15.0,
    ),
    //  Big [Buttons]
    headline1: TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w500,
      fontSize: 22.0,
    ),
    //salon's [address] in card
    headline2: TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w300,
      fontSize: 12,
    ),
    //  [TextField]
    headline3: TextStyle(
      fontFamily: 'Roboto',
      color: const Color(0xFF383838),
      fontWeight: FontWeight.w500,
      fontSize: 17.0,
    ),
    //  Some headlines —> Profile screen
    headline4: TextStyle(
      fontFamily: 'Roboto',
      color: const Color(0xFF383838),
      fontWeight: FontWeight.w500,
      fontSize: 22.0,
    ),
    // small buttons
    headline5: TextStyle(
      fontFamily: 'Roboto',
      color: const Color(0xFFFFFFFF),
      fontWeight: FontWeight.w500,
      fontSize: 15.0,
    ),
    //  some text fields —> Profile screen
    subtitle2: TextStyle(
      fontFamily: 'Roboto',
      color: const Color(0xFF383838),
      fontWeight: FontWeight.w400,
      fontSize: 17.0,
    ),
    headline6: TextStyle(
      fontFamily: 'Helvetica',
      color: const Color(0xFF383838),
      fontWeight: FontWeight.w500,
      fontSize: 26.0,
      height: 1.5,
    ),
    //  Location name —> Salons screen
    subtitle1: TextStyle(
      fontFamily: 'Roboto',
      color: const Color(0xFF383838),
      fontWeight: FontWeight.w700,
      fontSize: 18.0,
    ),
    //  light captions /titles —> Salons screen
    caption: TextStyle(
      fontFamily: 'Roboto',
      color: const Color(0xFF383838),
      fontWeight: FontWeight.w400,
      fontSize: 13.0,
    ),
  ),

  //***    Text Field   ***//
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: TextStyle(
      fontFamily: 'Roboto',
      color: const Color(0xFF333333),
      fontWeight: FontWeight.w300,
      fontSize: 15.0,
    ),
    border: UnderlineInputBorder(
      borderSide: BorderSide(
        width: 1.0,
        color: const Color(0xFFAEAEAE),
      ),
    ),
  ),
);
