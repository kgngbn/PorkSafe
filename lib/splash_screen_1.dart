import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_layout/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class SplashScreen1 extends StatefulWidget {
  @override
  State<SplashScreen1> createState() => _SplashScreen1();
}

class _SplashScreen1 extends State<SplashScreen1> {
  var _time;
  start() {
    _time = Timer(Duration(seconds: 6), call);
  }

  void call() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (content) => MyHomePage(),
        ));
  }

  @override
  void initState() {
    start();
    super.initState();
  }

  @override
  void dispose() {
    _time.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFAE9),
      appBar: AppBar(
        backgroundColor: Color(0xFFEC615A),
        title: Text('PORKIFIER',
            style: GoogleFonts.poppins(fontSize: 20, color: Colors.white)),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(Icons.edit),
          ),
        ],
      ),
      body: Center(child: Lottie.network('https://lottiefiles.com/72254-meat')),
    );
  }
}
