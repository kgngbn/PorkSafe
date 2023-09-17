import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SpoiledPorkInfoPage extends StatefulWidget {
  final String result;
  final File? imageFile; // Add this line

  SpoiledPorkInfoPage({required this.result, this.imageFile}); // Add this line

  @override
  _SpoiledPorkInfoPageState createState() => _SpoiledPorkInfoPageState();
}

class _SpoiledPorkInfoPageState extends State<SpoiledPorkInfoPage> {
  TextEditingController _descriptionController = TextEditingController();
  bool foulSmellChecked = false;
  bool slimyTextureChecked = false;
  bool discolorationChecked = false;
  bool? reportSent; // Initialize as null

  final FirebaseService _firebaseService = FirebaseService();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitInfoToFirebase() async {
    String additionalInfo = _descriptionController.text;

    try {
      await _firebaseService.saveAdditionalInfo(
        additionalInfo,
        widget.result,
        foulSmellChecked,
        slimyTextureChecked,
        discolorationChecked,
      );
      // Report sent successfully
      setState(() {
        reportSent = true;
      });
    } catch (error) {
      // Report failed to send
      print('Error saving data: $error');
      setState(() {
        reportSent = false;
      });
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
        // Center the content
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center vertically
              children: [
                // Display the classification result
                Text(
                  'Classification Result: ${widget.result}',
                  style: GoogleFonts.poppins(
                    fontSize: 18.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  reportSent == null
                      ? 'Check the appropriate descriptions based on your pork:'
                      : reportSent!
                          ? 'Report sent successfully!'
                          : 'Failed to send the report. Please try again later.',
                  style: GoogleFonts.poppins(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
                if (widget.imageFile != null) // Display the chosen image
                  Image.file(
                    widget.imageFile!,
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  )
                else // Display a default image if no image is chosen
                  Image.asset(
                    'assets/default_image.png', // Provide a default image asset path
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
                          'Discoloration (light pink is recommended for fresh pork)',
                          style: GoogleFonts.poppins(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                        value: discolorationChecked,
                        onChanged: (value) {
                          setState(() {
                            discolorationChecked = value!;
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
      bool discolorationChecked) async {
    try {
      await _spoiledPorkCollection.add({
        "additionalInfo": additionalInfo,
        "foulSmellChecked": foulSmellChecked,
        "slimyTextureChecked": slimyTextureChecked,
        "discolorationChecked": discolorationChecked,
        "classificationResult": result,
      });
    } catch (error) {
      print('Error saving data: $error');
      throw error; // Propagate the error to handle it in the UI
    }
  }
}
