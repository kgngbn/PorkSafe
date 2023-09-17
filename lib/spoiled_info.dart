import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';

class SpoiledPorkInfoPage extends StatefulWidget {
  final String result;
  final File? imageFile;

  SpoiledPorkInfoPage({required this.result, this.imageFile});

  @override
  _SpoiledPorkInfoPageState createState() => _SpoiledPorkInfoPageState();
}

class _SpoiledPorkInfoPageState extends State<SpoiledPorkInfoPage> {
  TextEditingController _descriptionController = TextEditingController();
  bool foulSmellChecked = false;
  bool slimyTextureChecked = false;
  bool discolorationChecked = false;

  final FirebaseService _firebaseService = FirebaseService();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitInfoToFirebase() {
    String additionalInfo = _descriptionController.text;

    // Use the FirebaseService to save the data
    _firebaseService.saveAdditionalInfo(additionalInfo, widget.result,
        foulSmellChecked, slimyTextureChecked, discolorationChecked);

    // Return to the previous page
    Navigator.of(context).pop();
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
        backgroundColor:
            Color(0xFFEC615A), // Set the app bar color here (EC615A)
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
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
              // Display the spoiled pork image
              if (widget.imageFile != null)
                Image.file(
                  widget.imageFile!,
                  width: 300,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              SizedBox(height: 16.0),
              Text(
                'Check the appropriate descriptions based on your pork:',
                style: GoogleFonts.poppins(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
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
                    color: Color(0xFFFED75F), // Set the label color (FED75F)
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitInfoToFirebase,
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF5347D9), // Set the button color (5347D9)
                ),
                child: Text(
                  'Submit Info',
                  style: GoogleFonts.poppins(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FirebaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.reference();

  void saveAdditionalInfo(
      String additionalInfo,
      String result,
      bool foulSmellChecked,
      bool slimyTextureChecked,
      bool discolorationChecked) {
    try {
      _database.child('spoiled_pork_info').push().set({
        "additionalInfo": additionalInfo,
        "foulSmellChecked": foulSmellChecked,
        "slimyTextureChecked": slimyTextureChecked,
        "discolorationChecked": discolorationChecked,
        "classificationResult": result,
      });
    } catch (error) {
      print('Error saving data: $error');
    }
  }
}
