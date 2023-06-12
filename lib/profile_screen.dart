import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatelessWidget {
  final User user;

  ProfilePage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFAE9), // Set the background color
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person,
              size: 100,
            ),
            SizedBox(height: 20),
            Text(
              'Email: ${user.email}',
              style: GoogleFonts.poppins(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangePasswordScreen(user),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF5347D9),
                onPrimary: Colors.white, // Set the foreground color
              ),
              child: Text(
                'Change Password',
                style: GoogleFonts.poppins(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChangePasswordScreen extends StatefulWidget {
  final User user;

  ChangePasswordScreen(this.user);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late String currentPassword; // Make it non-nullable
  late String newPassword; // Make it non-nullable
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  void changePassword(BuildContext context) async {
    try {
      // Reauthenticate the user with the current password
      AuthCredential credential = EmailAuthProvider.credential(
        email: widget.user.email!,
        password: currentPassword,
      );
      await widget.user.reauthenticateWithCredential(credential);

      // Update the password with the new password
      await widget.user.updatePassword(newPassword);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password updated successfully.'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear the password fields
      _currentPasswordController.clear();
      _newPasswordController.clear();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update password.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    currentPassword = '';
    newPassword = '';
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Change Password',
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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _currentPasswordController,
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  currentPassword = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Current Password',
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _newPasswordController,
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  newPassword = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'New Password',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                changePassword(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF5347D9),
                onPrimary: Colors.white, // Set the foreground color
              ),
              child: Text(
                'Update Password',
                style: GoogleFonts.poppins(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
