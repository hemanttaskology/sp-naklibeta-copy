import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      primaryColor: HexColor('#ff561D5E'),
      accentColor: HexColor('#ffF6C604'),
      appBarTheme: AppBarTheme(
          backgroundColor: HexColor('#ffF6C604'),
          // This will be applied to the "back" icon
          iconTheme: IconThemeData(color: HexColor('#ff561D5E')),
          // This will be applied to the action icon buttons that locates on the right side
          actionsIconTheme: IconThemeData(color: HexColor('#ff561D5E')),
          centerTitle: false,
          elevation: 10,
          titleTextStyle: TextStyle(
              color: HexColor('#ff561D5E'),
              fontSize: 18,
              fontWeight: FontWeight.bold)),
      // accentColor: Colors.amber.shade500,
      buttonColor: Colors.blue.shade500,
      cardColor: Colors.grey.shade100,
      disabledColor: Colors.grey.shade500,
      fontFamily: 'Source Sans Pro',
      //Theme.of(context).textTheme.headline5
      textTheme: TextTheme(
        headline5: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Source Sans Pro'),
      ),
      buttonTheme: ButtonThemeData(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
        buttonColor: HexColor('#ff561D5E'),
      ),
    );
  }
}
