import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout/profile_screen.dart';
import 'package:flutter_layout/settings.dart';
import 'about.dart';
import 'image_picker.dart';
import 'login_screen.dart';

class AppDrawer extends StatelessWidget {
  final User? user;

  AppDrawer(this.user);

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      print('Failed to log out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: user != null ? Text(user!.displayName ?? '') : null,
              accountEmail: user != null ? Text(user!.email ?? '') : null,
              currentAccountPicture: CircleAvatar(
                child: Icon(Icons.person),
                backgroundColor: Colors
                    .transparent, // Set the background color to transparent
              ),
              decoration: BoxDecoration(
                color: Color(0xFFEC615A),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings_outlined),
              title: Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
            if (user != null)
              Column(
                children: [
                  Divider(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfilePage(user!)),
                      );
                    },
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Profile'),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Logout'),
                    onTap: () => _logout(context),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
