import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart' as places;

class ProfileScreen extends StatefulWidget {
  final User user;
  final String? newLocation;

  ProfileScreen(this.user, {this.newLocation});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFEC615A),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50.0,
                  backgroundColor:
                      Colors.blue, // Set your desired background color
                  child: Icon(
                    Icons.person, // Use any icon you prefer
                    size: 50.0,
                    color: Colors.white, // Set the icon color
                  ),
                ),
                SizedBox(height: 20),
                ListTile(
                  title: Text(
                    'Name: ${widget.user.displayName}',
                    style: GoogleFonts.poppins(),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Email: ${widget.user.email}',
                    style: GoogleFonts.poppins(),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Location: ${widget.newLocation ?? ''}', // Display the actual location here
                    style: GoogleFonts.poppins(),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateProfileScreen(widget.user),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF5347D9),
                    onPrimary: Colors.white,
                  ),
                  child: Text(
                    'Edit Profile',
                    style: GoogleFonts.poppins(),
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

class UpdateProfileScreen extends StatefulWidget {
  final User user;

  UpdateProfileScreen(this.user);

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  late String newName;
  late String newLocation;
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();

  void updateProfile(BuildContext context) async {
    try {
      // Update the user's display name and photo URL
      await widget.user.updateProfile(
        displayName: newName,
        photoURL: newLocation,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully.'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear the input fields
      _nameController.clear();
      _locationController.clear();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> selectLocation(BuildContext context) async {
    places.Prediction? prediction = await PlacesAutocomplete.show(
      context: context,
      apiKey:
          'AIzaSyAiS_L_hUXgmMJkIMgymJ0r8DAp0nvNHaw', // Replace with your Google Maps API key
      language: 'en',
      components: [places.Component(places.Component.country, 'US')],
    );

    if (prediction != null) {
      // Extract the selected place details
      places.PlacesDetailsResponse placeDetails = await places.GoogleMapsPlaces(
              apiKey: 'AIzaSyAiS_L_hUXgmMJkIMgymJ0r8DAp0nvNHaw')
          .getDetailsByPlaceId(prediction.placeId ?? '');
      String selectedLocation = placeDetails.result.formattedAddress ?? '';

      setState(() {
        newLocation = selectedLocation;
        _locationController.text = selectedLocation;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    newName = widget.user.displayName ?? '';
    newLocation = widget.user.photoURL ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Profile',
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFEC615A),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                onChanged: (value) {
                  setState(() {
                    newName = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'New Name',
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _locationController,
                      onChanged: (value) {
                        setState(() {
                          newLocation = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'New Location',
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      icon: Icon(Icons.location_on),
                      onPressed: () {
                        selectLocation(context);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  updateProfile(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF5347D9),
                  onPrimary: Colors.white,
                ),
                child: Text(
                  'Update Profile',
                  style: GoogleFonts.poppins(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
