import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() => runApp(StaticApp());

class StaticApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xFFEC615A), // Change the primary color to red
        appBarTheme: AppBarTheme(
          elevation: 10,
          titleTextStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 24,
          ),
        ),
      ),
      home: SplashScreen(),
    );
  }
}
