import 'package:flutter/material.dart';

const brightness = Brightness.dark;
const primaryColor = const Color(0xFF00C569);
const primaryColorDark = const Color(0xFF66B489);
const accentColor = const Color(0xFF808080);
const backgroundColor = const Color(0xFFF5F5F5);

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
    errorColor: Colors.red,
    primaryColor: primaryColor,
    primaryColorDark: primaryColorDark,
    accentColor: primaryColor,
    // fontFamily: 'Montserrat',
    buttonColor: Colors.blue[400],
  );
}
