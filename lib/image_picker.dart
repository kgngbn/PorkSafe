import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'app_drawer.dart'; // Importing the AppDrawer file

File? _imageFile;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(source: source);
    setState(() {
      _imageFile = pickedFile != null ? File(pickedFile.path) : null;
    });

    // Here you can add the code for scanning the image using your Python script
    // You can pass the path of the selected image to your Python script
    // and then retrieve the result from your Python script and display it
    // in the UI.
    // You can use the Process class from the dart:io library to execute
    // your Python script and retrieve its output.
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(0.5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/logo.png',
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Scan Pork to Detect Spoilage or Freshness',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _pickImage(ImageSource.gallery);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF5347D9),
                      textStyle: GoogleFonts.poppins(
                        fontSize: 14,
                      ),
                    ),
                    child: Text('Select from gallery'),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      _pickImage(ImageSource.camera);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF5347D9),
                      textStyle: GoogleFonts.poppins(
                        fontSize: 14,
                      ),
                    ),
                    child: Text('Take a photo'),
                  ),
                  SizedBox(height: 20),
                  _imageFile != null
                      ? Image.file(
                          _imageFile!,
                          width: 300,
                          height: 300,
                          fit: BoxFit.cover,
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: AppDrawer(), // Adding the AppDrawer widget to the drawer property
    );
  }
}
