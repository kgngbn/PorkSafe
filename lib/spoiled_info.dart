import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class SpoiledPorkInfoPage extends StatefulWidget {
  final User? user;
  final String result;
  final File? imageFile;

  SpoiledPorkInfoPage({
    required this.result,
    this.user,
    this.imageFile,
  });

  @override
  _SpoiledPorkInfoPageState createState() => _SpoiledPorkInfoPageState();

  void clearStateCallback() {}
}

class _SpoiledPorkInfoPageState extends State<SpoiledPorkInfoPage> {
  TextEditingController _descriptionController = TextEditingController();
  bool foulSmellChecked = false;
  bool slimyTextureChecked = false;
  bool? reportSent;

  // New fields for choices
  bool frozenChecked = false;
  bool indoorChecked = false;
  TextEditingController _locationNameController = TextEditingController();

  final FirebaseService _firebaseService = FirebaseService();

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationNameController.dispose();
    super.dispose();
  }

  Future<String?> _uploadImageToStorage(File imageFile) async {
    try {
      final firebase_storage.Reference storageRef =
          firebase_storage.FirebaseStorage.instance.ref();

      final imageFileName =
          'images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final uploadTask = storageRef.child(imageFileName).putFile(imageFile);

      final snapshot = await uploadTask;
      final downloadURL = await snapshot.ref.getDownloadURL();

      return downloadURL;
    } catch (error) {
      print('Error uploading image: $error');
      return null;
    }
  }

  void _submitInfoToFirebase() async {
    String additionalInfo = _descriptionController.text;

    // Request location permission
    final PermissionStatus permissionStatus =
        await Permission.location.request();

    if (permissionStatus.isGranted) {
      try {
        final imageUrl = await _uploadImageToStorage(widget.imageFile!);

        // Get the user's current location
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        // Save the user's location along with other data
        await _firebaseService.saveAdditionalInfo(
          additionalInfo,
          widget.result,
          foulSmellChecked,
          slimyTextureChecked,
          frozenChecked,
          indoorChecked,
          imageUrl,
          widget.user?.displayName ?? '',
          widget.user?.email ?? '',
          position.latitude,
          position.longitude,
        );

        setState(() {
          reportSent = true;
        });
      } catch (error) {
        print('Error saving data: $error');
        setState(() {
          reportSent = false;
        });
      }
    } else {
      // Handle permission denied
      print('Location permission denied');
      // You can display a message or take appropriate action here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Spoiled Pork Info',
          style: GoogleFonts.poppins(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFFEC615A),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Classification Result: ${widget.result}',
                  style: GoogleFonts.poppins(
                    fontSize: 18.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (widget.imageFile != null)
                  Image.file(
                    widget.imageFile!,
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  )
                else
                  Image.asset(
                    'assets/default_image.png',
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                if (reportSent == null)
                  Column(
                    children: [
                      CheckboxListTile(
                        title: Text(
                          'Foul smell',
                          style: GoogleFonts.poppins(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                        value: foulSmellChecked,
                        onChanged: (value) {
                          setState(() {
                            foulSmellChecked = value!;
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: Text(
                          'Slimy texture',
                          style: GoogleFonts.poppins(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                        value: slimyTextureChecked,
                        onChanged: (value) {
                          setState(() {
                            slimyTextureChecked = value!;
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: Text(
                          'Frozen',
                          style: GoogleFonts.poppins(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                        value: frozenChecked,
                        onChanged: (value) {
                          setState(() {
                            frozenChecked = value!;
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: Text(
                          'Did you Buy it Indoor?',
                          style: GoogleFonts.poppins(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                        value: indoorChecked,
                        onChanged: (value) {
                          setState(() {
                            indoorChecked = value!;
                          });
                        },
                      ),
                      SizedBox(height: 16.0),
                      TextField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Additional Details',
                          border: OutlineInputBorder(),
                          labelStyle: GoogleFonts.poppins(
                            fontSize: 16.0,
                            color: Color(0xFFFED75F),
                          ),
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: reportSent == null ? _submitInfoToFirebase : null,
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF5347D9),
                  ),
                  child: Text(
                    'Submit Info',
                    style: GoogleFonts.poppins(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (reportSent == false) SizedBox(height: 16.0),
                if (reportSent != null)
                  Text(
                    reportSent!
                        ? 'Report sent successfully!'
                        : 'Failed to send the report. Please try again later.',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: reportSent! ? Colors.green : Colors.red,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FirebaseService {
  final CollectionReference _spoiledPorkCollection =
      FirebaseFirestore.instance.collection('spoiled_pork_info');

  Future<void> saveAdditionalInfo(
    String additionalInfo,
    String result,
    bool foulSmellChecked,
    bool slimyTextureChecked,
    bool frozenChecked,
    bool indoorChecked,
    String? imageUrl,
    String displayName,
    String email,
    double latitude,
    double longitude,
  ) async {
    try {
      await _spoiledPorkCollection.add({
        "additionalInfo": additionalInfo,
        "foulSmellChecked": foulSmellChecked,
        "slimyTextureChecked": slimyTextureChecked,
        "frozenChecked": frozenChecked,
        "indoorChecked": indoorChecked,
        "classificationResult": result,
        "imageUrl": imageUrl,
        "displayName": displayName,
        "email": email,
        "latitude": latitude,
        "longitude": longitude,
        // "locationName": locationName, // Remove this line
      });
    } catch (error) {
      print('Error saving data: $error');
      throw error;
    }
  }
}
