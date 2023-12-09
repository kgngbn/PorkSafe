import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFAE9),
      appBar: AppBar(
        backgroundColor: Color(0xFFEC615A),
        title: Text('About',
            style: GoogleFonts.poppins(fontSize: 20, color: Colors.white)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              backgroundImage: AssetImage('assets/logo.png'),
              backgroundColor: Colors.transparent,
              radius: 50,
            ),
            SizedBox(height: 10),
            Text(
              'PorkSafe',
              style: GoogleFonts.poppins(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'by Cabrillos, Calub, Genegaban, Guinar, and Paredes',
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'This app is developed as an image processing mobile app that utilizes one of  the approaches of artificial intelligence, specifically convolutional neural networks (CNN), to identify if the pork meat is spoiled and the level of freshness that does image analysis and a camera for displaying images. The main feature of the proposed application is image processing. By capturing the pork through the mobile camera, the application can determine if the pork is spoiled and/or the level of freshness of it.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Follow us on social media:',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.facebook),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.facebook),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.facebook),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
