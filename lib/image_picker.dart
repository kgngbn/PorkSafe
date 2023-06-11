import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'app_drawer.dart';

File? _imageFile;
List<dynamic>? _recognitions;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = false;
  bool _isModelBusy = false; // Flag to track interpreter busy state

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

    if (_isModelBusy) return; // Exit early if model is busy

    setState(() {
      _isLoading = true;
    });

    try {
      _isModelBusy = true; // Set the model as busy

      var recognitions = await Tflite.runModelOnImage(
        path: _imageFile!.path,
        imageMean: 0.0, // defaults to 117.0
        imageStd: 255.0, // defaults to 1.0
        numResults: 2, // Set the number of results to 2
        threshold: 0.2, // defaults to 0.1
        asynch: true,
      );

      String result = 'Unknown';

      if (recognitions != null && recognitions.isNotEmpty) {
        result = recognitions[0]['label'];
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Classification Result'),
            content: Text('The pork is $result.'),
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

      if (result == 'Spoiled') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Spoiled Pork Detected!!!'),
              content: Text('Please report this to the authorities.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error classifying image: $e');
    } finally {
      _isModelBusy = false; // Set the model as not busy
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFAE9),
      appBar: AppBar(
        backgroundColor: Color(0xFFEC615A),
        title: Text(
          'PorkSafe',
          style: GoogleFonts.poppins(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
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
                  _imageFile != null
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
                        ),
                  SizedBox(height: 10),
                  Text(
                    'Scan Pork to Detect Spoilage or Freshness',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
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
                  ElevatedButton(
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
    );
  }
}
