import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout/profile_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_drawer.dart';
import 'login_screen.dart';
import 'spoiled_info.dart';

class MyHomePage extends StatefulWidget {
  final User? user;

  MyHomePage({required this.user});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _imageFile;
  bool _isLoading = false;
  bool _isModelBusy = false;
  String _classificationResult = 'Unknown';

  bool _isImageSelected =
      false; // Add a variable to track whether an image is selected

  // Function to handle image selection
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(source: source);
    setState(() {
      _imageFile = pickedFile != null ? File(pickedFile.path) : null;
      _isImageSelected = _imageFile != null; // Update _isImageSelected
    });
  }

  Future<void> _classifyImage() async {
    if (_imageFile == null) {
      return;
    }

    if (_isModelBusy) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Loading...'),
            ],
          ),
        );
      },
    );

    try {
      _isModelBusy = true;

      var recognitions = await Tflite.runModelOnImage(
        path: _imageFile!.path,
        imageMean: 0.0,
        imageStd: 255.0,
        numResults: 2,
        threshold: 0.2,
        asynch: true,
      );

      Navigator.of(context).pop(); // Close the loading dialog

      _classificationResult = 'Unknown';

      if (recognitions != null && recognitions.isNotEmpty) {
        _classificationResult = recognitions[0]['label'];
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          if (!_isExpectedLabel(_classificationResult)) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.warning,
                    color: Colors.red,
                    size: 100,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Photo does not match the trained model!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Please try again with a different photo.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          } else {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Column(
                    children: [
                      Icon(
                        _classificationResult == 'Spoiled'
                            ? Icons.warning
                            : Icons.check_circle,
                        color: _classificationResult == 'Spoiled'
                            ? Colors.red
                            : Colors.green,
                        size: 100,
                      ),
                      SizedBox(height: 10),
                      Text(
                        _classificationResult == 'Spoiled'
                            ? 'Spoiled Pork Detected!!!'
                            : 'Fresh Pork Detected!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  if (_classificationResult == 'Spoiled')
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(
                              2), // Add padding around the button
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(
                                30), // Change border radius
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(); // Close the current dialog
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => SpoiledPorkInfoPage(
                                    user: widget.user!,
                                    result: _classificationResult,
                                    imageFile:
                                        _imageFile, // Pass the image file
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors
                                  .transparent, // Set the button background color as transparent
                              elevation: 0, // Remove button elevation
                            ),
                            child: Text(
                              'Report to Authorities', // Change button text here
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 10),
                  Text(
                    'Note: White spots on pork do not necessarily indicate spoilage but may be a sign of meat contamination. Consuming contaminated pork can lead to the development of harmful tapeworms inside the human body.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  if (_classificationResult != 'Spoiled') SizedBox(height: 10),
                  if (_classificationResult != 'Spoiled')
                    Text(
                      'Fresh Pork is Safe to Consume!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
              ],
            );
          }
        },
      );
    } catch (e) {
      print('Error classifying image: $e');
    } finally {
      _isModelBusy = false;
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _isExpectedLabel(String label) {
    // Replace ['ExpectedLabel'] with your actual expected labels
    List<String> expectedLabels = ['Spoiled', 'Fresh', 'Not Identified'];
    return expectedLabels.contains(label);
  }

  void loadModel() async {
    await Tflite.loadModel(
      model: 'assets/tflite_model.tflite',
      labels: 'assets/labels.txt',
    );
  }

  @override
  void initState() {
    loadModel();
    super.initState();
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  void logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
      (route) => false,
    );
  }

  void goToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UpdateProfileScreen(widget.user!)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFAE9),
      appBar: buildAppBar(context),
      body: buildBody(),
      drawer: AppDrawer(widget.user, onProfileSelected: goToProfile),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFFEC615A),
      title: Text(
        'PorkSafe',
        style: GoogleFonts.poppins(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: <Widget>[
        buildLogoutButton(context),
      ],
    );
  }

  Widget buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: IconButton(
        icon: Icon(Icons.logout),
        onPressed: () => logout(context),
      ),
    );
  }

  Widget buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(0.5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildImage(),
                SizedBox(height: 10),
                buildScanText(),
                SizedBox(height: 20),
                buildImageButton(
                    "Select from gallery", ImageSource.gallery, Icons.image),
                SizedBox(height: 10),
                buildImageButton(
                    "Take a photo", ImageSource.camera, Icons.camera_alt),
                SizedBox(height: 20),
                buildClassifyButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildImage() {
    return _imageFile != null
        ? Image.file(
            _imageFile!,
            width: 300,
            height: 300,
            fit: BoxFit.cover,
          )
        : Image.asset(
            'assets/logo.png',
            height: 200,
            fit: BoxFit.contain,
          );
  }

  Widget buildScanText() {
    return Text(
      'Scan Pork to Detect Spoilage or Freshness',
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget buildImageButton(String text, ImageSource source, IconData iconData) {
    return ConstrainedBox(
      constraints:
          BoxConstraints(maxWidth: 200), // Set the maximum width as needed
      child: ElevatedButton(
        onPressed: () {
          _pickImage(source);
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Color(0xFF5347D9),
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData),
            SizedBox(width: 8),
            Text(text),
          ],
        ),
      ),
    );
  }

  Widget buildClassifyButton() {
    return _isImageSelected // Only show the button if an image is selected
        ? ElevatedButton(
            onPressed: _isLoading ? null : _classifyImage,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Color(0xFF5347D9),
              textStyle: GoogleFonts.poppins(
                fontSize: 14,
              ),
            ),
            child: _isLoading
                ? CircularProgressIndicator()
                : Text('Classify Image'),
          )
        : Container(); // Placeholder empty container if no image is selected
  }
}
