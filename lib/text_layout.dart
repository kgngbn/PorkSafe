import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'What is Flora?',
          style: GoogleFonts.sassyFrass(
              fontSize: 50,
              fontWeight: FontWeight.bold,
              color: Colors.brown.shade900),
        ),
        Text(
            'Flora is an informative smartphone application that may enlighten users about the plants that grow naturally in the Philippines. Flora includes grasslands, forests, flowering and non-flowering plants and trees, and so forth.',
            style: TextStyle(fontSize: 15, color: Colors.brown.shade300)),
        Divider(),
        RichText(
          text: TextSpan(
            text: 'Mobile Application by ',
            style: TextStyle(fontSize: 11, color: Colors.brown.shade900),
            children: [
              TextSpan(
                text: 'Adrian Kate Genegaban and Clark Gabriel Paredes',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  decorationStyle: TextDecorationStyle.double,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
