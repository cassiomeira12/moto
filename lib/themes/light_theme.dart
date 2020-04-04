import 'package:flutter/material.dart';

const brightness = Brightness.light;
const primaryColor = const Color(0xFF84E8B2);
const primaryColorDark = const Color(0xFF66B489);
const accentColor = const Color(0xFF808080);
const backgroundColor = const Color(0xFFF5F5F5);

ThemeData lightTheme() {
  return ThemeData(
    scaffoldBackgroundColor: Colors.grey[100],
    backgroundColor: Colors.white,
    brightness: brightness,
    textTheme: TextTheme(
      subtitle: TextStyle(
        fontSize: 28,
        color: Colors.black45,
      ),
      body1: TextStyle(
        fontSize: 20,
        color: Colors.black45,
      ),
      body2: TextStyle(
        fontSize: 18,
        color: Colors.black45,
      ),
      button: TextStyle(
        fontSize: 14,
        color: Colors.blue,
      ),
    ),
    // tabBarTheme:
    // accentIconTheme:
    // accentTextTheme:
    // appBarTheme:
    bottomAppBarTheme: BottomAppBarTheme (
      color: Colors.white,
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
      color: Colors.black45,
    ),
    // inputDecorationTheme:
    // pageTransitionsTheme:
    // primaryIconTheme:
    // primaryTextTheme:
    // sliderTheme:
    hintColor: Colors.grey[350],
    errorColor: Colors.red,
    primaryColor: primaryColor,
    primaryColorDark: primaryColorDark,
    accentColor: accentColor,
    // fontFamily: 'Montserrat',
    buttonColor: Colors.blue[400],
  );
}
