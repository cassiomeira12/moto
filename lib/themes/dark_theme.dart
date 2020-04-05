import 'package:flutter/material.dart';

const brightness = Brightness.dark;

const primaryColor = const Color(0xFF00796B);
const primaryColorDark = const Color(0xFF004D40);
const accentColor = const Color(0xFFFCA639);

const backgroundColor = const Color(0xFFF5F5F5);
const errorColor = Colors.redAccent;

ThemeData darkTheme() {
  return ThemeData(
    scaffoldBackgroundColor: Colors.grey[800],
    backgroundColor: Colors.grey[700],
    brightness: brightness,
    textTheme: TextTheme(
      subtitle: TextStyle(
        fontSize: 28,
        color: Colors.white,
      ),
      body1: TextStyle(
          fontSize: 20,
          color: Colors.white,
      ),
      body2: TextStyle(
        fontSize: 18,
        color: Colors.white70,
      ),
      button: TextStyle(
        fontSize: 14,
        color: Colors.white,
      ),
      display1: TextStyle(
        fontSize: 18,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      display2: TextStyle(
        fontSize: 12,
        color: Colors.white,
      ),
    ),
    // tabBarTheme:
    // accentIconTheme:
    // accentTextTheme:
    // appBarTheme:
    bottomAppBarTheme: BottomAppBarTheme (
      color: Colors.grey[700],
      elevation: 5,
    ),
    // buttonTheme: new ButtonThemeData(
    //   buttonColor: Colors.orange,
    //   textTheme: ButtonTextTheme.primary,
    // ),
    // cardTheme: CardTheme(
    //   elevation: 5,
    //   color: Colors.indigo,
    // ),
    // chipTheme:
    // dialogTheme:
    // floatingActionButtonTheme:
    iconTheme: IconThemeData(
        color: Colors.white70,
    ),
    // inputDecorationTheme:
    // pageTransitionsTheme:
    // primaryIconTheme:
    // primaryTextTheme:
    // sliderTheme:
    hintColor: Colors.white30,
    errorColor: errorColor,
    primaryColor: primaryColor,
    primaryColorDark: primaryColorDark,
    accentColor: accentColor,
    // fontFamily: 'Montserrat',
    buttonColor: Colors.blue[500],
  );
}
