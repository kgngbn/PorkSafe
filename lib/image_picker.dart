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

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(source: source);
    setState(() {
      _imageFile = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<void> _classifyImage() async {
    if (_imageFile == null) {
      return;
    }

    if (_isModelBusy) return;

    setState(() {
      _isLoading = true;
    });

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

      _classificationResult = 'Unknown';

      if (recognitions != null && recognitions.isNotEmpty) {
        _classificationResult = recognitions[0]['label'];
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Classification Result'),
            content: Text('The pork is $_classificationResult.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
              TextButton(
                onPressed: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
                child: Text('Choose Another Photo'),
              ),
            ],
          );
        },
      );

      if (_classificationResult == 'Spoiled') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Spoiled Pork Detected!!!'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the current dialog
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SpoiledPorkInfoPage(
                              user: widget.user!,
                              result: _classificationResult,
                              imageFile: _imageFile, // Pass the image file
                            ),
                          ),
                        );
                      },
                      child: Text('Provide Additional Info'),
                    ),
                    Text(
                      'Note: White spots on pork do not necessarily indicate spoilage but may be a sign of meat contamination. Consuming contaminated pork can lead to the development of harmful tapeworms inside the human body.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
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
          },
        );
      }
    } catch (e) {
      print('Error classifying image: $e');
    } finally {
      _isModelBusy = false;
      setState(() {
        _isLoading = false;
      });
    }
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
    return ElevatedButton(
      onPressed: _isLoading ? null : _classifyImage,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF5347D9),
        textStyle: GoogleFonts.poppins(
          fontSize: 14,
        ),
      ),
      child: _isLoading ? CircularProgressIndicator() : Text('Classify Image'),
    );
  }
}
