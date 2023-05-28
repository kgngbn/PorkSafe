import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  String _language = 'English';

  List<String> _languageOptions = ['English', 'Spanish', 'French', 'German'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFAE9),
      appBar: AppBar(
        backgroundColor: Color(0xFFEC615A),
        title: Text('Settings',
            style: GoogleFonts.poppins(fontSize: 20, color: Colors.white)),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Notifications',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Enable notifications'),
                Switch(
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Notifications are currently ${_notificationsEnabled ? 'enabled' : 'disabled'}.',
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Language',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text('Select your preferred language'),
            SizedBox(height: 10),
            DropdownButton(
              value: _language,
              onChanged: (String? newValue) {
                setState(() {
                  _language = newValue!;
                });
              },
              items: _languageOptions.map((language) {
                return DropdownMenuItem(
                  child: Text(language),
                  value: language,
                );
              }).toList(),
            ),
            SizedBox(height: 10),
            Text(
              'The current language is $_language.',
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 30),
            Text(
              'About',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Version 1.0.0',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
